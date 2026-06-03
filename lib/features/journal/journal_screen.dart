import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';
import 'situations_sheet.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pitStops = ref.watch(pitStopsProvider).value ?? const [];
    final labels = ref.watch(situationLabelsProvider);
    final now = DateTime.now();

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const GraffitiHeadline('Journal', size: 30),
                    GestureDetector(
                      onTap: () => showSituationsSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PaceColors.neonCyan),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.tune, color: PaceColors.neonCyan, size: 16),
                            SizedBox(width: 6),
                            Text('Situationen',
                                style: TextStyle(
                                    color: PaceColors.neonCyan,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: pitStops.isEmpty
                    ? const _EmptyState()
                    : _JournalList(pitStops: pitStops, labels: labels, now: now),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JournalList extends StatelessWidget {
  const _JournalList({
    required this.pitStops,
    required this.labels,
    required this.now,
  });

  final List<PitStop> pitStops;
  final Map<String, String> labels;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    // Flatten into day-headers + entries (pitStops already newest-first).
    final rows = <Widget>[];
    DateTime? lastDay;
    for (final p in pitStops) {
      final day = DateTime(p.occurredAt.year, p.occurredAt.month, p.occurredAt.day);
      if (lastDay == null || day != lastDay) {
        rows.add(_DayHeader(label: formatDayHeader(day, now)));
        lastDay = day;
      }
      rows.add(_PitStopCard(
        pitStop: p,
        situation: p.situationId == null ? null : labels[p.situationId],
      ));
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      children: rows,
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: PaceColors.textMuted,
          fontSize: 12,
          letterSpacing: 2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PitStopCard extends StatelessWidget {
  const _PitStopCard({required this.pitStop, required this.situation});

  final PitStop pitStop;
  final String? situation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(formatClock(pitStop.occurredAt),
                  style: PaceTheme.dash(size: 22, color: PaceColors.neonCyan)),
              const SizedBox(width: 12),
              if (situation != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: PaceColors.panelLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(situation!,
                      style: const TextStyle(
                          color: PaceColors.textPrimary, fontSize: 12)),
                ),
              const Spacer(),
              if (pitStop.wasEarlyPit)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: PaceColors.neonOrange.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('DREHER',
                      style: TextStyle(
                          color: PaceColors.neonOrange,
                          fontSize: 10,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w800)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MiniLevel(
                  label: 'Verlangen',
                  value: pitStop.cravingLevel,
                  color: PaceColors.neonMagenta),
              const SizedBox(width: 16),
              _MiniLevel(
                  label: 'Stress',
                  value: pitStop.stressLevel,
                  color: PaceColors.neonOrange),
            ],
          ),
          if (pitStop.note != null && pitStop.note!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(pitStop.note!,
                style: TextStyle(
                    color: PaceColors.textMuted,
                    fontSize: 13,
                    fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }
}

class _MiniLevel extends StatelessWidget {
  const _MiniLevel({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label ',
            style: const TextStyle(color: PaceColors.textFaint, fontSize: 12)),
        for (var i = 1; i <= 5; i++)
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(right: 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i <= value ? color : PaceColors.chrome,
            ),
          ),
      ],
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
            const Icon(Icons.flag_outlined,
                color: PaceColors.neonLime, size: 56),
            const SizedBox(height: 16),
            Text('Noch keine Boxenstopps',
                style: PaceTheme.dash(size: 24, italic: true)),
            const SizedBox(height: 8),
            const Text(
              'Und das ist gut so. Sobald du einen Boxenstopp einträgst, '
              'siehst du hier dein Muster.',
              textAlign: TextAlign.center,
              style: TextStyle(color: PaceColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
