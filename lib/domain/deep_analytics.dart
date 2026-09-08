import 'behavior_analysis.dart';

/// One trigger situation with how often it shows up and how hard the craving is.
class TriggerStat {
  const TriggerStat({
    required this.label,
    required this.count,
    required this.avgCraving,
  });

  final String label;
  final int count;
  final double avgCraving;
}

/// A rolling 7-day window's consumption, for the trend.
class TrendPoint {
  const TrendPoint({required this.weeksAgo, required this.cigarettesPerDay});

  final int weeksAgo; // 0 = the last 7 days, 1 = the 7 before that, …
  final double cigarettesPerDay;
}

/// The "Race Engineer" deep analytics — when, where and how your cravings hit,
/// plus the long trend. Pure aggregation over pit stops, fully testable.
class DeepAnalytics {
  const DeepAnalytics({
    required this.total,
    required this.byHour,
    required this.byWeekday,
    required this.peakHour,
    required this.peakWeekday,
    required this.triggers,
    required this.trend,
  });

  final int total;

  /// Cigarettes per hour of day (index 0..23).
  final List<int> byHour;

  /// Cigarettes per weekday (index 0 = Monday … 6 = Sunday).
  final List<int> byWeekday;

  /// Hour (0..23) with the most cigarettes, or -1 if no data.
  final int peakHour;

  /// Weekday (0 = Monday … 6 = Sunday) with the most cigarettes, or -1.
  final int peakWeekday;

  /// Top trigger situations, most frequent first.
  final List<TriggerStat> triggers;

  /// Rolling-week consumption, oldest first, for the downward trend.
  final List<TrendPoint> trend;

  factory DeepAnalytics.from(
    List<PitSample> samples, {
    required Map<String, String> labels,
    required DateTime now,
    required String noSituationLabel,
    int maxTriggers = 6,
    int maxWeeks = 6,
  }) {
    final byHour = List<int>.filled(24, 0);
    final byWeekday = List<int>.filled(7, 0);
    final counts = <String, int>{};
    final cravingSum = <String, int>{};

    for (final s in samples) {
      byHour[s.occurredAt.hour]++;
      byWeekday[s.occurredAt.weekday - 1]++;
      final key = s.situationId ?? '';
      counts[key] = (counts[key] ?? 0) + 1;
      cravingSum[key] = (cravingSum[key] ?? 0) + s.craving;
    }

    final triggers =
        counts.entries
            .map(
              (e) => TriggerStat(
                label: e.key.isEmpty
                    ? noSituationLabel
                    : (labels[e.key] ?? noSituationLabel),
                count: e.value,
                avgCraving: cravingSum[e.key]! / e.value,
              ),
            )
            .toList()
          ..sort((a, b) => b.count.compareTo(a.count));

    // Rolling 7-day windows back from now, only as far as there is data.
    final earliest = samples.isEmpty
        ? now
        : samples
              .map((s) => s.occurredAt)
              .reduce((a, b) => a.isBefore(b) ? a : b);
    final weeksOfData = (now.difference(earliest).inDays / 7).ceil().clamp(
      1,
      maxWeeks,
    );
    final trend = <TrendPoint>[];
    for (var w = weeksOfData - 1; w >= 0; w--) {
      final to = now.subtract(Duration(days: 7 * w));
      final from = now.subtract(Duration(days: 7 * (w + 1)));
      final count = samples
          .where(
            (s) => !s.occurredAt.isBefore(from) && s.occurredAt.isBefore(to),
          )
          .length;
      trend.add(TrendPoint(weeksAgo: w, cigarettesPerDay: count / 7));
    }

    return DeepAnalytics(
      total: samples.length,
      byHour: byHour,
      byWeekday: byWeekday,
      peakHour: samples.isEmpty ? -1 : _argmax(byHour),
      peakWeekday: samples.isEmpty ? -1 : _argmax(byWeekday),
      triggers: triggers.take(maxTriggers).toList(),
      trend: trend,
    );
  }

  static int _argmax(List<int> xs) {
    var best = 0;
    for (var i = 1; i < xs.length; i++) {
      if (xs[i] > xs[best]) best = i;
    }
    return best;
  }
}
