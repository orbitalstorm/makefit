import 'dart:math' as math;
import '../models/makefit_models.dart';

/// Catalogue complet MakeFit 40+ (`v1.1.0`) :
/// - 25 exercices au poids du corps 100 % sans matériel (5 familles × 5 niveaux),
/// - Séances quotidiennes guidées de **10 minutes maximum** (`6 min`, `8 min` ou `10 min`),
/// - Enchaînement 100 % automatique Chronomètre + Séries + Récupérations Actives (`isTimedWork: true`),
/// - Langage clair, adulte, bienveillant et motivant pensé pour la remise en forme à 40 ans+.
class MakeFitCatalog {
  const MakeFitCatalog._();

  /// Les 25 exercices fondamentaux sans matériel (5 Familles × 5 Échelons).
  static const List<TacticalExercise> allExercises = <TacticalExercise>[
    // 1. BUSTE, ÉPAULES & BRAS (UPPER PUSH : T1 -> T5)
    TacticalExercise(
      id: 'ex_push_t1',
      code: 'EX_PUSH_T1',
      name: 'Pompes Inclinées Douces',
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
      tempo: 'Fluide 3-1-1',
      defaultTargetReps: 10,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'COUDES À 45°',
        'CORPS BIEN GAINÉ',
        'EXPIRE EN POUSSANT',
      ],
      biomechanicalInstructions: <String>[
        'Pose les mains largeur d\'épaules sur un support stable (rebord, table basse) ou genoux au sol.',
        'Garde les épaules basses loin des oreilles et les abdos engagés.',
        'Descends en contrôle puis repousse avec fluidité en expirant.',
      ],
      commonMistake: 'Creuser le bas du dos ou écarter les coudes à 90°.',
      stealthVariantName: 'Pompes Inclinées Silencieuses',
      stealthVariantDescription: 'Mouvement fluide et silencieux sans aucun impact.',
      wristKneeVariantName: 'Pompes au Mur / Poings Neutres',
      wristKneeVariantDescription: 'Appui debout contre un mur ou sur les poings pour ménager les poignets.',
      masteryStandardLabel: '3 séries de 12 répétitions fluides',
    ),
    TacticalExercise(
      id: 'ex_push_t2',
      code: 'EX_PUSH_T2',
      name: 'Pompes Classiques Toniques',
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
      tempo: 'Tonique 2-1-1',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'DOS BIEN DROIT',
        'COUDES À 45°',
        'POUSSÉE COMPLÈTE',
      ],
      biomechanicalInstructions: <String>[
        'En planche haute, pieds largeur de hanches, fessiers et abdos serrés.',
        'Fléchis les coudes à 45° en gardant la nuque alignée avec le dos.',
        'Repousse le sol avec énergie jusqu\'à tendre les bras sans brusquer les coudes.',
      ],
      commonMistake: 'Laisser le bassin descendre avant la poitrine.',
      stealthVariantName: 'Pompes Classiques Contrôlées',
      stealthVariantDescription: 'Exécution régulière sans bruit d\'impact.',
      wristKneeVariantName: 'Pompes sur les Poings (Poignets Droits)',
      wristKneeVariantDescription: 'Appui sur les poings fermés pour garder les poignets dans l\'axe.',
      masteryStandardLabel: '3 séries de 15 répétitions propres',
    ),
    TacticalExercise(
      id: 'ex_push_t3',
      code: 'EX_PUSH_T3',
      name: 'Pompes Épaules & Triceps (Pike)',
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
      tempo: 'Contrôlé 2-1-1',
      defaultTargetReps: 10,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'BASSIN HAUT EN V',
        'COUDES PRÈS DU CORPS',
        'CONTRÔLE LA DESCENTE',
      ],
      biomechanicalInstructions: <String>[
        'Monte les hanches en V inversé, talons légèrement décollés.',
        'Descends le haut de la tête légèrement en avant des mains en gardant les coudes serrés.',
        'Repousse dans l\'axe des épaules en soufflant.',
      ],
      commonMistake: 'Descendre la tête entre les mains en écartant trop les coudes.',
      stealthVariantName: 'Pompes Épaules Tempo Doux',
      stealthVariantDescription: 'Descente retenue sur 3 secondes sans à-coup.',
      wristKneeVariantName: 'Pompes Prise Serrée Poings Neutres',
      wristKneeVariantDescription: 'Mains largeur d\'épaules sur les poings pour protéger les poignets.',
      masteryStandardLabel: '3 séries de 12 répétitions',
    ),
    TacticalExercise(
      id: 'ex_push_t4',
      code: 'EX_PUSH_T4',
      name: 'Pompes Latérales Alternées',
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
      tempo: 'Précis 3-1-1',
      defaultTargetReps: 10,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'APPUI D\'UN CÔTÉ',
        'BRAS GUIDE TENDU',
        'BASSIN BIEN STABLE',
      ],
      biomechanicalInstructions: <String>[
        'Écarte les mains à 1,5 fois la largeur d\'épaules, doigts légèrement ouverts.',
        'Fléchis un bras en portant le buste vers lui tandis que l\'autre bras reste tendu en appui.',
        'Alterne droite et gauche en gardant les hanches parallèles au sol.',
      ],
      commonMistake: 'Tourner le bassin vers le bras tendu.',
      stealthVariantName: 'Pompes Latérales Tempo Lent',
      stealthVariantDescription: 'Renforcement intense de la poitrine sans saut ni impact.',
      wristKneeVariantName: 'Pompes Larges Mains Ouvertes 45°',
      wristKneeVariantDescription: 'Orientation confortable des mains réduisant la tension des poignets.',
      masteryStandardLabel: '3 séries de 10 répétitions alternées',
    ),
    TacticalExercise(
      id: 'ex_push_t5',
      code: 'EX_PUSH_T5',
      name: 'Pompes Unilatérales Gainées',
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
      tempo: 'Maîtrisé 3-1-1',
      defaultTargetReps: 6,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'PIEDS BIEN ÉCARTÉS',
        'ÉPAULES PARALLÈLES',
        'GAINAGE MAXIMAL',
      ],
      biomechanicalInstructions: <String>[
        'Écarte les pieds pour stabiliser le bassin, main d\'appui sous la poitrine, main libre au bas du dos.',
        'Garde les deux épaules parallèles au sol pendant toute la descente.',
        'Remonte avec puissance en verrouillant les abdos et les fessiers.',
      ],
      commonMistake: 'Vriller le buste sur le côté en remontant.',
      stealthVariantName: 'Pompes Unilatérales Silencieuses',
      stealthVariantDescription: 'Force pure et contrôle complet sans bruit.',
      wristKneeVariantName: 'Pompes Assistées 1 Bras sur Poing',
      wristKneeVariantDescription: 'Poignet aligné sur le poing neutre pour protéger l\'articulation.',
      masteryStandardLabel: '3 séries de 6 répétitions par côté',
    ),

    // 2. DOS, OMOPLATES & POSTURE (NO-BAR PULL : T1 -> T5)
    TacticalExercise(
      id: 'ex_pull_t1',
      code: 'EX_PULL_T1',
      name: 'Extension Dorsale Douce (Cobra)',
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
      tempo: 'Maintien 3s',
      defaultTargetReps: 10,
      defaultHoldSeconds: 35,
      isIsometric: true,
      isPlyometric: false,
      hudCues: <String>[
        'POUCES VERS LE HAUT',
        'SERRE LES OMOPLATES',
        'NUQUE ALLONGÉE',
      ],
      biomechanicalInstructions: <String>[
        'Allongé sur le ventre, regarde le tapis pour garder la nuque bien longue.',
        'Décolle légèrement le buste et les bras le long du corps, pouces tournés vers le plafond.',
        'Rapproche les omoplates en abaissant les épaules pendant 2 à 3 secondes.',
      ],
      commonMistake: 'Hausser les épaules vers les oreilles ou lever le menton.',
      stealthVariantName: 'Cobra Postural Silencieux',
      stealthVariantDescription: 'Posture idéale contre le dos voûté du bureau, zéro bruit.',
      wristKneeVariantName: 'Ouverture d\'Épaules Debout au Mur',
      wristKneeVariantDescription: 'Aucun appui sur les poignets ni sur les genoux.',
      masteryStandardLabel: '3 maintiens toniques de 35s',
    ),
    TacticalExercise(
      id: 'ex_pull_t2',
      code: 'EX_PULL_T2',
      name: 'Ouverture Posturale I-Y-T-W au Sol',
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
      tempo: 'Fluide 2-1-2',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'MOUVEMENT SANS ÉLAN',
        'COUDES VERS LES CÔTES',
        'ÉPAULES BASSES',
      ],
      biomechanicalInstructions: <String>[
        'Allongé sur le ventre, dessine lentement les lettres I, Y, T puis W avec les bras.',
        'En position W, tire les coudes vers les côtes pour bien engager tout le milieu du dos.',
        'Respire régulièrement sans cambrer excessivement le bas du dos.',
      ],
      commonMistake: 'Donner des à-coups avec le bas du dos.',
      stealthVariantName: 'Ouverture I-Y-T-W Sans Impact',
      stealthVariantDescription: 'Renforcement postural profond 100 % silencieux.',
      wristKneeVariantName: 'I-Y-T-W Douceur Articulaire',
      wristKneeVariantDescription: 'Zéro charge sur les poignets et les genoux.',
      masteryStandardLabel: '3 séries de 12 répétitions complètes',
    ),
    TacticalExercise(
      id: 'ex_pull_t3',
      code: 'EX_PULL_T3',
      name: 'Poussée des Coudes au Sol (Haut du Dos)',
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
      tempo: 'Tonique 2-1-2',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'APPUI SUR LES COUDES',
        'OUVRE LA POITRINE',
        'SERRE LE HAUT DU DOS',
      ],
      biomechanicalInstructions: <String>[
        'Allongé sur le dos, genoux fléchis, place les coudes à 45° des côtes, poings vers le plafond.',
        'Presse les coudes dans le tapis pour décoller le haut du dos et ouvrir la cage thoracique.',
        'Maintiens 1 à 2 secondes en haut puis redescends en douceur.',
      ],
      commonMistake: 'Pousser avec la tête au lieu d\'utiliser les coudes et le dos.',
      stealthVariantName: 'Renforcement Haut du Dos Silencieux',
      stealthVariantDescription: 'Alternative redoutable aux tractions, sans barre et sans bruit.',
      wristKneeVariantName: 'Poussée des Coudes sur Tapis Confort',
      wristKneeVariantDescription: 'Aucune flexion du poignet ni contrainte sur les genoux.',
      masteryStandardLabel: '3 séries de 14 répétitions',
    ),
    TacticalExercise(
      id: 'ex_pull_t4',
      code: 'EX_PULL_T4',
      name: 'Tirage Glissé au Sol sur Avant-Bras',
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
      tempo: 'Contrôlé 3-1-2',
      defaultTargetReps: 10,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'AVANT-BRAS ANCRÉS',
        'TIRE AVEC LE DOS',
        'ÉPAULES LOIN DES OREILLES',
      ],
      biomechanicalInstructions: <String>[
        'Sur le ventre (serviette sous le bassin sur sol lisse), pose les avant-bras devant toi.',
        'Presse les avant-bras au sol et tire le buste vers l\'avant en activant les dorsaux.',
        'Reviens lentement à la position de départ en gardant les abdos serrés.',
      ],
      commonMistake: 'S\'aider avec les pieds au lieu de tracter avec le dos.',
      stealthVariantName: 'Tirage Glissé Silencieux',
      stealthVariantDescription: 'Glissement fluide au sol sans aucun impact.',
      wristKneeVariantName: 'Tirage sur Avant-Bras (Poignets Neutres)',
      wristKneeVariantDescription: 'Appui réparti sur tout l\'avant-bras sans plier le poignet.',
      masteryStandardLabel: '3 séries de 10 répétitions',
    ),
    TacticalExercise(
      id: 'ex_pull_t5',
      code: 'EX_PULL_T5',
      name: 'Pont Thoracique & Tirage Unilatéral',
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
      tempo: 'Ample 3-1-2',
      defaultTargetReps: 8,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'MONTE LE BASSIN',
        'BASSIN BIEN STABLE',
        'GRANDE OUVERTURE BUSTE',
      ],
      biomechanicalInstructions: <String>[
        'Pieds et une main posés au sol, monte les hanches en ouvrant grand la poitrine vers le haut.',
        'Allonge le bras libre au-dessus de toi en respirant profondément.',
        'Redescends avec contrôle puis alterne de côté.',
      ],
      commonMistake: 'Forcer sur les lombaires au lieu d\'ouvrir le haut du buste.',
      stealthVariantName: 'Pont Thoracique Fluide Sans Bruit',
      stealthVariantDescription: 'Mobilité et force postérieure sans aucun saut.',
      wristKneeVariantName: 'Ouverture Thoracique sur Avant-Bras',
      wristKneeVariantDescription: 'Variante sur avant-bras pour supprimer l\'appui poignet.',
      masteryStandardLabel: '3 séries de 8 ouvertures par côté',
    ),

    // 3. JAMBES, CUISSES & FESSIERS (TACTICAL LEGS : T1 -> T5)
    TacticalExercise(
      id: 'ex_legs_t1',
      code: 'EX_LEGS_T1',
      name: 'Squats Contrôlés & Pont Fessier',
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
      tempo: 'Doux 3-1-1',
      defaultTargetReps: 14,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'TALONS ANCRÉS AU SOL',
        'GENOUX DANS L\'AXE',
        'BUSTE DROIT & FIER',
      ],
      biomechanicalInstructions: <String>[
        'Pieds largeur d\'épaules, pointes légèrement ouvertes, regard droit devant.',
        'Recule les hanches comme pour t\'asseoir en gardant tout le pied bien à plat.',
        'Remonte en poussant dans les talons et en contractant les fessiers.',
      ],
      commonMistake: 'Laisser les genoux rentrer vers l\'intérieur ou décoller les talons.',
      stealthVariantName: 'Squats Contrôlés Silencieux',
      stealthVariantDescription: 'Pieds ancrés en permanence au sol, zéro impact.',
      wristKneeVariantName: 'Demi-Squat Confort (Chaise) & Pont Fessier',
      wristKneeVariantDescription: 'Amplitude douce ménageant les rotules et les genoux.',
      masteryStandardLabel: '3 séries de 16 répétitions',
    ),
    TacticalExercise(
      id: 'ex_legs_t2',
      code: 'EX_LEGS_T2',
      name: 'Squats & Fentes Arrière Douces',
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
      tempo: 'Fluide 2-1-1',
      defaultTargetReps: 14,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'RECULE EN CONTRÔLE',
        'TIBIA AVANT VERTICAL',
        'POUSSE DANS LE TALON',
      ],
      biomechanicalInstructions: <String>[
        'Fais un grand pas en arrière en gardant le buste droit et les abdos serrés.',
        'Le tibia avant reste vertical, ce qui protège naturellement l\'articulation du genou.',
        'Remonte en poussant dans le talon avant puis change de jambe.',
      ],
      commonMistake: 'Poser brusquement le genou arrière contre le sol.',
      stealthVariantName: 'Fentes Arrière Silencieuses',
      stealthVariantDescription: 'Transition fluide à 2 cm du sol sans aucun choc.',
      wristKneeVariantName: 'Fentes Courtes Confort Genoux',
      wristKneeVariantDescription: 'Amplitude modérée privilégiant les fessiers sans flexion profonde.',
      masteryStandardLabel: '3 séries de 16 fentes alternées',
    ),
    TacticalExercise(
      id: 'ex_legs_t3',
      code: 'EX_LEGS_T3',
      name: 'Squats Pause Tonique (2s en bas)',
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
      tempo: 'Pause 3-2-1',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'PAUSE 2S EN BAS',
        'ZÉRO REBOND',
        'SERRE LES FESSIERS',
      ],
      biomechanicalInstructions: <String>[
        'Descends en 3 secondes et marque un arrêt complet de 2 secondes en bas du mouvement.',
        'Garde le dos droit et la poitrine ouverte pendant la pause.',
        'Remonte avec dynamisme sans rebondir sur les articulations.',
      ],
      commonMistake: 'Relâcher le gainage du dos en bas du squat.',
      stealthVariantName: 'Squats Pause Sans Saut',
      stealthVariantDescription: 'Remplace tout saut par un travail musculaire profond et silencieux.',
      wristKneeVariantName: 'Chaise au Mur 90° & Pont Fessier 1 Jambe',
      wristKneeVariantDescription: 'Renforcement intense des cuisses sans mouvement de cisaillement.',
      masteryStandardLabel: '3 séries de 12 répétitions',
    ),
    TacticalExercise(
      id: 'ex_legs_t4',
      code: 'EX_LEGS_T4',
      name: 'Fentes Latérales & Souplesse Hanches',
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
      tempo: 'Ample 3-1-1',
      defaultTargetReps: 12,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'PIED D\'APPUI À PLAT',
        'JAMBE OPPOSÉE TENDUE',
        'DOS BIEN PLAT',
      ],
      biomechanicalInstructions: <String>[
        'Pieds largement écartés, fléchis une jambe sur le côté en reculant les hanches.',
        'L\'autre jambe reste tendue, talon posé au sol pour assouplir les hanches.',
        'Remonte au centre et alterne de l\'autre côté.',
      ],
      commonMistake: 'Décoller le talon du pied porteur ou arrondir le dos.',
      stealthVariantName: 'Fentes Latérales Fluides',
      stealthVariantDescription: 'Force et mobilité des hanches 100 % silencieuse.',
      wristKneeVariantName: 'Fentes Latérales Amplitude Modérée',
      wristKneeVariantDescription: 'Descente confortable à mi-hauteur pour ménager les genoux.',
      masteryStandardLabel: '3 séries de 12 répétitions alternées',
    ),
    TacticalExercise(
      id: 'ex_legs_t5',
      code: 'EX_LEGS_T5',
      name: 'Flexion Équilibre sur 1 Jambe',
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
      tempo: 'Maîtrisé 3-1-1',
      defaultTargetReps: 8,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'DESCENTE LENTE 3S',
        'GENOU BIEN ALIGNÉ',
        'REGARD FIXE DEVANT',
      ],
      biomechanicalInstructions: <String>[
        'En équilibre sur un pied, tends l\'autre jambe devant toi et les bras pour l\'équilibre.',
        'Descends à ton amplitude de confort (ou vers une chaise) en gardant le talon ancré.',
        'Remonte à la force de la cuisse et du fessier.',
      ],
      commonMistake: 'Se laisser tomber rapidement en bas du mouvement.',
      stealthVariantName: 'Flexion 1 Jambe Contrôlée',
      stealthVariantDescription: 'Équilibre et force unilatérale sans impact.',
      wristKneeVariantName: 'Squat Bulgare Tempo Lent (4s)',
      wristKneeVariantDescription: 'Répartit la charge avec douceur sur le genou.',
      masteryStandardLabel: '3 séries de 8 répétitions par jambe',
    ),

    // 4. GAINAGE, ABDOS PROFONDS & PROTECTION DU DOS (IRON CORE : T1 -> T5)
    TacticalExercise(
      id: 'ex_core_t1',
      code: 'EX_CORE_T1',
      name: 'Gainage Lombaire Doux (Dead Bug)',
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
      tempo: 'Lent 3-1-2',
      defaultTargetReps: 12,
      defaultHoldSeconds: 40,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'BAS DU DOS PLAQUÉ',
        'BRAS & JAMBE OPPOSÉS',
        'EXPIRE LONGUEMENT',
      ],
      biomechanicalInstructions: <String>[
        'Allongé sur le dos, plaque fermement le bas du dos contre le tapis.',
        'Allonge lentement le bras droit et la jambe gauche sans jamais décoller les lombaires.',
        'Ramène au centre en expirant profondément puis change de côté.',
      ],
      commonMistake: 'Laisser le bas du dos se creuser quand la jambe descend.',
      stealthVariantName: 'Dead Bug Gainage Profond',
      stealthVariantDescription: 'L\'exercice numéro 1 pour renforcer les abdos tout en protégeant le dos.',
      wristKneeVariantName: 'Dead Bug (Zéro Pression Articulaire)',
      wristKneeVariantDescription: 'Aucune charge sur les poignets, les genoux ni les lombaires.',
      masteryStandardLabel: '3 séries de 40s fluides',
    ),
    TacticalExercise(
      id: 'ex_core_t2',
      code: 'EX_CORE_T2',
      name: 'Planche Active sur Avant-Bras',
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
      tempo: 'Gainage Tonique',
      defaultTargetReps: 12,
      defaultHoldSeconds: 40,
      isIsometric: true,
      isPlyometric: false,
      hudCues: <String>[
        'AVANT-BRAS SOLIDES',
        'ABDOS & FESSIERS SERRÉS',
        'RESPIRATION CALME',
      ],
      biomechanicalInstructions: <String>[
        'En appui sur les avant-bras, aligne tête, épaules, bassin et talons.',
        'Engage activement les abdos et les fessiers comme si tu tirais les coudes vers les pieds.',
        'Garde une respiration fluide sans jamais bloquer le souffle.',
      ],
      commonMistake: 'Creuser le bas du dos ou retenir sa respiration.',
      stealthVariantName: 'Planche Active Silencieuse',
      stealthVariantDescription: 'Ventre plat et sangle abdominale solide en silence.',
      wristKneeVariantName: 'Planche sur Avant-Bras (Poignets Libres)',
      wristKneeVariantDescription: 'Aucun appui sur les poignets.',
      masteryStandardLabel: '3 maintiens de 45s propres',
    ),
    TacticalExercise(
      id: 'ex_core_t3',
      code: 'EX_CORE_T3',
      name: 'Gainage Creux & Touches d\'Épaules',
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
      tempo: 'Stable 2-1-2',
      defaultTargetReps: 12,
      defaultHoldSeconds: 40,
      isIsometric: true,
      isPlyometric: false,
      hudCues: <String>[
        'BAS DU DOS MAINTENU',
        'CÔTES RENTREES',
        'BASSIN SANS BASCULE',
      ],
      biomechanicalInstructions: <String>[
        'Sur le dos, lombaires soudées au tapis, décolle légèrement les épaules et les jambes.',
        'Si besoin, plie légèrement les genoux pour garder le bas du dos parfaitement plaqué.',
        'Respire calmement en rentrant le nombril.',
      ],
      commonMistake: 'Tirer sur la nuque ou laisser les lombaires décoller du sol.',
      stealthVariantName: 'Gainage Creux Silencieux',
      stealthVariantDescription: 'Travail profond du transverse pour un ventre ferme.',
      wristKneeVariantName: 'Gainage Creux & Planche Latérale Avant-Bras',
      wristKneeVariantDescription: 'Zéro contrainte sur les poignets et les genoux.',
      masteryStandardLabel: '3 maintiens de 45s',
    ),
    TacticalExercise(
      id: 'ex_core_t4',
      code: 'EX_CORE_T4',
      name: 'Fermeture Abdominale Contrôlée',
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
      tempo: 'Fluide 2-1-2',
      defaultTargetReps: 14,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'MONTÉE FLUIDE',
        'SANS TIRER LA NUQUE',
        'RETENUE À LA DESCENTE',
      ],
      biomechanicalInstructions: <String>[
        'Allongé sur le dos, remonte simultanément le buste et les jambes (tendues ou semi-fléchies).',
        'Expire pendant la montée en rapprochant les mains des tibias.',
        'Redescends en 2 secondes avec contrôle sans laisser retomber les pieds.',
      ],
      commonMistake: 'Donner un coup de reins brusque au départ.',
      stealthVariantName: 'Fermeture Abdominale Sans Bruit',
      stealthVariantDescription: 'Descente retenue sans impact au sol.',
      wristKneeVariantName: 'Fermeture Genoux Fléchis Confort',
      wristKneeVariantDescription: 'Bras de levier raccourci doux pour le dos et sans appui poignets.',
      masteryStandardLabel: '3 séries de 15 répétitions',
    ),
    TacticalExercise(
      id: 'ex_core_t5',
      code: 'EX_CORE_T5',
      name: 'Équerre Assise & Gainage Complet',
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
      tempo: 'Maintien Tonique',
      defaultTargetReps: 8,
      defaultHoldSeconds: 25,
      isIsometric: true,
      isPlyometric: false,
      hudCues: <String>[
        'ÉPAULES ABAISSÉES',
        'BUSTE BIEN GRAND',
        'RESPIRATION MAÎTRISÉE',
      ],
      biomechanicalInstructions: <String>[
        'Assis jambes devant toi, mains posées à côté des hanches, repousse le sol en abaissant les épaules.',
        'Allège ou décolle les hanches et les pieds (jambes groupées ou tendues selon ta souplesse).',
        'Tiens la posture par petites séries toniques en respirant.',
      ],
      commonMistake: 'Arrondir le haut du dos et monter les épaules aux oreilles.',
      stealthVariantName: 'Équerre Assise Silencieuse',
      stealthVariantDescription: 'Force abdominale avancée 100 % silencieuse.',
      wristKneeVariantName: 'Équerre Groupée sur les Poings',
      wristKneeVariantDescription: 'Appui sur les poings fermés pour garder les poignets alignés.',
      masteryStandardLabel: '3 maintiens de 20s',
    ),

    // 5. CARDIO, SOUFFLE & BRÛLE-GRAISSE (METCON : T1 -> T5)
    TacticalExercise(
      id: 'ex_metcon_t1',
      code: 'EX_METCON_T1',
      name: 'Pas Latéraux Dynamiques Sans Saut',
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
      tempo: 'Rythme Tonique',
      defaultTargetReps: 20,
      defaultHoldSeconds: 40,
      isIsometric: false,
      isPlyometric: false,
      hudCues: <String>[
        'RYTHME DYNAMIQUE',
        'GRANDS BRAS OUVERTS',
        'ZÉRO IMPACT AU SOL',
      ],
      biomechanicalInstructions: <String>[
        'Déplace un pied sur le côté puis l\'autre à bon rythme tout en ouvrant grand les bras au-dessus de la tête.',
        'Fléchis légèrement les genoux pour engager les cuisses tout en protégeant tes articulations.',
        'Garde un souffle ample et régulier.',
      ],
      commonMistake: 'Faire de tout petits mouvements de bras sans amplitude.',
      stealthVariantName: 'Pas Latéraux Cardio Silencieux',
      stealthVariantDescription: 'Active le cœur et brûle des calories sans aucun saut.',
      wristKneeVariantName: 'Pas Latéraux Doux & Boxe Tonique',
      wristKneeVariantDescription: 'Zéro impact sur les genoux ni appui sur les poignets.',
      masteryStandardLabel: '3 séries de 40s dynamiques',
    ),
    TacticalExercise(
      id: 'ex_metcon_t2',
      code: 'EX_METCON_T2',
      name: 'Jumping Jacks Souples & Montées de Genoux',
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
      tempo: 'Cardio Fluide',
      defaultTargetReps: 22,
      defaultHoldSeconds: 40,
      isIsometric: false,
      isPlyometric: true,
      hudCues: <String>[
        'APPUIS SOUPLES',
        'GAINAGE ENGAGÉ',
        'SOUFFLE RÉGULIER',
      ],
      biomechanicalInstructions: <String>[
        'Enchaîne des Jumping Jacks souples sur l\'avant du pied en amortissant chaque appui.',
        'Garde les épaules détendues et les abdos engagés.',
        'À tout moment, passe en pas latéraux sans saut si tu préfères zéro impact.',
      ],
      commonMistake: 'Retomber jambes raides sur les talons.',
      stealthVariantName: 'Pas Rapides Sans Saut & Genoux Croisés',
      stealthVariantDescription: 'Cardio tonique 100 % sans saut, idéal en appartement et doux pour les genoux.',
      wristKneeVariantName: 'Marche Rapide Tonique & Directs Bras',
      wristKneeVariantDescription: 'Cardio debout dynamique ménageant genoux et poignets.',
      masteryStandardLabel: '3 séries de 40s régulières',
    ),
    TacticalExercise(
      id: 'ex_metcon_t3',
      code: 'EX_METCON_T3',
      name: 'Burpee Décomposé & Gainage Dynamique',
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
      tempo: '6 Temps Propres',
      defaultTargetReps: 10,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: true,
      hudCues: <String>[
        'POSE LES MAINS PROPREMENT',
        'PLANCHE BIEN DROITE',
        'REDRESSE-TOI GRAND',
      ],
      biomechanicalInstructions: <String>[
        'Fléchis les jambes pour poser les mains au sol, passe en planche solide et fais une pompe maîtrisée.',
        'Ramène les pieds à plat largeur d\'épaules puis redresse-toi complètement en ouvrant le buste.',
        'Privilégie toujours la fluidité du geste plutôt que la précipitation.',
      ],
      commonMistake: 'Laisser tomber le bassin en arrivant en planche.',
      stealthVariantName: 'Burpee Sans Saut (Un Pied Après l\'Autre)',
      stealthVariantDescription: 'Recul et retour d\'un pied après l\'autre sans saut ni impact.',
      wristKneeVariantName: 'Descente en Planche Marchée sur Poings',
      wristKneeVariantDescription: 'Mouvement progressif sur poings neutres, très sûr pour les articulations.',
      masteryStandardLabel: '10 répétitions fluides en 40s',
    ),
    TacticalExercise(
      id: 'ex_metcon_t4',
      code: 'EX_METCON_T4',
      name: 'Circuit Complet Pompe & Planche Dynamique',
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
      tempo: 'Complet 8 Temps',
      defaultTargetReps: 10,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: true,
      hudCues: <String>[
        'POMPE + OUVERTURE PIEDS',
        'BASSIN BIEN ALIGNÉ',
        'RESPIRATION AMPLE',
      ],
      biomechanicalInstructions: <String>[
        'Descends en planche, effectue une pompe propre, puis écarte et resserre les pieds en gainage.',
        'Ramène les pieds vers les mains et redresse-toi en soufflant.',
        'Un mouvement complet qui sollicite tout le corps en un minimum de temps.',
      ],
      commonMistake: 'Cambrer les lombaires lors de l\'ouverture des pieds.',
      stealthVariantName: 'Circuit Complet Sans Saut (Pas Alternés)',
      stealthVariantDescription: 'Ouverture d\'un pied après l\'autre et redressement sans sauter.',
      wristKneeVariantName: 'Circuit Sans Saut sur Poings Neutres',
      wristKneeVariantDescription: 'Poignets droits et transitions douces sans choc.',
      masteryStandardLabel: '10 répétitions complètes en 45s',
    ),
    TacticalExercise(
      id: 'ex_metcon_t5',
      code: 'EX_METCON_T5',
      name: 'Burpee Double Pompe Haute Énergie',
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
      tempo: 'Dynamique Soutenu',
      defaultTargetReps: 10,
      defaultHoldSeconds: 0,
      isIsometric: false,
      isPlyometric: true,
      hudCues: <String>[
        'DEUX POMPES PROPRES',
        'GAINAGE ACTIF',
        'RELANCE FLUIDE',
      ],
      biomechanicalInstructions: <String>[
        'Enchaîne deux pompes complètes à chaque passage au sol en gardant un gainage irréprochable.',
        'Remonte avec tonus et garde une respiration rythmée du début à la fin.',
        'Ajuste la cadence pour conserver une posture impeccable jusqu\'à la dernière seconde.',
      ],
      commonMistake: 'Réduire l\'amplitude de la deuxième pompe avec la fatigue.',
      stealthVariantName: 'Double Pompe & Relevé Sans Saut',
      stealthVariantDescription: 'Haute dépense énergétique zéro saut et zéro bruit.',
      wristKneeVariantName: 'Double Pompe Marchée sur Poings',
      wristKneeVariantDescription: 'Poignets alignés et zéro impact articulaire.',
      masteryStandardLabel: '10 répétitions maîtrisées en 45s',
    ),
  ];

  /// Étape 1 de chaque séance : Échauffement articulaire doux 40+ (`60s` à `90s`).
  static const TacticalExercise rampMobilityExercise = TacticalExercise(
    id: 'ex_ramp_warmup',
    code: 'WARMUP_40',
    name: 'Échauffement Articulaire Doux (Épaules, Dos, Hanches & Poignets)',
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
    tempo: 'Fluide & Doux',
    defaultTargetReps: 8,
    defaultHoldSeconds: 75,
    isIsometric: false,
    isPlyometric: false,
    hudCues: <String>[
      'CERCLES D\'ÉPAULES DOUX',
      'OUVERTURE DOS & HANCHES',
      'RÉVEIL DES POIGNETS',
    ],
    biomechanicalInstructions: <String>[
      'Grands cercles d\'épaules vers l\'arrière et ouverture de la cage thoracique.',
      'Rotations douces des poignets et déverrouillage du bassin et des hanches.',
      'Flexions légères et torsions thoraciques contrôlées pour préparer le corps sans raideur.',
    ],
    commonMistake: 'Commencer les séries à froid sans préparer les épaules et les poignets.',
    stealthVariantName: 'Échauffement Articulaire Silencieux',
    stealthVariantDescription: '100 % fluide, sans saut ni impact.',
    wristKneeVariantName: 'Échauffement Doux Spécial Articulations',
    wristKneeVariantDescription: 'Amplitude progressive tout en douceur.',
    masteryStandardLabel: '60s à 90s en début de chaque séance',
  );

  /// Récupération Active inter-séries & Retour au calme final (`15s–25s` / `60s–90s`).
  static const TacticalExercise h2fBoxBreathingExercise = TacticalExercise(
    id: 'ex_h2f_cooldown',
    code: 'BREATH_CALM',
    name: 'Retour au Calme, Étirements & Respiration Guidée',
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
    tempo: '4s - 4s - 4s - 4s',
    defaultTargetReps: 6,
    defaultHoldSeconds: 75,
    isIsometric: true,
    isPlyometric: false,
    hudCues: <String>[
      'INSPIRE PAR LE NEZ (4S)',
      'RELÂCHE LES ÉPAULES',
      'EXPIRE LENTEMENT (4S)',
    ],
    biomechanicalInstructions: <String>[
      'Allonge le dos, relâche complètement les trapèzes et décrispe les mâchoires.',
      'Suis le guide respiratoire (4s inspiration nasale, 4s calme, 4s expiration douce, 4s relâchement).',
      'Fait redescendre le rythme cardiaque et élimine les tensions de la journée.',
    ],
    commonMistake: 'Respirer rapidement par le haut de la poitrine au lieu du ventre.',
    stealthVariantName: 'Respiration & Relâchement du Dos',
    stealthVariantDescription: 'Calme complet et récupération profonde.',
    wristKneeVariantName: 'Respiration Guidée Assis ou Debout',
    wristKneeVariantDescription: 'Aucune contrainte articulaire.',
    masteryStandardLabel: '60s à 90s en fin de séance',
  );

  /// Normalise toute durée de séance vers `6`, `8` ou `10` minutes MAX (jamais > 10 min).
  static int normalizeSessionMinutes(int? rawMinutes) {
    final int m = (rawMinutes ?? 10).clamp(6, 10);
    if (m <= 6) {
      return 6;
    }
    if (m <= 8) {
      return 8;
    }
    return 10;
  }

  static String _familyClearBenefitLabel(BiomechanicalFamily family) {
    return switch (family) {
      BiomechanicalFamily.upperPush => 'Buste & Bras',
      BiomechanicalFamily.noBarPull => 'Dos & Posture',
      BiomechanicalFamily.tacticalLegs => 'Jambes & Tonus',
      BiomechanicalFamily.ironCore => 'Gainage & Protection du Dos',
      BiomechanicalFamily.metCon => 'Vitalité & Souffle',
    };
  }

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

  /// Retourne la variante plus douce (`Tier k - 1`) de la même famille.
  static TacticalExercise regressedExercise(TacticalExercise exercise) {
    final int prevIdx = math.max(0, exercise.tier.index - 1);
    return exerciseFor(exercise.family, DifficultyTier.values[prevIdx]);
  }

  /// Retourne la variante supérieure (`Tier k + 1`) de la même famille.
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

  /// Génère une séance 100 % automatique de **6, 8 ou 10 minutes maximum** :
  /// 1. Échauffement articulaire doux 40+ (`60s` à `90s`),
  /// 2. Séries d'effort (`35s` à `45s`) systématiquement suivies d'une Récupération Active (`15s` à `25s`),
  /// 3. Retour au calme & Respiration (`60s` à `90s`),
  /// avec `isTimedWork: true` sur **100 % des étapes** pour un enchaînement fluide dès l'appui sur `GO`.
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
    FitnessInitialLevel? fitnessLevel,
  }) {
    final int effectiveMinutes = normalizeSessionMinutes(
      durationMinutesOverride ??
          (promotionTrialRank != null
              ? 6
              : (isRecoveryDay ? 6 : format.defaultMinutes)),
    );

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

    final TacticalExercise pushEx = isRecoveryDay
        ? exerciseFor(BiomechanicalFamily.upperPush, DifficultyTier.tier1Recruit)
        : exerciseFor(BiomechanicalFamily.upperPush, pushTier);
    final TacticalExercise pullEx = isRecoveryDay
        ? exerciseFor(BiomechanicalFamily.noBarPull, DifficultyTier.tier1Recruit)
        : exerciseFor(BiomechanicalFamily.noBarPull, pullTier);
    final TacticalExercise legsEx = isRecoveryDay
        ? exerciseFor(
            BiomechanicalFamily.tacticalLegs,
            DifficultyTier.tier1Recruit,
          )
        : exerciseFor(BiomechanicalFamily.tacticalLegs, legsTier);
    final TacticalExercise coreEx = isRecoveryDay
        ? exerciseFor(BiomechanicalFamily.ironCore, DifficultyTier.tier1Recruit)
        : exerciseFor(BiomechanicalFamily.ironCore, coreTier);
    final TacticalExercise metconEx = isRecoveryDay
        ? exerciseFor(BiomechanicalFamily.metCon, DifficultyTier.tier1Recruit)
        : exerciseFor(BiomechanicalFamily.metCon, metconTier);

    final int pushReps = math.max(
      6,
      repQuotas[BiomechanicalFamily.upperPush] ?? pushEx.defaultTargetReps,
    );
    final int pullReps = math.max(
      6,
      repQuotas[BiomechanicalFamily.noBarPull] ?? pullEx.defaultTargetReps,
    );
    final int legsReps = math.max(
      8,
      repQuotas[BiomechanicalFamily.tacticalLegs] ?? legsEx.defaultTargetReps,
    );
    final int coreReps = math.max(
      8,
      repQuotas[BiomechanicalFamily.ironCore] ?? coreEx.defaultTargetReps,
    );
    final int metconReps = math.max(
      10,
      repQuotas[BiomechanicalFamily.metCon] ?? metconEx.defaultTargetReps,
    );

    // Calibrage du couple (Effort 35..45s + Récupération 15..25s = 60s exactes par bloc)
    final int baseWorkSeconds = isRecoveryDay
        ? 35
        : (fitnessLevel?.workSeconds ??
              (format == WorkoutFormatType.flashPt5Min ? 35 : 40));
    final int restShift = extraRestSeconds >= 5 ? 5 : 0;
    final int workSeconds = (baseWorkSeconds - restShift).clamp(35, 45);
    final int restSeconds = (60 - workSeconds).clamp(15, 25);

    // Découpage mathématique exact :
    // - 6 min (360s)  = 60s Échauffement + 4 × (work + rest = 60s) + 60s Retour au calme
    // - 8 min (480s)  = 60s Échauffement + 6 × (work + rest = 60s) + 60s Retour au calme
    // - 10 min (600s) = 90s Échauffement + 7 × (work + rest = 60s) + 90s Retour au calme
    final int warmupSeconds = effectiveMinutes == 10 ? 90 : 60;
    final int cooldownSeconds = effectiveMinutes == 10 ? 90 : 60;

    final bool needsExtraBackCare = !isRecoveryDay && posturalBalanceRatio < 0.85;

    final List<(TacticalExercise, int)> plannedSeries =
        switch (effectiveMinutes) {
          6 => <(TacticalExercise, int)>[
            (pushEx, pushReps),
            (pullEx, pullReps),
            (legsEx, legsReps),
            (coreEx, coreReps),
          ],
          8 => <(TacticalExercise, int)>[
            (pushEx, pushReps),
            (pullEx, pullReps),
            (legsEx, legsReps),
            (coreEx, coreReps),
            (isRecoveryDay ? pullEx : metconEx, isRecoveryDay ? pullReps : metconReps),
            (needsExtraBackCare ? pullEx : coreEx, needsExtraBackCare ? pullReps : coreReps),
          ],
          _ => <(TacticalExercise, int)>[
            (pushEx, pushReps),
            (pullEx, pullReps),
            (legsEx, legsReps),
            (coreEx, coreReps),
            (
              needsExtraBackCare ? pullEx : pushEx,
              needsExtraBackCare ? pullReps : math.max(6, (pushReps * 0.9).round()),
            ),
            (pullEx, pullReps),
            (
              isRecoveryDay || format == WorkoutFormatType.tacticalPyramid
                  ? legsEx
                  : metconEx,
              isRecoveryDay || format == WorkoutFormatType.tacticalPyramid
                  ? legsReps
                  : metconReps,
            ),
          ],
        };

    final int totalSeries = plannedSeries.length;
    final List<WorkoutStationStep> steps = <WorkoutStationStep>[
      WorkoutStationStep(
        stage: WorkoutStepStage.rampWarmup,
        title: 'Échauffement Articulaire Doux (${warmupSeconds}s)',
        subtitle: 'Réveil progressif des épaules, du dos, des hanches et des poignets',
        exercise: rampMobilityExercise,
        durationSeconds: warmupSeconds,
        targetReps: 8,
        isTimedWork: true,
        roundIndex: 1,
        totalRounds: 1,
      ),
    ];

    for (int i = 0; i < totalSeries; i++) {
      final (TacticalExercise ex, int reps) = plannedSeries[i];
      final int seriesNum = i + 1;
      final String benefit = _familyClearBenefitLabel(ex.family);
      final TacticalExercise? upcomingEx = (i + 1 < totalSeries)
          ? plannedSeries[i + 1].$1
          : null;

      steps.add(
        WorkoutStationStep(
          stage: WorkoutStepStage.mainWork,
          title: 'Série $seriesNum/$totalSeries — ${ex.name} ($benefit)',
          subtitle:
              '${workSeconds}s à ton rythme • Objectif ~$reps répétitions fluides',
          exercise: ex,
          durationSeconds: workSeconds,
          targetReps: reps,
          isTimedWork: true,
          roundIndex: seriesNum,
          totalRounds: totalSeries,
        ),
      );

      steps.add(
        WorkoutStationStep(
          stage: WorkoutStepStage.restRecovery,
          title:
              'Récupération Active (${restSeconds}s) — Souffle & Relâche les épaules',
          subtitle: upcomingEx != null
              ? 'Respire calmement • Prochaine série : ${upcomingEx.name}'
              : 'Belle dernière série ! Respire avant le retour au calme',
          exercise: h2fBoxBreathingExercise,
          durationSeconds: restSeconds,
          targetReps: 2,
          isTimedWork: true,
          roundIndex: seriesNum,
          totalRounds: totalSeries,
        ),
      );
    }

    steps.add(
      WorkoutStationStep(
        stage: WorkoutStepStage.h2fCooldown,
        title: 'Retour au Calme & Respiration (${cooldownSeconds}s)',
        subtitle:
            'Relâchement du dos, ouverture thoracique & respiration apaisante 4-4-4-4',
        exercise: h2fBoxBreathingExercise,
        durationSeconds: cooldownSeconds,
        targetReps: 6,
        isTimedWork: true,
        roundIndex: 1,
        totalRounds: 1,
      ),
    );

    return TacticalMission(
      id: id,
      code: code,
      title: title,
      subtitle: subtitle,
      format: format,
      durationMinutes: effectiveMinutes,
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

  /// Génère une séance personnalisée (strictement `6`, `8` ou `10` minutes max) adaptée
  /// au profil de l'utilisateur (niveau 40+, objectif, durée préférée et équilibre du dos).
  static TacticalMission buildPersonalizedMission({
    required SoldierProfileState profile,
    required WorkoutFormatType format,
    int? durationMinutes,
    BiomechanicalFamily? focusFamily,
  }) {
    final int minutes = normalizeSessionMinutes(
      durationMinutes ?? format.defaultMinutes,
    );
    final bool isExpress = format == WorkoutFormatType.flashPt5Min;
    final int extraRest = profile.lastRpeScore >= 4 ? 5 : 0;

    final Map<BiomechanicalFamily, int> scaledQuotas =
        <BiomechanicalFamily, int>{};
    profile.familyRepQuotas.forEach((BiomechanicalFamily fam, int baseQuota) {
      double mult = 1.0;
      if (focusFamily != null && fam == focusFamily) {
        mult = 1.15;
      }
      if (focusFamily == BiomechanicalFamily.upperPush &&
          fam == BiomechanicalFamily.noBarPull) {
        mult = 1.15;
      }
      scaledQuotas[fam] = math.max(6, (baseQuota * mult).round());
    });

    final DifficultyTier dominantTier = focusFamily != null
        ? (profile.familyTiers[focusFamily] ?? profile.fitnessLevel.recommendedTier)
        : profile.fitnessLevel.recommendedTier;

    final String focusTag = focusFamily != null
        ? ' • Focus ${_familyClearBenefitLabel(focusFamily)}'
        : '';

    return buildMission(
      id: 'custom_${format.code.toLowerCase()}_${minutes}m',
      code: 'SÉANCE • ${minutes}M',
      title: '${format.title}$focusTag',
      subtitle: isExpress
          ? '$minutes min • Réveil articulaire, posture & tonicité express'
          : '$minutes min • Séries & récupérations 100 % auto-enchaînées (${profile.fitnessLevel.title})',
      format: format,
      tier: dominantTier,
      repQuotas: scaledQuotas,
      familyTiers: profile.familyTiers,
      posturalBalanceRatio: profile.posturalBalanceRatio,
      extraRestSeconds: extraRest,
      durationMinutesOverride: minutes,
      isRecoveryDay: isExpress,
      fitnessLevel: profile.fitnessLevel,
    );
  }

  /// Génère les 5 séances rapides guidées (`6 min`, `8 min` ou `10 min max`).
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

  static String _dayFocusTheme(int day, OperationalCampaignId campaign) {
    const List<String> themes = <String>[
      'Remise en Forme Complète',
      'Tonus Buste & Dos Solide',
      'Vitalité Jambes & Gainage',
      'Mobilité Douce & Dos Détendu',
      'Posture & Énergie Globale',
      'Ventre Plat & Souffle',
      'Récupération Active & Souplesse',
    ];
    if (day == 1) {
      return 'Remise en Forme Complète';
    }
    return themes[(day - 1) % themes.length];
  }

  /// Génère les 28 séances quotidiennes d'un Programme de 28 Jours (`6`, `8` ou `10` min max).
  static List<TacticalMission> missionsForCampaign(
    OperationalCampaignId campaign,
    Map<BiomechanicalFamily, int> repQuotas, {
    Map<BiomechanicalFamily, DifficultyTier>? familyTiers,
    double posturalBalanceRatio = 1.0,
    int extraRestSeconds = 0,
    int? preferredSessionMinutes,
    FitnessInitialLevel? fitnessLevel,
  }) {
    final List<TacticalMission> list = <TacticalMission>[];
    const List<WorkoutFormatType> cycleFormats = <WorkoutFormatType>[
      WorkoutFormatType.emomOperational, // J1 : 10 min
      WorkoutFormatType.amrapHighDensity, // J2 : 8 min
      WorkoutFormatType.tabataHiit, // J3 : 8 min
      WorkoutFormatType.flashPt5Min, // J4 : 6 min Mobilité & Récupération
      WorkoutFormatType.tacticalPyramid, // J5 : 10 min
      WorkoutFormatType.emomOperational, // J6 : 10 min
      WorkoutFormatType.flashPt5Min, // J7 : 6 min Mobilité & Récupération
    ];

    for (int day = 1; day <= 28; day++) {
      final bool isRecovery = (day % 7 == 4) || (day % 7 == 0 && day != 28);
      final bool isBoss = day == 28;
      final WorkoutFormatType format = isBoss
          ? WorkoutFormatType.tacticalPyramid
          : cycleFormats[(day - 1) % cycleFormats.length];

      final int week = ((day - 1) ~/ 7) + 1;
      final (String weekLabel, double weekVolumeFactor) = switch (week) {
        1 => ('Semaine 1 • Mise en route', 0.92),
        2 => ('Semaine 2 • Régularité', 1.00),
        3 => ('Semaine 3 • Tonus & Vitalité', 1.08),
        _ => ('Semaine 4 • Forme durable', isBoss ? 1.15 : 0.95),
      };

      final int dayMinutes = preferredSessionMinutes != null
          ? normalizeSessionMinutes(preferredSessionMinutes)
          : normalizeSessionMinutes(isRecovery ? 6 : format.defaultMinutes);

      final Map<BiomechanicalFamily, int> dayQuotas =
          <BiomechanicalFamily, int>{
            for (final MapEntry<BiomechanicalFamily, int> e
                in repQuotas.entries)
              e.key: math.max(6, (e.value * weekVolumeFactor).round()),
          };

      final String theme = _dayFocusTheme(day, campaign);

      list.add(
        buildMission(
          id: '${campaign.code.toLowerCase()}_d$day',
          code: 'JOUR $day • ${dayMinutes}M',
          title: isBoss
              ? 'Séance Jour 28 — Bilan Final ${campaign.title} ($dayMinutes min)'
              : isRecovery
              ? 'Séance Jour $day — Mobilité Douce & Récupération ($dayMinutes min)'
              : 'Séance Jour $day — $theme ($dayMinutes min)',
          subtitle: isRecovery
              ? '$dayMinutes min • Dérouillage articulaire, dos relâché & respiration guidée'
              : '$dayMinutes min • $weekLabel • Échauffement, séries & repos automatiques',
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
          durationMinutesOverride: dayMinutes,
          fitnessLevel: fitnessLevel,
        ),
      );
    }
    return list;
  }

  /// Les 4 Défis de Progression (6 minutes chrono, 100 % guidés automatiquement).
  static List<PromotionTrialSpec> buildPromotionTrials(
    Map<BiomechanicalFamily, int> repQuotas,
  ) {
    return <PromotionTrialSpec>[
      PromotionTrialSpec(
        targetRank: MilitaryRank.e3Corporal,
        code: 'DEFI-01',
        title: 'Défi Progression #1 — Fondations Toniques (6 min)',
        bonusTxp: 500,
        block1Description: 'Haut du corps : Pompes classiques & ouverture du dos au sol',
        block2Description: 'Jambes : Squats contrôlés & fentes arrière douces',
        block3Description: 'Gainage : Planche sur avant-bras & pas dynamiques',
        stealthAdaptationNote: 'Option Sans Saut : Pas latéraux dynamiques sans impact',
        mission: buildMission(
          id: 'trial_e3',
          code: 'DEFI • 6M',
          title: 'Défi Progression #1 — Fondations Toniques (6 min)',
          subtitle: '6 min • Séance bilan complète (+500 XP)',
          format: WorkoutFormatType.emomOperational,
          tier: DifficultyTier.tier2Soldier,
          repQuotas: repQuotas,
          promotionTrialRank: MilitaryRank.e3Corporal,
          durationMinutesOverride: 6,
        ),
      ),
      PromotionTrialSpec(
        targetRank: MilitaryRank.e5StaffSergeant,
        code: 'DEFI-02',
        title: 'Défi Progression #2 — Vitalité & Gainage Solide (6 min)',
        bonusTxp: 750,
        block1Description: 'Haut du corps : Pompes toniques & renforcement haut du dos',
        block2Description: 'Jambes : Squats pause & fentes alternées',
        block3Description: 'Gainage & Souffle : Gainage creux & burpees maîtrisés',
        stealthAdaptationNote: 'Option Sans Saut : Burpees décomposés un pied après l\'autre',
        mission: buildMission(
          id: 'trial_e5',
          code: 'DEFI • 6M',
          title: 'Défi Progression #2 — Vitalité & Gainage Solide (6 min)',
          subtitle: '6 min • Séance bilan intermédiaire (+750 XP)',
          format: WorkoutFormatType.amrapHighDensity,
          tier: DifficultyTier.tier3Nco,
          repQuotas: repQuotas,
          promotionTrialRank: MilitaryRank.e5StaffSergeant,
          durationMinutesOverride: 6,
        ),
      ),
      PromotionTrialSpec(
        targetRank: MilitaryRank.o1Lieutenant,
        code: 'DEFI-03',
        title: 'Défi Progression #3 — Posture & Endurance Active (6 min)',
        bonusTxp: 1200,
        block1Description: 'Haut du corps : Pompes épaules & tirage glissé au sol',
        block2Description: 'Jambes : Fentes latérales & squats pause toniques',
        block3Description: 'Gainage & Cardio : Fermetures abdos & circuit complet',
        stealthAdaptationNote: 'Option Sans Saut : Circuit complet en pas alternés silencieux',
        mission: buildMission(
          id: 'trial_o1',
          code: 'DEFI • 6M',
          title: 'Défi Progression #3 — Posture & Endurance Active (6 min)',
          subtitle: '6 min • Séance bilan avancée (+1 200 XP)',
          format: WorkoutFormatType.tacticalPyramid,
          tier: DifficultyTier.tier4Officer,
          repQuotas: repQuotas,
          promotionTrialRank: MilitaryRank.o1Lieutenant,
          durationMinutesOverride: 6,
        ),
      ),
      PromotionTrialSpec(
        targetRank: MilitaryRank.sf1Operator,
        code: 'DEFI-04',
        title: 'Défi Progression #4 — Maîtrise Athlétique Complète (6 min)',
        bonusTxp: 2000,
        block1Description: 'Haut du corps : Pompes latérales & pont thoracique',
        block2Description: 'Jambes : Flexions sur 1 jambe & fentes latérales',
        block3Description: 'Gainage & Énergie : Équerre assise & double pompe',
        stealthAdaptationNote: 'Option Sans Saut : Double pompe & relevé fluide sans sauter',
        mission: buildMission(
          id: 'trial_sf1',
          code: 'DEFI • 6M',
          title: 'Défi Progression #4 — Maîtrise Athlétique Complète (6 min)',
          subtitle: '6 min • Séance bilan maîtrise (+2 000 XP)',
          format: WorkoutFormatType.tacticalPyramid,
          tier: DifficultyTier.tier5SpecOps,
          repQuotas: repQuotas,
          promotionTrialRank: MilitaryRank.sf1Operator,
          durationMinutesOverride: 6,
        ),
      ),
    ];
  }
}
