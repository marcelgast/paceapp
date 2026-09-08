/// Aggregate stats — cigarettes avoided and money saved. Pure & testable.
///
/// "Avoided" is driven by the stint mechanic: once a stint runs past its target,
/// every *full* extra target-length in overtime is one cigarette you skipped
/// (`overtime ÷ target`). Those banked laps are summed across every stint, so
/// the figure only grows — logging a cigarette ends the current stint but keeps
/// the laps it already earned. "Saved" prices each avoided cigarette at the
/// cost in effect for that stint.
class PaceStats {
  const PaceStats({
    required this.costPerCigaretteCents,
    required this.expectedCigarettes,
    required this.actualCigarettes,
    required this.savedCigarettes,
    required this.savedMoneyCents,
    required this.sinceStart,
  });

  final int costPerCigaretteCents;
  final double expectedCigarettes;
  final int actualCigarettes;
  final double savedCigarettes;
  final int savedMoneyCents;
  final Duration sinceStart;

  static int centsPerCigarette({
    required int packPriceCents,
    required int cigarettesPerPack,
  }) {
    if (cigarettesPerPack <= 0) return 0;
    return (packPriceCents / cigarettesPerPack).round();
  }

  /// [stints] are every stint (completed and ongoing), each with its awake
  /// length, the target that was active, and the price per cigarette then. A
  /// stint with no target (the measuring phase) earns nothing.
  ///
  /// [bonusCigarettes] / [bonusMoneyCents] are added on top of the lap totals —
  /// used after the quit moment, where you avoid your whole baseline consumption
  /// (not just banked laps), so the counters keep climbing at your real rate.
  factory PaceStats.compute({
    required Duration sinceStart,
    required int actualCigarettes,
    required int currentPerCig,
    required List<({int awakeSeconds, int targetSeconds, int perCig})> stints,
    double bonusCigarettes = 0,
    int bonusMoneyCents = 0,
  }) {
    var laps = 0;
    var moneyCents = 0;
    for (final s in stints) {
      if (s.targetSeconds <= 0) continue;
      final overtime = s.awakeSeconds - s.targetSeconds;
      if (overtime <= 0) continue;
      final stintLaps = overtime ~/ s.targetSeconds;
      laps += stintLaps;
      moneyCents += stintLaps * s.perCig;
    }
    final avoided = laps + bonusCigarettes;
    return PaceStats(
      costPerCigaretteCents: currentPerCig,
      expectedCigarettes: actualCigarettes + avoided,
      actualCigarettes: actualCigarettes,
      savedCigarettes: avoided,
      savedMoneyCents: moneyCents + bonusMoneyCents,
      sinceStart: sinceStart,
    );
  }
}
