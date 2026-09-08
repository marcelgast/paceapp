import 'sleep_window.dart';

/// The clean-run clock derived from pit-stop times. Pure — fully testable.
///
/// A cigarette (pit stop) resets the [current] run; [best] is the longest clean
/// stretch ever. Time milestones unlock on [best] (a record you keep). When a
/// [SleepWindow] is given, gaps count only awake time — sleep doesn't run the
/// clock, so a long overnight gap can't become your best time.
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
    SleepWindow? sleep,
  }) {
    Duration span(DateTime from, DateTime to) =>
        sleep == null ? to.difference(from) : sleep.awakeBetween(from, to);
    final ascending = [...pitTimes]..sort();
    var best = Duration.zero;
    var previous = startedAt;
    for (final pit in ascending) {
      final gap = span(previous, pit);
      if (gap > best) best = gap;
      previous = pit;
    }
    final current = span(previous, now);
    if (current > best) best = current;
    return CleanRun(current: current, best: best);
  }
}
