/// A nightly sleep window, stored as minutes from midnight. Used to take sleep
/// out of stint/best-time measurement: a cigarette still counts as a pit stop,
/// but the timer doesn't run while you're asleep. Pure — fully testable.
class SleepWindow {
  const SleepWindow({required this.startMinutes, required this.endMinutes});

  /// Minutes since midnight. The window wraps past midnight when
  /// [startMinutes] > [endMinutes] (e.g. 23:00 → 07:00).
  final int startMinutes;
  final int endMinutes;

  static const SleepWindow defaultWindow = SleepWindow(
    startMinutes: 23 * 60,
    endMinutes: 7 * 60,
  );

  /// Sleep length in minutes, wrap-aware. 0 means "no sleep window".
  int get durationMinutes => (endMinutes - startMinutes) % (24 * 60);

  /// Awake time between [start] and [end]: wall-clock minus the overlap with
  /// every night's sleep window in that span.
  Duration awakeBetween(DateTime start, DateTime end) {
    if (!end.isAfter(start)) return Duration.zero;
    final sleepMinutes = durationMinutes;
    final total = end.difference(start);
    if (sleepMinutes == 0) return total;

    var asleepSeconds = 0;
    // A night can start the day before [start], so begin one day early.
    var day = DateTime(
      start.year,
      start.month,
      start.day,
    ).subtract(const Duration(days: 1));
    final lastDay = DateTime(end.year, end.month, end.day);
    while (!day.isAfter(lastDay)) {
      final nightStart = day.add(Duration(minutes: startMinutes));
      final nightEnd = nightStart.add(Duration(minutes: sleepMinutes));
      final overlapStart = nightStart.isAfter(start) ? nightStart : start;
      final overlapEnd = nightEnd.isBefore(end) ? nightEnd : end;
      if (overlapEnd.isAfter(overlapStart)) {
        asleepSeconds += overlapEnd.difference(overlapStart).inSeconds;
      }
      day = day.add(const Duration(days: 1));
    }
    final awake = total.inSeconds - asleepSeconds;
    return Duration(seconds: awake < 0 ? 0 : awake);
  }
}
