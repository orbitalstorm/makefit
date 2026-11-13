import 'package:flutter/material.dart';

/// Les 5 familles biomécaniques fondamentales 100 % sans matériel.
enum BiomechanicalFamily {
  upperPush(
    code: 'PUSH',
    label: 'Poussée Tactique',
    shortLabel: 'PUSH',
    accentColor: Color(0xFFF59E0B),
  ),
  noBarPull(
    code: 'PULL',
    label: 'Tirage au Sol & Scapula',
    shortLabel: 'NO-BAR PULL',
    accentColor: Color(0xFF06B6D4),
  ),
  tacticalLegs(
    code: 'LEGS',
    label: 'Membres Inférieurs',
    shortLabel: 'LEGS',
    accentColor: Color(0xFF10B981),
  ),
  ironCore(
    code: 'CORE',
    label: 'Gainage Anti-Rotation',
    shortLabel: 'IRON CORE',
    accentColor: Color(0xFF8B5CF6),
  ),
  metCon(
    code: 'METCON',
    label: 'Cardio Métabolique',
    shortLabel: 'METCON',
    accentColor: Color(0xFFEF4444),
  );

  const BiomechanicalFamily({
    required this.code,
    required this.label,
    required this.shortLabel,
    required this.accentColor,
  });

  final String code;
  final String label;
  final String shortLabel;
  final Color accentColor;
}

/// Les 5 échelons de difficulté biomécanique (Tiers 1 à 5).
enum DifficultyTier {
  tier1Recruit(
    level: 1,
    code: 'T1',
    title: 'Échelon 1 — Recrue',
    shortTitle: 'Tier 1 • Recrue',
    txpCoefficient: 1.0,
  ),
  tier2Soldier(
    level: 2,
    code: 'T2',
    title: 'Échelon 2 — Soldat',
    shortTitle: 'Tier 2 • Soldat',
    txpCoefficient: 1.2,
  ),
  tier3Nco(
    level: 3,
    code: 'T3',
    title: 'Échelon 3 — Sous-Officier',
    shortTitle: 'Tier 3 • Sous-Off',
    txpCoefficient: 1.5,
  ),
  tier4Officer(
    level: 4,
    code: 'T4',
    title: 'Échelon 4 — Officier',
    shortTitle: 'Tier 4 • Officier',
    txpCoefficient: 1.8,
  ),
  tier5SpecOps(
    level: 5,
    code: 'T5',
    title: 'Échelon 5 — SpecOps',
    shortTitle: 'Tier 5 • SpecOps',
    txpCoefficient: 2.2,
  );

  const DifficultyTier({
    required this.level,
    required this.code,
    required this.title,
    required this.shortTitle,
    required this.txpCoefficient,
  });

  final int level;
  final String code;
  final String title;
  final String shortTitle;
  final double txpCoefficient;
}

/// Les 5 formats de routines simples ("Zero-Friction").
enum WorkoutFormatType {
  flashPt5Min(
    code: 'FLASH_PT',
    title: 'Flash PT & Mobilité',
    subtitle: '5 min • Réveil articulaire & maintien Streak',
    defaultMinutes: 5,
    txpMultiplier: 1.00,
    accentColor: Color(0xFF10B981),
  ),
  emomOperational(
    code: 'EMOM',
    title: 'EMOM Opérationnel',
    subtitle: '10–20 min • Départ chaque minute au bip',
    defaultMinutes: 14,
    txpMultiplier: 1.10,
    accentColor: Color(0xFFF59E0B),
  ),
  amrapHighDensity(
    code: 'AMRAP',
    title: 'AMRAP Haute Densité',
    subtitle: '12–18 min • Max de tours Push/Pull/Legs/Core',
    defaultMinutes: 12,
    txpMultiplier: 1.15,
    accentColor: Color(0xFF06B6D4),
  ),
  tacticalPyramid(
    code: 'PYRAMID',
    title: 'Pyramide Tactique 1→N→1',
    subtitle: '15–25 min • Échelle commando 1:2:3:4',
    defaultMinutes: 18,
    txpMultiplier: 1.20,
    accentColor: Color(0xFF8B5CF6),
  ),
  tabataHiit(
    code: 'TABATA',
    title: 'Tabata / Intervalle 40s/20s',
    subtitle: '12–16 min • 100 % guidé au bip sans compter',
    defaultMinutes: 12,
    txpMultiplier: 1.05,
    accentColor: Color(0xFFEF4444),
  );

