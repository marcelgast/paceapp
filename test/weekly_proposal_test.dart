import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/weekly_proposal.dart';

void main() {
  final now = DateTime(2026, 6, 3, 12);

  group('measuredMedian', () {
    test('returns null with too few pit stops', () {
      expect(
        ProposalCalculator.measuredMedian(
          pitTimes: [now.subtract(const Duration(hours: 2))],
          now: now,
        ),
        isNull,
      );
    });

    test('computes the median gap inside the window', () {
      // Gaps of 60, 60, 120 minutes -> median 60 min.
      final times = [
        now.subtract(const Duration(minutes: 240)),
        now.subtract(const Duration(minutes: 180)),
        now.subtract(const Duration(minutes: 120)),
        now.subtract(const Duration(minutes: 0)),
      ];
      final median = ProposalCalculator.measuredMedian(
        pitTimes: times,
        now: now,
      );
      expect(median, const Duration(minutes: 60));
    });

    test('ignores pit stops older than the window', () {
      final times = [
        now.subtract(const Duration(days: 30)),
        now.subtract(const Duration(days: 20)),
      ];
      expect(
        ProposalCalculator.measuredMedian(pitTimes: times, now: now),
        isNull,
      );
    });
  });

  group('baseFor', () {
    const fallback = Duration(hours: 1);

    test('uses fallback when nothing measured and no target', () {
      expect(
        ProposalCalculator.baseFor(
          measured: null,
          currentTarget: null,
          fallback: fallback,
        ),
        fallback,
      );
    });

    test('never proposes below the current target', () {
      final base = ProposalCalculator.baseFor(
        measured: const Duration(minutes: 40),
        currentTarget: const Duration(minutes: 60),
        fallback: fallback,
      );
      expect(base, const Duration(minutes: 60));
    });

    test('learns upward when the measured pace beats the target', () {
      final base = ProposalCalculator.baseFor(
        measured: const Duration(minutes: 90),
        currentTarget: const Duration(minutes: 60),
        fallback: fallback,
      );
      expect(base, const Duration(minutes: 90));
    });
  });

  group('proposed', () {
    test('stretches the base by the growth factor', () {
      expect(
        ProposalCalculator.proposed(
          base: const Duration(minutes: 60),
          growth: 0.10,
        ),
        const Duration(minutes: 66),
      );
    });
  });
}
