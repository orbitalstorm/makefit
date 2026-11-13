import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:makefit/data/makefit_catalog.dart';
import 'package:makefit/engine/makefit_engine.dart';
import 'package:makefit/main.dart';
import 'package:makefit/models/makefit_models.dart';

Future<void> _loadRobotoAndMaterialIconsIfAvailable() async {
  final String? envFlutterRoot = Platform.environment['FLUTTER_ROOT'];
  final List<String> sdkRoots = <String>[
    if (envFlutterRoot != null && envFlutterRoot.isNotEmpty) envFlutterRoot,
    '/tmp/flutter-sdk/flutter',
  ];

  const List<String> robotoFiles = <String>[
    'Roboto-Black.ttf',
    'Roboto-Bold.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Regular.ttf',
  ];

  for (final String root in sdkRoots) {
    final String fontDir = '$root/bin/cache/artifacts/material_fonts';
    if (!Directory(fontDir).existsSync()) {
      continue;
    }
    final FontLoader robotoLoader = FontLoader('Roboto');
    bool robotoLoaded = false;
    for (final String fileName in robotoFiles) {
      final File f = File('$fontDir/$fileName');
      if (f.existsSync()) {
        final Uint8List bytes = await f.readAsBytes();
        robotoLoader.addFont(
          Future<ByteData>.value(ByteData.sublistView(bytes)),
        );
        robotoLoaded = true;
      }
    }
    if (robotoLoaded) {
      await robotoLoader.load();
    }

    final File iconFile = File('$fontDir/MaterialIcons-Regular.otf');
    if (iconFile.existsSync()) {
      final FontLoader iconLoader = FontLoader('MaterialIcons');
      final Uint8List iconBytes = await iconFile.readAsBytes();
      iconLoader.addFont(
        Future<ByteData>.value(ByteData.sublistView(iconBytes)),
      );
      await iconLoader.load();
    }
    break;
  }
}

Future<void> _captureScreenshot(
  WidgetTester tester,
  GlobalKey boundaryKey,
  String relativePath,
) async {
  await tester.pump(const Duration(milliseconds: 120));
  final RenderRepaintBoundary boundary =
      boundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final ui.Image image = await tester
      .runAsync<ui.Image>(() => boundary.toImage(pixelRatio: 3.0))
      .then((ui.Image? img) => img!);
  final ByteData? byteData = await tester.runAsync<ByteData?>(
    () => image.toByteData(format: ui.ImageByteFormat.png),
  );
  final Uint8List pngBytes = byteData!.buffer.asUint8List();
  final File outFile = File(relativePath);
  outFile.parent.createSync(recursive: true);
  outFile.writeAsBytesSync(pngBytes);
}