  const WorkoutFormatType({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.defaultMinutes,
    required this.txpMultiplier,
    required this.accentColor,
  });

  final String code;
  final String title;
  final String subtitle;
  final int defaultMinutes;
  final double txpMultiplier;
  final Color accentColor;
}

/// Les 12 Grades Militaires officiels de MakeFit (`E-1` à `SF-2`).
enum MilitaryRank {
  e1Recruit(
    order: 1,
    code: 'E-1',
    title: 'Recrue',
    corps: 'Enrôlé (Enlisted)',
    minTxp: 0,
    requiresTrial: false,
    unlockedReward: 'Opération 01 Basic Bootcamp & Codex T1',
  ),
  e2Private(
    order: 2,
    code: 'E-2',
    title: 'Soldat',
    corps: 'Enrôlé (Enlisted)',
    minTxp: 1200,
    requiresTrial: false,
    unlockedReward: 'Générateur EMOM & Tabata débloqué',
  ),
  e3Corporal(
    order: 3,
    code: 'E-3',
    title: 'Caporal',
    corps: 'Enrôlé (Enlisted)',
    minTxp: 3500,
    requiresTrial: true,
    unlockedReward: 'Échelon 2 Skill Tree & Pyramide 1→5→1',
  ),
  e4Sergeant(
    order: 4,
    code: 'E-4',
    title: 'Sergent',
    corps: 'Enrôlé (Enlisted)',
    minTxp: 7000,
    requiresTrial: false,
    unlockedReward: '2e Jeton de Permission Tactique (Dog Tag)',
  ),
  e5StaffSergeant(
    order: 5,
    code: 'E-5',
    title: 'Sergent-Chef',
    corps: 'Sous-Officier (NCO)',
    minTxp: 12000,
    requiresTrial: true,
    unlockedReward: 'Échelon 3 Skill Tree & Opération 02 Silent Recon',
  ),
  e6WarrantOfficer(
    order: 6,
    code: 'E-6',
    title: 'Adjudant',
    corps: 'Sous-Officier (NCO)',
    minTxp: 18500,
    requiresTrial: false,
    unlockedReward: 'HUD Night Vision Emerald & Pyramide 1→7→1',
  ),
  e7MasterSergeant(
    order: 7,
    code: 'E-7',
    title: 'Major',
    corps: 'Sous-Officier (NCO)',
    minTxp: 27000,
    requiresTrial: false,
    unlockedReward: 'Opération 03 Airborne Conditioning',
  ),
  o1Lieutenant(
    order: 8,
    code: 'O-1',
    title: 'Lieutenant',
    corps: 'Officier (Officer)',
    minTxp: 38000,
    requiresTrial: true,
    unlockedReward: 'Échelon 4 Skill Tree (Archer, Sliding Floor Pull)',
  ),
  o2Captain(
    order: 9,
    code: 'O-2',
    title: 'Capitaine',
    corps: 'Officier (Officer)',
    minTxp: 52000,
    requiresTrial: false,
    unlockedReward: 'Constructeur de Missions Sur-Mesure',
  ),
  o3Major(
    order: 10,
    code: 'O-3',
    title: 'Commandant',
    corps: 'Officier (Officer)',
    minTxp: 70000,
    requiresTrial: false,
    unlockedReward: 'Opération 04 SpecOps Selection & Pyramide 1→10→1',
  ),
  sf1Operator(
    order: 11,
    code: 'SF-1',
    title: 'Opérateur',
    corps: 'Forces Spéciales (SpecOps)',
    minTxp: 95000,
    requiresTrial: true,
    unlockedReward: 'Échelon 5 Élite (Pistol Squat, One-Arm Push-up)',
  ),
  sf2TacticalLegend(
    order: 12,
    code: 'SF-2',
    title: 'Légende Tactique',
    corps: 'Forces Spéciales (SpecOps)',
    minTxp: 130000,
    requiresTrial: false,
    unlockedReward: 'Insigne Or/Carbone Animé & Prestige Infini',
  );

