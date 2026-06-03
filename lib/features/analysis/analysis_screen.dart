import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/behavior_analysis.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(behaviorAnalysisProvider);

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: a.total == 0
              ? const _EmptyState()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    const GraffitiHeadline('Race Analysis', size: 26),
                    const SizedBox(height: 16),
                    _MedianPaceCard(pace: a.medianPace),
                    const SizedBox(height: 16),
                    _SummaryRow(a: a),
                    const SizedBox(height: 28),
                    _SectionLabel('Deine Auslöser'),
                    const SizedBox(height: 12),
                    _SituationBars(a: a),
                    const SizedBox(height: 28),
                    _SectionLabel('Letzte 7 Tage'),
                    const SizedBox(height: 12),
                    _WeekBars(a: a),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MedianPaceCard extends StatelessWidget {
  const _MedianPaceCard({required this.pace});

  final Duration? pace;

  @override
  Widget build(BuildContext context) {
    final has = pace != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PaceColors.neonCyan.withValues(alpha: 0.18),
            PaceColors.neonLime.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PaceColors.neonCyan.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
              color: PaceColors.neonCyan.withValues(alpha: 0.12), blurRadius: 22),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.speed, color: PaceColors.neonCyan, size: 18),
              const SizedBox(width: 6),
              Text('MEDIAN-PACE',
                  style: TextStyle(
                      color: PaceColors.neonCyan,
                      fontSize: 12,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            has ? 'alle ${formatHumanDuration(pace!)}' : 'sammelt noch …',
            style: PaceTheme.dash(
                size: has ? 40 : 28,
                weight: FontWeight.w900,
                color: has ? Colors.white : PaceColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            has
                ? 'Typischer Abstand zwischen zwei Kippen — je größer, desto besser 🏁'
                : 'Trag ein paar Boxenstopps ein, dann erscheint dein Schnitt.',
            style: TextStyle(color: PaceColors.textMuted, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        style: const TextStyle(
            color: PaceColors.textMuted,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w700));
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.a});
  final BehaviorAnalysis a;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatTile(
            label: '⌀ Verlangen',
            value: a.avgCraving.toStringAsFixed(1),
            color: PaceColors.neonMagenta),
        const SizedBox(width: 12),
        _StatTile(
            label: '⌀ Stress',
            value: a.avgStress.toStringAsFixed(1),
            color: PaceColors.neonOrange),
        const SizedBox(width: 12),
        _StatTile(
            label: 'Dreher',
            value: '${(a.earlyRate * 100).round()}%',
            color: PaceColors.neonCyan),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: PaceColors.panel.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(value, style: PaceTheme.dash(size: 26, color: color)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: PaceColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _SituationBars extends StatelessWidget {
  const _SituationBars({required this.a});
  final BehaviorAnalysis a;

  @override
  Widget build(BuildContext context) {
    final max = a.bySituation.first.count;
    return Column(
      children: [
        for (final s in a.bySituation)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(s.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: PaceColors.textPrimary, fontSize: 13)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        Container(height: 22, color: PaceColors.night),
                        FractionallySizedBox(
                          widthFactor: max == 0 ? 0 : s.count / max,
                          child: Container(
                            height: 22,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  PaceColors.neonMagenta,
                                  PaceColors.neonPurple
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 24,
                  child: Text('${s.count}',
                      textAlign: TextAlign.right,
                      style: PaceTheme.dash(size: 18, color: PaceColors.neonMagenta)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.a});
  final BehaviorAnalysis a;

  static const _letters = ['M', 'D', 'M', 'D', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final max = a.last7Days.fold<int>(1, (m, d) => d.count > m ? d.count : m);
    return Container(
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final d in a.last7Days)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${d.count}',
                      style: const TextStyle(
                          color: PaceColors.textMuted, fontSize: 11)),
                  const SizedBox(height: 4),
                  Container(
                    height: (d.count / max) * 80 + 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [PaceColors.neonCyan, PaceColors.neonLime],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(_letters[d.day.weekday - 1],
                      style: const TextStyle(
                          color: PaceColors.textFaint, fontSize: 11)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insights, color: PaceColors.neonCyan, size: 56),
            const SizedBox(height: 16),
            Text('Noch keine Telemetrie',
                style: PaceTheme.dash(size: 24, italic: true)),
            const SizedBox(height: 8),
            const Text(
              'Sobald du Boxenstopps einträgst, erkennen wir hier dein Muster — '
              'wann, wo und wie stark dein Verlangen ist.',
              textAlign: TextAlign.center,
              style: TextStyle(color: PaceColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
