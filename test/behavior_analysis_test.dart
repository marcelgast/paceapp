import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/behavior_analysis.dart';

void main() {
  final now = DateTime(2026, 6, 3, 12);

  PitSample sample(DateTime at,
          {int craving = 3, int stress = 3, String? sit, bool early = false}) =>
      PitSample(
          occurredAt: at,
          craving: craving,
          stress: stress,
          situationId: sit,
          wasEarly: early);

  test('empty input yields zeroes and a 7-day scaffold', () {
    final a = BehaviorAnalysis.from([], labels: {}, now: now);
    expect(a.total, 0);
    expect(a.bySituation, isEmpty);
    expect(a.last7Days.length, 7);
    expect(a.last7Days.every((d) => d.count == 0), isTrue);
  });

  test('aggregates averages, early rate and triggers', () {
    final a = BehaviorAnalysis.from(
      [
        sample(now, craving: 5, stress: 1, sit: 'work', early: true),
        sample(now, craving: 3, stress: 3, sit: 'work'),
        sample(now, craving: 1, stress: 5, sit: 'car'),
        sample(now, craving: 3, stress: 3, sit: null),
      ],
      labels: {'work': 'Arbeit', 'car': 'Auto'},
      now: now,
    );

    expect(a.total, 4);
    expect(a.avgCraving, closeTo(3.0, 0.0001));
    expect(a.avgStress, closeTo(3.0, 0.0001));
    expect(a.earlyPits, 1);
    expect(a.earlyRate, closeTo(0.25, 0.0001));
    // Work is the top trigger with 2.
    expect(a.bySituation.first.label, 'Arbeit');
    expect(a.bySituation.first.count, 2);
    // Null situation is labelled.
    expect(a.bySituation.map((s) => s.label), contains(BehaviorAnalysis.noSituationLabel));
  });

  group('medianPace', () {
    test('is null with fewer than two pit stops', () {
      final a = BehaviorAnalysis.from([sample(now)], labels: {}, now: now);
      expect(a.medianPace, isNull);
    });

    test('is the median gap between cigarettes', () {
      // Gaps of 60, 60, 120 min -> median 60 min.
      final a = BehaviorAnalysis.from(
        [
          sample(now.subtract(const Duration(minutes: 240))),
          sample(now.subtract(const Duration(minutes: 180))),
          sample(now.subtract(const Duration(minutes: 120))),
          sample(now),
        ],
        labels: {},
        now: now,
      );
      expect(a.medianPace, const Duration(minutes: 60));
    });
  });

  test('buckets pit stops into the right day', () {
    final a = BehaviorAnalysis.from(
      [
        sample(now), // today
        sample(now.subtract(const Duration(days: 1))),
        sample(now.subtract(const Duration(days: 1))),
      ],
      labels: {},
      now: now,
    );
    expect(a.last7Days.last.count, 1); // today
    expect(a.last7Days[5].count, 2); // yesterday
  });
}