  const MilitaryRank({
    required this.order,
    required this.code,
    required this.title,
    required this.corps,
    required this.minTxp,
    required this.requiresTrial,
    required this.unlockedReward,
  });

  final int order;
  final String code;
  final String title;
  final String corps;
  final int minTxp;
  final bool requiresTrial;
  final String unlockedReward;

  MilitaryRank? get nextRank {
    final int nextIndex = index + 1;
    if (nextIndex >= MilitaryRank.values.length) {
      return null;
    }
    return MilitaryRank.values[nextIndex];
  }
}

/// Groupes musculaires mis en surbrillance thermique sur le mannequin anatomique.
enum MuscleGroup {
  pectorals('Grand Pectoral'),
  anteriorDeltoid('Deltoïde Antérieur'),
  lateralDeltoid('Deltoïde Moyen'),
  posteriorDeltoid('Deltoïde Postérieur'),
  triceps('Triceps Brachial'),
  bicepsForearms('Biceps & Avant-Bras'),
  rhomboidsTraps('Rhomboïdes & Trapèzes'),
  latissimusDorsi('Grand Dorsal'),
  erectorSpinae('Érecteurs du Rachis'),
  rectusAbdominis('Grand Droit & Transverse'),
  obliques('Obliques Anti-Rotation'),
  glutes('Grand & Moyen Fessiers'),
  quadriceps('Quadriceps Fémoral'),
  hamstrings('Ischio-Jambiers'),
  calves('Triceps Sural (Mollets)');

  const MuscleGroup(this.label);
  final String label;
}

/// Mode d'adaptation articulaire en 1 clic (Store Guideline 1.4.1).
enum JointFriendlyMode {
  standard('Standard Opérationnel'),
  wristFriendly('Protection Poignets (Poings / Avant-Bras)'),
  kneeFriendly('Protection Genoux (Sans Flexion Profonde)');

  const JointFriendlyMode(this.label);
  final String label;
}

/// Angle de caméra du mannequin biomécanique 3D/Vectoriel.
enum MannequinCameraAngle {
  threeQuarterTactical('3/4 Tactique'),
  sideProfile('Profil Biomécanique'),
  frontSymmetry('Face & Scapula');

  const MannequinCameraAngle(this.label);
  final String label;
}

/// Type de posture/cinématique animée par le Mannequin Anatomique 60 FPS.
enum MannequinMotionKind {
  pushupStrict,
  pushupIncline,
  pushupPike,
  pushupArcher,
  pushupOneArm,
  proneCobra,
  proneIytw,
  supineElbowPress,
  slidingFloorPull,
  thoracicBridge,
  airSquat,
  reverseLunge,
  cossackSquat,
  pistolSquat,
  deadBug,
  rkcPlank,
  hollowBodyHold,
  tacticalVUp,
  floorLSit,
  stepJacks,
  jumpingJacks,
  militaryBurpee,
  sealBodybuilder,
  rampMobility,
  boxBreathingH2f,
}

/// Spécification immuable d'un exercice sans matériel MakeFit.
@immutable
class TacticalExercise {
  const TacticalExercise({
    required this.id,
    required this.code,
    required this.name,
    required this.family,
    required this.tier,
    required this.motionKind,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.tempo,
    required this.defaultTargetReps,
    required this.defaultHoldSeconds,
    required this.isIsometric,
    required this.isPlyometric,
    required this.hudCues,
    required this.biomechanicalInstructions,
    required this.commonMistake,
    required this.stealthVariantName,
    required this.stealthVariantDescription,
    required this.wristKneeVariantName,
    required this.wristKneeVariantDescription,
    required this.masteryStandardLabel,
  });

