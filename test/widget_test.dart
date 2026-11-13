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
  const List<String> robotoPaths = <String>[
    '/tmp/flutter-sdk/flutter/bin/cache/artifacts/material_fonts/Roboto-Black.ttf',
    '/tmp/flutter-sdk/flutter/bin/cache/artifacts/material_fonts/Roboto-Bold.ttf',
    '/tmp/flutter-sdk/flutter/bin/cache/artifacts/material_fonts/Roboto-Medium.ttf',
    '/tmp/flutter-sdk/flutter/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf',
  ];
  final FontLoader robotoLoader = FontLoader('Roboto');
  bool robotoLoaded = false;
  for (final String path in robotoPaths) {
    final File f = File(path);
    if (f.existsSync()) {
      final Uint8List bytes = await f.readAsBytes();
      robotoLoader.addFont(Future<ByteData>.value(ByteData.sublistView(bytes)));
      robotoLoaded = true;
    }
  }
  if (robotoLoaded) {
    await robotoLoader.load();
  }

  final File iconFile = File(
    '/tmp/flutter-sdk/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (iconFile.existsSync()) {
    final FontLoader iconLoader = FontLoader('MaterialIcons');
    final Uint8List iconBytes = await iconFile.readAsBytes();
    iconLoader.addFont(Future<ByteData>.value(ByteData.sublistView(iconBytes)));
    await iconLoader.load();
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
  final ui.Image image = await tester.runAsync<ui.Image>(
    () => boundary.toImage(pixelRatio: 3.0),
  ).then((ui.Image? img) => img!);
  final ByteData? byteData = await tester.runAsync<ByteData?>(
    () => image.toByteData(format: ui.ImageByteFormat.png),
  );
  final Uint8List pngBytes = byteData!.buffer.asUint8List();
  final File outFile = File(relativePath);
  outFile.parent.createSync(recursive: true);
  outFile.writeAsBytesSync(pngBytes);
}

