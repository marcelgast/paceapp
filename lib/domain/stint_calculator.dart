import 'dart:math' as math;

/// Pure stint logic. No clock, no I/O — every input maps to one output, so
/// it is fully unit-testable.
///
/// A "stint" is the stretch of time between two cigarettes (pit stops). The
/// target stint grows [weeklyGrowth] each week. While you are inside the
/// target you are counting *down*; once you pass it you are in *overtime* —
/// pure winnings.
enum StintPhase { baseline, countdown, overtime }

class StintState {
  const StintState({
    required this.phase,
    required this.target,
    required this.elapsed,
    required this.remaining,
    required this.overtime,
    required this.progress,
  });

  final StintPhase phase;

  /// Current target stint length. [Duration.zero] during baseline.
  final Duration target;

  /// Time since the last pit stop.
  final Duration elapsed;

  /// Countdown remaining toward the target (zero in overtime/baseline).
  final Duration remaining;

  /// Time gained beyond the target (zero unless in overtime).
  final Duration overtime;

  /// 0..1 fill toward the target; pinned to 1 in overtime.
  final double progress;

  bool get isOvertime => phase == StintPhase.overtime;
  bool get isBaseline => phase == StintPhase.baseline;
}

abstract final class StintCalculator {
  static const double defaultWeeklyGrowth = 0.10;

  /// Length of the baseline phase before the timer mechanic switches on.
  static const Duration baselineDuration = Duration(days: 7);

  /// Target stint after [weeksSinceStart] weeks of growth.
  ///
  /// `target = baseInterval * (1 + growth)^weeks`, optionally capped.
  static Duration targetInterval({
    required Duration baseInterval,
    required int weeksSinceStart,
    double weeklyGrowth = defaultWeeklyGrowth,
    Duration? cap,
  }) {
    final weeks = math.max(0, weeksSinceStart);
    final factor = math.pow(1 + weeklyGrowth, weeks).toDouble();
    final seconds = (baseInterval.inSeconds * factor).round();
    final result = Duration(seconds: seconds);
    if (cap != null && result > cap) return cap;
    return result;
  }

  /// Average gap between cigarettes implied by a daily consumption rate,
  /// spread over waking hours ([awakeHoursPerDay], default 16h — nobody
  /// smokes in their sleep).
  static Duration intervalFromDailyRate(
    double cigarettesPerDay, {
    double awakeHoursPerDay = 16,
  }) {
    if (cigarettesPerDay <= 0) return const Duration(hours: 1);
    final seconds = (awakeHoursPerDay * 3600) / cigarettesPerDay;
    return Duration(seconds: seconds.round());
  }

  /// Evaluate the live stint given the active [target] and time [sinceLastPit].
  static StintState evaluate({
    required Duration target,
    required Duration sinceLastPit,
    required bool inBaseline,
  }) {
    if (inBaseline || target <= Duration.zero) {
      return StintState(
        phase: StintPhase.baseline,
        target: Duration.zero,
        elapsed: sinceLastPit,
        remaining: Duration.zero,
        overtime: Duration.zero,
        progress: 0,
      );
    }

    if (sinceLastPit < target) {
      final remaining = target - sinceLastPit;
      return StintState(
        phase: StintPhase.countdown,
        target: target,
        elapsed: sinceLastPit,
        remaining: remaining,
        overtime: Duration.zero,
        progress: (sinceLastPit.inMilliseconds / target.inMilliseconds)
            .clamp(0.0, 1.0),
      );
    }

    return StintState(
      phase: StintPhase.overtime,
      target: target,
      elapsed: sinceLastPit,
      remaining: Duration.zero,
      overtime: sinceLastPit - target,
      progress: 1.0,
    );
  }
}
