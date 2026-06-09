import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'domain/behavior_analysis.dart';
import 'domain/clean_run.dart';
import 'domain/sleep_window.dart';
import 'domain/milestones.dart';
import 'domain/pace_stats.dart';
import 'domain/stint_calculator.dart';
import 'domain/streak_calculator.dart';
import 'domain/weekly_proposal.dart';
import 'domain/weekly_report.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final settingsProvider = StreamProvider<AppSettingsRow?>((ref) {
  return ref.watch(databaseProvider).watchSettings();
});

final situationsProvider = StreamProvider<List<Situation>>((ref) {
  return ref.watch(databaseProvider).watchActiveSituations();
});

final pitStopsProvider = StreamProvider<List<PitStop>>((ref) {
  return ref.watch(databaseProvider).watchPitStops();
});

/// Price/pack-size epochs. A change applies from its effective date forward.
final costPeriodsProvider = StreamProvider<List<CostPeriod>>((ref) {
  return ref.watch(databaseProvider).watchCostPeriods();
});

/// The user's sleep window — excluded from stint/best timing.
final sleepWindowProvider = Provider<SleepWindow>((ref) {
  final s = ref.watch(settingsProvider).value;
  if (s == null) return SleepWindow.defaultWindow;
  return SleepWindow(
      startMinutes: s.sleepStartMinutes, endMinutes: s.sleepEndMinutes);
});

/// All situations including archived — used to label historic pit stops.
final allSituationsProvider = StreamProvider<List<Situation>>((ref) {
  return ref.watch(databaseProvider).watchAllSituations();
});

/// id → label map for quick lookup.
final situationLabelsProvider = Provider<Map<String, String>>((ref) {
  final all = ref.watch(allSituationsProvider).value ?? const [];
  return {for (final s in all) s.id: s.label};
});

/// Ticks once a second to drive the live countdown/overtime gauge.
final clockProvider = StreamProvider<DateTime>((ref) {
  Timer? timer;
  late final StreamController<DateTime> controller;
  controller = StreamController<DateTime>(
    onListen: () {
      controller.add(DateTime.now());
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        controller.add(DateTime.now());
      });
    },
    onCancel: () => timer?.cancel(),
  );
  ref.onDispose(() {
    timer?.cancel();
    controller.close();
  });
  return controller.stream;
});

/// The active target stint, or null while still measuring (no countdown yet).
/// Set only by accepting a weekly proposal.
final targetIntervalProvider = Provider<Duration?>((ref) {
  final secs = ref.watch(settingsProvider).value?.currentTargetSeconds;
  return secs == null ? null : Duration(seconds: secs);
});

/// Live stint state for the cockpit gauge. Baseline (count-up "Messrunde")
/// until a target has been accepted, then countdown → overtime.
final liveStintProvider = Provider<StintState?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final pitStops = ref.watch(pitStopsProvider).value;
  final now = ref.watch(clockProvider).value;
  final target = ref.watch(targetIntervalProvider);
  if (settings == null || now == null) return null;

  final lastPit = (pitStops != null && pitStops.isNotEmpty)
      ? pitStops.first.occurredAt
      : settings.startedAt;

  // The stint timer counts awake time only — sleep doesn't run the clock.
  final awake = ref.watch(sleepWindowProvider).awakeBetween(lastPit, now);
  return StintCalculator.evaluate(
    target: target ?? Duration.zero,
    sinceLastPit: awake,
    inBaseline: target == null,
  );
});

/// Wall-clock time since the last pit stop — for the recovery view, where the
/// body keeps healing during sleep (unlike the stint timer).
final wallClockSinceLastPitProvider = Provider<Duration>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final pitStops = ref.watch(pitStopsProvider).value;
  final now = ref.watch(clockProvider).value;
  if (settings == null || now == null) return Duration.zero;
  final lastPit = (pitStops != null && pitStops.isNotEmpty)
      ? pitStops.first.occurredAt
      : settings.startedAt;
  return now.difference(lastPit);
});

/// State for the weekly "stretch your target" proposal.
class ProposalState {
  const ProposalState({
    required this.isDue,
    required this.base,
    required this.measured,
    required this.currentTarget,
    required this.growthPermille,
  });

  final bool isDue;
  final Duration base;
  final Duration? measured;
  final Duration? currentTarget;
  final int growthPermille;
}

