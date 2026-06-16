import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/behavior_analysis.dart';
import 'package:pace/domain/deep_analytics.dart';

PitSample sample(DateTime t, {int craving = 3, String? situation}) => PitSample(
      occurredAt: t,
      craving: craving,
      stress: 3,
      situationId: situation,
      wasEarly: false,
    );

void main() {
  group('DeepAnalytics', () {
    test('empty input yields no peaks', () {
      final a = DeepAnalytics.from(const [],
          labels: const {}, now: DateTime(2026, 6, 1), noSituationLabel: '—');
      expect(a.total, 0);
      expect(a.peakHour, -1);
      expect(a.peakWeekday, -1);
      expect(a.triggers, isEmpty);
    });

    test('finds the peak hour and weekday', () {
      // Three cigarettes at 19:00 on a Monday, one at 09:00.
      final monday = DateTime(2026, 6, 1, 19); // 2026-06-01 is a Monday
      final samples = [
        sample(monday),
        sample(monday.add(const Duration(minutes: 5))),
        sample(monday.add(const Duration(minutes: 10))),
        sample(DateTime(2026, 6, 2, 9)), // Tuesday 09:00
      ];
      final a = DeepAnalytics.from(samples,
          labels: const {}, now: DateTime(2026, 6, 3), noSituationLabel: '—');
      expect(a.peakHour, 19);
      expect(a.byHour[19], 3);
      expect(a.peakWeekday, 0); // Monday
      expect(a.total, 4);
    });

    test('ranks triggers by frequency with average craving', () {
      final t = DateTime(2026, 6, 1, 12);
      final a = DeepAnalytics.from(
        [
          sample(t, situation: 'work', craving: 4),
          sample(t, situation: 'work', craving: 2),
          sample(t, situation: 'coffee', craving: 5),
        ],
        labels: const {'work': 'Arbeit', 'coffee': 'Kaffee'},
        now: DateTime(2026, 6, 2),
        noSituationLabel: '—',
      );
      expect(a.triggers.first.label, 'Arbeit');
      expect(a.triggers.first.count, 2);
      expect(a.triggers.first.avgCraving, 3.0);
    });
  });
}
