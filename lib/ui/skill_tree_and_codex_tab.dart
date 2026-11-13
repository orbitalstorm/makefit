import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/makefit_catalog.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/anatomical_mannequin_painter.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// Onglet 2 — `SKILL TREE 25` (Arbre de Compétences Biomécaniques 5 Familles × 5 Échelons
/// & Codex Anatomique 60 FPS Sans Matériel).
class SkillTreeAndCodexTab extends StatefulWidget {
  const SkillTreeAndCodexTab({
    super.key,
    required this.engine,
  });

  final MakeFitEngine engine;

  @override
  State<SkillTreeAndCodexTab> createState() => _SkillTreeAndCodexTabState();
}

class _SkillTreeAndCodexTabState extends State<SkillTreeAndCodexTab> {
  BiomechanicalFamily? _selectedFamilyFilter;
  TacticalExercise _inspectedExercise = MakeFitCatalog.allExercises.first;
  MannequinCameraAngle _inspectorCameraAngle =
      MannequinCameraAngle.threeQuarterTactical;
  double _inspectorAnimPhase = 0.35;

  void _selectExerciseNode(TacticalExercise exercise) {
    HapticFeedback.selectionClick();
    setState(() {
      _inspectedExercise = exercise;
      _inspectorAnimPhase = (_inspectorAnimPhase + 0.28) % 1.0;
    });
  }

  void _cycleInspectorAngle() {
    HapticFeedback.lightImpact();
    final List<MannequinCameraAngle> angles = MannequinCameraAngle.values;
    setState(() {
      _inspectorCameraAngle =
          angles[(_inspectorCameraAngle.index + 1) % angles.length];
    });
  }

  void _launchSingleExerciseTestMission(TacticalExercise exercise) {
    final SoldierProfileState profile = widget.engine.profile;
    final TacticalMission testMission = TacticalMission(
      id: 'codex_test_${exercise.id}',
      code: 'CODEX • ${exercise.code}',
      title: 'Test Biomécanique — ${exercise.name}',
      subtitle:
          '${exercise.family.label} • ${exercise.tier.shortTitle} • Tempo ${exercise.tempo}',
      format: WorkoutFormatType.flashPt5Min,
      durationMinutes: 5,
      recommendedTier: exercise.tier,
      targetRpe: 3,
      steps: <WorkoutStationStep>[
        WorkoutStationStep(
          stage: WorkoutStepStage.mainWork,
          title: 'Atelier Technique — ${exercise.name}',
          subtitle: exercise.masteryStandardLabel,
          exercise: exercise,
          durationSeconds:
              exercise.isIsometric ? exercise.defaultHoldSeconds : 60,
          targetReps: exercise.defaultTargetReps,
          isTimedWork: exercise.isIsometric,
          roundIndex: 1,
          totalRounds: 1,
        ),
        const WorkoutStationStep(
          stage: WorkoutStepStage.h2fCooldown,
          title: 'Décompression H2F & Box Breathing (4-4-4-4)',
          subtitle: 'Retour au calme parasympathique',
          exercise: MakeFitCatalog.h2fBoxBreathingExercise,
          durationSeconds: 120,
          targetReps: 8,
          isTimedWork: true,
          roundIndex: 1,
          totalRounds: 1,
        ),
      ],
    );
    if (profile.stealthApartmentMode) {
      // Déjà pris en compte par engine.startMission
    }
    widget.engine.startMission(testMission);
  }

