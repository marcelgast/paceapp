/// Pure aggregate stats — money & cigarettes saved versus the baseline rate.
///
/// "Saved" is measured against what the user *would* have smoked at their
/// onboarding baseline rate. Every second that passes without a pit stop nudges
/// expected consumption up, so the savings tick upward in real time — the
/// engine behind "celebrate from second one".
///
/// Crucially it never drops when a cigarette is logged: a cigarette you already
/// avoided stays avoided. We report the running *high-water mark* of
/// (expected − actual) — the peak just before each pit plus the live value now
/// — so logging a pit can pause the growth but never erase earned progress.
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

  /// [pitElapsed] are the pit-stop times as durations since the start, sorted
  /// ascending — needed to find the pre-smoke peaks of the savings curve.
  factory PaceStats.compute({
    required Duration sinceStart,
    required int packPriceCents,
    required int cigarettesPerPack,
    required double dailyRate,
    required List<Duration> pitElapsed,
  }) {
    final perCig = centsPerCigarette(
      packPriceCents: packPriceCents,
      cigarettesPerPack: cigarettesPerPack,
    );
    double expectedAt(Duration d) =>
        dailyRate * (d.inSeconds / Duration.secondsPerDay);

    final n = pitElapsed.length;
    // High-water mark of (expected − actual): the live value now, plus the peak
    // just before each pit (where actual is still the prior count). Logging a
    // cigarette captures the pre-smoke peak, so the figure never decreases.
    var savedPeak = expectedAt(sinceStart) - n;
    for (var k = 0; k < n; k++) {
      final peak = expectedAt(pitElapsed[k]) - k;
      if (peak > savedPeak) savedPeak = peak;
    }
    final saved = savedPeak.clamp(0.0, double.infinity);

    return PaceStats(
      costPerCigaretteCents: perCig,
      expectedCigarettes: expectedAt(sinceStart),
      actualCigarettes: n,
      savedCigarettes: saved,
      savedMoneyCents: (saved * perCig).round(),
      sinceStart: sinceStart,
    );
  }
}
