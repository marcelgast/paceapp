/// Where the user stands relative to their optional quit-smoking date.
enum QuitPhase {
  /// No date set — the open-ended "stretch the stint" mode.
  none,

  /// A date is set and still in the future — counting down to it.
  countdown,

  /// On or after the quit day — the smoke-free companion mode.
  smokeFree,
}

/// Pure view of the quit plan: derives the phase and the day counters from the
/// quit date and the current time, on calendar-day granularity. The quit day
/// itself is smoke-free day 1.
class QuitPlan {
  const QuitPlan({
    required this.phase,
    required this.daysUntil,
    required this.dayNumber,
    this.elapsed = Duration.zero,
    this.quitDate,
  });

  final QuitPhase phase;

  /// Countdown: whole days remaining until the quit day (≥ 1). Otherwise 0.
  final int daysUntil;

  /// Smoke-free: 1-based day count (quit day = 1). Otherwise 0.
  final int dayNumber;

  /// Smoke-free: live time since the quit day began (midnight). Otherwise zero.
  final Duration elapsed;

  final DateTime? quitDate;

  /// The hours/minutes/seconds within the current day (0 ≤ h < 24), for the
  /// live ticker shown under the day count.
  Duration get intraDay => elapsed - Duration(days: elapsed.inDays);

  bool get isActive => phase != QuitPhase.none;
  bool get isSmokeFree => phase == QuitPhase.smokeFree;
  bool get isCountdown => phase == QuitPhase.countdown;

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  factory QuitPlan.from({required DateTime? quitDate, required DateTime now}) {
    if (quitDate == null) {
      return const QuitPlan(phase: QuitPhase.none, daysUntil: 0, dayNumber: 0);
    }
    final diff = _day(quitDate).difference(_day(now)).inDays;
    if (diff > 0) {
      return QuitPlan(
        phase: QuitPhase.countdown,
        daysUntil: diff,
        dayNumber: 0,
        quitDate: quitDate,
      );
    }
    return QuitPlan(
      phase: QuitPhase.smokeFree,
      daysUntil: 0,
      dayNumber: -diff + 1,
      elapsed: now.difference(_day(quitDate)),
      quitDate: quitDate,
    );
  }
}
