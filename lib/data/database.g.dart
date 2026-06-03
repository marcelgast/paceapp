// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AppSettingsRowsTable extends AppSettingsRows
    with TableInfo<$AppSettingsRowsTable, AppSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _packPriceCentsMeta = const VerificationMeta(
    'packPriceCents',
  );
  @override
  late final GeneratedColumn<int> packPriceCents = GeneratedColumn<int>(
    'pack_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cigarettesPerPackMeta = const VerificationMeta(
    'cigarettesPerPack',
  );
  @override
  late final GeneratedColumn<int> cigarettesPerPack = GeneratedColumn<int>(
    'cigarettes_per_pack',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baselineCigsPerDayMeta =
      const VerificationMeta('baselineCigsPerDay');
  @override
  late final GeneratedColumn<int> baselineCigsPerDay = GeneratedColumn<int>(
    'baseline_cigs_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EUR'),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onboardingDoneMeta = const VerificationMeta(
    'onboardingDone',
  );
  @override
  late final GeneratedColumn<bool> onboardingDone = GeneratedColumn<bool>(
    'onboarding_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _currentTargetSecondsMeta =
      const VerificationMeta('currentTargetSeconds');
  @override
  late final GeneratedColumn<int> currentTargetSeconds = GeneratedColumn<int>(
    'current_target_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastProposalAtMeta = const VerificationMeta(
    'lastProposalAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastProposalAt =
      GeneratedColumn<DateTime>(
        'last_proposal_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _growthPermilleMeta = const VerificationMeta(
    'growthPermille',
  );
  @override
  late final GeneratedColumn<int> growthPermille = GeneratedColumn<int>(
    'growth_permille',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packPriceCents,
    cigarettesPerPack,
    baselineCigsPerDay,
    currencyCode,
    startedAt,
    onboardingDone,
    currentTargetSeconds,
    lastProposalAt,
    growthPermille,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pack_price_cents')) {
      context.handle(
        _packPriceCentsMeta,
        packPriceCents.isAcceptableOrUnknown(
          data['pack_price_cents']!,
          _packPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packPriceCentsMeta);
    }
    if (data.containsKey('cigarettes_per_pack')) {
      context.handle(
        _cigarettesPerPackMeta,
        cigarettesPerPack.isAcceptableOrUnknown(
          data['cigarettes_per_pack']!,
          _cigarettesPerPackMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cigarettesPerPackMeta);
    }
    if (data.containsKey('baseline_cigs_per_day')) {
      context.handle(
        _baselineCigsPerDayMeta,
        baselineCigsPerDay.isAcceptableOrUnknown(
          data['baseline_cigs_per_day']!,
          _baselineCigsPerDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baselineCigsPerDayMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('onboarding_done')) {
      context.handle(
        _onboardingDoneMeta,
        onboardingDone.isAcceptableOrUnknown(
          data['onboarding_done']!,
          _onboardingDoneMeta,
        ),
      );
    }
    if (data.containsKey('current_target_seconds')) {
      context.handle(
        _currentTargetSecondsMeta,
        currentTargetSeconds.isAcceptableOrUnknown(
          data['current_target_seconds']!,
          _currentTargetSecondsMeta,
        ),
      );
    }
    if (data.containsKey('last_proposal_at')) {
      context.handle(
        _lastProposalAtMeta,
        lastProposalAt.isAcceptableOrUnknown(
          data['last_proposal_at']!,
          _lastProposalAtMeta,
        ),
      );
    }
    if (data.containsKey('growth_permille')) {
      context.handle(
        _growthPermilleMeta,
        growthPermille.isAcceptableOrUnknown(
          data['growth_permille']!,
          _growthPermilleMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pack_price_cents'],
      )!,
      cigarettesPerPack: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cigarettes_per_pack'],
      )!,
      baselineCigsPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baseline_cigs_per_day'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      onboardingDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_done'],
      )!,
      currentTargetSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_target_seconds'],
      ),
      lastProposalAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_proposal_at'],
      ),
      growthPermille: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}growth_permille'],
      )!,
    );
  }

  @override
  $AppSettingsRowsTable createAlias(String alias) {
    return $AppSettingsRowsTable(attachedDatabase, alias);
  }
}

class AppSettingsRow extends DataClass implements Insertable<AppSettingsRow> {
  final int id;
  final int packPriceCents;
  final int cigarettesPerPack;
  final int baselineCigsPerDay;
  final String currencyCode;
  final DateTime startedAt;
  final bool onboardingDone;

  /// Active target stint in seconds. Null = still measuring (no countdown yet).
  final int? currentTargetSeconds;

  /// When the last weekly proposal was shown/resolved (accepted or declined).
  final DateTime? lastProposalAt;

