import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/anatomical_mannequin_painter.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// Lecteur de Séance 100 % Automatique & Animé (`v1.1.0`).
/// - Défilement automatique du chronomètre et animation continue 60 FPS du Mannequin 3D/2.5D
///   via `Timer.periodic` (100ms pour l'animation, 1000ms pour la seconde du chronomètre),
/// - Enchaînement 100 % automatique : Échauffement -> Séries -> Repos -> Retour au calme -> Fin de séance,
/// - Carte de Motivation Dynamique temps réel, Grand Chronomètre central, Encart « À SUIVRE »
///   et Barre de contrôle simple (PAUSE/REPRENDRE, +15s REPOS, ADAPTER (PLUS DOUX), SUIVANT).
class WorkoutPlayerModal extends StatefulWidget {
  const WorkoutPlayerModal({
    super.key,
    required this.engine,
    required this.snapshot,
  });

  final MakeFitEngine engine;
  final WorkoutLiveSnapshot snapshot;

  @override
  State<WorkoutPlayerModal> createState() => _WorkoutPlayerModalState();
}

class _WorkoutPlayerModalState extends State<WorkoutPlayerModal> {
  Timer? _autoTimer;
  int _subSecondTickCounter = 0;

  @override
  void initState() {
    super.initState();
    _startAutoTimer();
  }

