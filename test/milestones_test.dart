import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/milestones.dart';

void main() {
  group('MilestoneEvaluator.achieved', () {
    test('time milestones unlock by the best clean stretch', () {
      final keys = MilestoneEvaluator.achieved(
        bestClean: const Duration(minutes: 25),
        savedCents: 0,
        avoided: 0,
      ).map((m) => m.key);
      expect(keys, containsAll(['time_1m', 'time_20m']));
      expect(keys, isNot(contains('time_8h')));
    });

    test('money and avoided unlock independently', () {
      final achieved = MilestoneEvaluator.achieved(
        bestClean: Duration.zero,
        savedCents: 600,
        avoided: 12,
      ).map((m) => m.key);
      expect(achieved, contains('money_500'));
      expect(achieved, contains('avoid_10'));
      expect(achieved, isNot(contains('avoid_50')));
    });
  });

  group('garage', () {
    test('currentCar is the highest affordable tier', () {
      expect(MilestoneEvaluator.currentCar(0).name, 'Rostlaube');
      expect(MilestoneEvaluator.currentCar(6000).name, 'Street Coupé');
      expect(MilestoneEvaluator.currentCar(999999).name, 'Hypercar');
    });

    test('nextCar points at the next tier, null when maxed', () {
      expect(MilestoneEvaluator.nextCar(0)!.name, 'Tuned Hatchback');
      expect(MilestoneEvaluator.nextCar(999999), isNull);
    });
  });
}