void main() {
  test('Catalogue Scientifique MakeFit : 25 Exercices Sans Matériel, 4 Campagnes 28J & 4 Examens PT', () {
    expect(MakeFitCatalog.allExercises.length, 25);

    for (final BiomechanicalFamily fam in BiomechanicalFamily.values) {
      final List<TacticalExercise> byFam = MakeFitCatalog.exercisesByFamily(fam);
      expect(byFam.length, 5, reason: 'Chaque famille doit avoir exactement 5 échelons');
      for (final TacticalExercise ex in byFam) {
        expect(ex.hudCues.length, 3);
        expect(ex.stealthVariantName.isNotEmpty, isTrue);
        expect(ex.wristKneeVariantName.isNotEmpty, isTrue);
      }
    }

    final MakeFitEngine engine = MakeFitEngine();
    for (final OperationalCampaignId camp in OperationalCampaignId.values) {
      final List<TacticalMission> missions = MakeFitCatalog.missionsForCampaign(
        camp,
        engine.profile.familyRepQuotas,
      );
      expect(missions.length, 28);
      expect(missions.last.isBossMission, isTrue);
    }

    final List<PromotionTrialSpec> trials = MakeFitCatalog.buildPromotionTrials(
      engine.profile.familyRepQuotas,
    );
    expect(trials.length, 4);
  });

  test('Moteur Mathématique MakeFit : Calibration IAO 6m, Formule TXP, Grades E-1..SF-2, RPE & Debounce 650ms', () {
    final BaselinePtCalibrationResult cal = MakeFitEngine.evaluateBaselinePtTest(
      pushupsIn2Min: 32,
      squatsIn2Min: 48,
      plankSeconds: 75,
    );
    expect(cal.iaoGlobalIndex, inInclusiveRange(50, 75));
    expect(cal.initialUnlockedRank, MilitaryRank.e3Corporal);

    final MakeFitEngine engine = MakeFitEngine();
    final TacticalMission mission = engine.todayRecommendedMission;
    engine.startMission(mission);
    expect(engine.liveWorkoutNotifier.value, isNotNull);

    // Avancer à la 1re station de travail (après RAMP)
    engine.advanceToNextWorkoutStep();
    expect(
      engine.liveWorkoutNotifier.value!.currentStep.stage,
      WorkoutStepStage.mainWork,
    );

    // Test du filtre anti-rebond 650 ms en mode Sans Contact
    final bool firstRep = engine.registerContactlessRep();
    final bool immediateDuplicate = engine.registerContactlessRep();
    expect(firstRep, isTrue);
    expect(immediateDuplicate, isFalse, reason: 'Debounce 650ms doit rejeter un double tap immédiat');

    // Passage en Debriefing & vérification RPE 1..5 + Gain TXP
    while (engine.liveWorkoutNotifier.value!.phase !=
        WorkoutExecutionPhase.debriefingVictory) {
      engine.advanceToNextWorkoutStep();
    }
    engine.selectDebriefRpe(3);
    final TxpBreakdown breakdown = engine.liveWorkoutNotifier.value!.txpBreakdown!;
    expect(breakdown.rampH2fBonusTxp, 100);
    expect(breakdown.rpeHonestyBonusTxp, 25);
    expect(breakdown.totalTxp, greaterThan(400));

    final int prevTxp = engine.profile.totalTxp;
    final int prevStreak = engine.profile.currentStreakDays;
    engine.confirmMissionDebriefAndClaimLoot();
    expect(engine.profile.totalTxp, greaterThan(prevTxp));
    expect(engine.profile.currentStreakDays, prevStreak + 1);
    expect(engine.liveWorkoutNotifier.value, isNull);
  });

  testWidgets('Parcours UI Complet MakeFit v1.0.0 & Génération des 6 Captures Store Portrait 1080x2400', (
    WidgetTester tester,
  ) async {
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
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);

    // 01. Capture Command Center & Campagnes 28J
    await _captureScreenshot(
      tester,
      boundaryKey,
      'screenshots/01_command_center_and_campaigns.png',
    );

    // Démarrage de la Mission du Jour -> Passage à la station Push-up (HUD 2m + Mannequin 3D/2.5D)
    engine.startMission(engine.todayRecommendedMission);
    engine.advanceToNextWorkoutStep(); // Station 1 Push-up
    engine.tickWorkout(deltaSeconds: 12, deltaAnimPhase: 0.35);
    await tester.pump(const Duration(milliseconds: 350));
    expect(tester.takeException(), isNull);

    // 02. Capture HUD Séance 2m & Mannequin Anatomique 60 FPS
    await _captureScreenshot(
      tester,
      boundaryKey,
      'screenshots/02_workout_hud_2m_mannequin_60fps.png',
    );

    // Avancer jusqu'à la phase finale Décompression H2F & Box Breathing (4-4-4-4)
    while (engine.liveWorkoutNotifier.value != null &&
        engine.liveWorkoutNotifier.value!.currentStep.stage !=
            WorkoutStepStage.h2fCooldown) {
      engine.advanceToNextWorkoutStep();
    }
    engine.tickWorkout(deltaSeconds: 6, deltaAnimPhase: 0.25);
    await tester.pump(const Duration(milliseconds: 350));
    expect(tester.takeException(), isNull);

    // 03. Capture Décompression H2F & Anneau Box Breathing 4-4-4-4
    await _captureScreenshot(
      tester,
      boundaryKey,
      'screenshots/03_h2f_box_breathing_cooldown.png',
    );

    // Avancer vers la Modale de Victoire & Debriefing RPE
    engine.advanceToNextWorkoutStep();
    engine.selectDebriefRpe(3);
    await tester.pump(const Duration(milliseconds: 450));
    expect(tester.takeException(), isNull);

    // 04. Capture Modale Debriefing Victoire, Jauge RPE & Loot TXP
    await _captureScreenshot(
      tester,
      boundaryKey,
      'screenshots/04_victory_debrief_rpe_and_txp_loot.png',
    );

    // Valider le Debriefing et fermer la modale
    engine.confirmMissionDebriefAndClaimLoot();
    await tester.pump(const Duration(milliseconds: 350));
    expect(tester.takeException(), isNull);

    // Basculer sur l'onglet 2 : SKILL TREE 25
    await tester.tap(find.text('SKILL TREE 25'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);

    // 05. Capture Arbre de Compétences Biomécaniques (25 Nœuds Sans Matériel)
    await _captureScreenshot(
      tester,
      boundaryKey,
      'screenshots/05_calisthenics_skill_tree_25_nodes.png',
    );

    // Basculer sur l'onglet 3 : CASERNE & PT
    await tester.tap(find.text('CASERNE & PT'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);

    // 06. Capture La Caserne : 12 Grades Militaires, 4 Examens PT & Calibrateur IAO
    await _captureScreenshot(
      tester,
      boundaryKey,
      'screenshots/06_barracks_12_ranks_and_pt_trials.png',
    );
  });
}
