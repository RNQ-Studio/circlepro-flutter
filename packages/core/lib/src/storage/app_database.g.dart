// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CacheEntriesTable extends CacheEntries
    with TableInfo<$CacheEntriesTable, CacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _jsonPayloadMeta =
      const VerificationMeta('jsonPayload');
  @override
  late final GeneratedColumn<String> jsonPayload = GeneratedColumn<String>(
      'json_payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _ttlSecondsMeta =
      const VerificationMeta('ttlSeconds');
  @override
  late final GeneratedColumn<int> ttlSeconds = GeneratedColumn<int>(
      'ttl_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, key, jsonPayload, createdAt, ttlSeconds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_entries';
  @override
  VerificationContext validateIntegrity(Insertable<CacheEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('json_payload')) {
      context.handle(
          _jsonPayloadMeta,
          jsonPayload.isAcceptableOrUnknown(
              data['json_payload']!, _jsonPayloadMeta));
    } else if (isInserting) {
      context.missing(_jsonPayloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('ttl_seconds')) {
      context.handle(
          _ttlSecondsMeta,
          ttlSeconds.isAcceptableOrUnknown(
              data['ttl_seconds']!, _ttlSecondsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      jsonPayload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_payload'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      ttlSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ttl_seconds']),
    );
  }

  @override
  $CacheEntriesTable createAlias(String alias) {
    return $CacheEntriesTable(attachedDatabase, alias);
  }
}

class CacheEntry extends DataClass implements Insertable<CacheEntry> {
  final int id;
  final String key;
  final String jsonPayload;
  final DateTime createdAt;

  /// TTL in seconds. Null = never expires.
  final int? ttlSeconds;
  const CacheEntry(
      {required this.id,
      required this.key,
      required this.jsonPayload,
      required this.createdAt,
      this.ttlSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['json_payload'] = Variable<String>(jsonPayload);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || ttlSeconds != null) {
      map['ttl_seconds'] = Variable<int>(ttlSeconds);
    }
    return map;
  }

  CacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return CacheEntriesCompanion(
      id: Value(id),
      key: Value(key),
      jsonPayload: Value(jsonPayload),
      createdAt: Value(createdAt),
      ttlSeconds: ttlSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(ttlSeconds),
    );
  }

  factory CacheEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheEntry(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      jsonPayload: serializer.fromJson<String>(json['jsonPayload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      ttlSeconds: serializer.fromJson<int?>(json['ttlSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'jsonPayload': serializer.toJson<String>(jsonPayload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'ttlSeconds': serializer.toJson<int?>(ttlSeconds),
    };
  }

  CacheEntry copyWith(
          {int? id,
          String? key,
          String? jsonPayload,
          DateTime? createdAt,
          Value<int?> ttlSeconds = const Value.absent()}) =>
      CacheEntry(
        id: id ?? this.id,
        key: key ?? this.key,
        jsonPayload: jsonPayload ?? this.jsonPayload,
        createdAt: createdAt ?? this.createdAt,
        ttlSeconds: ttlSeconds.present ? ttlSeconds.value : this.ttlSeconds,
      );
  CacheEntry copyWithCompanion(CacheEntriesCompanion data) {
    return CacheEntry(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      jsonPayload:
          data.jsonPayload.present ? data.jsonPayload.value : this.jsonPayload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      ttlSeconds:
          data.ttlSeconds.present ? data.ttlSeconds.value : this.ttlSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntry(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('jsonPayload: $jsonPayload, ')
          ..write('createdAt: $createdAt, ')
          ..write('ttlSeconds: $ttlSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, jsonPayload, createdAt, ttlSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheEntry &&
          other.id == this.id &&
          other.key == this.key &&
          other.jsonPayload == this.jsonPayload &&
          other.createdAt == this.createdAt &&
          other.ttlSeconds == this.ttlSeconds);
}

class CacheEntriesCompanion extends UpdateCompanion<CacheEntry> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> jsonPayload;
  final Value<DateTime> createdAt;
  final Value<int?> ttlSeconds;
  const CacheEntriesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.jsonPayload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.ttlSeconds = const Value.absent(),
  });
  CacheEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String jsonPayload,
    this.createdAt = const Value.absent(),
    this.ttlSeconds = const Value.absent(),
  })  : key = Value(key),
        jsonPayload = Value(jsonPayload);
  static Insertable<CacheEntry> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? jsonPayload,
    Expression<DateTime>? createdAt,
    Expression<int>? ttlSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (jsonPayload != null) 'json_payload': jsonPayload,
      if (createdAt != null) 'created_at': createdAt,
      if (ttlSeconds != null) 'ttl_seconds': ttlSeconds,
    });
  }

  CacheEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? key,
      Value<String>? jsonPayload,
      Value<DateTime>? createdAt,
      Value<int?>? ttlSeconds}) {
    return CacheEntriesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      jsonPayload: jsonPayload ?? this.jsonPayload,
      createdAt: createdAt ?? this.createdAt,
      ttlSeconds: ttlSeconds ?? this.ttlSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (jsonPayload.present) {
      map['json_payload'] = Variable<String>(jsonPayload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (ttlSeconds.present) {
      map['ttl_seconds'] = Variable<int>(ttlSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntriesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('jsonPayload: $jsonPayload, ')
          ..write('createdAt: $createdAt, ')
          ..write('ttlSeconds: $ttlSeconds')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CacheEntriesTable cacheEntries = $CacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cacheEntries];
}

typedef $$CacheEntriesTableCreateCompanionBuilder = CacheEntriesCompanion
    Function({
  Value<int> id,
  required String key,
  required String jsonPayload,
  Value<DateTime> createdAt,
  Value<int?> ttlSeconds,
});
typedef $$CacheEntriesTableUpdateCompanionBuilder = CacheEntriesCompanion
    Function({
  Value<int> id,
  Value<String> key,
  Value<String> jsonPayload,
  Value<DateTime> createdAt,
  Value<int?> ttlSeconds,
});

class $$CacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jsonPayload => $composableBuilder(
      column: $table.jsonPayload, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ttlSeconds => $composableBuilder(
      column: $table.ttlSeconds, builder: (column) => ColumnFilters(column));
}

class $$CacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jsonPayload => $composableBuilder(
      column: $table.jsonPayload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ttlSeconds => $composableBuilder(
      column: $table.ttlSeconds, builder: (column) => ColumnOrderings(column));
}

class $$CacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get jsonPayload => $composableBuilder(
      column: $table.jsonPayload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get ttlSeconds => $composableBuilder(
      column: $table.ttlSeconds, builder: (column) => column);
}

class $$CacheEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CacheEntriesTable,
    CacheEntry,
    $$CacheEntriesTableFilterComposer,
    $$CacheEntriesTableOrderingComposer,
    $$CacheEntriesTableAnnotationComposer,
    $$CacheEntriesTableCreateCompanionBuilder,
    $$CacheEntriesTableUpdateCompanionBuilder,
    (CacheEntry, BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>),
    CacheEntry,
    PrefetchHooks Function()> {
  $$CacheEntriesTableTableManager(_$AppDatabase db, $CacheEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> jsonPayload = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int?> ttlSeconds = const Value.absent(),
          }) =>
              CacheEntriesCompanion(
            id: id,
            key: key,
            jsonPayload: jsonPayload,
            createdAt: createdAt,
            ttlSeconds: ttlSeconds,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            required String jsonPayload,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int?> ttlSeconds = const Value.absent(),
          }) =>
              CacheEntriesCompanion.insert(
            id: id,
            key: key,
            jsonPayload: jsonPayload,
            createdAt: createdAt,
            ttlSeconds: ttlSeconds,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CacheEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CacheEntriesTable,
    CacheEntry,
    $$CacheEntriesTableFilterComposer,
    $$CacheEntriesTableOrderingComposer,
    $$CacheEntriesTableAnnotationComposer,
    $$CacheEntriesTableCreateCompanionBuilder,
    $$CacheEntriesTableUpdateCompanionBuilder,
    (CacheEntry, BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>),
    CacheEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CacheEntriesTableTableManager get cacheEntries =>
      $$CacheEntriesTableTableManager(_db, _db.cacheEntries);
}
