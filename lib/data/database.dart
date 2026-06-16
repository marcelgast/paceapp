import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'ids.dart';
import 'tables.dart';

part 'database.g.dart';

const List<String> kDefaultSituations = [
  'Arbeit',
  'Zuhause',
  'Auto',
  'Restaurant',
  'Kaffee',
  'Alkohol',
  'Sonstiges',
];

@DriftDatabase(
    tables: [AppSettingsRows, Situations, PitStops, Unlocks, CostPeriods])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDefaultSituations();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(unlocks);
          if (from < 3) {
            await m.addColumn(
                appSettingsRows, appSettingsRows.currentTargetSeconds);
            await m.addColumn(appSettingsRows, appSettingsRows.lastProposalAt);
            await m.addColumn(appSettingsRows, appSettingsRows.growthPermille);
          }
          if (from < 5) {
            await m.addColumn(
                appSettingsRows, appSettingsRows.sleepStartMinutes);
            await m.addColumn(
                appSettingsRows, appSettingsRows.sleepEndMinutes);
          }
          if (from < 6) {
            await m.addColumn(appSettingsRows, appSettingsRows.skinId);
          }
          if (from < 7) {
            await m.addColumn(
                appSettingsRows, appSettingsRows.liveActivityEnabled);
          }
          if (from < 8) {
            await m.addColumn(appSettingsRows, appSettingsRows.proPurchased);
          }
          if (from < 4) {
            await m.createTable(costPeriods);
            // Seed the first cost period from the existing settings so past
            // savings keep their original pricing.
            final s = await getSettings();
            if (s != null) {
              await into(costPeriods).insert(
                CostPeriodsCompanion.insert(
                  id: newId(),
                  effectiveFrom: s.startedAt,
                  packPriceCents: s.packPriceCents,
                  cigarettesPerPack: s.cigarettesPerPack,
                ),
              );
            }
          }
        },
      );

  // ---- Cost periods -------------------------------------------------------

  Stream<List<CostPeriod>> watchCostPeriods() => (select(costPeriods)
        ..orderBy([(t) => OrderingTerm(expression: t.effectiveFrom)]))
      .watch();

  /// Records a price/pack-size change effective [at]. The new values also become
  /// the settings row's current values (for form pre-fill and display).
  Future<void> changeCostFrom({
    required int packPriceCents,
    required int cigarettesPerPack,
    required DateTime at,
  }) async {
    await into(costPeriods).insert(
      CostPeriodsCompanion.insert(
        id: newId(),
        effectiveFrom: at,
        packPriceCents: packPriceCents,
        cigarettesPerPack: cigarettesPerPack,
      ),
    );
    await (update(appSettingsRows)..where((t) => t.id.equals(1))).write(
      AppSettingsRowsCompanion(
        packPriceCents: Value(packPriceCents),
        cigarettesPerPack: Value(cigarettesPerPack),
      ),
    );
  }

  Future<void> updateSkin(String skinId) {
    return (update(appSettingsRows)..where((t) => t.id.equals(1)))
        .write(AppSettingsRowsCompanion(skinId: Value(skinId)));
  }

  Future<void> updateLiveActivityEnabled(bool enabled) {
    return (update(appSettingsRows)..where((t) => t.id.equals(1)))
        .write(AppSettingsRowsCompanion(liveActivityEnabled: Value(enabled)));
  }

  Future<void> setProPurchased(bool purchased) {
    return (update(appSettingsRows)..where((t) => t.id.equals(1)))
        .write(AppSettingsRowsCompanion(proPurchased: Value(purchased)));
  }

  Future<void> updateSleepWindow({
    required int startMinutes,
    required int endMinutes,
  }) {
    return (update(appSettingsRows)..where((t) => t.id.equals(1))).write(
      AppSettingsRowsCompanion(
        sleepStartMinutes: Value(startMinutes),
        sleepEndMinutes: Value(endMinutes),
      ),
    );
  }

  /// Corrects the baseline daily-consumption estimate. Unlike price, this is a
  /// simple overwrite — it shifts the whole expected-consumption reference.
  Future<void> updateBaseline(int baselineCigsPerDay) {
    return (update(appSettingsRows)..where((t) => t.id.equals(1))).write(
      AppSettingsRowsCompanion(
        baselineCigsPerDay: Value(baselineCigsPerDay)),
    );
  }

  // ---- Settings -----------------------------------------------------------

  Stream<AppSettingsRow?> watchSettings() =>
      (select(appSettingsRows)..where((t) => t.id.equals(1)))
          .watchSingleOrNull();

  Future<AppSettingsRow?> getSettings() =>
      (select(appSettingsRows)..where((t) => t.id.equals(1)))
          .getSingleOrNull();

  Future<void> saveOnboarding({
    required int packPriceCents,
    required int cigarettesPerPack,
    required int baselineCigsPerDay,
    required DateTime startedAt,
    String currencyCode = 'EUR',
    int sleepStartMinutes = 23 * 60,
    int sleepEndMinutes = 7 * 60,
  }) async {
    await into(appSettingsRows).insertOnConflictUpdate(
      AppSettingsRowsCompanion.insert(
        id: const Value(1),
        packPriceCents: packPriceCents,
        cigarettesPerPack: cigarettesPerPack,
        baselineCigsPerDay: baselineCigsPerDay,
        startedAt: startedAt,
        currencyCode: Value(currencyCode),
        onboardingDone: const Value(true),
        sleepStartMinutes: Value(sleepStartMinutes),
        sleepEndMinutes: Value(sleepEndMinutes),
      ),
    );
    // First cost period — pricing is sourced from here onward.
    await into(costPeriods).insert(
      CostPeriodsCompanion.insert(
        id: newId(),
        effectiveFrom: startedAt,
        packPriceCents: packPriceCents,
        cigarettesPerPack: cigarettesPerPack,
      ),
    );
  }

  /// Accept a weekly proposal: set the new target and remember the choice.
  Future<void> acceptProposal({
    required int targetSeconds,
    required int growthPermille,
    required DateTime at,
  }) {
    return (update(appSettingsRows)..where((t) => t.id.equals(1))).write(
      AppSettingsRowsCompanion(
        currentTargetSeconds: Value(targetSeconds),
        growthPermille: Value(growthPermille),
        lastProposalAt: Value(at),
      ),
    );
  }

  /// Decline a weekly proposal: keep the target, just bump the timestamp so the
  /// next proposal is due in a week.
  Future<void> declineProposal(DateTime at) {
    return (update(appSettingsRows)..where((t) => t.id.equals(1)))
        .write(AppSettingsRowsCompanion(lastProposalAt: Value(at)));
  }

  // ---- Situations ---------------------------------------------------------

  Future<void> seedDefaultSituations() async {
    for (var i = 0; i < kDefaultSituations.length; i++) {
      await into(situations).insert(
        SituationsCompanion.insert(
          id: newId(),
          label: kDefaultSituations[i],
          isBuiltIn: const Value(true),
          sortOrder: Value(i),
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  Stream<List<Situation>> watchAllSituations() {
    return (select(situations)
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  Stream<List<Situation>> watchActiveSituations() {
    return (select(situations)
          ..where((t) => t.archivedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  Future<Situation> addSituation(String label) async {
    final maxOrder = await (selectOnly(situations)
          ..addColumns([situations.sortOrder.max()]))
        .map((row) => row.read(situations.sortOrder.max()))
        .getSingleOrNull();
    final row = SituationsCompanion.insert(
      id: newId(),
      label: label.trim(),
      sortOrder: Value((maxOrder ?? 0) + 1),
      createdAt: DateTime.now(),
    );
    await into(situations).insert(row);
    return (select(situations)..where((t) => t.id.equals(row.id.value)))
        .getSingle();
  }

  Future<void> archiveSituation(String id) {
    return (update(situations)..where((t) => t.id.equals(id)))
        .write(SituationsCompanion(archivedAt: Value(DateTime.now())));
  }

  // ---- Pit stops ----------------------------------------------------------

  Future<PitStop?> lastPitStop() {
    return (select(pitStops)
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.occurredAt, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<PitStop>> watchPitStops() {
    return (select(pitStops)
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.occurredAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  // ---- Milestones ---------------------------------------------------------

  Future<Set<String>> celebratedKeys() async {
    final rows = await select(unlocks).get();
    return rows.map((r) => r.milestoneKey).toSet();
  }

  Stream<Set<String>> watchCelebratedKeys() => select(unlocks)
      .watch()
      .map((rows) => rows.map((r) => r.milestoneKey).toSet());

  Future<void> markCelebrated(Iterable<String> keys, DateTime at) async {
    await batch((b) {
      b.insertAll(
        unlocks,
        [for (final k in keys) UnlocksCompanion.insert(milestoneKey: k, achievedAt: at)],
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<void> deletePitStop(String id) {
    return (delete(pitStops)..where((t) => t.id.equals(id))).go();
  }

  /// Wipes everything and re-seeds defaults — the app drops back to onboarding
  /// because the settings row is gone.
  Future<void> resetEverything() async {
    await transaction(() async {
      await delete(pitStops).go();
      await delete(unlocks).go();
      await delete(costPeriods).go();
      await delete(situations).go();
      await delete(appSettingsRows).go();
      await seedDefaultSituations();
    });
  }

  Future<int> addPitStop({
    required DateTime occurredAt,
    required int cravingLevel,
    required int stressLevel,
    String? situationId,
    bool wasEarlyPit = false,
    int? targetIntervalSeconds,
    String? note,
  }) {
    return into(pitStops).insert(
      PitStopsCompanion.insert(
        id: newId(),
        occurredAt: occurredAt,
        cravingLevel: cravingLevel,
        stressLevel: stressLevel,
        situationId: Value(situationId),
        wasEarlyPit: Value(wasEarlyPit),
        targetIntervalSeconds: Value(targetIntervalSeconds),
        note: Value(note),
      ),
    );
  }
}

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'pace.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
