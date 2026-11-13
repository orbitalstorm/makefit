import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../data/makefit_catalog.dart';
import '../models/makefit_models.dart';

/// Moteur mathématique, biomécanique et comportemental MakeFit (`v1.0.0`).
/// Implémente :
/// - Le Test PT Initial de 6 min (IAO sur 100 & attribution d'échelons Tier 1..5),
/// - L'Algorithme d'Auto-Régulation RPE (1 à 5), la progression/régression d'échelons
///   et l'Index Postural Push/Pull (`[0.85, 1.15]`) avec injection corrective anti-cyphose,
/// - Le Calculateur déterministe de TXP, l'XP Banking & les 12 Grades Militaires (`E-1` à `SF-2`),
/// - La Machine à états 60 Hz de séance résiliente aux dérives d'horloge (`Stopwatch` monotone
///   + synchronisation `DateTime.now()`), le filtre Sans Contact anti-rebond `650 ms`
///   et l'Audio Ducking (`-12 dB`) respectant Spotify/Apple Music.
class MakeFitEngine extends ChangeNotifier {
  MakeFitEngine({SoldierProfileState? initialProfile})
    : _profile = initialProfile ?? createDefaultSoldierProfile();

  /// Fenêtre biomécanique minimale anti-rebond entre deux répétitions sans contact.
  static const int contactlessDebounceMs = 650;

  SoldierProfileState _profile;
  SoldierProfileState get profile => _profile;

  final ValueNotifier<WorkoutLiveSnapshot?> liveWorkoutNotifier =
      ValueNotifier<WorkoutLiveSnapshot?>(null);

  /// Horloge monotone insensible aux changements d'heure système / NTP.
  final Stopwatch _monotonicSessionWatch = Stopwatch();
  final Stopwatch _contactlessDebounceWatch = Stopwatch();

  /// Horodatages muraux (`DateTime.now()`) pour la reprise après mise en veille OS.
  DateTime? _lastContactlessRepTimestamp;
  DateTime? _lastWallClockTickAt;

  static SoldierProfileState createDefaultSoldierProfile() {
    return const SoldierProfileState(
      callsign: 'ALPHA-01',
      rank: MilitaryRank.e2Private,
      totalTxp: 1650,
      currentStreakDays: 8,
      bestStreakDays: 14,
      tacticalLeavePasses: 2,
      sessionsTowardsNextPass: 1,
      completedSessionsCount: 8,
      stealthApartmentMode: false,
      jointFriendlyMode: JointFriendlyMode.standard,
      familyTiers: <BiomechanicalFamily, DifficultyTier>{
        BiomechanicalFamily.upperPush: DifficultyTier.tier2Soldier,
        BiomechanicalFamily.noBarPull: DifficultyTier.tier2Soldier,
        BiomechanicalFamily.tacticalLegs: DifficultyTier.tier2Soldier,
        BiomechanicalFamily.ironCore: DifficultyTier.tier2Soldier,
        BiomechanicalFamily.metCon: DifficultyTier.tier2Soldier,
      },
      familyRepQuotas: <BiomechanicalFamily, int>{
        BiomechanicalFamily.upperPush: 15,
        BiomechanicalFamily.noBarPull: 16,
        BiomechanicalFamily.tacticalLegs: 20,
        BiomechanicalFamily.ironCore: 20,
        BiomechanicalFamily.metCon: 25,
      },
      completedMissionIds: <String>{
        'op-01_d1',
        'op-01_d2',
        'op-01_d3',
        'op-01_d4',
        'op-01_d5',
        'op-01_d6',
        'op-01_d7',
        'op-01_d8',
      },
      passedTrialRanks: <MilitaryRank>{},
      weeklyFamilyVolumes: <BiomechanicalFamily, int>{
        BiomechanicalFamily.upperPush: 180,
        BiomechanicalFamily.noBarPull: 185,
        BiomechanicalFamily.tacticalLegs: 240,
        BiomechanicalFamily.ironCore: 210,
        BiomechanicalFamily.metCon: 195,
      },
      lastRpeScore: 3,
      iaoCalibrationScore: 44,
      medicalDisclaimerAccepted: true,
      activeCampaignId: OperationalCampaignId.op1BasicBootcamp,
      currentCampaignDay: 9,
      activityHeatmap28Days: <int>[
        2, 3, 2, 1, 3, 2, 1,
        3, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0,
      ],
    );
  }

  /// Ratio d'équilibre postural Push / Pull sur 7 jours (cible optimale : `0.85` à `1.15`).
  double get posturalBalanceRatio => _profile.posturalBalanceRatio;

  /// Indique si le volume de tirage au sol est déficitaire par rapport à la poussée (`< 0.85`).
  bool get hasPosturalPullDeficit => _profile.posturalBalanceRatio < 0.85;

  /// Indique si l'équilibre scapulaire hebdomadaire est dans la fenêtre optimale `[0.85, 1.15]`.
  bool get isPosturalBalanceOptimal {
    final double r = _profile.posturalBalanceRatio;
    return r >= 0.85 && r <= 1.15;
  }

  /// Diagnostic lisible de l'équilibre postural Push / Pull.
  String get posturalDiagnosticLabel {
    final double r = _profile.posturalBalanceRatio;
    if (r < 0.85) {
      return 'DÉFICIT TIRAGE (${r.toStringAsFixed(2)}) • +1 SÉRIE SCAPULA AUTO-INJECTÉE';
    }
    if (r > 1.15) {
      return 'DOMINANTE CHAÎNE POSTÉRIEURE (${r.toStringAsFixed(2)}) • ÉPAULES PROTÉGÉES';
    }
    return 'ÉQUILIBRE SCAPULAIRE OPTIMAL (${r.toStringAsFixed(2)} • CIBLE 1:1)';
  }

  /// Indique si le capteur Sans Contact est prêt à accepter une nouvelle répétition (`≥ 650 ms`).
  bool get isContactlessReady {
    if (_contactlessDebounceWatch.isRunning &&
        _contactlessDebounceWatch.elapsedMilliseconds < contactlessDebounceMs) {
      return false;
    }
    final DateTime? last = _lastContactlessRepTimestamp;
    if (last != null) {
      final int wallMs = DateTime.now().difference(last).inMilliseconds;
      if (wallMs >= 0 && wallMs < contactlessDebounceMs) {
        return false;
      }
    }
    return true;
  }

