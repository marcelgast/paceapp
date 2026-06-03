/// The clean-run clock derived from pit-stop times. Pure — fully testable.
///
/// A cigarette (pit stop) resets the [current] run; [best] is the longest clean
/// stretch ever. Time milestones unlock on [best] (a record you keep), while the
/// live recovery view tracks [current] (it resets every time you smoke).
class CleanRun {
  const CleanRun({required this.current, required this.best});

  /// Time since the last pit stop (or since the start). Resets on every pit.
  final Duration current;

  /// Longest clean stretch ever: start → first pit, between pits, last pit → now.
  final Duration best;

  factory CleanRun.from({
    required List<DateTime> pitTimes,
    required DateTime startedAt,
    required DateTime now,
  }) {
    final ascending = [...pitTimes]..sort();
    var best = Duration.zero;
    var previous = startedAt;
    for (final pit in ascending) {
      final gap = pit.difference(previous);
      if (gap > best) best = gap;
      previous = pit;
    }
    final current = now.difference(previous);
    if (current > best) best = current;
    return CleanRun(current: current, best: best);
  }
}
