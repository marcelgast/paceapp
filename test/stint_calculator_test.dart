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

  group('PaceStats (overtime laps)', () {
    PaceStats forStints(
      List<({int awakeSeconds, int targetSeconds, int perCig})> stints, {
      int actual = 0,
      int perCig = 40,
    }) =>
        PaceStats.compute(
          sinceStart: const Duration(hours: 1),
          actualCigarettes: actual,
          currentPerCig: perCig,
          stints: stints,
        );

    test('no target earns nothing', () {
      final s = forStints(
          const [(awakeSeconds: 5 * 3600, targetSeconds: 0, perCig: 40)]);
      expect(s.savedCigarettes, 0);
      expect(s.savedMoneyCents, 0);
    });

    test('one full lap of overtime is one avoided cigarette', () {
      // target 1 h, stint 2 h awake → 1 h overtime → 1 lap.
      final s = forStints(const [
        (awakeSeconds: 2 * 3600, targetSeconds: 3600, perCig: 40),
      ]);
      expect(s.savedCigarettes, 1);
      expect(s.savedMoneyCents, 40);
    });

    test('partial overtime does not count until it is full', () {
      // target 1 h, stint 1 h 40 → 40 min overtime → 0 laps.
      final s = forStints(const [
        (awakeSeconds: 100 * 60, targetSeconds: 3600, perCig: 40),
      ]);
      expect(s.savedCigarettes, 0);
      expect(s.savedMoneyCents, 0);
    });

    test('laps accumulate across stints, each priced for its stint', () {
      final s = forStints(
        const [
          // 3 h stint, target 1 h → 2 h overtime → 2 laps × 40
          (awakeSeconds: 3 * 3600, targetSeconds: 3600, perCig: 40),
          // 2 h stint, target 1 h → 1 h overtime → 1 lap × 60
          (awakeSeconds: 2 * 3600, targetSeconds: 3600, perCig: 60),
        ],
        actual: 2,
      );
      expect(s.savedCigarettes, 3);
      expect(s.savedMoneyCents, 2 * 40 + 1 * 60);
    });
  });
}
