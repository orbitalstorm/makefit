import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../data/makefit_catalog.dart';
import '../models/makefit_models.dart';

/// Moteur d'entraînement guidé, d'auto-régulation et de motivation MakeFit 40+ (`v1.1.0`).
/// Implémente :
/// - Démarrage 100 % vierge sans aucune donnée d'exemple (`Jour 1`, `0 séance`, `0 min`, `0 XP`),
/// - Séances quotidiennes de **10 minutes maximum** (`6`, `8` ou `10` min) adaptées au profil 40+,
/// - Enchaînement **100 % automatique** après l'appui sur `GO` : Échauffement -> Séries ->
///   Récupérations actives -> Retour au calme, avec progression automatique des répétitions
///   synchronisée à l'animation 60 FPS sans jamais obliger à toucher l'écran,
/// - Motivation quotidienne bienveillante (`dailyMotivationQuote`) et équilibrage postural du dos.
class MakeFitEngine extends ChangeNotifier {
  MakeFitEngine({SoldierProfileState? initialProfile})
    : _profile = initialProfile ?? createDefaultSoldierProfile();

  /// Fenêtre minimale anti-rebond (`650 ms`) entre deux validations manuelles.
  static const int contactlessDebounceMs = 650;

  /// Citations quotidiennes motivantes, adultes et bienveillantes (28 jours).
  static const List<String> _dailyMotivationQuotes = <String>[
    'Le plus important, c\'est de commencer : 10 minutes aujourd\'hui lancent ta nouvelle dynamique.',
    'La régularité bat toujours l\'intensité : chaque séance renforce ton dos, ton souffle et ton énergie.',
    'Trois jours d\'élan : tes articulations se dérouillent et ton corps retrouve son tonus naturel.',
    'Prendre soin de sa mobilité à 40 ans, c\'est investir dans vingt ans de vitalité.',
    'Dix minutes bien guidées valent mieux qu\'une heure remise à demain. Bravo d\'être là !',
    'Un gainage solide, c\'est un dos protégé du matin au soir. Continue à ton rythme.',
    'Une première semaine qui prend forme : l\'habitude s\'installe séance après séance.',
    'Chaque répétition fluide redresse ta posture et chasse la fatigue du quotidien.',
    'Écoute ton corps, respire profondément et laisse le chronomètre te guider sans pression.',
    'À 40 ans, la vraie force est durable : souplesse, tonicité et régularité.',
    'Même les jours chargés, 6 à 10 minutes suffisent pour garder la flamme allumée.',
    'Ton souffle est plus calme, tes épaules plus ouvertes : tes efforts portent déjà leurs fruits.',
    'Pas besoin de matériel ni de salle : ton meilleur allié, c\'est ta constance d\'aujourd\'hui.',
    'Deux semaines de cap ! Ton niveau d\'énergie au réveil fait toute la différence.',
    'Un mouvement propre et maîtrisé protège tes articulations tout en sculptant tes muscles.',
    'Tu construis un corps fiable, mobile et tonique pour tout ce qui compte dans ta vie.',
    'Relâche les épaules, engage les abdos : la qualité du geste prime toujours.',
    'La récupération active fait partie intégrante du progrès. Respire et savoure l\'instant.',
    'Séance après séance, ta sangle abdominale se renforce et ton dos te remercie.',
    'Vingt jours d\'engagement personnel : la discipline douce devient une seconde nature.',
    'Trois semaines au compteur ! Tu prouves qu\'un format court et régulier change tout.',
    'Garde ce rythme fluide : ni précipitation, ni tension inutile, juste du bon mouvement.',
    'Ton endurance progresse en silence : ce qui semblait exigeant au Jour 1 devient naturel.',
    'Dix minutes pour toi, zéro distraction : le meilleur moment de la journée pour recharger les batteries.',
    'La mobilité des hanches et des épaules est le secret d\'un corps jeune et sans raideur.',
    'Dernière ligne droite du cycle : sois fier de chaque séance accomplie depuis le premier jour.',
    'Demain marque le bilan de tes 4 semaines : garde de l\'aisance et profite du mouvement.',
    'Jour 28 : quatre semaines de constance ! Tu as bâti une vraie routine de forme durable.',
  ];

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

