import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../domain/weekly_report.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../services/widget_service.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';
import 'situations_sheet.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pitStops = ref.watch(pitStopsProvider).value ?? const [];
    final reports = ref.watch(weeklyReportsProvider);
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
                    GraffitiHeadline(l10n.journalTitle, size: 30),
                    GestureDetector(
                      onTap: () => showSituationsSheet(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: PaceColors.neonCyan),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.tune, color: PaceColors.neonCyan, size: 16),
                            const SizedBox(width: 6),
                            Text(l10n.journalSituations,
                                style: const TextStyle(
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
                child: pitStops.isEmpty && reports.isEmpty
                    ? const _EmptyState()
                    : _JournalList(
                        pitStops: pitStops,
                        reports: reports,
                        labels: labels,
                        now: now),
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
    required this.reports,
    required this.labels,
    required this.now,
  });

  final List<PitStop> pitStops;
  final List<WeeklyReport> reports;
  final Map<String, String> labels;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    // Merge pit stops and weekly reports into one newest-first feed.
    final feed = <({DateTime ts, PitStop? pit, WeeklyReport? report})>[
      for (final p in pitStops) (ts: p.occurredAt, pit: p, report: null),
      for (final r in reports) (ts: r.weekEnd, pit: null, report: r),
    ]..sort((a, b) => b.ts.compareTo(a.ts));

    final rows = <Widget>[];
    DateTime? lastDay;
    for (final item in feed) {
      if (item.report != null) {
        rows.add(_ReportCard(report: item.report!));
        lastDay = null; // next pit stop gets a fresh day header
        continue;
      }
      final p = item.pit!;
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

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});

  final WeeklyReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final delta = report.cigaretteDelta;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PaceColors.neonMagenta.withValues(alpha: 0.16),
            PaceColors.neonPurple.withValues(alpha: 0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaceColors.neonMagenta.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
              color: PaceColors.neonMagenta.withValues(alpha: 0.15), blurRadius: 18),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_circle, color: PaceColors.neonMagenta, size: 20),
              const SizedBox(width: 8),
              Text(l10n.journalRaceReportWeek(report.weekNumber.toString()),
                  style: const TextStyle(
                      color: PaceColors.neonMagenta,
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                report.medianPace == null
                    ? '—'
                    : l10n.journalEvery(formatHumanDuration(report.medianPace!)),
                style: PaceTheme.dash(size: 26, weight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(l10n.journalMedianPace,
                  style: TextStyle(color: PaceColors.textMuted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ReportStat(
                  label: l10n.journalCigarettes, value: '${report.cigarettes}', color: PaceColors.neonCyan),
              const SizedBox(width: 20),
              _ReportStat(
                  label: l10n.journalSpin, value: '${report.dreher}', color: PaceColors.neonOrange),
              const Spacer(),
              if (delta != null && delta != 0)
                Text(
                  delta < 0 ? l10n.journalFewer((-delta).toString()) : '+$delta',
                  style: TextStyle(
                      color: delta < 0 ? PaceColors.neonLime : PaceColors.neonOrange,
                      fontSize: 13,
                      fontWeight: FontWeight.w800),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportStat extends StatelessWidget {
  const _ReportStat({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(value, style: PaceTheme.dash(size: 20, color: color)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: PaceColors.textMuted, fontSize: 12)),
      ],
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

class _PitStopCard extends ConsumerWidget {
  const _PitStopCard({required this.pitStop, required this.situation});

  final PitStop pitStop;
  final String? situation;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: PaceColors.panel,
        title: Text(l10n.journalDeletePitStopTitle),
        content: Text(l10n.journalDeletePitStopBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.journalCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: PaceColors.neonOrange,
                foregroundColor: Colors.black),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.journalDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(databaseProvider).deletePitStop(pitStop.id);
    await pushPaceWidget(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
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
                  child: Text(l10n.journalSpinBadge,
                      style: const TextStyle(
                          color: PaceColors.neonOrange,
                          fontSize: 10,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w800)),
                ),
              GestureDetector(
                onTap: () => _delete(context, ref),
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.delete_outline,
                      color: PaceColors.textFaint, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MiniLevel(
                  label: l10n.journalCraving,
                  value: pitStop.cravingLevel,
                  color: PaceColors.neonMagenta),
              const SizedBox(width: 16),
              _MiniLevel(
                  label: l10n.journalStress,
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
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.flag_outlined,
                color: PaceColors.neonLime, size: 56),
            const SizedBox(height: 16),
            Text(l10n.journalEmptyTitle,
                style: PaceTheme.dash(size: 24, italic: true)),
            const SizedBox(height: 8),
            Text(
              l10n.journalEmptyBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: PaceColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
