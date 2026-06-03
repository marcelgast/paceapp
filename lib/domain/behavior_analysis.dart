/// Pure behavioural aggregation over pit stops — no Flutter, fully testable.
library;

class PitSample {
  const PitSample({
    required this.occurredAt,
    required this.craving,
    required this.stress,
    required this.situationId,
    required this.wasEarly,
  });

  final DateTime occurredAt;
  final int craving;
  final int stress;
  final String? situationId;
  final bool wasEarly;
}

class SituationCount {
  const SituationCount(this.label, this.count);
  final String label;
  final int count;
}

class DayCount {
  const DayCount(this.day, this.count);
  final DateTime day;
  final int count;
}

class BehaviorAnalysis {
  const BehaviorAnalysis({
    required this.total,
    required this.avgCraving,
    required this.avgStress,
    required this.earlyPits,
    required this.earlyRate,
    required this.bySituation,
    required this.last7Days,
    required this.medianPace,
    required this.previousMedianPace,
  });

  final int total;
  final double avgCraving;
  final double avgStress;
  final int earlyPits;
  final double earlyRate;
  final List<SituationCount> bySituation;
  final List<DayCount> last7Days;

  /// Median time between cigarettes over the last 7 days — the "pace".
  /// Grows as the user stretches their intervals. Null with too little data.
  final Duration? medianPace;

  /// Median pace over the week before that (days 7–14 ago), for a trend.
  final Duration? previousMedianPace;

  static const String noSituationLabel = 'Ohne Angabe';

  factory BehaviorAnalysis.from(
    List<PitSample> samples, {
    required Map<String, String> labels,
    required DateTime now,
  }) {
    final total = samples.length;
    if (total == 0) {
      final empty7 = _last7DaysScaffold(now);
      return BehaviorAnalysis(
        total: 0,
        avgCraving: 0,
        avgStress: 0,
        earlyPits: 0,
        earlyRate: 0,
        bySituation: const [],
        last7Days: empty7,
        medianPace: null,
        previousMedianPace: null,
      );
    }

    var craving = 0;
    var stress = 0;
    var early = 0;
    final counts = <String, int>{};
    for (final s in samples) {
      craving += s.craving;
      stress += s.stress;
      if (s.wasEarly) early++;
      final key = s.situationId ?? '';
      counts[key] = (counts[key] ?? 0) + 1;
    }

    final bySituation = counts.entries
        .map((e) => SituationCount(
              e.key.isEmpty ? noSituationLabel : (labels[e.key] ?? noSituationLabel),
              e.value,
            ))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    // Fill the last-7-days buckets.
    final buckets = _last7DaysScaffold(now);
    final byDay = {for (var i = 0; i < buckets.length; i++) buckets[i].day: 0};
    for (final s in samples) {
      final d = DateTime(s.occurredAt.year, s.occurredAt.month, s.occurredAt.day);
      if (byDay.containsKey(d)) byDay[d] = byDay[d]! + 1;
    }
    final last7 = byDay.entries.map((e) => DayCount(e.key, e.value)).toList();

    return BehaviorAnalysis(
      total: total,
      avgCraving: craving / total,
      avgStress: stress / total,
      earlyPits: early,
      earlyRate: early / total,
      bySituation: bySituation,
      last7Days: last7,
      medianPace: _medianPaceBetween(
          samples, now.subtract(const Duration(days: 7)), now),
      previousMedianPace: _medianPaceBetween(samples,
          now.subtract(const Duration(days: 14)),
          now.subtract(const Duration(days: 7))),
    );
  }

  /// Median gap between consecutive cigarettes in the window [from, to).
  static Duration? _medianPaceBetween(
      List<PitSample> samples, DateTime from, DateTime to) {
    final times = samples
        .map((s) => s.occurredAt)
        .where((t) => !t.isBefore(from) && t.isBefore(to))
        .toList()
      ..sort();
    if (times.length < 2) return null;

    final gaps = <int>[
      for (var i = 1; i < times.length; i++)
        times[i].difference(times[i - 1]).inSeconds,
    ]..sort();
    final mid = gaps.length ~/ 2;
    final median = gaps.length.isOdd
        ? gaps[mid]
        : ((gaps[mid - 1] + gaps[mid]) / 2).round();
    return Duration(seconds: median);
  }

  static List<DayCount> _last7DaysScaffold(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return [
      for (var i = 6; i >= 0; i--)
        DayCount(today.subtract(Duration(days: i)), 0),
    ];
  }
}
