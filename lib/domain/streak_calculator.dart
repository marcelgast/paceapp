/// Streak logic — consecutive "win days" where the user smoked fewer cigarettes
/// than their baseline daily rate. A fully clean day (0) always counts.
library;

class StreakResult {
  const StreakResult({required this.current, required this.longest});

  final int current;
  final int longest;
}

abstract final class StreakCalculator {
  static StreakResult compute({
    required List<DateTime> pitTimes,
    required double dailyThreshold,
    required DateTime startedAt,
    required DateTime now,
  }) {
    if (dailyThreshold <= 0) {
      return const StreakResult(current: 0, longest: 0);
    }

    final perDay = <DateTime, int>{};
    for (final t in pitTimes) {
      final d = DateTime(t.year, t.month, t.day);
      perDay[d] = (perDay[d] ?? 0) + 1;
    }

    final startDay = DateTime(startedAt.year, startedAt.month, startedAt.day);
    final today = DateTime(now.year, now.month, now.day);
    bool isWin(DateTime d) => (perDay[d] ?? 0) < dailyThreshold;

    var longest = 0;
    var run = 0;
    for (
      var d = startDay;
      !d.isAfter(today);
      d = d.add(const Duration(days: 1))
    ) {
      if (isWin(d)) {
        run++;
        if (run > longest) longest = run;
      } else {
        run = 0;
      }
    }

    var current = 0;
    for (
      var d = today;
      !d.isBefore(startDay);
      d = d.subtract(const Duration(days: 1))
    ) {
      if (isWin(d)) {
        current++;
      } else {
        break;
      }
    }

    return StreakResult(current: current, longest: longest);
  }
}
