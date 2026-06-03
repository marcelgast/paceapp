import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/database.dart';
import 'domain/behavior_analysis.dart';
import 'domain/milestones.dart';
import 'domain/pace_stats.dart';
import 'domain/stint_calculator.dart';
import 'domain/weekly_proposal.dart';

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

/// Every milestone currently met by the user's progress.
final achievedMilestonesProvider = Provider<List<Milestone>>((ref) {
  final stats = ref.watch(statsProvider);
  if (stats == null) return const [];
  return MilestoneEvaluator.achieved(
    sinceStart: stats.sinceStart,
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

  return PaceStats.compute(
    sinceStart: now.difference(settings.startedAt),
    packPriceCents: settings.packPriceCents,
    cigarettesPerPack: settings.cigarettesPerPack,
    baselineCigsPerDay: settings.baselineCigsPerDay,
    actualCigarettes: pitStops?.length ?? 0,
  );
});
