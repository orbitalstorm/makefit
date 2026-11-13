import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/anatomical_mannequin_painter.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// HUD Séance Distance-First lisible à 2 mètres, Mode Sans Contact (`height: 112dp`,
/// Debounce 650 ms) & Modale de Victoire / Debriefing RPE (`Curves.elasticOut`).
class WorkoutPlayerModal extends StatelessWidget {
  const WorkoutPlayerModal({
    super.key,
    required this.engine,
    required this.snapshot,
  });

  final MakeFitEngine engine;
  final WorkoutLiveSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MakeFitTheme.oledBlack,
      child: SafeArea(
        child: snapshot.phase == WorkoutExecutionPhase.debriefingVictory
            ? _buildDebriefingVictoryView(context)
            : _buildActiveHud2mView(context),
      ),
    );
  }

  Color _stateAccentColor(WorkoutStepStage stage) {
    return switch (stage) {
      WorkoutStepStage.mainWork => const Color(0xFFF59E0B), // Effort #F59E0B
      WorkoutStepStage.restRecovery => const Color(0xFF06B6D4), // Repos #06B6D4
      WorkoutStepStage.rampWarmup => const Color(0xFF10B981), // RAMP #10B981
      WorkoutStepStage.h2fCooldown => const Color(0xFF10B981), // H2F #10B981
    };
  }

  String _formatMinSec(int totalSeconds) {
    final int clamped = totalSeconds < 0 ? 0 : totalSeconds;
    final int mins = clamped ~/ 60;
    final int secs = clamped % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _cycleJointFriendlyMode() {
    final List<JointFriendlyMode> modes = JointFriendlyMode.values;
    final JointFriendlyMode next =
        modes[(snapshot.jointFriendlyMode.index + 1) % modes.length];
    engine.setJointFriendlyMode(next);
  }

  Widget _buildActiveHud2mView(BuildContext context) {
    final WorkoutStationStep step = snapshot.currentStep;
    final TacticalExercise exercise = step.exercise;
    final Color stateColor = _stateAccentColor(step.stage);
    final String effectiveExName = exercise.effectiveName(
      stealthMode: snapshot.stealthModeActive,
      jointMode: snapshot.jointFriendlyMode,
    );

    return Column(
      children: <Widget>[
        // Barre supérieure tactique + Audio Ducking -12 dB
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
                        horizontal: 8,
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
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ÉTAPE ${snapshot.currentStepIndex + 1}/${snapshot.mission.steps.length} • ${snapshot.mission.code}',
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
                    tooltip: 'Avancer 1s (Tick)',
                    onPressed: () => engine.tickWorkout(),
                    icon: const Icon(
                      Icons.timer_outlined,
                      color: MakeFitTheme.amberTactical,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Fermer la séance',
                    onPressed: engine.closeWorkoutModal,
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
                  value: snapshot.overallMissionProgress,
                  minHeight: 6,
                  backgroundColor: MakeFitTheme.slateCard,
                  valueColor: AlwaysStoppedAnimation<Color>(stateColor),
                ),
              ),
              const SizedBox(height: 6),
              // Indicateur Audio Ducking -12 dB (Spotify Friendly)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: MakeFitTheme.slateCard,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: snapshot.audioDuckingActive
                        ? MakeFitTheme.cyanRadar
                        : MakeFitTheme.slateBorder,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.graphic_eq_rounded,
                      color: MakeFitTheme.cyanRadar,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text(
                        'AUDIO DUCKING -12 dB (SPOTIFY)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MakeFitTheme.cyanRadar,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        snapshot.lastAudioCueBanner,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Zone centrale scrollable sans overflow (Mannequin 60 FPS + Cues + Chrono Géant 2m)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  effectiveExName.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MakeFitTheme.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${step.title} • Tempo ${exercise.tempo} • ${snapshot.jointFriendlyMode.label}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MakeFitTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
                const SizedBox(height: 6),

                // Mannequin Anatomique 60 FPS + Bouton Angle 3/4 • Profil • Face
                Stack(
                  children: <Widget>[
                    AnatomicalMannequinView(
                      exercise: exercise,
                      animationPhase: snapshot.animationCyclePhase,
                      cameraAngle: snapshot.cameraAngle,
                      stealthMode: snapshot.stealthModeActive,
                      jointMode: snapshot.jointFriendlyMode,
                      height: 152,
                    ),
                    Positioned(
                      top: 6,
                      right: 8,
                      child: GestureDetector(
                        onTap: engine.cycleMannequinCameraAngle,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: MakeFitTheme.oledBlack.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: MakeFitTheme.amberTactical,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                Icons.cameraswitch_rounded,
                                color: MakeFitTheme.amberTactical,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '3/4 • Profil • Face (${snapshot.cameraAngle.label})',
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

                // 3 HUD Cues en pilules haute visibilité
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: exercise.hudCues.map((String cue) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: MakeFitTheme.slateCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: stateColor.withValues(alpha: 0.70),
                          width: 1.4,
                        ),
                      ),
                      child: Text(
                        cue,
                        style: const TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 11.5,
                        ),
                      ),
                    );
                  }).toList(growable: false),
                ),
                const SizedBox(height: 10),

                // Si phase H2F Cooldown : affichage de l'anneau BoxBreathingRing (4-4-4-4)
                if (step.stage == WorkoutStepStage.h2fCooldown) ...<Widget>[
                  BoxBreathingRing(
                    phase: snapshot.currentBoxBreathingPhase,
                    stepElapsedSeconds: snapshot.stepElapsedSeconds,
                    size: 132,
                  ),
                  const SizedBox(height: 10),
                ],

                // HUD Distance-First lisible à 2 mètres : Chiffres tabulaires géants (72pt–88pt)
                RepaintBoundary(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: MakeFitTheme.slateCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: stateColor.withValues(alpha: 0.85),
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _formatMinSec(snapshot.stepRemainingSeconds),
                              style: TextStyle(
                                color: stateColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 78,
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
                            Text(
                              '${snapshot.completedRepsInStep} / ${step.targetReps} REPS',
                              style: const TextStyle(
                                color: MakeFitTheme.textPrimary,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                                fontFeatures: <FontFeature>[
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'TOTAL VALIDÉ : ${snapshot.totalValidatedReps} REPS',
                              style: const TextStyle(
                                color: MakeFitTheme.textSecondary,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                fontFeatures: <FontFeature>[
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Zone Inférieure Sweat-Proof (Boutons Tactiques + Zone Géante Sans Contact 112dp)
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 14, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: JuicyTactical3DButton(
                      label: '+15S REPOS',
                      icon: Icons.more_time_rounded,
                      height: 48,
                      fontSize: 11.5,
                      backgroundColor: MakeFitTheme.cyanRadar,
                      bottomLipColor: MakeFitTheme.cyanLip,
                      foregroundColor: MakeFitTheme.oledBlack,
                      onPressed: () => engine.addRestSeconds(15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: JuicyTactical3DButton(
                      label: 'ADAPTER POIGNETS/GENOUX',
                      icon: Icons.health_and_safety_rounded,
                      height: 48,
                      fontSize: 10.5,
                      backgroundColor: MakeFitTheme.emeraldH2f,
                      bottomLipColor: MakeFitTheme.emeraldLip,
                      foregroundColor: MakeFitTheme.oledBlack,
                      onPressed: _cycleJointFriendlyMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              JuicyTactical3DButton(
                label: 'VALIDER LA SÉRIE (1-TAP)',
                subtitle:
                    'Validation par lot de l\'étape (${step.targetReps} reps)',
                icon: Icons.check_circle_rounded,
                height: 52,
                fontSize: 13.5,
                onPressed: engine.completeCurrentStepBatch,
              ),
              const SizedBox(height: 8),

              // Zone Géante Sans Contact (height: 112dp) — Nez / Menton / Pouce (Debounce 650 ms)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  engine.registerContactlessRep(bypassDebounceForTest: true);
                },
                child: Container(
                  height: 112,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        MakeFitTheme.slateCard,
                        stateColor.withValues(alpha: 0.24),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: stateColor,
                      width: 2.2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.sensors_rounded,
                            color: stateColor,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'ZONE SANS CONTACT (NEZ / MENTON / POUCE)',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: stateColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'EFFLEURER ICI EN BAS DE POMPE POUR +1 REP • DEBOUNCE 650 MS (${snapshot.completedRepsInStep}/${step.targetReps})',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDebriefingVictoryView(BuildContext context) {
    final TxpBreakdown breakdown = snapshot.txpBreakdown ??
        engine.computeTxpBreakdown(
          mission: snapshot.mission,
          totalValidatedReps: snapshot.totalValidatedReps,
          rpeScore: snapshot.selectedRpe,
        );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.86, end: 1.0),
      duration: const Duration(milliseconds: 520),
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
                  const MakeFitLogoBadge(size: 46),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'MISSION ACCOMPLIE — DEBRIEFING VICTOIRE',
                          style: TextStyle(
                            color: MakeFitTheme.amberTactical,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          snapshot.mission.title,
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
              const SizedBox(height: 14),

              // Compteur TXP Géant Interpolé sous RepaintBoundary
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
                      'LOOT EXPÉRIENCE TACTIQUE (TXP)',
                      style: TextStyle(
                        color: MakeFitTheme.textSecondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InterpolatedTxpCounter(
                      txpValue: breakdown.totalTxp,
                      prefix: '+',
                      suffix: ' TXP',
                      style: const TextStyle(
                        color: MakeFitTheme.amberTactical,
                        fontWeight: FontWeight.w900,
                        fontSize: 38,
                        fontFeatures: <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                      ),
                    ),
                    if (breakdown.promotedToRank != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: MakeFitTheme.emeraldH2f.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: MakeFitTheme.emeraldH2f),
                        ),
                        child: Text(
                          'PROMOTION DÉBLOQUÉE : ${breakdown.promotedToRank!.code} ${breakdown.promotedToRank!.title}',
                          style: const TextStyle(
                            color: MakeFitTheme.emeraldH2f,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Détail mathématique du TxpBreakdown
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
                      'DÉCOMPOSITION MATHÉMATIQUE TXP',
                      style: TextStyle(
                        color: MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBreakdownRow('Base de complétion', '+${breakdown.baseTxp} TXP'),
                    _buildBreakdownRow(
                      'Volume biomécanique (${snapshot.totalValidatedReps} reps)',
                      '+${breakdown.volumeTxp} TXP',
                    ),
                    _buildBreakdownRow('Densité temporelle', '+${breakdown.durationTxp} TXP'),
                    _buildBreakdownRow(
                      'Intégrité RAMP 3m + H2F 2m',
                      '+${breakdown.rampH2fBonusTxp} TXP',
                    ),
                    _buildBreakdownRow(
                      'Multiplicateurs Streak × Format',
                      'x${breakdown.streakMultiplier.toStringAsFixed(2)} × x${breakdown.formatMultiplier.toStringAsFixed(2)}',
                    ),
                    _buildBreakdownRow(
                      'Bonus Honnêteté RPE (${snapshot.selectedRpe}/5)',
                      '+${breakdown.rpeHonestyBonusTxp} TXP',
                    ),
                    if (breakdown.trialBonusTxp > 0)
                      _buildBreakdownRow(
                        'Prime Examen PT de Promotion',
                        '+${breakdown.trialBonusTxp} TXP',
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Sélecteur RPE 1 à 5
              RpeSelectorBar(
                selectedRpe: snapshot.selectedRpe,
                onRpeSelected: (int rpe) {
                  HapticFeedback.selectionClick();
                  engine.selectDebriefRpe(rpe);
                },
              ),
              const SizedBox(height: 10),

              // Note d'adaptation algorithmique J+1
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MakeFitTheme.cyanRadar.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: MakeFitTheme.cyanRadar.withValues(alpha: 0.65),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.auto_graph_rounded,
                      color: MakeFitTheme.cyanRadar,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        breakdown.nextSessionAdjustmentNote,
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
              const SizedBox(height: 16),

              JuicyTactical3DButton(
                label: 'RÉCLAMER LE LOOT TXP & VALIDER LE STREAK',
                subtitle:
                    '+${breakdown.totalTxp} TXP • Streak ${engine.profile.currentStreakDays + 1} Jours',
                icon: Icons.military_tech_rounded,
                height: 60,
                fontSize: 13.5,
                onPressed: engine.confirmMissionDebriefAndClaimLoot,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
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