  final String id;
  final String code;
  final String name;
  final BiomechanicalFamily family;
  final DifficultyTier tier;
  final MannequinMotionKind motionKind;
  final List<MuscleGroup> primaryMuscles;
  final List<MuscleGroup> secondaryMuscles;
  final String tempo;
  final int defaultTargetReps;
  final int defaultHoldSeconds;
  final bool isIsometric;
  final bool isPlyometric;
  final List<String> hudCues;
  final List<String> biomechanicalInstructions;
  final String commonMistake;
  final String stealthVariantName;
  final String stealthVariantDescription;
  final String wristKneeVariantName;
  final String wristKneeVariantDescription;
  final String masteryStandardLabel;

  String effectiveName({
    required bool stealthMode,
    required JointFriendlyMode jointMode,
  }) {
    if (jointMode != JointFriendlyMode.standard) {
      return wristKneeVariantName;
    }
    if (stealthMode && isPlyometric) {
      return stealthVariantName;
    }
    return name;
  }
}

/// Phase d'une étape de séance.
enum WorkoutStepStage {
  rampWarmup('ÉCHAUFFEMENT RAMP (3 MIN)', Color(0xFF10B981)),
  mainWork('EFFORT OPÉRATIONNEL', Color(0xFFF59E0B)),
  restRecovery('REPOS & RESPIRATION', Color(0xFF06B6D4)),
  h2fCooldown('DÉCOMPRESSION H2F & BOX BREATHING', Color(0xFF10B981));

  const WorkoutStepStage(this.bannerLabel, this.color);
  final String bannerLabel;
  final Color color;
}

/// Étape élémentaire dans la machine à états d'une séance.
@immutable
class WorkoutStationStep {
  const WorkoutStationStep({
    required this.stage,
    required this.title,
    required this.subtitle,
    required this.exercise,
    required this.durationSeconds,
    required this.targetReps,
    required this.isTimedWork,
    required this.roundIndex,
    required this.totalRounds,
  });

  final WorkoutStepStage stage;
  final String title;
  final String subtitle;
  final TacticalExercise exercise;
  final int durationSeconds;
  final int targetReps;
  final bool isTimedWork;
  final int roundIndex;
  final int totalRounds;
}

/// Identifiant des 4 Campagnes Opérationnelles de 28 Jours.
enum OperationalCampaignId {
  op1BasicBootcamp(
    code: 'OP-01',
    title: 'Opération 01 : Basic Bootcamp',
    subtitle: '28 Jours • Fondations Posturales, Gainage & Habitude (10–15 min/j)',
    thumbnailAsset: 'assets/branding/thumbnails/thumb_op1_basic_bootcamp.png',
    recommendedTier: DifficultyTier.tier1Recruit,
    accentColor: Color(0xFF10B981),
    isStealthDefault: false,
  ),
  op2SilentRecon(
    code: 'OP-02',
    title: 'Opération 02 : Silent Recon',
    subtitle: '28 Jours • Spécial Appartement Zéro Saut, Tempo Lent & Isométrie (15 min/j)',
    thumbnailAsset: 'assets/branding/thumbnails/thumb_op2_silent_recon.png',
    recommendedTier: DifficultyTier.tier2Soldier,
    accentColor: Color(0xFF06B6D4),
    isStealthDefault: true,
  ),
  op3AirborneConditioning(
    code: 'OP-03',
    title: 'Opération 03 : Airborne Conditioning',
    subtitle: '28 Jours • Haute Densité EMOM/AMRAP & Endurance Cardio (20 min/j)',
    thumbnailAsset: 'assets/branding/thumbnails/thumb_op3_airborne_conditioning.png',
    recommendedTier: DifficultyTier.tier3Nco,
    accentColor: Color(0xFFF59E0B),
    isStealthDefault: false,
  ),
  op4SpecOpsSelection(
    code: 'OP-04',
    title: 'Opération 04 : SpecOps Selection',
    subtitle: '28 Jours • Pyramides Lourdes 1→10→1, Force Unilatérale & Mental (25–30 min/j)',
    thumbnailAsset: 'assets/branding/thumbnails/thumb_op4_specops_selection.png',
    recommendedTier: DifficultyTier.tier4Officer,
    accentColor: Color(0xFFEF4444),
    isStealthDefault: false,
  );

