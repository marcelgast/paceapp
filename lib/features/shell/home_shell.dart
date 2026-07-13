import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../services/widget_service.dart';
import '../../theme/pace_colors.dart';
import '../analysis/analysis_screen.dart';
import '../cockpit/cockpit_screen.dart';
import '../cockpit/pit_stop_action.dart';
import '../goals/goals_screen.dart';
import '../journal/journal_screen.dart';
import '../recovery/recovery_screen.dart';
import '../trophies/trophies_screen.dart';

/// Initial tab, overridden only by the screenshot tooling (SHOTS build flag).
int kDemoInitialTab = 0;

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell>
    with WidgetsBindingObserver {
  int _index = kDemoInitialTab;

  static const _tabs = [
    CockpitScreen(),
    AnalysisScreen(),
    RecoveryScreen(),
    TrophiesScreen(),
    GoalsScreen(),
    JournalScreen(),
  ];

  // Static so the guard survives any State rebuild/remount, and a cooldown on
  // top: a widget cold-launch fires _checkPendingAction from both the initState
  // post-frame and the resume callback. The in-flight flag stops the
  // simultaneous case; the timestamp stops a second consumption if the two
  // triggers are far enough apart that the first already finished.
  static bool _consumingPitStop = false;
  static DateTime? _pitStopConsumedAt;

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
    if (_consumingPitStop) return;
    final consumedAt = _pitStopConsumedAt;
    if (consumedAt != null &&
        DateTime.now().difference(consumedAt) < const Duration(seconds: 3)) {
      return;
    }
    _consumingPitStop = true;
    try {
      final action = await HomeWidget.getWidgetData<String>('pending_action');
      if (action != 'boxenstopp') return;
      await HomeWidget.saveWidgetData<String>('pending_action', '');
      _pitStopConsumedAt = DateTime.now();
      if (!mounted) return;
      setState(() => _index = 0);
      await recordPitStop(context, ref);
    } catch (_) {
      // home_widget unavailable (e.g. simulator) — nothing to do.
    } finally {
      _consumingPitStop = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Push the Live Activity the instant the stint phase flips (e.g. into
    // overtime): the .timer text self-updates, but the surrounding colour and
    // label only re-render on a push.
    ref.listen(liveStintProvider.select((s) => s?.phase), (_, _) {
      pushPaceWidget(ref);
    });
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
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.speed_outlined),
                selectedIcon:
                    Icon(Icons.speed, color: PaceColors.neonMagenta),
                label: l10n.tabCockpit,
              ),
              NavigationDestination(
                icon: const Icon(Icons.insights_outlined),
                selectedIcon:
                    Icon(Icons.insights, color: PaceColors.neonMagenta),
                label: l10n.tabAnalysis,
              ),
              NavigationDestination(
                icon: const Icon(Icons.monitor_heart_outlined),
                selectedIcon: Icon(Icons.monitor_heart,
                    color: PaceColors.neonMagenta),
                label: l10n.tabBody,
              ),
              NavigationDestination(
                icon: const Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events,
                    color: PaceColors.neonMagenta),
                label: l10n.tabTrophies,
              ),
              NavigationDestination(
                icon: const Icon(Icons.savings_outlined),
                selectedIcon:
                    Icon(Icons.savings, color: PaceColors.neonMagenta),
                label: l10n.tabGoals,
              ),
              NavigationDestination(
                icon: const Icon(Icons.menu_book_outlined),
                selectedIcon:
                    Icon(Icons.menu_book, color: PaceColors.neonMagenta),
                label: l10n.tabJournal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
