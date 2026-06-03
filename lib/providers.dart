import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'domain/behavior_analysis.dart';
import 'domain/clean_run.dart';
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

  return StintCalculator.evaluate(
    target: target ?? Duration.zero,
    sinceLastPit: now.difference(lastPit),
    inBaseline: target == null,
  );
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

  final afterFirstWeek =
      now.difference(settings.startedAt) >= ProposalCalculator.window;
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
    isDue: afterFirstWeek && dueAgain,
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
  final celebrated = ref.watch(celebratedKeysProvider).value ?? const {};
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
  final sinceStart = now.difference(settings.startedAt);
  final measuringEnd = settings.startedAt.add(StintCalculator.baselineDuration);

  // Counterfactual rate from real data: running rate while still measuring,
  // then the measured baseline (week-1 cigarettes ÷ 7). Falls back to the
  // onboarding estimate only if no baseline was ever logged.
  final double dailyRate;
  if (now.isBefore(measuringEnd)) {
    final days = sinceStart.inSeconds / Duration.secondsPerDay;
    dailyRate = days > 0 ? all.length / days : 0;
  } else {
    final week1 = all.where((p) => p.occurredAt.isBefore(measuringEnd)).length;
    final measured = week1 / StintCalculator.baselineDuration.inDays;
    dailyRate = measured > 0 ? measured : settings.baselineCigsPerDay.toDouble();
  }

  return PaceStats.compute(
    sinceStart: sinceStart,
    packPriceCents: settings.packPriceCents,
    cigarettesPerPack: settings.cigarettesPerPack,
    dailyRate: dailyRate,
    actualCigarettes: all.length,
  );
});
