import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/clean_run.dart';

void main() {
  final start = DateTime(2026, 1, 1, 8);

  group('CleanRun', () {
    test('no pit stops: current and best both run from the start', () {
      final run = CleanRun.from(
        pitTimes: const [],
        startedAt: start,
        now: start.add(const Duration(hours: 3)),
      );
      expect(run.current, const Duration(hours: 3));
      expect(run.best, const Duration(hours: 3));
    });

    test('current resets at the last pit, best keeps the longest stretch', () {
      final run = CleanRun.from(
        pitTimes: [
          start.add(const Duration(hours: 9)), // 9 h clean stretch first
          start.add(const Duration(hours: 9, minutes: 30)),
        ],
        startedAt: start,
        now: start.add(const Duration(hours: 9, minutes: 33)),
      );
      // Smoking 33 min ago resets the current run.
      expect(run.current, const Duration(minutes: 3));
      // The best stretch (start → first pit) stays at 9 h.
      expect(run.best, const Duration(hours: 9));
    });

    test('pit order does not matter', () {
      final run = CleanRun.from(
        pitTimes: [
          start.add(const Duration(hours: 5)),
          start.add(const Duration(hours: 1)),
        ],
        startedAt: start,
        now: start.add(const Duration(hours: 5, minutes: 10)),
      );
      // Longest gap is pit1 → pit2 = 4 h.
      expect(run.best, const Duration(hours: 4));
      expect(run.current, const Duration(minutes: 10));
    });
  });
}
