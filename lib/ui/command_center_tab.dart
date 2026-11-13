import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/makefit_catalog.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// Onglet 1 — `AUJOURD'HUI` (Accueil Séance 10 Min Max, Bouton GO & Parcours 28 Jours `v1.1.0`).
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
          _buildGreetingAndMotivationHeader(profile),
          const SizedBox(height: 14),
          _buildHeroTodaySessionCard(profile, todayMission),
          const SizedBox(height: 16),
          _buildClean28DayJourneyCard(profile, campaignMissions),
        ],
      ),
    );
  }

  Widget _buildGreetingAndMotivationHeader(SoldierProfileState profile) {
    final String streakLabel = profile.currentStreakDays <= 1
        ? '${profile.currentStreakDays} jour'
        : '${profile.currentStreakDays} jours';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MakeFitTheme.slateBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const MakeFitLogoBadge(size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Bonjour ${profile.displayName} • ${profile.ageYears} ans',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: profile.fitnessGoal.accentColor
                            .withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: profile.fitnessGoal.accentColor
                              .withValues(alpha: 0.65),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            profile.fitnessGoal.icon,
                            color: profile.fitnessGoal.accentColor,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              profile.fitnessGoal.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: profile.fitnessGoal.accentColor,
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
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Carte Motivation du Jour
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MakeFitTheme.slateSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: MakeFitTheme.emeraldH2f.withValues(alpha: 0.55),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.wb_sunny_rounded,
                  color: MakeFitTheme.amberTactical,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'MOTIVATION DU JOUR',
                        style: TextStyle(
                          color: MakeFitTheme.emeraldH2f,
                          fontWeight: FontWeight.w900,
                          fontSize: 10.5,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        profile.fitnessGoal.motivationalTagline,
                        style: const TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 3 compteurs épurés (0 au départ)
          Row(
            children: <Widget>[
              Expanded(
                child: _buildStatPill(
                  icon: Icons.local_fire_department_rounded,
                  accent: MakeFitTheme.amberTactical,
                  label: 'Série : $streakLabel',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatPill(
                  icon: Icons.check_circle_outline_rounded,
                  accent: MakeFitTheme.emeraldH2f,
                  label: 'Séances : ${profile.completedSessionsCount}',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatPill(
                  icon: Icons.schedule_rounded,
                  accent: MakeFitTheme.cyanRadar,
                  label: 'Temps : ${profile.totalMinutesTrained} min',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill({
    required IconData icon,
    required Color accent,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: accent, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                color: MakeFitTheme.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroTodaySessionCard(
    SoldierProfileState profile,
    TacticalMission todayMission,
  ) {
    const List<int> durationChoices = <int>[6, 8, 10];
    final bool gentleModeActive =
        profile.stealthApartmentMode ||
        profile.jointFriendlyMode != JointFriendlyMode.standard;

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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MakeFitTheme.amberTactical, width: 2.0),
      ),
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
                    color: MakeFitTheme.amberTactical,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'TA SÉANCE DU JOUR (10 MIN MAX)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MakeFitTheme.oledBlack,
                      fontWeight: FontWeight.w900,
                      fontSize: 10.5,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${profile.preferredSessionMinutes} min max • Sans matériel',
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
            'Jour ${profile.currentCampaignDay} • ${todayMission.title}',
            style: const TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 17.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Appuie sur GO : le coach animé, le chronomètre, les séries et les temps de repos s\'enchaînent tout seuls.',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),

          // Résumé visuel limpide en 3 étapes
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MakeFitTheme.slateSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MakeFitTheme.slateBorder),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildStepFlowBadge(
                    stepNumber: '1',
                    title: 'Échauffement',
                    subtitle: 'Réveil doux',
                    color: MakeFitTheme.emeraldH2f,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: MakeFitTheme.textSecondary,
                  size: 12,
                ),
                Expanded(
                  child: _buildStepFlowBadge(
                    stepNumber: '2',
                    title: 'Séries & Repos',
                    subtitle: 'Auto-enchaînés',
                    color: MakeFitTheme.amberTactical,
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: MakeFitTheme.textSecondary,
                  size: 12,
                ),
                Expanded(
                  child: _buildStepFlowBadge(
                    stepNumber: '3',
                    title: 'Retour au calme',
                    subtitle: 'Respiration',
                    color: MakeFitTheme.cyanRadar,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Sélecteur rapide de durée (6 min, 8 min, 10 min)
          Row(
            children: <Widget>[
              const Text(
                'Durée :',
                style: TextStyle(
                  color: MakeFitTheme.textSecondary,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              ...durationChoices.map((int mins) {
                final bool selected = profile.preferredSessionMinutes == mins;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () => engine.setPreferredSessionMinutes(mins),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? MakeFitTheme.amberTactical
                                  .withValues(alpha: 0.24)
                              : MakeFitTheme.slateSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected
                                ? MakeFitTheme.amberTactical
                                : MakeFitTheme.slateBorder,
                            width: selected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Text(
                          '$mins min',
                          style: TextStyle(
                            color: selected
                                ? MakeFitTheme.amberTactical
                                : MakeFitTheme.textPrimary,
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 10),

          // Switch simple Mode Sans Saut / Douceur articulaire
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: MakeFitTheme.slateSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: gentleModeActive
                    ? MakeFitTheme.cyanRadar
                    : MakeFitTheme.slateBorder,
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.shield_outlined,
                  color: gentleModeActive
                      ? MakeFitTheme.cyanRadar
                      : MakeFitTheme.textSecondary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Mode Sans Saut / Douceur articulaire',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MakeFitTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                Switch(
                  value: gentleModeActive,
                  activeThumbColor: MakeFitTheme.cyanRadar,
                  onChanged: (bool val) {
                    engine.toggleStealthApartmentMode(val);
                    engine.setJointFriendlyMode(
                      val
                          ? JointFriendlyMode.wristFriendly
                          : JointFriendlyMode.standard,
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // ÉNORME BOUTON GO — DÉMARRER LA SÉANCE
          JuicyTactical3DButton(
            label: 'GO — DÉMARRER LA SÉANCE',
            subtitle:
                'Lancer le coach animé • Chrono, séries et repos automatiques',
            icon: Icons.play_arrow_rounded,
            height: 64,
            fontSize: 16,
            onPressed: () => engine.startMission(todayMission),
          ),
        ],
      ),
    );
  }

  Widget _buildStepFlowBadge({
    required String stepNumber,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.22),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1.5),
            ),
            child: Text(
              stepNumber,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MakeFitTheme.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 10.5,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              subtitle,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: MakeFitTheme.textSecondary,
                fontSize: 9.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClean28DayJourneyCard(
    SoldierProfileState profile,
    List<TacticalMission> campaignMissions,
  ) {
    final int completedDaysCount = profile.completedMissionIds.length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(18),
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
                  'MON PARCOURS 28 JOURS (10 MIN / JOUR)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MakeFitTheme.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 13.5,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: MakeFitTheme.emeraldH2f.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Jour ${profile.currentCampaignDay} / 28 ($completedDaysCount validé${completedDaysCount > 1 ? 's' : ''})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: MakeFitTheme.emeraldH2f,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            profile.activeCampaignId.title,
            style: TextStyle(
              color: profile.activeCampaignId.accentColor,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.activeCampaignId.subtitle,
            style: const TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: OperationalCampaignId.values.map(
              (OperationalCampaignId camp) {
                final bool active = profile.activeCampaignId == camp;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    engine.selectOperationalCampaign(camp);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? camp.accentColor.withValues(alpha: 0.22)
                          : MakeFitTheme.slateSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: active
                            ? camp.accentColor
                            : MakeFitTheme.slateBorder,
                        width: active ? 1.8 : 1.0,
                      ),
                    ),
                    child: Text(
                      camp.title,
                      style: TextStyle(
                        color: active
                            ? camp.accentColor
                            : MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                );
              },
            ).toList(growable: false),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: campaignMissions.map((TacticalMission m) {
              final int day = m.dayNumber ?? 1;
              final bool isCompleted =
                  profile.completedMissionIds.contains(m.id);
              final bool isCurrent = day == profile.currentCampaignDay;
              final Color cellColor = isCompleted
                  ? MakeFitTheme.emeraldH2f
                  : (isCurrent
                        ? MakeFitTheme.amberTactical
                        : MakeFitTheme.slateSurface);

              return GestureDetector(
                onTap: () => engine.startMission(m),
                child: Container(
                  width: 42,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cellColor.withValues(
                      alpha: (isCurrent || isCompleted) ? 0.25 : 0.90,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCurrent
                          ? MakeFitTheme.amberTactical
                          : (isCompleted
                                ? MakeFitTheme.emeraldH2f
                                : MakeFitTheme.slateBorder),
                      width: isCurrent ? 2.0 : 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'J$day',
                        style: TextStyle(
                          color: (isCurrent || isCompleted)
                              ? MakeFitTheme.textPrimary
                              : MakeFitTheme.textSecondary,
                          fontWeight: FontWeight.w900,
                          fontSize: 10.5,
                        ),
                      ),
                      Text(
                        isCompleted
                            ? 'OK'
                            : (isCurrent
                                  ? 'GO'
                                  : (m.isRecoveryDay ? 'DOUX' : '10m')),
                        style: TextStyle(
                          color: isCompleted
                              ? MakeFitTheme.emeraldH2f
                              : (isCurrent
                                    ? MakeFitTheme.amberTactical
                                    : MakeFitTheme.textSecondary),
                          fontWeight: FontWeight.w800,
                          fontSize: 8.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(growable: false),
          ),
        ],
      ),
    );
  }
}
