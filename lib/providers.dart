import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'domain/behavior_analysis.dart';
import 'domain/clean_run.dart';
import 'domain/sleep_window.dart';
import 'theme/skin.dart';
import 'domain/milestones.dart';
import 'domain/pace_stats.dart';
import 'domain/quit_plan.dart';
import 'domain/savings_calculator.dart';
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

/// The selected neon skin (Pro). Drives the runtime accent recolouring.
final skinProvider = Provider<Skin>((ref) {
  final id = ref.watch(settingsProvider).value?.skinId;
  return Skin.byId(id);
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

  // After the quit moment the stint mechanic ends — the smoke-free run takes
  // over the cockpit and widgets.
  final quitDate = settings.quitDate;
  if (quitDate != null && !now.isBefore(quitDate)) return null;

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
  // No more stint-stretch proposals once the quit moment has arrived.
  final quitDate = settings.quitDate;
  final smokeFree = quitDate != null && !now.isBefore(quitDate);

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
    isDue: measuringDone && dueAgain && !smokeFree,
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

/// Aggregate savings — the money/cigarette figures behind the cockpit, trophies
/// and goals. The pure computation lives in [SavingsCalculator]; this provider
/// only gathers the current inputs and delegates.
final statsProvider = Provider<PaceStats?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final now = ref.watch(clockProvider).value;
  if (settings == null || now == null) return null;

  final pitStops = ref.watch(pitStopsProvider).value ?? const <PitStop>[];
  final periods = ref.watch(costPeriodsProvider).value ?? const <CostPeriod>[];

  return SavingsCalculator.compute(
    startedAt: settings.startedAt,
    now: now,
    packPriceCents: settings.packPriceCents,
    cigarettesPerPack: settings.cigarettesPerPack,
    currentTargetSeconds: settings.currentTargetSeconds,
    baselineCigsPerDay: settings.baselineCigsPerDay.toDouble(),
    quitDate: settings.quitDate,
    sleep: ref.watch(sleepWindowProvider),
    pits: [
      for (final p in pitStops)
        SavingsPit(
          occurredAt: p.occurredAt,
          targetIntervalSeconds: p.targetIntervalSeconds,
        ),
    ],
    costEpochs: [
      for (final p in periods)
        CostEpoch(
          effectiveFrom: p.effectiveFrom,
          packPriceCents: p.packPriceCents,
          cigarettesPerPack: p.cigarettesPerPack,
        ),
    ],
  );
});

/// Current quit-plan phase (none / countdown / smoke-free) derived from the
/// optional quit date. Recomputes each clock tick, but only changes at day
/// boundaries.
final quitPlanProvider = Provider<QuitPlan>((ref) {
  final quitDate = ref.watch(settingsProvider).value?.quitDate;
  final now = ref.watch(clockProvider).value ?? DateTime.now();
  final pitStops = ref.watch(pitStopsProvider).value;
  final lastPit = (pitStops != null && pitStops.isNotEmpty)
      ? pitStops.first.occurredAt
      : null;
  return QuitPlan.from(quitDate: quitDate, now: now, lastPitStop: lastPit);
});

final savingsGoalsProvider = StreamProvider<List<SavingsGoal>>((ref) {
  return ref.watch(databaseProvider).watchSavingsGoals();
});

/// Goals whose target has been reached by the saved money but which haven't
/// been marked yet. The GoalWatcher marks them and fires the celebration once.
final unmarkedReachedGoalsProvider = Provider<List<SavingsGoal>>((ref) {
  final goals = ref.watch(savingsGoalsProvider).value ?? const [];
  final saved = ref.watch(statsProvider)?.savedMoneyCents ?? 0;
  return goals
      .where((g) => g.reachedAt == null && saved >= g.priceCents)
      .toList();
});
