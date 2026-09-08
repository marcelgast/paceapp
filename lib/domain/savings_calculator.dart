import 'pace_stats.dart';
import 'sleep_window.dart';

/// One cigarette event, reduced to what the savings computation needs.
class SavingsPit {
  const SavingsPit({
    required this.occurredAt,
    required this.targetIntervalSeconds,
  });

  final DateTime occurredAt;

  /// The target stint (seconds) that was active when this cigarette was logged,
  /// or null if it happened during the open-ended measuring phase.
  final int? targetIntervalSeconds;
}

/// A price/pack-size epoch. Its values apply from [effectiveFrom] forward, so a
/// price change never re-prices cigarettes that came before it.
class CostEpoch {
  const CostEpoch({
    required this.effectiveFrom,
    required this.packPriceCents,
    required this.cigarettesPerPack,
  });

  final DateTime effectiveFrom;
  final int packPriceCents;
  final int cigarettesPerPack;
}

/// Turns the raw pit-stop history, pricing epochs and an optional quit moment
/// into a [PaceStats]. Pure: identical inputs always yield an identical result.
///
/// Two regimes drive "cigarettes avoided":
///
/// * **Before the quit moment** the stint mechanic earns the savings — every
///   full target-length survived in overtime banks one avoided cigarette,
///   priced at the cost in effect for that stint (see [PaceStats.compute]).
/// * **After the quit moment** the lap mechanic freezes at the value banked at
///   the stop, and savings then accrue continuously at the full baseline rate
///   (whole daily consumption avoided, minus any slip-ups). This keeps the
///   counters climbing smoothly instead of jumping in chunky target-sized laps.
abstract final class SavingsCalculator {
  static PaceStats compute({
    required DateTime startedAt,
    required DateTime now,
    required int packPriceCents,
    required int cigarettesPerPack,
    required int? currentTargetSeconds,
    required double baselineCigsPerDay,
    required DateTime? quitDate,
    required SleepWindow sleep,
    required List<SavingsPit> pits,
    required List<CostEpoch> costEpochs,
  }) {
    final defaultPerCig = PaceStats.centsPerCigarette(
      packPriceCents: packPriceCents,
      cigarettesPerPack: cigarettesPerPack,
    );
    final epochs = [...costEpochs]
      ..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));

    // Cents per cigarette in effect at [t] — the latest epoch that has started.
    int perCigAt(DateTime t) {
      var perCig = defaultPerCig;
      for (final epoch in epochs) {
        if (epoch.effectiveFrom.isAfter(t)) break;
        perCig = PaceStats.centsPerCigarette(
          packPriceCents: epoch.packPriceCents,
          cigarettesPerPack: epoch.cigarettesPerPack,
        );
      }
      return perCig;
    }

    // After the quit moment the stint/lap mechanic stops: the ongoing stint is
    // frozen at the quit moment (its last banked value) and the baseline bonus
    // below takes over.
    final quitMoment = quitDate;
    final smokeFree = quitMoment != null && now.isAfter(quitMoment);
    final stintEnd = smokeFree ? quitMoment : now;

    // One stint per gap between cigarettes, plus the ongoing one. Each carries
    // the target that was active and the price then; sleep is excluded from the
    // awake length.
    final ascending = [...pits]
      ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final stints = <({int awakeSeconds, int targetSeconds, int perCig})>[];
    var previous = startedAt;
    for (final pit in ascending) {
      if (pit.occurredAt.isAfter(stintEnd)) break; // post-quit slips: baseline
      stints.add((
        awakeSeconds: sleep.awakeBetween(previous, pit.occurredAt).inSeconds,
        targetSeconds: pit.targetIntervalSeconds ?? 0,
        perCig: perCigAt(pit.occurredAt),
      ));
      previous = pit.occurredAt;
    }
    stints.add((
      awakeSeconds: sleep.awakeBetween(previous, stintEnd).inSeconds,
      targetSeconds: currentTargetSeconds ?? 0,
      perCig: perCigAt(stintEnd),
    ));

    // Post-quit baseline accrual: you avoid your whole daily consumption (minus
    // any slip-ups), so the counters keep climbing from the value banked at the
    // stop.
    var bonusCigarettes = 0.0;
    var bonusMoneyCents = 0;
    if (smokeFree) {
      final daysSinceQuit = now.difference(quitMoment).inSeconds / 86400.0;
      final slipsAfterQuit =
          pits.where((p) => p.occurredAt.isAfter(quitMoment)).length;
      final avoided = baselineCigsPerDay * daysSinceQuit - slipsAfterQuit;
      bonusCigarettes = avoided < 0 ? 0 : avoided;
      bonusMoneyCents = (bonusCigarettes * perCigAt(now)).round();
    }

    return PaceStats.compute(
      sinceStart: now.difference(startedAt),
      actualCigarettes: pits.length,
      currentPerCig: perCigAt(now),
      stints: stints,
      bonusCigarettes: bonusCigarettes,
      bonusMoneyCents: bonusMoneyCents,
    );
  }
}