  const OperationalCampaignId({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.thumbnailAsset,
    required this.recommendedTier,
    required this.accentColor,
    required this.isStealthDefault,
  });

  final String code;
  final String title;
  final String subtitle;
  final String thumbnailAsset;
  final DifficultyTier recommendedTier;
  final Color accentColor;
  final bool isStealthDefault;
}

/// Mission d'entraînement complète (Campagne J1..J28, Routine Rapide ou Examen PT).
@immutable
class TacticalMission {
  const TacticalMission({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.format,
    required this.durationMinutes,
    required this.recommendedTier,
    required this.targetRpe,
    required this.steps,
    this.campaignId,
    this.dayNumber,
    this.isRecoveryDay = false,
    this.isBossMission = false,
    this.promotionTrialRank,
  });

  final String id;
  final String code;
  final String title;
  final String subtitle;
  final WorkoutFormatType format;
  final int durationMinutes;
  final DifficultyTier recommendedTier;
  final int targetRpe;
  final List<WorkoutStationStep> steps;
  final OperationalCampaignId? campaignId;
  final int? dayNumber;
  final bool isRecoveryDay;
  final bool isBossMission;
  final MilitaryRank? promotionTrialRank;
}

/// Spécification d'un Examen PT de Promotion (6 minutes).
@immutable
class PromotionTrialSpec {
  const PromotionTrialSpec({
    required this.targetRank,
    required this.code,
    required this.title,
    required this.bonusTxp,
    required this.block1Description,
    required this.block2Description,
    required this.block3Description,
    required this.stealthAdaptationNote,
    required this.mission,
  });

  final MilitaryRank targetRank;
  final String code;
  final String title;
  final int bonusTxp;
  final String block1Description;
  final String block2Description;
  final String block3Description;
  final String stealthAdaptationNote;
  final TacticalMission mission;
}

/// Résultat mathématique du Test PT Initial de Calibration (6 min — IAO sur 100).
@immutable
class BaselinePtCalibrationResult {
  const BaselinePtCalibrationResult({
    required this.pushScore,
    required this.legsScore,
    required this.coreScore,
    required this.iaoGlobalIndex,
    required this.recommendedFamilyTiers,
    required this.initialUnlockedRank,
  });

  final int pushScore;
  final int legsScore;
  final int coreScore;
  final int iaoGlobalIndex;
  final Map<BiomechanicalFamily, DifficultyTier> recommendedFamilyTiers;
  final MilitaryRank initialUnlockedRank;
}

/// Décomposition déterministe des TXP gagnés en fin de séance.
@immutable
class TxpBreakdown {
  const TxpBreakdown({
    required this.baseTxp,
    required this.volumeTxp,
    required this.durationTxp,
    required this.rampH2fBonusTxp,
    required this.streakMultiplier,
    required this.formatMultiplier,
    required this.rpeHonestyBonusTxp,
    required this.trialBonusTxp,
    required this.totalTxp,
    required this.nextSessionAdjustmentNote,
    this.promotedToRank,
  });

  final int baseTxp;
  final int volumeTxp;
  final int durationTxp;
  final int rampH2fBonusTxp;
  final double streakMultiplier;
  final double formatMultiplier;
  final int rpeHonestyBonusTxp;
  final int trialBonusTxp;
  final int totalTxp;
  final String nextSessionAdjustmentNote;
  final MilitaryRank? promotedToRank;
}

/// Phase temps réel de la séance dans le WorkoutPlayerModal.
enum WorkoutExecutionPhase {
  briefing,
  activeStep,
  paused,
  debriefingVictory,
}

/// Phase respiratoire du Box Breathing Navy SEAL (`4s - 4s - 4s - 4s`).
enum BoxBreathingPhase {
  inhale('INSPIRATION NASALE (4S)', Color(0xFF06B6D4)),
  holdFull('APNÉE POUMONS PLEINS (4S)', Color(0xFF10B981)),
  exhale('EXPIRATION LENTE (4S)', Color(0xFFF59E0B)),
  holdEmpty('APNÉE POUMONS VIDES (4S)', Color(0xFF8B5CF6));

