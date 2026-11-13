import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/makefit_catalog.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// Onglet 3 — `CASERNE & PT` (12 Grades Militaires E-1..SF-2, 4 Examens PT 6 min,
/// Calibrateur IAO sur 100, Jauge Posturale Push/Pull, Heatmap 28J & Store Compliance).
class BarracksAndTrialsTab extends StatefulWidget {
  const BarracksAndTrialsTab({
    super.key,
    required this.engine,
  });

  final MakeFitEngine engine;

  @override
  State<BarracksAndTrialsTab> createState() => _BarracksAndTrialsTabState();
}

class _BarracksAndTrialsTabState extends State<BarracksAndTrialsTab> {
  int _pushupsIn2Min = 28;
  int _squatsIn2Min = 42;
  int _plankSeconds = 65;
  bool _assistedPushups = false;

  @override
  Widget build(BuildContext context) {
    final SoldierProfileState profile = widget.engine.profile;
    final List<PromotionTrialSpec> trials =
        MakeFitCatalog.buildPromotionTrials(profile.familyRepQuotas);
    final BaselinePtCalibrationResult previewIao =
        MakeFitEngine.evaluateBaselinePtTest(
      pushupsIn2Min: _pushupsIn2Min,
      squatsIn2Min: _squatsIn2Min,
      plankSeconds: _plankSeconds,
      assistedPushups: _assistedPushups,
    );

    return ColoredBox(
      color: MakeFitTheme.oledBlack,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: <Widget>[
          _buildBaselinePtCalibratorCard(profile, previewIao),
          const SizedBox(height: 16),
          _buildPosturalBalanceAndHeatmapCard(profile),
          const SizedBox(height: 16),
          _buildPromotionTrialsSection(profile, trials),
          const SizedBox(height: 16),
          _buildMilitaryRanksLadderSection(profile),
          const SizedBox(height: 16),
          _buildStoreComplianceBanner(profile),
        ],
      ),
    );
  }

  Widget _buildBaselinePtCalibratorCard(
    SoldierProfileState profile,
    BaselinePtCalibrationResult previewIao,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MakeFitTheme.amberTactical, width: 1.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.speed_rounded,
                color: MakeFitTheme.amberTactical,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'CALIBRATEUR TEST PT INITIAL 6 MIN (IAO SUR 100)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MakeFitTheme.amberTactical,
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: MakeFitTheme.amberTactical.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'IAO ACTUEL : ${profile.iaoCalibrationScore}/100',
                  style: const TextStyle(
                    color: MakeFitTheme.amberTactical,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Protocole US Army FM 7-22 : 2m Push-ups • 2m Air Squats • Max Plank Hold',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          _buildStepperRow(
            label: 'Push-ups (2 min)',
            valueText: '$_pushupsIn2Min reps (Score ${previewIao.pushScore}/100)',
            onDecrement: () {
              HapticFeedback.selectionClick();
              setState(
                () => _pushupsIn2Min = (_pushupsIn2Min - 5).clamp(0, 120),
              );
            },
            onIncrement: () {
              HapticFeedback.selectionClick();
              setState(
                () => _pushupsIn2Min = (_pushupsIn2Min + 5).clamp(0, 120),
              );
            },
          ),
          const SizedBox(height: 6),
          _buildStepperRow(
            label: 'Air Squats (2 min)',
            valueText: '$_squatsIn2Min reps (Score ${previewIao.legsScore}/100)',
            onDecrement: () {
              HapticFeedback.selectionClick();
              setState(
                () => _squatsIn2Min = (_squatsIn2Min - 5).clamp(0, 160),
              );
            },
            onIncrement: () {
              HapticFeedback.selectionClick();
              setState(
                () => _squatsIn2Min = (_squatsIn2Min + 5).clamp(0, 160),
              );
            },
          ),
          const SizedBox(height: 6),
          _buildStepperRow(
            label: 'Gainage Plank (s)',
            valueText: '${_plankSeconds}s (Score ${previewIao.coreScore}/100)',
            onDecrement: () {
              HapticFeedback.selectionClick();
              setState(
                () => _plankSeconds = (_plankSeconds - 15).clamp(0, 300),
              );
            },
            onIncrement: () {
              HapticFeedback.selectionClick();
              setState(
                () => _plankSeconds = (_plankSeconds + 15).clamp(0, 300),
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  'Pompes assistées (sur genoux / inclinées x0.55)',
                  style: TextStyle(
                    color: MakeFitTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ),
              Switch(
                value: _assistedPushups,
                activeThumbColor: MakeFitTheme.amberTactical,
                onChanged: (bool val) {
                  HapticFeedback.selectionClick();
                  setState(() => _assistedPushups = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MakeFitTheme.slateSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MakeFitTheme.slateBorder),
            ),
            child: Text(
              'APERÇU IAO : ${previewIao.iaoGlobalIndex}/100 • Grade initial ${previewIao.initialUnlockedRank.code} (${previewIao.initialUnlockedRank.title})',
              style: const TextStyle(
                color: MakeFitTheme.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 10),
          JuicyTactical3DButton(
            label: 'CALIBRER L\'IAO & METTRE À JOUR LES ÉCHELONS',
            subtitle:
                'Appliquer IAO ${previewIao.iaoGlobalIndex}/100 aux 5 familles biomécaniques',
            icon: Icons.tune_rounded,
            height: 50,
            onPressed: () {
              widget.engine.applyBaselineCalibration(
                pushupsIn2Min: _pushupsIn2Min,
                squatsIn2Min: _squatsIn2Min,
                plankSeconds: _plankSeconds,
                assistedPushups: _assistedPushups,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepperRow({
    required String label,
    required String valueText,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MakeFitTheme.slateBorder),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: const TextStyle(
                    color: MakeFitTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                Text(
                  valueText,
                  style: const TextStyle(
                    color: MakeFitTheme.amberTactical,
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onDecrement,
            icon: const Icon(
              Icons.remove_circle_outline_rounded,
              color: MakeFitTheme.textPrimary,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onIncrement,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: MakeFitTheme.amberTactical,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosturalBalanceAndHeatmapCard(SoldierProfileState profile) {
    final double ratio = profile.posturalBalanceRatio;
    final bool optimal = ratio >= 0.85 && ratio <= 1.25;
    final Color ratioColor =
        optimal ? MakeFitTheme.emeraldH2f : MakeFitTheme.amberTactical;
    final int pushVol =
        profile.weeklyFamilyVolumes[BiomechanicalFamily.upperPush] ?? 0;
    final int pullVol =
        profile.weeklyFamilyVolumes[BiomechanicalFamily.noBarPull] ?? 0;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Flexible(
                child: Text(
                  'JAUGE D\'ÉQUILIBRE POSTURAL PUSH / PULL',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MakeFitTheme.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ratioColor.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'RATIO ${ratio.toStringAsFixed(2)} (${optimal ? 'OPTIMAL' : 'À ÉQUILIBRER'})',
                  style: TextStyle(
                    color: ratioColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Volume 7j : Poussée $pushVol reps • Tirage au Sol & Scapula $pullVol reps (Cible 1:1)',
            style: const TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (ratio / 2.0).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: MakeFitTheme.amberTactical.withValues(alpha: 0.35),
              valueColor: AlwaysStoppedAnimation<Color>(ratioColor),
            ),
          ),
          const Divider(color: MakeFitTheme.slateBorder, height: 22),
          const Text(
            'HEATMAP D\'ACTIVITÉ OPÉRATIONNELLE SUR 28 JOURS',
            style: TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List<Widget>.generate(
              profile.activityHeatmap28Days.length,
              (int index) {
                final int intensity = profile.activityHeatmap28Days[index];
                final Color cellColor = switch (intensity) {
                  3 => MakeFitTheme.amberTactical,
                  2 => MakeFitTheme.cyanRadar,
                  1 => MakeFitTheme.emeraldH2f,
                  _ => MakeFitTheme.slateSurface,
                };
                return Container(
                  width: 34,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cellColor.withValues(
                      alpha: intensity > 0 ? 0.28 : 0.9,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: intensity > 0 ? cellColor : MakeFitTheme.slateBorder,
                    ),
                  ),
                  child: Text(
                    'J${index + 1}',
                    style: TextStyle(
                      color: intensity > 0
                          ? MakeFitTheme.textPrimary
                          : MakeFitTheme.textSecondary,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionTrialsSection(
    SoldierProfileState profile,
    List<PromotionTrialSpec> trials,
  ) {
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
            '4 EXAMENS PT DE PROMOTION (6 MINUTES)',
            style: TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Épreuves standardisées pour franchir les grades E-3, E-5, O-1 et SF-1 (XP Banking actif)',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          ...trials.map((PromotionTrialSpec trial) {
            final bool passed =
                profile.passedTrialRanks.contains(trial.targetRank);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MakeFitTheme.slateSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: passed
                        ? MakeFitTheme.emeraldH2f
                        : MakeFitTheme.amberTactical.withValues(alpha: 0.65),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        MilitaryRankBadge(
                          rank: trial.targetRank,
                          size: 40,
                          isLocked: !passed,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                trial.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: MakeFitTheme.textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13.5,
                                ),
                              ),
                              Text(
                                '${trial.code} • Prime +${trial.bonusTxp} TXP • Seuil ${trial.targetRank.minTxp} TXP',
                                style: const TextStyle(
                                  color: MakeFitTheme.amberTactical,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• ${trial.block1Description}\n• ${trial.block2Description}\n• ${trial.block3Description}',
                      style: const TextStyle(
                        color: MakeFitTheme.textPrimary,
                        fontSize: 11.5,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trial.stealthAdaptationNote,
                      style: const TextStyle(
                        color: MakeFitTheme.cyanRadar,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 10),
                    JuicyTactical3DButton(
                      label: 'PASSER L\'EXAMEN PT',
                      subtitle:
                          '${trial.targetRank.code} ${trial.targetRank.title} (+${trial.bonusTxp} TXP)',
                      icon: Icons.workspace_premium_rounded,
                      height: 48,
                      fontSize: 12.5,
                      backgroundColor: passed
                          ? MakeFitTheme.emeraldH2f
                          : MakeFitTheme.amberTactical,
                      bottomLipColor: passed
                          ? MakeFitTheme.emeraldLip
                          : MakeFitTheme.amberLip,
                      onPressed: () => widget.engine.startMission(trial.mission),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMilitaryRanksLadderSection(SoldierProfileState profile) {
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
            'HIÉRARCHIE DES 12 GRADES MILITAIRES (E-1 À SF-2)',
            style: TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 10),
          ...MilitaryRank.values.map((MilitaryRank r) {
            final bool unlocked = profile.rank.order >= r.order;
            final bool isCurrent = profile.rank == r;

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? MakeFitTheme.amberTactical.withValues(alpha: 0.16)
                      : MakeFitTheme.slateSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isCurrent
                        ? MakeFitTheme.amberTactical
                        : MakeFitTheme.slateBorder,
                    width: isCurrent ? 1.8 : 1.0,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    MilitaryRankBadge(
                      rank: r,
                      size: 40,
                      isLocked: !unlocked,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${r.code} ${r.title} • ${r.corps}',
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
                            '${r.minTxp} TXP${r.requiresTrial ? ' + Examen PT' : ''} • ${r.unlockedReward}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStoreComplianceBanner(SoldierProfileState profile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: MakeFitTheme.emeraldH2f.withValues(alpha: 0.65),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(
                Icons.verified_user_rounded,
                color: MakeFitTheme.emeraldH2f,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'STORE COMPLIANCE : HEALTH & SAFETY (1.4.1) & OFFLINE PRIVACY (5.1.1)',
                  style: TextStyle(
                    color: MakeFitTheme.emeraldH2f,
                    fontWeight: FontWeight.w900,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '• Health & Safety Medical Disclaimer (Guideline 1.4.1) : Programme basé sur les doctrines publiques US Army FM 7-22 (H2F) et Navy SEAL Physical Training Guide. Consultez un médecin avant tout programme sportif et utilisez le bouton d\'adaptation Poignets/Genoux en cas de gêne articulaire.\n'
            '• Zero-Sign-Up Offline Privacy (Guideline 5.1.1) : 100 % hors-ligne, zéro création de compte obligatoire, zéro tracking publicitaire ni télémétrie externe.',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11,
              height: 1.35,
            ),
          ),
          if (!profile.medicalDisclaimerAccepted) ...<Widget>[
            const SizedBox(height: 10),
            JuicyTactical3DButton(
              label: 'ACCEPTER LE MEDICAL DISCLAIMER (1.4.1)',
              height: 46,
              backgroundColor: MakeFitTheme.emeraldH2f,
              bottomLipColor: MakeFitTheme.emeraldLip,
              onPressed: widget.engine.acceptMedicalDisclaimer,
            ),
          ],
        ],
      ),
    );
  }
}
