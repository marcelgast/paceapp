import 'package:flutter/material.dart';

import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';

/// Placeholder for tabs still in the pit lane.
class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key, required this.title, required this.icon, required this.note});

  final String title;
  final IconData icon;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 64, color: PaceColors.neonMagenta),
                const SizedBox(height: 16),
                Text(title, style: PaceTheme.dash(size: 34, italic: true)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    note,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: PaceColors.textMuted, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: PaceColors.neonCyan),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('IN DER BOXENGASSE',
                      style: TextStyle(
                          color: PaceColors.neonCyan,
                          fontSize: 11,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
