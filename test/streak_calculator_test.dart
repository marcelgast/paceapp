import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/streak_calculator.dart';

void main() {
  DateTime day(int d) => DateTime(2026, 6, d, 12);

  test('counts consecutive win days ending today', () {
    // Threshold 5/day. Days 1–4: 2 each (win). Day 5 (today): 1 (win).
    final pits = [
      for (final d in [1, 2, 3, 4]) ...[day(d), day(d)],
      day(5),
    ];
    final r = StreakCalculator.compute(
      pitTimes: pits,
      dailyThreshold: 5,
      startedAt: day(1),
      now: day(5),
    );
    expect(r.current, 5);
    expect(r.longest, 5);
  });

  test('a day at/over the threshold breaks the streak', () {
    // Day 3 has 6 (>=... actually >5) → break. current counts only days 4,5.
    final pits = [
      day(1), day(2), // wins
      for (var i = 0; i < 6; i++) day(3), // 6 → not a win
      day(4), day(5), // wins
    ];
    final r = StreakCalculator.compute(
      pitTimes: pits,
      dailyThreshold: 5,
      startedAt: day(1),
      now: day(5),
    );
    expect(r.current, 2); // days 4 + 5
    expect(r.longest, 2); // either side is length 2
  });

  test('zero threshold yields no streak', () {
    final r = StreakCalculator.compute(
      pitTimes: [day(1)],
      dailyThreshold: 0,
      startedAt: day(1),
      now: day(1),
    );
    expect(r.current, 0);
  });
}