  @override
  Widget build(BuildContext context) {
    final SoldierProfileState profile = widget.engine.profile;
    final List<BiomechanicalFamily> displayedFamilies =
        _selectedFamilyFilter == null
            ? BiomechanicalFamily.values
            : <BiomechanicalFamily>[_selectedFamilyFilter!];

    return ColoredBox(
      color: MakeFitTheme.oledBlack,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: <Widget>[
          _buildHeaderAndFamilyFilters(),
          const SizedBox(height: 14),
          _buildExerciseInspectorCard(profile, _inspectedExercise),
          const SizedBox(height: 16),
          ...displayedFamilies.map(
            (BiomechanicalFamily family) =>
                _buildFamilySkillBranch(profile, family),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAndFamilyFilters() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MakeFitTheme.slateBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'SKILL TREE BIOMÉCANIQUE — 25 NŒUDS SANS MATÉRIEL',
            style: TextStyle(
              color: MakeFitTheme.amberTactical,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '5 Familles × 5 Échelons (Recrue T1 à SpecOps T5) • 0 Barre de traction requise',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _buildFilterChip(
                label: 'TOUTES (25)',
                selected: _selectedFamilyFilter == null,
                accentColor: MakeFitTheme.amberTactical,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedFamilyFilter = null);
                },
              ),
              ...BiomechanicalFamily.values.map((BiomechanicalFamily fam) {
                final bool selected = _selectedFamilyFilter == fam;
                return _buildFilterChip(
                  label: fam.shortLabel,
                  selected: selected,
                  accentColor: fam.accentColor,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedFamilyFilter = fam;
                      _inspectedExercise =
                          MakeFitCatalog.exercisesByFamily(fam).first;
                    });
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? accentColor.withValues(alpha: 0.24)
              : MakeFitTheme.slateSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? accentColor : MakeFitTheme.slateBorder,
            width: selected ? 1.8 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? accentColor : MakeFitTheme.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseInspectorCard(
    SoldierProfileState profile,
    TacticalExercise ex,
  ) {
    final String primaryMusclesText =
        ex.primaryMuscles.map((MuscleGroup m) => m.label).join(' • ');
    final String secondaryMusclesText =
        ex.secondaryMuscles.map((MuscleGroup m) => m.label).join(' • ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ex.family.accentColor, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              BiomechanicalFamilyBadge(family: ex.family, size: 40),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'FICHE D\'INSPECTION • ${ex.code} (${ex.tier.shortTitle})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ex.family.accentColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ex.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: <Widget>[
              AnatomicalMannequinView(
                exercise: ex,
                animationPhase: _inspectorAnimPhase,
                cameraAngle: _inspectorCameraAngle,
                stealthMode: profile.stealthApartmentMode,
                jointMode: profile.jointFriendlyMode,
                height: 168,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _cycleInspectorAngle,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: MakeFitTheme.oledBlack.withValues(alpha: 0.86),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: ex.family.accentColor),
                    ),
                    child: Text(
                      'Angle : ${_inspectorCameraAngle.label}',
                      style: const TextStyle(
                        color: MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              _buildMetaBadge('TEMPO ${ex.tempo}', MakeFitTheme.amberTactical),
              _buildMetaBadge(
                'STANDARD : ${ex.masteryStandardLabel}',
                MakeFitTheme.emeraldH2f,
              ),
              ...ex.hudCues.map(
                (String c) => _buildMetaBadge(c, ex.family.accentColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildDetailBlock(
            title: 'MUSCLES PRIMAIRES & SECONDAIRES',
            body:
                'Agonistes : $primaryMusclesText\nSynergistes : $secondaryMusclesText',
            accent: ex.family.accentColor,
          ),
          const SizedBox(height: 8),
          _buildDetailBlock(
            title: 'ERREUR FRÉQUENTE À ÉVITER',
            body: ex.commonMistake,
            accent: MakeFitTheme.coralAlert,
          ),
          const SizedBox(height: 8),
          _buildDetailBlock(
            title:
                'VARIANTE MODE SILENCIEUX APPARTEMENT : ${ex.stealthVariantName}',
            body: ex.stealthVariantDescription,
            accent: MakeFitTheme.cyanRadar,
          ),
          const SizedBox(height: 8),
          _buildDetailBlock(
            title:
                'VARIANTE WRIST/KNEE-FRIENDLY : ${ex.wristKneeVariantName}',
            body: ex.wristKneeVariantDescription,
            accent: MakeFitTheme.emeraldH2f,
          ),
          const SizedBox(height: 12),
          JuicyTactical3DButton(
            label: 'TESTER CET EXERCICE',
            subtitle:
                'Déployer ${ex.code} dans le HUD 2m (${ex.defaultTargetReps} reps)',
            icon: Icons.bolt_rounded,
            height: 52,
            backgroundColor: ex.family.accentColor,
            bottomLipColor: MakeFitTheme.slateBorder,
            foregroundColor: MakeFitTheme.oledBlack,
            onPressed: () => _launchSingleExerciseTestMission(ex),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildDetailBlock({
    required String title,
    required String body,
    required Color accent,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w900,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            body,
            style: const TextStyle(
              color: MakeFitTheme.textPrimary,
              fontSize: 11.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilySkillBranch(
    SoldierProfileState profile,
    BiomechanicalFamily family,
  ) {
    final List<TacticalExercise> exercises =
        MakeFitCatalog.exercisesByFamily(family);
    final DifficultyTier unlockedTier =
        profile.familyTiers[family] ?? DifficultyTier.tier2Soldier;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MakeFitTheme.slateCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: family.accentColor.withValues(alpha: 0.55),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                BiomechanicalFamilyBadge(family: family, size: 34),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${family.shortLabel} — ${family.label.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: family.accentColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Échelon actif : ${unlockedTier.shortTitle} • Quota ${profile.familyRepQuotas[family] ?? 15} reps',
                        style: const TextStyle(
                          color: MakeFitTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...exercises.map((TacticalExercise ex) {
              final bool isSelected = ex.id == _inspectedExercise.id;
              final bool isUnlocked = ex.tier.level <= unlockedTier.level;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _selectExerciseNode(ex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? family.accentColor.withValues(alpha: 0.20)
                          : MakeFitTheme.slateSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? family.accentColor
                            : (isUnlocked
                                  ? family.accentColor.withValues(alpha: 0.45)
                                  : MakeFitTheme.slateBorder),
                        width: isSelected ? 2.0 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? family.accentColor.withValues(alpha: 0.22)
                                : MakeFitTheme.oledBlack,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isUnlocked
                                  ? family.accentColor
                                  : MakeFitTheme.slateBorder,
                            ),
                          ),
                          child: Text(
                            ex.tier.code,
                            style: TextStyle(
                              color: isUnlocked
                                  ? family.accentColor
                                  : MakeFitTheme.textSecondary,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                ex.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: MakeFitTheme.textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${ex.code} • ${ex.masteryStandardLabel} • Tempo ${ex.tempo}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: MakeFitTheme.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isUnlocked
                              ? Icons.verified_rounded
                              : Icons.lock_outline_rounded,
                          color: isUnlocked
                              ? family.accentColor
                              : MakeFitTheme.textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
