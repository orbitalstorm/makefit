import 'package:flutter/material.dart';
import '../data/makefit_catalog.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// Onglet 1 — `COMMAND CENTER` (QG Opérationnel MakeFit `v1.0.0`).
class CommandCenterTab extends StatelessWidget {
  const CommandCenterTab({
    super.key,
    required this.engine,
  });

  final MakeFitEngine engine;

  @override
  Widget build(BuildContext context) {
    final SoldierProfileState profile = engine.profile;
    final TacticalMission todayMission = engine.todayRecommendedMission;
    final List<TacticalMission> campaignMissions =
        MakeFitCatalog.missionsForCampaign(
      profile.activeCampaignId,
      profile.familyRepQuotas,
    );

    return ColoredBox(
      color: MakeFitTheme.oledBlack,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: <Widget>[
          _buildTacticalOledHeader(profile),
          const SizedBox(height: 14),
          _buildStealthAndJointAdaptationPanel(profile),
          const SizedBox(height: 14),
          _buildHeroMissionOfTheDayCard(profile, todayMission),
          const SizedBox(height: 18),
          _buildOperationalCampaignsSection(profile, campaignMissions),
          const SizedBox(height: 18),
          _buildQuickRoutineGeneratorSection(profile),
        ],
      ),
    );
  }

  Widget _buildTacticalOledHeader(SoldierProfileState profile) {
    final MilitaryRank? nextRank = profile.rank.nextRank;
    final int nextMinTxp = nextRank?.minTxp ?? profile.totalTxp;

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
            children: <Widget>[
              const MakeFitLogoBadge(size: 46),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Flexible(
                          child: Text(
                            'MAKEFIT COMMAND CENTER',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: MakeFitTheme.amberTactical,
                              fontWeight: FontWeight.w900,
                              fontSize: 11.5,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: MakeFitTheme.emeraldH2f.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            profile.callsign,
                            style: const TextStyle(
                              color: MakeFitTheme.emeraldH2f,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${profile.rank.code} — ${profile.rank.title} (${profile.rank.corps})',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              MilitaryRankBadge(rank: profile.rank, size: 44),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InterpolatedTxpCounter(
                txpValue: profile.totalTxp,
                style: const TextStyle(
                  color: MakeFitTheme.amberTactical,
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                  fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
                ),
              ),
              Flexible(
                child: Text(
                  nextRank != null
                      ? 'OBJECTIF ${nextRank.code} : $nextMinTxp TXP'
                      : 'GRADE MAXIMAL SF-2 ATTEINT',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MakeFitTheme.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: profile.progressToNextRank,
              minHeight: 9,
              backgroundColor: MakeFitTheme.oledBlack,
              valueColor: const AlwaysStoppedAnimation<Color>(
                MakeFitTheme.amberTactical,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: MakeFitTheme.amberTactical.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: MakeFitTheme.amberTactical.withValues(alpha: 0.55),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: MakeFitTheme.amberTactical,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'STREAK RÉSILIENT : ${profile.currentStreakDays} JOURS',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: MakeFitTheme.slateSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MakeFitTheme.slateBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TacticalDogTagIcon(
                      activeCount: profile.tacticalLeavePasses,
                      maxCount: 2,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${profile.tacticalLeavePasses}/2 PERMISSIONS TACTIQUES',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: MakeFitTheme.textSecondary,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStealthAndJointAdaptationPanel(SoldierProfileState profile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: profile.stealthApartmentMode
              ? MakeFitTheme.cyanRadar
              : MakeFitTheme.slateBorder,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => engine.toggleStealthApartmentMode(),
            child: Row(
              children: <Widget>[
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: profile.stealthApartmentMode
                        ? MakeFitTheme.cyanRadar.withValues(alpha: 0.20)
                        : MakeFitTheme.slateSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: profile.stealthApartmentMode
                          ? MakeFitTheme.cyanRadar
                          : MakeFitTheme.slateBorder,
                    ),
                  ),
                  child: Icon(
                    profile.stealthApartmentMode
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    color: profile.stealthApartmentMode
                        ? MakeFitTheme.cyanRadar
                        : MakeFitTheme.textSecondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'MODE SILENCIEUX APPARTEMENT (0 SAUT • < 35 dB)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Remplace instantanément tout saut par du contrôle excentrique',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MakeFitTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: profile.stealthApartmentMode,
                  activeThumbColor: MakeFitTheme.cyanRadar,
                  onChanged: (bool value) =>
                      engine.toggleStealthApartmentMode(value),
                ),
              ],
            ),
          ),
          const Divider(color: MakeFitTheme.slateBorder, height: 18),
          const Text(
            'ADAPTATION ARTICULAIRE POIGNETS / GENOUX (1-CLIC)',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: JointFriendlyMode.values.map((JointFriendlyMode mode) {
              final bool selected = profile.jointFriendlyMode == mode;
              return GestureDetector(
                onTap: () => engine.setJointFriendlyMode(mode),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? MakeFitTheme.emeraldH2f.withValues(alpha: 0.22)
                        : MakeFitTheme.slateSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? MakeFitTheme.emeraldH2f
                          : MakeFitTheme.slateBorder,
                      width: selected ? 1.8 : 1.0,
                    ),
                  ),
                  child: Text(
                    mode.label,
                    style: TextStyle(
                      color: selected
                          ? MakeFitTheme.emeraldH2f
                          : MakeFitTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMissionOfTheDayCard(
    SoldierProfileState profile,
    TacticalMission mission,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            MakeFitTheme.slateCard,
            MakeFitTheme.amberTactical.withValues(alpha: 0.16),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MakeFitTheme.amberTactical, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: MakeFitTheme.amberTactical,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'MISSION DU JOUR (1-CLIC)',
                  style: TextStyle(
                    color: MakeFitTheme.oledBlack,
                    fontWeight: FontWeight.w900,
                    fontSize: 10.5,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${mission.code} • ${mission.durationMinutes} MIN • CIBLE RPE ${mission.targetRpe}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MakeFitTheme.amberTactical,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            mission.title,
            style: const TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mission.subtitle,
            style: const TextStyle(
              color: MakeFitTheme.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              _buildMissionTag(
                'RAMP 3 MIN INCLUS',
                MakeFitTheme.emeraldH2f,
              ),
              _buildMissionTag(
                'RATIO PUSH/PULL 1:1',
                MakeFitTheme.cyanRadar,
              ),
              _buildMissionTag(
                'BOX BREATHING H2F 2 MIN',
                MakeFitTheme.purpleCore,
              ),
            ],
          ),
          const SizedBox(height: 14),
          JuicyTactical3DButton(
            label: 'DÉPLOYER LA MISSION DU JOUR',
            subtitle:
                '${mission.format.title} • ${mission.steps.length} étapes guidées à 2m',
            icon: Icons.play_arrow_rounded,
            height: 62,
            fontSize: 15,
            onPressed: () => engine.startMission(mission),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.55)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildOperationalCampaignsSection(
    SoldierProfileState profile,
    List<TacticalMission> campaignMissions,
  ) {
    final TacticalMission bossMission = campaignMissions.last;

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
            '4 CAMPAGNES OPÉRATIONNELLES DE 28 JOURS',
            style: TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Périodisation ondulatoire 4 semaines • Jours Mobilité H2F (J4/J7) & Boss Mission J28',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: OperationalCampaignId.values.map(
              (OperationalCampaignId camp) {
                final bool active = profile.activeCampaignId == camp;
                return GestureDetector(
                  onTap: () => engine.selectOperationalCampaign(camp),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? camp.accentColor.withValues(alpha: 0.24)
                          : MakeFitTheme.slateSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            active ? camp.accentColor : MakeFitTheme.slateBorder,
                        width: active ? 2.0 : 1.0,
                      ),
                    ),
                    child: Text(
                      camp.title,
                      style: TextStyle(
                        color: active
                            ? camp.accentColor
                            : MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                );
              },
            ).toList(growable: false),
          ),
          const SizedBox(height: 12),
          CampaignThumbnailBanner(campaign: profile.activeCampaignId),
          const SizedBox(height: 12),
          const Text(
            'CARTE DE DÉPLOIEMENT 28 JOURS (TAP POUR LANCER UN JOUR)',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: campaignMissions.map((TacticalMission m) {
              final int day = m.dayNumber ?? 1;
              final bool isCompleted =
                  profile.completedMissionIds.contains(m.id);
              final bool isCurrent = day == profile.currentCampaignDay;
              final Color cellColor = m.isBossMission
                  ? MakeFitTheme.coralAlert
                  : m.isRecoveryDay
                  ? MakeFitTheme.emeraldH2f
                  : (isCompleted
                        ? MakeFitTheme.amberTactical
                        : MakeFitTheme.slateSurface);

              return GestureDetector(
                onTap: () => engine.startMission(m),
                child: Container(
                  width: 44,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cellColor.withValues(
                      alpha: isCurrent ? 0.35 : 0.16,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrent ? Colors.white : cellColor,
                      width: isCurrent ? 2.0 : 1.2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'J$day',
                        style: const TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 10.5,
                        ),
                      ),
                      Text(
                        m.isBossMission
                            ? 'BOSS'
                            : (m.isRecoveryDay ? 'H2F' : (isCompleted ? 'OK' : 'PT')),
                        style: TextStyle(
                          color: cellColor == MakeFitTheme.slateSurface
                              ? MakeFitTheme.textSecondary
                              : cellColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 8.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(growable: false),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MakeFitTheme.coralAlert.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: MakeFitTheme.coralAlert.withValues(alpha: 0.55),
              ),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.shield_rounded,
                  color: MakeFitTheme.coralAlert,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bossMission.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: MakeFitTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 11.5,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                JuicyTactical3DButton(
                  label: 'BOSS J28',
                  expand: false,
                  height: 44,
                  fontSize: 11.5,
                  backgroundColor: MakeFitTheme.coralAlert,
                  bottomLipColor: MakeFitTheme.coralLip,
                  foregroundColor: Colors.white,
                  onPressed: () => engine.startMission(bossMission),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRoutineGeneratorSection(SoldierProfileState profile) {
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
            'GÉNÉRATEUR DE ROUTINES SIMPLES 1-CLIC',
            style: TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 0.7,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Flash PT 5 min • EMOM 14 min • AMRAP 12 min • Pyramide 1→N→1 • Tabata HIIT',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          ...WorkoutFormatType.values.map((WorkoutFormatType format) {
            final DifficultyTier tier =
                profile.familyTiers[BiomechanicalFamily.upperPush] ??
                    DifficultyTier.tier2Soldier;
            final TacticalMission quickMission = MakeFitCatalog.buildMission(
              id: 'quick_${format.code.toLowerCase()}',
              code: 'QUICK • ${format.code}',
              title: '${format.title} (${format.defaultMinutes} min)',
              subtitle: format.subtitle,
              format: format,
              tier: tier,
              repQuotas: profile.familyRepQuotas,
              isRecoveryDay: format == WorkoutFormatType.flashPt5Min,
            );

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: MakeFitTheme.slateSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: format.accentColor.withValues(alpha: 0.55),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: format.accentColor.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${format.defaultMinutes}m',
                        style: TextStyle(
                          color: format.accentColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            format.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: MakeFitTheme.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 13.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${format.subtitle} • Multiplicateur x${format.txpMultiplier.toStringAsFixed(2)}',
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
                    JuicyTactical3DButton(
                      label: 'LANCER',
                      expand: false,
                      height: 44,
                      fontSize: 12,
                      backgroundColor: format.accentColor,
                      bottomLipColor: MakeFitTheme.slateBorder,
                      foregroundColor: MakeFitTheme.oledBlack,
                      onPressed: () => engine.startMission(quickMission),
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
}
