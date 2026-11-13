import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../engine/makefit_engine.dart';
import '../models/makefit_models.dart';
import '../painters/makefit_vector_assets.dart';
import 'makefit_juicy_widgets.dart';

/// Écran de Création de Profil au Démarrage (`v1.1.0`).
/// Affiché dès l'ouverture lorsque `engine.profile.isProfileCreated == false`.
/// Simple, aéré, motivant et orienté remise en forme Homme 40+ en 10 min max / jour.
class ProfileOnboardingScreen extends StatefulWidget {
  const ProfileOnboardingScreen({
    super.key,
    required this.engine,
  });

  final MakeFitEngine engine;

  @override
  State<ProfileOnboardingScreen> createState() =>
      _ProfileOnboardingScreenState();
}

class _ProfileOnboardingScreenState extends State<ProfileOnboardingScreen> {
  static const List<String> _quickNames = <String>[
    'Thomas',
    'Marc',
    'David',
    'Julien',
    'Nicolas',
  ];

  late final TextEditingController _nameController;
  late int _ageYears;
  late FitnessGoal40Plus _selectedGoal;
  late FitnessInitialLevel _selectedLevel;
  late int _preferredMinutes;
  late bool _jointAndNoJumpMode;

  @override
  void initState() {
    super.initState();
    final SoldierProfileState p = widget.engine.profile;
    _nameController = TextEditingController(text: p.callsign);
    _ageYears = p.ageYears > 0 ? p.ageYears : 40;
    _selectedGoal = p.fitnessGoal;
    _selectedLevel = p.fitnessLevel;
    _preferredMinutes = p.preferredSessionMinutes.clamp(6, 10);
    _jointAndNoJumpMode =
        p.stealthApartmentMode || p.jointFriendlyMode != JointFriendlyMode.standard;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    widget.engine.completeProfileCreation(
      firstName: _nameController.text,
      ageYears: _ageYears,
      goal: _selectedGoal,
      level: _selectedLevel,
      preferredSessionMinutes: _preferredMinutes,
      jointProtection: _jointAndNoJumpMode,
      silentNoJump: _jointAndNoJumpMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: MakeFitTheme.oledBlack,
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildWelcomeBanner(),
                  const SizedBox(height: 14),
                  _buildIdentitySection(),
                  const SizedBox(height: 14),
                  _buildGoalSection(),
                  const SizedBox(height: 14),
                  _buildLevelAndDurationSection(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
            decoration: const BoxDecoration(
              color: MakeFitTheme.slateSurface,
              border: Border(
                top: BorderSide(color: MakeFitTheme.slateBorder, width: 1.5),
              ),
            ),
            child: JuicyTactical3DButton(
              label: 'CRÉER MON PROFIL & COMMENCER AU JOUR 1',
              subtitle:
                  'Séance guidée $_preferredMinutes min max • Coach animé auto • 0 matériel',
              icon: Icons.rocket_launch_rounded,
              height: 58,
              fontSize: 13.5,
              onPressed: _submitProfile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
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
        border: Border.all(
          color: MakeFitTheme.amberTactical.withValues(alpha: 0.85),
          width: 1.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const MakeFitLogoBadge(size: 46),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: MakeFitTheme.amberTactical.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'PROGRAMME REMISE EN FORME • DÉPART JOUR 1',
                        style: TextStyle(
                          color: MakeFitTheme.amberTactical,
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Bienvenue sur MakeFit 40+ — Votre remise en forme en 10 min par jour',
                      style: TextStyle(
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
          const SizedBox(height: 10),
          const Text(
            'Appuyez sur GO chaque jour : échauffement, séries animées et repos s\'enchaînent automatiquement en 10 minutes max, chez vous et sans matériel.',
            style: TextStyle(
              color: MakeFitTheme.textSecondary,
              fontSize: 12,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentitySection() {
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
            '1. VOTRE PRÉNOM & VOTRE ÂGE',
            style: TextStyle(
              color: MakeFitTheme.amberTactical,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _nameController,
            style: const TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              labelText: 'Votre Prénom',
              labelStyle: const TextStyle(
                color: MakeFitTheme.textSecondary,
                fontWeight: FontWeight.w700,
              ),
              hintText: 'Ex : Thomas, Marc, David...',
              hintStyle: TextStyle(
                color: MakeFitTheme.textSecondary.withValues(alpha: 0.65),
              ),
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                color: MakeFitTheme.amberTactical,
              ),
              filled: true,
              fillColor: MakeFitTheme.slateSurface,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: MakeFitTheme.slateBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: MakeFitTheme.amberTactical,
                  width: 1.8,
                ),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              const Text(
                'Saisie 1-tap :',
                style: TextStyle(
                  color: MakeFitTheme.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              ..._quickNames.map((String name) {
                final bool isSelected =
                    _nameController.text.trim().toLowerCase() ==
                        name.toLowerCase();
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _nameController.text = name;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MakeFitTheme.amberTactical.withValues(alpha: 0.22)
                          : MakeFitTheme.slateSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? MakeFitTheme.amberTactical
                            : MakeFitTheme.slateBorder,
                      ),
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: isSelected
                            ? MakeFitTheme.amberTactical
                            : MakeFitTheme.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: MakeFitTheme.slateSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MakeFitTheme.slateBorder),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.cake_outlined,
                  color: MakeFitTheme.cyanRadar,
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Votre Âge',
                        style: TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Programme calibré pour la vitalité à 40 ans et +',
                        style: TextStyle(
                          color: MakeFitTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Diminuer l\'âge',
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _ageYears = (_ageYears - 1).clamp(18, 85));
                  },
                  icon: const Icon(
                    Icons.remove_circle_outline_rounded,
                    color: MakeFitTheme.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: MakeFitTheme.amberTactical.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: MakeFitTheme.amberTactical),
                  ),
                  child: Text(
                    '$_ageYears ans',
                    style: const TextStyle(
                      color: MakeFitTheme.amberTactical,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Augmenter l\'âge',
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() => _ageYears = (_ageYears + 1).clamp(18, 85));
                  },
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: MakeFitTheme.amberTactical,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSection() {
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
            '2. VOTRE OBJECTIF PRINCIPAL',
            style: TextStyle(
              color: MakeFitTheme.amberTactical,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          ...FitnessGoal40Plus.values.map((FitnessGoal40Plus goal) {
            final bool selected = _selectedGoal == goal;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedGoal = goal);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: selected
                        ? goal.accentColor.withValues(alpha: 0.18)
                        : MakeFitTheme.slateSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? goal.accentColor
                          : MakeFitTheme.slateBorder,
                      width: selected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: goal.accentColor.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          goal.icon,
                          color: goal.accentColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              goal.title,
                              style: const TextStyle(
                                color: MakeFitTheme.textPrimary,
                                fontWeight: FontWeight.w900,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              goal.subtitle,
                              style: const TextStyle(
                                color: MakeFitTheme.textSecondary,
                                fontSize: 11.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: selected
                            ? goal.accentColor
                            : MakeFitTheme.textSecondary,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLevelAndDurationSection() {
    const List<int> durationOptions = <int>[6, 8, 10];

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
            '3. VOTRE NIVEAU & DURÉE QUOTIDIENNE (10 MIN MAX)',
            style: TextStyle(
              color: MakeFitTheme.amberTactical,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          ...FitnessInitialLevel.values.map((FitnessInitialLevel level) {
            final bool selected = _selectedLevel == level;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedLevel = level);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? MakeFitTheme.emeraldH2f.withValues(alpha: 0.18)
                        : MakeFitTheme.slateSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? MakeFitTheme.emeraldH2f
                          : MakeFitTheme.slateBorder,
                      width: selected ? 1.8 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              level.title,
                              style: const TextStyle(
                                color: MakeFitTheme.textPrimary,
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              level.subtitle,
                              style: const TextStyle(
                                color: MakeFitTheme.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        color: selected
                            ? MakeFitTheme.emeraldH2f
                            : MakeFitTheme.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          const Text(
            'Durée quotidienne souhaitée :',
            style: TextStyle(
              color: MakeFitTheme.textPrimary,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: durationOptions.map((int mins) {
              final bool selected = _preferredMinutes == mins;
              final String label = mins == 10 ? '10 min max' : '$mins min';
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _preferredMinutes = mins);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? MakeFitTheme.amberTactical.withValues(alpha: 0.22)
                            : MakeFitTheme.slateSurface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? MakeFitTheme.amberTactical
                              : MakeFitTheme.slateBorder,
                          width: selected ? 2.0 : 1.0,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: selected
                              ? MakeFitTheme.amberTactical
                              : MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(growable: false),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: MakeFitTheme.slateSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _jointAndNoJumpMode
                    ? MakeFitTheme.cyanRadar
                    : MakeFitTheme.slateBorder,
              ),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.health_and_safety_outlined,
                  color: MakeFitTheme.cyanRadar,
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Ménager mes articulations / Sans saut',
                        style: TextStyle(
                          color: MakeFitTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                      Text(
                        'Protège les genoux, le dos et les poignets (zéro impact)',
                        style: TextStyle(
                          color: MakeFitTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _jointAndNoJumpMode,
                  activeThumbColor: MakeFitTheme.cyanRadar,
                  onChanged: (bool val) {
                    HapticFeedback.selectionClick();
                    setState(() => _jointAndNoJumpMode = val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
