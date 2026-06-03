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