  const BoxBreathingPhase(this.instruction, this.color);
  final String instruction;
  final Color color;
}

/// Snapshot immuable à 60 Hz pilotant le HUD de séance (lisible à 2 mètres).
@immutable
class WorkoutLiveSnapshot {
  const WorkoutLiveSnapshot({
    required this.mission,
    required this.phase,
    required this.currentStepIndex,
    required this.stepRemainingSeconds,
    required this.stepElapsedSeconds,
    required this.totalElapsedSeconds,
    required this.completedRepsInStep,
    required this.totalValidatedReps,
    required this.animationCyclePhase,
    required this.stealthModeActive,
    required this.jointFriendlyMode,
    required this.cameraAngle,
    required this.audioDuckingActive,
    required this.lastAudioCueBanner,
    required this.selectedRpe,
    this.txpBreakdown,
  });

  final TacticalMission mission;
  final WorkoutExecutionPhase phase;
  final int currentStepIndex;
  final int stepRemainingSeconds;
  final int stepElapsedSeconds;
  final int totalElapsedSeconds;
  final int completedRepsInStep;
  final int totalValidatedReps;
  final double animationCyclePhase;
  final bool stealthModeActive;
  final JointFriendlyMode jointFriendlyMode;
  final MannequinCameraAngle cameraAngle;
  final bool audioDuckingActive;
  final String lastAudioCueBanner;
  final int selectedRpe;
  final TxpBreakdown? txpBreakdown;

  WorkoutStationStep get currentStep =>
      mission.steps[currentStepIndex.clamp(0, mission.steps.length - 1)];

  double get stepProgress {
    final int total = currentStep.durationSeconds <= 0
        ? 1
        : currentStep.durationSeconds;
    return (stepElapsedSeconds / total).clamp(0.0, 1.0);
  }

  double get overallMissionProgress {
    if (mission.steps.isEmpty) {
      return 1.0;
    }
    return ((currentStepIndex + stepProgress) / mission.steps.length).clamp(
      0.0,
      1.0,
    );
  }

  BoxBreathingPhase get currentBoxBreathingPhase {
    final int cycleSecond = stepElapsedSeconds % 16;
    if (cycleSecond < 4) {
      return BoxBreathingPhase.inhale;
    } else if (cycleSecond < 8) {
      return BoxBreathingPhase.holdFull;
    } else if (cycleSecond < 12) {
      return BoxBreathingPhase.exhale;
    }
    return BoxBreathingPhase.holdEmpty;
  }
}

/// État immuable complet du Profil Soldat (persisté hors-ligne).
@immutable
class SoldierProfileState {
  const SoldierProfileState({
    required this.callsign,
    required this.rank,
    required this.totalTxp,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.tacticalLeavePasses,
    required this.sessionsTowardsNextPass,
    required this.completedSessionsCount,
    required this.stealthApartmentMode,
    required this.jointFriendlyMode,
    required this.familyTiers,
    required this.familyRepQuotas,
    required this.completedMissionIds,
    required this.passedTrialRanks,
    required this.weeklyFamilyVolumes,
    required this.lastRpeScore,
    required this.iaoCalibrationScore,
    required this.medicalDisclaimerAccepted,
    required this.activeCampaignId,
    required this.currentCampaignDay,
    required this.activityHeatmap28Days,
  });

  final String callsign;
  final MilitaryRank rank;
  final int totalTxp;
  final int currentStreakDays;
  final int bestStreakDays;
  final int tacticalLeavePasses;
  final int sessionsTowardsNextPass;
  final int completedSessionsCount;
  final bool stealthApartmentMode;
  final JointFriendlyMode jointFriendlyMode;
  final Map<BiomechanicalFamily, DifficultyTier> familyTiers;
  final Map<BiomechanicalFamily, int> familyRepQuotas;
  final Set<String> completedMissionIds;
  final Set<MilitaryRank> passedTrialRanks;
  final Map<BiomechanicalFamily, int> weeklyFamilyVolumes;
  final int lastRpeScore;
  final int iaoCalibrationScore;
  final bool medicalDisclaimerAccepted;
  final OperationalCampaignId activeCampaignId;
  final int currentCampaignDay;
  final List<int> activityHeatmap28Days;

