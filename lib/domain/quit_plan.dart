/// Where the user stands relative to their optional quit-smoking date.
enum QuitPhase {
  /// No date set — the open-ended "stretch the stint" mode.
  none,

  /// A date is set and still in the future — counting down to it.
  countdown,

  /// On or after the quit moment — the smoke-free companion mode.
  smokeFree,
}

/// Pure view of the quit plan: derives the phase and counters from the exact
/// quit moment and the current time. Smoke-free time is anchored to the quit
/// moment — or to the most recent slip-up after it, so a relapse resets the
/// timer.
class QuitPlan {
  const QuitPlan({
    required this.phase,
    required this.daysUntil,
    required this.dayNumber,
    this.elapsed = Duration.zero,
    this.quitDate,
    this.smokeFreeStart,
  });

  final QuitPhase phase;

  /// Countdown: whole calendar days until the quit day (0 = today). Otherwise 0.
  final int daysUntil;

  /// Smoke-free: 1-based day count (first 24 h = day 1). Otherwise 0.
  final int dayNumber;

  /// Smoke-free: live time since [smokeFreeStart]. Otherwise zero.
  final Duration elapsed;

  final DateTime? quitDate;

  /// Smoke-free: the moment the current smoke-free run started — the quit moment
  /// or the last relapse, whichever is later.
  final DateTime? smokeFreeStart;

  /// The hours/minutes/seconds within the current 24 h cycle (0 ≤ h < 24), for
  /// the live ticker under the day count.
  Duration get intraDay => elapsed - Duration(days: elapsed.inDays);

  bool get isActive => phase != QuitPhase.none;
  bool get isSmokeFree => phase == QuitPhase.smokeFree;
  bool get isCountdown => phase == QuitPhase.countdown;

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  factory QuitPlan.from({
    required DateTime? quitDate,
    required DateTime now,
    DateTime? lastPitStop,
  }) {
    if (quitDate == null) {
      return const QuitPlan(phase: QuitPhase.none, daysUntil: 0, dayNumber: 0);
    }
    if (now.isBefore(quitDate)) {
      return QuitPlan(
        phase: QuitPhase.countdown,
        daysUntil: _day(quitDate).difference(_day(now)).inDays,
        dayNumber: 0,
        quitDate: quitDate,
      );
    }
    // Smoke-free. A cigarette logged at/after the quit moment is a relapse and
    // resets the run.
    var start = quitDate;
    if (lastPitStop != null && !lastPitStop.isBefore(quitDate)) {
      start = lastPitStop;
    }
    final elapsed = now.difference(start);
    return QuitPlan(
      phase: QuitPhase.smokeFree,
      daysUntil: 0,
      dayNumber: elapsed.inDays + 1,
      elapsed: elapsed,
      quitDate: quitDate,
      smokeFreeStart: start,
    );
  }
}
