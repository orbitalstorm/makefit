import 'package:flutter/material.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// Onglet 3 — `MON PROFIL` (`v1.1.0` — Mon Profil & Ma Progression 40+).
class BarracksAndTrialsTab extends StatelessWidget {
  const BarracksAndTrialsTab({
    super.key,
    required this.engine,
  });

  final MakeFitEngine engine;

  @override
  Widget build(BuildContext context) {
    final SoldierProfileState profile = engine.profile;

    return ColoredBox(
      color: MakeFitTheme.oledBlack,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: <Widget>[
          _buildIdentityCard(profile),
          const SizedBox(height: 14),
          _buildFitnessSummaryCard(profile),
          const SizedBox(height: 14),
          _buildAttendanceCalendar28DaysCard(profile),
          const SizedBox(height: 14),
          _buildMotivationMilestonesCard(profile),
          const SizedBox(height: 14),
          _buildHealthAndPrivacyFooter(),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(SoldierProfileState profile) {
    final bool gentleMode =
        profile.stealthApartmentMode ||
        profile.jointFriendlyMode != JointFriendlyMode.standard;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MakeFitTheme.amberTactical, width: 1.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      'MON PROFIL REMISE EN FORME',
                      style: TextStyle(
                        color: MakeFitTheme.amberTactical,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${profile.displayName} • ${profile.ageYears} ans',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              MilitaryRankBadge(rank: profile.rank, size: 42),
            ],
          ),
          const SizedBox(height: 14),
          _buildProfileRow(
            icon: profile.fitnessGoal.icon,
            label: 'Objectif 40+',
            value: profile.fitnessGoal.title,
            accent: profile.fitnessGoal.accentColor,
          ),
          const SizedBox(height: 8),
          _buildProfileRow(
            icon: Icons.trending_up_rounded,
            label: 'Niveau choisi',
            value: profile.fitnessLevel.title,
            accent: MakeFitTheme.emeraldH2f,
          ),
          const SizedBox(height: 8),
          _buildProfileRow(
            icon: Icons.timer_outlined,
            label: 'Durée quotidienne',
            value: '${profile.preferredSessionMinutes} min max / jour',
            accent: MakeFitTheme.amberTactical,
          ),
          const SizedBox(height: 8),
          _buildProfileRow(
            icon: Icons.shield_outlined,
            label: 'Confort articulaire',
            value: gentleMode
                ? 'Sans saut & Douceur articulaire actifs'
                : 'Rythme progressif standard',
            accent: MakeFitTheme.cyanRadar,
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: JuicyTactical3DButton(
                  label: 'Modifier mon profil',
                  icon: Icons.edit_rounded,
                  height: 48,
                  fontSize: 12,
                  backgroundColor: MakeFitTheme.amberTactical,
                  bottomLipColor: MakeFitTheme.amberLip,
                  foregroundColor: MakeFitTheme.oledBlack,
                  onPressed: engine.reopenProfileEditor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: JuicyTactical3DButton(
                  label: 'Réinitialiser à zéro',
                  icon: Icons.restart_alt_rounded,
                  height: 48,
                  fontSize: 12,
                  backgroundColor: MakeFitTheme.slateSurface,
                  bottomLipColor: MakeFitTheme.slateBorder,
                  foregroundColor: MakeFitTheme.textPrimary,
                  onPressed: engine.resetProfileToZero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow({
    required IconData icon,
    required String label,
    required String value,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MakeFitTheme.slateBorder),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: accent, size: 18),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              '$label : ',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: MakeFitTheme.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: accent,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFitnessSummaryCard(SoldierProfileState profile) {
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
          const Text(
            'BILAN DE REMISE EN FORME',
            style: TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildBigMetricBox(
                  value: '${profile.completedSessionsCount}',
                  label: 'Séances complétées',
                  accent: MakeFitTheme.emeraldH2f,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBigMetricBox(
                  value: '${profile.totalMinutesTrained} min',
                  label: 'Minutes cumulées',
                  accent: MakeFitTheme.cyanRadar,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildBigMetricBox(
                  value: '${profile.currentStreakDays} j',
                  label: 'Série actuelle',
                  accent: MakeFitTheme.amberTactical,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBigMetricBox(
                  value: '${profile.totalTxp} XP',
                  label: 'Niveau ${profile.rank.order} (${profile.rank.title})',
                  accent: MakeFitTheme.purpleCore,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  'Niveau actuel : ${profile.rank.title}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: MakeFitTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  nextRank != null
                      ? 'Prochain palier : $nextMinTxp XP'
                      : 'Niveau maximal atteint',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
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
              minHeight: 8,
              backgroundColor: MakeFitTheme.oledBlack,
              valueColor: const AlwaysStoppedAnimation<Color>(
                MakeFitTheme.amberTactical,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigMetricBox({
    required String value,
    required String label,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontWeight: FontWeight.w900,
              fontSize: 20,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: MakeFitTheme.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCalendar28DaysCard(SoldierProfileState profile) {
    final int activeDays =
        profile.activityHeatmap28Days.where((int v) => v > 0).length;

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
                  'CALENDRIER D\'ASSIDUITÉ SUR 28 JOURS',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MakeFitTheme.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '$activeDays / 28 jours cochés',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: MakeFitTheme.emeraldH2f,
                    fontWeight: FontWeight.w800,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Chaque séance de 10 minutes valide ta journée sur le calendrier.',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List<Widget>.generate(
              profile.activityHeatmap28Days.length,
              (int index) {
                final int intensity = profile.activityHeatmap28Days[index];
                final bool done = intensity > 0;
                return Container(
                  width: 36,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: done
                        ? MakeFitTheme.emeraldH2f.withValues(alpha: 0.25)
                        : MakeFitTheme.slateSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: done
                          ? MakeFitTheme.emeraldH2f
                          : MakeFitTheme.slateBorder,
                    ),
                  ),
                  child: Text(
                    done ? 'OK' : 'J${index + 1}',
                    style: TextStyle(
                      color: done
                          ? MakeFitTheme.emeraldH2f
                          : MakeFitTheme.textSecondary,
                      fontWeight: FontWeight.w900,
                      fontSize: 10.5,
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

  Widget _buildMotivationMilestonesCard(SoldierProfileState profile) {
    final List<({String title, String subtitle, bool unlocked, Color color})>
        milestones =
        <({String title, String subtitle, bool unlocked, Color color})>[
      (
        title: 'Déclic Jour 1',
        subtitle: 'Terminer sa toute première séance de 10 minutes',
        unlocked: profile.completedSessionsCount >= 1,
        color: MakeFitTheme.emeraldH2f,
      ),
      (
        title: 'Habitude Enclenchée (3 jours)',
        subtitle: 'Enchaîner 3 jours de remise en forme',
        unlocked: profile.bestStreakDays >= 3 || profile.completedSessionsCount >= 3,
        color: MakeFitTheme.amberTactical,
      ),
      (
        title: 'Semaine Complète (7 séances)',
        subtitle: 'Validation de 7 séances guidées sans matériel',
        unlocked: profile.completedSessionsCount >= 7,
        color: MakeFitTheme.cyanRadar,
      ),
      (
        title: 'Transformation 28 Jours',
        subtitle: 'Boucler le programme complet de 4 semaines',
        unlocked: profile.completedSessionsCount >= 28,
        color: MakeFitTheme.purpleCore,
      ),
    ];

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
            'JALONS DE MOTIVATION',
            style: TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          ...milestones.map((m) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: m.unlocked
                      ? m.color.withValues(alpha: 0.16)
                      : MakeFitTheme.slateSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: m.unlocked ? m.color : MakeFitTheme.slateBorder,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      m.unlocked
                          ? Icons.emoji_events_rounded
                          : Icons.lock_clock_outlined,
                      color:
                          m.unlocked ? m.color : MakeFitTheme.textSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            m.title,
                            style: const TextStyle(
                              color: MakeFitTheme.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                            ),
                          ),
                          Text(
                            m.subtitle,
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

  Widget _buildHealthAndPrivacyFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MakeFitTheme.slateCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MakeFitTheme.emeraldH2f.withValues(alpha: 0.55),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.verified_user_rounded,
            color: MakeFitTheme.emeraldH2f,
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Santé & Confidentialité : Application 100 % hors-ligne sans collecte de données. Écoutez vos articulations et utilisez le bouton « Adapter (Plus doux) » à tout moment.',
              style: TextStyle(
                color: MakeFitTheme.textSecondary,
                fontSize: 11,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