  /// Last chosen weekly stretch in per-mille (100 = 10 %). Pre-fills the slider.
  final int growthPermille;
  const AppSettingsRow({
    required this.id,
    required this.packPriceCents,
    required this.cigarettesPerPack,
    required this.baselineCigsPerDay,
    required this.currencyCode,
    required this.startedAt,
    required this.onboardingDone,
    this.currentTargetSeconds,
    this.lastProposalAt,
    required this.growthPermille,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pack_price_cents'] = Variable<int>(packPriceCents);
    map['cigarettes_per_pack'] = Variable<int>(cigarettesPerPack);
    map['baseline_cigs_per_day'] = Variable<int>(baselineCigsPerDay);
    map['currency_code'] = Variable<String>(currencyCode);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['onboarding_done'] = Variable<bool>(onboardingDone);
    if (!nullToAbsent || currentTargetSeconds != null) {
      map['current_target_seconds'] = Variable<int>(currentTargetSeconds);
    }
    if (!nullToAbsent || lastProposalAt != null) {
      map['last_proposal_at'] = Variable<DateTime>(lastProposalAt);
    }
    map['growth_permille'] = Variable<int>(growthPermille);
    return map;
  }

  AppSettingsRowsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsRowsCompanion(
      id: Value(id),
      packPriceCents: Value(packPriceCents),
      cigarettesPerPack: Value(cigarettesPerPack),
      baselineCigsPerDay: Value(baselineCigsPerDay),
      currencyCode: Value(currencyCode),
      startedAt: Value(startedAt),
      onboardingDone: Value(onboardingDone),
      currentTargetSeconds: currentTargetSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(currentTargetSeconds),
      lastProposalAt: lastProposalAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastProposalAt),
      growthPermille: Value(growthPermille),
    );
  }

  factory AppSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      packPriceCents: serializer.fromJson<int>(json['packPriceCents']),
      cigarettesPerPack: serializer.fromJson<int>(json['cigarettesPerPack']),
      baselineCigsPerDay: serializer.fromJson<int>(json['baselineCigsPerDay']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      onboardingDone: serializer.fromJson<bool>(json['onboardingDone']),
      currentTargetSeconds: serializer.fromJson<int?>(
        json['currentTargetSeconds'],
      ),
      lastProposalAt: serializer.fromJson<DateTime?>(json['lastProposalAt']),
      growthPermille: serializer.fromJson<int>(json['growthPermille']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packPriceCents': serializer.toJson<int>(packPriceCents),
      'cigarettesPerPack': serializer.toJson<int>(cigarettesPerPack),
      'baselineCigsPerDay': serializer.toJson<int>(baselineCigsPerDay),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'onboardingDone': serializer.toJson<bool>(onboardingDone),
      'currentTargetSeconds': serializer.toJson<int?>(currentTargetSeconds),
      'lastProposalAt': serializer.toJson<DateTime?>(lastProposalAt),
      'growthPermille': serializer.toJson<int>(growthPermille),
    };
  }

  AppSettingsRow copyWith({
    int? id,
    int? packPriceCents,
    int? cigarettesPerPack,
    int? baselineCigsPerDay,
    String? currencyCode,
    DateTime? startedAt,
    bool? onboardingDone,
    Value<int?> currentTargetSeconds = const Value.absent(),
    Value<DateTime?> lastProposalAt = const Value.absent(),
    int? growthPermille,
  }) => AppSettingsRow(
    id: id ?? this.id,
    packPriceCents: packPriceCents ?? this.packPriceCents,
    cigarettesPerPack: cigarettesPerPack ?? this.cigarettesPerPack,
    baselineCigsPerDay: baselineCigsPerDay ?? this.baselineCigsPerDay,
    currencyCode: currencyCode ?? this.currencyCode,
    startedAt: startedAt ?? this.startedAt,
    onboardingDone: onboardingDone ?? this.onboardingDone,
    currentTargetSeconds: currentTargetSeconds.present
        ? currentTargetSeconds.value
        : this.currentTargetSeconds,
    lastProposalAt: lastProposalAt.present
        ? lastProposalAt.value
        : this.lastProposalAt,
    growthPermille: growthPermille ?? this.growthPermille,
  );
  AppSettingsRow copyWithCompanion(AppSettingsRowsCompanion data) {
    return AppSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      packPriceCents: data.packPriceCents.present
          ? data.packPriceCents.value
          : this.packPriceCents,
      cigarettesPerPack: data.cigarettesPerPack.present
          ? data.cigarettesPerPack.value
          : this.cigarettesPerPack,
      baselineCigsPerDay: data.baselineCigsPerDay.present
          ? data.baselineCigsPerDay.value
          : this.baselineCigsPerDay,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      onboardingDone: data.onboardingDone.present
          ? data.onboardingDone.value
          : this.onboardingDone,
      currentTargetSeconds: data.currentTargetSeconds.present
          ? data.currentTargetSeconds.value
          : this.currentTargetSeconds,
      lastProposalAt: data.lastProposalAt.present
          ? data.lastProposalAt.value
          : this.lastProposalAt,
      growthPermille: data.growthPermille.present
          ? data.growthPermille.value
          : this.growthPermille,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRow(')
          ..write('id: $id, ')
          ..write('packPriceCents: $packPriceCents, ')
          ..write('cigarettesPerPack: $cigarettesPerPack, ')
          ..write('baselineCigsPerDay: $baselineCigsPerDay, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('startedAt: $startedAt, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('currentTargetSeconds: $currentTargetSeconds, ')
          ..write('lastProposalAt: $lastProposalAt, ')
          ..write('growthPermille: $growthPermille')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packPriceCents,
    cigarettesPerPack,
    baselineCigsPerDay,
    currencyCode,
    startedAt,
    onboardingDone,
    currentTargetSeconds,
    lastProposalAt,
    growthPermille,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRow &&
          other.id == this.id &&
          other.packPriceCents == this.packPriceCents &&
          other.cigarettesPerPack == this.cigarettesPerPack &&
          other.baselineCigsPerDay == this.baselineCigsPerDay &&
          other.currencyCode == this.currencyCode &&
          other.startedAt == this.startedAt &&
          other.onboardingDone == this.onboardingDone &&
          other.currentTargetSeconds == this.currentTargetSeconds &&
          other.lastProposalAt == this.lastProposalAt &&
          other.growthPermille == this.growthPermille);
}

class AppSettingsRowsCompanion extends UpdateCompanion<AppSettingsRow> {
  final Value<int> id;
  final Value<int> packPriceCents;
  final Value<int> cigarettesPerPack;
  final Value<int> baselineCigsPerDay;
  final Value<String> currencyCode;
  final Value<DateTime> startedAt;
  final Value<bool> onboardingDone;
  final Value<int?> currentTargetSeconds;
  final Value<DateTime?> lastProposalAt;
  final Value<int> growthPermille;
  const AppSettingsRowsCompanion({
    this.id = const Value.absent(),
    this.packPriceCents = const Value.absent(),
    this.cigarettesPerPack = const Value.absent(),
    this.baselineCigsPerDay = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.onboardingDone = const Value.absent(),
    this.currentTargetSeconds = const Value.absent(),
    this.lastProposalAt = const Value.absent(),
    this.growthPermille = const Value.absent(),
  });
  AppSettingsRowsCompanion.insert({
    this.id = const Value.absent(),
    required int packPriceCents,
    required int cigarettesPerPack,
    required int baselineCigsPerDay,
    this.currencyCode = const Value.absent(),
    required DateTime startedAt,
    this.onboardingDone = const Value.absent(),
    this.currentTargetSeconds = const Value.absent(),
    this.lastProposalAt = const Value.absent(),
    this.growthPermille = const Value.absent(),
  }) : packPriceCents = Value(packPriceCents),
       cigarettesPerPack = Value(cigarettesPerPack),
       baselineCigsPerDay = Value(baselineCigsPerDay),
       startedAt = Value(startedAt);
  static Insertable<AppSettingsRow> custom({
    Expression<int>? id,
    Expression<int>? packPriceCents,
    Expression<int>? cigarettesPerPack,
    Expression<int>? baselineCigsPerDay,
    Expression<String>? currencyCode,
    Expression<DateTime>? startedAt,
    Expression<bool>? onboardingDone,
    Expression<int>? currentTargetSeconds,
    Expression<DateTime>? lastProposalAt,
    Expression<int>? growthPermille,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packPriceCents != null) 'pack_price_cents': packPriceCents,
      if (cigarettesPerPack != null) 'cigarettes_per_pack': cigarettesPerPack,
      if (baselineCigsPerDay != null)
        'baseline_cigs_per_day': baselineCigsPerDay,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (startedAt != null) 'started_at': startedAt,
      if (onboardingDone != null) 'onboarding_done': onboardingDone,
      if (currentTargetSeconds != null)
        'current_target_seconds': currentTargetSeconds,
      if (lastProposalAt != null) 'last_proposal_at': lastProposalAt,
      if (growthPermille != null) 'growth_permille': growthPermille,
    });
  }

  AppSettingsRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? packPriceCents,
    Value<int>? cigarettesPerPack,
    Value<int>? baselineCigsPerDay,
    Value<String>? currencyCode,
    Value<DateTime>? startedAt,
    Value<bool>? onboardingDone,
    Value<int?>? currentTargetSeconds,
    Value<DateTime?>? lastProposalAt,
    Value<int>? growthPermille,
  }) {
    return AppSettingsRowsCompanion(
      id: id ?? this.id,
      packPriceCents: packPriceCents ?? this.packPriceCents,
      cigarettesPerPack: cigarettesPerPack ?? this.cigarettesPerPack,
      baselineCigsPerDay: baselineCigsPerDay ?? this.baselineCigsPerDay,
      currencyCode: currencyCode ?? this.currencyCode,
      startedAt: startedAt ?? this.startedAt,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      currentTargetSeconds: currentTargetSeconds ?? this.currentTargetSeconds,
      lastProposalAt: lastProposalAt ?? this.lastProposalAt,
      growthPermille: growthPermille ?? this.growthPermille,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packPriceCents.present) {
      map['pack_price_cents'] = Variable<int>(packPriceCents.value);
    }
    if (cigarettesPerPack.present) {
      map['cigarettes_per_pack'] = Variable<int>(cigarettesPerPack.value);
    }
    if (baselineCigsPerDay.present) {
      map['baseline_cigs_per_day'] = Variable<int>(baselineCigsPerDay.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (onboardingDone.present) {
      map['onboarding_done'] = Variable<bool>(onboardingDone.value);
    }
    if (currentTargetSeconds.present) {
      map['current_target_seconds'] = Variable<int>(currentTargetSeconds.value);
    }
    if (lastProposalAt.present) {
      map['last_proposal_at'] = Variable<DateTime>(lastProposalAt.value);
    }
    if (growthPermille.present) {
      map['growth_permille'] = Variable<int>(growthPermille.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRowsCompanion(')
          ..write('id: $id, ')
          ..write('packPriceCents: $packPriceCents, ')
          ..write('cigarettesPerPack: $cigarettesPerPack, ')
          ..write('baselineCigsPerDay: $baselineCigsPerDay, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('startedAt: $startedAt, ')
          ..write('onboardingDone: $onboardingDone, ')
          ..write('currentTargetSeconds: $currentTargetSeconds, ')
          ..write('lastProposalAt: $lastProposalAt, ')
          ..write('growthPermille: $growthPermille')
          ..write(')'))
        .toString();
  }
}

class $SituationsTable extends Situations
    with TableInfo<$SituationsTable, Situation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SituationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    isBuiltIn,
    sortOrder,
    createdAt,
    archivedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'situations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Situation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Situation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Situation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
    );
  }

  @override
  $SituationsTable createAlias(String alias) {
    return $SituationsTable(attachedDatabase, alias);
  }
}

class Situation extends DataClass implements Insertable<Situation> {
  final String id;
  final String label;
  final bool isBuiltIn;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? archivedAt;
  const Situation({
    required this.id,
    required this.label,
    required this.isBuiltIn,
    required this.sortOrder,
    required this.createdAt,
    this.archivedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  SituationsCompanion toCompanion(bool nullToAbsent) {
    return SituationsCompanion(
      id: Value(id),
      label: Value(label),
      isBuiltIn: Value(isBuiltIn),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Situation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Situation(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Situation copyWith({
    String? id,
    String? label,
    bool? isBuiltIn,
    int? sortOrder,
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
  }) => Situation(
    id: id ?? this.id,
    label: label ?? this.label,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
  );
  Situation copyWithCompanion(SituationsCompanion data) {
    return Situation(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Situation(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, label, isBuiltIn, sortOrder, createdAt, archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Situation &&
          other.id == this.id &&
          other.label == this.label &&
          other.isBuiltIn == this.isBuiltIn &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt);
}

class SituationsCompanion extends UpdateCompanion<Situation> {
  final Value<String> id;
  final Value<String> label;
  final Value<bool> isBuiltIn;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const SituationsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SituationsCompanion.insert({
    required String id,
    required String label,
    this.isBuiltIn = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label),
       createdAt = Value(createdAt);
  static Insertable<Situation> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<bool>? isBuiltIn,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SituationsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<bool>? isBuiltIn,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
    Value<int>? rowid,
  }) {
    return SituationsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SituationsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PitStopsTable extends PitStops with TableInfo<$PitStopsTable, PitStop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PitStopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cravingLevelMeta = const VerificationMeta(
    'cravingLevel',
  );
  @override
  late final GeneratedColumn<int> cravingLevel = GeneratedColumn<int>(
    'craving_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stressLevelMeta = const VerificationMeta(
    'stressLevel',
  );
  @override
  late final GeneratedColumn<int> stressLevel = GeneratedColumn<int>(
    'stress_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _situationIdMeta = const VerificationMeta(
    'situationId',
  );
  @override
  late final GeneratedColumn<String> situationId = GeneratedColumn<String>(
    'situation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES situations (id)',
    ),
  );
  static const VerificationMeta _wasEarlyPitMeta = const VerificationMeta(
    'wasEarlyPit',
  );
  @override
  late final GeneratedColumn<bool> wasEarlyPit = GeneratedColumn<bool>(
    'was_early_pit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("was_early_pit" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _targetIntervalSecondsMeta =
      const VerificationMeta('targetIntervalSeconds');
  @override
  late final GeneratedColumn<int> targetIntervalSeconds = GeneratedColumn<int>(
    'target_interval_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occurredAt,
    cravingLevel,
    stressLevel,
    situationId,
    wasEarlyPit,
    targetIntervalSeconds,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pit_stops';
  @override
  VerificationContext validateIntegrity(
    Insertable<PitStop> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('craving_level')) {
      context.handle(
        _cravingLevelMeta,
        cravingLevel.isAcceptableOrUnknown(
          data['craving_level']!,
          _cravingLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cravingLevelMeta);
    }
    if (data.containsKey('stress_level')) {
      context.handle(
        _stressLevelMeta,
        stressLevel.isAcceptableOrUnknown(
          data['stress_level']!,
          _stressLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_stressLevelMeta);
    }
    if (data.containsKey('situation_id')) {
      context.handle(
        _situationIdMeta,
        situationId.isAcceptableOrUnknown(
          data['situation_id']!,
          _situationIdMeta,
        ),
      );
    }
    if (data.containsKey('was_early_pit')) {
      context.handle(
        _wasEarlyPitMeta,
        wasEarlyPit.isAcceptableOrUnknown(
          data['was_early_pit']!,
          _wasEarlyPitMeta,
        ),
      );
    }
    if (data.containsKey('target_interval_seconds')) {
      context.handle(
        _targetIntervalSecondsMeta,
        targetIntervalSeconds.isAcceptableOrUnknown(
          data['target_interval_seconds']!,
          _targetIntervalSecondsMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PitStop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PitStop(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      cravingLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}craving_level'],
      )!,
      stressLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stress_level'],
      )!,
      situationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}situation_id'],
      ),
      wasEarlyPit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}was_early_pit'],
      )!,
      targetIntervalSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_interval_seconds'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $PitStopsTable createAlias(String alias) {
    return $PitStopsTable(attachedDatabase, alias);
  }
}

class PitStop extends DataClass implements Insertable<PitStop> {
  final String id;
  final DateTime occurredAt;
  final int cravingLevel;
  final int stressLevel;
  final String? situationId;

  /// True when fired while a countdown was still running (an early box stop).
  final bool wasEarlyPit;

  /// The active target stint (seconds) at the moment of this pit stop.
  final int? targetIntervalSeconds;
  final String? note;
  const PitStop({
    required this.id,
    required this.occurredAt,
    required this.cravingLevel,
    required this.stressLevel,
    this.situationId,
    required this.wasEarlyPit,
    this.targetIntervalSeconds,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['craving_level'] = Variable<int>(cravingLevel);
    map['stress_level'] = Variable<int>(stressLevel);
    if (!nullToAbsent || situationId != null) {
      map['situation_id'] = Variable<String>(situationId);
    }
    map['was_early_pit'] = Variable<bool>(wasEarlyPit);
    if (!nullToAbsent || targetIntervalSeconds != null) {
      map['target_interval_seconds'] = Variable<int>(targetIntervalSeconds);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  PitStopsCompanion toCompanion(bool nullToAbsent) {
    return PitStopsCompanion(
      id: Value(id),
      occurredAt: Value(occurredAt),
      cravingLevel: Value(cravingLevel),
      stressLevel: Value(stressLevel),
      situationId: situationId == null && nullToAbsent
          ? const Value.absent()
          : Value(situationId),
      wasEarlyPit: Value(wasEarlyPit),
      targetIntervalSeconds: targetIntervalSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(targetIntervalSeconds),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory PitStop.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PitStop(
      id: serializer.fromJson<String>(json['id']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      cravingLevel: serializer.fromJson<int>(json['cravingLevel']),
      stressLevel: serializer.fromJson<int>(json['stressLevel']),
      situationId: serializer.fromJson<String?>(json['situationId']),
      wasEarlyPit: serializer.fromJson<bool>(json['wasEarlyPit']),
      targetIntervalSeconds: serializer.fromJson<int?>(
        json['targetIntervalSeconds'],
      ),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'cravingLevel': serializer.toJson<int>(cravingLevel),
      'stressLevel': serializer.toJson<int>(stressLevel),
      'situationId': serializer.toJson<String?>(situationId),
      'wasEarlyPit': serializer.toJson<bool>(wasEarlyPit),
      'targetIntervalSeconds': serializer.toJson<int?>(targetIntervalSeconds),
      'note': serializer.toJson<String?>(note),
    };
  }

  PitStop copyWith({
    String? id,
    DateTime? occurredAt,
    int? cravingLevel,
    int? stressLevel,
    Value<String?> situationId = const Value.absent(),
    bool? wasEarlyPit,
    Value<int?> targetIntervalSeconds = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => PitStop(
    id: id ?? this.id,
    occurredAt: occurredAt ?? this.occurredAt,
    cravingLevel: cravingLevel ?? this.cravingLevel,
    stressLevel: stressLevel ?? this.stressLevel,
    situationId: situationId.present ? situationId.value : this.situationId,
    wasEarlyPit: wasEarlyPit ?? this.wasEarlyPit,
    targetIntervalSeconds: targetIntervalSeconds.present
        ? targetIntervalSeconds.value
        : this.targetIntervalSeconds,
    note: note.present ? note.value : this.note,
  );
  PitStop copyWithCompanion(PitStopsCompanion data) {
    return PitStop(
      id: data.id.present ? data.id.value : this.id,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      cravingLevel: data.cravingLevel.present
          ? data.cravingLevel.value
          : this.cravingLevel,
      stressLevel: data.stressLevel.present
          ? data.stressLevel.value
          : this.stressLevel,
      situationId: data.situationId.present
          ? data.situationId.value
          : this.situationId,
      wasEarlyPit: data.wasEarlyPit.present
          ? data.wasEarlyPit.value
          : this.wasEarlyPit,
      targetIntervalSeconds: data.targetIntervalSeconds.present
          ? data.targetIntervalSeconds.value
          : this.targetIntervalSeconds,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PitStop(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('cravingLevel: $cravingLevel, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('situationId: $situationId, ')
          ..write('wasEarlyPit: $wasEarlyPit, ')
          ..write('targetIntervalSeconds: $targetIntervalSeconds, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    occurredAt,
    cravingLevel,
    stressLevel,
    situationId,
    wasEarlyPit,
    targetIntervalSeconds,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PitStop &&
          other.id == this.id &&
          other.occurredAt == this.occurredAt &&
          other.cravingLevel == this.cravingLevel &&
          other.stressLevel == this.stressLevel &&
          other.situationId == this.situationId &&
          other.wasEarlyPit == this.wasEarlyPit &&
          other.targetIntervalSeconds == this.targetIntervalSeconds &&
          other.note == this.note);
}

class PitStopsCompanion extends UpdateCompanion<PitStop> {
  final Value<String> id;
  final Value<DateTime> occurredAt;
  final Value<int> cravingLevel;
  final Value<int> stressLevel;
  final Value<String?> situationId;
  final Value<bool> wasEarlyPit;
  final Value<int?> targetIntervalSeconds;
  final Value<String?> note;
  final Value<int> rowid;
  const PitStopsCompanion({
    this.id = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.cravingLevel = const Value.absent(),
    this.stressLevel = const Value.absent(),
    this.situationId = const Value.absent(),
    this.wasEarlyPit = const Value.absent(),
    this.targetIntervalSeconds = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PitStopsCompanion.insert({
    required String id,
    required DateTime occurredAt,
    required int cravingLevel,
    required int stressLevel,
    this.situationId = const Value.absent(),
    this.wasEarlyPit = const Value.absent(),
    this.targetIntervalSeconds = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occurredAt = Value(occurredAt),
       cravingLevel = Value(cravingLevel),
       stressLevel = Value(stressLevel);
  static Insertable<PitStop> custom({
    Expression<String>? id,
    Expression<DateTime>? occurredAt,
    Expression<int>? cravingLevel,
    Expression<int>? stressLevel,
    Expression<String>? situationId,
    Expression<bool>? wasEarlyPit,
    Expression<int>? targetIntervalSeconds,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (cravingLevel != null) 'craving_level': cravingLevel,
      if (stressLevel != null) 'stress_level': stressLevel,
      if (situationId != null) 'situation_id': situationId,
      if (wasEarlyPit != null) 'was_early_pit': wasEarlyPit,
      if (targetIntervalSeconds != null)
        'target_interval_seconds': targetIntervalSeconds,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PitStopsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? occurredAt,
    Value<int>? cravingLevel,
    Value<int>? stressLevel,
    Value<String?>? situationId,
    Value<bool>? wasEarlyPit,
    Value<int?>? targetIntervalSeconds,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return PitStopsCompanion(
      id: id ?? this.id,
      occurredAt: occurredAt ?? this.occurredAt,
      cravingLevel: cravingLevel ?? this.cravingLevel,
      stressLevel: stressLevel ?? this.stressLevel,
      situationId: situationId ?? this.situationId,
      wasEarlyPit: wasEarlyPit ?? this.wasEarlyPit,
      targetIntervalSeconds:
          targetIntervalSeconds ?? this.targetIntervalSeconds,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (cravingLevel.present) {
      map['craving_level'] = Variable<int>(cravingLevel.value);
    }
    if (stressLevel.present) {
      map['stress_level'] = Variable<int>(stressLevel.value);
    }
    if (situationId.present) {
      map['situation_id'] = Variable<String>(situationId.value);
    }
    if (wasEarlyPit.present) {
      map['was_early_pit'] = Variable<bool>(wasEarlyPit.value);
    }
    if (targetIntervalSeconds.present) {
      map['target_interval_seconds'] = Variable<int>(
        targetIntervalSeconds.value,
      );
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PitStopsCompanion(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('cravingLevel: $cravingLevel, ')
          ..write('stressLevel: $stressLevel, ')
          ..write('situationId: $situationId, ')
          ..write('wasEarlyPit: $wasEarlyPit, ')
          ..write('targetIntervalSeconds: $targetIntervalSeconds, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UnlocksTable extends Unlocks with TableInfo<$UnlocksTable, Unlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _milestoneKeyMeta = const VerificationMeta(
    'milestoneKey',
  );
  @override
  late final GeneratedColumn<String> milestoneKey = GeneratedColumn<String>(
    'milestone_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedAtMeta = const VerificationMeta(
    'achievedAt',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAt = GeneratedColumn<DateTime>(
    'achieved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [milestoneKey, achievedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unlocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('milestone_key')) {
      context.handle(
        _milestoneKeyMeta,
        milestoneKey.isAcceptableOrUnknown(
          data['milestone_key']!,
          _milestoneKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_milestoneKeyMeta);
    }
    if (data.containsKey('achieved_at')) {
      context.handle(
        _achievedAtMeta,
        achievedAt.isAcceptableOrUnknown(data['achieved_at']!, _achievedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_achievedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {milestoneKey};
  @override
  Unlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unlock(
      milestoneKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}milestone_key'],
      )!,
      achievedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at'],
      )!,
    );
  }

  @override
  $UnlocksTable createAlias(String alias) {
    return $UnlocksTable(attachedDatabase, alias);
  }
}

class Unlock extends DataClass implements Insertable<Unlock> {
  final String milestoneKey;
  final DateTime achievedAt;
  const Unlock({required this.milestoneKey, required this.achievedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['milestone_key'] = Variable<String>(milestoneKey);
    map['achieved_at'] = Variable<DateTime>(achievedAt);
    return map;
  }

  UnlocksCompanion toCompanion(bool nullToAbsent) {
    return UnlocksCompanion(
      milestoneKey: Value(milestoneKey),
      achievedAt: Value(achievedAt),
    );
  }

  factory Unlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unlock(
      milestoneKey: serializer.fromJson<String>(json['milestoneKey']),
      achievedAt: serializer.fromJson<DateTime>(json['achievedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'milestoneKey': serializer.toJson<String>(milestoneKey),
      'achievedAt': serializer.toJson<DateTime>(achievedAt),
    };
  }

  Unlock copyWith({String? milestoneKey, DateTime? achievedAt}) => Unlock(
    milestoneKey: milestoneKey ?? this.milestoneKey,
    achievedAt: achievedAt ?? this.achievedAt,
  );
  Unlock copyWithCompanion(UnlocksCompanion data) {
    return Unlock(
      milestoneKey: data.milestoneKey.present
          ? data.milestoneKey.value
          : this.milestoneKey,
      achievedAt: data.achievedAt.present
          ? data.achievedAt.value
          : this.achievedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unlock(')
          ..write('milestoneKey: $milestoneKey, ')
          ..write('achievedAt: $achievedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(milestoneKey, achievedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unlock &&
          other.milestoneKey == this.milestoneKey &&
          other.achievedAt == this.achievedAt);
}

class UnlocksCompanion extends UpdateCompanion<Unlock> {
  final Value<String> milestoneKey;
  final Value<DateTime> achievedAt;
  final Value<int> rowid;
  const UnlocksCompanion({
    this.milestoneKey = const Value.absent(),
    this.achievedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UnlocksCompanion.insert({
    required String milestoneKey,
    required DateTime achievedAt,
    this.rowid = const Value.absent(),
  }) : milestoneKey = Value(milestoneKey),
       achievedAt = Value(achievedAt);
  static Insertable<Unlock> custom({
    Expression<String>? milestoneKey,
    Expression<DateTime>? achievedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (milestoneKey != null) 'milestone_key': milestoneKey,
      if (achievedAt != null) 'achieved_at': achievedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UnlocksCompanion copyWith({
    Value<String>? milestoneKey,
    Value<DateTime>? achievedAt,
    Value<int>? rowid,
  }) {
    return UnlocksCompanion(
      milestoneKey: milestoneKey ?? this.milestoneKey,
      achievedAt: achievedAt ?? this.achievedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (milestoneKey.present) {
      map['milestone_key'] = Variable<String>(milestoneKey.value);
    }
    if (achievedAt.present) {
      map['achieved_at'] = Variable<DateTime>(achievedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnlocksCompanion(')
          ..write('milestoneKey: $milestoneKey, ')
          ..write('achievedAt: $achievedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsRowsTable appSettingsRows = $AppSettingsRowsTable(
    this,
  );
  late final $SituationsTable situations = $SituationsTable(this);
  late final $PitStopsTable pitStops = $PitStopsTable(this);
  late final $UnlocksTable unlocks = $UnlocksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettingsRows,
    situations,
    pitStops,
    unlocks,
  ];
}

typedef $$AppSettingsRowsTableCreateCompanionBuilder =
    AppSettingsRowsCompanion Function({
      Value<int> id,
      required int packPriceCents,
      required int cigarettesPerPack,
      required int baselineCigsPerDay,
      Value<String> currencyCode,
      required DateTime startedAt,
      Value<bool> onboardingDone,
      Value<int?> currentTargetSeconds,
      Value<DateTime?> lastProposalAt,
      Value<int> growthPermille,
    });
typedef $$AppSettingsRowsTableUpdateCompanionBuilder =
    AppSettingsRowsCompanion Function({
      Value<int> id,
      Value<int> packPriceCents,
      Value<int> cigarettesPerPack,
      Value<int> baselineCigsPerDay,
      Value<String> currencyCode,
      Value<DateTime> startedAt,
      Value<bool> onboardingDone,
      Value<int?> currentTargetSeconds,
      Value<DateTime?> lastProposalAt,
      Value<int> growthPermille,
    });

class $$AppSettingsRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packPriceCents => $composableBuilder(
    column: $table.packPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cigarettesPerPack => $composableBuilder(
    column: $table.cigarettesPerPack,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baselineCigsPerDay => $composableBuilder(
    column: $table.baselineCigsPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentTargetSeconds => $composableBuilder(
    column: $table.currentTargetSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastProposalAt => $composableBuilder(
    column: $table.lastProposalAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get growthPermille => $composableBuilder(
    column: $table.growthPermille,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packPriceCents => $composableBuilder(
    column: $table.packPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cigarettesPerPack => $composableBuilder(
    column: $table.cigarettesPerPack,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baselineCigsPerDay => $composableBuilder(
    column: $table.baselineCigsPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentTargetSeconds => $composableBuilder(
    column: $table.currentTargetSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastProposalAt => $composableBuilder(
    column: $table.lastProposalAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get growthPermille => $composableBuilder(
    column: $table.growthPermille,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get packPriceCents => $composableBuilder(
    column: $table.packPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cigarettesPerPack => $composableBuilder(
    column: $table.cigarettesPerPack,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baselineCigsPerDay => $composableBuilder(
    column: $table.baselineCigsPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<bool> get onboardingDone => $composableBuilder(
    column: $table.onboardingDone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentTargetSeconds => $composableBuilder(
    column: $table.currentTargetSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastProposalAt => $composableBuilder(
    column: $table.lastProposalAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get growthPermille => $composableBuilder(
    column: $table.growthPermille,
    builder: (column) => column,
  );
}

class $$AppSettingsRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsRowsTable,
          AppSettingsRow,
          $$AppSettingsRowsTableFilterComposer,
          $$AppSettingsRowsTableOrderingComposer,
          $$AppSettingsRowsTableAnnotationComposer,
          $$AppSettingsRowsTableCreateCompanionBuilder,
          $$AppSettingsRowsTableUpdateCompanionBuilder,
          (
            AppSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsRowsTable,
              AppSettingsRow
            >,
          ),
          AppSettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsRowsTableTableManager(
    _$AppDatabase db,
    $AppSettingsRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> packPriceCents = const Value.absent(),
                Value<int> cigarettesPerPack = const Value.absent(),
                Value<int> baselineCigsPerDay = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<bool> onboardingDone = const Value.absent(),
                Value<int?> currentTargetSeconds = const Value.absent(),
                Value<DateTime?> lastProposalAt = const Value.absent(),
                Value<int> growthPermille = const Value.absent(),
              }) => AppSettingsRowsCompanion(
                id: id,
                packPriceCents: packPriceCents,
                cigarettesPerPack: cigarettesPerPack,
                baselineCigsPerDay: baselineCigsPerDay,
                currencyCode: currencyCode,
                startedAt: startedAt,
                onboardingDone: onboardingDone,
                currentTargetSeconds: currentTargetSeconds,
                lastProposalAt: lastProposalAt,
                growthPermille: growthPermille,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int packPriceCents,
                required int cigarettesPerPack,
                required int baselineCigsPerDay,
                Value<String> currencyCode = const Value.absent(),
                required DateTime startedAt,
                Value<bool> onboardingDone = const Value.absent(),
                Value<int?> currentTargetSeconds = const Value.absent(),
                Value<DateTime?> lastProposalAt = const Value.absent(),
                Value<int> growthPermille = const Value.absent(),
              }) => AppSettingsRowsCompanion.insert(
                id: id,
                packPriceCents: packPriceCents,
                cigarettesPerPack: cigarettesPerPack,
                baselineCigsPerDay: baselineCigsPerDay,
                currencyCode: currencyCode,
                startedAt: startedAt,
                onboardingDone: onboardingDone,
                currentTargetSeconds: currentTargetSeconds,
                lastProposalAt: lastProposalAt,
                growthPermille: growthPermille,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsRowsTable,
      AppSettingsRow,
      $$AppSettingsRowsTableFilterComposer,
      $$AppSettingsRowsTableOrderingComposer,
      $$AppSettingsRowsTableAnnotationComposer,
      $$AppSettingsRowsTableCreateCompanionBuilder,
      $$AppSettingsRowsTableUpdateCompanionBuilder,
      (
        AppSettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsRowsTable, AppSettingsRow>,
      ),
      AppSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$SituationsTableCreateCompanionBuilder =
    SituationsCompanion Function({
      required String id,
      required String label,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });
typedef $$SituationsTableUpdateCompanionBuilder =
    SituationsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<bool> isBuiltIn,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime?> archivedAt,
      Value<int> rowid,
    });

final class $$SituationsTableReferences
    extends BaseReferences<_$AppDatabase, $SituationsTable, Situation> {
  $$SituationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PitStopsTable, List<PitStop>> _pitStopsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.pitStops,
    aliasName: $_aliasNameGenerator(db.situations.id, db.pitStops.situationId),
  );

  $$PitStopsTableProcessedTableManager get pitStopsRefs {
    final manager = $$PitStopsTableTableManager(
      $_db,
      $_db.pitStops,
    ).filter((f) => f.situationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pitStopsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SituationsTableFilterComposer
    extends Composer<_$AppDatabase, $SituationsTable> {
  $$SituationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> pitStopsRefs(
    Expression<bool> Function($$PitStopsTableFilterComposer f) f,
  ) {
    final $$PitStopsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pitStops,
      getReferencedColumn: (t) => t.situationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PitStopsTableFilterComposer(
            $db: $db,
            $table: $db.pitStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SituationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SituationsTable> {
  $$SituationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SituationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SituationsTable> {
  $$SituationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  Expression<T> pitStopsRefs<T extends Object>(
    Expression<T> Function($$PitStopsTableAnnotationComposer a) f,
  ) {
    final $$PitStopsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pitStops,
      getReferencedColumn: (t) => t.situationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PitStopsTableAnnotationComposer(
            $db: $db,
            $table: $db.pitStops,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SituationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SituationsTable,
          Situation,
          $$SituationsTableFilterComposer,
          $$SituationsTableOrderingComposer,
          $$SituationsTableAnnotationComposer,
          $$SituationsTableCreateCompanionBuilder,
          $$SituationsTableUpdateCompanionBuilder,
          (Situation, $$SituationsTableReferences),
          Situation,
          PrefetchHooks Function({bool pitStopsRefs})
        > {
  $$SituationsTableTableManager(_$AppDatabase db, $SituationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SituationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SituationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SituationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SituationsCompanion(
                id: id,
                label: label,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                Value<bool> isBuiltIn = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SituationsCompanion.insert(
                id: id,
                label: label,
                isBuiltIn: isBuiltIn,
                sortOrder: sortOrder,
                createdAt: createdAt,
                archivedAt: archivedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SituationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({pitStopsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (pitStopsRefs) db.pitStops],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (pitStopsRefs)
                    await $_getPrefetchedData<
                      Situation,
                      $SituationsTable,
                      PitStop
                    >(
                      currentTable: table,
                      referencedTable: $$SituationsTableReferences
                          ._pitStopsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SituationsTableReferences(
                            db,
                            table,
                            p0,
                          ).pitStopsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.situationId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SituationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SituationsTable,
      Situation,
      $$SituationsTableFilterComposer,
      $$SituationsTableOrderingComposer,
      $$SituationsTableAnnotationComposer,
      $$SituationsTableCreateCompanionBuilder,
      $$SituationsTableUpdateCompanionBuilder,
      (Situation, $$SituationsTableReferences),
      Situation,
      PrefetchHooks Function({bool pitStopsRefs})
    >;
typedef $$PitStopsTableCreateCompanionBuilder =
    PitStopsCompanion Function({
      required String id,
      required DateTime occurredAt,
      required int cravingLevel,
      required int stressLevel,
      Value<String?> situationId,
      Value<bool> wasEarlyPit,
      Value<int?> targetIntervalSeconds,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$PitStopsTableUpdateCompanionBuilder =
    PitStopsCompanion Function({
      Value<String> id,
      Value<DateTime> occurredAt,
      Value<int> cravingLevel,
      Value<int> stressLevel,
      Value<String?> situationId,
      Value<bool> wasEarlyPit,
      Value<int?> targetIntervalSeconds,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$PitStopsTableReferences
    extends BaseReferences<_$AppDatabase, $PitStopsTable, PitStop> {
  $$PitStopsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SituationsTable _situationIdTable(_$AppDatabase db) =>
      db.situations.createAlias(
        $_aliasNameGenerator(db.pitStops.situationId, db.situations.id),
      );

  $$SituationsTableProcessedTableManager? get situationId {
    final $_column = $_itemColumn<String>('situation_id');
    if ($_column == null) return null;
    final manager = $$SituationsTableTableManager(
      $_db,
      $_db.situations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_situationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PitStopsTableFilterComposer
    extends Composer<_$AppDatabase, $PitStopsTable> {
  $$PitStopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cravingLevel => $composableBuilder(
    column: $table.cravingLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get wasEarlyPit => $composableBuilder(
    column: $table.wasEarlyPit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetIntervalSeconds => $composableBuilder(
    column: $table.targetIntervalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$SituationsTableFilterComposer get situationId {
    final $$SituationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.situationId,
      referencedTable: $db.situations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SituationsTableFilterComposer(
            $db: $db,
            $table: $db.situations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PitStopsTableOrderingComposer
    extends Composer<_$AppDatabase, $PitStopsTable> {
  $$PitStopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cravingLevel => $composableBuilder(
    column: $table.cravingLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get wasEarlyPit => $composableBuilder(
    column: $table.wasEarlyPit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetIntervalSeconds => $composableBuilder(
    column: $table.targetIntervalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$SituationsTableOrderingComposer get situationId {
    final $$SituationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.situationId,
      referencedTable: $db.situations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SituationsTableOrderingComposer(
            $db: $db,
            $table: $db.situations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PitStopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PitStopsTable> {
  $$PitStopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cravingLevel => $composableBuilder(
    column: $table.cravingLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get stressLevel => $composableBuilder(
    column: $table.stressLevel,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get wasEarlyPit => $composableBuilder(
    column: $table.wasEarlyPit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetIntervalSeconds => $composableBuilder(
    column: $table.targetIntervalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$SituationsTableAnnotationComposer get situationId {
    final $$SituationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.situationId,
      referencedTable: $db.situations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SituationsTableAnnotationComposer(
            $db: $db,
            $table: $db.situations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PitStopsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PitStopsTable,
          PitStop,
          $$PitStopsTableFilterComposer,
          $$PitStopsTableOrderingComposer,
          $$PitStopsTableAnnotationComposer,
          $$PitStopsTableCreateCompanionBuilder,
          $$PitStopsTableUpdateCompanionBuilder,
          (PitStop, $$PitStopsTableReferences),
          PitStop,
          PrefetchHooks Function({bool situationId})
        > {
  $$PitStopsTableTableManager(_$AppDatabase db, $PitStopsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PitStopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PitStopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PitStopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<int> cravingLevel = const Value.absent(),
                Value<int> stressLevel = const Value.absent(),
                Value<String?> situationId = const Value.absent(),
                Value<bool> wasEarlyPit = const Value.absent(),
                Value<int?> targetIntervalSeconds = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PitStopsCompanion(
                id: id,
                occurredAt: occurredAt,
                cravingLevel: cravingLevel,
                stressLevel: stressLevel,
                situationId: situationId,
                wasEarlyPit: wasEarlyPit,
                targetIntervalSeconds: targetIntervalSeconds,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime occurredAt,
                required int cravingLevel,
                required int stressLevel,
                Value<String?> situationId = const Value.absent(),
                Value<bool> wasEarlyPit = const Value.absent(),
                Value<int?> targetIntervalSeconds = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PitStopsCompanion.insert(
                id: id,
                occurredAt: occurredAt,
                cravingLevel: cravingLevel,
                stressLevel: stressLevel,
                situationId: situationId,
                wasEarlyPit: wasEarlyPit,
                targetIntervalSeconds: targetIntervalSeconds,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PitStopsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({situationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (situationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.situationId,
                                referencedTable: $$PitStopsTableReferences
                                    ._situationIdTable(db),
                                referencedColumn: $$PitStopsTableReferences
                                    ._situationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PitStopsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PitStopsTable,
      PitStop,
      $$PitStopsTableFilterComposer,
      $$PitStopsTableOrderingComposer,
      $$PitStopsTableAnnotationComposer,
      $$PitStopsTableCreateCompanionBuilder,
      $$PitStopsTableUpdateCompanionBuilder,
      (PitStop, $$PitStopsTableReferences),
      PitStop,
      PrefetchHooks Function({bool situationId})
    >;
typedef $$UnlocksTableCreateCompanionBuilder =
    UnlocksCompanion Function({
      required String milestoneKey,
      required DateTime achievedAt,
      Value<int> rowid,
    });
typedef $$UnlocksTableUpdateCompanionBuilder =
    UnlocksCompanion Function({
      Value<String> milestoneKey,
      Value<DateTime> achievedAt,
      Value<int> rowid,
    });

class $$UnlocksTableFilterComposer
    extends Composer<_$AppDatabase, $UnlocksTable> {
  $$UnlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get milestoneKey => $composableBuilder(
    column: $table.milestoneKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $UnlocksTable> {
  $$UnlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get milestoneKey => $composableBuilder(
    column: $table.milestoneKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnlocksTable> {
  $$UnlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get milestoneKey => $composableBuilder(
    column: $table.milestoneKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get achievedAt => $composableBuilder(
    column: $table.achievedAt,
    builder: (column) => column,
  );
}

class $$UnlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnlocksTable,
          Unlock,
          $$UnlocksTableFilterComposer,
          $$UnlocksTableOrderingComposer,
          $$UnlocksTableAnnotationComposer,
          $$UnlocksTableCreateCompanionBuilder,
          $$UnlocksTableUpdateCompanionBuilder,
          (Unlock, BaseReferences<_$AppDatabase, $UnlocksTable, Unlock>),
          Unlock,
          PrefetchHooks Function()
        > {
  $$UnlocksTableTableManager(_$AppDatabase db, $UnlocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> milestoneKey = const Value.absent(),
                Value<DateTime> achievedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UnlocksCompanion(
                milestoneKey: milestoneKey,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String milestoneKey,
                required DateTime achievedAt,
                Value<int> rowid = const Value.absent(),
              }) => UnlocksCompanion.insert(
                milestoneKey: milestoneKey,
                achievedAt: achievedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnlocksTable,
      Unlock,
      $$UnlocksTableFilterComposer,
      $$UnlocksTableOrderingComposer,
      $$UnlocksTableAnnotationComposer,
      $$UnlocksTableCreateCompanionBuilder,
      $$UnlocksTableUpdateCompanionBuilder,
      (Unlock, BaseReferences<_$AppDatabase, $UnlocksTable, Unlock>),
      Unlock,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsRowsTableTableManager get appSettingsRows =>
      $$AppSettingsRowsTableTableManager(_db, _db.appSettingsRows);
  $$SituationsTableTableManager get situations =>
      $$SituationsTableTableManager(_db, _db.situations);
  $$PitStopsTableTableManager get pitStops =>
      $$PitStopsTableTableManager(_db, _db.pitStops);
  $$UnlocksTableTableManager get unlocks =>
      $$UnlocksTableTableManager(_db, _db.unlocks);
}
