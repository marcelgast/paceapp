import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/clean_run.dart';
import 'package:pace/domain/sleep_window.dart';

void main() {
  const sleep = SleepWindow.defaultWindow; // 23:00–07:00 (8 h)

  group('SleepWindow.awakeBetween', () {
    test('default window is 8 hours long', () {
      expect(sleep.durationMinutes, 8 * 60);
    });

    test('a daytime gap counts fully', () {
      final awake = sleep.awakeBetween(
        DateTime(2026, 1, 2, 8),
        DateTime(2026, 1, 2, 20),
      );
      expect(awake, const Duration(hours: 12));
    });

    test('a gap entirely within sleep counts as zero', () {
      final awake = sleep.awakeBetween(
        DateTime(2026, 1, 2, 0),
        DateTime(2026, 1, 2, 6),
      );
      expect(awake, Duration.zero);
    });

    test('an overnight gap only counts the awake edges', () {
      // 22:00 → 09:00 = 11 h, minus 23:00–07:00 sleep (8 h) = 3 h awake.
      final awake = sleep.awakeBetween(
        DateTime(2026, 1, 1, 22),
        DateTime(2026, 1, 2, 9),
      );
      expect(awake, const Duration(hours: 3));
    });

    test('zero-length window disables filtering', () {
      const none = SleepWindow(startMinutes: 0, endMinutes: 0);
      final awake = none.awakeBetween(
        DateTime(2026, 1, 1, 22),
        DateTime(2026, 1, 2, 9),
      );
      expect(awake, const Duration(hours: 11));
    });
  });

  group('CleanRun with sleep window', () {
    test('overnight sleep does not become the best time', () {
      final start = DateTime(2026, 1, 1, 20);
      // One cigarette at 22:00, then clean across the whole night until 09:00.
      final run = CleanRun.from(
        pitTimes: [DateTime(2026, 1, 1, 22)],
        startedAt: start,
        now: DateTime(2026, 1, 2, 9),
        sleep: sleep,
      );
      // start→pit: 20:00–22:00 = 2 h awake. pit→now: 22:00–09:00 = 3 h awake.
      expect(run.best, const Duration(hours: 3));
      expect(run.current, const Duration(hours: 3));
    });
  });
}