  /// Crée un profil 100 % vierge au démarrage (zéro donnée d'exemple : Jour 1, 0 séance, 0 min, 0 XP).
  static SoldierProfileState createDefaultSoldierProfile() {
    return const SoldierProfileState(
      callsign: '',
      rank: MilitaryRank.e1Recruit,
      totalTxp: 0,
      currentStreakDays: 0,
      bestStreakDays: 0,
      tacticalLeavePasses: 1,
      sessionsTowardsNextPass: 0,
      completedSessionsCount: 0,
      stealthApartmentMode: false,
      jointFriendlyMode: JointFriendlyMode.standard,
      familyTiers: <BiomechanicalFamily, DifficultyTier>{
        BiomechanicalFamily.upperPush: DifficultyTier.tier1Recruit,
        BiomechanicalFamily.noBarPull: DifficultyTier.tier1Recruit,
        BiomechanicalFamily.tacticalLegs: DifficultyTier.tier1Recruit,
        BiomechanicalFamily.ironCore: DifficultyTier.tier1Recruit,
        BiomechanicalFamily.metCon: DifficultyTier.tier1Recruit,
      },
      familyRepQuotas: <BiomechanicalFamily, int>{
        BiomechanicalFamily.upperPush: 10,
        BiomechanicalFamily.noBarPull: 10,
        BiomechanicalFamily.tacticalLegs: 14,
        BiomechanicalFamily.ironCore: 12,
        BiomechanicalFamily.metCon: 18,
      },
      completedMissionIds: <String>{},
      passedTrialRanks: <MilitaryRank>{},
      weeklyFamilyVolumes: <BiomechanicalFamily, int>{
        BiomechanicalFamily.upperPush: 0,
        BiomechanicalFamily.noBarPull: 0,
        BiomechanicalFamily.tacticalLegs: 0,
        BiomechanicalFamily.ironCore: 0,
        BiomechanicalFamily.metCon: 0,
      },
      lastRpeScore: 3,
      iaoCalibrationScore: 0,
      medicalDisclaimerAccepted: true,
      activeCampaignId: OperationalCampaignId.op1BasicBootcamp,
      currentCampaignDay: 1,
      activityHeatmap28Days: <int>[
        0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0,
      ],
      isProfileCreated: false,
      ageYears: 40,
      fitnessGoal: FitnessGoal40Plus.vitalityAndEnergy,
      fitnessLevel: FitnessInitialLevel.gentleRestart,
      preferredSessionMinutes: 10,
      totalMinutesTrained: 0,
    );
  }

  /// Phrase de motivation quotidienne percutante et bienveillante adaptée au jour courant.
  String get dailyMotivationQuote {
    final int idx = (_profile.currentCampaignDay - 1).clamp(
      0,
      _dailyMotivationQuotes.length - 1,
    );
    return _dailyMotivationQuotes[idx];
  }