  /// Mission quotidienne recommandée (1-Clic depuis le Command Center), personnalisée
  /// selon les quotas RPE, les échelons par famille et le ratio postural Push/Pull.
  TacticalMission get todayRecommendedMission {
    final int restBuffer = _profile.lastRpeScore >= 5
        ? 15
        : (_profile.lastRpeScore == 4 ? 5 : 0);
    final List<TacticalMission> missions = MakeFitCatalog.missionsForCampaign(
      _profile.activeCampaignId,
      _profile.familyRepQuotas,
      posturalBalanceRatio: _profile.posturalBalanceRatio,
      extraRestSeconds: restBuffer,
    );
    final int idx = (_profile.currentCampaignDay - 1).clamp(
      0,
      missions.length - 1,
    );
    return missions[idx];
  }

  /// Catalogue des 5 formats rapides "Zero-Friction" personnalisés à l'état actuel du soldat.
  List<TacticalMission> get personalizedQuickMissions =>
      MakeFitCatalog.buildQuickFormatMissions(_profile);

  /// Génère à la demande une séance personnalisée (durée, format, focus biomécanique).
  TacticalMission generatePersonalizedMission({
    required WorkoutFormatType format,
    int? durationMinutes,
    BiomechanicalFamily? focusFamily,
  }) {
    return MakeFitCatalog.buildPersonalizedMission(
      profile: _profile,
      format: format,
      durationMinutes: durationMinutes,
      focusFamily: focusFamily,
    );
  }

  /// Bascule instantanée du Mode Silencieux Appartement (0 saut, < 35 dB).
  void toggleStealthApartmentMode([bool? enabled]) {
    final bool next = enabled ?? !_profile.stealthApartmentMode;
    _profile = _profile.copyWith(stealthApartmentMode: next);
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap != null) {
      liveWorkoutNotifier.value = WorkoutLiveSnapshot(
        mission: snap.mission,
        phase: snap.phase,
        currentStepIndex: snap.currentStepIndex,
        stepRemainingSeconds: snap.stepRemainingSeconds,
        stepElapsedSeconds: snap.stepElapsedSeconds,
        totalElapsedSeconds: snap.totalElapsedSeconds,
        completedRepsInStep: snap.completedRepsInStep,
        totalValidatedReps: snap.totalValidatedReps,
        animationCyclePhase: snap.animationCyclePhase,
        stealthModeActive: next,
        jointFriendlyMode: snap.jointFriendlyMode,
        cameraAngle: snap.cameraAngle,
        audioDuckingActive: snap.audioDuckingActive,
        lastAudioCueBanner: next
            ? 'STEALTH MODE ACTIF (0 SAUT • <35dB)'
            : 'MODE STANDARD OPÉRATIONNEL',
        selectedRpe: snap.selectedRpe,
        txpBreakdown: snap.txpBreakdown,
      );
    }
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Bascule l'adaptation articulaire (Poignets / Genoux — Guideline 1.4.1).
  void setJointFriendlyMode(JointFriendlyMode mode) {
    _profile = _profile.copyWith(jointFriendlyMode: mode);
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap != null) {
      liveWorkoutNotifier.value = WorkoutLiveSnapshot(
        mission: snap.mission,
        phase: snap.phase,
        currentStepIndex: snap.currentStepIndex,
        stepRemainingSeconds: snap.stepRemainingSeconds,
        stepElapsedSeconds: snap.stepElapsedSeconds,
        totalElapsedSeconds: snap.totalElapsedSeconds,
        completedRepsInStep: snap.completedRepsInStep,
        totalValidatedReps: snap.totalValidatedReps,
        animationCyclePhase: snap.animationCyclePhase,
        stealthModeActive: snap.stealthModeActive,
        jointFriendlyMode: mode,
        cameraAngle: snap.cameraAngle,
        audioDuckingActive: snap.audioDuckingActive,
        lastAudioCueBanner: 'ADAPTATION : ${mode.label.toUpperCase()}',
        selectedRpe: snap.selectedRpe,
        txpBreakdown: snap.txpBreakdown,
      );
    }
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  /// Sélectionne la Campagne Opérationnelle de 28 Jours active.
  void selectOperationalCampaign(OperationalCampaignId campaign) {
    _profile = _profile.copyWith(
      activeCampaignId: campaign,
      stealthApartmentMode:
          campaign.isStealthDefault ? true : _profile.stealthApartmentMode,
    );
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  /// Accepte le Health & Safety Medical Disclaimer (Store Guideline 1.4.1).
  void acceptMedicalDisclaimer() {
    _profile = _profile.copyWith(medicalDisclaimerAccepted: true);
    notifyListeners();
  }

  /// Utilise un Jeton de Permission Tactique (Dog Tag) pour protéger le Streak en cas d'imprévu.
  bool consumeTacticalLeavePass() {
    if (_profile.tacticalLeavePasses <= 0) {
      return false;
    }
    _profile = _profile.copyWith(
      tacticalLeavePasses: _profile.tacticalLeavePasses - 1,
    );
    HapticFeedback.mediumImpact();
    notifyListeners();
    return true;
  }

  /// Calcule l'Indice d'Aptitude Opérationnelle (IAO sur 100) du Test PT 6 min (@Spartan).
  static BaselinePtCalibrationResult evaluateBaselinePtTest({
    required int pushupsIn2Min,
    required int squatsIn2Min,
    required int plankSeconds,
    bool assistedPushups = false,
  }) {
    final int safePush = math.max(0, pushupsIn2Min);
    final int safeSquats = math.max(0, squatsIn2Min);
    final int safePlank = math.max(0, plankSeconds);

    final double effectivePush =
        safePush * (assistedPushups ? 0.55 : 1.0);
    final int sPush = math.min(
      100,
      (100.0 * math.pow((effectivePush / 60.0).clamp(0.0, 2.0), 0.85)).round(),
    );
    final int sLegs = math.min(
      100,
      (100.0 * math.pow((safeSquats / 80.0).clamp(0.0, 2.0), 0.85)).round(),
    );
    final int sCore = math.min(
      100,
      (100.0 * math.pow((safePlank / 120.0).clamp(0.0, 2.0), 0.90)).round(),
    );
    final int iao =
        (0.35 * sPush + 0.35 * sLegs + 0.30 * sCore).round().clamp(0, 100);

    DifficultyTier tierForScore(int s) {
      if (s < 25) return DifficultyTier.tier1Recruit;
      if (s < 50) return DifficultyTier.tier2Soldier;
      if (s < 75) return DifficultyTier.tier3Nco;
      if (s < 90) return DifficultyTier.tier4Officer;
      return DifficultyTier.tier5SpecOps;
    }

    final DifficultyTier pushTier = tierForScore(sPush);
    final DifficultyTier globalTier = tierForScore(iao);
    final DifficultyTier pullTier = pushTier.level < globalTier.level
        ? pushTier
        : globalTier;

    final MilitaryRank initialRank = iao >= 50
        ? MilitaryRank.e3Corporal
        : (iao >= 25 ? MilitaryRank.e2Private : MilitaryRank.e1Recruit);

    return BaselinePtCalibrationResult(
      pushScore: sPush,
      legsScore: sLegs,
      coreScore: sCore,
      iaoGlobalIndex: iao,
      recommendedFamilyTiers: <BiomechanicalFamily, DifficultyTier>{
        BiomechanicalFamily.upperPush: pushTier,
        BiomechanicalFamily.noBarPull: pullTier,
        BiomechanicalFamily.tacticalLegs: tierForScore(sLegs),
        BiomechanicalFamily.ironCore: tierForScore(sCore),
        BiomechanicalFamily.metCon: globalTier,
      },
      initialUnlockedRank: initialRank,
    );
  }

  /// Applique le résultat de la calibration PT au profil soldat (échelons & quotas adaptés).
  void applyBaselineCalibration({
    required int pushupsIn2Min,
    required int squatsIn2Min,
    required int plankSeconds,
    bool assistedPushups = false,
  }) {
    final BaselinePtCalibrationResult result = evaluateBaselinePtTest(
      pushupsIn2Min: pushupsIn2Min,
      squatsIn2Min: squatsIn2Min,
      plankSeconds: plankSeconds,
      assistedPushups: assistedPushups,
    );

    final Map<BiomechanicalFamily, int> calibratedQuotas =
        <BiomechanicalFamily, int>{};
    result.recommendedFamilyTiers.forEach((
      BiomechanicalFamily fam,
      DifficultyTier tier,
    ) {
      final TacticalExercise ex = MakeFitCatalog.exerciseFor(fam, tier);
      calibratedQuotas[fam] = ex.defaultTargetReps;
    });

    final MilitaryRank calibratedRank =
        result.initialUnlockedRank.order > _profile.rank.order
        ? result.initialUnlockedRank
        : _profile.rank;

    _profile = _profile.copyWith(
      rank: calibratedRank,
      iaoCalibrationScore: result.iaoGlobalIndex,
      familyTiers: result.recommendedFamilyTiers,
      familyRepQuotas: calibratedQuotas,
    );
    HapticFeedback.heavyImpact();
    notifyListeners();
  }

  /// Ouvre le Briefing pré-séance (inspection des exercices et réglages Stealth/Joint).
  void openMissionBriefing(TacticalMission mission) {
    if (mission.steps.isEmpty) {
      return;
    }
    final WorkoutStationStep firstStep = mission.steps.first;
    _monotonicSessionWatch
      ..stop()
      ..reset();
    _contactlessDebounceWatch
      ..stop()
      ..reset();
    _lastContactlessRepTimestamp = null;
    _lastWallClockTickAt = null;

    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: mission,
      phase: WorkoutExecutionPhase.briefing,
      currentStepIndex: 0,
      stepRemainingSeconds: firstStep.durationSeconds,
      stepElapsedSeconds: 0,
      totalElapsedSeconds: 0,
      completedRepsInStep: 0,
      totalValidatedReps: 0,
      animationCyclePhase: 0.0,
      stealthModeActive: _profile.stealthApartmentMode,
      jointFriendlyMode: _profile.jointFriendlyMode,
      cameraAngle: MannequinCameraAngle.threeQuarterTactical,
      audioDuckingActive: false,
      lastAudioCueBanner: 'BRIEFING OPÉRATIONNEL PRÊT • VÉRIFIEZ ZONE 2M×2M',
      selectedRpe: 3,
    );
    notifyListeners();
  }

