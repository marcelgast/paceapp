/// Pure aggregate stats — money & cigarettes saved versus the baseline rate.
///
/// "Saved" is measured against what the user *would* have smoked at their
/// onboarding baseline rate. Every second that passes without a pit stop
/// nudges expected consumption up, so the savings tick upward in real time —
/// the engine behind "celebrate from second one".
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

  factory PaceStats.compute({
    required Duration sinceStart,
    required int packPriceCents,
    required int cigarettesPerPack,
    required double dailyRate,
    required int actualCigarettes,
  }) {
    final perCig = centsPerCigarette(
      packPriceCents: packPriceCents,
      cigarettesPerPack: cigarettesPerPack,
    );
    final days = sinceStart.inSeconds / Duration.secondsPerDay;
    final expected = dailyRate * days;
    final saved = (expected - actualCigarettes).clamp(0.0, double.infinity);
    return PaceStats(
      costPerCigaretteCents: perCig,
      expectedCigarettes: expected,
      actualCigarettes: actualCigarettes,
      savedCigarettes: saved,
      savedMoneyCents: (saved * perCig).round(),
      sinceStart: sinceStart,
    );
  }
}
