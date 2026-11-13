import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/makefit_catalog.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/anatomical_mannequin_painter.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// Onglet 2 — `EXERCICES` (`v1.1.0` — Guide Visuel Simple & Mannequin Animé en Continu).
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
  double _inspectorAnimPhase = 0.0;
  Timer? _autoAnimTimer;

  @override
  void initState() {
    super.initState();
    _autoAnimTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _inspectorAnimPhase = (_inspectorAnimPhase + 0.035) % 1.0;
        });
      },
    );
  }

  @override
  void dispose() {
    _autoAnimTimer?.cancel();
    super.dispose();
  }

  String _zoneLabel(BiomechanicalFamily family) {
    return switch (family) {
      BiomechanicalFamily.upperPush => 'Buste & Bras',
      BiomechanicalFamily.noBarPull => 'Dos & Posture',
      BiomechanicalFamily.tacticalLegs => 'Jambes',
      BiomechanicalFamily.ironCore => 'Abdos & Gainage',
      BiomechanicalFamily.metCon => 'Cardio',
    };
  }

  void _selectExerciseNode(TacticalExercise exercise) {
    HapticFeedback.selectionClick();
    setState(() {
      _inspectedExercise = exercise;
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

  void _launchSingleExerciseMission(TacticalExercise exercise) {
    final TacticalMission singleMission = TacticalMission(
      id: 'exercise_focus_${exercise.id}',
      code: 'ATELIER • ${exercise.code}',
      title: 'Séance Guidée — ${exercise.name}',
      subtitle:
          '${_zoneLabel(exercise.family)} • Mouvement guidé & Retour au calme',
      format: WorkoutFormatType.flashPt5Min,
      durationMinutes: 6,
      recommendedTier: exercise.tier,
      targetRpe: 3,
      steps: <WorkoutStationStep>[
        WorkoutStationStep(
          stage: WorkoutStepStage.mainWork,
          title: 'Série 1/2 — ${exercise.name}',
          subtitle: 'Suis le rythme de l\'animation à l\'écran',
          exercise: exercise,
          durationSeconds: 40,
          targetReps: exercise.defaultTargetReps,
          isTimedWork: true,
          roundIndex: 1,
          totalRounds: 2,
        ),
        const WorkoutStationStep(
          stage: WorkoutStepStage.restRecovery,
          title: 'Récupération Active (20s)',
          subtitle: 'Respire profondément et relâche les épaules',
          exercise: MakeFitCatalog.h2fBoxBreathingExercise,
          durationSeconds: 20,
          targetReps: 2,
          isTimedWork: true,
          roundIndex: 1,
          totalRounds: 2,
        ),
        WorkoutStationStep(
          stage: WorkoutStepStage.mainWork,
          title: 'Série 2/2 — ${exercise.name}',
          subtitle: 'Garde une posture propre jusqu\'au bip',
          exercise: exercise,
          durationSeconds: 40,
          targetReps: exercise.defaultTargetReps,
          isTimedWork: true,
          roundIndex: 2,
          totalRounds: 2,
        ),
        const WorkoutStationStep(
          stage: WorkoutStepStage.h2fCooldown,
          title: 'Retour au calme & Respiration',
          subtitle: 'Récupération respiratoire guidée',
          exercise: MakeFitCatalog.h2fBoxBreathingExercise,
          durationSeconds: 60,
          targetReps: 4,
          isTimedWork: true,
          roundIndex: 1,
          totalRounds: 1,
        ),
      ],
    );
    widget.engine.startMission(singleMission);
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
          _buildHeaderAndZoneFilters(),
          const SizedBox(height: 14),
          _buildAnimatedExerciseCoachCard(profile, _inspectedExercise),
          const SizedBox(height: 16),
          ...displayedFamilies.map(
            (BiomechanicalFamily family) =>
                _buildZoneExercisesSection(profile, family),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAndZoneFilters() {
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
            'GUIDE VISUEL DES EXERCICES SANS MATÉRIEL',
            style: TextStyle(
              color: MakeFitTheme.amberTactical,
              fontWeight: FontWeight.w900,
              fontSize: 12.5,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sélectionne un exercice pour voir la démonstration animée en continu.',
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
                label: 'Tous',
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
                  label: _zoneLabel(fam),
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
            fontWeight: FontWeight.w800,
            fontSize: 11.5,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedExerciseCoachCard(
    SoldierProfileState profile,
    TacticalExercise ex,
  ) {
    final String primaryMusclesText =
        ex.primaryMuscles.map((MuscleGroup m) => m.label).join(' • ');

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
                      '${_zoneLabel(ex.family).toUpperCase()} • NIVEAU ${ex.tier.level}/5',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ex.family.accentColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.5,
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
                height: 176,
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.cameraswitch_rounded,
                          color: ex.family.accentColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Vue : ${_inspectorCameraAngle.label}',
                          style: const TextStyle(
                            color: MakeFitTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '3 CONSEILS CLÉS POUR UNE BONNE POSTURE :',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontWeight: FontWeight.w900,
              fontSize: 10.5,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: ex.hudCues.map((String cue) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: ex.family.accentColor.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: ex.family.accentColor.withValues(alpha: 0.55),
                  ),
                ),
                child: Text(
                  cue,
                  style: TextStyle(
                    color: ex.family.accentColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(growable: false),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MakeFitTheme.slateSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MakeFitTheme.slateBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Zones travaillées : $primaryMusclesText',
                  style: const TextStyle(
                    color: MakeFitTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Option douce articulations : ${ex.wristKneeVariantName}',
                  style: const TextStyle(
                    color: MakeFitTheme.emeraldH2f,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          JuicyTactical3DButton(
            label: 'Lancer cet exercice',
            subtitle:
                'Démarrer un atelier guidé sur ${ex.name} avec chrono auto',
            icon: Icons.play_arrow_rounded,
            height: 52,
            backgroundColor: ex.family.accentColor,
            bottomLipColor: MakeFitTheme.slateBorder,
            foregroundColor: MakeFitTheme.oledBlack,
            onPressed: () => _launchSingleExerciseMission(ex),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneExercisesSection(
    SoldierProfileState profile,
    BiomechanicalFamily family,
  ) {
    final List<TacticalExercise> exercises =
        MakeFitCatalog.exercisesByFamily(family);

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
                BiomechanicalFamilyBadge(family: family, size: 32),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${_zoneLabel(family)} — ${family.label}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: family.accentColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...exercises.map((TacticalExercise ex) {
              final bool isSelected = ex.id == _inspectedExercise.id;

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
                            : MakeFitTheme.slateBorder,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 34,
                          height: 34,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: family.accentColor.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: family.accentColor),
                          ),
                          child: Text(
                            'N${ex.tier.level}',
                            style: TextStyle(
                              color: family.accentColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 11.5,
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
                                ex.hudCues.join(' • '),
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
                          isSelected
                              ? Icons.play_circle_fill_rounded
                              : Icons.visibility_outlined,
                          color: isSelected
                              ? family.accentColor
                              : MakeFitTheme.textSecondary,
                          size: 20,
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