final proposalProvider = Provider<ProposalState?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final pitStops = ref.watch(pitStopsProvider).value;
  final now = ref.watch(clockProvider).value;
  if (settings == null || now == null) return null;

  // First proposal once the measuring round is over; afterwards the stretch
  // keeps its weekly rhythm.
  final measuringDone =
      now.difference(settings.startedAt) >= StintCalculator.baselineDuration;
  final last = settings.lastProposalAt;
  final dueAgain =
      last == null || now.difference(last) >= ProposalCalculator.window;

  final measured = ProposalCalculator.measuredMedian(
    pitTimes: (pitStops ?? const []).map((p) => p.occurredAt).toList(),
    now: now,
  );
  final currentTarget = settings.currentTargetSeconds == null
      ? null
      : Duration(seconds: settings.currentTargetSeconds!);
  final base = ProposalCalculator.baseFor(
    measured: measured,
    currentTarget: currentTarget,
    fallback: StintCalculator.intervalFromDailyRate(
        settings.baselineCigsPerDay.toDouble()),
  );

  return ProposalState(
    isDue: measuringDone && dueAgain,
    base: base,
    measured: measured,
    currentTarget: currentTarget,
    growthPermille: settings.growthPermille,
  );
});

final celebratedKeysProvider = StreamProvider<Set<String>>((ref) {
  return ref.watch(databaseProvider).watchCelebratedKeys();
});

/// Current and best clean run derived from the pit-stop history. Smoking resets
/// [CleanRun.current]; [CleanRun.best] is the record that time milestones use.
final cleanRunProvider = Provider<CleanRun>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final pitStops = ref.watch(pitStopsProvider).value;
  final now = ref.watch(clockProvider).value;
  if (settings == null || now == null) {
    return const CleanRun(current: Duration.zero, best: Duration.zero);
  }
  return CleanRun.from(
    pitTimes: (pitStops ?? const <PitStop>[]).map((p) => p.occurredAt).toList(),
    startedAt: settings.startedAt,
    now: now,
    sleep: ref.watch(sleepWindowProvider),
  );
});

/// Every milestone currently met by the user's progress. Time milestones unlock
/// on the *best* clean stretch — a record you keep even after a slip-up.
final achievedMilestonesProvider = Provider<List<Milestone>>((ref) {
  final stats = ref.watch(statsProvider);
  if (stats == null) return const [];
  return MilestoneEvaluator.achieved(
    bestClean: ref.watch(cleanRunProvider).best,
    savedCents: stats.savedMoneyCents,
    avoided: stats.savedCigarettes.floor(),
  );
});

/// Achieved but not yet celebrated — drives the pop-up.
final pendingMilestonesProvider = Provider<List<Milestone>>((ref) {
  final achieved = ref.watch(achievedMilestonesProvider);
  // Wait until the "already celebrated" set has actually loaded from the DB.
  // Otherwise the first frame sees an empty set and re-pops every achievement
  // on each launch.
  final celebrated = ref.watch(celebratedKeysProvider).value;
  if (celebrated == null) return const [];
  return achieved.where((m) => !celebrated.contains(m.key)).toList();
});

final behaviorAnalysisProvider = Provider<BehaviorAnalysis>((ref) {
  final pitStops = ref.watch(pitStopsProvider).value ?? const [];
  final labels = ref.watch(situationLabelsProvider);
  final samples = pitStops
      .map((p) => PitSample(
            occurredAt: p.occurredAt,
            craving: p.cravingLevel,
            stress: p.stressLevel,
            situationId: p.situationId,
            wasEarly: p.wasEarlyPit,
          ))
      .toList();
  return BehaviorAnalysis.from(samples, labels: labels, now: DateTime.now());
});

final weeklyReportsProvider = Provider<List<WeeklyReport>>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final pitStops = ref.watch(pitStopsProvider).value;
  final now = ref.watch(clockProvider).value;
  if (settings == null || now == null) return const [];

  final samples = (pitStops ?? const <PitStop>[])
      .map((p) => PitSample(
            occurredAt: p.occurredAt,
            craving: p.cravingLevel,
            stress: p.stressLevel,
            situationId: p.situationId,
            wasEarly: p.wasEarlyPit,
          ))
      .toList();
  return WeeklyReportBuilder.build(samples,
      startedAt: settings.startedAt, now: now);
});

