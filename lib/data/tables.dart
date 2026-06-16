import 'package:drift/drift.dart';

/// Singleton settings row (always id = 1).
class AppSettingsRows extends Table {
  @override
  String get tableName => 'app_settings';

  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get packPriceCents => integer()();
  IntColumn get cigarettesPerPack => integer()();
  IntColumn get baselineCigsPerDay => integer()();
  TextColumn get currencyCode => text().withDefault(const Constant('EUR'))();
  DateTimeColumn get startedAt => dateTime()();
  BoolColumn get onboardingDone =>
      boolean().withDefault(const Constant(false))();

  /// Active target stint in seconds. Null = still measuring (no countdown yet).
  IntColumn get currentTargetSeconds => integer().nullable()();

  /// When the last weekly proposal was shown/resolved (accepted or declined).
  DateTimeColumn get lastProposalAt => dateTime().nullable()();

  /// Last chosen weekly stretch in per-mille (100 = 10 %). Pre-fills the slider.
  IntColumn get growthPermille =>
      integer().withDefault(const Constant(100))();

  /// Sleep window as minutes from midnight. Sleep is excluded from stint/best
  /// timing (default 23:00–07:00).
  IntColumn get sleepStartMinutes =>
      integer().withDefault(const Constant(23 * 60))();
  IntColumn get sleepEndMinutes =>
      integer().withDefault(const Constant(7 * 60))();

  /// Selected neon skin (Pro). Defaults to the original "Underground".
  TextColumn get skinId =>
      text().withDefault(const Constant('underground'))();

  /// Live Activity / Dynamic Island stint timer (Pro). Off by default.
  BoolColumn get liveActivityEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// User-editable situations (Arbeit, Auto, Kaffee, …). New ones appear live.
class Situations extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Milestones the user has already been congratulated for — so the celebration
/// pops exactly once.
class Unlocks extends Table {
  TextColumn get milestoneKey => text()();
  DateTimeColumn get achievedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {milestoneKey};
}

/// Cost parameters over time. Each cigarette and each stretch of expected
/// consumption is priced by the period it falls in, so a price or pack-size
/// change applies from its [effectiveFrom] forward and never re-prices the past.
class CostPeriods extends Table {
  TextColumn get id => text()();
  DateTimeColumn get effectiveFrom => dateTime()();
  IntColumn get packPriceCents => integer()();
  IntColumn get cigarettesPerPack => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One cigarette = one pit stop.
class PitStops extends Table {
  TextColumn get id => text()();
  DateTimeColumn get occurredAt => dateTime()();
  IntColumn get cravingLevel => integer()(); // 1..5
  IntColumn get stressLevel => integer()(); // 1..5
  TextColumn get situationId =>
      text().nullable().references(Situations, #id)();

  /// True when fired while a countdown was still running (an early box stop).
  BoolColumn get wasEarlyPit => boolean().withDefault(const Constant(false))();

  /// The active target stint (seconds) at the moment of this pit stop.
  IntColumn get targetIntervalSeconds => integer().nullable()();

  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