void main() {
  test(
    'Profil par défaut vierge (0 donnée d\'exemple) & Catalogue 25 Exercices / 4 Programmes 28J',
    () {
      expect(MakeFitCatalog.allExercises.length, 25);

      for (final BiomechanicalFamily fam in BiomechanicalFamily.values) {
        final List<TacticalExercise> byFam =
            MakeFitCatalog.exercisesByFamily(fam);
        expect(
          byFam.length,
          5,
          reason: 'Chaque famille doit avoir exactement 5 échelons',
        );
        for (final TacticalExercise ex in byFam) {
          expect(ex.hudCues.length, 3);
          expect(ex.stealthVariantName.isNotEmpty, isTrue);
          expect(ex.wristKneeVariantName.isNotEmpty, isTrue);
        }
      }

      // Vérification ZÉRO donnée d'exemple au démarrage
      final MakeFitEngine engine = MakeFitEngine();
      expect(engine.profile.isProfileCreated, isFalse);
      expect(engine.profile.totalTxp, 0);
      expect(engine.profile.completedSessionsCount, 0);
      expect(engine.profile.currentStreakDays, 0);
      expect(engine.profile.currentCampaignDay, 1);
      expect(engine.profile.totalMinutesTrained, 0);
      expect(engine.profile.completedMissionIds, isEmpty);

      for (final OperationalCampaignId camp in OperationalCampaignId.values) {
        final List<TacticalMission> missions =
            MakeFitCatalog.missionsForCampaign(
          camp,
          engine.profile.familyRepQuotas,
        );
        expect(missions.length, 28);
        expect(missions.last.isBossMission, isTrue);
      }
    },
  );

  test(
    'Création du Profil 40+, Enchaînement de Séance 10 min & Validation +1 Séance / Série 1 Jour',
    () {
      final MakeFitEngine engine = MakeFitEngine();
      expect(engine.profile.isProfileCreated, isFalse);

      // Création du profil (Homme 40 ans, 10 min max)
      engine.completeProfileCreation(
        firstName: 'Thomas',
        ageYears: 40,
        goal: FitnessGoal40Plus.vitalityAndEnergy,
        level: FitnessInitialLevel.gentleRestart,
        preferredSessionMinutes: 10,
      );
      expect(engine.profile.isProfileCreated, isTrue);
      expect(engine.profile.displayName, 'Thomas');
      expect(engine.profile.ageYears, 40);
      expect(engine.profile.preferredSessionMinutes, 10);
      expect(engine.profile.currentCampaignDay, 1);
      expect(engine.profile.completedSessionsCount, 0);
      expect(engine.profile.currentStreakDays, 0);
      expect(engine.profile.totalTxp, 0);

      // Lancement de la séance du Jour 1
      final TacticalMission mission = engine.todayRecommendedMission;
      engine.startMission(mission);
      expect(engine.liveWorkoutNotifier.value, isNotNull);
      expect(
        engine.liveWorkoutNotifier.value!.currentStep.stage,
        WorkoutStepStage.rampWarmup,
      );

      // Avancement vers la 1re série
      engine.advanceToNextWorkoutStep();
      expect(
        engine.liveWorkoutNotifier.value!.currentStep.stage,
        WorkoutStepStage.mainWork,
      );

      // Enchaînement jusqu'à la fin de séance
      while (engine.liveWorkoutNotifier.value!.phase !=
          WorkoutExecutionPhase.debriefingVictory) {
        engine.advanceToNextWorkoutStep();
      }
      engine.selectDebriefRpe(3);
      final TxpBreakdown breakdown =
          engine.liveWorkoutNotifier.value!.txpBreakdown!;
      expect(breakdown.totalTxp, greaterThan(300));

      // Validation finale : +1 séance, Série = 1 jour, Passage au Jour 2
      engine.confirmMissionDebriefAndClaimLoot();
      expect(engine.profile.completedSessionsCount, 1);
      expect(engine.profile.currentStreakDays, 1);
      expect(engine.profile.totalTxp, greaterThan(0));
      expect(engine.profile.currentCampaignDay, 2);
      expect(engine.liveWorkoutNotifier.value, isNull);
    },
  );

  testWidgets(
    'Parcours UI Complet MakeFit v1.1.0 (Création Profil, GO 10 Min, Coach Animé Auto & 6 Captures 1080x2400)',
    (WidgetTester tester) async {
      await tester.runAsync(_loadRobotoAndMaterialIconsIfAvailable);
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final MakeFitEngine engine = MakeFitEngine();
      final GlobalKey boundaryKey = GlobalKey();

      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: MakeFitApp(engine: engine),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 1. Vérification de l'affichage de l'écran de Création du Profil au premier lancement
      expect(engine.profile.isProfileCreated, isFalse);
      expect(
        find.text(
          'Bienvenue sur MakeFit 40+ — Votre remise en forme en 10 min par jour',
        ),
        findsOneWidget,
      );
      expect(find.text('40 ans'), findsOneWidget);

      // Saisie rapide du prénom "Thomas" en 1 tap et création du profil
      await tester.tap(find.text('Thomas'));
      await tester.pump(const Duration(milliseconds: 100));

      // 00. Capture Écran de Création du Profil au premier lancement (40 ans, 10 min max)
      await _captureScreenshot(
        tester,
        boundaryKey,
        'screenshots/00_profile_creation_onboarding.png',
      );

      final Finder createBtn = find.text(
        'CRÉER MON PROFIL & COMMENCER AU JOUR 1',
      );
      await tester.ensureVisible(createBtn);
      await tester.tap(createBtn);
      await tester.pump(const Duration(milliseconds: 350));
      expect(tester.takeException(), isNull);

      // 2. Vérification de l'accueil AUJOURD'HUI à 0 séance / Jour 1
      expect(engine.profile.isProfileCreated, isTrue);
      expect(find.text('Bonjour Thomas • 40 ans'), findsOneWidget);
      expect(find.text('Série : 0 jour'), findsOneWidget);
      expect(find.text('Séances : 0'), findsOneWidget);
      expect(find.text('Temps : 0 min'), findsOneWidget);
      expect(find.text('GO — DÉMARRER LA SÉANCE'), findsOneWidget);

      // 01. Capture Accueil Clair AUJOURD'HUI (Séance 10 min max & Parcours 28 Jours)
      await _captureScreenshot(
        tester,
        boundaryKey,
        'screenshots/01_command_center_and_campaigns.png',
      );

      // 3. Lancement de la séance via le bouton GO
      await tester.tap(find.text('GO — DÉMARRER LA SÉANCE'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(engine.liveWorkoutNotifier.value, isNotNull);
      expect(tester.takeException(), isNull);

      // Vérification que le Timer.periodic anime automatiquement le mannequin et décrémente le chrono
      final double initialAnimPhase =
          engine.liveWorkoutNotifier.value!.animationCyclePhase;
      final int initialRemainingSec =
          engine.liveWorkoutNotifier.value!.stepRemainingSeconds;
      await tester.pump(const Duration(milliseconds: 1100));
      expect(
        engine.liveWorkoutNotifier.value!.animationCyclePhase,
        isNot(equals(initialAnimPhase)),
      );
      expect(
        engine.liveWorkoutNotifier.value!.stepRemainingSeconds,
        lessThan(initialRemainingSec),
      );

      // Avancer à la 1re série pour la capture du Coach Animé en plein mouvement
      engine.advanceToNextWorkoutStep();
      engine.tickWorkout(deltaSeconds: 8, deltaAnimPhase: 0.35);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 02. Capture Lecteur de Séance Automatique & Mannequin Animé 60 FPS
      await _captureScreenshot(
        tester,
        boundaryKey,
        'screenshots/02_workout_hud_2m_mannequin_60fps.png',
      );

      // Avancer jusqu'à la phase finale Retour au calme & Respiration (4-4-4-4)
      while (engine.liveWorkoutNotifier.value != null &&
          engine.liveWorkoutNotifier.value!.currentStep.stage !=
              WorkoutStepStage.h2fCooldown) {
        engine.advanceToNextWorkoutStep();
      }
      engine.tickWorkout(deltaSeconds: 6, deltaAnimPhase: 0.25);
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      // 03. Capture Retour au calme & Anneau de Respiration Guidée 4-4-4-4
      await _captureScreenshot(
        tester,
        boundaryKey,
        'screenshots/03_h2f_box_breathing_cooldown.png',
      );

      // Avancer vers l'écran de Fin de Séance Motivant
      engine.advanceToNextWorkoutStep();
      engine.selectDebriefRpe(3);
      await tester.pump(const Duration(milliseconds: 450));
      expect(tester.takeException(), isNull);
      expect(
        find.textContaining('Bravo Thomas ! Séance de'),
        findsOneWidget,
      );

      // 04. Capture Écran de Fin de Séance Motivant, Ressenti 1..5 & Points XP
      await _captureScreenshot(
        tester,
        boundaryKey,
        'screenshots/04_victory_debrief_rpe_and_txp_loot.png',
      );

      // Valider la séance et vérifier +1 séance et Série = 1 jour
      final Finder validateBtn = find.text('VALIDER MA SÉANCE & CONTINUER');
      await tester.ensureVisible(validateBtn);
      await tester.tap(validateBtn);
      await tester.pump(const Duration(milliseconds: 350));
      expect(tester.takeException(), isNull);
      expect(engine.profile.completedSessionsCount, 1);
      expect(engine.profile.currentStreakDays, 1);

      // Basculer sur l'onglet 2 : EXERCICES (avec animation continue automatique)
      await tester.tap(find.text('EXERCICES'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);

      // 05. Capture Onglet EXERCICES (Guide visuel & Mannequin animé auto)
      await _captureScreenshot(
        tester,
        boundaryKey,
        'screenshots/05_calisthenics_skill_tree_25_nodes.png',
      );

      // Basculer sur l'onglet 3 : MON PROFIL
      await tester.tap(find.text('MON PROFIL'));
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);

      // 06. Capture Onglet MON PROFIL (Identité 40+, Bilan, Calendrier 28J & Jalons)
      await _captureScreenshot(
        tester,
        boundaryKey,
        'screenshots/06_barracks_12_ranks_and_pt_trials.png',
      );
    },
  );
}
