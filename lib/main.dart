import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'engine/makefit_engine.dart';
import 'models/makefit_models.dart';
import 'ui/barracks_and_trials_tab.dart';
import 'ui/command_center_tab.dart';
import 'ui/makefit_juicy_widgets.dart';
import 'ui/skill_tree_and_codex_tab.dart';
import 'ui/workout_player_modal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MakeFitApp());
}

/// Alias de compatibilité descendante.
typedef MyApp = MakeFitApp;

/// Application racine MakeFit (`v1.0.0` — Tactical RPG Military Calisthenics 100 % Sans Matériel).
class MakeFitApp extends StatefulWidget {
  const MakeFitApp({
    super.key,
    this.engine,
  });

  final MakeFitEngine? engine;

  @override
  State<MakeFitApp> createState() => _MakeFitAppState();
}

class _MakeFitAppState extends State<MakeFitApp> {
  late MakeFitEngine _engine;
  bool _ownsEngine = false;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.engine != null) {
      _engine = widget.engine!;
      _ownsEngine = false;
    } else {
      _engine = MakeFitEngine();
      _ownsEngine = true;
    }
  }

  @override
  void didUpdateWidget(covariant MakeFitApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.engine != oldWidget.engine) {
      if (_ownsEngine) {
        _engine.dispose();
      }
      if (widget.engine != null) {
        _engine = widget.engine!;
        _ownsEngine = false;
      } else {
        _engine = MakeFitEngine();
        _ownsEngine = true;
      }
    }
  }

  @override
  void dispose() {
    if (_ownsEngine) {
      _engine.dispose();
    }
    super.dispose();
  }

  void _onSelectTab(int index) {
    HapticFeedback.selectionClick();
    setState(() => _selectedTabIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MakeFit — Tactical Calisthenics RPG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: MakeFitTheme.oledBlack,
        colorScheme: const ColorScheme.dark(
          primary: MakeFitTheme.amberTactical,
          secondary: MakeFitTheme.cyanRadar,
          surface: MakeFitTheme.slateCard,
        ),
        useMaterial3: true,
      ),
      home: ListenableBuilder(
        listenable: _engine,
        builder: (BuildContext context, Widget? _) {
          return Scaffold(
            backgroundColor: MakeFitTheme.oledBlack,
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  IndexedStack(
                    index: _selectedTabIndex,
                    children: <Widget>[
                      CommandCenterTab(engine: _engine),
                      SkillTreeAndCodexTab(engine: _engine),
                      BarracksAndTrialsTab(engine: _engine),
                    ],
                  ),
                  ValueListenableBuilder<WorkoutLiveSnapshot?>(
                    valueListenable: _engine.liveWorkoutNotifier,
                    builder: (
                      BuildContext context,
                      WorkoutLiveSnapshot? liveSnap,
                      Widget? _,
                    ) {
                      if (liveSnap == null) {
                        return const SizedBox.shrink();
                      }
                      return Positioned.fill(
                        child: WorkoutPlayerModal(
                          engine: _engine,
                          snapshot: liveSnap,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _buildTacticalBottomBar(),
          );
        },
      ),
    );
  }

  Widget _buildTacticalBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: MakeFitTheme.slateSurface,
        border: Border(
          top: BorderSide(color: MakeFitTheme.slateBorder, width: 1.5),
        ),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: MakeFitTheme.slateSurface,
          indicatorColor: MakeFitTheme.amberTactical.withValues(alpha: 0.22),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) {
              final bool selected = states.contains(WidgetState.selected);
              return TextStyle(
                color: selected
                    ? MakeFitTheme.amberTactical
                    : MakeFitTheme.textSecondary,
                fontWeight: FontWeight.w900,
                fontSize: 11,
                letterSpacing: 0.4,
              );
            },
          ),
        ),
        child: NavigationBar(
          height: 64,
          selectedIndex: _selectedTabIndex,
          onDestinationSelected: _onSelectTab,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(
                Icons.radar_rounded,
                color: MakeFitTheme.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.radar_rounded,
                color: MakeFitTheme.amberTactical,
              ),
              label: 'COMMAND CENTER',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.account_tree_rounded,
                color: MakeFitTheme.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.account_tree_rounded,
                color: MakeFitTheme.amberTactical,
              ),
              label: 'SKILL TREE 25',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.military_tech_rounded,
                color: MakeFitTheme.textSecondary,
              ),
              selectedIcon: Icon(
                Icons.military_tech_rounded,
                color: MakeFitTheme.amberTactical,
              ),
              label: 'CASERNE & PT',
            ),
          ],
        ),
      ),
    );
  }
}
