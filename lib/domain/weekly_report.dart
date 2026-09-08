import 'behavior_analysis.dart' show PitSample;

/// A finished-week "race report" — derived from pit stops, no storage needed.
class WeeklyReport {
  const WeeklyReport({
    required this.weekNumber,
    required this.weekStart,
    required this.weekEnd,
    required this.cigarettes,
    required this.cigarettesPrevWeek,
    required this.medianPace,
    required this.dreher,
  });

  final int weekNumber; // 1-based
  final DateTime weekStart;
  final DateTime weekEnd; // exclusive
  final int cigarettes;
  final int? cigarettesPrevWeek;
  final Duration? medianPace;
  final int dreher;

  /// Change in cigarettes vs the previous week (negative = fewer = good).
  int? get cigaretteDelta =>
      cigarettesPrevWeek == null ? null : cigarettes - cigarettesPrevWeek!;
}

abstract final class WeeklyReportBuilder {
  static const Duration week = Duration(days: 7);

  /// One report per *completed* week since [startedAt], newest first.
  static List<WeeklyReport> build(
    List<PitSample> samples, {
    required DateTime startedAt,
    required DateTime now,
  }) {
    final reports = <WeeklyReport>[];
    var weekIndex = 0;
    final counts = <int>[]; // cigarettes per completed week, by index

    while (true) {
      final start = startedAt.add(week * weekIndex);
      final end = start.add(week);
      if (now.isBefore(end)) break; // week not finished yet

      final inWeek =
          samples
              .where(
                (s) =>
                    !s.occurredAt.isBefore(start) && s.occurredAt.isBefore(end),
              )
              .toList()
            ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));

      counts.add(inWeek.length);
      reports.add(
        WeeklyReport(
          weekNumber: weekIndex + 1,
          weekStart: start,
          weekEnd: end,
          cigarettes: inWeek.length,
          cigarettesPrevWeek: weekIndex > 0 ? counts[weekIndex - 1] : null,
          medianPace: _median(inWeek),
          dreher: inWeek.where((s) => s.wasEarly).length,
        ),
      );
      weekIndex++;
    }

    return reports.reversed.toList();
  }

  static Duration? _median(List<PitSample> sorted) {
    if (sorted.length < 2) return null;
    final gaps = <int>[
      for (var i = 1; i < sorted.length; i++)
        sorted[i].occurredAt.difference(sorted[i - 1].occurredAt).inSeconds,
    ]..sort();
    final mid = gaps.length ~/ 2;
    final median = gaps.length.isOdd
        ? gaps[mid]
        : ((gaps[mid - 1] + gaps[mid]) / 2).round();
    return Duration(seconds: median);
  }
}