  /// Crée ou met à jour le profil utilisateur à partir de l'écran de Création de Profil.
  /// Démarre au Jour 1 avec 0 séance et 0 donnée de démonstration lors de la création initiale.
  void completeProfileCreation({
    required String firstName,
    int ageYears = 40,
    FitnessGoal40Plus goal = FitnessGoal40Plus.vitalityAndEnergy,
    FitnessInitialLevel level = FitnessInitialLevel.gentleRestart,
    int preferredSessionMinutes = 10,
    bool jointProtection = false,
    bool silentNoJump = false,
  }) {
    final String cleanName = firstName.trim().isEmpty
        ? 'Athlète'
        : firstName.trim();
    final int clampedAge = ageYears.clamp(18, 85);
    final int normalizedMinutes = MakeFitCatalog.normalizeSessionMinutes(
      preferredSessionMinutes,
    );
    final DifficultyTier startTier = level.recommendedTier;

    final Map<BiomechanicalFamily, DifficultyTier> startTiers =
        <BiomechanicalFamily, DifficultyTier>{
          for (final BiomechanicalFamily fam in BiomechanicalFamily.values)
            fam: startTier,
        };
    final Map<BiomechanicalFamily, int> startQuotas =
        <BiomechanicalFamily, int>{
          for (final BiomechanicalFamily fam in BiomechanicalFamily.values)
            fam: MakeFitCatalog.exerciseFor(fam, startTier).defaultTargetReps,
        };

    final OperationalCampaignId recommendedCampaign = switch (goal) {
      FitnessGoal40Plus.vitalityAndEnergy =>
        silentNoJump
            ? OperationalCampaignId.op2SilentRecon
            : OperationalCampaignId.op1BasicBootcamp,
      FitnessGoal40Plus.coreAndBackHealth =>
        OperationalCampaignId.op2SilentRecon,
      FitnessGoal40Plus.strengthAndPosture =>
        level == FitnessInitialLevel.dynamicFit
            ? OperationalCampaignId.op3AirborneConditioning
            : OperationalCampaignId.op1BasicBootcamp,
    };

    _profile = _profile.copyWith(
      callsign: cleanName,
      ageYears: clampedAge,
      fitnessGoal: goal,
      fitnessLevel: level,
      preferredSessionMinutes: normalizedMinutes,
      stealthApartmentMode: silentNoJump,
      jointFriendlyMode: jointProtection
          ? JointFriendlyMode.wristFriendly
          : JointFriendlyMode.standard,
      familyTiers: startTiers,
      familyRepQuotas: startQuotas,
      activeCampaignId: recommendedCampaign,
      isProfileCreated: true,
    );
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  /// Modifie la durée quotidienne souhaitée (`6`, `8` ou `10` minutes max).
  void setPreferredSessionMinutes(int minutes) {
    final int normalized = MakeFitCatalog.normalizeSessionMinutes(minutes);
    _profile = _profile.copyWith(preferredSessionMinutes: normalized);
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Rouvre l'écran de configuration du profil.
  void reopenProfileEditor() {
    _profile = _profile.copyWith(isProfileCreated: false);
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Réinitialise intégralement le profil à zéro (Jour 1, 0 séance, 0 min, 0 XP).
  void resetProfileToZero() {
    _profile = createDefaultSoldierProfile();
    liveWorkoutNotifier.value = null;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  /// Ratio d'équilibre postural Push / Pull sur 7 jours (cible optimale : `0.85` à `1.15`).
  double get posturalBalanceRatio => _profile.posturalBalanceRatio;

  /// Indique si le volume de tirage dorsal est inférieur à la poussée (`< 0.85`).
  bool get hasPosturalPullDeficit => _profile.posturalBalanceRatio < 0.85;

  /// Indique si l'équilibre buste / dos hebdomadaire est dans la fenêtre optimale `[0.85, 1.15]`.
  bool get isPosturalBalanceOptimal {
    final double r = _profile.posturalBalanceRatio;
    return r >= 0.85 && r <= 1.15;
  }

  /// Diagnostic lisible de l'équilibre postural Buste / Dos.
  String get posturalDiagnosticLabel {
    final double r = _profile.posturalBalanceRatio;
    if (r < 0.85) {
      return 'RENFORCEMENT DOS ACTIVÉ (${r.toStringAsFixed(2)}) • +1 SÉRIE POSTURE AJOUTÉE';
    }
    if (r > 1.15) {
      return 'DOS SOLIDE & ÉPAULES PROTÉGÉES (${r.toStringAsFixed(2)})';
    }
    return 'ÉQUILIBRE BUSTE / DOS OPTIMAL (${r.toStringAsFixed(2)})';
  }

  /// Indique si le filtre anti-rebond (`650 ms`) autorise une validation manuelle.
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

  /// Séance quotidienne recommandée (1 clic avec le bouton `GO`), calibrée sur
  /// `profile.preferredSessionMinutes` (`6`, `8` ou `10` min max) et `profile.fitnessLevel`.
  TacticalMission get todayRecommendedMission {
    final int targetMinutes = MakeFitCatalog.normalizeSessionMinutes(
      _profile.preferredSessionMinutes,
    );
    final int restBuffer = _profile.lastRpeScore >= 4 ? 5 : 0;
    final List<TacticalMission> missions = MakeFitCatalog.missionsForCampaign(
      _profile.activeCampaignId,
      _profile.familyRepQuotas,
      familyTiers: _profile.familyTiers,
      posturalBalanceRatio: _profile.posturalBalanceRatio,
      extraRestSeconds: restBuffer,
      preferredSessionMinutes: targetMinutes,
      fitnessLevel: _profile.fitnessLevel,
    );
    final int idx = (_profile.currentCampaignDay - 1).clamp(
      0,
      missions.length - 1,
    );
    return missions[idx];
  }

  /// Catalogue des 5 formats rapides guidés (`6`, `8` ou `10` min max) adaptés au profil.
  List<TacticalMission> get personalizedQuickMissions =>
      MakeFitCatalog.buildQuickFormatMissions(_profile);

  /// Génère à la demande une séance personnalisée (`6`, `8` ou `10` min max).
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

  /// Bascule instantanée du Mode Sans Saut / Silencieux.
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
            ? 'Mode Sans Saut activé • Douceur articulaire'
            : 'Mode Standard activé',
        selectedRpe: snap.selectedRpe,
        txpBreakdown: snap.txpBreakdown,
      );
    }
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Bascule l'adaptation articulaire (Poignets / Genoux).
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
        lastAudioCueBanner: 'Adaptation active : ${mode.label}',
        selectedRpe: snap.selectedRpe,
        txpBreakdown: snap.txpBreakdown,
      );
    }
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  /// Sélectionne le Programme de 28 Jours actif.
  void selectOperationalCampaign(OperationalCampaignId campaign) {
    _profile = _profile.copyWith(
      activeCampaignId: campaign,
      stealthApartmentMode:
          campaign.isStealthDefault ? true : _profile.stealthApartmentMode,
    );
    HapticFeedback.lightImpact();
    notifyListeners();
  }

