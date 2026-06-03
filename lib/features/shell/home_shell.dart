import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../services/widget_service.dart';
import '../../theme/pace_colors.dart';
import '../analysis/analysis_screen.dart';
import '../cockpit/cockpit_screen.dart';
import '../cockpit/pit_stop_action.dart';
import '../journal/journal_screen.dart';
import '../trophies/trophies_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell>
    with WidgetsBindingObserver {
  int _index = 0;

  static const _tabs = [
    CockpitScreen(),
    AnalysisScreen(),
    TrophiesScreen(),
    JournalScreen(),
  ];

  bool _openingPitStop = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      pushPaceWidget(ref);
      _checkPendingAction();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPendingAction();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      pushPaceWidget(ref);
    }
  }

  /// The widget's Boxenstopp button writes a flag into the App Group (via the
  /// SceneDelegate). When we see it, open the pit-stop form and clear the flag.
  Future<void> _checkPendingAction() async {
    if (_openingPitStop) return;
    String? action;
    try {
      action = await HomeWidget.getWidgetData<String>('pending_action');
      if (action != 'boxenstopp') return;
      await HomeWidget.saveWidgetData<String>('pending_action', '');
    } catch (_) {
      return; // home_widget unavailable (e.g. simulator) — nothing to do.
    }
    if (!mounted) return;
    _openingPitStop = true;
    setState(() => _index = 0);
    try {
      await recordPitStop(context, ref);
    } finally {
      _openingPitStop = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: PaceColors.panel,
          border: Border(
            top: BorderSide(color: PaceColors.chrome.withValues(alpha: 0.4)),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            indicatorColor: PaceColors.neonMagenta.withValues(alpha: 0.18),
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
          child: NavigationBar(
            height: 64,
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.speed_outlined),
                selectedIcon: Icon(Icons.speed, color: PaceColors.neonMagenta),
                label: 'Cockpit',
              ),
              NavigationDestination(
                icon: Icon(Icons.insights_outlined),
                selectedIcon: Icon(Icons.insights, color: PaceColors.neonMagenta),
                label: 'Analyse',
              ),
              NavigationDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon:
                    Icon(Icons.emoji_events, color: PaceColors.neonMagenta),
                label: 'Pokale',
              ),
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon:
                    Icon(Icons.menu_book, color: PaceColors.neonMagenta),
                label: 'Journal',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
