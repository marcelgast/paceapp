/// Pure logic for the weekly "stretch your target" proposal.
///
/// The target *learns* from real behaviour: the base is the median gap between
/// your recent cigarettes (robust against overnight gaps), never below your
/// current target. The user then stretches it by a slider amount.
library;

abstract final class ProposalCalculator {
  static const Duration window = Duration(days: 7);
  static const double minGrowth = 0.05;
  static const double maxGrowth = 0.30;
  static const double defaultGrowth = 0.10;

  /// Median gap between consecutive pit stops inside the last [window].
  /// Returns null when there isn't enough data to be meaningful.
  static Duration? measuredMedian({
    required List<DateTime> pitTimes,
    required DateTime now,
  }) {
    final from = now.subtract(window);
    final recent = pitTimes.where((t) => t.isAfter(from)).toList()..sort();
    if (recent.length < 3) return null;

    final gaps = <int>[
      for (var i = 1; i < recent.length; i++)
        recent[i].difference(recent[i - 1]).inSeconds,
    ]..sort();
    if (gaps.isEmpty) return null;

    final mid = gaps.length ~/ 2;
    final median = gaps.length.isOdd
        ? gaps[mid]
        : ((gaps[mid - 1] + gaps[mid]) / 2).round();
    return Duration(seconds: median);
  }

  /// Base interval to stretch from: the learned median, but never below the
  /// current target (we don't propose going backwards), with a [fallback] for
  /// when there's no measured data yet.
  static Duration baseFor({
    required Duration? measured,
    required Duration? currentTarget,
    required Duration fallback,
  }) {
    final learned = measured ?? fallback;
    if (currentTarget == null) return learned;
    return learned > currentTarget ? learned : currentTarget;
  }

  /// Proposed target = base stretched by [growth] (e.g. 0.10 = +10 %).
  static Duration proposed({required Duration base, required double growth}) {
    return Duration(seconds: (base.inSeconds * (1 + growth)).round());
  }
}