  /// Démarre une séance active dans le WorkoutPlayerModal.
  void startMission(TacticalMission mission) {
    if (mission.steps.isEmpty) {
      return;
    }
    final WorkoutStationStep firstStep = mission.steps.first;
    _monotonicSessionWatch
      ..reset()
      ..start();
    _contactlessDebounceWatch
      ..stop()
      ..reset();
    _lastContactlessRepTimestamp = null;
    _lastWallClockTickAt = DateTime.now();

    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: mission,
      phase: WorkoutExecutionPhase.activeStep,
      currentStepIndex: 0,
      stepRemainingSeconds: firstStep.durationSeconds,
      stepElapsedSeconds: 0,
      totalElapsedSeconds: 0,
      completedRepsInStep: 0,
      totalValidatedReps: 0,
      animationCyclePhase: 0.0,
      stealthModeActive: _profile.stealthApartmentMode,
      jointFriendlyMode: _profile.jointFriendlyMode,
      cameraAngle: MannequinCameraAngle.threeQuarterTactical,
      audioDuckingActive: true,
      lastAudioCueBanner: 'AUDIO DUCKING -12dB • 3-2-1 GO !',
      selectedRpe: 3,
    );
    HapticFeedback.heavyImpact();
    notifyListeners();
  }

  /// Met la séance en pause sans perdre l'état ni dériver l'horloge monotone.
  void pauseWorkout() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null || snap.phase != WorkoutExecutionPhase.activeStep) {
      return;
    }
    _monotonicSessionWatch.stop();
    _lastWallClockTickAt = null;
    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: WorkoutExecutionPhase.paused,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: snap.stepRemainingSeconds,
      stepElapsedSeconds: snap.stepElapsedSeconds,
      totalElapsedSeconds: snap.totalElapsedSeconds,
      completedRepsInStep: snap.completedRepsInStep,
      totalValidatedReps: snap.totalValidatedReps,
      animationCyclePhase: snap.animationCyclePhase,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: false,
      lastAudioCueBanner: 'PAUSE TACTIQUE • SPOTIFY 100%',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Reprend une séance mise en pause (ou la lance depuis l'écran de briefing).
  void resumeWorkout() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    if (snap.phase != WorkoutExecutionPhase.paused &&
        snap.phase != WorkoutExecutionPhase.briefing) {
      return;
    }
    _monotonicSessionWatch.start();
    _lastWallClockTickAt = DateTime.now();
    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: WorkoutExecutionPhase.activeStep,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: snap.stepRemainingSeconds,
      stepElapsedSeconds: snap.stepElapsedSeconds,
      totalElapsedSeconds: snap.totalElapsedSeconds,
      completedRepsInStep: snap.completedRepsInStep,
      totalValidatedReps: snap.totalValidatedReps,
      animationCyclePhase: snap.animationCyclePhase,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: true,
      lastAudioCueBanner: 'REPRISE OPÉRATIONNELLE • GO !',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  /// Bascule Pause / Reprise en 1 tap.
  void togglePauseWorkout() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    if (snap.phase == WorkoutExecutionPhase.activeStep) {
      pauseWorkout();
    } else if (snap.phase == WorkoutExecutionPhase.paused ||
        snap.phase == WorkoutExecutionPhase.briefing) {
      resumeWorkout();
    }
  }

  /// Synchronise la séance avec l'horloge murale (`DateTime.now()`) après un retour
  /// de mise en arrière-plan OS, en protégeant contre tout recul NTP négatif.
  void syncWithWallClock({DateTime? now}) {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null || snap.phase != WorkoutExecutionPhase.activeStep) {
      return;
    }
    final DateTime current = now ?? DateTime.now();
    final DateTime? previous = _lastWallClockTickAt;
    _lastWallClockTickAt = current;
    if (previous == null) {
      return;
    }
    final int elapsedSec = current.difference(previous).inSeconds;
    if (elapsedSec > 0) {
      tickWorkout(
        deltaSeconds: math.min(elapsedSec, 600),
        deltaAnimPhase: (elapsedSec * 0.25) % 1.0,
      );
    }
  }

  /// Bouton d'urgence "ADAPTER L'EXERCICE / TROP DUR" en pleine séance :
  /// bascule immédiatement vers l'échelon biomécanique inférieur (`Tier k - 1`) sans pénalité.
  void adaptCurrentExerciseDown() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null || snap.phase != WorkoutExecutionPhase.activeStep) {
      return;
    }
    final WorkoutStationStep cur = snap.currentStep;
    final TacticalExercise regressed = MakeFitCatalog.regressedExercise(
      cur.exercise,
    );
    final int adaptedTarget = math.max(5, (cur.targetReps * 0.80).round());

    final List<WorkoutStationStep> updatedSteps = List<WorkoutStationStep>.from(
      snap.mission.steps,
    );
    updatedSteps[snap.currentStepIndex] = WorkoutStationStep(
      stage: cur.stage,
      title: '${cur.title} [ADAPTÉ]',
      subtitle: 'Régression protectrice -> ${regressed.name}',
      exercise: regressed,
      durationSeconds: cur.durationSeconds,
      targetReps: adaptedTarget,
      isTimedWork: cur.isTimedWork,
      roundIndex: cur.roundIndex,
      totalRounds: cur.totalRounds,
    );

    final TacticalMission adaptedMission = TacticalMission(
      id: snap.mission.id,
      code: snap.mission.code,
      title: snap.mission.title,
      subtitle: snap.mission.subtitle,
      format: snap.mission.format,
      durationMinutes: snap.mission.durationMinutes,
      recommendedTier: snap.mission.recommendedTier,
      targetRpe: snap.mission.targetRpe,
      steps: updatedSteps,
      campaignId: snap.mission.campaignId,
      dayNumber: snap.mission.dayNumber,
      isRecoveryDay: snap.mission.isRecoveryDay,
      isBossMission: snap.mission.isBossMission,
      promotionTrialRank: snap.mission.promotionTrialRank,
    );

    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: adaptedMission,
      phase: snap.phase,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: snap.stepRemainingSeconds,
      stepElapsedSeconds: snap.stepElapsedSeconds,
      totalElapsedSeconds: snap.totalElapsedSeconds,
      completedRepsInStep: math.min(snap.completedRepsInStep, adaptedTarget),
      totalValidatedReps: snap.totalValidatedReps,
      animationCyclePhase: snap.animationCyclePhase,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: true,
      lastAudioCueBanner:
          'PROTECTION TENDINEUSE : ${regressed.code} ($adaptedTarget REPS)',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  /// Avance l'horloge et l'animation 60 FPS de la séance en cours.
  /// Supporte à la fois les ticks d'animation pure (`deltaSeconds = 0`) et les ticks temporels (`≥ 1s`).
  void tickWorkout({int deltaSeconds = 1, double deltaAnimPhase = 0.08}) {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null || snap.phase != WorkoutExecutionPhase.activeStep) {
      return;
    }

    final int safeDelta = math.max(0, deltaSeconds);
    final double nextAnim =
        ((snap.animationCyclePhase + deltaAnimPhase) % 1.0 + 1.0) % 1.0;

    if (safeDelta == 0) {
      liveWorkoutNotifier.value = WorkoutLiveSnapshot(
        mission: snap.mission,
        phase: snap.phase,
        currentStepIndex: snap.currentStepIndex,
        stepRemainingSeconds: snap.stepRemainingSeconds,
        stepElapsedSeconds: snap.stepElapsedSeconds,
        totalElapsedSeconds: snap.totalElapsedSeconds,
        completedRepsInStep: snap.completedRepsInStep,
        totalValidatedReps: snap.totalValidatedReps,
        animationCyclePhase: nextAnim,
        stealthModeActive: snap.stealthModeActive,
        jointFriendlyMode: snap.jointFriendlyMode,
        cameraAngle: snap.cameraAngle,
        audioDuckingActive: snap.audioDuckingActive,
        lastAudioCueBanner: snap.lastAudioCueBanner,
        selectedRpe: snap.selectedRpe,
        txpBreakdown: snap.txpBreakdown,
      );
      return;
    }

    _lastWallClockTickAt = DateTime.now();

    final WorkoutStationStep curStep = snap.currentStep;
    final int nextRemaining = snap.stepRemainingSeconds - safeDelta;
    final int nextStepElapsed = snap.stepElapsedSeconds + safeDelta;
    final int nextTotalElapsed = snap.totalElapsedSeconds + safeDelta;

    if (nextRemaining <= 0 && curStep.isTimedWork) {
      // Conservation du temps écoulé réel avant transition vers l'étape suivante
      liveWorkoutNotifier.value = WorkoutLiveSnapshot(
        mission: snap.mission,
        phase: snap.phase,
        currentStepIndex: snap.currentStepIndex,
        stepRemainingSeconds: 0,
        stepElapsedSeconds: nextStepElapsed,
        totalElapsedSeconds: nextTotalElapsed,
        completedRepsInStep: snap.completedRepsInStep,
        totalValidatedReps: snap.totalValidatedReps,
        animationCyclePhase: nextAnim,
        stealthModeActive: snap.stealthModeActive,
        jointFriendlyMode: snap.jointFriendlyMode,
        cameraAngle: snap.cameraAngle,
        audioDuckingActive: snap.audioDuckingActive,
        lastAudioCueBanner: snap.lastAudioCueBanner,
        selectedRpe: snap.selectedRpe,
        txpBreakdown: snap.txpBreakdown,
      );
      advanceToNextWorkoutStep();
      return;
    }

    final bool isCountdown = nextRemaining > 0 && nextRemaining <= 3;
    final int halfDuration = curStep.durationSeconds ~/ 2;
    final bool isHalfwaySwitch =
        halfDuration >= 10 &&
        snap.stepElapsedSeconds < halfDuration &&
        nextStepElapsed >= halfDuration &&
        _isUnilateralMotion(curStep.exercise.motionKind);
    final bool isBoxBreathingTransition =
        curStep.stage == WorkoutStepStage.h2fCooldown &&
        (nextStepElapsed ~/ 4) != (snap.stepElapsedSeconds ~/ 4);

    String nextBanner = snap.lastAudioCueBanner;
    bool ducking = false;
    if (isCountdown) {
      ducking = true;
      nextBanner = 'AUDIO DUCKING -12dB • BIP ${nextRemaining}S';
      HapticFeedback.lightImpact();
    } else if (isHalfwaySwitch) {
      ducking = true;
      nextBanner = 'AUDIO DUCKING -12dB • MI-TEMPS : CHANGEZ DE CÔTÉ !';
      HapticFeedback.mediumImpact();
    } else if (isBoxBreathingTransition) {
      ducking = true;
      final int cycleSec = nextStepElapsed % 16;
      final BoxBreathingPhase bPhase = cycleSec < 4
          ? BoxBreathingPhase.inhale
          : cycleSec < 8
          ? BoxBreathingPhase.holdFull
          : cycleSec < 12
          ? BoxBreathingPhase.exhale
          : BoxBreathingPhase.holdEmpty;
      nextBanner = 'H2F BOX BREATHING • ${bPhase.instruction}';
      HapticFeedback.selectionClick();
    }

    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: snap.phase,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: math.max(0, nextRemaining),
      stepElapsedSeconds: nextStepElapsed,
      totalElapsedSeconds: nextTotalElapsed,
      completedRepsInStep: snap.completedRepsInStep,
      totalValidatedReps: snap.totalValidatedReps,
      animationCyclePhase: nextAnim,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: ducking,
      lastAudioCueBanner: nextBanner,
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
  }

  bool _isUnilateralMotion(MannequinMotionKind kind) {
    return kind == MannequinMotionKind.pushupArcher ||
        kind == MannequinMotionKind.pushupOneArm ||
        kind == MannequinMotionKind.thoracicBridge ||
        kind == MannequinMotionKind.reverseLunge ||
        kind == MannequinMotionKind.cossackSquat ||
        kind == MannequinMotionKind.pistolSquat;
  }

  /// Enregistre une répétition via la Zone Sans Contact (Nez/Menton/Proximité)
  /// avec double filtre anti-rebond `650 ms` (horloge monotone `Stopwatch` + `DateTime.now()`).
  bool registerContactlessRep({
    bool bypassDebounceForTest = false,
    DateTime? timestampOverride,
  }) {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null || snap.phase != WorkoutExecutionPhase.activeStep) {
      return false;
    }

    final DateTime now = timestampOverride ?? DateTime.now();
    if (!bypassDebounceForTest) {
      // 1. Priorité au test d'horodatage explicite ou à l'horloge monotone matérielle
      if (timestampOverride != null && _lastContactlessRepTimestamp != null) {
        final int overrideDeltaMs =
            now.difference(_lastContactlessRepTimestamp!).inMilliseconds;
        if (overrideDeltaMs >= 0 && overrideDeltaMs < contactlessDebounceMs) {
          return false;
        }
      } else if (_contactlessDebounceWatch.isRunning &&
          _contactlessDebounceWatch.elapsedMilliseconds <
              contactlessDebounceMs) {
        return false; // Filtre anti-rebond biomécanique monotone 650 ms (@Athena)
      } else if (_lastContactlessRepTimestamp != null) {
        final int elapsedMs =
            now.difference(_lastContactlessRepTimestamp!).inMilliseconds;
        // Protection contre un saut NTP négatif : si elapsedMs < 0, on ne bloque pas indéfiniment
        if (elapsedMs >= 0 && elapsedMs < contactlessDebounceMs) {
          return false;
        }
      }
    }

    _lastContactlessRepTimestamp = now;
    _contactlessDebounceWatch
      ..reset()
      ..start();

    final int nextReps = snap.completedRepsInStep + 1;
    final int nextTotalReps = snap.totalValidatedReps + 1;
    HapticFeedback.mediumImpact();

    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: snap.phase,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: snap.stepRemainingSeconds,
      stepElapsedSeconds: snap.stepElapsedSeconds,
      totalElapsedSeconds: snap.totalElapsedSeconds,
      completedRepsInStep: nextReps,
      totalValidatedReps: nextTotalReps,
      animationCyclePhase: (snap.animationCyclePhase + 0.25) % 1.0,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: true,
      lastAudioCueBanner:
          'REP $nextReps/${snap.currentStep.targetReps} VALIDÉE (DEBOUNCE 650MS OK)',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );

    if (nextReps >= snap.currentStep.targetReps &&
        !snap.currentStep.isTimedWork) {
      advanceToNextWorkoutStep();
    }
    return true;
  }

  /// Valide en 1-Tap toute la série courante (Batch Validation Fallback).
  void completeCurrentStepBatch() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    final int remainingReps = math.max(
      0,
      snap.currentStep.targetReps - snap.completedRepsInStep,
    );
    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: snap.phase,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: snap.stepRemainingSeconds,
      stepElapsedSeconds: snap.stepElapsedSeconds,
      totalElapsedSeconds: snap.totalElapsedSeconds + 20,
      completedRepsInStep: snap.currentStep.targetReps,
      totalValidatedReps: snap.totalValidatedReps + remainingReps,
      animationCyclePhase: snap.animationCyclePhase,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: true,
      lastAudioCueBanner: 'SÉRIE COMPLÉTÉE • TRANSITION AUDIO DUCKING -12dB',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
    advanceToNextWorkoutStep();
  }

  /// Passe à l'étape suivante ou ouvre la modale de victoire/debriefing.
  void advanceToNextWorkoutStep() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    final int nextIndex = snap.currentStepIndex + 1;
    if (nextIndex >= snap.mission.steps.length) {
      _monotonicSessionWatch.stop();
      final int effectiveReps = math.max(45, snap.totalValidatedReps);
      final TxpBreakdown breakdown = computeTxpBreakdown(
        mission: snap.mission,
        totalValidatedReps: effectiveReps,
        rpeScore: snap.selectedRpe,
      );
      final int monotonicElapsedSec =
          _monotonicSessionWatch.elapsedMilliseconds ~/ 1000;
      final int finalElapsedSec = math.max(
        snap.mission.durationMinutes * 60,
        math.max(snap.totalElapsedSeconds, monotonicElapsedSec),
      );
      liveWorkoutNotifier.value = WorkoutLiveSnapshot(
        mission: snap.mission,
        phase: WorkoutExecutionPhase.debriefingVictory,
        currentStepIndex: snap.currentStepIndex,
        stepRemainingSeconds: 0,
        stepElapsedSeconds: snap.stepElapsedSeconds,
        totalElapsedSeconds: finalElapsedSec,
        completedRepsInStep: snap.completedRepsInStep,
        totalValidatedReps: effectiveReps,
        animationCyclePhase: snap.animationCyclePhase,
        stealthModeActive: snap.stealthModeActive,
        jointFriendlyMode: snap.jointFriendlyMode,
        cameraAngle: snap.cameraAngle,
        audioDuckingActive: true,
        lastAudioCueBanner: 'MISSION ACCOMPLIE • FANFARE TACTIQUE',
        selectedRpe: snap.selectedRpe,
        txpBreakdown: breakdown,
      );
      HapticFeedback.heavyImpact();
      notifyListeners();
      return;
    }

    final WorkoutStationStep nextStep = snap.mission.steps[nextIndex];
    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: WorkoutExecutionPhase.activeStep,
      currentStepIndex: nextIndex,
      stepRemainingSeconds: nextStep.durationSeconds,
      stepElapsedSeconds: 0,
      totalElapsedSeconds: snap.totalElapsedSeconds,
      completedRepsInStep: 0,
      totalValidatedReps: snap.totalValidatedReps,
      animationCyclePhase: 0.0,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: true,
      lastAudioCueBanner:
          'ÉTAPE ${nextIndex + 1}/${snap.mission.steps.length} • ${nextStep.stage.bannerLabel}',
      selectedRpe: snap.selectedRpe,
    );
    HapticFeedback.lightImpact();
  }

  /// Change l'angle d'inspection du mannequin anatomique (3/4, Profil, Face).
  void cycleMannequinCameraAngle() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    final List<MannequinCameraAngle> angles = MannequinCameraAngle.values;
    final MannequinCameraAngle nextAngle =
        angles[(snap.cameraAngle.index + 1) % angles.length];
    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: snap.phase,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: snap.stepRemainingSeconds,
      stepElapsedSeconds: snap.stepElapsedSeconds,
      totalElapsedSeconds: snap.totalElapsedSeconds,
      completedRepsInStep: snap.completedRepsInStep,
      totalValidatedReps: snap.totalValidatedReps,
      animationCyclePhase: snap.animationCyclePhase,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: nextAngle,
      audioDuckingActive: snap.audioDuckingActive,
      lastAudioCueBanner: 'CAMÉRA MANNEQUIN : ${nextAngle.label.toUpperCase()}',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
  }

  /// Ajoute +15 secondes de repos tactique si l'utilisateur est essoufflé.
  void addRestSeconds(int extraSeconds) {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    final int safeExtra = math.max(1, extraSeconds);
    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: snap.phase,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: snap.stepRemainingSeconds + safeExtra,
      stepElapsedSeconds: snap.stepElapsedSeconds,
      totalElapsedSeconds: snap.totalElapsedSeconds,
      completedRepsInStep: snap.completedRepsInStep,
      totalValidatedReps: snap.totalValidatedReps,
      animationCyclePhase: snap.animationCyclePhase,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: snap.audioDuckingActive,
      lastAudioCueBanner: '+${safeExtra}S REPOS TACTIQUE ACCORDÉ',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
  }

  /// Met à jour le score RPE (1 à 5) sur l'écran de Debriefing et recalcule les TXP.
  void selectDebriefRpe(int rpeScore) {
    final int clamped = rpeScore.clamp(1, 5);
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    final TxpBreakdown breakdown = computeTxpBreakdown(
      mission: snap.mission,
      totalValidatedReps: math.max(45, snap.totalValidatedReps),
      rpeScore: clamped,
    );
    liveWorkoutNotifier.value = WorkoutLiveSnapshot(
      mission: snap.mission,
      phase: snap.phase,
      currentStepIndex: snap.currentStepIndex,
      stepRemainingSeconds: snap.stepRemainingSeconds,
      stepElapsedSeconds: snap.stepElapsedSeconds,
      totalElapsedSeconds: snap.totalElapsedSeconds,
      completedRepsInStep: snap.completedRepsInStep,
      totalValidatedReps: snap.totalValidatedReps,
      animationCyclePhase: snap.animationCyclePhase,
      stealthModeActive: snap.stealthModeActive,
      jointFriendlyMode: snap.jointFriendlyMode,
      cameraAngle: snap.cameraAngle,
      audioDuckingActive: snap.audioDuckingActive,
      lastAudioCueBanner: snap.lastAudioCueBanner,
      selectedRpe: clamped,
      txpBreakdown: breakdown,
    );
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Formule mathématique exacte des TXP (@Athena ORB-83).
  TxpBreakdown computeTxpBreakdown({
    required TacticalMission mission,
    required int totalValidatedReps,
    required int rpeScore,
  }) {
    final int clampedRpe = rpeScore.clamp(1, 5);
    final int baseTxp =
        (mission.isRecoveryDay ||
            mission.format == WorkoutFormatType.flashPt5Min)
        ? 60
        : 100;
    final double tierCoeff = mission.recommendedTier.txpCoefficient;
    final int volumeTxp = (math.max(0, totalValidatedReps) * 2 * tierCoeff)
        .round();
    final int durationTxp = math.max(1, mission.durationMinutes) * 10;
    const int rampH2fBonusTxp = 100; // 35 RAMP + 35 H2F + 30 Combo Santé

    final int nextStreak = _profile.currentStreakDays + 1;
    final double streakMultiplier = nextStreak >= 28
        ? 1.50
        : nextStreak >= 14
        ? 1.40
        : nextStreak >= 7
        ? 1.25
        : nextStreak >= 3
        ? 1.10
        : 1.00;
    final double formatMultiplier = mission.format.txpMultiplier;
    final int rpeBonus = clampedRpe <= 2 ? 15 : 25;
    final int trialBonus = switch (mission.promotionTrialRank) {
      MilitaryRank.e3Corporal => 500,
      MilitaryRank.e5StaffSergeant => 750,
      MilitaryRank.o1Lieutenant => 1200,
      MilitaryRank.sf1Operator => 2000,
      _ => 0,
    };

    final int multipliedCore =
        ((baseTxp + volumeTxp + durationTxp + rampH2fBonusTxp) *
                streakMultiplier *
                formatMultiplier)
            .floor();
    final int totalTxp = multipliedCore + rpeBonus + trialBonus;

    final String adjustmentNote = switch (clampedRpe) {
      1 =>
        'RPE 1 (Recon) : Volume J+1 +15% (+2 reps/série) & échelon supérieur prêt',
      2 => 'RPE 2 (Patrouille) : Volume J+1 +10% (+1 rep/série)',
      3 =>
        'RPE 3 (Standard Opérationnel) : Progression nominale H2F (+5% / +1 rep)',
      4 =>
        'RPE 4 (Combat Intense) : Consolidation tendineuse (volume maintenu, +5s repos)',
      _ =>
        'RPE 5 (Surchauffe) : Tactical Deload automatique (-20% volume J+1 & Mobilité H2F)',
    };

    final int projectedTotalTxp = _profile.totalTxp + totalTxp;
    final Set<MilitaryRank> projectedTrials = <MilitaryRank>{
      ..._profile.passedTrialRanks,
      if (mission.promotionTrialRank != null) mission.promotionTrialRank!,
    };
    final MilitaryRank resolvedRank = resolveRankForTxp(
      totalTxp: projectedTotalTxp,
      passedTrials: projectedTrials,
    );
    final MilitaryRank? promotedTo = resolvedRank.order > _profile.rank.order
        ? resolvedRank
        : null;

    return TxpBreakdown(
      baseTxp: baseTxp,
      volumeTxp: volumeTxp,
      durationTxp: durationTxp,
      rampH2fBonusTxp: rampH2fBonusTxp,
      streakMultiplier: streakMultiplier,
      formatMultiplier: formatMultiplier,
      rpeHonestyBonusTxp: rpeBonus,
      trialBonusTxp: trialBonus,
      totalTxp: totalTxp,
      nextSessionAdjustmentNote: adjustmentNote,
      promotedToRank: promotedTo,
    );
  }

  /// Résout le grade militaire atteint selon les TXP cumulés et les Examens PT validés (XP Banking inclus).
  static MilitaryRank resolveRankForTxp({
    required int totalTxp,
    required Set<MilitaryRank> passedTrials,
  }) {
    MilitaryRank current = MilitaryRank.e1Recruit;
    for (final MilitaryRank candidate in MilitaryRank.values) {
      if (totalTxp < candidate.minTxp) {
        break;
      }
      if (candidate.requiresTrial && !passedTrials.contains(candidate)) {
        break; // XP Banking : les TXP continuent de s'accumuler sans perte
      }
      current = candidate;
    }
    return current;
  }

  int _masteryRepThresholdForTier(DifficultyTier tier) {
    return switch (tier) {
      DifficultyTier.tier1Recruit => 18,
      DifficultyTier.tier2Soldier => 20,
      DifficultyTier.tier3Nco => 16,
      DifficultyTier.tier4Officer => 14,
      DifficultyTier.tier5SpecOps => 999,
    };
  }

  /// Valide définitivement le Debriefing de séance, applique l'auto-régulation RPE,
  /// met à jour l'équilibre postural Push/Pull réel et gère le Streak Résilient.
  void confirmMissionDebriefAndClaimLoot() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    final int rpe = snap.selectedRpe.clamp(1, 5);
    final TxpBreakdown breakdown =
        snap.txpBreakdown ??
        computeTxpBreakdown(
          mission: snap.mission,
          totalValidatedReps: math.max(45, snap.totalValidatedReps),
          rpeScore: rpe,
        );

    // 1. Adaptation automatique des quotas & échelons par l'algorithme RPE (@Spartan §4.2)
    final double gamma = switch (rpe) {
      1 => 0.15,
      2 => 0.10,
      3 => 0.05,
      4 => 0.00,
      _ => -0.20,
    };
    final int delta = switch (rpe) {
      1 => 2,
      2 => 1,
      3 => 1,
      4 => 0,
      _ => -2,
    };

    final Map<BiomechanicalFamily, int> updatedQuotas =
        <BiomechanicalFamily, int>{};
    final Map<BiomechanicalFamily, DifficultyTier> updatedTiers =
        Map<BiomechanicalFamily, DifficultyTier>.from(_profile.familyTiers);

    _profile.familyRepQuotas.forEach((BiomechanicalFamily fam, int currentRep) {
      final DifficultyTier curTier =
          updatedTiers[fam] ?? DifficultyTier.tier2Soldier;
      int adapted = (currentRep * (1.0 + gamma) + delta).round().clamp(5, 40);

      // Promotion automatique d'échelon si standard de maîtrise atteint à RPE <= 3
      final int masteryCeiling = _masteryRepThresholdForTier(curTier);
      if (!snap.mission.isRecoveryDay &&
          curTier.index < DifficultyTier.values.length - 1 &&
          ((adapted >= masteryCeiling && rpe <= 3) ||
              (rpe == 1 && _profile.lastRpeScore <= 2 && adapted >= 14))) {
        updatedTiers[fam] = DifficultyTier.values[curTier.index + 1];
        adapted = (masteryCeiling * 0.60).round().clamp(6, 20);
      } else if (rpe == 5 &&
          _profile.lastRpeScore == 5 &&
          curTier.index > 0) {
        // Régression protectrice en cas de double surchauffe consécutive (RPE 5 × 2)
        final DifficultyTier prevTier = DifficultyTier.values[curTier.index - 1];
        updatedTiers[fam] = prevTier;
        adapted = (_masteryRepThresholdForTier(prevTier) * 0.75)
            .round()
            .clamp(6, 20);
      }

      updatedQuotas[fam] = adapted;
    });

    // Conservation stricte d'un plancher de tirage scapulaire face à la poussée
    final int nextPushQuota = updatedQuotas[BiomechanicalFamily.upperPush] ?? 15;
    final int nextPullQuota = updatedQuotas[BiomechanicalFamily.noBarPull] ?? 15;
    if (_profile.posturalBalanceRatio < 0.85 && nextPullQuota < nextPushQuota) {
      updatedQuotas[BiomechanicalFamily.noBarPull] = nextPushQuota;
    }

    // 2. Comptabilisation réelle des volumes hebdomadaires par famille biomécanique
    final Map<BiomechanicalFamily, int> sessionVolumes =
        <BiomechanicalFamily, int>{
          for (final BiomechanicalFamily f in BiomechanicalFamily.values) f: 0,
        };
    for (final WorkoutStationStep step in snap.mission.steps) {
      if (step.stage == WorkoutStepStage.mainWork) {
        final BiomechanicalFamily fam = step.exercise.family;
        sessionVolumes[fam] = (sessionVolumes[fam] ?? 0) + step.targetReps;
      }
    }

    final Map<BiomechanicalFamily, int> updatedVolumes =
        Map<BiomechanicalFamily, int>.from(_profile.weeklyFamilyVolumes);
    for (final BiomechanicalFamily fam in BiomechanicalFamily.values) {
      final int gained = sessionVolumes[fam] ?? 0;
      updatedVolumes[fam] =
          (updatedVolumes[fam] ?? 0) + (gained > 0 ? gained : 12);
    }

    // 3. Streak Résilient & Jetons de Permission Tactique (1 Dog Tag / 7 séances, max 2)
    final int nextCompletedSessions = _profile.completedSessionsCount + 1;
    final int nextStreak = _profile.currentStreakDays + 1;
    final int nextBestStreak = math.max(_profile.bestStreakDays, nextStreak);
    int nextPasses = _profile.tacticalLeavePasses;
    int extraConstancyTxp = 0;
    final int nextPassCounter = (_profile.sessionsTowardsNextPass + 1) % 7;
    if (nextPassCounter == 0) {
      if (nextPasses < 2) {
        nextPasses += 1;
      } else {
        extraConstancyTxp = 250; // Surplus converti en +250 TXP (@Athena)
      }
    }

    final int nextTotalTxp =
        _profile.totalTxp + breakdown.totalTxp + extraConstancyTxp;
    final Set<MilitaryRank> nextTrials = <MilitaryRank>{
      ..._profile.passedTrialRanks,
      if (snap.mission.promotionTrialRank != null)
        snap.mission.promotionTrialRank!,
    };
    final MilitaryRank nextRank = resolveRankForTxp(
      totalTxp: nextTotalTxp,
      passedTrials: nextTrials,
    );

    final Set<String> nextCompletedMissions = <String>{
      ..._profile.completedMissionIds,
      snap.mission.id,
    };
    final List<int> nextHeatmap = List<int>.from(
      _profile.activityHeatmap28Days,
    );
    final int heatIdx = (_profile.currentCampaignDay - 1).clamp(
      0,
      nextHeatmap.length - 1,
    );
    nextHeatmap[heatIdx] = snap.mission.isRecoveryDay ? 1 : 3;

    _profile = _profile.copyWith(
      rank: nextRank,
      totalTxp: nextTotalTxp,
      currentStreakDays: nextStreak,
      bestStreakDays: nextBestStreak,
      tacticalLeavePasses: nextPasses,
      sessionsTowardsNextPass: nextPassCounter,
      completedSessionsCount: nextCompletedSessions,
      familyTiers: updatedTiers,
      familyRepQuotas: updatedQuotas,
      completedMissionIds: nextCompletedMissions,
      passedTrialRanks: nextTrials,
      weeklyFamilyVolumes: updatedVolumes,
      lastRpeScore: rpe,
      currentCampaignDay: (_profile.currentCampaignDay % 28) + 1,
      activityHeatmap28Days: nextHeatmap,
    );

    _monotonicSessionWatch
      ..stop()
      ..reset();
    _contactlessDebounceWatch
      ..stop()
      ..reset();
    _lastContactlessRepTimestamp = null;
    _lastWallClockTickAt = null;

    liveWorkoutNotifier.value = null;
    HapticFeedback.heavyImpact();
    notifyListeners();
  }

  /// Ferme la modale d'entraînement sans perdre la progression existante.
  void closeWorkoutModal() {
    _monotonicSessionWatch
      ..stop()
      ..reset();
    _contactlessDebounceWatch
      ..stop()
      ..reset();
    _lastContactlessRepTimestamp = null;
    _lastWallClockTickAt = null;
    liveWorkoutNotifier.value = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _monotonicSessionWatch.stop();
    _contactlessDebounceWatch.stop();
    liveWorkoutNotifier.dispose();
    super.dispose();
  }
}
