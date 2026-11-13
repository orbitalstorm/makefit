import 'dart:math' as math;
import '../models/makefit_models.dart';

/// Catalogue scientifique complet MakeFit (25 Exercices 100 % Sans Matériel,
/// Protocoles RAMP/H2F, 4 Campagnes de 28 Jours, 5 Formats Rapides & 4 Examens PT).
class MakeFitCatalog {
  const MakeFitCatalog._();

  /// Les 25 exercices fondamentaux (5 Familles × 5 Échelons).
  static const List<TacticalExercise> allExercises = <TacticalExercise>[
    // 1. UPPER PUSH (T1 -> T5)
    TacticalExercise(
      id: 'ex_push_t1',
      code: 'EX_PUSH_T1',
      name: 'Incline / Knee Tactical Push-up',
      family: BiomechanicalFamily.upperPush,
      tier: DifficultyTier.tier1Recruit,
      motionKind: MannequinMotionKind.pushupIncline,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.pectorals,
        MuscleGroup.triceps,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.anteriorDeltoid,
        MuscleGroup.rectusAbdominis,
      ],
      tempo: '3-1-1-0',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['COUDES À 45°', 'BASSIN VERROUILLÉ', 'POITRINE AU SUPPORT'],
      biomechanicalInstructions: <String>[
        'Placer les mains largeur d\'épaules sur rebord stable ou genoux au sol avec bassin en rétroversion.',
        'Visser les paumes pour abaisser les épaules loin des oreilles.',
        'Descendre en 3s coudes à 45° puis repousser avec protraction scapulaire.',
      ],
      commonMistake: 'Cambrure lombaire ou coudes ouverts à 90° en T.',
      stealthVariantName: 'Incline Tactical Push-up (0 dB)',
      stealthVariantDescription: 'Mouvement intrinsèquement silencieux au tempo 3-1-1-0.',
      wristKneeVariantName: 'Wall / Knuckle Incline Push-up',
      wristKneeVariantDescription: 'Mains contre un mur debout ou sur les poings neutres.',
      masteryStandardLabel: '3 × 15 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_push_t2',
      code: 'EX_PUSH_T2',
      name: 'Military Strict Push-up (FM 7-22)',
      family: BiomechanicalFamily.upperPush,
      tier: DifficultyTier.tier2Soldier,
      motionKind: MannequinMotionKind.pushupStrict,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.pectorals,
        MuscleGroup.triceps,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.anteriorDeltoid,
        MuscleGroup.rectusAbdominis,
        MuscleGroup.glutes,
      ],
      tempo: '2-1-1-0',
      defaultTargetReps: 15,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['CORPS EN PLANCHE', 'COUDES À 45°', 'EXTENSION COMPLÈTE'],
      biomechanicalInstructions: <String>[
        'Planche haute stricte, pieds joints ou largeur de hanches, fessiers et quadriceps contractés.',
        'Fléchir les coudes à 45° jusqu\'à 2 cm du sol, regard à 50 cm devant les mains.',
        'Repousser explosivement jusqu\'au verrouillage complet des coudes.',
      ],
      commonMistake: 'Ondulation lombaire (worming) ou tête qui plonge vers le sol.',
      stealthVariantName: 'Military Strict Push-up (0 dB)',
      stealthVariantDescription: 'Exécution contrôlée zéro impact sonore.',
      wristKneeVariantName: 'Neutral Knuckle Military Push-up',
      wristKneeVariantDescription: 'Sur les poings fermés (poignets droits alignés avec le radius).',
      masteryStandardLabel: '3 × 20 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_push_t3',
      code: 'EX_PUSH_T3',
      name: 'Diamond & Pike Push-up',
      family: BiomechanicalFamily.upperPush,
      tier: DifficultyTier.tier3Nco,
      motionKind: MannequinMotionKind.pushupPike,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.triceps,
        MuscleGroup.anteriorDeltoid,
        MuscleGroup.lateralDeltoid,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.pectorals,
        MuscleGroup.rhomboidsTraps,
      ],
      tempo: '2-1-1-1',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['TRIANGLE TÊTE-MAINS', 'COUDES SERRÉS', 'POUSSÉE VERTICALE'],
      biomechanicalInstructions: <String>[
        'En Pike : bassin fléchi en V inversé (~90°), talons hauts.',
        'Descendre le sommet du crâne en avant des mains pour former un triangle équilatéral.',
        'Repousser dans l\'axe vertical avec élévation scapulaire active en haut.',
      ],
      commonMistake: 'Descendre la tête entre les mains au lieu de devant les mains.',
      stealthVariantName: 'Strict Tempo Pike Push-up',
      stealthVariantDescription: 'Contrôle excentrique 3s sans rebond.',
      wristKneeVariantName: 'Close-Grip Neutral Fist Push-up',
      wristKneeVariantDescription: 'Largeur bi-acromiale sur les poings pour supprimer la déviation ulnaire.',
      masteryStandardLabel: '3 × 15 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_push_t4',
      code: 'EX_PUSH_T4',
      name: 'Archer & Pseudo-Planche Push-up',
      family: BiomechanicalFamily.upperPush,
      tier: DifficultyTier.tier4Officer,
      motionKind: MannequinMotionKind.pushupArcher,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.pectorals,
        MuscleGroup.anteriorDeltoid,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.triceps,
        MuscleGroup.bicepsForearms,
        MuscleGroup.obliques,
      ],
      tempo: '3-1-1-1',
      defaultTargetReps: 10,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['BRAS D\'APPUI 75%', 'BRAS GUIDE TENDU', 'ÉPAULES EN AVANT'],
      biomechanicalInstructions: <String>[
        'Mains écartées à 1.5× la largeur d\'épaules, doigts orientés à 45°.',
        'Fléchir un bras en portant 75 % de la masse corporelle dessus, l\'autre bras tendu en stabilisateur.',
        'Alterner droite et gauche en maintenant le bassin parfaitement parallèle au sol.',
      ],
      commonMistake: 'Rotation du bassin vers le bras tendu.',
      stealthVariantName: 'Archer Tempo Push-up (3-2-1-0)',
      stealthVariantDescription: 'Remplace toute pompe claquée pliométrique par une tension mécanique pure.',
      wristKneeVariantName: 'Externally Rotated Pseudo-Planche (90°)',
      wristKneeVariantDescription: 'Doigts tournés sur les côtés pour supprimer le pincement dorsal du carpe.',
      masteryStandardLabel: '3 × 12 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_push_t5',
      code: 'EX_PUSH_T5',
      name: 'Strict One-Arm / Wall HSPU',
      family: BiomechanicalFamily.upperPush,
      tier: DifficultyTier.tier5SpecOps,
      motionKind: MannequinMotionKind.pushupOneArm,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.pectorals,
        MuscleGroup.anteriorDeltoid,
        MuscleGroup.triceps,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.obliques,
        MuscleGroup.glutes,
      ],
      tempo: '3-1-1-0',
      defaultTargetReps: 6,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['ÉPAULES PARALLÈLES', 'GAINAGE MAXIMAL', 'VERROUILLAGE HAUT'],
      biomechanicalInstructions: <String>[
        'Pieds écartés à 1.2× largeur d\'épaules, main d\'appui sous le sternum, main libre dans le bas du dos.',
        'Maintenir les deux épaules strictement parallèles au sol (0° de vrille thoracique).',
        'Descendre poitrine au sol en 3s puis repousser jusqu\'au verrouillage complet.',
      ],
      commonMistake: 'Vriller le buste à 45° et ouvrir le coude à 90°.',
      stealthVariantName: 'Silent One-Arm Push-up / Wall Walk HSPU',
      stealthVariantDescription: 'Montée et descente contrôlées sans impact contre le mur ou le sol.',
      wristKneeVariantName: 'Neutral Fist One-Arm / Pause Archer (3s)',
      wristKneeVariantDescription: 'Sur le poing neutre pour protéger le complexe fibro-cartilagineux (TFCC).',
      masteryStandardLabel: '3 × 6 reps/côté (RPE ≤ 3)',
    ),

    // 2. NO-BAR PULL & SCAPULA (T1 -> T5)
    TacticalExercise(
      id: 'ex_pull_t1',
      code: 'EX_PULL_T1',
      name: 'Prone Cobra Hold & Scapular Pinch',
      family: BiomechanicalFamily.noBarPull,
      tier: DifficultyTier.tier1Recruit,
      motionKind: MannequinMotionKind.proneCobra,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.rhomboidsTraps,
        MuscleGroup.posteriorDeltoid,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.erectorSpinae,
        MuscleGroup.glutes,
      ],
      tempo: '1-0-1-3',
      defaultTargetReps: 12,
      defaultHoldSeconds: 30,
      isIsometric: true,
      isPlyometric: false,
      hudCues: <String>['POUCES AU PLAFOND', 'OMOPLATES SERRÉES', 'NUQUE LONGUE'],
      biomechanicalInstructions: <String>[
        'Allongé sur le ventre, front à 3 cm du sol, menton rentré, fessiers contractés.',
        'Décoller les bras le long du corps, tourner les pouces vers le plafond (rotation externe humérale).',
        'Serrer les omoplates vers l\'arrière et vers le bas pendant 3s à chaque répétition.',
      ],
      commonMistake: 'Hausser les épaules vers les oreilles ou casser la nuque.',
      stealthVariantName: 'Prone Cobra Hold (0 dB)',
      stealthVariantDescription: 'Isométrie posturale 100 % silencieuse.',
      wristKneeVariantName: 'Standing Wall Angels / Thoracic Cobra',
      wristKneeVariantDescription: 'Zéro appui sur les poignets ni flexion des genoux.',
      masteryStandardLabel: '3 × 30s (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_pull_t2',
      code: 'EX_PULL_T2',
      name: 'Prone I-Y-T-W Scapular Raises',
      family: BiomechanicalFamily.noBarPull,
      tier: DifficultyTier.tier2Soldier,
      motionKind: MannequinMotionKind.proneIytw,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.rhomboidsTraps,
        MuscleGroup.posteriorDeltoid,
        MuscleGroup.latissimusDorsi,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.erectorSpinae,
        MuscleGroup.glutes,
      ],
      tempo: '2-0-1-2',
      defaultTargetReps: 16,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['SÉQUENCE I-Y-T-W', 'COUDES AUX CÔTES', 'ZÉRO ÉLAN'],
      biomechanicalInstructions: <String>[
        'Face au sol, fessiers verrouillés, former successivement les lettres I, Y, T et W sans reposer les mains.',
        'En W (Superman Pull) : tirer puissamment les coudes vers les côtes en serrant les dorsaux.',
        'Maintenir 2s de contraction isométrique à chaque position.',
      ],
      commonMistake: 'Utiliser l\'élan lombaire au lieu du glissement scapulaire.',
      stealthVariantName: 'Prone I-Y-T-W Raises (0 dB)',
      stealthVariantDescription: 'Contrôle scapulaire pur sans impact.',
      wristKneeVariantName: 'Prone I-Y-T-W (0 charge carpe/genou)',
      wristKneeVariantDescription: 'Aucune pression sur les poignets ou les genoux.',
      masteryStandardLabel: '3 × 16 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_pull_t3',
      code: 'EX_PULL_T3',
      name: 'Supine Elbow Press (Floor Back Widow)',
      family: BiomechanicalFamily.noBarPull,
      tier: DifficultyTier.tier3Nco,
      motionKind: MannequinMotionKind.supineElbowPress,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.latissimusDorsi,
        MuscleGroup.rhomboidsTraps,
        MuscleGroup.posteriorDeltoid,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.erectorSpinae,
        MuscleGroup.bicepsForearms,
      ],
      tempo: '2-0-1-2',
      defaultTargetReps: 15,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['POUSSE DANS LES COUDES', 'DÉCOLLE LES OMOPLATES', 'POITRINE HAUTE'],
      biomechanicalInstructions: <String>[
        'Allongé sur le dos, genoux fléchis, coudes au sol à 45° des côtes, poings vers le plafond.',
        'Pousser verticalement les coudes dans le sol pour décoller tout le haut du dos et les omoplates.',
        'Maintenir la contraction maximale du dos en haut pendant 2s puis redescendre en contrôle.',
      ],
      commonMistake: 'Pousser avec l\'arrière du crâne au lieu des coudes.',
      stealthVariantName: 'Supine Elbow Press (0 dB)',
      stealthVariantDescription: 'Traction verticale inversée au sol 100 % silencieuse.',
      wristKneeVariantName: 'Padded Supine Elbow Press (Poignets Neutres)',
      wristKneeVariantDescription: 'Zéro contrainte sur le poignet (appui exclusif sur l\'olécrane/humérus).',
      masteryStandardLabel: '3 × 15 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_pull_t4',
      code: 'EX_PULL_T4',
      name: 'Prone Forearm Sliding Floor Pull-up',
      family: BiomechanicalFamily.noBarPull,
      tier: DifficultyTier.tier4Officer,
      motionKind: MannequinMotionKind.slidingFloorPull,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.latissimusDorsi,
        MuscleGroup.bicepsForearms,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.rhomboidsTraps,
        MuscleGroup.posteriorDeltoid,
        MuscleGroup.rectusAbdominis,
      ],
      tempo: '3-1-2-1',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['ÉCRASE LE SOL', 'TIRE AVEC LES DORSAUX', 'ÉPAULES BASSES'],
      biomechanicalInstructions: <String>[
        'Allongé sur le ventre sur sol lisse (ou serviette sous le bassin), avant-bras posés loin devant.',
        'Presser fortement les avant-bras dans le sol et tracter le corps vers l\'avant par l\'adduction des dorsaux.',
        'Replacer les bras devant en contrôle excentrique de 3s.',
      ],
      commonMistake: 'Pousser avec les orteils au lieu de tracter avec les grands dorsaux.',
      stealthVariantName: 'Sliding Floor Pull-up (< 25 dB)',
      stealthVariantDescription: 'Glissement fluide et silencieux au sol.',
      wristKneeVariantName: 'Forearm Sliding Pull (Poignet à plat)',
      wristKneeVariantDescription: 'Appui réparti sur tout l\'avant-bras sans extension du poignet.',
      masteryStandardLabel: '3 × 12 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_pull_t5',
      code: 'EX_PULL_T5',
      name: 'Single-Arm Sliding Pull & Thoracic Bridge',
      family: BiomechanicalFamily.noBarPull,
      tier: DifficultyTier.tier5SpecOps,
      motionKind: MannequinMotionKind.thoracicBridge,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.latissimusDorsi,
        MuscleGroup.posteriorDeltoid,
        MuscleGroup.rhomboidsTraps,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.obliques,
        MuscleGroup.glutes,
        MuscleGroup.erectorSpinae,
      ],
      tempo: '3-1-2-1',
      defaultTargetReps: 8,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['TRACTION 1 BRAS', 'ANTI-ROTATION STRICTE', 'OUVERTURE THORACIQUE'],
      biomechanicalInstructions: <String>[
        'Une main verrouillée dans le bas du dos, l\'autre bras tendu devant au sol.',
        'Tracter l\'ensemble du poids du corps avec un seul grand dorsal sans rotation d\'épaules.',
        'Enchaîner avec le pont thoracique unilatéral pour ouvrir la chaîne antérieure.',
      ],
      commonMistake: 'Hyperextension lombaire compensatoire.',
      stealthVariantName: '1-Arm Sliding Floor Pull (0 dB)',
      stealthVariantDescription: 'Force maximale de tirage sans barre ni impact.',
      wristKneeVariantName: '1-Arm Forearm Pull & Unilateral Elbow Press',
      wristKneeVariantDescription: 'Exécution sur avant-bras et coude unique pour zéro charge carpienne.',
      masteryStandardLabel: '3 × 8 reps/côté (RPE ≤ 3)',
    ),

    // 3. TACTICAL LEGS (T1 -> T5)
    TacticalExercise(
      id: 'ex_legs_t1',
      code: 'EX_LEGS_T1',
      name: 'Assisted Tempo Squat & Glute Bridge',
      family: BiomechanicalFamily.tacticalLegs,
      tier: DifficultyTier.tier1Recruit,
      motionKind: MannequinMotionKind.airSquat,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.quadriceps,
        MuscleGroup.glutes,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.hamstrings,
        MuscleGroup.calves,
      ],
      tempo: '3-1-1-1',
      defaultTargetReps: 16,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['GENOUX DANS L\'AXE', 'TALONS ANCRÉS', 'BUSTE FIER'],
      biomechanicalInstructions: <String>[
        'Pieds largeur d\'épaules, pointes ouvertes à 20°, trépied plantaire ancré au sol.',
        'Descendre en 3s hanches vers l\'arrière jusqu\'à la parallèle puis remonter en serrant les fessiers.',
        'Compléter par le Glute Bridge au sol avec pause de 2s en rétroversion pelvienne.',
      ],
      commonMistake: 'Valgus dynamique des genoux (genoux qui rentrent vers l\'intérieur).',
      stealthVariantName: 'Tempo Squat & Glute Bridge (0 dB)',
      stealthVariantDescription: 'Pieds ancrés en permanence au sol.',
      wristKneeVariantName: 'Box Squat Parallèle & Isometric Glute Bridge',
      wristKneeVariantDescription: 'Amplitude limitée à 80° de flexion patellaire + chaîne postérieure dominante.',
      masteryStandardLabel: '3 × 20 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_legs_t2',
      code: 'EX_LEGS_T2',
      name: 'Military Air Squat & Reverse Lunge',
      family: BiomechanicalFamily.tacticalLegs,
      tier: DifficultyTier.tier2Soldier,
      motionKind: MannequinMotionKind.reverseLunge,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.quadriceps,
        MuscleGroup.glutes,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.hamstrings,
        MuscleGroup.calves,
      ],
      tempo: '2-1-1-0',
      defaultTargetReps: 20,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['SOUS LA PARALLÈLE', 'GENOU ARRIÈRE 2CM', 'POUSSÉE TALON AVANT'],
      biomechanicalInstructions: <String>[
        'Alterner Air Squat complet sous la parallèle et fente arrière contrôlée (Reverse Lunge).',
        'En fente arrière : garder le tibia avant vertical pour protéger le tendon rotulien.',
        'Repousser puissamment par le talon et le grand fessier de la jambe avant.',
      ],
      commonMistake: 'Frapper le genou arrière contre le sol.',
      stealthVariantName: 'Silent Reverse Lunge & Prisoner Squat',
      stealthVariantDescription: 'Contrôle décélérateur à 2 cm du sol sans contact bruyant.',
      wristKneeVariantName: 'Short-Range Reverse Lunge & Hip Hinge',
      wristKneeVariantDescription: 'Recul long privilégiant la hanche et le grand fessier plutôt que le genou.',
      masteryStandardLabel: '3 × 25 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_legs_t3',
      code: 'EX_LEGS_T3',
      name: 'Pause Squat (3-2-1) & Single-Leg Bridge',
      family: BiomechanicalFamily.tacticalLegs,
      tier: DifficultyTier.tier3Nco,
      motionKind: MannequinMotionKind.airSquat,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.quadriceps,
        MuscleGroup.glutes,
        MuscleGroup.hamstrings,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.calves,
        MuscleGroup.erectorSpinae,
      ],
      tempo: '3-2-1-0',
      defaultTargetReps: 15,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['PAUSE 2S EN BAS', 'ZÉRO REBOND', 'EXTENSION HANCHE 1-JAMBE'],
      biomechanicalInstructions: <String>[
        'Descendre en 3 secondes sous la parallèle et figer la position basse pendant 2 secondes complètes.',
        'Remonter explosivement sans rebond élastique.',
        'Enchaîner avec le pont fessier unilatéral (Single-Leg Glute Bridge) bassin verrouillé.',
      ],
      commonMistake: 'Relâcher la tension lombaire pendant la pause basse.',
      stealthVariantName: 'Pause Squat 3-2-1 (Remplace Jump Lunges)',
      stealthVariantDescription: 'Supprime tout impact de saut par une pause isométrique profonde.',
      wristKneeVariantName: 'Single-Leg Glute Bridge & Wall Sit (90°)',
      wristKneeVariantDescription: 'Isométrie à 90° et travail unilatéral de hanche sans cisaillement patellaire.',
      masteryStandardLabel: '3 × 15 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_legs_t4',
      code: 'EX_LEGS_T4',
      name: 'Cossack Squat & Hamstring Walkout',
      family: BiomechanicalFamily.tacticalLegs,
      tier: DifficultyTier.tier4Officer,
      motionKind: MannequinMotionKind.cossackSquat,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.quadriceps,
        MuscleGroup.hamstrings,
        MuscleGroup.glutes,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.calves,
        MuscleGroup.obliques,
      ],
      tempo: '3-1-1-1',
      defaultTargetReps: 14,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['JAMBE LIBRE TENDUE', 'TALON D\'APPUI AU SOL', 'ISCHIOS SOUS TENSION'],
      biomechanicalInstructions: <String>[
        'En Cossack Squat : écart large, descendre latéralement sur une jambe tandis que l\'autre reste tendue sur le talon.',
        'En Hamstring Walkout : depuis le pont fessier, avancer les talons à petits pas jusqu\'à l\'extension quasi complète.',
        'Revenir sous tension maximale des ischio-jambiers.',
      ],
      commonMistake: 'Décoller le talon de la jambe porteuse en Cossack Squat.',
      stealthVariantName: 'Cossack Squat & Hamstring Walkout (0 dB)',
      stealthVariantDescription: 'Force frontale et chaîne postérieure 100 % silencieuse.',
      wristKneeVariantName: 'Hamstring Walkout & High Cossack',
      wristKneeVariantDescription: 'Priorité aux ischio-jambiers qui stabilisent le ligament croisé antérieur (LCA).',
      masteryStandardLabel: '3 × 15 reps/côté (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_legs_t5',
      code: 'EX_LEGS_T5',
      name: 'Strict Pistol Squat & Shrimp Squat',
      family: BiomechanicalFamily.tacticalLegs,
      tier: DifficultyTier.tier5SpecOps,
      motionKind: MannequinMotionKind.pistolSquat,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.quadriceps,
        MuscleGroup.glutes,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.hamstrings,
        MuscleGroup.calves,
        MuscleGroup.rectusAbdominis,
      ],
      tempo: '3-1-1-1',
      defaultTargetReps: 8,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['JAMBE AVANT HORIZONTALE', 'CONTRÔLE 3S DESCENTE', 'STABILITÉ CHEVILLE'],
      biomechanicalInstructions: <String>[
        'En équilibre sur un pied, tendre la jambe libre devant soi parallèlement au sol.',
        'Descendre en 3s en gardant le talon ancré et le genou aligné sur le 2e orteil.',
        'Marquer 1s en bas puis remonter à la force pure d\'une seule jambe.',
      ],
      commonMistake: 'S\'effondrer en bas de course avec rebond sur le ménisque.',
      stealthVariantName: 'Strict Tempo Pistol Squat (0 dB)',
      stealthVariantDescription: 'Maîtrise unilatérale absolue sans aucun bruit d\'impact.',
      wristKneeVariantName: 'Slow Tempo Split Squat (4-2-1) & Hamstring Bridge',
      wristKneeVariantDescription: 'Répartit la contrainte patellaire tout en maintenant une intensité SpecOps.',
      masteryStandardLabel: '3 × 8 reps/jambe (RPE ≤ 3)',
    ),

    // 4. IRON CORE (T1 -> T5)
    TacticalExercise(
      id: 'ex_core_t1',
      code: 'EX_CORE_T1',
      name: 'Dead Bug Strict & McGill Curl-up',
      family: BiomechanicalFamily.ironCore,
      tier: DifficultyTier.tier1Recruit,
      motionKind: MannequinMotionKind.deadBug,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.rectusAbdominis,
        MuscleGroup.obliques,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.glutes,
      ],
      tempo: '3-2-1-0',
      defaultTargetReps: 14,
      defaultHoldSeconds: 40,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['LOMBAIRES PLAQUÉES', 'BRAS/JAMBE OPPOSÉS', 'EXPIRATION LONGUE'],
      biomechanicalInstructions: <String>[
        'Sur le dos, écraser fermement le creux lombaire contre le tapis (rétroversion pelvienne).',
        'Tendre lentement le bras droit et la jambe gauche à 5 cm du sol sans jamais perdre le contact lombaire.',
        'Expirer profondément en ramenant au centre puis alterner.',
      ],
      commonMistake: 'Laisser le bas du dos se cambrer lorsque la jambe descend.',
      stealthVariantName: 'Dead Bug Strict (0 dB)',
      stealthVariantDescription: 'Gainage anti-extension 100 % silencieux.',
      wristKneeVariantName: 'Dead Bug (0 charge poignets/genoux/disques)',
      wristKneeVariantDescription: 'Protocole de référence du Pr. Stuart McGill pour protéger les disques lombaires.',
      masteryStandardLabel: '3 × 40s (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_core_t2',
      code: 'EX_CORE_T2',
      name: 'RKC Plank & 4-Count Flutter Kicks',
      family: BiomechanicalFamily.ironCore,
      tier: DifficultyTier.tier2Soldier,
      motionKind: MannequinMotionKind.rkcPlank,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.rectusAbdominis,
        MuscleGroup.obliques,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.glutes,
        MuscleGroup.latissimusDorsi,
      ],
      tempo: 'ISO-MAX',
      defaultTargetReps: 20,
      defaultHoldSeconds: 45,
      isIsometric: true,
      isPlyometric: false,
      hudCues: <String>['TIRE COUDES VERS ORTEILS', 'FESSIERS ACIER', 'BATTEMENTS COURTS'],
      biomechanicalInstructions: <String>[
        'En RKC Plank sur avant-bras : tirer isométriquement les coudes vers les pointes de pieds et contracter les fessiers à 100 %.',
        'En 4-Count Flutter Kicks : sur le dos, mains sous le sacrum, omoplates décollées, battements alternés à 15 cm du sol.',
        'Compter 1-2-3 = 1 répétition militaire.',
      ],
      commonMistake: 'Cambrer les lombaires ou bloquer sa respiration.',
      stealthVariantName: 'RKC Plank & Flutter Kicks (0 dB)',
      stealthVariantDescription: 'Classique militaire USMC/SEAL totalement silencieux.',
      wristKneeVariantName: 'Forearm RKC Plank (Sur avant-bras)',
      wristKneeVariantDescription: 'Supprime toute extension du poignet.',
      masteryStandardLabel: '3 × 45s (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_core_t3',
      code: 'EX_CORE_T3',
      name: 'Hollow Body Hold & Plank Shoulder Taps',
      family: BiomechanicalFamily.ironCore,
      tier: DifficultyTier.tier3Nco,
      motionKind: MannequinMotionKind.hollowBodyHold,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.rectusAbdominis,
        MuscleGroup.obliques,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.quadriceps,
        MuscleGroup.anteriorDeltoid,
      ],
      tempo: 'ISO / 2-1-2',
      defaultTargetReps: 16,
      defaultHoldSeconds: 50,
      isIsometric: true,
      isPlyometric: false,
      hudCues: <String>['BAS DU DOS SOUDÉ', 'CÔTES ABAISSÉES', 'ZÉRO ROULIS BASSIN'],
      biomechanicalInstructions: <String>[
        'En Hollow Body : lombaires soudées au sol, jambes tendues à 30° et bras tendus derrière les oreilles.',
        'En Shoulder Taps : toucher l\'épaule opposée en 2s sans aucun mouvement latéral des hanches.',
        'Imaginer un verre d\'eau posé sur le sacrum.',
      ],
      commonMistake: 'Dandiner les hanches de gauche à droite.',
      stealthVariantName: 'Hollow Body Hold & Slow Shoulder Taps',
      stealthVariantDescription: 'Contrôle anti-rotation silencieux.',
      wristKneeVariantName: 'Hollow Body Hold & Forearm Side Plank',
      wristKneeVariantDescription: 'Remplace l\'appui mains tendues par le gainage latéral sur avant-bras.',
      masteryStandardLabel: '3 × 50s (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_core_t4',
      code: 'EX_CORE_T4',
      name: 'Hollow Body Rocks & Tactical V-Ups',
      family: BiomechanicalFamily.ironCore,
      tier: DifficultyTier.tier4Officer,
      motionKind: MannequinMotionKind.tacticalVUp,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.rectusAbdominis,
        MuscleGroup.obliques,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.quadriceps,
      ],
      tempo: '2-1-1-0',
      defaultTargetReps: 18,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['PLIURE SYMÉTRIQUE EN V', 'JAMBES TENDUES', 'CONTRÔLE DESCENTE'],
      biomechanicalInstructions: <String>[
        'Depuis la position Hollow Body, monter simultanément le buste et les jambes tendues pour toucher les tibias.',
        'Redescendre en 2s sans laisser les talons ni les omoplates frapper le sol.',
        'Enchaîner avec les bascules rigides en banane (Hollow Rocks).',
      ],
      commonMistake: 'Fléchir les genoux ou tirer sur la nuque.',
      stealthVariantName: 'Controlled Tempo V-Ups (0 dB)',
      stealthVariantDescription: 'Décélération excentrique à 2 cm du sol sans bruit.',
      wristKneeVariantName: 'Tuck V-Ups & Copenhagen Adductor Plank',
      wristKneeVariantDescription: 'Bras de levier ajusté et zéro appui sur les poignets.',
      masteryStandardLabel: '3 × 20 reps (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_core_t5',
      code: 'EX_CORE_T5',
      name: 'Floor L-Sit Hold & Floor Dragon Flag',
      family: BiomechanicalFamily.ironCore,
      tier: DifficultyTier.tier5SpecOps,
      motionKind: MannequinMotionKind.floorLSit,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.rectusAbdominis,
        MuscleGroup.triceps,
        MuscleGroup.quadriceps,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.latissimusDorsi,
        MuscleGroup.glutes,
      ],
      tempo: 'ISO / 4-1-2',
      defaultTargetReps: 8,
      defaultHoldSeconds: 20,
      isIsometric: true,
      isPlyometric: false,
      hudCues: <String>['DÉPRESSION SCAPULAIRE', 'JAMBES À 90°', 'CORPS EN LIGNE DROITE'],
      biomechanicalInstructions: <String>[
        'En Floor L-Sit : assis jambes tendues, mains à plat à côté des cuisses, pousser les épaules vers le bas pour décoller fessiers et talons.',
        'En Floor Dragon Flag : ancrage sur le haut des épaules, descendre le corps verrouillé en 4s sans casser les hanches.',
        'Remonter en bloc rigide.',
      ],
      commonMistake: 'Casser l\'angle des hanches à la descente du Dragon Flag.',
      stealthVariantName: 'Floor L-Sit & Dragon Flag (0 dB)',
      stealthVariantDescription: 'Force gymnique et militaire d\'élite 100 % silencieuse.',
      wristKneeVariantName: 'Knuckle Floor L-Sit Tuck & Dragon Flag',
      wristKneeVariantDescription: 'Appui sur les poings neutres en L-Sit.',
      masteryStandardLabel: '3 × 20s / 8 reps (RPE ≤ 3)',
    ),

    // 5. METCON ENGINE (T1 -> T5)
    TacticalExercise(
      id: 'ex_metcon_t1',
      code: 'EX_METCON_T1',
      name: 'Step-Jacks & Squat-to-Reach',
      family: BiomechanicalFamily.metCon,
      tier: DifficultyTier.tier1Recruit,
      motionKind: MannequinMotionKind.stepJacks,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.quadriceps,
        MuscleGroup.lateralDeltoid,
        MuscleGroup.calves,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.glutes,
        MuscleGroup.rectusAbdominis,
      ],
      tempo: 'CADENCE HAUTE',
      defaultTargetReps: 25,
      defaultHoldSeconds: 45,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>['CADENCE RAPIDE', 'BRAS GRANDS OUVERTS', 'ZÉRO IMPACT AU SOL'],
      biomechanicalInstructions: <String>[
        'Pas chassés latéraux dynamiques sans saut accompagnés d\'une ouverture complète des bras au-dessus de la tête.',
        'Enchaîner avec Squat-to-Reach : flexion fluide suivie d\'une extension haute sur demi-pointes.',
        'Respiration rythmée nasale/buccale.',
      ],
      commonMistake: 'Amplitude de bras incomplète qui réduit la dépense énergétique.',
      stealthVariantName: 'Speed Step-Jacks & Squat-to-Reach (0 dB)',
      stealthVariantDescription: '100 % silencieux dès la version standard.',
      wristKneeVariantName: 'Low-Impact Step-Jacks & Shadow Boxing',
      wristKneeVariantDescription: 'Aucune contrainte sur les poignets ni sur les rotules.',
      masteryStandardLabel: '3 × 45s (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_metcon_t2',
      code: 'EX_METCON_T2',
      name: 'Military Jumping Jacks & Mountain Climbers',
      family: BiomechanicalFamily.metCon,
      tier: DifficultyTier.tier2Soldier,
      motionKind: MannequinMotionKind.jumpingJacks,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.calves,
        MuscleGroup.quadriceps,
        MuscleGroup.rectusAbdominis,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.anteriorDeltoid,
        MuscleGroup.pectorals,
      ],
      tempo: 'CADENCE 120 BPM',
      defaultTargetReps: 30,
      defaultHoldSeconds: 60,
      isIsometric: false,
      isPlyometric: true,
      hudCues: <String>['ATTERRISSAGE AVANT-PIED', 'ÉPAULES AU-DESSUS DES MAINS', 'BASSIN BAS'],
      biomechanicalInstructions: <String>[
        '4-Count Military Jumping Jacks (Side Straddle Hop FM 7-22) sur la plante des pieds.',
        'Enchaîner au sol en Mountain Climbers : épaules verrouillées au-dessus des poignets, montée rapide des genoux vers la poitrine.',
        'Garder le dos parfaitement plat.',
      ],
      commonMistake: 'Monter les fesses en pyramide pendant les Mountain Climbers.',
      stealthVariantName: 'Speed Step-Jacks & Slow Cross-Body Climbers',
      stealthVariantDescription: 'Remplace tous les sauts par des montées de genoux croisées silencieuses au sol.',
      wristKneeVariantName: 'Forearm Plank March & Standing High-Cadence Punch',
      wristKneeVariantDescription: 'Sur avant-bras ou debout en Shadow Boxing haute intensité.',
      masteryStandardLabel: '3 × 60s (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_metcon_t3',
      code: 'EX_METCON_T3',
      name: '6-Count Military Burpee & Bear Crawl',
      family: BiomechanicalFamily.metCon,
      tier: DifficultyTier.tier3Nco,
      motionKind: MannequinMotionKind.militaryBurpee,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.pectorals,
        MuscleGroup.quadriceps,
        MuscleGroup.rectusAbdominis,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.anteriorDeltoid,
        MuscleGroup.triceps,
        MuscleGroup.glutes,
      ],
      tempo: '6-COUNT STRICT',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: true,
      hudCues: <String>['1 SQUAT • 2 PLANCHE', '3-4 POMPE STRICTE', '5 SQUAT • 6 EXTENSION'],
      biomechanicalInstructions: <String>[
        'Décomposer en 6 temps militaires stricts : (1) Squat mains au sol, (2) Jeté de pieds en planche.',
        '(3) Descente pompe poitrine au sol, (4) Poussée en planche.',
        '(5) Retour des pieds à plat largeur d\'épaules, (6) Extension complète.',
      ],
      commonMistake: 'Cambrer le bas du dos lors du jeté de jambes en planche.',
      stealthVariantName: 'No-Jump Step-Back 6-Count Burpee & Bear Crawl',
      stealthVariantDescription: 'Recul et retour un pied après l\'autre + extension sur pointes sans aucun saut (< 30 dB).',
      wristKneeVariantName: 'Knuckle Step-Back Burpee / Walkout Push-up',
      wristKneeVariantDescription: 'Sur les poings neutres avec recul contrôlé sans choc articulaire.',
      masteryStandardLabel: '15 reps / min (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_metcon_t4',
      code: 'EX_METCON_T4',
      name: '8-Count Navy SEAL Bodybuilder',
      family: BiomechanicalFamily.metCon,
      tier: DifficultyTier.tier4Officer,
      motionKind: MannequinMotionKind.sealBodybuilder,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.pectorals,
        MuscleGroup.quadriceps,
        MuscleGroup.rectusAbdominis,
        MuscleGroup.glutes,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.anteriorDeltoid,
        MuscleGroup.triceps,
        MuscleGroup.obliques,
      ],
      tempo: '8-COUNT NSW',
      defaultTargetReps: 15,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: true,
      hudCues: <String>['POMPE + PLANK JACK', 'GAINAGE CORONADO', 'CADENCE ININTERROMPUE'],
      biomechanicalInstructions: <String>[
        'Standard Navy SEAL Coronado en 8 temps : (1) Squat mains au sol, (2) Planche, (3) Descente pompe, (4) Remontée pompe.',
        '(5) Écartement des pieds en Plank Jack, (6) Fermeture des pieds joints.',
        '(7) Retour en squat pieds à plat, (8) Redressement au garde-à-vous.',
      ],
      commonMistake: 'Laisser tomber les hanches aux temps 5 et 6 du Plank Jack.',
      stealthVariantName: 'Stealth 8-Count SEAL Bodybuilder (Step-Out)',
      stealthVariantDescription: 'Ouverture latérale alternée des pieds sans saut + extension rapide sans décoller.',
      wristKneeVariantName: 'Fist 8-Count Step Bodybuilder',
      wristKneeVariantDescription: 'Appui sur les poings fermés et transitions glissées sans impact.',
      masteryStandardLabel: '15 reps / min (RPE ≤ 3)',
    ),
    TacticalExercise(
      id: 'ex_metcon_t5',
      code: 'EX_METCON_T5',
      name: 'Devil Burpee (Double Push-up) & Speed Crawl',
      family: BiomechanicalFamily.metCon,
      tier: DifficultyTier.tier5SpecOps,
      motionKind: MannequinMotionKind.sealBodybuilder,
      primaryMuscles: <MuscleGroup>[
        MuscleGroup.pectorals,
        MuscleGroup.quadriceps,
        MuscleGroup.glutes,
        MuscleGroup.rectusAbdominis,
      ],
      secondaryMuscles: <MuscleGroup>[
        MuscleGroup.triceps,
        MuscleGroup.anteriorDeltoid,
        MuscleGroup.calves,
      ],
      tempo: 'EXPLOSIF SPECOPS',
      defaultTargetReps: 16,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: true,
      hudCues: <String>['DOUBLE POMPE STRICTE', 'PUISSANCE MAXIMALE', 'RELANCE IMMÉDIATE'],
      biomechanicalInstructions: <String>[
        'Enchaîner deux pompes militaires complètes poitrine au sol à chaque passage en planche.',
        'Remonter explosivement et enchaîner 4 pas de Bear Crawl avant/arrière genoux à 3 cm du sol.',
        'Maintenir une fréquence cardiaque de zone 4–5 sous contrôle respiratoire.',
      ],
      commonMistake: 'Sacrifier l\'amplitude de la seconde pompe sous la fatigue.',
      stealthVariantName: 'Stealth Double-Push-up Burpee & Bear Crawl',
      stealthVariantDescription: 'Double pompe + marche de l\'ours ultra-rapide 100 % sans saut.',
      wristKneeVariantName: 'Knuckle Double-Push-up Walkout',
      wristKneeVariantDescription: 'Sur poings neutres, zéro saut vertical.',
      masteryStandardLabel: '18 reps / min (RPE ≤ 3)',
    ),
  ];

  /// Exercice de mobilité RAMP (3 minutes).
  static const TacticalExercise rampMobilityExercise = TacticalExercise(
    id: 'ex_ramp_warmup',
    code: 'RAMP_PREP',
    name: 'Protocole RAMP FM 7-22 (Poignets, Scapula, Hanches)',
    family: BiomechanicalFamily.noBarPull,
    tier: DifficultyTier.tier1Recruit,
    motionKind: MannequinMotionKind.rampMobility,
    primaryMuscles: <MuscleGroup>[
      MuscleGroup.rhomboidsTraps,
      MuscleGroup.glutes,
      MuscleGroup.anteriorDeltoid,
    ],
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.rectusAbdominis,
      MuscleGroup.hamstrings,
    ],
    tempo: 'FLUIDE CONTINU',
    defaultTargetReps: 10,
    defaultHoldSeconds: 180,
    isIsometric: false,
    isPlyometric: false,
    hudCues: <String>['MOBILITÉ POIGNETS', 'WORLD\'S GREATEST STRETCH', 'ACTIVATION SCAPULAIRE'],
    biomechanicalInstructions: <String>[
      '0:00–1:00 (Raise) : Marche tactique, grands cercles d\'épaules et Step-Jacks.',
      '1:00–2:00 (Activate & Mobilize) : Bascules douces des poignets et World\'s Greatest Stretch G/D.',
      '2:00–3:00 (Potentiate) : Deep Squat Pry thoracique et Walkout-to-Push-up.',
    ],
    commonMistake: 'Sauter l\'échauffement des poignets avant les séries de pompes.',
    stealthVariantName: 'Protocole RAMP Silencieux (0 dB)',
    stealthVariantDescription: '100 % sans saut ni impact.',
    wristKneeVariantName: 'RAMP Décompression Articulaire Douce',
    wristKneeVariantDescription: 'Amplitude progressive adaptée.',
    masteryStandardLabel: '3 minutes avant chaque mission (+35 TXP)',
  );

  /// Exercice de retour au calme H2F & Box Breathing Navy SEAL (2 minutes).
  static const TacticalExercise h2fBoxBreathingExercise = TacticalExercise(
    id: 'ex_h2f_cooldown',
    code: 'H2F_BOX',
    name: 'Décompression H2F & Box Breathing (4-4-4-4)',
    family: BiomechanicalFamily.ironCore,
    tier: DifficultyTier.tier1Recruit,
    motionKind: MannequinMotionKind.boxBreathingH2f,
    primaryMuscles: <MuscleGroup>[
      MuscleGroup.rectusAbdominis,
      MuscleGroup.erectorSpinae,
    ],
    secondaryMuscles: <MuscleGroup>[
      MuscleGroup.latissimusDorsi,
      MuscleGroup.glutes,
    ],
    tempo: '4S - 4S - 4S - 4S',
    defaultTargetReps: 8,
    defaultHoldSeconds: 120,
    isIsometric: true,
    isPlyometric: false,
    hudCues: <String>['INSPIRE 4S (NEZ)', 'GARDE 4S (CALME)', 'EXPIRE 4S • VIDE 4S'],
    biomechanicalInstructions: <String>[
      '0:00–1:00 : Cobra thoracique doux puis Child\'s Pose avec étirement latéral des dorsaux.',
      '1:00–2:00 : Respiration carrée Navy SEAL (4s Inspiration, 4s Apnée Plein, 4s Expiration, 4s Apnée Vide).',
      'Active le nerf vague et accélère la récupération parasympathique.',
    ],
    commonMistake: 'Respirer dans le haut de la poitrine au lieu du diaphragme.',
    stealthVariantName: 'Box Breathing H2F (0 dB)',
    stealthVariantDescription: 'Calme absolu.',
    wristKneeVariantName: 'Box Breathing Assis ou Allongé',
    wristKneeVariantDescription: 'Zéro contrainte articulaire.',
    masteryStandardLabel: '2 minutes post-séance (+35 TXP + Combo +30 TXP)',
  );

  static TacticalExercise exerciseFor(
    BiomechanicalFamily family,
    DifficultyTier tier,
  ) {
    for (final TacticalExercise ex in allExercises) {
      if (ex.family == family && ex.tier == tier) {
        return ex;
      }
    }
    return allExercises.first;
  }

  static TacticalExercise? exerciseById(String id) {
    for (final TacticalExercise ex in allExercises) {
      if (ex.id == id) {
        return ex;
      }
    }
    if (id == rampMobilityExercise.id) {
      return rampMobilityExercise;
    }
    if (id == h2fBoxBreathingExercise.id) {
      return h2fBoxBreathingExercise;
    }
    return null;
  }

  /// Retourne la régression biomécanique sécurisée (`Tier k - 1`) de la même famille.
  static TacticalExercise regressedExercise(TacticalExercise exercise) {
    final int prevIdx = math.max(0, exercise.tier.index - 1);
    return exerciseFor(exercise.family, DifficultyTier.values[prevIdx]);
  }

  /// Retourne la progression biomécanique supérieure (`Tier k + 1`) de la même famille.
  static TacticalExercise progressedExercise(TacticalExercise exercise) {
    final int nextIdx = math.min(
      DifficultyTier.values.length - 1,
      exercise.tier.index + 1,
    );
    return exerciseFor(exercise.family, DifficultyTier.values[nextIdx]);
  }

  static List<TacticalExercise> exercisesByFamily(BiomechanicalFamily family) {
    return allExercises
        .where((TacticalExercise e) => e.family == family)
        .toList(growable: false);
  }

  /// Génère une mission complète (avec RAMP 3 min + Corps équilibré Push/Pull + H2F 2 min).
  /// Injecte automatiquement une série corrective de Tirage Sans Barre si `posturalBalanceRatio < 0.85`.
  static TacticalMission buildMission({
    required String id,
    required String code,
    required String title,
    required String subtitle,
    required WorkoutFormatType format,
    required DifficultyTier tier,
    required Map<BiomechanicalFamily, int> repQuotas,
    OperationalCampaignId? campaignId,
    int? dayNumber,
    bool isRecoveryDay = false,
    bool isBossMission = false,
    MilitaryRank? promotionTrialRank,
    Map<BiomechanicalFamily, DifficultyTier>? familyTiers,
    double posturalBalanceRatio = 1.0,
    int extraRestSeconds = 0,
    int? durationMinutesOverride,
  }) {
    final DifficultyTier pushTier =
        familyTiers?[BiomechanicalFamily.upperPush] ?? tier;
    final DifficultyTier pullTier =
        familyTiers?[BiomechanicalFamily.noBarPull] ?? tier;
    final DifficultyTier legsTier =
        familyTiers?[BiomechanicalFamily.tacticalLegs] ?? tier;
    final DifficultyTier coreTier =
        familyTiers?[BiomechanicalFamily.ironCore] ?? tier;
    final DifficultyTier metconTier =
        familyTiers?[BiomechanicalFamily.metCon] ?? tier;

    final TacticalExercise pushEx = exerciseFor(BiomechanicalFamily.upperPush, pushTier);
    final TacticalExercise pullEx = exerciseFor(BiomechanicalFamily.noBarPull, pullTier);
    final TacticalExercise legsEx = exerciseFor(BiomechanicalFamily.tacticalLegs, legsTier);
    final TacticalExercise coreEx = exerciseFor(BiomechanicalFamily.ironCore, coreTier);
    final TacticalExercise metconEx = exerciseFor(BiomechanicalFamily.metCon, metconTier);

    final int pushReps = math.max(
      4,
      repQuotas[BiomechanicalFamily.upperPush] ?? pushEx.defaultTargetReps,
    );
    final int pullReps = math.max(
      4,
      repQuotas[BiomechanicalFamily.noBarPull] ?? pullEx.defaultTargetReps,
    );
    final int legsReps = math.max(
      6,
      repQuotas[BiomechanicalFamily.tacticalLegs] ?? legsEx.defaultTargetReps,
    );
    final int coreReps = math.max(
      6,
      repQuotas[BiomechanicalFamily.ironCore] ?? coreEx.defaultTargetReps,
    );
    final int metconReps = math.max(
      6,
      repQuotas[BiomechanicalFamily.metCon] ?? metconEx.defaultTargetReps,
    );

    final List<WorkoutStationStep> steps = <WorkoutStationStep>[
      const WorkoutStationStep(
        stage: WorkoutStepStage.rampWarmup,
        title: 'Phase 1 — Échauffement RAMP FM 7-22',
        subtitle: 'Poignets, Scapula, Hanches & Activation SNC',
        exercise: rampMobilityExercise,
        durationSeconds: 180,
        targetReps: 10,
        isTimedWork: true,
        roundIndex: 1,
        totalRounds: 1,
      ),
    ];

    // Loi scientifique @Spartan §4.2.3 : si B_postural < 0.85, injection automatique
    // d'une série corrective de Tirage Sans Barre pour prévenir la cyphose thoracique.
    if (!isRecoveryDay && posturalBalanceRatio < 0.85) {
      steps.add(
        WorkoutStationStep(
          stage: WorkoutStepStage.mainWork,
          title: 'Correction Posturale Anti-Cyphose (${pullEx.code})',
          subtitle:
              'Série bonus auto-injectée (Ratio Push/Pull ${posturalBalanceRatio.toStringAsFixed(2)} < 0.85)',
          exercise: pullEx,
          durationSeconds: 45,
          targetReps: pullReps,
          isTimedWork: false,
          roundIndex: 1,
          totalRounds: 1,
        ),
      );
    }

    final int restDuration = (25 + extraRestSeconds).clamp(15, 60);

    if (isRecoveryDay || format == WorkoutFormatType.flashPt5Min) {
      final List<TacticalExercise> flashStations = <TacticalExercise>[
        pushEx,
        pullEx,
        legsEx,
        coreEx,
      ];
      for (int i = 0; i < flashStations.length; i++) {
        final TacticalExercise ex = flashStations[i];
        steps.add(
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Flash PT Station ${i + 1}/4 — ${ex.family.shortLabel}',
            subtitle: ex.name,
            exercise: ex,
            durationSeconds: 45,
            targetReps: ex.defaultTargetReps,
            isTimedWork: false,
            roundIndex: i + 1,
            totalRounds: 4,
          ),
        );
      }
    } else if (format == WorkoutFormatType.tabataHiit) {
      // Protocole Tabata Tactique 40s Effort / 20s Repos (100 % guidé au bip sans compter)
      const int tabataRounds = 2;
      final int intervalRest = (20 + extraRestSeconds).clamp(10, 45);
      for (int r = 1; r <= tabataRounds; r++) {
        steps.addAll(<WorkoutStationStep>[
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Intervalle $r/$tabataRounds • 40s Poussée (${pushEx.code})',
            subtitle: 'Effort continu tempo propre • Ratio 1:1 avec Tirage',
            exercise: pushEx,
            durationSeconds: 40,
            targetReps: pushReps,
            isTimedWork: true,
            roundIndex: r,
            totalRounds: tabataRounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.restRecovery,
            title: 'Transition Tactique (${intervalRest}s)',
            subtitle: 'Relâchement épaules • Préparation Tirage au Sol',
            exercise: h2fBoxBreathingExercise,
            durationSeconds: intervalRest,
            targetReps: 2,
            isTimedWork: true,
            roundIndex: r,
            totalRounds: tabataRounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Intervalle $r/$tabataRounds • 40s Tirage (${pullEx.code})',
            subtitle: 'Rétraction scapulaire & protection coiffe des rotateurs',
            exercise: pullEx,
            durationSeconds: 40,
            targetReps: pullReps,
            isTimedWork: true,
            roundIndex: r,
            totalRounds: tabataRounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.restRecovery,
            title: 'Transition Tactique (${intervalRest}s)',
            subtitle: 'Respiration nasale • Mise en place Membres Inférieurs',
            exercise: h2fBoxBreathingExercise,
            durationSeconds: intervalRest,
            targetReps: 2,
            isTimedWork: true,
            roundIndex: r,
            totalRounds: tabataRounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Intervalle $r/$tabataRounds • 40s Jambes (${legsEx.code})',
            subtitle: 'Amplitude contrôlée sans impact excessif',
            exercise: legsEx,
            durationSeconds: 40,
            targetReps: legsReps,
            isTimedWork: true,
            roundIndex: r,
            totalRounds: tabataRounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Intervalle $r/$tabataRounds • 40s ${r.isOdd ? "Core" : "MetCon"}',
            subtitle: r.isOdd
                ? 'Gainage anti-extension maximal'
                : 'Densité cardio-métabolique',
            exercise: r.isOdd ? coreEx : metconEx,
            durationSeconds: 40,
            targetReps: r.isOdd ? coreReps : metconReps,
            isTimedWork: true,
            roundIndex: r,
            totalRounds: tabataRounds,
          ),
        ]);
      }
    } else if (format == WorkoutFormatType.tacticalPyramid) {
      // Pyramide Tactique Symétrique 1 -> Sommet -> 1 (Loi des multiplicateurs NSW)
      const List<double> ladderFactors = <double>[0.65, 1.00, 0.75];
      final int totalRungs = ladderFactors.length;
      for (int i = 0; i < totalRungs; i++) {
        final int r = i + 1;
        final double f = ladderFactors[i];
        final String rungLabel = i == 0
            ? 'Montée'
            : (i == 1 ? 'Sommet Pic' : 'Redescente');
        steps.addAll(<WorkoutStationStep>[
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Échelon $r/$totalRungs ($rungLabel) • Poussée (${pushEx.code})',
            subtitle: 'Pyramide symétrique 1:1 avec Tirage au Sol',
            exercise: pushEx,
            durationSeconds: 60,
            targetReps: math.max(4, (pushReps * f).round()),
            isTimedWork: false,
            roundIndex: r,
            totalRounds: totalRungs,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Échelon $r/$totalRungs ($rungLabel) • Tirage (${pullEx.code})',
            subtitle: 'Fixateurs d\'omoplates & chaîne postérieure',
            exercise: pullEx,
            durationSeconds: 60,
            targetReps: math.max(4, (pullReps * f).round()),
            isTimedWork: false,
            roundIndex: r,
            totalRounds: totalRungs,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.restRecovery,
            title: 'Repos Tactique Inter-Échelon',
            subtitle: 'Respiration nasale lente • Relâchement épaules',
            exercise: h2fBoxBreathingExercise,
            durationSeconds: restDuration,
            targetReps: 4,
            isTimedWork: true,
            roundIndex: r,
            totalRounds: totalRungs,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Échelon $r/$totalRungs ($rungLabel) • Jambes (${legsEx.code})',
            subtitle: 'Puissance locomotrice sans matériel',
            exercise: legsEx,
            durationSeconds: 60,
            targetReps: math.max(6, (legsReps * f).round()),
            isTimedWork: false,
            roundIndex: r,
            totalRounds: totalRungs,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Échelon $r/$totalRungs ($rungLabel) • Core & MetCon',
            subtitle: 'Résilience mentale sous pré-fatigue',
            exercise: i == 1 ? metconEx : coreEx,
            durationSeconds: 60,
            targetReps: math.max(
              6,
              ((i == 1 ? metconReps : coreReps) * f).round(),
            ),
            isTimedWork: i != 1 && coreEx.isIsometric,
            roundIndex: r,
            totalRounds: totalRungs,
          ),
        ]);
      }
    } else {
      // EMOM Opérationnel & AMRAP Haute Densité
      const int rounds = 2;
      for (int r = 1; r <= rounds; r++) {
        steps.addAll(<WorkoutStationStep>[
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Tour $r/$rounds • Poussée (${pushEx.code})',
            subtitle: 'Ratio équilibré 1:1 avec Tirage au Sol',
            exercise: pushEx,
            durationSeconds: 60,
            targetReps: pushReps,
            isTimedWork: false,
            roundIndex: r,
            totalRounds: rounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Tour $r/$rounds • Tirage Sans Barre (${pullEx.code})',
            subtitle: 'Protection épaules & rétraction scapulaire',
            exercise: pullEx,
            durationSeconds: 60,
            targetReps: pullReps,
            isTimedWork: false,
            roundIndex: r,
            totalRounds: rounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.restRecovery,
            title: 'Repos Tactique Inter-Couple',
            subtitle: 'Respiration nasale lente • Relâchement épaules',
            exercise: h2fBoxBreathingExercise,
            durationSeconds: restDuration,
            targetReps: 4,
            isTimedWork: true,
            roundIndex: r,
            totalRounds: rounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Tour $r/$rounds • Jambes (${legsEx.code})',
            subtitle: 'Puissance locomotrice sans matériel',
            exercise: legsEx,
            durationSeconds: 60,
            targetReps: legsReps,
            isTimedWork: false,
            roundIndex: r,
            totalRounds: rounds,
          ),
          WorkoutStationStep(
            stage: WorkoutStepStage.mainWork,
            title: 'Tour $r/$rounds • Gainage & MetCon (${r.isOdd ? coreEx.code : metconEx.code})',
            subtitle: 'Sangle abdominale anti-extension & densité cardio',
            exercise: r.isOdd ? coreEx : metconEx,
            durationSeconds: 60,
            targetReps: r.isOdd ? coreReps : metconReps,
            isTimedWork: r.isOdd,
            roundIndex: r,
            totalRounds: rounds,
          ),
        ]);
      }
    }

    steps.add(
      const WorkoutStationStep(
        stage: WorkoutStepStage.h2fCooldown,
        title: 'Phase Finale — Décompression H2F & Box Breathing (4-4-4-4)',
        subtitle: '2 min • Retour au calme parasympathique (+35 TXP)',
        exercise: h2fBoxBreathingExercise,
        durationSeconds: 120,
        targetReps: 8,
        isTimedWork: true,
        roundIndex: 1,
        totalRounds: 1,
      ),
    );

    final int effectiveDuration =
        durationMinutesOverride ??
        (isRecoveryDay
            ? 5
            : (promotionTrialRank != null ? 6 : format.defaultMinutes));

    return TacticalMission(
      id: id,
      code: code,
      title: title,
      subtitle: subtitle,
      format: format,
      durationMinutes: effectiveDuration,
      recommendedTier: tier,
      targetRpe: isRecoveryDay ? 2 : (isBossMission ? 4 : 3),
      steps: steps,
      campaignId: campaignId,
      dayNumber: dayNumber,
      isRecoveryDay: isRecoveryDay,
      isBossMission: isBossMission,
      promotionTrialRank: promotionTrialRank,
    );
  }

  /// Génère une séance 100 % personnalisée selon le profil du soldat (Tiers par famille,
  /// quotas auto-régulés par RPE, ratio postural Push/Pull et durée choisie).
  static TacticalMission buildPersonalizedMission({
    required SoldierProfileState profile,
    required WorkoutFormatType format,
    int? durationMinutes,
    BiomechanicalFamily? focusFamily,
  }) {
    final int minutes = durationMinutes ?? format.defaultMinutes;
    final bool isFlash = format == WorkoutFormatType.flashPt5Min;
    final int extraRest = profile.lastRpeScore >= 5
        ? 15
        : (profile.lastRpeScore == 4 ? 5 : 0);

    final Map<BiomechanicalFamily, int> scaledQuotas =
        <BiomechanicalFamily, int>{};
    profile.familyRepQuotas.forEach((BiomechanicalFamily fam, int baseQuota) {
      double mult = 1.0;
      if (focusFamily != null && fam == focusFamily) {
        mult = 1.15;
      }
      // Si l'utilisateur choisit un focus Upper Push, on augmente aussi No-Bar Pull
      // afin de préserver la règle d'or 1:1 d'intégrité scapulaire !
      if (focusFamily == BiomechanicalFamily.upperPush &&
          fam == BiomechanicalFamily.noBarPull) {
        mult = 1.15;
      }
      scaledQuotas[fam] = math.max(5, (baseQuota * mult).round());
    });

    final DifficultyTier dominantTier =
        focusFamily != null
        ? (profile.familyTiers[focusFamily] ??
              profile.activeCampaignId.recommendedTier)
        : profile.activeCampaignId.recommendedTier;

    final String focusTag = focusFamily != null
        ? ' • Focus ${focusFamily.shortLabel}'
        : '';

    return buildMission(
      id: 'custom_${format.code.toLowerCase()}_${minutes}m',
      code: 'CUSTOM • ${format.code}',
      title: '${format.title} Personnalisé ($minutes min$focusTag)',
      subtitle: isFlash
          ? '5 min • Réveil articulaire, Mobilité H2F & Bouclier Streak'
          : '$minutes min • Calibré IAO ${profile.iaoCalibrationScore}/100 • Ratio Push/Pull ${profile.posturalBalanceRatio.toStringAsFixed(2)}',
      format: format,
      tier: dominantTier,
      repQuotas: scaledQuotas,
      familyTiers: profile.familyTiers,
      posturalBalanceRatio: profile.posturalBalanceRatio,
      extraRestSeconds: extraRest,
      durationMinutesOverride: minutes,
      isRecoveryDay: isFlash,
    );
  }

  /// Génère le catalogue des 5 séances rapides "Zero-Friction" personnalisées au profil.
  static List<TacticalMission> buildQuickFormatMissions(
    SoldierProfileState profile,
  ) {
    return WorkoutFormatType.values
        .map(
          (WorkoutFormatType fmt) =>
              buildPersonalizedMission(profile: profile, format: fmt),
        )
        .toList(growable: false);
  }

  /// Génère les 28 missions d'une Campagne Opérationnelle avec périodisation ondulatoire
  /// sur 4 semaines (Acclimatation -> Accumulation -> Intensification -> Affûtage & Boss).
  static List<TacticalMission> missionsForCampaign(
    OperationalCampaignId campaign,
    Map<BiomechanicalFamily, int> repQuotas, {
    Map<BiomechanicalFamily, DifficultyTier>? familyTiers,
    double posturalBalanceRatio = 1.0,
    int extraRestSeconds = 0,
  }) {
    final List<TacticalMission> list = <TacticalMission>[];
    const List<WorkoutFormatType> cycleFormats = <WorkoutFormatType>[
      WorkoutFormatType.emomOperational,
      WorkoutFormatType.tabataHiit,
      WorkoutFormatType.amrapHighDensity,
      WorkoutFormatType.flashPt5Min, // J4 Recovery active
      WorkoutFormatType.tacticalPyramid,
      WorkoutFormatType.emomOperational,
      WorkoutFormatType.flashPt5Min, // J7 Recovery active
    ];

    for (int day = 1; day <= 28; day++) {
      final bool isRecovery = (day % 7 == 4) || (day % 7 == 0 && day != 28);
      final bool isBoss = day == 28;
      final WorkoutFormatType format = isBoss
          ? WorkoutFormatType.tacticalPyramid
          : cycleFormats[(day - 1) % cycleFormats.length];
      final int week = ((day - 1) ~/ 7) + 1;
      final (String weekPhase, double weekVolumeFactor) = switch (week) {
        1 => ('S1 Acclimatation', 0.92),
        2 => ('S2 Accumulation', 1.00),
        3 => ('S3 Intensification', 1.12),
        _ => ('S4 Affûtage & Boss', isBoss ? 1.20 : 0.86),
      };

      final Map<BiomechanicalFamily, int> dayQuotas =
          <BiomechanicalFamily, int>{
            for (final MapEntry<BiomechanicalFamily, int> e
                in repQuotas.entries)
              e.key: math.max(5, (e.value * weekVolumeFactor).round()),
          };

      list.add(
        buildMission(
          id: '${campaign.code.toLowerCase()}_d$day',
          code: '${campaign.code} • J${day.toString().padLeft(2, '0')}',
          title: isBoss
              ? 'BOSS MISSION J28 — Épreuve Finale ${campaign.title}'
              : isRecovery
              ? 'Jour $day — Mobilité Active H2F & Streak Shield'
              : 'Jour $day — $weekPhase (${format.title})',
          subtitle: isRecovery
              ? '5 min • Décompression articulaire & Box Breathing (Valide 100% du Streak)'
              : '${format.defaultMinutes} min • Ratio Push/Pull 1:1 • ${campaign.recommendedTier.shortTitle}',
          format: format,
          tier: campaign.recommendedTier,
          repQuotas: dayQuotas,
          campaignId: campaign,
          dayNumber: day,
          isRecoveryDay: isRecovery,
          isBossMission: isBoss,
          familyTiers: familyTiers,
          posturalBalanceRatio: posturalBalanceRatio,
          extraRestSeconds: extraRestSeconds,
        ),
      );
    }
    return list;
  }

  /// Les 4 Examens PT de Promotion (6 minutes).
  static List<PromotionTrialSpec> buildPromotionTrials(
    Map<BiomechanicalFamily, int> repQuotas,
  ) {
    return <PromotionTrialSpec>[
      PromotionTrialSpec(
        targetRank: MilitaryRank.e3Corporal,
        code: 'PT-TRIAL-01',
        title: 'Examen PT #1 — Bootcamp Qualification (E-3 Caporal)',
        bonusTxp: 500,
        block1Description: 'Bloc 1 (2m) : 15 Military Push-ups + 15 Prone I-Y-T-W Raises',
        block2Description: 'Bloc 2 (2m) : 30 Air Squats stricts sous la parallèle',
        block3Description: 'Bloc 3 (2m) : 45s RKC Plank + 25 Jumping Jacks / Step-Jacks',
        stealthAdaptationNote: 'Mode Silencieux : 25 Speed Step-Jacks (0 saut)',
        mission: buildMission(
          id: 'trial_e3',
          code: 'PT-TRIAL-E3',
          title: 'Examen PT #1 — Qualification Caporal E-3',
          subtitle: '6 min • Prime +500 TXP & Déblocage Tier 2',
          format: WorkoutFormatType.emomOperational,
          tier: DifficultyTier.tier2Soldier,
          repQuotas: repQuotas,
          promotionTrialRank: MilitaryRank.e3Corporal,
        ),
      ),
      PromotionTrialSpec(
        targetRank: MilitaryRank.e5StaffSergeant,
        code: 'PT-TRIAL-02',
        title: 'Examen PT #2 — NCO Tactical Trial (E-5 Sergent-Chef)',
        bonusTxp: 750,
        block1Description: 'Bloc 1 (2m) : 25 Military Push-ups + 20 Supine Elbow Presses',
        block2Description: 'Bloc 2 (2m) : 40 Air Squats + 20 Reverse Lunges alternés',
        block3Description: 'Bloc 3 (2m) : 45s Hollow Body Hold + 12 6-Count Military Burpees',
        stealthAdaptationNote: 'Mode Silencieux : 12 No-Jump Step-Back Burpees',
        mission: buildMission(
          id: 'trial_e5',
          code: 'PT-TRIAL-E5',
          title: 'Examen PT #2 — Qualification Sergent-Chef E-5',
          subtitle: '6 min • Prime +750 TXP & Déblocage Opération 02 Silent Recon',
          format: WorkoutFormatType.amrapHighDensity,
          tier: DifficultyTier.tier3Nco,
          repQuotas: repQuotas,
          promotionTrialRank: MilitaryRank.e5StaffSergeant,
        ),
      ),
      PromotionTrialSpec(
        targetRank: MilitaryRank.o1Lieutenant,
        code: 'PT-TRIAL-03',
        title: 'Examen PT #3 — Officer Endurance Crucible (O-1 Lieutenant)',
        bonusTxp: 1200,
        block1Description: 'Bloc 1 (2m) : 20 Diamond Push-ups + 15 Pike + 20 Floor Back Widows',
        block2Description: 'Bloc 2 (2m) : 15 Cossack Squats/côté + 20 Pause Squats (3-2-1)',
        block3Description: 'Bloc 3 (2m) : 60s Hollow Rocks + 18 8-Count Navy SEAL Bodybuilders',
        stealthAdaptationNote: 'Mode Silencieux : 18 Stealth 8-Count Bodybuilders + Bear Crawl',
        mission: buildMission(
          id: 'trial_o1',
          code: 'PT-TRIAL-O1',
          title: 'Examen PT #3 — Qualification Officier O-1',
          subtitle: '6 min • Prime +1 200 TXP & Déblocage Tier 4 Avancé',
          format: WorkoutFormatType.tacticalPyramid,
          tier: DifficultyTier.tier4Officer,
          repQuotas: repQuotas,
          promotionTrialRank: MilitaryRank.o1Lieutenant,
        ),
      ),
      PromotionTrialSpec(
        targetRank: MilitaryRank.sf1Operator,
        code: 'PT-TRIAL-04',
        title: 'Examen PT #4 — SpecOps Hell Week Trial (SF-1 Opérateur)',
        bonusTxp: 2000,
        block1Description: 'Bloc 1 (2m) : 20 Archer Push-ups + 20 Sliding Floor Pull-ups',
        block2Description: 'Bloc 2 (2m) : 8 Pistol Squats stricts/jambe + 20 Cossack Squats',
        block3Description: 'Bloc 3 (2m) : 30 Tactical V-Ups + 22 Devil Burpees (Double Push-up)',
        stealthAdaptationNote: 'Mode Silencieux : 22 Double-Push-up Stealth Burpees sans saut',
        mission: buildMission(
          id: 'trial_sf1',
          code: 'PT-TRIAL-SF1',
          title: 'Examen PT #4 — Qualification SpecOps SF-1',
          subtitle: '6 min • Prime +2 000 TXP & Déblocage Tier 5 Élite',
          format: WorkoutFormatType.tacticalPyramid,
          tier: DifficultyTier.tier5SpecOps,
          repQuotas: repQuotas,
          promotionTrialRank: MilitaryRank.sf1Operator,
        ),
      ),
    ];
  }
}
