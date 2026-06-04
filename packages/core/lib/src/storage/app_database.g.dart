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

class $QuotesTable extends Quotes with TableInfo<$QuotesTable, Quote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
      'local_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
      'server_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncActionMeta =
      const VerificationMeta('syncAction');
  @override
  late final GeneratedColumn<String> syncAction = GeneratedColumn<String>(
      'sync_action', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _loveCountMeta =
      const VerificationMeta('loveCount');
  @override
  late final GeneratedColumn<int> loveCount = GeneratedColumn<int>(
      'love_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isLovedMeta =
      const VerificationMeta('isLoved');
  @override
  late final GeneratedColumn<bool> isLoved = GeneratedColumn<bool>(
      'is_loved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_loved" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        serverId,
        content,
        author,
        source,
        isActive,
        isSynced,
        syncAction,
        createdAt,
        updatedAt,
        loveCount,
        isLoved
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotes';
  @override
  VerificationContext validateIntegrity(Insertable<Quote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('sync_action')) {
      context.handle(
          _syncActionMeta,
          syncAction.isAcceptableOrUnknown(
              data['sync_action']!, _syncActionMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('love_count')) {
      context.handle(_loveCountMeta,
          loveCount.isAcceptableOrUnknown(data['love_count']!, _loveCountMeta));
    }
    if (data.containsKey('is_loved')) {
      context.handle(_isLovedMeta,
          isLoved.isAcceptableOrUnknown(data['is_loved']!, _isLovedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  Quote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quote(
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_id']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncAction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_action']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      loveCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}love_count'])!,
      isLoved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_loved'])!,
    );
  }

  @override
  $QuotesTable createAlias(String alias) {
    return $QuotesTable(attachedDatabase, alias);
  }
}

class Quote extends DataClass implements Insertable<Quote> {
  /// Local auto-increment primary key.
  final int localId;

  /// Server-assigned ID. Null when created offline and not yet synced.
  final int? serverId;

  /// The quote text content.
  /// Named `content` to avoid shadowing Drift's `text()` method.
  final String content;

  /// The quote author name.
  final String author;

  /// Optional source of the quote (book, speech, etc.).
  final String? source;

  /// Whether the quote is active.
  final bool isActive;

  /// Whether this record has been synced with the server.
  final bool isSynced;

  /// Pending sync action: 'create', 'update', 'delete', or null.
  final String? syncAction;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Total number of users who loved this quote.
  final int loveCount;

  /// Whether the current authenticated user has loved this quote.
  final bool isLoved;
  const Quote(
      {required this.localId,
      this.serverId,
      required this.content,
      required this.author,
      this.source,
      required this.isActive,
      required this.isSynced,
      this.syncAction,
      this.createdAt,
      this.updatedAt,
      required this.loveCount,
      required this.isLoved});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['content'] = Variable<String>(content);
    map['author'] = Variable<String>(author);
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncAction != null) {
      map['sync_action'] = Variable<String>(syncAction);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['love_count'] = Variable<int>(loveCount);
    map['is_loved'] = Variable<bool>(isLoved);
    return map;
  }

  QuotesCompanion toCompanion(bool nullToAbsent) {
    return QuotesCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      content: Value(content),
      author: Value(author),
      source:
          source == null && nullToAbsent ? const Value.absent() : Value(source),
      isActive: Value(isActive),
      isSynced: Value(isSynced),
      syncAction: syncAction == null && nullToAbsent
          ? const Value.absent()
          : Value(syncAction),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      loveCount: Value(loveCount),
      isLoved: Value(isLoved),
    );
  }

  factory Quote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quote(
      localId: serializer.fromJson<int>(json['localId']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      content: serializer.fromJson<String>(json['content']),
      author: serializer.fromJson<String>(json['author']),
      source: serializer.fromJson<String?>(json['source']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncAction: serializer.fromJson<String?>(json['syncAction']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      loveCount: serializer.fromJson<int>(json['loveCount']),
      isLoved: serializer.fromJson<bool>(json['isLoved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'serverId': serializer.toJson<int?>(serverId),
      'content': serializer.toJson<String>(content),
      'author': serializer.toJson<String>(author),
      'source': serializer.toJson<String?>(source),
      'isActive': serializer.toJson<bool>(isActive),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncAction': serializer.toJson<String?>(syncAction),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'loveCount': serializer.toJson<int>(loveCount),
      'isLoved': serializer.toJson<bool>(isLoved),
    };
  }

  Quote copyWith(
          {int? localId,
          Value<int?> serverId = const Value.absent(),
          String? content,
          String? author,
          Value<String?> source = const Value.absent(),
          bool? isActive,
          bool? isSynced,
          Value<String?> syncAction = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          int? loveCount,
          bool? isLoved}) =>
      Quote(
        localId: localId ?? this.localId,
        serverId: serverId.present ? serverId.value : this.serverId,
        content: content ?? this.content,
        author: author ?? this.author,
        source: source.present ? source.value : this.source,
        isActive: isActive ?? this.isActive,
        isSynced: isSynced ?? this.isSynced,
        syncAction: syncAction.present ? syncAction.value : this.syncAction,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        loveCount: loveCount ?? this.loveCount,
        isLoved: isLoved ?? this.isLoved,
      );
  Quote copyWithCompanion(QuotesCompanion data) {
    return Quote(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      content: data.content.present ? data.content.value : this.content,
      author: data.author.present ? data.author.value : this.author,
      source: data.source.present ? data.source.value : this.source,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncAction:
          data.syncAction.present ? data.syncAction.value : this.syncAction,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      loveCount: data.loveCount.present ? data.loveCount.value : this.loveCount,
      isLoved: data.isLoved.present ? data.isLoved.value : this.isLoved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quote(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('content: $content, ')
          ..write('author: $author, ')
          ..write('source: $source, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncAction: $syncAction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('loveCount: $loveCount, ')
          ..write('isLoved: $isLoved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localId, serverId, content, author, source,
      isActive, isSynced, syncAction, createdAt, updatedAt, loveCount, isLoved);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quote &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.content == this.content &&
          other.author == this.author &&
          other.source == this.source &&
          other.isActive == this.isActive &&
          other.isSynced == this.isSynced &&
          other.syncAction == this.syncAction &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.loveCount == this.loveCount &&
          other.isLoved == this.isLoved);
}

class QuotesCompanion extends UpdateCompanion<Quote> {
  final Value<int> localId;
  final Value<int?> serverId;
  final Value<String> content;
  final Value<String> author;
  final Value<String?> source;
  final Value<bool> isActive;
  final Value<bool> isSynced;
  final Value<String?> syncAction;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> loveCount;
  final Value<bool> isLoved;
  const QuotesCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.content = const Value.absent(),
    this.author = const Value.absent(),
    this.source = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncAction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.loveCount = const Value.absent(),
    this.isLoved = const Value.absent(),
  });
  QuotesCompanion.insert({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    required String content,
    required String author,
    this.source = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncAction = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.loveCount = const Value.absent(),
    this.isLoved = const Value.absent(),
  })  : content = Value(content),
        author = Value(author);
  static Insertable<Quote> custom({
    Expression<int>? localId,
    Expression<int>? serverId,
    Expression<String>? content,
    Expression<String>? author,
    Expression<String>? source,
    Expression<bool>? isActive,
    Expression<bool>? isSynced,
    Expression<String>? syncAction,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? loveCount,
    Expression<bool>? isLoved,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (content != null) 'content': content,
      if (author != null) 'author': author,
      if (source != null) 'source': source,
      if (isActive != null) 'is_active': isActive,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncAction != null) 'sync_action': syncAction,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (loveCount != null) 'love_count': loveCount,
      if (isLoved != null) 'is_loved': isLoved,
    });
  }

  QuotesCompanion copyWith(
      {Value<int>? localId,
      Value<int?>? serverId,
      Value<String>? content,
      Value<String>? author,
      Value<String?>? source,
      Value<bool>? isActive,
      Value<bool>? isSynced,
      Value<String?>? syncAction,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? loveCount,
      Value<bool>? isLoved}) {
    return QuotesCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      content: content ?? this.content,
      author: author ?? this.author,
      source: source ?? this.source,
      isActive: isActive ?? this.isActive,
      isSynced: isSynced ?? this.isSynced,
      syncAction: syncAction ?? this.syncAction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      loveCount: loveCount ?? this.loveCount,
      isLoved: isLoved ?? this.isLoved,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncAction.present) {
      map['sync_action'] = Variable<String>(syncAction.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (loveCount.present) {
      map['love_count'] = Variable<int>(loveCount.value);
    }
    if (isLoved.present) {
      map['is_loved'] = Variable<bool>(isLoved.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotesCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('content: $content, ')
          ..write('author: $author, ')
          ..write('source: $source, ')
          ..write('isActive: $isActive, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncAction: $syncAction, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('loveCount: $loveCount, ')
          ..write('isLoved: $isLoved')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CacheEntriesTable cacheEntries = $CacheEntriesTable(this);
  late final $QuotesTable quotes = $QuotesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cacheEntries, quotes];
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
typedef $$QuotesTableCreateCompanionBuilder = QuotesCompanion Function({
  Value<int> localId,
  Value<int?> serverId,
  required String content,
  required String author,
  Value<String?> source,
  Value<bool> isActive,
  Value<bool> isSynced,
  Value<String?> syncAction,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> loveCount,
  Value<bool> isLoved,
});
typedef $$QuotesTableUpdateCompanionBuilder = QuotesCompanion Function({
  Value<int> localId,
  Value<int?> serverId,
  Value<String> content,
  Value<String> author,
  Value<String?> source,
  Value<bool> isActive,
  Value<bool> isSynced,
  Value<String?> syncAction,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> loveCount,
  Value<bool> isLoved,
});

class $$QuotesTableFilterComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncAction => $composableBuilder(
      column: $table.syncAction, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get loveCount => $composableBuilder(
      column: $table.loveCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLoved => $composableBuilder(
      column: $table.isLoved, builder: (column) => ColumnFilters(column));
}

class $$QuotesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncAction => $composableBuilder(
      column: $table.syncAction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get loveCount => $composableBuilder(
      column: $table.loveCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLoved => $composableBuilder(
      column: $table.isLoved, builder: (column) => ColumnOrderings(column));
}

class $$QuotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get syncAction => $composableBuilder(
      column: $table.syncAction, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get loveCount =>
      $composableBuilder(column: $table.loveCount, builder: (column) => column);

  GeneratedColumn<bool> get isLoved =>
      $composableBuilder(column: $table.isLoved, builder: (column) => column);
}

class $$QuotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuotesTable,
    Quote,
    $$QuotesTableFilterComposer,
    $$QuotesTableOrderingComposer,
    $$QuotesTableAnnotationComposer,
    $$QuotesTableCreateCompanionBuilder,
    $$QuotesTableUpdateCompanionBuilder,
    (Quote, BaseReferences<_$AppDatabase, $QuotesTable, Quote>),
    Quote,
    PrefetchHooks Function()> {
  $$QuotesTableTableManager(_$AppDatabase db, $QuotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> localId = const Value.absent(),
            Value<int?> serverId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> author = const Value.absent(),
            Value<String?> source = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String?> syncAction = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> loveCount = const Value.absent(),
            Value<bool> isLoved = const Value.absent(),
          }) =>
              QuotesCompanion(
            localId: localId,
            serverId: serverId,
            content: content,
            author: author,
            source: source,
            isActive: isActive,
            isSynced: isSynced,
            syncAction: syncAction,
            createdAt: createdAt,
            updatedAt: updatedAt,
            loveCount: loveCount,
            isLoved: isLoved,
          ),
          createCompanionCallback: ({
            Value<int> localId = const Value.absent(),
            Value<int?> serverId = const Value.absent(),
            required String content,
            required String author,
            Value<String?> source = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String?> syncAction = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> loveCount = const Value.absent(),
            Value<bool> isLoved = const Value.absent(),
          }) =>
              QuotesCompanion.insert(
            localId: localId,
            serverId: serverId,
            content: content,
            author: author,
            source: source,
            isActive: isActive,
            isSynced: isSynced,
            syncAction: syncAction,
            createdAt: createdAt,
            updatedAt: updatedAt,
            loveCount: loveCount,
            isLoved: isLoved,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$QuotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $QuotesTable,
    Quote,
    $$QuotesTableFilterComposer,
    $$QuotesTableOrderingComposer,
    $$QuotesTableAnnotationComposer,
    $$QuotesTableCreateCompanionBuilder,
    $$QuotesTableUpdateCompanionBuilder,
    (Quote, BaseReferences<_$AppDatabase, $QuotesTable, Quote>),
    Quote,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CacheEntriesTableTableManager get cacheEntries =>
      $$CacheEntriesTableTableManager(_db, _db.cacheEntries);
  $$QuotesTableTableManager get quotes =>
      $$QuotesTableTableManager(_db, _db.quotes);
}