final streakProvider = Provider<StreakResult>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final pitStops = ref.watch(pitStopsProvider).value;
  final now = ref.watch(clockProvider).value;
  if (settings == null || now == null) {
    return const StreakResult(current: 0, longest: 0);
  }

  final all = pitStops ?? const <PitStop>[];
  final measuringEnd = settings.startedAt.add(StintCalculator.baselineDuration);
  final double threshold;
  if (now.isBefore(measuringEnd)) {
    threshold = settings.baselineCigsPerDay.toDouble();
  } else {
    final week1 = all.where((p) => p.occurredAt.isBefore(measuringEnd)).length;
    final measured = week1 / StintCalculator.baselineDuration.inDays;
    threshold = measured > 0 ? measured : settings.baselineCigsPerDay.toDouble();
  }

  return StreakCalculator.compute(
    pitTimes: all.map((p) => p.occurredAt).toList(),
    dailyThreshold: threshold,
    startedAt: settings.startedAt,
    now: now,
  );
});

final currentCarProvider = Provider<CarTier>((ref) {
  final stats = ref.watch(statsProvider);
  return MilestoneEvaluator.currentCar(stats?.savedMoneyCents ?? 0);
});

final nextCarProvider = Provider<CarTier?>((ref) {
  final stats = ref.watch(statsProvider);
  return MilestoneEvaluator.nextCar(stats?.savedMoneyCents ?? 0);
});

final statsProvider = Provider<PaceStats?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final pitStops = ref.watch(pitStopsProvider).value;
  final now = ref.watch(clockProvider).value;
  if (settings == null || now == null) return null;

  final all = pitStops ?? const <PitStop>[];
  final start = settings.startedAt;
  final sinceStart = now.difference(start);
  final baseline = settings.baselineCigsPerDay.toDouble();

  // Cigarettes per calendar day — drives the rolling "yesterday" baseline.
  final dailyCounts = <DateTime, int>{};
  for (final p in all) {
    final d = DateTime(p.occurredAt.year, p.occurredAt.month, p.occurredAt.day);
    dailyCounts[d] = (dailyCounts[d] ?? 0) + 1;
  }

  // One rate segment per calendar day in [start, now]. Each day's expected rate
  // is the previous calendar day's count (the first day uses the onboarding
  // baseline). Savings stay a high-water mark, so they never drop.
  final startDate = DateTime(start.year, start.month, start.day);
  final rateSegments = <({Duration start, Duration end, double ratePerDay})>[];
  var dayMidnight = startDate;
  while (dayMidnight.isBefore(now)) {
    final nextMidnight =
        DateTime(dayMidnight.year, dayMidnight.month, dayMidnight.day + 1);
    final segStart = dayMidnight.isBefore(start) ? start : dayMidnight;
    final segEnd = nextMidnight.isAfter(now) ? now : nextMidnight;
    if (segEnd.isAfter(segStart)) {
      final double rate;
      if (dayMidnight == startDate) {
        rate = baseline;
      } else {
        final prevDay = DateTime(
            dayMidnight.year, dayMidnight.month, dayMidnight.day - 1);
        rate = (dailyCounts[prevDay] ?? 0).toDouble();
      }
      rateSegments.add((
        start: segStart.difference(start),
        end: segEnd.difference(start),
        ratePerDay: rate,
      ));
    }
    dayMidnight = nextMidnight;
  }

  final pitElapsed = all
      .map((p) => p.occurredAt.difference(settings.startedAt))
      .where((d) => !d.isNegative)
      .toList()
    ..sort();

  // Cost epochs as (offset-from-start, cents-per-cigarette), anchored at zero.
  final periods = ref.watch(costPeriodsProvider).value ?? const <CostPeriod>[];
  final costPeriods = <({Duration start, int perCig})>[];
  if (periods.isEmpty) {
    costPeriods.add((
      start: Duration.zero,
      perCig: PaceStats.centsPerCigarette(
        packPriceCents: settings.packPriceCents,
        cigarettesPerPack: settings.cigarettesPerPack,
      ),
    ));
  } else {
    final sorted = [...periods]
      ..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));
    for (final p in sorted) {
      final offset = p.effectiveFrom.difference(settings.startedAt);
      costPeriods.add((
        start: offset.isNegative ? Duration.zero : offset,
        perCig: PaceStats.centsPerCigarette(
          packPriceCents: p.packPriceCents,
          cigarettesPerPack: p.cigarettesPerPack,
        ),
      ));
    }
    costPeriods[0] = (start: Duration.zero, perCig: costPeriods[0].perCig);
  }

  return PaceStats.compute(
    sinceStart: sinceStart,
    pitElapsed: pitElapsed,
    costPeriods: costPeriods,
    rateSegments: rateSegments,
  );
});