  /// Accepte l'avertissement de santé et de prévention.
  void acceptMedicalDisclaimer() {
    _profile = _profile.copyWith(medicalDisclaimerAccepted: true);
    notifyListeners();
  }

  /// Utilise un jeton de souplesse pour préserver la série de jours consécutifs en cas d'imprévu.
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

  /// Calcule le score d'évaluation initial sur 100 (Test 6 min).
  static BaselinePtCalibrationResult evaluateBaselinePtTest({
    required int pushupsIn2Min,
    required int squatsIn2Min,
    required int plankSeconds,
    bool assistedPushups = false,
  }) {
    final int safePush = math.max(0, pushupsIn2Min);
    final int safeSquats = math.max(0, squatsIn2Min);
    final int safePlank = math.max(0, plankSeconds);

    final double effectivePush = safePush * (assistedPushups ? 0.55 : 1.0);
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

  /// Applique le résultat de l'évaluation initiale au profil utilisateur.
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

  /// Ouvre l'aperçu pré-séance avant le lancement.
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
      lastAudioCueBanner:
          'Séance prête (${mission.durationMinutes} min) • Appuie sur GO pour démarrer',
      selectedRpe: 3,
    );
    notifyListeners();
  }

  /// Démarre immédiatement la séance guidée 100 % automatique (`GO`).
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
      lastAudioCueBanner:
          'C\'est parti ! Suis l\'animation, tout s\'enchaîne automatiquement',
      selectedRpe: 3,
    );
    HapticFeedback.heavyImpact();
    notifyListeners();
  }

  /// Met la séance en pause sans perdre la progression en cours.
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
      lastAudioCueBanner: 'Séance en pause • Reprends dès que tu es prêt',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Reprend une séance mise en pause (ou la lance depuis l'aperçu).
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
      lastAudioCueBanner: 'Reprise de la séance • Garde un rythme fluide !',
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
  /// de mise en arrière-plan OS.
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
        deltaAnimPhase: (elapsedSec * 0.35) % 1.0,
      );
    }
  }

  /// Adapte immédiatement l'exercice en cours vers une variante plus douce (`Tier k - 1`) sans pénalité.
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
      title: '${cur.title} (Plus doux)',
      subtitle: 'Variante confort -> ${regressed.name}',
      exercise: regressed,
      durationSeconds: cur.durationSeconds,
      targetReps: adaptedTarget,
      isTimedWork: true,
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
          'Variante plus douce activée : ${regressed.name} (~$adaptedTarget reps)',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  /// Avance automatiquement l'horloge, l'animation 60 FPS et le compteur de répétitions.
  /// - Si `deltaSeconds == 0` : met à jour uniquement la phase d'animation fluide.
  /// - Si `deltaSeconds >= 1` : décrémente le chronomètre, fait progresser automatiquement
  ///   `completedRepsInStep` et `totalValidatedReps` pendant `WorkoutStepStage.mainWork`,
  ///   et enchaîne automatiquement l'étape suivante dès que `nextRemaining <= 0`.
  void tickWorkout({int deltaSeconds = 1, double deltaAnimPhase = 0.08}) {
    WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
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

    int remainingToProcess = safeDelta;
    bool animApplied = false;
    int safetyTransitions = 0;
    final int maxTransitions = snap.mission.steps.length + 2;

    while (remainingToProcess > 0 && safetyTransitions <= maxTransitions) {
      snap = liveWorkoutNotifier.value;
      if (snap == null || snap.phase != WorkoutExecutionPhase.activeStep) {
        break;
      }

      final WorkoutStationStep curStep = snap.currentStep;
      final int stepRemBefore = math.max(1, snap.stepRemainingSeconds);
      final int consumed = math.min(remainingToProcess, stepRemBefore);
      remainingToProcess -= consumed;

      final int nextRemaining = snap.stepRemainingSeconds - consumed;
      final int nextStepElapsed = snap.stepElapsedSeconds + consumed;
      final int nextTotalElapsed = snap.totalElapsedSeconds + consumed;
      final double stepAnim = animApplied
          ? ((snap.animationCyclePhase + (consumed * 0.35)) % 1.0 + 1.0) % 1.0
          : nextAnim;
      animApplied = true;

      // Progression 100 % automatique des répétitions pendant une série d'effort
      int nextRepsInStep = snap.completedRepsInStep;
      int nextTotalValidatedReps = snap.totalValidatedReps;
      if (curStep.stage == WorkoutStepStage.mainWork && curStep.targetReps > 0) {
        final int stepDur = math.max(1, curStep.durationSeconds);
        final int effectiveElapsed = nextRemaining <= 0
            ? stepDur
            : nextStepElapsed.clamp(0, stepDur);
        final int autoRepsNow = ((effectiveElapsed * curStep.targetReps) / stepDur)
            .floor()
            .clamp(0, curStep.targetReps);
        if (autoRepsNow > nextRepsInStep) {
          final int deltaReps = autoRepsNow - nextRepsInStep;
          nextRepsInStep = autoRepsNow;
          nextTotalValidatedReps += deltaReps;
        }
      }

      // Enchaînement 100 % automatique vers l'étape suivante quelle que soit sa nature
      if (nextRemaining <= 0) {
        liveWorkoutNotifier.value = WorkoutLiveSnapshot(
          mission: snap.mission,
          phase: snap.phase,
          currentStepIndex: snap.currentStepIndex,
          stepRemainingSeconds: 0,
          stepElapsedSeconds: nextStepElapsed,
          totalElapsedSeconds: nextTotalElapsed,
          completedRepsInStep: nextRepsInStep,
          totalValidatedReps: nextTotalValidatedReps,
          animationCyclePhase: stepAnim,
          stealthModeActive: snap.stealthModeActive,
          jointFriendlyMode: snap.jointFriendlyMode,
          cameraAngle: snap.cameraAngle,
          audioDuckingActive: snap.audioDuckingActive,
          lastAudioCueBanner: snap.lastAudioCueBanner,
          selectedRpe: snap.selectedRpe,
          txpBreakdown: snap.txpBreakdown,
        );
        safetyTransitions++;
        advanceToNextWorkoutStep();
        continue;
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
        nextBanner = 'Changement d\'étape dans ${nextRemaining}s…';
        HapticFeedback.lightImpact();
      } else if (isHalfwaySwitch) {
        ducking = true;
        nextBanner = 'Mi-série : change de côté en douceur !';
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
        nextBanner = 'Respiration guidée • ${bPhase.instruction}';
        HapticFeedback.selectionClick();
      }

      liveWorkoutNotifier.value = WorkoutLiveSnapshot(
        mission: snap.mission,
        phase: snap.phase,
        currentStepIndex: snap.currentStepIndex,
        stepRemainingSeconds: math.max(0, nextRemaining),
        stepElapsedSeconds: nextStepElapsed,
        totalElapsedSeconds: nextTotalElapsed,
        completedRepsInStep: nextRepsInStep,
        totalValidatedReps: nextTotalValidatedReps,
        animationCyclePhase: stepAnim,
        stealthModeActive: snap.stealthModeActive,
        jointFriendlyMode: snap.jointFriendlyMode,
        cameraAngle: snap.cameraAngle,
        audioDuckingActive: ducking,
        lastAudioCueBanner: nextBanner,
        selectedRpe: snap.selectedRpe,
        txpBreakdown: snap.txpBreakdown,
      );
    }
  }

  bool _isUnilateralMotion(MannequinMotionKind kind) {
    return kind == MannequinMotionKind.pushupArcher ||
        kind == MannequinMotionKind.pushupOneArm ||
        kind == MannequinMotionKind.thoracicBridge ||
        kind == MannequinMotionKind.reverseLunge ||
        kind == MannequinMotionKind.cossackSquat ||
        kind == MannequinMotionKind.pistolSquat;
  }

  /// Comptabilise manuellement une répétition supplémentaire avec filtre anti-rebond `650 ms`.
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
      if (timestampOverride != null && _lastContactlessRepTimestamp != null) {
        final int overrideDeltaMs =
            now.difference(_lastContactlessRepTimestamp!).inMilliseconds;
        if (overrideDeltaMs >= 0 && overrideDeltaMs < contactlessDebounceMs) {
          return false;
        }
      } else if (_contactlessDebounceWatch.isRunning &&
          _contactlessDebounceWatch.elapsedMilliseconds <
              contactlessDebounceMs) {
        return false;
      } else if (_lastContactlessRepTimestamp != null) {
        final int elapsedMs =
            now.difference(_lastContactlessRepTimestamp!).inMilliseconds;
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
          'Répétition $nextReps/${snap.currentStep.targetReps} comptabilisée',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );

    if (nextReps >= snap.currentStep.targetReps &&
        !snap.currentStep.isTimedWork) {
      advanceToNextWorkoutStep();
    }
    return true;
  }

  /// Passe immédiatement à l'étape suivante en validant l'étape courante.
  void completeCurrentStepBatch() {
    final WorkoutLiveSnapshot? snap = liveWorkoutNotifier.value;
    if (snap == null) {
      return;
    }
    final int remainingReps = snap.currentStep.stage == WorkoutStepStage.mainWork
        ? math.max(0, snap.currentStep.targetReps - snap.completedRepsInStep)
        : 0;
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
      lastAudioCueBanner: 'Étape validée • Passage à la suite',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
    advanceToNextWorkoutStep();
  }

  /// Passe automatiquement à l'étape suivante ou ouvre l'écran de félicitations de fin de séance.
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
        lastAudioCueBanner: 'Bravo ! Séance terminée avec succès !',
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
          'Étape ${nextIndex + 1}/${snap.mission.steps.length} • ${nextStep.stage.bannerLabel}',
      selectedRpe: snap.selectedRpe,
    );
    HapticFeedback.lightImpact();
  }

  /// Change l'angle de vue du coach animé 3D/2.5D (3/4, Profil, Face).
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
      lastAudioCueBanner: 'Angle de vue : ${nextAngle.label}',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
  }

  /// Ajoute +15 secondes de récupération si l'utilisateur souhaite souffler un peu plus.
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
      lastAudioCueBanner: '+${safeExtra}s de récupération ajoutées',
      selectedRpe: snap.selectedRpe,
      txpBreakdown: snap.txpBreakdown,
    );
  }

  /// Met à jour le ressenti d'effort (1 à 5) en fin de séance et recalcule les points gagnés.
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

  /// Calcule les points d'expérience et de motivation gagnés en fin de séance.
  TxpBreakdown computeTxpBreakdown({
    required TacticalMission mission,
    required int totalValidatedReps,
    required int rpeScore,
  }) {
    final int clampedRpe = rpeScore.clamp(1, 5);
    final int baseTxp =
        (mission.isRecoveryDay ||
            mission.format == WorkoutFormatType.flashPt5Min)
        ? 80
        : 100;
    final double tierCoeff = mission.recommendedTier.txpCoefficient;
    final int volumeTxp = (math.max(0, totalValidatedReps) * 2 * tierCoeff)
        .round();
    final int durationTxp = math.max(6, mission.durationMinutes) * 10;
    const int rampH2fBonusTxp = 100; // Échauffement + Retour au calme complets

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
        'Séance très facile : +2 répétitions par série prévues demain pour progresser en douceur.',
      2 =>
        'Bon confort : +1 répétition par série demain pour continuer sur cette belle lancée.',
      3 =>
        'Rythme idéal : progression régulière et équilibrée maintenue pour demain.',
      4 =>
        'Belle séance soutenue : on consolide ce niveau demain avec un repos confortable.',
      _ =>
        'Séance intense : demain, séance plus douce (-20 %) pour ménager tes articulations.',
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

  /// Résout le niveau atteint selon les XP cumulés et les défis validés.
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
        break;
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

  /// Valide la séance terminée, ajuste en douceur la séance du lendemain selon le ressenti,
  /// met à jour le temps total d'entraînement, la série de jours et le calendrier 28 jours.
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
          updatedTiers[fam] ?? DifficultyTier.tier1Recruit;
      int adapted = (currentRep * (1.0 + gamma) + delta).round().clamp(5, 40);

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
        final DifficultyTier prevTier = DifficultyTier.values[curTier.index - 1];
        updatedTiers[fam] = prevTier;
        adapted = (_masteryRepThresholdForTier(prevTier) * 0.75)
            .round()
            .clamp(6, 20);
      }

      updatedQuotas[fam] = adapted;
    });

    final int nextPushQuota = updatedQuotas[BiomechanicalFamily.upperPush] ?? 12;
    final int nextPullQuota = updatedQuotas[BiomechanicalFamily.noBarPull] ?? 12;
    if (_profile.posturalBalanceRatio < 0.85 && nextPullQuota < nextPushQuota) {
      updatedQuotas[BiomechanicalFamily.noBarPull] = nextPushQuota;
    }

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
          (updatedVolumes[fam] ?? 0) + (gained > 0 ? gained : 10);
    }

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
        extraConstancyTxp = 250;
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
      totalMinutesTrained:
          _profile.totalMinutesTrained + snap.mission.durationMinutes,
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

  /// Ferme le lecteur de séance sans modifier l'historique existant.
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
