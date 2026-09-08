import 'package:flutter_test/flutter_test.dart';
import 'package:pace/domain/behavior_analysis.dart';
import 'package:pace/domain/weekly_report.dart';

void main() {
  final start = DateTime(2026, 6, 1, 9);

  PitSample s(DateTime at, {bool early = false}) => PitSample(
    occurredAt: at,
    craving: 3,
    stress: 3,
    situationId: null,
    wasEarly: early,
  );

  test('only finished weeks produce a report', () {
    // 10 days elapsed -> one finished week (days 1-7), week 2 still running.
    final now = start.add(const Duration(days: 10));
    final samples = [
      s(start.add(const Duration(days: 1))),
      s(start.add(const Duration(days: 8))),
    ];
    final reports = WeeklyReportBuilder.build(
      samples,
      startedAt: start,
      now: now,
    );
    expect(reports.length, 1);
    expect(reports.first.weekNumber, 1);
    expect(
      reports.first.cigarettes,
      1,
    ); // only the day-1 cigarette is in week 1
  });

  test('delta compares to the previous week', () {
    final now = start.add(const Duration(days: 15)); // 2 finished weeks
    final samples = [
      // week 1: 3 cigarettes
      s(start.add(const Duration(hours: 1))),
      s(start.add(const Duration(hours: 3))),
      s(start.add(const Duration(hours: 5))),
      // week 2: 1 cigarette
      s(start.add(const Duration(days: 8))),
    ];
    final reports = WeeklyReportBuilder.build(
      samples,
      startedAt: start,
      now: now,
    );
    expect(reports.length, 2);
    // newest first -> week 2 first
    expect(reports.first.weekNumber, 2);
    expect(reports.first.cigarettes, 1);
    expect(reports.first.cigarettesPrevWeek, 3);
    expect(reports.first.cigaretteDelta, -2);
  });
}