  /// Ratio d'équilibre postural Push / Pull sur 7 jours (Cible optimale : 0.85 à 1.15).
  double get posturalBalanceRatio {
    final int pushVol = weeklyFamilyVolumes[BiomechanicalFamily.upperPush] ?? 1;
    final int pullVol = weeklyFamilyVolumes[BiomechanicalFamily.noBarPull] ?? 1;
    if (pushVol <= 0) {
      return 1.0;
    }
    return pullVol / pushVol;
  }

  /// Progression 0.0 -> 1.0 vers le prochain grade militaire.
  double get progressToNextRank {
    final MilitaryRank? next = rank.nextRank;
    if (next == null) {
      return 1.0;
    }
    final int span = next.minTxp - rank.minTxp;
    if (span <= 0) {
      return 1.0;
    }
    return ((totalTxp - rank.minTxp) / span).clamp(0.0, 1.0);
  }

  /// Indique si un Examen PT de Promotion est disponible dès maintenant.
  MilitaryRank? get pendingPromotionTrialRank {
    final MilitaryRank? next = rank.nextRank;
    if (next != null &&
        next.requiresTrial &&
        totalTxp >= next.minTxp &&
        !passedTrialRanks.contains(next)) {
      return next;
    }
    return null;
  }

  SoldierProfileState copyWith({
    String? callsign,
    MilitaryRank? rank,
    int? totalTxp,
    int? currentStreakDays,
    int? bestStreakDays,
    int? tacticalLeavePasses,
    int? sessionsTowardsNextPass,
    int? completedSessionsCount,
    bool? stealthApartmentMode,
    JointFriendlyMode? jointFriendlyMode,
    Map<BiomechanicalFamily, DifficultyTier>? familyTiers,
    Map<BiomechanicalFamily, int>? familyRepQuotas,
    Set<String>? completedMissionIds,
    Set<MilitaryRank>? passedTrialRanks,
    Map<BiomechanicalFamily, int>? weeklyFamilyVolumes,
    int? lastRpeScore,
    int? iaoCalibrationScore,
    bool? medicalDisclaimerAccepted,
    OperationalCampaignId? activeCampaignId,
    int? currentCampaignDay,
    List<int>? activityHeatmap28Days,
  }) {
    return SoldierProfileState(
      callsign: callsign ?? this.callsign,
      rank: rank ?? this.rank,
      totalTxp: totalTxp ?? this.totalTxp,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      bestStreakDays: bestStreakDays ?? this.bestStreakDays,
      tacticalLeavePasses: tacticalLeavePasses ?? this.tacticalLeavePasses,
      sessionsTowardsNextPass:
          sessionsTowardsNextPass ?? this.sessionsTowardsNextPass,
      completedSessionsCount:
          completedSessionsCount ?? this.completedSessionsCount,
      stealthApartmentMode: stealthApartmentMode ?? this.stealthApartmentMode,
      jointFriendlyMode: jointFriendlyMode ?? this.jointFriendlyMode,
      familyTiers: familyTiers ?? this.familyTiers,
      familyRepQuotas: familyRepQuotas ?? this.familyRepQuotas,
      completedMissionIds: completedMissionIds ?? this.completedMissionIds,
      passedTrialRanks: passedTrialRanks ?? this.passedTrialRanks,
      weeklyFamilyVolumes: weeklyFamilyVolumes ?? this.weeklyFamilyVolumes,
      lastRpeScore: lastRpeScore ?? this.lastRpeScore,
      iaoCalibrationScore: iaoCalibrationScore ?? this.iaoCalibrationScore,
      medicalDisclaimerAccepted:
          medicalDisclaimerAccepted ?? this.medicalDisclaimerAccepted,
      activeCampaignId: activeCampaignId ?? this.activeCampaignId,
      currentCampaignDay: currentCampaignDay ?? this.currentCampaignDay,
      activityHeatmap28Days:
          activityHeatmap28Days ?? this.activityHeatmap28Days,
    );
  }
}