  void _startAutoTimer() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _onAutoTimerTick(),
    );
  }

  void _onAutoTimerTick() {
    if (!mounted) {
      return;
    }
    final WorkoutLiveSnapshot? snap = widget.engine.liveWorkoutNotifier.value;
    if (snap == null || snap.phase != WorkoutExecutionPhase.activeStep) {
      return;
    }

    _subSecondTickCounter += 1;
    if (_subSecondTickCounter >= 10) {
      _subSecondTickCounter = 0;
      final int prevStepIndex = snap.currentStepIndex;
      final int prevRemaining = snap.stepRemainingSeconds;

      widget.engine.tickWorkout(deltaSeconds: 1, deltaAnimPhase: 0.035);

      // Si l'étape n'était pas marquée isTimedWork dans le catalogue mais que son
      // chronomètre vient d'atteindre 00:00, on valide et enchaîne automatiquement !
      final WorkoutLiveSnapshot? afterSnap =
          widget.engine.liveWorkoutNotifier.value;
      if (afterSnap != null &&
          afterSnap.phase == WorkoutExecutionPhase.activeStep &&
          afterSnap.currentStepIndex == prevStepIndex &&
          afterSnap.stepRemainingSeconds <= 0 &&
          prevRemaining <= 1) {
        widget.engine.completeCurrentStepBatch();
      }
    } else {
      widget.engine.tickWorkout(deltaSeconds: 0, deltaAnimPhase: 0.035);
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  Color _stateAccentColor(WorkoutStepStage stage) {
    return switch (stage) {
      WorkoutStepStage.mainWork => const Color(0xFFF59E0B),
      WorkoutStepStage.restRecovery => const Color(0xFF06B6D4),
      WorkoutStepStage.rampWarmup => const Color(0xFF10B981),
      WorkoutStepStage.h2fCooldown => const Color(0xFF10B981),
    };
  }

  String _formatMinSec(int totalSeconds) {
    final int clamped = totalSeconds < 0 ? 0 : totalSeconds;
    final int mins = clamped ~/ 60;
    final int secs = clamped % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _buildUpNextText(WorkoutLiveSnapshot snap) {
    final WorkoutStationStep cur = snap.currentStep;
    if (cur.stage == WorkoutStepStage.restRecovery) {
      final WorkoutStationStep? nextWork = snap.nextWorkStep;
      if (nextWork != null) {
        return 'Prochain exercice : ${nextWork.exercise.name}';
      }
    }
    final WorkoutStationStep? next = snap.nextStep;
    if (next == null) {
      return 'Dernière étape avant la fin de ta séance !';
    }
    if (next.stage == WorkoutStepStage.restRecovery) {
      final WorkoutStationStep? upcomingWork = snap.nextWorkStep;
      if (upcomingWork != null) {
        return '${next.durationSeconds}s de Récupération puis ${upcomingWork.exercise.name}';
      }
      return '${next.durationSeconds}s de Récupération Active';
    }
    if (next.stage == WorkoutStepStage.h2fCooldown) {
      return 'Retour au calme & Respiration (${next.durationSeconds}s)';
    }
    return '${next.exercise.name} (${next.durationSeconds}s)';
  }

  @override
  Widget build(BuildContext context) {
    final WorkoutLiveSnapshot snap = widget.snapshot;

    return Material(
      color: MakeFitTheme.oledBlack,
      child: SafeArea(
        child: snap.phase == WorkoutExecutionPhase.debriefingVictory
            ? _buildDebriefingVictoryView(context, snap)
            : _buildAutomaticSessionPlayerView(context, snap),
      ),
    );
  }

  Widget _buildAutomaticSessionPlayerView(
    BuildContext context,
    WorkoutLiveSnapshot snap,
  ) {
    final WorkoutStationStep step = snap.currentStep;
    final TacticalExercise exercise = step.exercise;
    final Color stateColor = _stateAccentColor(step.stage);
    final bool isPaused = snap.phase == WorkoutExecutionPhase.paused;
    final String effectiveExName = exercise.effectiveName(
      stealthMode: snap.stealthModeActive,
      jointMode: snap.jointFriendlyMode,
    );

    return Column(
      children: <Widget>[
        // 1. En-tête clair : Phase actuelle, étape X/N, temps total restant et progression
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: stateColor.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: stateColor, width: 1.5),
                      ),
                      child: Text(
                        step.stage.bannerLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: stateColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 10.5,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Étape ${snap.currentStepIndex + 1}/${snap.mission.steps.length} • Reste ${_formatMinSec(snap.totalRemainingSeconds)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MakeFitTheme.textSecondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Quitter la séance',
                    onPressed: widget.engine.closeWorkoutModal,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: MakeFitTheme.textSecondary,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: snap.overallMissionProgress,
                  minHeight: 6,
                  backgroundColor: MakeFitTheme.slateCard,
                  valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                ),
              ),
            ],
          ),
        ),

        // 2. Zone centrale scrollable : Motivation + Mannequin animé auto + Grand Chrono + À suivre
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Carte de Motivation Dynamique
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: MakeFitTheme.slateCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: stateColor.withValues(alpha: 0.65),
                      width: 1.4,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        isPaused
                            ? Icons.pause_circle_filled_rounded
                            : Icons.bolt_rounded,
                        color: stateColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          snap.motivationalCoachMessage,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: MakeFitTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Titre de l'exercice en cours
                Text(
                  effectiveExName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MakeFitTheme.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  step.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MakeFitTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Grand Mannequin 3D/2.5D animé en continu
                Stack(
                  children: <Widget>[
                    AnatomicalMannequinView(
                      exercise: exercise,
                      animationPhase: snap.animationCyclePhase,
                      cameraAngle: snap.cameraAngle,
                      stealthMode: snap.stealthModeActive,
                      jointMode: snap.jointFriendlyMode,
                      height: step.stage == WorkoutStepStage.h2fCooldown
                          ? 130
                          : 164,
                    ),
                    Positioned(
                      top: 6,
                      right: 8,
                      child: GestureDetector(
                        onTap: widget.engine.cycleMannequinCameraAngle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                MakeFitTheme.oledBlack.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: stateColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.cameraswitch_rounded,
                                color: stateColor,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Vue : ${snap.cameraAngle.label}',
                                style: const TextStyle(
                                  color: MakeFitTheme.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // 3 pastilles de conseils simples
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: exercise.hudCues.map((String cue) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: MakeFitTheme.slateCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: stateColor.withValues(alpha: 0.65),
                        ),
                      ),
                      child: Text(
                        cue,
                        style: const TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(growable: false),
                ),
                const SizedBox(height: 8),

                // Anneau de respiration guidée pendant le retour au calme
                if (step.stage == WorkoutStepStage.h2fCooldown) ...<Widget>[
                  BoxBreathingRing(
                    phase: snap.currentBoxBreathingPhase,
                    stepElapsedSeconds: snap.stepElapsedSeconds,
                    size: 118,
                  ),
                  const SizedBox(height: 8),
                ],

                // Grand Chronomètre central ultra-lisible avec barre de progression fluide
                RepaintBoundary(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: MakeFitTheme.slateCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: stateColor.withValues(alpha: 0.85),
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _formatMinSec(snap.stepRemainingSeconds),
                                  style: TextStyle(
                                    color: stateColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 64,
                                    height: 1.0,
                                    fontFeatures: const <FontFeature>[
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: stateColor.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isPaused
                                        ? 'EN PAUSE'
                                        : 'AUTO ENCHAÎNÉ',
                                    style: TextStyle(
                                      color: stateColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Série ${step.roundIndex}/${step.totalRounds}',
                                  style: const TextStyle(
                                    color: MakeFitTheme.textPrimary,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Cible : ${step.targetReps} mouv.',
                                  style: const TextStyle(
                                    color: MakeFitTheme.textSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: (1.0 - snap.stepProgress).clamp(0.0, 1.0),
                            minHeight: 7,
                            backgroundColor: MakeFitTheme.oledBlack,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(stateColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Encart « À SUIVRE »
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: MakeFitTheme.slateSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MakeFitTheme.slateBorder),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.skip_next_rounded,
                        color: MakeFitTheme.cyanRadar,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'À SUIVRE : ',
                        style: TextStyle(
                          color: MakeFitTheme.cyanRadar,
                          fontWeight: FontWeight.w900,
                          fontSize: 11,
                          letterSpacing: 0.4,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _buildUpNextText(snap),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: MakeFitTheme.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 3. Barre de contrôle inférieure simple et claire
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Grand bouton central PAUSE / REPRENDRE
              JuicyTactical3DButton(
                label: isPaused ? 'REPRENDRE' : 'PAUSE',
                subtitle: isPaused
                    ? 'Relancer le chronomètre et l\'animation'
                    : 'Mettre la séance en pause',
                icon: isPaused
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
                height: 54,
                fontSize: 15,
                backgroundColor: isPaused
                    ? MakeFitTheme.emeraldH2f
                    : MakeFitTheme.amberTactical,
                bottomLipColor: isPaused
                    ? MakeFitTheme.emeraldLip
                    : MakeFitTheme.amberLip,
                foregroundColor: MakeFitTheme.oledBlack,
                onPressed: widget.engine.togglePauseWorkout,
              ),
              const SizedBox(height: 8),
              // 3 boutons d'assistance rapide : +15s REPOS | ADAPTER (PLUS DOUX) | SUIVANT
              Row(
                children: <Widget>[
                  Expanded(
                    child: JuicyTactical3DButton(
                      label: '+15s REPOS',
                      icon: Icons.more_time_rounded,
                      height: 46,
                      fontSize: 11,
                      backgroundColor: MakeFitTheme.cyanRadar,
                      bottomLipColor: MakeFitTheme.cyanLip,
                      foregroundColor: MakeFitTheme.oledBlack,
                      onPressed: () => widget.engine.addRestSeconds(15),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: JuicyTactical3DButton(
                      label: 'ADAPTER (PLUS DOUX)',
                      icon: Icons.favorite_border_rounded,
                      height: 46,
                      fontSize: 10,
                      backgroundColor: MakeFitTheme.emeraldH2f,
                      bottomLipColor: MakeFitTheme.emeraldLip,
                      foregroundColor: MakeFitTheme.oledBlack,
                      onPressed: widget.engine.adaptCurrentExerciseDown,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: JuicyTactical3DButton(
                      label: 'SUIVANT',
                      icon: Icons.skip_next_rounded,
                      height: 46,
                      fontSize: 11,
                      backgroundColor: MakeFitTheme.slateCard,
                      bottomLipColor: MakeFitTheme.slateBorder,
                      foregroundColor: MakeFitTheme.textPrimary,
                      onPressed: widget.engine.advanceToNextWorkoutStep,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDebriefingVictoryView(
    BuildContext context,
    WorkoutLiveSnapshot snap,
  ) {
    final SoldierProfileState profile = widget.engine.profile;
    final TxpBreakdown breakdown = snap.txpBreakdown ??
        widget.engine.computeTxpBreakdown(
          mission: snap.mission,
          totalValidatedReps: snap.totalValidatedReps,
          rpeScore: snap.selectedRpe,
        );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.88, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (BuildContext context, double scale, Widget? child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: MakeFitTheme.slateCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: MakeFitTheme.amberTactical, width: 2.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const MakeFitLogoBadge(size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'SÉANCE TERMINÉE AVEC SUCCÈS !',
                          style: TextStyle(
                            color: MakeFitTheme.emeraldH2f,
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bravo ${profile.displayName} ! Séance de ${snap.mission.durationMinutes} min terminée !',
                          style: const TextStyle(
                            color: MakeFitTheme.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 16.5,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Carte Points de Motivation Gagnés
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: MakeFitTheme.oledBlack,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: MakeFitTheme.amberTactical.withValues(alpha: 0.65),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'POINTS DE MOTIVATION GAGNÉS',
                      style: TextStyle(
                        color: MakeFitTheme.textSecondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.7,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InterpolatedTxpCounter(
                      txpValue: breakdown.totalTxp,
                      prefix: '+',
                      suffix: ' XP',
                      style: const TextStyle(
                        color: MakeFitTheme.amberTactical,
                        fontWeight: FontWeight.w900,
                        fontSize: 36,
                        fontFeatures: <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Série en cours : ${profile.currentStreakDays + 1} jour(s) • Séances : ${profile.completedSessionsCount + 1}',
                      style: const TextStyle(
                        color: MakeFitTheme.emeraldH2f,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Résumé simple des gains
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MakeFitTheme.slateSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MakeFitTheme.slateBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'RÉSUMÉ DE TA SÉANCE',
                      style: TextStyle(
                        color: MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      'Séance complétée (${snap.mission.durationMinutes} min)',
                      '+${breakdown.baseTxp + breakdown.durationTxp} XP',
                    ),
                    _buildSummaryRow(
                      'Séries & mouvements réalisés',
                      '+${breakdown.volumeTxp} XP',
                    ),
                    _buildSummaryRow(
                      'Échauffement & Retour au calme',
                      '+${breakdown.rampH2fBonusTxp} XP',
                    ),
                    _buildSummaryRow(
                      'Bonus de régularité',
                      '+${breakdown.rpeHonestyBonusTxp} XP',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Sélection simple du ressenti (1 à 5)
              RpeSelectorBar(
                selectedRpe: snap.selectedRpe,
                onRpeSelected: (int rpe) {
                  HapticFeedback.selectionClick();
                  widget.engine.selectDebriefRpe(rpe);
                },
              ),
              const SizedBox(height: 16),

              JuicyTactical3DButton(
                label: 'VALIDER MA SÉANCE & CONTINUER',
                subtitle:
                    '+${breakdown.totalTxp} XP • Enregistrer ma progression du jour',
                icon: Icons.check_circle_rounded,
                height: 60,
                fontSize: 14,
                onPressed: widget.engine.confirmMissionDebriefAndClaimLoot,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: MakeFitTheme.textSecondary,
                fontSize: 11.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 11.5,
              fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
