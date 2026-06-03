import 'package:flutter/material.dart';

import '../../theme/pace_colors.dart';
import '../analysis/analysis_screen.dart';
import '../cockpit/cockpit_screen.dart';
import '../journal/journal_screen.dart';
import '../trophies/trophies_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const _tabs = [
    CockpitScreen(),
    AnalysisScreen(),
    TrophiesScreen(),
    JournalScreen(),
  ];

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
