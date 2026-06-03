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
  /// ascending. [costPeriods] are the cost epochs as (start-since-start, cents
  /// per cigarette), sorted ascending, the first starting at zero — so a price
  /// change is honoured from its moment forward and never re-prices the past.
  factory PaceStats.compute({
    required Duration sinceStart,
    required double dailyRate,
    required List<Duration> pitElapsed,
    required List<({Duration start, int perCig})> costPeriods,
  }) {
    final currentPerCig =
        costPeriods.isEmpty ? 0 : costPeriods.last.perCig;

    double expectedCigsAt(Duration t) =>
        dailyRate * (t.inSeconds / Duration.secondsPerDay);

    int perCigAt(Duration e) {
      var pc = costPeriods.isEmpty ? 0 : costPeriods.first.perCig;
      for (final p in costPeriods) {
        if (p.start <= e) {
          pc = p.perCig;
        } else {
          break;
        }
      }
      return pc;
    }

    // Expected money spent at baseline up to [t], each period priced its own way.
    double expectedMoneyAt(Duration t) {
      var sum = 0.0;
      for (var i = 0; i < costPeriods.length; i++) {
        final start = costPeriods[i].start;
        final end =
            i + 1 < costPeriods.length ? costPeriods[i + 1].start : t;
        final hi = end < t ? end : t;
        if (hi > start) {
          final days = (hi - start).inSeconds / Duration.secondsPerDay;
          sum += dailyRate * costPeriods[i].perCig * days;
        }
      }
      return sum;
    }

    final n = pitElapsed.length;

    // High-water mark of (expected − actual): the live value now plus the peak
    // just before each pit (actual still the prior count). Logging a cigarette
    // captures the pre-smoke peak, so neither figure ever decreases.
    var cigPeak = expectedCigsAt(sinceStart) - n;
    var moneyActual = 0.0;
    var moneyPeak = double.negativeInfinity;
    for (var k = 0; k < n; k++) {
      final c = expectedCigsAt(pitElapsed[k]) - k;
      if (c > cigPeak) cigPeak = c;
      final m = expectedMoneyAt(pitElapsed[k]) - moneyActual;
      if (m > moneyPeak) moneyPeak = m;
      moneyActual += perCigAt(pitElapsed[k]);
    }
    final moneyNow = expectedMoneyAt(sinceStart) - moneyActual;
    if (moneyNow > moneyPeak) moneyPeak = moneyNow;

    final savedCigs = cigPeak.clamp(0.0, double.infinity);
    final savedMoney = moneyPeak.clamp(0.0, double.infinity);

    return PaceStats(
      costPerCigaretteCents: currentPerCig,
      expectedCigarettes: expectedCigsAt(sinceStart),
      actualCigarettes: n,
      savedCigarettes: savedCigs,
      savedMoneyCents: savedMoney.round(),
      sinceStart: sinceStart,
    );
  }
}
