import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/savings_calculator.dart';
import 'package:pace/domain/sleep_window.dart';

void main() {
  // No sleep window → awake time equals wall-clock, so the numbers stay simple.
  const noSleep = SleepWindow(startMinutes: 0, endMinutes: 0);
  final t0 = DateTime(2026, 1, 1, 8, 0, 0);

  // Pack of 20 at 8.00 → 40 cents per cigarette.
  const packCents = 800;
  const perPack = 20;
  const perCig = 40;

  group('pre-quit stint savings', () {
    test('banks one avoided cigarette per full target survived in overtime', () {
      final stats = SavingsCalculator.compute(
        startedAt: t0,
        now: t0.add(const Duration(hours: 5)),
        packPriceCents: packCents,
        cigarettesPerPack: perPack,
        currentTargetSeconds: 3600, // 1h target
        baselineCigsPerDay: 20,
        quitDate: null,
        sleep: noSleep,
        pits: const [],
        costEpochs: const [],
      );

      // 5h awake, 1h target → 4h overtime → 4 full laps.
      expect(stats.savedCigarettes, 4.0);
      expect(stats.savedMoneyCents, 4 * perCig);
      expect(stats.actualCigarettes, 0);
      expect(stats.expectedCigarettes, 4);
      expect(stats.costPerCigaretteCents, perCig);
    });

    test('measuring phase (no target) earns nothing', () {
      final stats = SavingsCalculator.compute(
        startedAt: t0,
        now: t0.add(const Duration(hours: 5)),
        packPriceCents: packCents,
        cigarettesPerPack: perPack,
        currentTargetSeconds: null, // still measuring
        baselineCigsPerDay: 20,
        quitDate: null,
        sleep: noSleep,
        pits: const [],
        costEpochs: const [],
      );

      expect(stats.savedCigarettes, 0.0);
      expect(stats.savedMoneyCents, 0);
    });

    test('a price epoch applies from its effective date forward', () {
      final stats = SavingsCalculator.compute(
        startedAt: t0,
        now: t0.add(const Duration(hours: 5)),
        packPriceCents: packCents,
        cigarettesPerPack: perPack,
        currentTargetSeconds: 3600,
        baselineCigsPerDay: 20,
        quitDate: null,
        sleep: noSleep,
        pits: const [],
        costEpochs: [
          // Price rises to 10.00/pack (50 cents/cig) three hours in.
          CostEpoch(
            effectiveFrom: t0.add(const Duration(hours: 3)),
            packPriceCents: 1000,
            cigarettesPerPack: perPack,
          ),
        ],
      );

      // The ongoing stint ends at `now`, after the epoch → priced at 50 cents.
      expect(stats.savedCigarettes, 4.0);
      expect(stats.savedMoneyCents, 4 * 50);
      expect(stats.costPerCigaretteCents, 50);
    });

    test('a quit date still in the future does not trigger baseline accrual',
        () {
      final stats = SavingsCalculator.compute(
        startedAt: t0,
        now: t0.add(const Duration(hours: 5)),
        packPriceCents: packCents,
        cigarettesPerPack: perPack,
        currentTargetSeconds: 3600,
        baselineCigsPerDay: 20,
        quitDate: t0.add(const Duration(hours: 6)), // not reached yet
        sleep: noSleep,
        pits: const [],
        costEpochs: const [],
      );

      // Identical to the no-quit case — savings come only from laps.
      expect(stats.savedCigarettes, 4.0);
      expect(stats.savedMoneyCents, 4 * perCig);
    });
  });

  group('post-quit baseline accrual', () {
    test('freezes the banked laps and adds the full daily baseline per day', () {
      final quit = t0.add(const Duration(hours: 2));
      final stats = SavingsCalculator.compute(
        startedAt: t0,
        now: quit.add(const Duration(days: 1)),
        packPriceCents: packCents,
        cigarettesPerPack: perPack,
        currentTargetSeconds: 3600,
        baselineCigsPerDay: 20,
        quitDate: quit,
        sleep: noSleep,
        pits: const [],
        costEpochs: const [],
      );

      // Frozen lap: 2h awake, 1h target → 1 lap banked at the stop (40 cents).
      // Baseline: exactly one day smoke-free → 20 cigarettes avoided (800 cents).
      expect(stats.savedCigarettes, 1.0 + 20.0);
      expect(stats.savedMoneyCents, perCig + 20 * perCig);
      expect(stats.actualCigarettes, 0);
    });

    test('grows continuously between whole days (no chunky lap jumps)', () {
      final quit = t0.add(const Duration(hours: 2));
      final half = SavingsCalculator.compute(
        startedAt: t0,
        now: quit.add(const Duration(hours: 12)),
        packPriceCents: packCents,
        cigarettesPerPack: perPack,
        currentTargetSeconds: 3600,
        baselineCigsPerDay: 20,
        quitDate: quit,
        sleep: noSleep,
        pits: const [],
        costEpochs: const [],
      );

      // Half a day → 10 cigarettes of baseline on top of the 1 frozen lap.
      expect(half.savedCigarettes, 1.0 + 10.0);
      expect(half.savedMoneyCents, perCig + 10 * perCig);
    });

    test('a slip after the quit moment reduces the avoided count', () {
      final quit = t0.add(const Duration(hours: 2));
      final stats = SavingsCalculator.compute(
        startedAt: t0,
        now: quit.add(const Duration(days: 1)),
        packPriceCents: packCents,
        cigarettesPerPack: perPack,
        currentTargetSeconds: 3600,
        baselineCigsPerDay: 20,
        quitDate: quit,
        sleep: noSleep,
        pits: [
          SavingsPit(
            occurredAt: quit.add(const Duration(hours: 12)),
            targetIntervalSeconds: 3600,
          ),
        ],
        costEpochs: const [],
      );

      // One slip → baseline avoided drops from 20 to 19; the slip counts as an
      // actual cigarette but the frozen lap is unaffected.
      expect(stats.savedCigarettes, 1.0 + 19.0);
      expect(stats.savedMoneyCents, perCig + 19 * perCig);
      expect(stats.actualCigarettes, 1);
    });

    test('never reports negative savings when slips exceed the baseline', () {
      final quit = t0.add(const Duration(hours: 2));
      final stats = SavingsCalculator.compute(
        startedAt: t0,
        now: quit.add(const Duration(hours: 1)),
        packPriceCents: packCents,
        cigarettesPerPack: perPack,
        currentTargetSeconds: 3600,
        baselineCigsPerDay: 20,
        quitDate: quit,
        sleep: noSleep,
        // Five slips in the first hour after quitting — far above the ~0.8 the
        // baseline would have avoided in that hour.
        pits: [
          for (var i = 0; i < 5; i++)
            SavingsPit(
              occurredAt: quit.add(Duration(minutes: 5 * (i + 1))),
              targetIntervalSeconds: 3600,
            ),
        ],
        costEpochs: const [],
      );

      // Baseline bonus floors at zero; only the frozen pre-quit lap remains.
      expect(stats.savedCigarettes, 1.0);
      expect(stats.savedMoneyCents, perCig);
    });
  });
}
