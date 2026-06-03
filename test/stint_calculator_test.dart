import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/pace_stats.dart';
import 'package:pace/domain/stint_calculator.dart';

void main() {
  group('targetInterval', () {
    test('grows 10% per week from the base', () {
      const base = Duration(minutes: 60);
      expect(
        StintCalculator.targetInterval(baseInterval: base, weeksSinceStart: 0),
        base,
      );
      expect(
        StintCalculator.targetInterval(baseInterval: base, weeksSinceStart: 1),
        const Duration(minutes: 66),
      );
      // 60 * 1.1^2 = 72.6 min = 4356 s
      expect(
        StintCalculator.targetInterval(baseInterval: base, weeksSinceStart: 2)
            .inSeconds,
        4356,
      );
    });

    test('respects the cap', () {
      final result = StintCalculator.targetInterval(
        baseInterval: const Duration(hours: 1),
        weeksSinceStart: 52,
        cap: const Duration(hours: 4),
      );
      expect(result, const Duration(hours: 4));
    });

    test('negative weeks clamp to base', () {
      expect(
        StintCalculator.targetInterval(
            baseInterval: const Duration(minutes: 30), weeksSinceStart: -3),
        const Duration(minutes: 30),
      );
    });
  });

  group('intervalFromDailyRate', () {
    test('spreads cigarettes across waking hours', () {
      // 16 cigarettes over 16 awake hours → one per hour.
      expect(
        StintCalculator.intervalFromDailyRate(16),
        const Duration(hours: 1),
      );
    });

    test('falls back to one hour for zero/negative', () {
      expect(StintCalculator.intervalFromDailyRate(0), const Duration(hours: 1));
    });
  });

  group('evaluate', () {
    const target = Duration(minutes: 60);

    test('baseline ignores the target', () {
      final s = StintCalculator.evaluate(
        target: target,
        sinceLastPit: const Duration(minutes: 90),
        inBaseline: true,
      );
      expect(s.phase, StintPhase.baseline);
      expect(s.progress, 0);
    });

    test('counts down inside the target', () {
      final s = StintCalculator.evaluate(
        target: target,
        sinceLastPit: const Duration(minutes: 15),
        inBaseline: false,
      );
      expect(s.phase, StintPhase.countdown);
      expect(s.remaining, const Duration(minutes: 45));
      expect(s.progress, closeTo(0.25, 0.0001));
    });

    test('flips to overtime past the target', () {
      final s = StintCalculator.evaluate(
        target: target,
        sinceLastPit: const Duration(minutes: 75),
        inBaseline: false,
      );
      expect(s.phase, StintPhase.overtime);
      expect(s.overtime, const Duration(minutes: 15));
      expect(s.progress, 1.0);
    });
  });

  group('PaceStats', () {
    PaceStats statsFor(List<Duration> pits) => PaceStats.compute(
          sinceStart: const Duration(days: 1),
          packPriceCents: 800,
          cigarettesPerPack: 20,
          dailyRate: 20,
          pitElapsed: pits,
        );

    test('savings accrue against the baseline rate', () {
      // 20/day baseline, 1 day elapsed, smoked 12 early → saved 8 cigarettes.
      final stats = statsFor(List.filled(12, Duration.zero));
      expect(stats.costPerCigaretteCents, 40);
      expect(stats.savedCigarettes, closeTo(8, 0.0001));
      expect(stats.savedMoneyCents, 320);
    });

    test('never goes negative when over baseline', () {
      final stats = statsFor(List.filled(40, Duration.zero));
      expect(stats.savedCigarettes, 0);
      expect(stats.savedMoneyCents, 0);
    });

    test('saved never drops when another cigarette is logged', () {
      // Built up a lead, then smoke one more right now.
      final before = statsFor(List.filled(5, Duration.zero));
      final after = statsFor([
        ...List.filled(5, Duration.zero),
        const Duration(days: 1),
      ]);
      expect(after.savedCigarettes,
          greaterThanOrEqualTo(before.savedCigarettes));
      expect(after.savedMoneyCents,
          greaterThanOrEqualTo(before.savedMoneyCents));
    });
  });
}
