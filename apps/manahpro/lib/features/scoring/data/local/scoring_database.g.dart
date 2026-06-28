// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoring_database.dart';

// ignore_for_file: type=lint
class $ScoringSessionRowsTable extends ScoringSessionRows
    with TableInfo<$ScoringSessionRowsTable, ScoringSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoringSessionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clientUuidMeta =
      const VerificationMeta('clientUuid');
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
      'client_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _equipmentProfileIdMeta =
      const VerificationMeta('equipmentProfileId');
  @override
  late final GeneratedColumn<String> equipmentProfileId =
      GeneratedColumn<String>('equipment_profile_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bowClassMeta =
      const VerificationMeta('bowClass');
  @override
  late final GeneratedColumn<String> bowClass = GeneratedColumn<String>(
      'bow_class', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _distanceCategoryMeta =
      const VerificationMeta('distanceCategory');
  @override
  late final GeneratedColumn<String> distanceCategory = GeneratedColumn<String>(
      'distance_category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _distanceMMeta =
      const VerificationMeta('distanceM');
  @override
  late final GeneratedColumn<int> distanceM = GeneratedColumn<int>(
      'distance_m', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _environmentMeta =
      const VerificationMeta('environment');
  @override
  late final GeneratedColumn<String> environment = GeneratedColumn<String>(
      'environment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('outdoor'));
  static const VerificationMeta _targetFaceCmMeta =
      const VerificationMeta('targetFaceCm');
  @override
  late final GeneratedColumn<int> targetFaceCm = GeneratedColumn<int>(
      'target_face_cm', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _targetFaceIdMeta =
      const VerificationMeta('targetFaceId');
  @override
  late final GeneratedColumn<String> targetFaceId = GeneratedColumn<String>(
      'target_face_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numEndsMeta =
      const VerificationMeta('numEnds');
  @override
  late final GeneratedColumn<int> numEnds = GeneratedColumn<int>(
      'num_ends', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _arrowsPerEndMeta =
      const VerificationMeta('arrowsPerEnd');
  @override
  late final GeneratedColumn<int> arrowsPerEnd = GeneratedColumn<int>(
      'arrows_per_end', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('in_progress'));
  static const VerificationMeta _totalScoreMeta =
      const VerificationMeta('totalScore');
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
      'total_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _arrowsShotMeta =
      const VerificationMeta('arrowsShot');
  @override
  late final GeneratedColumn<int> arrowsShot = GeneratedColumn<int>(
      'arrows_shot', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _xCountMeta = const VerificationMeta('xCount');
  @override
  late final GeneratedColumn<int> xCount = GeneratedColumn<int>(
      'x_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _tenCountMeta =
      const VerificationMeta('tenCount');
  @override
  late final GeneratedColumn<int> tenCount = GeneratedColumn<int>(
      'ten_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _missCountMeta =
      const VerificationMeta('missCount');
  @override
  late final GeneratedColumn<int> missCount = GeneratedColumn<int>(
      'miss_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isPersonalBestMeta =
      const VerificationMeta('isPersonalBest');
  @override
  late final GeneratedColumn<bool> isPersonalBest = GeneratedColumn<bool>(
      'is_personal_best', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_personal_best" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('mobile'));
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
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _scoringSessionGroupIdMeta =
      const VerificationMeta('scoringSessionGroupId');
  @override
  late final GeneratedColumn<String> scoringSessionGroupId =
      GeneratedColumn<String>('scoring_session_group_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guestNameMeta =
      const VerificationMeta('guestName');
  @override
  late final GeneratedColumn<String> guestName = GeneratedColumn<String>(
      'guest_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        clientUuid,
        equipmentProfileId,
        title,
        bowClass,
        distanceCategory,
        distanceM,
        environment,
        targetFaceCm,
        targetFaceId,
        numEnds,
        arrowsPerEnd,
        status,
        totalScore,
        arrowsShot,
        xCount,
        tenCount,
        missCount,
        isPersonalBest,
        notes,
        startedAt,
        completedAt,
        source,
        isSynced,
        syncAction,
        updatedAt,
        scoringSessionGroupId,
        guestName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scoring_session_rows';
  @override
  VerificationContext validateIntegrity(Insertable<ScoringSessionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
          _clientUuidMeta,
          clientUuid.isAcceptableOrUnknown(
              data['client_uuid']!, _clientUuidMeta));
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('equipment_profile_id')) {
      context.handle(
          _equipmentProfileIdMeta,
          equipmentProfileId.isAcceptableOrUnknown(
              data['equipment_profile_id']!, _equipmentProfileIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('bow_class')) {
      context.handle(_bowClassMeta,
          bowClass.isAcceptableOrUnknown(data['bow_class']!, _bowClassMeta));
    }
    if (data.containsKey('distance_category')) {
      context.handle(
          _distanceCategoryMeta,
          distanceCategory.isAcceptableOrUnknown(
              data['distance_category']!, _distanceCategoryMeta));
    } else if (isInserting) {
      context.missing(_distanceCategoryMeta);
    }
    if (data.containsKey('distance_m')) {
      context.handle(_distanceMMeta,
          distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta));
    } else if (isInserting) {
      context.missing(_distanceMMeta);
    }
    if (data.containsKey('environment')) {
      context.handle(
          _environmentMeta,
          environment.isAcceptableOrUnknown(
              data['environment']!, _environmentMeta));
    }
    if (data.containsKey('target_face_cm')) {
      context.handle(
          _targetFaceCmMeta,
          targetFaceCm.isAcceptableOrUnknown(
              data['target_face_cm']!, _targetFaceCmMeta));
    }
    if (data.containsKey('target_face_id')) {
      context.handle(
          _targetFaceIdMeta,
          targetFaceId.isAcceptableOrUnknown(
              data['target_face_id']!, _targetFaceIdMeta));
    }
    if (data.containsKey('num_ends')) {
      context.handle(_numEndsMeta,
          numEnds.isAcceptableOrUnknown(data['num_ends']!, _numEndsMeta));
    } else if (isInserting) {
      context.missing(_numEndsMeta);
    }
    if (data.containsKey('arrows_per_end')) {
      context.handle(
          _arrowsPerEndMeta,
          arrowsPerEnd.isAcceptableOrUnknown(
              data['arrows_per_end']!, _arrowsPerEndMeta));
    } else if (isInserting) {
      context.missing(_arrowsPerEndMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('total_score')) {
      context.handle(
          _totalScoreMeta,
          totalScore.isAcceptableOrUnknown(
              data['total_score']!, _totalScoreMeta));
    }
    if (data.containsKey('arrows_shot')) {
      context.handle(
          _arrowsShotMeta,
          arrowsShot.isAcceptableOrUnknown(
              data['arrows_shot']!, _arrowsShotMeta));
    }
    if (data.containsKey('x_count')) {
      context.handle(_xCountMeta,
          xCount.isAcceptableOrUnknown(data['x_count']!, _xCountMeta));
    }
    if (data.containsKey('ten_count')) {
      context.handle(_tenCountMeta,
          tenCount.isAcceptableOrUnknown(data['ten_count']!, _tenCountMeta));
    }
    if (data.containsKey('miss_count')) {
      context.handle(_missCountMeta,
          missCount.isAcceptableOrUnknown(data['miss_count']!, _missCountMeta));
    }
    if (data.containsKey('is_personal_best')) {
      context.handle(
          _isPersonalBestMeta,
          isPersonalBest.isAcceptableOrUnknown(
              data['is_personal_best']!, _isPersonalBestMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
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
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('scoring_session_group_id')) {
      context.handle(
          _scoringSessionGroupIdMeta,
          scoringSessionGroupId.isAcceptableOrUnknown(
              data['scoring_session_group_id']!, _scoringSessionGroupIdMeta));
    }
    if (data.containsKey('guest_name')) {
      context.handle(_guestNameMeta,
          guestName.isAcceptableOrUnknown(data['guest_name']!, _guestNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScoringSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScoringSessionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      clientUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_uuid'])!,
      equipmentProfileId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}equipment_profile_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      bowClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bow_class']),
      distanceCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}distance_category'])!,
      distanceM: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}distance_m'])!,
      environment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}environment'])!,
      targetFaceCm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_face_cm']),
      targetFaceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_face_id']),
      numEnds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}num_ends'])!,
      arrowsPerEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}arrows_per_end'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      totalScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_score'])!,
      arrowsShot: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}arrows_shot'])!,
      xCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}x_count'])!,
      tenCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ten_count'])!,
      missCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}miss_count'])!,
      isPersonalBest: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_personal_best'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncAction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_action']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      scoringSessionGroupId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}scoring_session_group_id']),
      guestName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guest_name']),
    );
  }

  @override
  $ScoringSessionRowsTable createAlias(String alias) {
    return $ScoringSessionRowsTable(attachedDatabase, alias);
  }
}

class ScoringSessionRow extends DataClass
    implements Insertable<ScoringSessionRow> {
  final String id;
  final String clientUuid;
  final String? equipmentProfileId;
  final String? title;
  final String? bowClass;
  final String distanceCategory;
  final int distanceM;
  final String environment;
  final int? targetFaceCm;
  final String? targetFaceId;
  final int numEnds;
  final int arrowsPerEnd;
  final String status;
  final int totalScore;
  final int arrowsShot;
  final int xCount;
  final int tenCount;
  final int missCount;
  final bool isPersonalBest;
  final String? notes;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String source;
  final bool isSynced;

  /// Pending sync action: 'create' | 'update' | 'delete' | null.
  final String? syncAction;
  final DateTime? updatedAt;
  final String? scoringSessionGroupId;
  final String? guestName;
  const ScoringSessionRow(
      {required this.id,
      required this.clientUuid,
      this.equipmentProfileId,
      this.title,
      this.bowClass,
      required this.distanceCategory,
      required this.distanceM,
      required this.environment,
      this.targetFaceCm,
      this.targetFaceId,
      required this.numEnds,
      required this.arrowsPerEnd,
      required this.status,
      required this.totalScore,
      required this.arrowsShot,
      required this.xCount,
      required this.tenCount,
      required this.missCount,
      required this.isPersonalBest,
      this.notes,
      required this.startedAt,
      this.completedAt,
      required this.source,
      required this.isSynced,
      this.syncAction,
      this.updatedAt,
      this.scoringSessionGroupId,
      this.guestName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['client_uuid'] = Variable<String>(clientUuid);
    if (!nullToAbsent || equipmentProfileId != null) {
      map['equipment_profile_id'] = Variable<String>(equipmentProfileId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || bowClass != null) {
      map['bow_class'] = Variable<String>(bowClass);
    }
    map['distance_category'] = Variable<String>(distanceCategory);
    map['distance_m'] = Variable<int>(distanceM);
    map['environment'] = Variable<String>(environment);
    if (!nullToAbsent || targetFaceCm != null) {
      map['target_face_cm'] = Variable<int>(targetFaceCm);
    }
    if (!nullToAbsent || targetFaceId != null) {
      map['target_face_id'] = Variable<String>(targetFaceId);
    }
    map['num_ends'] = Variable<int>(numEnds);
    map['arrows_per_end'] = Variable<int>(arrowsPerEnd);
    map['status'] = Variable<String>(status);
    map['total_score'] = Variable<int>(totalScore);
    map['arrows_shot'] = Variable<int>(arrowsShot);
    map['x_count'] = Variable<int>(xCount);
    map['ten_count'] = Variable<int>(tenCount);
    map['miss_count'] = Variable<int>(missCount);
    map['is_personal_best'] = Variable<bool>(isPersonalBest);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['source'] = Variable<String>(source);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncAction != null) {
      map['sync_action'] = Variable<String>(syncAction);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    if (!nullToAbsent || scoringSessionGroupId != null) {
      map['scoring_session_group_id'] = Variable<String>(scoringSessionGroupId);
    }
    if (!nullToAbsent || guestName != null) {
      map['guest_name'] = Variable<String>(guestName);
    }
    return map;
  }

  ScoringSessionRowsCompanion toCompanion(bool nullToAbsent) {
    return ScoringSessionRowsCompanion(
      id: Value(id),
      clientUuid: Value(clientUuid),
      equipmentProfileId: equipmentProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(equipmentProfileId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      bowClass: bowClass == null && nullToAbsent
          ? const Value.absent()
          : Value(bowClass),
      distanceCategory: Value(distanceCategory),
      distanceM: Value(distanceM),
      environment: Value(environment),
      targetFaceCm: targetFaceCm == null && nullToAbsent
          ? const Value.absent()
          : Value(targetFaceCm),
      targetFaceId: targetFaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetFaceId),
      numEnds: Value(numEnds),
      arrowsPerEnd: Value(arrowsPerEnd),
      status: Value(status),
      totalScore: Value(totalScore),
      arrowsShot: Value(arrowsShot),
      xCount: Value(xCount),
      tenCount: Value(tenCount),
      missCount: Value(missCount),
      isPersonalBest: Value(isPersonalBest),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      source: Value(source),
      isSynced: Value(isSynced),
      syncAction: syncAction == null && nullToAbsent
          ? const Value.absent()
          : Value(syncAction),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      scoringSessionGroupId: scoringSessionGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(scoringSessionGroupId),
      guestName: guestName == null && nullToAbsent
          ? const Value.absent()
          : Value(guestName),
    );
  }

  factory ScoringSessionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScoringSessionRow(
      id: serializer.fromJson<String>(json['id']),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      equipmentProfileId:
          serializer.fromJson<String?>(json['equipmentProfileId']),
      title: serializer.fromJson<String?>(json['title']),
      bowClass: serializer.fromJson<String?>(json['bowClass']),
      distanceCategory: serializer.fromJson<String>(json['distanceCategory']),
      distanceM: serializer.fromJson<int>(json['distanceM']),
      environment: serializer.fromJson<String>(json['environment']),
      targetFaceCm: serializer.fromJson<int?>(json['targetFaceCm']),
      targetFaceId: serializer.fromJson<String?>(json['targetFaceId']),
      numEnds: serializer.fromJson<int>(json['numEnds']),
      arrowsPerEnd: serializer.fromJson<int>(json['arrowsPerEnd']),
      status: serializer.fromJson<String>(json['status']),
      totalScore: serializer.fromJson<int>(json['totalScore']),
      arrowsShot: serializer.fromJson<int>(json['arrowsShot']),
      xCount: serializer.fromJson<int>(json['xCount']),
      tenCount: serializer.fromJson<int>(json['tenCount']),
      missCount: serializer.fromJson<int>(json['missCount']),
      isPersonalBest: serializer.fromJson<bool>(json['isPersonalBest']),
      notes: serializer.fromJson<String?>(json['notes']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      source: serializer.fromJson<String>(json['source']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncAction: serializer.fromJson<String?>(json['syncAction']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      scoringSessionGroupId:
          serializer.fromJson<String?>(json['scoringSessionGroupId']),
      guestName: serializer.fromJson<String?>(json['guestName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'equipmentProfileId': serializer.toJson<String?>(equipmentProfileId),
      'title': serializer.toJson<String?>(title),
      'bowClass': serializer.toJson<String?>(bowClass),
      'distanceCategory': serializer.toJson<String>(distanceCategory),
      'distanceM': serializer.toJson<int>(distanceM),
      'environment': serializer.toJson<String>(environment),
      'targetFaceCm': serializer.toJson<int?>(targetFaceCm),
      'targetFaceId': serializer.toJson<String?>(targetFaceId),
      'numEnds': serializer.toJson<int>(numEnds),
      'arrowsPerEnd': serializer.toJson<int>(arrowsPerEnd),
      'status': serializer.toJson<String>(status),
      'totalScore': serializer.toJson<int>(totalScore),
      'arrowsShot': serializer.toJson<int>(arrowsShot),
      'xCount': serializer.toJson<int>(xCount),
      'tenCount': serializer.toJson<int>(tenCount),
      'missCount': serializer.toJson<int>(missCount),
      'isPersonalBest': serializer.toJson<bool>(isPersonalBest),
      'notes': serializer.toJson<String?>(notes),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'source': serializer.toJson<String>(source),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncAction': serializer.toJson<String?>(syncAction),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'scoringSessionGroupId':
          serializer.toJson<String?>(scoringSessionGroupId),
      'guestName': serializer.toJson<String?>(guestName),
    };
  }

  ScoringSessionRow copyWith(
          {String? id,
          String? clientUuid,
          Value<String?> equipmentProfileId = const Value.absent(),
          Value<String?> title = const Value.absent(),
          Value<String?> bowClass = const Value.absent(),
          String? distanceCategory,
          int? distanceM,
          String? environment,
          Value<int?> targetFaceCm = const Value.absent(),
          Value<String?> targetFaceId = const Value.absent(),
          int? numEnds,
          int? arrowsPerEnd,
          String? status,
          int? totalScore,
          int? arrowsShot,
          int? xCount,
          int? tenCount,
          int? missCount,
          bool? isPersonalBest,
          Value<String?> notes = const Value.absent(),
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          String? source,
          bool? isSynced,
          Value<String?> syncAction = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          Value<String?> scoringSessionGroupId = const Value.absent(),
          Value<String?> guestName = const Value.absent()}) =>
      ScoringSessionRow(
        id: id ?? this.id,
        clientUuid: clientUuid ?? this.clientUuid,
        equipmentProfileId: equipmentProfileId.present
            ? equipmentProfileId.value
            : this.equipmentProfileId,
        title: title.present ? title.value : this.title,
        bowClass: bowClass.present ? bowClass.value : this.bowClass,
        distanceCategory: distanceCategory ?? this.distanceCategory,
        distanceM: distanceM ?? this.distanceM,
        environment: environment ?? this.environment,
        targetFaceCm:
            targetFaceCm.present ? targetFaceCm.value : this.targetFaceCm,
        targetFaceId:
            targetFaceId.present ? targetFaceId.value : this.targetFaceId,
        numEnds: numEnds ?? this.numEnds,
        arrowsPerEnd: arrowsPerEnd ?? this.arrowsPerEnd,
        status: status ?? this.status,
        totalScore: totalScore ?? this.totalScore,
        arrowsShot: arrowsShot ?? this.arrowsShot,
        xCount: xCount ?? this.xCount,
        tenCount: tenCount ?? this.tenCount,
        missCount: missCount ?? this.missCount,
        isPersonalBest: isPersonalBest ?? this.isPersonalBest,
        notes: notes.present ? notes.value : this.notes,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        source: source ?? this.source,
        isSynced: isSynced ?? this.isSynced,
        syncAction: syncAction.present ? syncAction.value : this.syncAction,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        scoringSessionGroupId: scoringSessionGroupId.present
            ? scoringSessionGroupId.value
            : this.scoringSessionGroupId,
        guestName: guestName.present ? guestName.value : this.guestName,
      );
  ScoringSessionRow copyWithCompanion(ScoringSessionRowsCompanion data) {
    return ScoringSessionRow(
      id: data.id.present ? data.id.value : this.id,
      clientUuid:
          data.clientUuid.present ? data.clientUuid.value : this.clientUuid,
      equipmentProfileId: data.equipmentProfileId.present
          ? data.equipmentProfileId.value
          : this.equipmentProfileId,
      title: data.title.present ? data.title.value : this.title,
      bowClass: data.bowClass.present ? data.bowClass.value : this.bowClass,
      distanceCategory: data.distanceCategory.present
          ? data.distanceCategory.value
          : this.distanceCategory,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      environment:
          data.environment.present ? data.environment.value : this.environment,
      targetFaceCm: data.targetFaceCm.present
          ? data.targetFaceCm.value
          : this.targetFaceCm,
      targetFaceId: data.targetFaceId.present
          ? data.targetFaceId.value
          : this.targetFaceId,
      numEnds: data.numEnds.present ? data.numEnds.value : this.numEnds,
      arrowsPerEnd: data.arrowsPerEnd.present
          ? data.arrowsPerEnd.value
          : this.arrowsPerEnd,
      status: data.status.present ? data.status.value : this.status,
      totalScore:
          data.totalScore.present ? data.totalScore.value : this.totalScore,
      arrowsShot:
          data.arrowsShot.present ? data.arrowsShot.value : this.arrowsShot,
      xCount: data.xCount.present ? data.xCount.value : this.xCount,
      tenCount: data.tenCount.present ? data.tenCount.value : this.tenCount,
      missCount: data.missCount.present ? data.missCount.value : this.missCount,
      isPersonalBest: data.isPersonalBest.present
          ? data.isPersonalBest.value
          : this.isPersonalBest,
      notes: data.notes.present ? data.notes.value : this.notes,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      source: data.source.present ? data.source.value : this.source,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncAction:
          data.syncAction.present ? data.syncAction.value : this.syncAction,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      scoringSessionGroupId: data.scoringSessionGroupId.present
          ? data.scoringSessionGroupId.value
          : this.scoringSessionGroupId,
      guestName: data.guestName.present ? data.guestName.value : this.guestName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScoringSessionRow(')
          ..write('id: $id, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('equipmentProfileId: $equipmentProfileId, ')
          ..write('title: $title, ')
          ..write('bowClass: $bowClass, ')
          ..write('distanceCategory: $distanceCategory, ')
          ..write('distanceM: $distanceM, ')
          ..write('environment: $environment, ')
          ..write('targetFaceCm: $targetFaceCm, ')
          ..write('targetFaceId: $targetFaceId, ')
          ..write('numEnds: $numEnds, ')
          ..write('arrowsPerEnd: $arrowsPerEnd, ')
          ..write('status: $status, ')
          ..write('totalScore: $totalScore, ')
          ..write('arrowsShot: $arrowsShot, ')
          ..write('xCount: $xCount, ')
          ..write('tenCount: $tenCount, ')
          ..write('missCount: $missCount, ')
          ..write('isPersonalBest: $isPersonalBest, ')
          ..write('notes: $notes, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('source: $source, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncAction: $syncAction, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('scoringSessionGroupId: $scoringSessionGroupId, ')
          ..write('guestName: $guestName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        clientUuid,
        equipmentProfileId,
        title,
        bowClass,
        distanceCategory,
        distanceM,
        environment,
        targetFaceCm,
        targetFaceId,
        numEnds,
        arrowsPerEnd,
        status,
        totalScore,
        arrowsShot,
        xCount,
        tenCount,
        missCount,
        isPersonalBest,
        notes,
        startedAt,
        completedAt,
        source,
        isSynced,
        syncAction,
        updatedAt,
        scoringSessionGroupId,
        guestName
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScoringSessionRow &&
          other.id == this.id &&
          other.clientUuid == this.clientUuid &&
          other.equipmentProfileId == this.equipmentProfileId &&
          other.title == this.title &&
          other.bowClass == this.bowClass &&
          other.distanceCategory == this.distanceCategory &&
          other.distanceM == this.distanceM &&
          other.environment == this.environment &&
          other.targetFaceCm == this.targetFaceCm &&
          other.targetFaceId == this.targetFaceId &&
          other.numEnds == this.numEnds &&
          other.arrowsPerEnd == this.arrowsPerEnd &&
          other.status == this.status &&
          other.totalScore == this.totalScore &&
          other.arrowsShot == this.arrowsShot &&
          other.xCount == this.xCount &&
          other.tenCount == this.tenCount &&
          other.missCount == this.missCount &&
          other.isPersonalBest == this.isPersonalBest &&
          other.notes == this.notes &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.source == this.source &&
          other.isSynced == this.isSynced &&
          other.syncAction == this.syncAction &&
          other.updatedAt == this.updatedAt &&
          other.scoringSessionGroupId == this.scoringSessionGroupId &&
          other.guestName == this.guestName);
}

class ScoringSessionRowsCompanion extends UpdateCompanion<ScoringSessionRow> {
  final Value<String> id;
  final Value<String> clientUuid;
  final Value<String?> equipmentProfileId;
  final Value<String?> title;
  final Value<String?> bowClass;
  final Value<String> distanceCategory;
  final Value<int> distanceM;
  final Value<String> environment;
  final Value<int?> targetFaceCm;
  final Value<String?> targetFaceId;
  final Value<int> numEnds;
  final Value<int> arrowsPerEnd;
  final Value<String> status;
  final Value<int> totalScore;
  final Value<int> arrowsShot;
  final Value<int> xCount;
  final Value<int> tenCount;
  final Value<int> missCount;
  final Value<bool> isPersonalBest;
  final Value<String?> notes;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String> source;
  final Value<bool> isSynced;
  final Value<String?> syncAction;
  final Value<DateTime?> updatedAt;
  final Value<String?> scoringSessionGroupId;
  final Value<String?> guestName;
  final Value<int> rowid;
  const ScoringSessionRowsCompanion({
    this.id = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.equipmentProfileId = const Value.absent(),
    this.title = const Value.absent(),
    this.bowClass = const Value.absent(),
    this.distanceCategory = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.environment = const Value.absent(),
    this.targetFaceCm = const Value.absent(),
    this.targetFaceId = const Value.absent(),
    this.numEnds = const Value.absent(),
    this.arrowsPerEnd = const Value.absent(),
    this.status = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.arrowsShot = const Value.absent(),
    this.xCount = const Value.absent(),
    this.tenCount = const Value.absent(),
    this.missCount = const Value.absent(),
    this.isPersonalBest = const Value.absent(),
    this.notes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncAction = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.scoringSessionGroupId = const Value.absent(),
    this.guestName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScoringSessionRowsCompanion.insert({
    required String id,
    required String clientUuid,
    this.equipmentProfileId = const Value.absent(),
    this.title = const Value.absent(),
    this.bowClass = const Value.absent(),
    required String distanceCategory,
    required int distanceM,
    this.environment = const Value.absent(),
    this.targetFaceCm = const Value.absent(),
    this.targetFaceId = const Value.absent(),
    required int numEnds,
    required int arrowsPerEnd,
    this.status = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.arrowsShot = const Value.absent(),
    this.xCount = const Value.absent(),
    this.tenCount = const Value.absent(),
    this.missCount = const Value.absent(),
    this.isPersonalBest = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncAction = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.scoringSessionGroupId = const Value.absent(),
    this.guestName = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        clientUuid = Value(clientUuid),
        distanceCategory = Value(distanceCategory),
        distanceM = Value(distanceM),
        numEnds = Value(numEnds),
        arrowsPerEnd = Value(arrowsPerEnd),
        startedAt = Value(startedAt);
  static Insertable<ScoringSessionRow> custom({
    Expression<String>? id,
    Expression<String>? clientUuid,
    Expression<String>? equipmentProfileId,
    Expression<String>? title,
    Expression<String>? bowClass,
    Expression<String>? distanceCategory,
    Expression<int>? distanceM,
    Expression<String>? environment,
    Expression<int>? targetFaceCm,
    Expression<String>? targetFaceId,
    Expression<int>? numEnds,
    Expression<int>? arrowsPerEnd,
    Expression<String>? status,
    Expression<int>? totalScore,
    Expression<int>? arrowsShot,
    Expression<int>? xCount,
    Expression<int>? tenCount,
    Expression<int>? missCount,
    Expression<bool>? isPersonalBest,
    Expression<String>? notes,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? source,
    Expression<bool>? isSynced,
    Expression<String>? syncAction,
    Expression<DateTime>? updatedAt,
    Expression<String>? scoringSessionGroupId,
    Expression<String>? guestName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (equipmentProfileId != null)
        'equipment_profile_id': equipmentProfileId,
      if (title != null) 'title': title,
      if (bowClass != null) 'bow_class': bowClass,
      if (distanceCategory != null) 'distance_category': distanceCategory,
      if (distanceM != null) 'distance_m': distanceM,
      if (environment != null) 'environment': environment,
      if (targetFaceCm != null) 'target_face_cm': targetFaceCm,
      if (targetFaceId != null) 'target_face_id': targetFaceId,
      if (numEnds != null) 'num_ends': numEnds,
      if (arrowsPerEnd != null) 'arrows_per_end': arrowsPerEnd,
      if (status != null) 'status': status,
      if (totalScore != null) 'total_score': totalScore,
      if (arrowsShot != null) 'arrows_shot': arrowsShot,
      if (xCount != null) 'x_count': xCount,
      if (tenCount != null) 'ten_count': tenCount,
      if (missCount != null) 'miss_count': missCount,
      if (isPersonalBest != null) 'is_personal_best': isPersonalBest,
      if (notes != null) 'notes': notes,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (source != null) 'source': source,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncAction != null) 'sync_action': syncAction,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (scoringSessionGroupId != null)
        'scoring_session_group_id': scoringSessionGroupId,
      if (guestName != null) 'guest_name': guestName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScoringSessionRowsCompanion copyWith(
      {Value<String>? id,
      Value<String>? clientUuid,
      Value<String?>? equipmentProfileId,
      Value<String?>? title,
      Value<String?>? bowClass,
      Value<String>? distanceCategory,
      Value<int>? distanceM,
      Value<String>? environment,
      Value<int?>? targetFaceCm,
      Value<String?>? targetFaceId,
      Value<int>? numEnds,
      Value<int>? arrowsPerEnd,
      Value<String>? status,
      Value<int>? totalScore,
      Value<int>? arrowsShot,
      Value<int>? xCount,
      Value<int>? tenCount,
      Value<int>? missCount,
      Value<bool>? isPersonalBest,
      Value<String?>? notes,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<String>? source,
      Value<bool>? isSynced,
      Value<String?>? syncAction,
      Value<DateTime?>? updatedAt,
      Value<String?>? scoringSessionGroupId,
      Value<String?>? guestName,
      Value<int>? rowid}) {
    return ScoringSessionRowsCompanion(
      id: id ?? this.id,
      clientUuid: clientUuid ?? this.clientUuid,
      equipmentProfileId: equipmentProfileId ?? this.equipmentProfileId,
      title: title ?? this.title,
      bowClass: bowClass ?? this.bowClass,
      distanceCategory: distanceCategory ?? this.distanceCategory,
      distanceM: distanceM ?? this.distanceM,
      environment: environment ?? this.environment,
      targetFaceCm: targetFaceCm ?? this.targetFaceCm,
      targetFaceId: targetFaceId ?? this.targetFaceId,
      numEnds: numEnds ?? this.numEnds,
      arrowsPerEnd: arrowsPerEnd ?? this.arrowsPerEnd,
      status: status ?? this.status,
      totalScore: totalScore ?? this.totalScore,
      arrowsShot: arrowsShot ?? this.arrowsShot,
      xCount: xCount ?? this.xCount,
      tenCount: tenCount ?? this.tenCount,
      missCount: missCount ?? this.missCount,
      isPersonalBest: isPersonalBest ?? this.isPersonalBest,
      notes: notes ?? this.notes,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      source: source ?? this.source,
      isSynced: isSynced ?? this.isSynced,
      syncAction: syncAction ?? this.syncAction,
      updatedAt: updatedAt ?? this.updatedAt,
      scoringSessionGroupId:
          scoringSessionGroupId ?? this.scoringSessionGroupId,
      guestName: guestName ?? this.guestName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (equipmentProfileId.present) {
      map['equipment_profile_id'] = Variable<String>(equipmentProfileId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (bowClass.present) {
      map['bow_class'] = Variable<String>(bowClass.value);
    }
    if (distanceCategory.present) {
      map['distance_category'] = Variable<String>(distanceCategory.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<int>(distanceM.value);
    }
    if (environment.present) {
      map['environment'] = Variable<String>(environment.value);
    }
    if (targetFaceCm.present) {
      map['target_face_cm'] = Variable<int>(targetFaceCm.value);
    }
    if (targetFaceId.present) {
      map['target_face_id'] = Variable<String>(targetFaceId.value);
    }
    if (numEnds.present) {
      map['num_ends'] = Variable<int>(numEnds.value);
    }
    if (arrowsPerEnd.present) {
      map['arrows_per_end'] = Variable<int>(arrowsPerEnd.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (arrowsShot.present) {
      map['arrows_shot'] = Variable<int>(arrowsShot.value);
    }
    if (xCount.present) {
      map['x_count'] = Variable<int>(xCount.value);
    }
    if (tenCount.present) {
      map['ten_count'] = Variable<int>(tenCount.value);
    }
    if (missCount.present) {
      map['miss_count'] = Variable<int>(missCount.value);
    }
    if (isPersonalBest.present) {
      map['is_personal_best'] = Variable<bool>(isPersonalBest.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncAction.present) {
      map['sync_action'] = Variable<String>(syncAction.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (scoringSessionGroupId.present) {
      map['scoring_session_group_id'] =
          Variable<String>(scoringSessionGroupId.value);
    }
    if (guestName.present) {
      map['guest_name'] = Variable<String>(guestName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoringSessionRowsCompanion(')
          ..write('id: $id, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('equipmentProfileId: $equipmentProfileId, ')
          ..write('title: $title, ')
          ..write('bowClass: $bowClass, ')
          ..write('distanceCategory: $distanceCategory, ')
          ..write('distanceM: $distanceM, ')
          ..write('environment: $environment, ')
          ..write('targetFaceCm: $targetFaceCm, ')
          ..write('targetFaceId: $targetFaceId, ')
          ..write('numEnds: $numEnds, ')
          ..write('arrowsPerEnd: $arrowsPerEnd, ')
          ..write('status: $status, ')
          ..write('totalScore: $totalScore, ')
          ..write('arrowsShot: $arrowsShot, ')
          ..write('xCount: $xCount, ')
          ..write('tenCount: $tenCount, ')
          ..write('missCount: $missCount, ')
          ..write('isPersonalBest: $isPersonalBest, ')
          ..write('notes: $notes, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('source: $source, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncAction: $syncAction, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('scoringSessionGroupId: $scoringSessionGroupId, ')
          ..write('guestName: $guestName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScoringEndRowsTable extends ScoringEndRows
    with TableInfo<$ScoringEndRowsTable, ScoringEndRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoringEndRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endNumberMeta =
      const VerificationMeta('endNumber');
  @override
  late final GeneratedColumn<int> endNumber = GeneratedColumn<int>(
      'end_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, sessionId, endNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scoring_end_rows';
  @override
  VerificationContext validateIntegrity(Insertable<ScoringEndRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('end_number')) {
      context.handle(_endNumberMeta,
          endNumber.isAcceptableOrUnknown(data['end_number']!, _endNumberMeta));
    } else if (isInserting) {
      context.missing(_endNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScoringEndRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScoringEndRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      endNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}end_number'])!,
    );
  }

  @override
  $ScoringEndRowsTable createAlias(String alias) {
    return $ScoringEndRowsTable(attachedDatabase, alias);
  }
}

class ScoringEndRow extends DataClass implements Insertable<ScoringEndRow> {
  final String id;
  final String sessionId;
  final int endNumber;
  const ScoringEndRow(
      {required this.id, required this.sessionId, required this.endNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['end_number'] = Variable<int>(endNumber);
    return map;
  }

  ScoringEndRowsCompanion toCompanion(bool nullToAbsent) {
    return ScoringEndRowsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      endNumber: Value(endNumber),
    );
  }

  factory ScoringEndRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScoringEndRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      endNumber: serializer.fromJson<int>(json['endNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'endNumber': serializer.toJson<int>(endNumber),
    };
  }

  ScoringEndRow copyWith({String? id, String? sessionId, int? endNumber}) =>
      ScoringEndRow(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        endNumber: endNumber ?? this.endNumber,
      );
  ScoringEndRow copyWithCompanion(ScoringEndRowsCompanion data) {
    return ScoringEndRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      endNumber: data.endNumber.present ? data.endNumber.value : this.endNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScoringEndRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('endNumber: $endNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sessionId, endNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScoringEndRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.endNumber == this.endNumber);
}

class ScoringEndRowsCompanion extends UpdateCompanion<ScoringEndRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> endNumber;
  final Value<int> rowid;
  const ScoringEndRowsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.endNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScoringEndRowsCompanion.insert({
    required String id,
    required String sessionId,
    required int endNumber,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sessionId = Value(sessionId),
        endNumber = Value(endNumber);
  static Insertable<ScoringEndRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? endNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (endNumber != null) 'end_number': endNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScoringEndRowsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sessionId,
      Value<int>? endNumber,
      Value<int>? rowid}) {
    return ScoringEndRowsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      endNumber: endNumber ?? this.endNumber,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (endNumber.present) {
      map['end_number'] = Variable<int>(endNumber.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoringEndRowsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('endNumber: $endNumber, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScoringArrowRowsTable extends ScoringArrowRows
    with TableInfo<$ScoringArrowRowsTable, ScoringArrowRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScoringArrowRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endIdMeta = const VerificationMeta('endId');
  @override
  late final GeneratedColumn<String> endId = GeneratedColumn<String>(
      'end_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _arrowIndexMeta =
      const VerificationMeta('arrowIndex');
  @override
  late final GeneratedColumn<int> arrowIndex = GeneratedColumn<int>(
      'arrow_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scoreValueMeta =
      const VerificationMeta('scoreValue');
  @override
  late final GeneratedColumn<int> scoreValue = GeneratedColumn<int>(
      'score_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isXMeta = const VerificationMeta('isX');
  @override
  late final GeneratedColumn<bool> isX = GeneratedColumn<bool>(
      'is_x', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_x" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isMissMeta = const VerificationMeta('isMiss');
  @override
  late final GeneratedColumn<bool> isMiss = GeneratedColumn<bool>(
      'is_miss', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_miss" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, endId, arrowIndex, scoreValue, isX, isMiss];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scoring_arrow_rows';
  @override
  VerificationContext validateIntegrity(Insertable<ScoringArrowRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('end_id')) {
      context.handle(
          _endIdMeta, endId.isAcceptableOrUnknown(data['end_id']!, _endIdMeta));
    } else if (isInserting) {
      context.missing(_endIdMeta);
    }
    if (data.containsKey('arrow_index')) {
      context.handle(
          _arrowIndexMeta,
          arrowIndex.isAcceptableOrUnknown(
              data['arrow_index']!, _arrowIndexMeta));
    } else if (isInserting) {
      context.missing(_arrowIndexMeta);
    }
    if (data.containsKey('score_value')) {
      context.handle(
          _scoreValueMeta,
          scoreValue.isAcceptableOrUnknown(
              data['score_value']!, _scoreValueMeta));
    } else if (isInserting) {
      context.missing(_scoreValueMeta);
    }
    if (data.containsKey('is_x')) {
      context.handle(
          _isXMeta, isX.isAcceptableOrUnknown(data['is_x']!, _isXMeta));
    }
    if (data.containsKey('is_miss')) {
      context.handle(_isMissMeta,
          isMiss.isAcceptableOrUnknown(data['is_miss']!, _isMissMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScoringArrowRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScoringArrowRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      endId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_id'])!,
      arrowIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}arrow_index'])!,
      scoreValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score_value'])!,
      isX: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_x'])!,
      isMiss: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_miss'])!,
    );
  }

  @override
  $ScoringArrowRowsTable createAlias(String alias) {
    return $ScoringArrowRowsTable(attachedDatabase, alias);
  }
}

class ScoringArrowRow extends DataClass implements Insertable<ScoringArrowRow> {
  final String id;
  final String endId;
  final int arrowIndex;
  final int scoreValue;
  final bool isX;
  final bool isMiss;
  const ScoringArrowRow(
      {required this.id,
      required this.endId,
      required this.arrowIndex,
      required this.scoreValue,
      required this.isX,
      required this.isMiss});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['end_id'] = Variable<String>(endId);
    map['arrow_index'] = Variable<int>(arrowIndex);
    map['score_value'] = Variable<int>(scoreValue);
    map['is_x'] = Variable<bool>(isX);
    map['is_miss'] = Variable<bool>(isMiss);
    return map;
  }

  ScoringArrowRowsCompanion toCompanion(bool nullToAbsent) {
    return ScoringArrowRowsCompanion(
      id: Value(id),
      endId: Value(endId),
      arrowIndex: Value(arrowIndex),
      scoreValue: Value(scoreValue),
      isX: Value(isX),
      isMiss: Value(isMiss),
    );
  }

  factory ScoringArrowRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScoringArrowRow(
      id: serializer.fromJson<String>(json['id']),
      endId: serializer.fromJson<String>(json['endId']),
      arrowIndex: serializer.fromJson<int>(json['arrowIndex']),
      scoreValue: serializer.fromJson<int>(json['scoreValue']),
      isX: serializer.fromJson<bool>(json['isX']),
      isMiss: serializer.fromJson<bool>(json['isMiss']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'endId': serializer.toJson<String>(endId),
      'arrowIndex': serializer.toJson<int>(arrowIndex),
      'scoreValue': serializer.toJson<int>(scoreValue),
      'isX': serializer.toJson<bool>(isX),
      'isMiss': serializer.toJson<bool>(isMiss),
    };
  }

  ScoringArrowRow copyWith(
          {String? id,
          String? endId,
          int? arrowIndex,
          int? scoreValue,
          bool? isX,
          bool? isMiss}) =>
      ScoringArrowRow(
        id: id ?? this.id,
        endId: endId ?? this.endId,
        arrowIndex: arrowIndex ?? this.arrowIndex,
        scoreValue: scoreValue ?? this.scoreValue,
        isX: isX ?? this.isX,
        isMiss: isMiss ?? this.isMiss,
      );
  ScoringArrowRow copyWithCompanion(ScoringArrowRowsCompanion data) {
    return ScoringArrowRow(
      id: data.id.present ? data.id.value : this.id,
      endId: data.endId.present ? data.endId.value : this.endId,
      arrowIndex:
          data.arrowIndex.present ? data.arrowIndex.value : this.arrowIndex,
      scoreValue:
          data.scoreValue.present ? data.scoreValue.value : this.scoreValue,
      isX: data.isX.present ? data.isX.value : this.isX,
      isMiss: data.isMiss.present ? data.isMiss.value : this.isMiss,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScoringArrowRow(')
          ..write('id: $id, ')
          ..write('endId: $endId, ')
          ..write('arrowIndex: $arrowIndex, ')
          ..write('scoreValue: $scoreValue, ')
          ..write('isX: $isX, ')
          ..write('isMiss: $isMiss')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, endId, arrowIndex, scoreValue, isX, isMiss);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScoringArrowRow &&
          other.id == this.id &&
          other.endId == this.endId &&
          other.arrowIndex == this.arrowIndex &&
          other.scoreValue == this.scoreValue &&
          other.isX == this.isX &&
          other.isMiss == this.isMiss);
}

class ScoringArrowRowsCompanion extends UpdateCompanion<ScoringArrowRow> {
  final Value<String> id;
  final Value<String> endId;
  final Value<int> arrowIndex;
  final Value<int> scoreValue;
  final Value<bool> isX;
  final Value<bool> isMiss;
  final Value<int> rowid;
  const ScoringArrowRowsCompanion({
    this.id = const Value.absent(),
    this.endId = const Value.absent(),
    this.arrowIndex = const Value.absent(),
    this.scoreValue = const Value.absent(),
    this.isX = const Value.absent(),
    this.isMiss = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScoringArrowRowsCompanion.insert({
    required String id,
    required String endId,
    required int arrowIndex,
    required int scoreValue,
    this.isX = const Value.absent(),
    this.isMiss = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        endId = Value(endId),
        arrowIndex = Value(arrowIndex),
        scoreValue = Value(scoreValue);
  static Insertable<ScoringArrowRow> custom({
    Expression<String>? id,
    Expression<String>? endId,
    Expression<int>? arrowIndex,
    Expression<int>? scoreValue,
    Expression<bool>? isX,
    Expression<bool>? isMiss,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (endId != null) 'end_id': endId,
      if (arrowIndex != null) 'arrow_index': arrowIndex,
      if (scoreValue != null) 'score_value': scoreValue,
      if (isX != null) 'is_x': isX,
      if (isMiss != null) 'is_miss': isMiss,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScoringArrowRowsCompanion copyWith(
      {Value<String>? id,
      Value<String>? endId,
      Value<int>? arrowIndex,
      Value<int>? scoreValue,
      Value<bool>? isX,
      Value<bool>? isMiss,
      Value<int>? rowid}) {
    return ScoringArrowRowsCompanion(
      id: id ?? this.id,
      endId: endId ?? this.endId,
      arrowIndex: arrowIndex ?? this.arrowIndex,
      scoreValue: scoreValue ?? this.scoreValue,
      isX: isX ?? this.isX,
      isMiss: isMiss ?? this.isMiss,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (endId.present) {
      map['end_id'] = Variable<String>(endId.value);
    }
    if (arrowIndex.present) {
      map['arrow_index'] = Variable<int>(arrowIndex.value);
    }
    if (scoreValue.present) {
      map['score_value'] = Variable<int>(scoreValue.value);
    }
    if (isX.present) {
      map['is_x'] = Variable<bool>(isX.value);
    }
    if (isMiss.present) {
      map['is_miss'] = Variable<bool>(isMiss.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScoringArrowRowsCompanion(')
          ..write('id: $id, ')
          ..write('endId: $endId, ')
          ..write('arrowIndex: $arrowIndex, ')
          ..write('scoreValue: $scoreValue, ')
          ..write('isX: $isX, ')
          ..write('isMiss: $isMiss, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TargetFaceRowsTable extends TargetFaceRows
    with TableInfo<$TargetFaceRowsTable, TargetFaceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetFaceRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _organizationIdMeta =
      const VerificationMeta('organizationId');
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
      'organization_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _organizationNameMeta =
      const VerificationMeta('organizationName');
  @override
  late final GeneratedColumn<String> organizationName = GeneratedColumn<String>(
      'organization_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _organizationSlugMeta =
      const VerificationMeta('organizationSlug');
  @override
  late final GeneratedColumn<String> organizationSlug = GeneratedColumn<String>(
      'organization_slug', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scoringRulesJsonMeta =
      const VerificationMeta('scoringRulesJson');
  @override
  late final GeneratedColumn<String> scoringRulesJson = GeneratedColumn<String>(
      'scoring_rules_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usedCountMeta =
      const VerificationMeta('usedCount');
  @override
  late final GeneratedColumn<int> usedCount = GeneratedColumn<int>(
      'used_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        organizationId,
        organizationName,
        organizationSlug,
        code,
        name,
        imagePath,
        scoringRulesJson,
        usedCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'target_face_rows';
  @override
  VerificationContext validateIntegrity(Insertable<TargetFaceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
          _organizationIdMeta,
          organizationId.isAcceptableOrUnknown(
              data['organization_id']!, _organizationIdMeta));
    }
    if (data.containsKey('organization_name')) {
      context.handle(
          _organizationNameMeta,
          organizationName.isAcceptableOrUnknown(
              data['organization_name']!, _organizationNameMeta));
    }
    if (data.containsKey('organization_slug')) {
      context.handle(
          _organizationSlugMeta,
          organizationSlug.isAcceptableOrUnknown(
              data['organization_slug']!, _organizationSlugMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('scoring_rules_json')) {
      context.handle(
          _scoringRulesJsonMeta,
          scoringRulesJson.isAcceptableOrUnknown(
              data['scoring_rules_json']!, _scoringRulesJsonMeta));
    } else if (isInserting) {
      context.missing(_scoringRulesJsonMeta);
    }
    if (data.containsKey('used_count')) {
      context.handle(_usedCountMeta,
          usedCount.isAcceptableOrUnknown(data['used_count']!, _usedCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TargetFaceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TargetFaceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      organizationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}organization_id']),
      organizationName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_name']),
      organizationSlug: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}organization_slug']),
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      scoringRulesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scoring_rules_json'])!,
      usedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}used_count'])!,
    );
  }

  @override
  $TargetFaceRowsTable createAlias(String alias) {
    return $TargetFaceRowsTable(attachedDatabase, alias);
  }
}

class TargetFaceRow extends DataClass implements Insertable<TargetFaceRow> {
  final String id;
  final String? organizationId;
  final String? organizationName;
  final String? organizationSlug;
  final String code;
  final String name;
  final String? imagePath;
  final String scoringRulesJson;
  final int usedCount;
  const TargetFaceRow(
      {required this.id,
      this.organizationId,
      this.organizationName,
      this.organizationSlug,
      required this.code,
      required this.name,
      this.imagePath,
      required this.scoringRulesJson,
      required this.usedCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || organizationId != null) {
      map['organization_id'] = Variable<String>(organizationId);
    }
    if (!nullToAbsent || organizationName != null) {
      map['organization_name'] = Variable<String>(organizationName);
    }
    if (!nullToAbsent || organizationSlug != null) {
      map['organization_slug'] = Variable<String>(organizationSlug);
    }
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['scoring_rules_json'] = Variable<String>(scoringRulesJson);
    map['used_count'] = Variable<int>(usedCount);
    return map;
  }

  TargetFaceRowsCompanion toCompanion(bool nullToAbsent) {
    return TargetFaceRowsCompanion(
      id: Value(id),
      organizationId: organizationId == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationId),
      organizationName: organizationName == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationName),
      organizationSlug: organizationSlug == null && nullToAbsent
          ? const Value.absent()
          : Value(organizationSlug),
      code: Value(code),
      name: Value(name),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      scoringRulesJson: Value(scoringRulesJson),
      usedCount: Value(usedCount),
    );
  }

  factory TargetFaceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TargetFaceRow(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String?>(json['organizationId']),
      organizationName: serializer.fromJson<String?>(json['organizationName']),
      organizationSlug: serializer.fromJson<String?>(json['organizationSlug']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      scoringRulesJson: serializer.fromJson<String>(json['scoringRulesJson']),
      usedCount: serializer.fromJson<int>(json['usedCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String?>(organizationId),
      'organizationName': serializer.toJson<String?>(organizationName),
      'organizationSlug': serializer.toJson<String?>(organizationSlug),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'imagePath': serializer.toJson<String?>(imagePath),
      'scoringRulesJson': serializer.toJson<String>(scoringRulesJson),
      'usedCount': serializer.toJson<int>(usedCount),
    };
  }

  TargetFaceRow copyWith(
          {String? id,
          Value<String?> organizationId = const Value.absent(),
          Value<String?> organizationName = const Value.absent(),
          Value<String?> organizationSlug = const Value.absent(),
          String? code,
          String? name,
          Value<String?> imagePath = const Value.absent(),
          String? scoringRulesJson,
          int? usedCount}) =>
      TargetFaceRow(
        id: id ?? this.id,
        organizationId:
            organizationId.present ? organizationId.value : this.organizationId,
        organizationName: organizationName.present
            ? organizationName.value
            : this.organizationName,
        organizationSlug: organizationSlug.present
            ? organizationSlug.value
            : this.organizationSlug,
        code: code ?? this.code,
        name: name ?? this.name,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        scoringRulesJson: scoringRulesJson ?? this.scoringRulesJson,
        usedCount: usedCount ?? this.usedCount,
      );
  TargetFaceRow copyWithCompanion(TargetFaceRowsCompanion data) {
    return TargetFaceRow(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      organizationName: data.organizationName.present
          ? data.organizationName.value
          : this.organizationName,
      organizationSlug: data.organizationSlug.present
          ? data.organizationSlug.value
          : this.organizationSlug,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      scoringRulesJson: data.scoringRulesJson.present
          ? data.scoringRulesJson.value
          : this.scoringRulesJson,
      usedCount: data.usedCount.present ? data.usedCount.value : this.usedCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TargetFaceRow(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('organizationName: $organizationName, ')
          ..write('organizationSlug: $organizationSlug, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('scoringRulesJson: $scoringRulesJson, ')
          ..write('usedCount: $usedCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, organizationId, organizationName,
      organizationSlug, code, name, imagePath, scoringRulesJson, usedCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TargetFaceRow &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.organizationName == this.organizationName &&
          other.organizationSlug == this.organizationSlug &&
          other.code == this.code &&
          other.name == this.name &&
          other.imagePath == this.imagePath &&
          other.scoringRulesJson == this.scoringRulesJson &&
          other.usedCount == this.usedCount);
}

class TargetFaceRowsCompanion extends UpdateCompanion<TargetFaceRow> {
  final Value<String> id;
  final Value<String?> organizationId;
  final Value<String?> organizationName;
  final Value<String?> organizationSlug;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> imagePath;
  final Value<String> scoringRulesJson;
  final Value<int> usedCount;
  final Value<int> rowid;
  const TargetFaceRowsCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.organizationName = const Value.absent(),
    this.organizationSlug = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.scoringRulesJson = const Value.absent(),
    this.usedCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TargetFaceRowsCompanion.insert({
    required String id,
    this.organizationId = const Value.absent(),
    this.organizationName = const Value.absent(),
    this.organizationSlug = const Value.absent(),
    required String code,
    required String name,
    this.imagePath = const Value.absent(),
    required String scoringRulesJson,
    this.usedCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        code = Value(code),
        name = Value(name),
        scoringRulesJson = Value(scoringRulesJson);
  static Insertable<TargetFaceRow> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? organizationName,
    Expression<String>? organizationSlug,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? imagePath,
    Expression<String>? scoringRulesJson,
    Expression<int>? usedCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (organizationName != null) 'organization_name': organizationName,
      if (organizationSlug != null) 'organization_slug': organizationSlug,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (imagePath != null) 'image_path': imagePath,
      if (scoringRulesJson != null) 'scoring_rules_json': scoringRulesJson,
      if (usedCount != null) 'used_count': usedCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TargetFaceRowsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? organizationId,
      Value<String?>? organizationName,
      Value<String?>? organizationSlug,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? imagePath,
      Value<String>? scoringRulesJson,
      Value<int>? usedCount,
      Value<int>? rowid}) {
    return TargetFaceRowsCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      organizationSlug: organizationSlug ?? this.organizationSlug,
      code: code ?? this.code,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      scoringRulesJson: scoringRulesJson ?? this.scoringRulesJson,
      usedCount: usedCount ?? this.usedCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (organizationName.present) {
      map['organization_name'] = Variable<String>(organizationName.value);
    }
    if (organizationSlug.present) {
      map['organization_slug'] = Variable<String>(organizationSlug.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (scoringRulesJson.present) {
      map['scoring_rules_json'] = Variable<String>(scoringRulesJson.value);
    }
    if (usedCount.present) {
      map['used_count'] = Variable<int>(usedCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetFaceRowsCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('organizationName: $organizationName, ')
          ..write('organizationSlug: $organizationSlug, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('scoringRulesJson: $scoringRulesJson, ')
          ..write('usedCount: $usedCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupSessionRowsTable extends GroupSessionRows
    with TableInfo<$GroupSessionRowsTable, GroupSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupSessionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _joinCodeMeta =
      const VerificationMeta('joinCode');
  @override
  late final GeneratedColumn<String> joinCode = GeneratedColumn<String>(
      'join_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hostUserIdMeta =
      const VerificationMeta('hostUserId');
  @override
  late final GeneratedColumn<int> hostUserId = GeneratedColumn<int>(
      'host_user_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hostNameMeta =
      const VerificationMeta('hostName');
  @override
  late final GeneratedColumn<String> hostName = GeneratedColumn<String>(
      'host_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _distanceCategoryMeta =
      const VerificationMeta('distanceCategory');
  @override
  late final GeneratedColumn<String> distanceCategory = GeneratedColumn<String>(
      'distance_category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _distanceMMeta =
      const VerificationMeta('distanceM');
  @override
  late final GeneratedColumn<int> distanceM = GeneratedColumn<int>(
      'distance_m', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _environmentMeta =
      const VerificationMeta('environment');
  @override
  late final GeneratedColumn<String> environment = GeneratedColumn<String>(
      'environment', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('outdoor'));
  static const VerificationMeta _targetFaceCmMeta =
      const VerificationMeta('targetFaceCm');
  @override
  late final GeneratedColumn<int> targetFaceCm = GeneratedColumn<int>(
      'target_face_cm', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _targetFaceIdMeta =
      const VerificationMeta('targetFaceId');
  @override
  late final GeneratedColumn<String> targetFaceId = GeneratedColumn<String>(
      'target_face_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _numEndsMeta =
      const VerificationMeta('numEnds');
  @override
  late final GeneratedColumn<int> numEnds = GeneratedColumn<int>(
      'num_ends', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _arrowsPerEndMeta =
      const VerificationMeta('arrowsPerEnd');
  @override
  late final GeneratedColumn<int> arrowsPerEnd = GeneratedColumn<int>(
      'arrows_per_end', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('in_progress'));
  static const VerificationMeta _participantCountMeta =
      const VerificationMeta('participantCount');
  @override
  late final GeneratedColumn<int> participantCount = GeneratedColumn<int>(
      'participant_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        joinCode,
        title,
        hostUserId,
        hostName,
        distanceCategory,
        distanceM,
        environment,
        targetFaceCm,
        targetFaceId,
        numEnds,
        arrowsPerEnd,
        status,
        participantCount,
        startedAt,
        completedAt,
        cachedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_session_rows';
  @override
  VerificationContext validateIntegrity(Insertable<GroupSessionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('join_code')) {
      context.handle(_joinCodeMeta,
          joinCode.isAcceptableOrUnknown(data['join_code']!, _joinCodeMeta));
    } else if (isInserting) {
      context.missing(_joinCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('host_user_id')) {
      context.handle(
          _hostUserIdMeta,
          hostUserId.isAcceptableOrUnknown(
              data['host_user_id']!, _hostUserIdMeta));
    } else if (isInserting) {
      context.missing(_hostUserIdMeta);
    }
    if (data.containsKey('host_name')) {
      context.handle(_hostNameMeta,
          hostName.isAcceptableOrUnknown(data['host_name']!, _hostNameMeta));
    }
    if (data.containsKey('distance_category')) {
      context.handle(
          _distanceCategoryMeta,
          distanceCategory.isAcceptableOrUnknown(
              data['distance_category']!, _distanceCategoryMeta));
    } else if (isInserting) {
      context.missing(_distanceCategoryMeta);
    }
    if (data.containsKey('distance_m')) {
      context.handle(_distanceMMeta,
          distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta));
    } else if (isInserting) {
      context.missing(_distanceMMeta);
    }
    if (data.containsKey('environment')) {
      context.handle(
          _environmentMeta,
          environment.isAcceptableOrUnknown(
              data['environment']!, _environmentMeta));
    }
    if (data.containsKey('target_face_cm')) {
      context.handle(
          _targetFaceCmMeta,
          targetFaceCm.isAcceptableOrUnknown(
              data['target_face_cm']!, _targetFaceCmMeta));
    }
    if (data.containsKey('target_face_id')) {
      context.handle(
          _targetFaceIdMeta,
          targetFaceId.isAcceptableOrUnknown(
              data['target_face_id']!, _targetFaceIdMeta));
    }
    if (data.containsKey('num_ends')) {
      context.handle(_numEndsMeta,
          numEnds.isAcceptableOrUnknown(data['num_ends']!, _numEndsMeta));
    } else if (isInserting) {
      context.missing(_numEndsMeta);
    }
    if (data.containsKey('arrows_per_end')) {
      context.handle(
          _arrowsPerEndMeta,
          arrowsPerEnd.isAcceptableOrUnknown(
              data['arrows_per_end']!, _arrowsPerEndMeta));
    } else if (isInserting) {
      context.missing(_arrowsPerEndMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('participant_count')) {
      context.handle(
          _participantCountMeta,
          participantCount.isAcceptableOrUnknown(
              data['participant_count']!, _participantCountMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupSessionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      joinCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}join_code'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      hostUserId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}host_user_id'])!,
      hostName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}host_name']),
      distanceCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}distance_category'])!,
      distanceM: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}distance_m'])!,
      environment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}environment'])!,
      targetFaceCm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_face_cm']),
      targetFaceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_face_id']),
      numEnds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}num_ends'])!,
      arrowsPerEnd: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}arrows_per_end'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      participantCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}participant_count'])!,
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $GroupSessionRowsTable createAlias(String alias) {
    return $GroupSessionRowsTable(attachedDatabase, alias);
  }
}

class GroupSessionRow extends DataClass implements Insertable<GroupSessionRow> {
  final String id;
  final String joinCode;
  final String? title;
  final int hostUserId;
  final String? hostName;
  final String distanceCategory;
  final int distanceM;
  final String environment;
  final int? targetFaceCm;
  final String? targetFaceId;
  final int numEnds;
  final int arrowsPerEnd;
  final String status;
  final int participantCount;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime cachedAt;
  const GroupSessionRow(
      {required this.id,
      required this.joinCode,
      this.title,
      required this.hostUserId,
      this.hostName,
      required this.distanceCategory,
      required this.distanceM,
      required this.environment,
      this.targetFaceCm,
      this.targetFaceId,
      required this.numEnds,
      required this.arrowsPerEnd,
      required this.status,
      required this.participantCount,
      required this.startedAt,
      this.completedAt,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['join_code'] = Variable<String>(joinCode);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['host_user_id'] = Variable<int>(hostUserId);
    if (!nullToAbsent || hostName != null) {
      map['host_name'] = Variable<String>(hostName);
    }
    map['distance_category'] = Variable<String>(distanceCategory);
    map['distance_m'] = Variable<int>(distanceM);
    map['environment'] = Variable<String>(environment);
    if (!nullToAbsent || targetFaceCm != null) {
      map['target_face_cm'] = Variable<int>(targetFaceCm);
    }
    if (!nullToAbsent || targetFaceId != null) {
      map['target_face_id'] = Variable<String>(targetFaceId);
    }
    map['num_ends'] = Variable<int>(numEnds);
    map['arrows_per_end'] = Variable<int>(arrowsPerEnd);
    map['status'] = Variable<String>(status);
    map['participant_count'] = Variable<int>(participantCount);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  GroupSessionRowsCompanion toCompanion(bool nullToAbsent) {
    return GroupSessionRowsCompanion(
      id: Value(id),
      joinCode: Value(joinCode),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      hostUserId: Value(hostUserId),
      hostName: hostName == null && nullToAbsent
          ? const Value.absent()
          : Value(hostName),
      distanceCategory: Value(distanceCategory),
      distanceM: Value(distanceM),
      environment: Value(environment),
      targetFaceCm: targetFaceCm == null && nullToAbsent
          ? const Value.absent()
          : Value(targetFaceCm),
      targetFaceId: targetFaceId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetFaceId),
      numEnds: Value(numEnds),
      arrowsPerEnd: Value(arrowsPerEnd),
      status: Value(status),
      participantCount: Value(participantCount),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory GroupSessionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupSessionRow(
      id: serializer.fromJson<String>(json['id']),
      joinCode: serializer.fromJson<String>(json['joinCode']),
      title: serializer.fromJson<String?>(json['title']),
      hostUserId: serializer.fromJson<int>(json['hostUserId']),
      hostName: serializer.fromJson<String?>(json['hostName']),
      distanceCategory: serializer.fromJson<String>(json['distanceCategory']),
      distanceM: serializer.fromJson<int>(json['distanceM']),
      environment: serializer.fromJson<String>(json['environment']),
      targetFaceCm: serializer.fromJson<int?>(json['targetFaceCm']),
      targetFaceId: serializer.fromJson<String?>(json['targetFaceId']),
      numEnds: serializer.fromJson<int>(json['numEnds']),
      arrowsPerEnd: serializer.fromJson<int>(json['arrowsPerEnd']),
      status: serializer.fromJson<String>(json['status']),
      participantCount: serializer.fromJson<int>(json['participantCount']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'joinCode': serializer.toJson<String>(joinCode),
      'title': serializer.toJson<String?>(title),
      'hostUserId': serializer.toJson<int>(hostUserId),
      'hostName': serializer.toJson<String?>(hostName),
      'distanceCategory': serializer.toJson<String>(distanceCategory),
      'distanceM': serializer.toJson<int>(distanceM),
      'environment': serializer.toJson<String>(environment),
      'targetFaceCm': serializer.toJson<int?>(targetFaceCm),
      'targetFaceId': serializer.toJson<String?>(targetFaceId),
      'numEnds': serializer.toJson<int>(numEnds),
      'arrowsPerEnd': serializer.toJson<int>(arrowsPerEnd),
      'status': serializer.toJson<String>(status),
      'participantCount': serializer.toJson<int>(participantCount),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  GroupSessionRow copyWith(
          {String? id,
          String? joinCode,
          Value<String?> title = const Value.absent(),
          int? hostUserId,
          Value<String?> hostName = const Value.absent(),
          String? distanceCategory,
          int? distanceM,
          String? environment,
          Value<int?> targetFaceCm = const Value.absent(),
          Value<String?> targetFaceId = const Value.absent(),
          int? numEnds,
          int? arrowsPerEnd,
          String? status,
          int? participantCount,
          DateTime? startedAt,
          Value<DateTime?> completedAt = const Value.absent(),
          DateTime? cachedAt}) =>
      GroupSessionRow(
        id: id ?? this.id,
        joinCode: joinCode ?? this.joinCode,
        title: title.present ? title.value : this.title,
        hostUserId: hostUserId ?? this.hostUserId,
        hostName: hostName.present ? hostName.value : this.hostName,
        distanceCategory: distanceCategory ?? this.distanceCategory,
        distanceM: distanceM ?? this.distanceM,
        environment: environment ?? this.environment,
        targetFaceCm:
            targetFaceCm.present ? targetFaceCm.value : this.targetFaceCm,
        targetFaceId:
            targetFaceId.present ? targetFaceId.value : this.targetFaceId,
        numEnds: numEnds ?? this.numEnds,
        arrowsPerEnd: arrowsPerEnd ?? this.arrowsPerEnd,
        status: status ?? this.status,
        participantCount: participantCount ?? this.participantCount,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  GroupSessionRow copyWithCompanion(GroupSessionRowsCompanion data) {
    return GroupSessionRow(
      id: data.id.present ? data.id.value : this.id,
      joinCode: data.joinCode.present ? data.joinCode.value : this.joinCode,
      title: data.title.present ? data.title.value : this.title,
      hostUserId:
          data.hostUserId.present ? data.hostUserId.value : this.hostUserId,
      hostName: data.hostName.present ? data.hostName.value : this.hostName,
      distanceCategory: data.distanceCategory.present
          ? data.distanceCategory.value
          : this.distanceCategory,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      environment:
          data.environment.present ? data.environment.value : this.environment,
      targetFaceCm: data.targetFaceCm.present
          ? data.targetFaceCm.value
          : this.targetFaceCm,
      targetFaceId: data.targetFaceId.present
          ? data.targetFaceId.value
          : this.targetFaceId,
      numEnds: data.numEnds.present ? data.numEnds.value : this.numEnds,
      arrowsPerEnd: data.arrowsPerEnd.present
          ? data.arrowsPerEnd.value
          : this.arrowsPerEnd,
      status: data.status.present ? data.status.value : this.status,
      participantCount: data.participantCount.present
          ? data.participantCount.value
          : this.participantCount,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupSessionRow(')
          ..write('id: $id, ')
          ..write('joinCode: $joinCode, ')
          ..write('title: $title, ')
          ..write('hostUserId: $hostUserId, ')
          ..write('hostName: $hostName, ')
          ..write('distanceCategory: $distanceCategory, ')
          ..write('distanceM: $distanceM, ')
          ..write('environment: $environment, ')
          ..write('targetFaceCm: $targetFaceCm, ')
          ..write('targetFaceId: $targetFaceId, ')
          ..write('numEnds: $numEnds, ')
          ..write('arrowsPerEnd: $arrowsPerEnd, ')
          ..write('status: $status, ')
          ..write('participantCount: $participantCount, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      joinCode,
      title,
      hostUserId,
      hostName,
      distanceCategory,
      distanceM,
      environment,
      targetFaceCm,
      targetFaceId,
      numEnds,
      arrowsPerEnd,
      status,
      participantCount,
      startedAt,
      completedAt,
      cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupSessionRow &&
          other.id == this.id &&
          other.joinCode == this.joinCode &&
          other.title == this.title &&
          other.hostUserId == this.hostUserId &&
          other.hostName == this.hostName &&
          other.distanceCategory == this.distanceCategory &&
          other.distanceM == this.distanceM &&
          other.environment == this.environment &&
          other.targetFaceCm == this.targetFaceCm &&
          other.targetFaceId == this.targetFaceId &&
          other.numEnds == this.numEnds &&
          other.arrowsPerEnd == this.arrowsPerEnd &&
          other.status == this.status &&
          other.participantCount == this.participantCount &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.cachedAt == this.cachedAt);
}

class GroupSessionRowsCompanion extends UpdateCompanion<GroupSessionRow> {
  final Value<String> id;
  final Value<String> joinCode;
  final Value<String?> title;
  final Value<int> hostUserId;
  final Value<String?> hostName;
  final Value<String> distanceCategory;
  final Value<int> distanceM;
  final Value<String> environment;
  final Value<int?> targetFaceCm;
  final Value<String?> targetFaceId;
  final Value<int> numEnds;
  final Value<int> arrowsPerEnd;
  final Value<String> status;
  final Value<int> participantCount;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const GroupSessionRowsCompanion({
    this.id = const Value.absent(),
    this.joinCode = const Value.absent(),
    this.title = const Value.absent(),
    this.hostUserId = const Value.absent(),
    this.hostName = const Value.absent(),
    this.distanceCategory = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.environment = const Value.absent(),
    this.targetFaceCm = const Value.absent(),
    this.targetFaceId = const Value.absent(),
    this.numEnds = const Value.absent(),
    this.arrowsPerEnd = const Value.absent(),
    this.status = const Value.absent(),
    this.participantCount = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupSessionRowsCompanion.insert({
    required String id,
    required String joinCode,
    this.title = const Value.absent(),
    required int hostUserId,
    this.hostName = const Value.absent(),
    required String distanceCategory,
    required int distanceM,
    this.environment = const Value.absent(),
    this.targetFaceCm = const Value.absent(),
    this.targetFaceId = const Value.absent(),
    required int numEnds,
    required int arrowsPerEnd,
    this.status = const Value.absent(),
    this.participantCount = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        joinCode = Value(joinCode),
        hostUserId = Value(hostUserId),
        distanceCategory = Value(distanceCategory),
        distanceM = Value(distanceM),
        numEnds = Value(numEnds),
        arrowsPerEnd = Value(arrowsPerEnd),
        startedAt = Value(startedAt),
        cachedAt = Value(cachedAt);
  static Insertable<GroupSessionRow> custom({
    Expression<String>? id,
    Expression<String>? joinCode,
    Expression<String>? title,
    Expression<int>? hostUserId,
    Expression<String>? hostName,
    Expression<String>? distanceCategory,
    Expression<int>? distanceM,
    Expression<String>? environment,
    Expression<int>? targetFaceCm,
    Expression<String>? targetFaceId,
    Expression<int>? numEnds,
    Expression<int>? arrowsPerEnd,
    Expression<String>? status,
    Expression<int>? participantCount,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (joinCode != null) 'join_code': joinCode,
      if (title != null) 'title': title,
      if (hostUserId != null) 'host_user_id': hostUserId,
      if (hostName != null) 'host_name': hostName,
      if (distanceCategory != null) 'distance_category': distanceCategory,
      if (distanceM != null) 'distance_m': distanceM,
      if (environment != null) 'environment': environment,
      if (targetFaceCm != null) 'target_face_cm': targetFaceCm,
      if (targetFaceId != null) 'target_face_id': targetFaceId,
      if (numEnds != null) 'num_ends': numEnds,
      if (arrowsPerEnd != null) 'arrows_per_end': arrowsPerEnd,
      if (status != null) 'status': status,
      if (participantCount != null) 'participant_count': participantCount,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupSessionRowsCompanion copyWith(
      {Value<String>? id,
      Value<String>? joinCode,
      Value<String?>? title,
      Value<int>? hostUserId,
      Value<String?>? hostName,
      Value<String>? distanceCategory,
      Value<int>? distanceM,
      Value<String>? environment,
      Value<int?>? targetFaceCm,
      Value<String?>? targetFaceId,
      Value<int>? numEnds,
      Value<int>? arrowsPerEnd,
      Value<String>? status,
      Value<int>? participantCount,
      Value<DateTime>? startedAt,
      Value<DateTime?>? completedAt,
      Value<DateTime>? cachedAt,
      Value<int>? rowid}) {
    return GroupSessionRowsCompanion(
      id: id ?? this.id,
      joinCode: joinCode ?? this.joinCode,
      title: title ?? this.title,
      hostUserId: hostUserId ?? this.hostUserId,
      hostName: hostName ?? this.hostName,
      distanceCategory: distanceCategory ?? this.distanceCategory,
      distanceM: distanceM ?? this.distanceM,
      environment: environment ?? this.environment,
      targetFaceCm: targetFaceCm ?? this.targetFaceCm,
      targetFaceId: targetFaceId ?? this.targetFaceId,
      numEnds: numEnds ?? this.numEnds,
      arrowsPerEnd: arrowsPerEnd ?? this.arrowsPerEnd,
      status: status ?? this.status,
      participantCount: participantCount ?? this.participantCount,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (joinCode.present) {
      map['join_code'] = Variable<String>(joinCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (hostUserId.present) {
      map['host_user_id'] = Variable<int>(hostUserId.value);
    }
    if (hostName.present) {
      map['host_name'] = Variable<String>(hostName.value);
    }
    if (distanceCategory.present) {
      map['distance_category'] = Variable<String>(distanceCategory.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<int>(distanceM.value);
    }
    if (environment.present) {
      map['environment'] = Variable<String>(environment.value);
    }
    if (targetFaceCm.present) {
      map['target_face_cm'] = Variable<int>(targetFaceCm.value);
    }
    if (targetFaceId.present) {
      map['target_face_id'] = Variable<String>(targetFaceId.value);
    }
    if (numEnds.present) {
      map['num_ends'] = Variable<int>(numEnds.value);
    }
    if (arrowsPerEnd.present) {
      map['arrows_per_end'] = Variable<int>(arrowsPerEnd.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (participantCount.present) {
      map['participant_count'] = Variable<int>(participantCount.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupSessionRowsCompanion(')
          ..write('id: $id, ')
          ..write('joinCode: $joinCode, ')
          ..write('title: $title, ')
          ..write('hostUserId: $hostUserId, ')
          ..write('hostName: $hostName, ')
          ..write('distanceCategory: $distanceCategory, ')
          ..write('distanceM: $distanceM, ')
          ..write('environment: $environment, ')
          ..write('targetFaceCm: $targetFaceCm, ')
          ..write('targetFaceId: $targetFaceId, ')
          ..write('numEnds: $numEnds, ')
          ..write('arrowsPerEnd: $arrowsPerEnd, ')
          ..write('status: $status, ')
          ..write('participantCount: $participantCount, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GroupParticipantCacheRowsTable extends GroupParticipantCacheRows
    with TableInfo<$GroupParticipantCacheRowsTable, GroupParticipantCacheRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupParticipantCacheRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _guestNameMeta =
      const VerificationMeta('guestName');
  @override
  late final GeneratedColumn<String> guestName = GeneratedColumn<String>(
      'guest_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isGuestMeta =
      const VerificationMeta('isGuest');
  @override
  late final GeneratedColumn<bool> isGuest = GeneratedColumn<bool>(
      'is_guest', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_guest" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bowClassMeta =
      const VerificationMeta('bowClass');
  @override
  late final GeneratedColumn<String> bowClass = GeneratedColumn<String>(
      'bow_class', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _distanceCategoryMeta =
      const VerificationMeta('distanceCategory');
  @override
  late final GeneratedColumn<String> distanceCategory = GeneratedColumn<String>(
      'distance_category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _distanceMMeta =
      const VerificationMeta('distanceM');
  @override
  late final GeneratedColumn<int> distanceM = GeneratedColumn<int>(
      'distance_m', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _targetFaceCmMeta =
      const VerificationMeta('targetFaceCm');
  @override
  late final GeneratedColumn<int> targetFaceCm = GeneratedColumn<int>(
      'target_face_cm', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _targetButtMeta =
      const VerificationMeta('targetButt');
  @override
  late final GeneratedColumn<int> targetButt = GeneratedColumn<int>(
      'target_butt', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _targetLetterMeta =
      const VerificationMeta('targetLetter');
  @override
  late final GeneratedColumn<String> targetLetter = GeneratedColumn<String>(
      'target_letter', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastScoredByUserIdMeta =
      const VerificationMeta('lastScoredByUserId');
  @override
  late final GeneratedColumn<int> lastScoredByUserId = GeneratedColumn<int>(
      'last_scored_by_user_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _totalScoreMeta =
      const VerificationMeta('totalScore');
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
      'total_score', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _maxPossibleScoreMeta =
      const VerificationMeta('maxPossibleScore');
  @override
  late final GeneratedColumn<int> maxPossibleScore = GeneratedColumn<int>(
      'max_possible_score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _arrowsShotMeta =
      const VerificationMeta('arrowsShot');
  @override
  late final GeneratedColumn<int> arrowsShot = GeneratedColumn<int>(
      'arrows_shot', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _xCountMeta = const VerificationMeta('xCount');
  @override
  late final GeneratedColumn<int> xCount = GeneratedColumn<int>(
      'x_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _tenCountMeta =
      const VerificationMeta('tenCount');
  @override
  late final GeneratedColumn<int> tenCount = GeneratedColumn<int>(
      'ten_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        userId,
        displayName,
        guestName,
        isGuest,
        bowClass,
        distanceCategory,
        distanceM,
        targetFaceCm,
        targetButt,
        targetLetter,
        lastScoredByUserId,
        totalScore,
        maxPossibleScore,
        arrowsShot,
        xCount,
        tenCount,
        status,
        cachedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_participant_cache_rows';
  @override
  VerificationContext validateIntegrity(
      Insertable<GroupParticipantCacheRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('guest_name')) {
      context.handle(_guestNameMeta,
          guestName.isAcceptableOrUnknown(data['guest_name']!, _guestNameMeta));
    }
    if (data.containsKey('is_guest')) {
      context.handle(_isGuestMeta,
          isGuest.isAcceptableOrUnknown(data['is_guest']!, _isGuestMeta));
    }
    if (data.containsKey('bow_class')) {
      context.handle(_bowClassMeta,
          bowClass.isAcceptableOrUnknown(data['bow_class']!, _bowClassMeta));
    }
    if (data.containsKey('distance_category')) {
      context.handle(
          _distanceCategoryMeta,
          distanceCategory.isAcceptableOrUnknown(
              data['distance_category']!, _distanceCategoryMeta));
    }
    if (data.containsKey('distance_m')) {
      context.handle(_distanceMMeta,
          distanceM.isAcceptableOrUnknown(data['distance_m']!, _distanceMMeta));
    }
    if (data.containsKey('target_face_cm')) {
      context.handle(
          _targetFaceCmMeta,
          targetFaceCm.isAcceptableOrUnknown(
              data['target_face_cm']!, _targetFaceCmMeta));
    }
    if (data.containsKey('target_butt')) {
      context.handle(
          _targetButtMeta,
          targetButt.isAcceptableOrUnknown(
              data['target_butt']!, _targetButtMeta));
    }
    if (data.containsKey('target_letter')) {
      context.handle(
          _targetLetterMeta,
          targetLetter.isAcceptableOrUnknown(
              data['target_letter']!, _targetLetterMeta));
    }
    if (data.containsKey('last_scored_by_user_id')) {
      context.handle(
          _lastScoredByUserIdMeta,
          lastScoredByUserId.isAcceptableOrUnknown(
              data['last_scored_by_user_id']!, _lastScoredByUserIdMeta));
    }
    if (data.containsKey('total_score')) {
      context.handle(
          _totalScoreMeta,
          totalScore.isAcceptableOrUnknown(
              data['total_score']!, _totalScoreMeta));
    }
    if (data.containsKey('max_possible_score')) {
      context.handle(
          _maxPossibleScoreMeta,
          maxPossibleScore.isAcceptableOrUnknown(
              data['max_possible_score']!, _maxPossibleScoreMeta));
    }
    if (data.containsKey('arrows_shot')) {
      context.handle(
          _arrowsShotMeta,
          arrowsShot.isAcceptableOrUnknown(
              data['arrows_shot']!, _arrowsShotMeta));
    }
    if (data.containsKey('x_count')) {
      context.handle(_xCountMeta,
          xCount.isAcceptableOrUnknown(data['x_count']!, _xCountMeta));
    }
    if (data.containsKey('ten_count')) {
      context.handle(_tenCountMeta,
          tenCount.isAcceptableOrUnknown(data['ten_count']!, _tenCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupParticipantCacheRow map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupParticipantCacheRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id']),
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      guestName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}guest_name']),
      isGuest: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_guest'])!,
      bowClass: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bow_class']),
      distanceCategory: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}distance_category']),
      distanceM: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}distance_m']),
      targetFaceCm: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_face_cm']),
      targetButt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_butt']),
      targetLetter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_letter']),
      lastScoredByUserId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_scored_by_user_id']),
      totalScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_score'])!,
      maxPossibleScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_possible_score']),
      arrowsShot: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}arrows_shot'])!,
      xCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}x_count'])!,
      tenCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ten_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $GroupParticipantCacheRowsTable createAlias(String alias) {
    return $GroupParticipantCacheRowsTable(attachedDatabase, alias);
  }
}

class GroupParticipantCacheRow extends DataClass
    implements Insertable<GroupParticipantCacheRow> {
  final String id;
  final String groupId;
  final int? userId;
  final String? displayName;
  final String? guestName;
  final bool isGuest;
  final String? bowClass;
  final String? distanceCategory;
  final int? distanceM;
  final int? targetFaceCm;
  final int? targetButt;
  final String? targetLetter;
  final int? lastScoredByUserId;
  final int totalScore;
  final int? maxPossibleScore;
  final int arrowsShot;
  final int xCount;
  final int tenCount;
  final String? status;
  final DateTime cachedAt;
  const GroupParticipantCacheRow(
      {required this.id,
      required this.groupId,
      this.userId,
      this.displayName,
      this.guestName,
      required this.isGuest,
      this.bowClass,
      this.distanceCategory,
      this.distanceM,
      this.targetFaceCm,
      this.targetButt,
      this.targetLetter,
      this.lastScoredByUserId,
      required this.totalScore,
      this.maxPossibleScore,
      required this.arrowsShot,
      required this.xCount,
      required this.tenCount,
      this.status,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['group_id'] = Variable<String>(groupId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || guestName != null) {
      map['guest_name'] = Variable<String>(guestName);
    }
    map['is_guest'] = Variable<bool>(isGuest);
    if (!nullToAbsent || bowClass != null) {
      map['bow_class'] = Variable<String>(bowClass);
    }
    if (!nullToAbsent || distanceCategory != null) {
      map['distance_category'] = Variable<String>(distanceCategory);
    }
    if (!nullToAbsent || distanceM != null) {
      map['distance_m'] = Variable<int>(distanceM);
    }
    if (!nullToAbsent || targetFaceCm != null) {
      map['target_face_cm'] = Variable<int>(targetFaceCm);
    }
    if (!nullToAbsent || targetButt != null) {
      map['target_butt'] = Variable<int>(targetButt);
    }
    if (!nullToAbsent || targetLetter != null) {
      map['target_letter'] = Variable<String>(targetLetter);
    }
    if (!nullToAbsent || lastScoredByUserId != null) {
      map['last_scored_by_user_id'] = Variable<int>(lastScoredByUserId);
    }
    map['total_score'] = Variable<int>(totalScore);
    if (!nullToAbsent || maxPossibleScore != null) {
      map['max_possible_score'] = Variable<int>(maxPossibleScore);
    }
    map['arrows_shot'] = Variable<int>(arrowsShot);
    map['x_count'] = Variable<int>(xCount);
    map['ten_count'] = Variable<int>(tenCount);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  GroupParticipantCacheRowsCompanion toCompanion(bool nullToAbsent) {
    return GroupParticipantCacheRowsCompanion(
      id: Value(id),
      groupId: Value(groupId),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      guestName: guestName == null && nullToAbsent
          ? const Value.absent()
          : Value(guestName),
      isGuest: Value(isGuest),
      bowClass: bowClass == null && nullToAbsent
          ? const Value.absent()
          : Value(bowClass),
      distanceCategory: distanceCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceCategory),
      distanceM: distanceM == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceM),
      targetFaceCm: targetFaceCm == null && nullToAbsent
          ? const Value.absent()
          : Value(targetFaceCm),
      targetButt: targetButt == null && nullToAbsent
          ? const Value.absent()
          : Value(targetButt),
      targetLetter: targetLetter == null && nullToAbsent
          ? const Value.absent()
          : Value(targetLetter),
      lastScoredByUserId: lastScoredByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastScoredByUserId),
      totalScore: Value(totalScore),
      maxPossibleScore: maxPossibleScore == null && nullToAbsent
          ? const Value.absent()
          : Value(maxPossibleScore),
      arrowsShot: Value(arrowsShot),
      xCount: Value(xCount),
      tenCount: Value(tenCount),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      cachedAt: Value(cachedAt),
    );
  }

  factory GroupParticipantCacheRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupParticipantCacheRow(
      id: serializer.fromJson<String>(json['id']),
      groupId: serializer.fromJson<String>(json['groupId']),
      userId: serializer.fromJson<int?>(json['userId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      guestName: serializer.fromJson<String?>(json['guestName']),
      isGuest: serializer.fromJson<bool>(json['isGuest']),
      bowClass: serializer.fromJson<String?>(json['bowClass']),
      distanceCategory: serializer.fromJson<String?>(json['distanceCategory']),
      distanceM: serializer.fromJson<int?>(json['distanceM']),
      targetFaceCm: serializer.fromJson<int?>(json['targetFaceCm']),
      targetButt: serializer.fromJson<int?>(json['targetButt']),
      targetLetter: serializer.fromJson<String?>(json['targetLetter']),
      lastScoredByUserId: serializer.fromJson<int?>(json['lastScoredByUserId']),
      totalScore: serializer.fromJson<int>(json['totalScore']),
      maxPossibleScore: serializer.fromJson<int?>(json['maxPossibleScore']),
      arrowsShot: serializer.fromJson<int>(json['arrowsShot']),
      xCount: serializer.fromJson<int>(json['xCount']),
      tenCount: serializer.fromJson<int>(json['tenCount']),
      status: serializer.fromJson<String?>(json['status']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupId': serializer.toJson<String>(groupId),
      'userId': serializer.toJson<int?>(userId),
      'displayName': serializer.toJson<String?>(displayName),
      'guestName': serializer.toJson<String?>(guestName),
      'isGuest': serializer.toJson<bool>(isGuest),
      'bowClass': serializer.toJson<String?>(bowClass),
      'distanceCategory': serializer.toJson<String?>(distanceCategory),
      'distanceM': serializer.toJson<int?>(distanceM),
      'targetFaceCm': serializer.toJson<int?>(targetFaceCm),
      'targetButt': serializer.toJson<int?>(targetButt),
      'targetLetter': serializer.toJson<String?>(targetLetter),
      'lastScoredByUserId': serializer.toJson<int?>(lastScoredByUserId),
      'totalScore': serializer.toJson<int>(totalScore),
      'maxPossibleScore': serializer.toJson<int?>(maxPossibleScore),
      'arrowsShot': serializer.toJson<int>(arrowsShot),
      'xCount': serializer.toJson<int>(xCount),
      'tenCount': serializer.toJson<int>(tenCount),
      'status': serializer.toJson<String?>(status),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  GroupParticipantCacheRow copyWith(
          {String? id,
          String? groupId,
          Value<int?> userId = const Value.absent(),
          Value<String?> displayName = const Value.absent(),
          Value<String?> guestName = const Value.absent(),
          bool? isGuest,
          Value<String?> bowClass = const Value.absent(),
          Value<String?> distanceCategory = const Value.absent(),
          Value<int?> distanceM = const Value.absent(),
          Value<int?> targetFaceCm = const Value.absent(),
          Value<int?> targetButt = const Value.absent(),
          Value<String?> targetLetter = const Value.absent(),
          Value<int?> lastScoredByUserId = const Value.absent(),
          int? totalScore,
          Value<int?> maxPossibleScore = const Value.absent(),
          int? arrowsShot,
          int? xCount,
          int? tenCount,
          Value<String?> status = const Value.absent(),
          DateTime? cachedAt}) =>
      GroupParticipantCacheRow(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        userId: userId.present ? userId.value : this.userId,
        displayName: displayName.present ? displayName.value : this.displayName,
        guestName: guestName.present ? guestName.value : this.guestName,
        isGuest: isGuest ?? this.isGuest,
        bowClass: bowClass.present ? bowClass.value : this.bowClass,
        distanceCategory: distanceCategory.present
            ? distanceCategory.value
            : this.distanceCategory,
        distanceM: distanceM.present ? distanceM.value : this.distanceM,
        targetFaceCm:
            targetFaceCm.present ? targetFaceCm.value : this.targetFaceCm,
        targetButt: targetButt.present ? targetButt.value : this.targetButt,
        targetLetter:
            targetLetter.present ? targetLetter.value : this.targetLetter,
        lastScoredByUserId: lastScoredByUserId.present
            ? lastScoredByUserId.value
            : this.lastScoredByUserId,
        totalScore: totalScore ?? this.totalScore,
        maxPossibleScore: maxPossibleScore.present
            ? maxPossibleScore.value
            : this.maxPossibleScore,
        arrowsShot: arrowsShot ?? this.arrowsShot,
        xCount: xCount ?? this.xCount,
        tenCount: tenCount ?? this.tenCount,
        status: status.present ? status.value : this.status,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  GroupParticipantCacheRow copyWithCompanion(
      GroupParticipantCacheRowsCompanion data) {
    return GroupParticipantCacheRow(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      userId: data.userId.present ? data.userId.value : this.userId,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      guestName: data.guestName.present ? data.guestName.value : this.guestName,
      isGuest: data.isGuest.present ? data.isGuest.value : this.isGuest,
      bowClass: data.bowClass.present ? data.bowClass.value : this.bowClass,
      distanceCategory: data.distanceCategory.present
          ? data.distanceCategory.value
          : this.distanceCategory,
      distanceM: data.distanceM.present ? data.distanceM.value : this.distanceM,
      targetFaceCm: data.targetFaceCm.present
          ? data.targetFaceCm.value
          : this.targetFaceCm,
      targetButt:
          data.targetButt.present ? data.targetButt.value : this.targetButt,
      targetLetter: data.targetLetter.present
          ? data.targetLetter.value
          : this.targetLetter,
      lastScoredByUserId: data.lastScoredByUserId.present
          ? data.lastScoredByUserId.value
          : this.lastScoredByUserId,
      totalScore:
          data.totalScore.present ? data.totalScore.value : this.totalScore,
      maxPossibleScore: data.maxPossibleScore.present
          ? data.maxPossibleScore.value
          : this.maxPossibleScore,
      arrowsShot:
          data.arrowsShot.present ? data.arrowsShot.value : this.arrowsShot,
      xCount: data.xCount.present ? data.xCount.value : this.xCount,
      tenCount: data.tenCount.present ? data.tenCount.value : this.tenCount,
      status: data.status.present ? data.status.value : this.status,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupParticipantCacheRow(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('guestName: $guestName, ')
          ..write('isGuest: $isGuest, ')
          ..write('bowClass: $bowClass, ')
          ..write('distanceCategory: $distanceCategory, ')
          ..write('distanceM: $distanceM, ')
          ..write('targetFaceCm: $targetFaceCm, ')
          ..write('targetButt: $targetButt, ')
          ..write('targetLetter: $targetLetter, ')
          ..write('lastScoredByUserId: $lastScoredByUserId, ')
          ..write('totalScore: $totalScore, ')
          ..write('maxPossibleScore: $maxPossibleScore, ')
          ..write('arrowsShot: $arrowsShot, ')
          ..write('xCount: $xCount, ')
          ..write('tenCount: $tenCount, ')
          ..write('status: $status, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      groupId,
      userId,
      displayName,
      guestName,
      isGuest,
      bowClass,
      distanceCategory,
      distanceM,
      targetFaceCm,
      targetButt,
      targetLetter,
      lastScoredByUserId,
      totalScore,
      maxPossibleScore,
      arrowsShot,
      xCount,
      tenCount,
      status,
      cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupParticipantCacheRow &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.userId == this.userId &&
          other.displayName == this.displayName &&
          other.guestName == this.guestName &&
          other.isGuest == this.isGuest &&
          other.bowClass == this.bowClass &&
          other.distanceCategory == this.distanceCategory &&
          other.distanceM == this.distanceM &&
          other.targetFaceCm == this.targetFaceCm &&
          other.targetButt == this.targetButt &&
          other.targetLetter == this.targetLetter &&
          other.lastScoredByUserId == this.lastScoredByUserId &&
          other.totalScore == this.totalScore &&
          other.maxPossibleScore == this.maxPossibleScore &&
          other.arrowsShot == this.arrowsShot &&
          other.xCount == this.xCount &&
          other.tenCount == this.tenCount &&
          other.status == this.status &&
          other.cachedAt == this.cachedAt);
}

class GroupParticipantCacheRowsCompanion
    extends UpdateCompanion<GroupParticipantCacheRow> {
  final Value<String> id;
  final Value<String> groupId;
  final Value<int?> userId;
  final Value<String?> displayName;
  final Value<String?> guestName;
  final Value<bool> isGuest;
  final Value<String?> bowClass;
  final Value<String?> distanceCategory;
  final Value<int?> distanceM;
  final Value<int?> targetFaceCm;
  final Value<int?> targetButt;
  final Value<String?> targetLetter;
  final Value<int?> lastScoredByUserId;
  final Value<int> totalScore;
  final Value<int?> maxPossibleScore;
  final Value<int> arrowsShot;
  final Value<int> xCount;
  final Value<int> tenCount;
  final Value<String?> status;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const GroupParticipantCacheRowsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.guestName = const Value.absent(),
    this.isGuest = const Value.absent(),
    this.bowClass = const Value.absent(),
    this.distanceCategory = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.targetFaceCm = const Value.absent(),
    this.targetButt = const Value.absent(),
    this.targetLetter = const Value.absent(),
    this.lastScoredByUserId = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.maxPossibleScore = const Value.absent(),
    this.arrowsShot = const Value.absent(),
    this.xCount = const Value.absent(),
    this.tenCount = const Value.absent(),
    this.status = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GroupParticipantCacheRowsCompanion.insert({
    required String id,
    required String groupId,
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.guestName = const Value.absent(),
    this.isGuest = const Value.absent(),
    this.bowClass = const Value.absent(),
    this.distanceCategory = const Value.absent(),
    this.distanceM = const Value.absent(),
    this.targetFaceCm = const Value.absent(),
    this.targetButt = const Value.absent(),
    this.targetLetter = const Value.absent(),
    this.lastScoredByUserId = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.maxPossibleScore = const Value.absent(),
    this.arrowsShot = const Value.absent(),
    this.xCount = const Value.absent(),
    this.tenCount = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        groupId = Value(groupId),
        cachedAt = Value(cachedAt);
  static Insertable<GroupParticipantCacheRow> custom({
    Expression<String>? id,
    Expression<String>? groupId,
    Expression<int>? userId,
    Expression<String>? displayName,
    Expression<String>? guestName,
    Expression<bool>? isGuest,
    Expression<String>? bowClass,
    Expression<String>? distanceCategory,
    Expression<int>? distanceM,
    Expression<int>? targetFaceCm,
    Expression<int>? targetButt,
    Expression<String>? targetLetter,
    Expression<int>? lastScoredByUserId,
    Expression<int>? totalScore,
    Expression<int>? maxPossibleScore,
    Expression<int>? arrowsShot,
    Expression<int>? xCount,
    Expression<int>? tenCount,
    Expression<String>? status,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (userId != null) 'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (guestName != null) 'guest_name': guestName,
      if (isGuest != null) 'is_guest': isGuest,
      if (bowClass != null) 'bow_class': bowClass,
      if (distanceCategory != null) 'distance_category': distanceCategory,
      if (distanceM != null) 'distance_m': distanceM,
      if (targetFaceCm != null) 'target_face_cm': targetFaceCm,
      if (targetButt != null) 'target_butt': targetButt,
      if (targetLetter != null) 'target_letter': targetLetter,
      if (lastScoredByUserId != null)
        'last_scored_by_user_id': lastScoredByUserId,
      if (totalScore != null) 'total_score': totalScore,
      if (maxPossibleScore != null) 'max_possible_score': maxPossibleScore,
      if (arrowsShot != null) 'arrows_shot': arrowsShot,
      if (xCount != null) 'x_count': xCount,
      if (tenCount != null) 'ten_count': tenCount,
      if (status != null) 'status': status,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GroupParticipantCacheRowsCompanion copyWith(
      {Value<String>? id,
      Value<String>? groupId,
      Value<int?>? userId,
      Value<String?>? displayName,
      Value<String?>? guestName,
      Value<bool>? isGuest,
      Value<String?>? bowClass,
      Value<String?>? distanceCategory,
      Value<int?>? distanceM,
      Value<int?>? targetFaceCm,
      Value<int?>? targetButt,
      Value<String?>? targetLetter,
      Value<int?>? lastScoredByUserId,
      Value<int>? totalScore,
      Value<int?>? maxPossibleScore,
      Value<int>? arrowsShot,
      Value<int>? xCount,
      Value<int>? tenCount,
      Value<String?>? status,
      Value<DateTime>? cachedAt,
      Value<int>? rowid}) {
    return GroupParticipantCacheRowsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      guestName: guestName ?? this.guestName,
      isGuest: isGuest ?? this.isGuest,
      bowClass: bowClass ?? this.bowClass,
      distanceCategory: distanceCategory ?? this.distanceCategory,
      distanceM: distanceM ?? this.distanceM,
      targetFaceCm: targetFaceCm ?? this.targetFaceCm,
      targetButt: targetButt ?? this.targetButt,
      targetLetter: targetLetter ?? this.targetLetter,
      lastScoredByUserId: lastScoredByUserId ?? this.lastScoredByUserId,
      totalScore: totalScore ?? this.totalScore,
      maxPossibleScore: maxPossibleScore ?? this.maxPossibleScore,
      arrowsShot: arrowsShot ?? this.arrowsShot,
      xCount: xCount ?? this.xCount,
      tenCount: tenCount ?? this.tenCount,
      status: status ?? this.status,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (guestName.present) {
      map['guest_name'] = Variable<String>(guestName.value);
    }
    if (isGuest.present) {
      map['is_guest'] = Variable<bool>(isGuest.value);
    }
    if (bowClass.present) {
      map['bow_class'] = Variable<String>(bowClass.value);
    }
    if (distanceCategory.present) {
      map['distance_category'] = Variable<String>(distanceCategory.value);
    }
    if (distanceM.present) {
      map['distance_m'] = Variable<int>(distanceM.value);
    }
    if (targetFaceCm.present) {
      map['target_face_cm'] = Variable<int>(targetFaceCm.value);
    }
    if (targetButt.present) {
      map['target_butt'] = Variable<int>(targetButt.value);
    }
    if (targetLetter.present) {
      map['target_letter'] = Variable<String>(targetLetter.value);
    }
    if (lastScoredByUserId.present) {
      map['last_scored_by_user_id'] = Variable<int>(lastScoredByUserId.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (maxPossibleScore.present) {
      map['max_possible_score'] = Variable<int>(maxPossibleScore.value);
    }
    if (arrowsShot.present) {
      map['arrows_shot'] = Variable<int>(arrowsShot.value);
    }
    if (xCount.present) {
      map['x_count'] = Variable<int>(xCount.value);
    }
    if (tenCount.present) {
      map['ten_count'] = Variable<int>(tenCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupParticipantCacheRowsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('guestName: $guestName, ')
          ..write('isGuest: $isGuest, ')
          ..write('bowClass: $bowClass, ')
          ..write('distanceCategory: $distanceCategory, ')
          ..write('distanceM: $distanceM, ')
          ..write('targetFaceCm: $targetFaceCm, ')
          ..write('targetButt: $targetButt, ')
          ..write('targetLetter: $targetLetter, ')
          ..write('lastScoredByUserId: $lastScoredByUserId, ')
          ..write('totalScore: $totalScore, ')
          ..write('maxPossibleScore: $maxPossibleScore, ')
          ..write('arrowsShot: $arrowsShot, ')
          ..write('xCount: $xCount, ')
          ..write('tenCount: $tenCount, ')
          ..write('status: $status, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ScoringDatabase extends GeneratedDatabase {
  _$ScoringDatabase(QueryExecutor e) : super(e);
  $ScoringDatabaseManager get managers => $ScoringDatabaseManager(this);
  late final $ScoringSessionRowsTable scoringSessionRows =
      $ScoringSessionRowsTable(this);
  late final $ScoringEndRowsTable scoringEndRows = $ScoringEndRowsTable(this);
  late final $ScoringArrowRowsTable scoringArrowRows =
      $ScoringArrowRowsTable(this);
  late final $TargetFaceRowsTable targetFaceRows = $TargetFaceRowsTable(this);
  late final $GroupSessionRowsTable groupSessionRows =
      $GroupSessionRowsTable(this);
  late final $GroupParticipantCacheRowsTable groupParticipantCacheRows =
      $GroupParticipantCacheRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        scoringSessionRows,
        scoringEndRows,
        scoringArrowRows,
        targetFaceRows,
        groupSessionRows,
        groupParticipantCacheRows
      ];
}

typedef $$ScoringSessionRowsTableCreateCompanionBuilder
    = ScoringSessionRowsCompanion Function({
  required String id,
  required String clientUuid,
  Value<String?> equipmentProfileId,
  Value<String?> title,
  Value<String?> bowClass,
  required String distanceCategory,
  required int distanceM,
  Value<String> environment,
  Value<int?> targetFaceCm,
  Value<String?> targetFaceId,
  required int numEnds,
  required int arrowsPerEnd,
  Value<String> status,
  Value<int> totalScore,
  Value<int> arrowsShot,
  Value<int> xCount,
  Value<int> tenCount,
  Value<int> missCount,
  Value<bool> isPersonalBest,
  Value<String?> notes,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  Value<String> source,
  Value<bool> isSynced,
  Value<String?> syncAction,
  Value<DateTime?> updatedAt,
  Value<String?> scoringSessionGroupId,
  Value<String?> guestName,
  Value<int> rowid,
});
typedef $$ScoringSessionRowsTableUpdateCompanionBuilder
    = ScoringSessionRowsCompanion Function({
  Value<String> id,
  Value<String> clientUuid,
  Value<String?> equipmentProfileId,
  Value<String?> title,
  Value<String?> bowClass,
  Value<String> distanceCategory,
  Value<int> distanceM,
  Value<String> environment,
  Value<int?> targetFaceCm,
  Value<String?> targetFaceId,
  Value<int> numEnds,
  Value<int> arrowsPerEnd,
  Value<String> status,
  Value<int> totalScore,
  Value<int> arrowsShot,
  Value<int> xCount,
  Value<int> tenCount,
  Value<int> missCount,
  Value<bool> isPersonalBest,
  Value<String?> notes,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<String> source,
  Value<bool> isSynced,
  Value<String?> syncAction,
  Value<DateTime?> updatedAt,
  Value<String?> scoringSessionGroupId,
  Value<String?> guestName,
  Value<int> rowid,
});

class $$ScoringSessionRowsTableFilterComposer
    extends Composer<_$ScoringDatabase, $ScoringSessionRowsTable> {
  $$ScoringSessionRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientUuid => $composableBuilder(
      column: $table.clientUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get equipmentProfileId => $composableBuilder(
      column: $table.equipmentProfileId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bowClass => $composableBuilder(
      column: $table.bowClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get distanceM => $composableBuilder(
      column: $table.distanceM, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get environment => $composableBuilder(
      column: $table.environment, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetFaceId => $composableBuilder(
      column: $table.targetFaceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numEnds => $composableBuilder(
      column: $table.numEnds, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get arrowsPerEnd => $composableBuilder(
      column: $table.arrowsPerEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalScore => $composableBuilder(
      column: $table.totalScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get arrowsShot => $composableBuilder(
      column: $table.arrowsShot, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xCount => $composableBuilder(
      column: $table.xCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenCount => $composableBuilder(
      column: $table.tenCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get missCount => $composableBuilder(
      column: $table.missCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPersonalBest => $composableBuilder(
      column: $table.isPersonalBest,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncAction => $composableBuilder(
      column: $table.syncAction, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scoringSessionGroupId => $composableBuilder(
      column: $table.scoringSessionGroupId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guestName => $composableBuilder(
      column: $table.guestName, builder: (column) => ColumnFilters(column));
}

class $$ScoringSessionRowsTableOrderingComposer
    extends Composer<_$ScoringDatabase, $ScoringSessionRowsTable> {
  $$ScoringSessionRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientUuid => $composableBuilder(
      column: $table.clientUuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipmentProfileId => $composableBuilder(
      column: $table.equipmentProfileId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bowClass => $composableBuilder(
      column: $table.bowClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get distanceM => $composableBuilder(
      column: $table.distanceM, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get environment => $composableBuilder(
      column: $table.environment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetFaceId => $composableBuilder(
      column: $table.targetFaceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numEnds => $composableBuilder(
      column: $table.numEnds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get arrowsPerEnd => $composableBuilder(
      column: $table.arrowsPerEnd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalScore => $composableBuilder(
      column: $table.totalScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get arrowsShot => $composableBuilder(
      column: $table.arrowsShot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xCount => $composableBuilder(
      column: $table.xCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenCount => $composableBuilder(
      column: $table.tenCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get missCount => $composableBuilder(
      column: $table.missCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPersonalBest => $composableBuilder(
      column: $table.isPersonalBest,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncAction => $composableBuilder(
      column: $table.syncAction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scoringSessionGroupId => $composableBuilder(
      column: $table.scoringSessionGroupId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guestName => $composableBuilder(
      column: $table.guestName, builder: (column) => ColumnOrderings(column));
}

class $$ScoringSessionRowsTableAnnotationComposer
    extends Composer<_$ScoringDatabase, $ScoringSessionRowsTable> {
  $$ScoringSessionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get clientUuid => $composableBuilder(
      column: $table.clientUuid, builder: (column) => column);

  GeneratedColumn<String> get equipmentProfileId => $composableBuilder(
      column: $table.equipmentProfileId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get bowClass =>
      $composableBuilder(column: $table.bowClass, builder: (column) => column);

  GeneratedColumn<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory, builder: (column) => column);

  GeneratedColumn<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<String> get environment => $composableBuilder(
      column: $table.environment, builder: (column) => column);

  GeneratedColumn<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm, builder: (column) => column);

  GeneratedColumn<String> get targetFaceId => $composableBuilder(
      column: $table.targetFaceId, builder: (column) => column);

  GeneratedColumn<int> get numEnds =>
      $composableBuilder(column: $table.numEnds, builder: (column) => column);

  GeneratedColumn<int> get arrowsPerEnd => $composableBuilder(
      column: $table.arrowsPerEnd, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get totalScore => $composableBuilder(
      column: $table.totalScore, builder: (column) => column);

  GeneratedColumn<int> get arrowsShot => $composableBuilder(
      column: $table.arrowsShot, builder: (column) => column);

  GeneratedColumn<int> get xCount =>
      $composableBuilder(column: $table.xCount, builder: (column) => column);

  GeneratedColumn<int> get tenCount =>
      $composableBuilder(column: $table.tenCount, builder: (column) => column);

  GeneratedColumn<int> get missCount =>
      $composableBuilder(column: $table.missCount, builder: (column) => column);

  GeneratedColumn<bool> get isPersonalBest => $composableBuilder(
      column: $table.isPersonalBest, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<String> get syncAction => $composableBuilder(
      column: $table.syncAction, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get scoringSessionGroupId => $composableBuilder(
      column: $table.scoringSessionGroupId, builder: (column) => column);

  GeneratedColumn<String> get guestName =>
      $composableBuilder(column: $table.guestName, builder: (column) => column);
}

class $$ScoringSessionRowsTableTableManager extends RootTableManager<
    _$ScoringDatabase,
    $ScoringSessionRowsTable,
    ScoringSessionRow,
    $$ScoringSessionRowsTableFilterComposer,
    $$ScoringSessionRowsTableOrderingComposer,
    $$ScoringSessionRowsTableAnnotationComposer,
    $$ScoringSessionRowsTableCreateCompanionBuilder,
    $$ScoringSessionRowsTableUpdateCompanionBuilder,
    (
      ScoringSessionRow,
      BaseReferences<_$ScoringDatabase, $ScoringSessionRowsTable,
          ScoringSessionRow>
    ),
    ScoringSessionRow,
    PrefetchHooks Function()> {
  $$ScoringSessionRowsTableTableManager(
      _$ScoringDatabase db, $ScoringSessionRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScoringSessionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScoringSessionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScoringSessionRowsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> clientUuid = const Value.absent(),
            Value<String?> equipmentProfileId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> bowClass = const Value.absent(),
            Value<String> distanceCategory = const Value.absent(),
            Value<int> distanceM = const Value.absent(),
            Value<String> environment = const Value.absent(),
            Value<int?> targetFaceCm = const Value.absent(),
            Value<String?> targetFaceId = const Value.absent(),
            Value<int> numEnds = const Value.absent(),
            Value<int> arrowsPerEnd = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> totalScore = const Value.absent(),
            Value<int> arrowsShot = const Value.absent(),
            Value<int> xCount = const Value.absent(),
            Value<int> tenCount = const Value.absent(),
            Value<int> missCount = const Value.absent(),
            Value<bool> isPersonalBest = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String?> syncAction = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> scoringSessionGroupId = const Value.absent(),
            Value<String?> guestName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScoringSessionRowsCompanion(
            id: id,
            clientUuid: clientUuid,
            equipmentProfileId: equipmentProfileId,
            title: title,
            bowClass: bowClass,
            distanceCategory: distanceCategory,
            distanceM: distanceM,
            environment: environment,
            targetFaceCm: targetFaceCm,
            targetFaceId: targetFaceId,
            numEnds: numEnds,
            arrowsPerEnd: arrowsPerEnd,
            status: status,
            totalScore: totalScore,
            arrowsShot: arrowsShot,
            xCount: xCount,
            tenCount: tenCount,
            missCount: missCount,
            isPersonalBest: isPersonalBest,
            notes: notes,
            startedAt: startedAt,
            completedAt: completedAt,
            source: source,
            isSynced: isSynced,
            syncAction: syncAction,
            updatedAt: updatedAt,
            scoringSessionGroupId: scoringSessionGroupId,
            guestName: guestName,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String clientUuid,
            Value<String?> equipmentProfileId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> bowClass = const Value.absent(),
            required String distanceCategory,
            required int distanceM,
            Value<String> environment = const Value.absent(),
            Value<int?> targetFaceCm = const Value.absent(),
            Value<String?> targetFaceId = const Value.absent(),
            required int numEnds,
            required int arrowsPerEnd,
            Value<String> status = const Value.absent(),
            Value<int> totalScore = const Value.absent(),
            Value<int> arrowsShot = const Value.absent(),
            Value<int> xCount = const Value.absent(),
            Value<int> tenCount = const Value.absent(),
            Value<int> missCount = const Value.absent(),
            Value<bool> isPersonalBest = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<String?> syncAction = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<String?> scoringSessionGroupId = const Value.absent(),
            Value<String?> guestName = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScoringSessionRowsCompanion.insert(
            id: id,
            clientUuid: clientUuid,
            equipmentProfileId: equipmentProfileId,
            title: title,
            bowClass: bowClass,
            distanceCategory: distanceCategory,
            distanceM: distanceM,
            environment: environment,
            targetFaceCm: targetFaceCm,
            targetFaceId: targetFaceId,
            numEnds: numEnds,
            arrowsPerEnd: arrowsPerEnd,
            status: status,
            totalScore: totalScore,
            arrowsShot: arrowsShot,
            xCount: xCount,
            tenCount: tenCount,
            missCount: missCount,
            isPersonalBest: isPersonalBest,
            notes: notes,
            startedAt: startedAt,
            completedAt: completedAt,
            source: source,
            isSynced: isSynced,
            syncAction: syncAction,
            updatedAt: updatedAt,
            scoringSessionGroupId: scoringSessionGroupId,
            guestName: guestName,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScoringSessionRowsTableProcessedTableManager = ProcessedTableManager<
    _$ScoringDatabase,
    $ScoringSessionRowsTable,
    ScoringSessionRow,
    $$ScoringSessionRowsTableFilterComposer,
    $$ScoringSessionRowsTableOrderingComposer,
    $$ScoringSessionRowsTableAnnotationComposer,
    $$ScoringSessionRowsTableCreateCompanionBuilder,
    $$ScoringSessionRowsTableUpdateCompanionBuilder,
    (
      ScoringSessionRow,
      BaseReferences<_$ScoringDatabase, $ScoringSessionRowsTable,
          ScoringSessionRow>
    ),
    ScoringSessionRow,
    PrefetchHooks Function()>;
typedef $$ScoringEndRowsTableCreateCompanionBuilder = ScoringEndRowsCompanion
    Function({
  required String id,
  required String sessionId,
  required int endNumber,
  Value<int> rowid,
});
typedef $$ScoringEndRowsTableUpdateCompanionBuilder = ScoringEndRowsCompanion
    Function({
  Value<String> id,
  Value<String> sessionId,
  Value<int> endNumber,
  Value<int> rowid,
});

class $$ScoringEndRowsTableFilterComposer
    extends Composer<_$ScoringDatabase, $ScoringEndRowsTable> {
  $$ScoringEndRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get endNumber => $composableBuilder(
      column: $table.endNumber, builder: (column) => ColumnFilters(column));
}

class $$ScoringEndRowsTableOrderingComposer
    extends Composer<_$ScoringDatabase, $ScoringEndRowsTable> {
  $$ScoringEndRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get endNumber => $composableBuilder(
      column: $table.endNumber, builder: (column) => ColumnOrderings(column));
}

class $$ScoringEndRowsTableAnnotationComposer
    extends Composer<_$ScoringDatabase, $ScoringEndRowsTable> {
  $$ScoringEndRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get endNumber =>
      $composableBuilder(column: $table.endNumber, builder: (column) => column);
}

class $$ScoringEndRowsTableTableManager extends RootTableManager<
    _$ScoringDatabase,
    $ScoringEndRowsTable,
    ScoringEndRow,
    $$ScoringEndRowsTableFilterComposer,
    $$ScoringEndRowsTableOrderingComposer,
    $$ScoringEndRowsTableAnnotationComposer,
    $$ScoringEndRowsTableCreateCompanionBuilder,
    $$ScoringEndRowsTableUpdateCompanionBuilder,
    (
      ScoringEndRow,
      BaseReferences<_$ScoringDatabase, $ScoringEndRowsTable, ScoringEndRow>
    ),
    ScoringEndRow,
    PrefetchHooks Function()> {
  $$ScoringEndRowsTableTableManager(
      _$ScoringDatabase db, $ScoringEndRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScoringEndRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScoringEndRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScoringEndRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sessionId = const Value.absent(),
            Value<int> endNumber = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScoringEndRowsCompanion(
            id: id,
            sessionId: sessionId,
            endNumber: endNumber,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sessionId,
            required int endNumber,
            Value<int> rowid = const Value.absent(),
          }) =>
              ScoringEndRowsCompanion.insert(
            id: id,
            sessionId: sessionId,
            endNumber: endNumber,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScoringEndRowsTableProcessedTableManager = ProcessedTableManager<
    _$ScoringDatabase,
    $ScoringEndRowsTable,
    ScoringEndRow,
    $$ScoringEndRowsTableFilterComposer,
    $$ScoringEndRowsTableOrderingComposer,
    $$ScoringEndRowsTableAnnotationComposer,
    $$ScoringEndRowsTableCreateCompanionBuilder,
    $$ScoringEndRowsTableUpdateCompanionBuilder,
    (
      ScoringEndRow,
      BaseReferences<_$ScoringDatabase, $ScoringEndRowsTable, ScoringEndRow>
    ),
    ScoringEndRow,
    PrefetchHooks Function()>;
typedef $$ScoringArrowRowsTableCreateCompanionBuilder
    = ScoringArrowRowsCompanion Function({
  required String id,
  required String endId,
  required int arrowIndex,
  required int scoreValue,
  Value<bool> isX,
  Value<bool> isMiss,
  Value<int> rowid,
});
typedef $$ScoringArrowRowsTableUpdateCompanionBuilder
    = ScoringArrowRowsCompanion Function({
  Value<String> id,
  Value<String> endId,
  Value<int> arrowIndex,
  Value<int> scoreValue,
  Value<bool> isX,
  Value<bool> isMiss,
  Value<int> rowid,
});

class $$ScoringArrowRowsTableFilterComposer
    extends Composer<_$ScoringDatabase, $ScoringArrowRowsTable> {
  $$ScoringArrowRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endId => $composableBuilder(
      column: $table.endId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get arrowIndex => $composableBuilder(
      column: $table.arrowIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scoreValue => $composableBuilder(
      column: $table.scoreValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isX => $composableBuilder(
      column: $table.isX, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isMiss => $composableBuilder(
      column: $table.isMiss, builder: (column) => ColumnFilters(column));
}

class $$ScoringArrowRowsTableOrderingComposer
    extends Composer<_$ScoringDatabase, $ScoringArrowRowsTable> {
  $$ScoringArrowRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endId => $composableBuilder(
      column: $table.endId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get arrowIndex => $composableBuilder(
      column: $table.arrowIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scoreValue => $composableBuilder(
      column: $table.scoreValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isX => $composableBuilder(
      column: $table.isX, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isMiss => $composableBuilder(
      column: $table.isMiss, builder: (column) => ColumnOrderings(column));
}

class $$ScoringArrowRowsTableAnnotationComposer
    extends Composer<_$ScoringDatabase, $ScoringArrowRowsTable> {
  $$ScoringArrowRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get endId =>
      $composableBuilder(column: $table.endId, builder: (column) => column);

  GeneratedColumn<int> get arrowIndex => $composableBuilder(
      column: $table.arrowIndex, builder: (column) => column);

  GeneratedColumn<int> get scoreValue => $composableBuilder(
      column: $table.scoreValue, builder: (column) => column);

  GeneratedColumn<bool> get isX =>
      $composableBuilder(column: $table.isX, builder: (column) => column);

  GeneratedColumn<bool> get isMiss =>
      $composableBuilder(column: $table.isMiss, builder: (column) => column);
}

class $$ScoringArrowRowsTableTableManager extends RootTableManager<
    _$ScoringDatabase,
    $ScoringArrowRowsTable,
    ScoringArrowRow,
    $$ScoringArrowRowsTableFilterComposer,
    $$ScoringArrowRowsTableOrderingComposer,
    $$ScoringArrowRowsTableAnnotationComposer,
    $$ScoringArrowRowsTableCreateCompanionBuilder,
    $$ScoringArrowRowsTableUpdateCompanionBuilder,
    (
      ScoringArrowRow,
      BaseReferences<_$ScoringDatabase, $ScoringArrowRowsTable, ScoringArrowRow>
    ),
    ScoringArrowRow,
    PrefetchHooks Function()> {
  $$ScoringArrowRowsTableTableManager(
      _$ScoringDatabase db, $ScoringArrowRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScoringArrowRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScoringArrowRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScoringArrowRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> endId = const Value.absent(),
            Value<int> arrowIndex = const Value.absent(),
            Value<int> scoreValue = const Value.absent(),
            Value<bool> isX = const Value.absent(),
            Value<bool> isMiss = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScoringArrowRowsCompanion(
            id: id,
            endId: endId,
            arrowIndex: arrowIndex,
            scoreValue: scoreValue,
            isX: isX,
            isMiss: isMiss,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String endId,
            required int arrowIndex,
            required int scoreValue,
            Value<bool> isX = const Value.absent(),
            Value<bool> isMiss = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ScoringArrowRowsCompanion.insert(
            id: id,
            endId: endId,
            arrowIndex: arrowIndex,
            scoreValue: scoreValue,
            isX: isX,
            isMiss: isMiss,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ScoringArrowRowsTableProcessedTableManager = ProcessedTableManager<
    _$ScoringDatabase,
    $ScoringArrowRowsTable,
    ScoringArrowRow,
    $$ScoringArrowRowsTableFilterComposer,
    $$ScoringArrowRowsTableOrderingComposer,
    $$ScoringArrowRowsTableAnnotationComposer,
    $$ScoringArrowRowsTableCreateCompanionBuilder,
    $$ScoringArrowRowsTableUpdateCompanionBuilder,
    (
      ScoringArrowRow,
      BaseReferences<_$ScoringDatabase, $ScoringArrowRowsTable, ScoringArrowRow>
    ),
    ScoringArrowRow,
    PrefetchHooks Function()>;
typedef $$TargetFaceRowsTableCreateCompanionBuilder = TargetFaceRowsCompanion
    Function({
  required String id,
  Value<String?> organizationId,
  Value<String?> organizationName,
  Value<String?> organizationSlug,
  required String code,
  required String name,
  Value<String?> imagePath,
  required String scoringRulesJson,
  Value<int> usedCount,
  Value<int> rowid,
});
typedef $$TargetFaceRowsTableUpdateCompanionBuilder = TargetFaceRowsCompanion
    Function({
  Value<String> id,
  Value<String?> organizationId,
  Value<String?> organizationName,
  Value<String?> organizationSlug,
  Value<String> code,
  Value<String> name,
  Value<String?> imagePath,
  Value<String> scoringRulesJson,
  Value<int> usedCount,
  Value<int> rowid,
});

class $$TargetFaceRowsTableFilterComposer
    extends Composer<_$ScoringDatabase, $TargetFaceRowsTable> {
  $$TargetFaceRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organizationName => $composableBuilder(
      column: $table.organizationName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get organizationSlug => $composableBuilder(
      column: $table.organizationSlug,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scoringRulesJson => $composableBuilder(
      column: $table.scoringRulesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usedCount => $composableBuilder(
      column: $table.usedCount, builder: (column) => ColumnFilters(column));
}

class $$TargetFaceRowsTableOrderingComposer
    extends Composer<_$ScoringDatabase, $TargetFaceRowsTable> {
  $$TargetFaceRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organizationId => $composableBuilder(
      column: $table.organizationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organizationName => $composableBuilder(
      column: $table.organizationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get organizationSlug => $composableBuilder(
      column: $table.organizationSlug,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scoringRulesJson => $composableBuilder(
      column: $table.scoringRulesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usedCount => $composableBuilder(
      column: $table.usedCount, builder: (column) => ColumnOrderings(column));
}

class $$TargetFaceRowsTableAnnotationComposer
    extends Composer<_$ScoringDatabase, $TargetFaceRowsTable> {
  $$TargetFaceRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
      column: $table.organizationId, builder: (column) => column);

  GeneratedColumn<String> get organizationName => $composableBuilder(
      column: $table.organizationName, builder: (column) => column);

  GeneratedColumn<String> get organizationSlug => $composableBuilder(
      column: $table.organizationSlug, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get scoringRulesJson => $composableBuilder(
      column: $table.scoringRulesJson, builder: (column) => column);

  GeneratedColumn<int> get usedCount =>
      $composableBuilder(column: $table.usedCount, builder: (column) => column);
}

class $$TargetFaceRowsTableTableManager extends RootTableManager<
    _$ScoringDatabase,
    $TargetFaceRowsTable,
    TargetFaceRow,
    $$TargetFaceRowsTableFilterComposer,
    $$TargetFaceRowsTableOrderingComposer,
    $$TargetFaceRowsTableAnnotationComposer,
    $$TargetFaceRowsTableCreateCompanionBuilder,
    $$TargetFaceRowsTableUpdateCompanionBuilder,
    (
      TargetFaceRow,
      BaseReferences<_$ScoringDatabase, $TargetFaceRowsTable, TargetFaceRow>
    ),
    TargetFaceRow,
    PrefetchHooks Function()> {
  $$TargetFaceRowsTableTableManager(
      _$ScoringDatabase db, $TargetFaceRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetFaceRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetFaceRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetFaceRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> organizationId = const Value.absent(),
            Value<String?> organizationName = const Value.absent(),
            Value<String?> organizationSlug = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<String> scoringRulesJson = const Value.absent(),
            Value<int> usedCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TargetFaceRowsCompanion(
            id: id,
            organizationId: organizationId,
            organizationName: organizationName,
            organizationSlug: organizationSlug,
            code: code,
            name: name,
            imagePath: imagePath,
            scoringRulesJson: scoringRulesJson,
            usedCount: usedCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> organizationId = const Value.absent(),
            Value<String?> organizationName = const Value.absent(),
            Value<String?> organizationSlug = const Value.absent(),
            required String code,
            required String name,
            Value<String?> imagePath = const Value.absent(),
            required String scoringRulesJson,
            Value<int> usedCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TargetFaceRowsCompanion.insert(
            id: id,
            organizationId: organizationId,
            organizationName: organizationName,
            organizationSlug: organizationSlug,
            code: code,
            name: name,
            imagePath: imagePath,
            scoringRulesJson: scoringRulesJson,
            usedCount: usedCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TargetFaceRowsTableProcessedTableManager = ProcessedTableManager<
    _$ScoringDatabase,
    $TargetFaceRowsTable,
    TargetFaceRow,
    $$TargetFaceRowsTableFilterComposer,
    $$TargetFaceRowsTableOrderingComposer,
    $$TargetFaceRowsTableAnnotationComposer,
    $$TargetFaceRowsTableCreateCompanionBuilder,
    $$TargetFaceRowsTableUpdateCompanionBuilder,
    (
      TargetFaceRow,
      BaseReferences<_$ScoringDatabase, $TargetFaceRowsTable, TargetFaceRow>
    ),
    TargetFaceRow,
    PrefetchHooks Function()>;
typedef $$GroupSessionRowsTableCreateCompanionBuilder
    = GroupSessionRowsCompanion Function({
  required String id,
  required String joinCode,
  Value<String?> title,
  required int hostUserId,
  Value<String?> hostName,
  required String distanceCategory,
  required int distanceM,
  Value<String> environment,
  Value<int?> targetFaceCm,
  Value<String?> targetFaceId,
  required int numEnds,
  required int arrowsPerEnd,
  Value<String> status,
  Value<int> participantCount,
  required DateTime startedAt,
  Value<DateTime?> completedAt,
  required DateTime cachedAt,
  Value<int> rowid,
});
typedef $$GroupSessionRowsTableUpdateCompanionBuilder
    = GroupSessionRowsCompanion Function({
  Value<String> id,
  Value<String> joinCode,
  Value<String?> title,
  Value<int> hostUserId,
  Value<String?> hostName,
  Value<String> distanceCategory,
  Value<int> distanceM,
  Value<String> environment,
  Value<int?> targetFaceCm,
  Value<String?> targetFaceId,
  Value<int> numEnds,
  Value<int> arrowsPerEnd,
  Value<String> status,
  Value<int> participantCount,
  Value<DateTime> startedAt,
  Value<DateTime?> completedAt,
  Value<DateTime> cachedAt,
  Value<int> rowid,
});

class $$GroupSessionRowsTableFilterComposer
    extends Composer<_$ScoringDatabase, $GroupSessionRowsTable> {
  $$GroupSessionRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get joinCode => $composableBuilder(
      column: $table.joinCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get hostUserId => $composableBuilder(
      column: $table.hostUserId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get hostName => $composableBuilder(
      column: $table.hostName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get distanceM => $composableBuilder(
      column: $table.distanceM, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get environment => $composableBuilder(
      column: $table.environment, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetFaceId => $composableBuilder(
      column: $table.targetFaceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numEnds => $composableBuilder(
      column: $table.numEnds, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get arrowsPerEnd => $composableBuilder(
      column: $table.arrowsPerEnd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get participantCount => $composableBuilder(
      column: $table.participantCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$GroupSessionRowsTableOrderingComposer
    extends Composer<_$ScoringDatabase, $GroupSessionRowsTable> {
  $$GroupSessionRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get joinCode => $composableBuilder(
      column: $table.joinCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get hostUserId => $composableBuilder(
      column: $table.hostUserId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get hostName => $composableBuilder(
      column: $table.hostName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get distanceM => $composableBuilder(
      column: $table.distanceM, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get environment => $composableBuilder(
      column: $table.environment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetFaceId => $composableBuilder(
      column: $table.targetFaceId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numEnds => $composableBuilder(
      column: $table.numEnds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get arrowsPerEnd => $composableBuilder(
      column: $table.arrowsPerEnd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get participantCount => $composableBuilder(
      column: $table.participantCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
      column: $table.startedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$GroupSessionRowsTableAnnotationComposer
    extends Composer<_$ScoringDatabase, $GroupSessionRowsTable> {
  $$GroupSessionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get joinCode =>
      $composableBuilder(column: $table.joinCode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get hostUserId => $composableBuilder(
      column: $table.hostUserId, builder: (column) => column);

  GeneratedColumn<String> get hostName =>
      $composableBuilder(column: $table.hostName, builder: (column) => column);

  GeneratedColumn<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory, builder: (column) => column);

  GeneratedColumn<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<String> get environment => $composableBuilder(
      column: $table.environment, builder: (column) => column);

  GeneratedColumn<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm, builder: (column) => column);

  GeneratedColumn<String> get targetFaceId => $composableBuilder(
      column: $table.targetFaceId, builder: (column) => column);

  GeneratedColumn<int> get numEnds =>
      $composableBuilder(column: $table.numEnds, builder: (column) => column);

  GeneratedColumn<int> get arrowsPerEnd => $composableBuilder(
      column: $table.arrowsPerEnd, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get participantCount => $composableBuilder(
      column: $table.participantCount, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$GroupSessionRowsTableTableManager extends RootTableManager<
    _$ScoringDatabase,
    $GroupSessionRowsTable,
    GroupSessionRow,
    $$GroupSessionRowsTableFilterComposer,
    $$GroupSessionRowsTableOrderingComposer,
    $$GroupSessionRowsTableAnnotationComposer,
    $$GroupSessionRowsTableCreateCompanionBuilder,
    $$GroupSessionRowsTableUpdateCompanionBuilder,
    (
      GroupSessionRow,
      BaseReferences<_$ScoringDatabase, $GroupSessionRowsTable, GroupSessionRow>
    ),
    GroupSessionRow,
    PrefetchHooks Function()> {
  $$GroupSessionRowsTableTableManager(
      _$ScoringDatabase db, $GroupSessionRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupSessionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupSessionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupSessionRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> joinCode = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<int> hostUserId = const Value.absent(),
            Value<String?> hostName = const Value.absent(),
            Value<String> distanceCategory = const Value.absent(),
            Value<int> distanceM = const Value.absent(),
            Value<String> environment = const Value.absent(),
            Value<int?> targetFaceCm = const Value.absent(),
            Value<String?> targetFaceId = const Value.absent(),
            Value<int> numEnds = const Value.absent(),
            Value<int> arrowsPerEnd = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> participantCount = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupSessionRowsCompanion(
            id: id,
            joinCode: joinCode,
            title: title,
            hostUserId: hostUserId,
            hostName: hostName,
            distanceCategory: distanceCategory,
            distanceM: distanceM,
            environment: environment,
            targetFaceCm: targetFaceCm,
            targetFaceId: targetFaceId,
            numEnds: numEnds,
            arrowsPerEnd: arrowsPerEnd,
            status: status,
            participantCount: participantCount,
            startedAt: startedAt,
            completedAt: completedAt,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String joinCode,
            Value<String?> title = const Value.absent(),
            required int hostUserId,
            Value<String?> hostName = const Value.absent(),
            required String distanceCategory,
            required int distanceM,
            Value<String> environment = const Value.absent(),
            Value<int?> targetFaceCm = const Value.absent(),
            Value<String?> targetFaceId = const Value.absent(),
            required int numEnds,
            required int arrowsPerEnd,
            Value<String> status = const Value.absent(),
            Value<int> participantCount = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> completedAt = const Value.absent(),
            required DateTime cachedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupSessionRowsCompanion.insert(
            id: id,
            joinCode: joinCode,
            title: title,
            hostUserId: hostUserId,
            hostName: hostName,
            distanceCategory: distanceCategory,
            distanceM: distanceM,
            environment: environment,
            targetFaceCm: targetFaceCm,
            targetFaceId: targetFaceId,
            numEnds: numEnds,
            arrowsPerEnd: arrowsPerEnd,
            status: status,
            participantCount: participantCount,
            startedAt: startedAt,
            completedAt: completedAt,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GroupSessionRowsTableProcessedTableManager = ProcessedTableManager<
    _$ScoringDatabase,
    $GroupSessionRowsTable,
    GroupSessionRow,
    $$GroupSessionRowsTableFilterComposer,
    $$GroupSessionRowsTableOrderingComposer,
    $$GroupSessionRowsTableAnnotationComposer,
    $$GroupSessionRowsTableCreateCompanionBuilder,
    $$GroupSessionRowsTableUpdateCompanionBuilder,
    (
      GroupSessionRow,
      BaseReferences<_$ScoringDatabase, $GroupSessionRowsTable, GroupSessionRow>
    ),
    GroupSessionRow,
    PrefetchHooks Function()>;
typedef $$GroupParticipantCacheRowsTableCreateCompanionBuilder
    = GroupParticipantCacheRowsCompanion Function({
  required String id,
  required String groupId,
  Value<int?> userId,
  Value<String?> displayName,
  Value<String?> guestName,
  Value<bool> isGuest,
  Value<String?> bowClass,
  Value<String?> distanceCategory,
  Value<int?> distanceM,
  Value<int?> targetFaceCm,
  Value<int?> targetButt,
  Value<String?> targetLetter,
  Value<int?> lastScoredByUserId,
  Value<int> totalScore,
  Value<int?> maxPossibleScore,
  Value<int> arrowsShot,
  Value<int> xCount,
  Value<int> tenCount,
  Value<String?> status,
  required DateTime cachedAt,
  Value<int> rowid,
});
typedef $$GroupParticipantCacheRowsTableUpdateCompanionBuilder
    = GroupParticipantCacheRowsCompanion Function({
  Value<String> id,
  Value<String> groupId,
  Value<int?> userId,
  Value<String?> displayName,
  Value<String?> guestName,
  Value<bool> isGuest,
  Value<String?> bowClass,
  Value<String?> distanceCategory,
  Value<int?> distanceM,
  Value<int?> targetFaceCm,
  Value<int?> targetButt,
  Value<String?> targetLetter,
  Value<int?> lastScoredByUserId,
  Value<int> totalScore,
  Value<int?> maxPossibleScore,
  Value<int> arrowsShot,
  Value<int> xCount,
  Value<int> tenCount,
  Value<String?> status,
  Value<DateTime> cachedAt,
  Value<int> rowid,
});

class $$GroupParticipantCacheRowsTableFilterComposer
    extends Composer<_$ScoringDatabase, $GroupParticipantCacheRowsTable> {
  $$GroupParticipantCacheRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get guestName => $composableBuilder(
      column: $table.guestName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isGuest => $composableBuilder(
      column: $table.isGuest, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bowClass => $composableBuilder(
      column: $table.bowClass, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get distanceM => $composableBuilder(
      column: $table.distanceM, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetButt => $composableBuilder(
      column: $table.targetButt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetLetter => $composableBuilder(
      column: $table.targetLetter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastScoredByUserId => $composableBuilder(
      column: $table.lastScoredByUserId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalScore => $composableBuilder(
      column: $table.totalScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxPossibleScore => $composableBuilder(
      column: $table.maxPossibleScore,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get arrowsShot => $composableBuilder(
      column: $table.arrowsShot, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get xCount => $composableBuilder(
      column: $table.xCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tenCount => $composableBuilder(
      column: $table.tenCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$GroupParticipantCacheRowsTableOrderingComposer
    extends Composer<_$ScoringDatabase, $GroupParticipantCacheRowsTable> {
  $$GroupParticipantCacheRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get guestName => $composableBuilder(
      column: $table.guestName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isGuest => $composableBuilder(
      column: $table.isGuest, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bowClass => $composableBuilder(
      column: $table.bowClass, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get distanceM => $composableBuilder(
      column: $table.distanceM, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetButt => $composableBuilder(
      column: $table.targetButt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetLetter => $composableBuilder(
      column: $table.targetLetter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastScoredByUserId => $composableBuilder(
      column: $table.lastScoredByUserId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalScore => $composableBuilder(
      column: $table.totalScore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxPossibleScore => $composableBuilder(
      column: $table.maxPossibleScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get arrowsShot => $composableBuilder(
      column: $table.arrowsShot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get xCount => $composableBuilder(
      column: $table.xCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tenCount => $composableBuilder(
      column: $table.tenCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$GroupParticipantCacheRowsTableAnnotationComposer
    extends Composer<_$ScoringDatabase, $GroupParticipantCacheRowsTable> {
  $$GroupParticipantCacheRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get guestName =>
      $composableBuilder(column: $table.guestName, builder: (column) => column);

  GeneratedColumn<bool> get isGuest =>
      $composableBuilder(column: $table.isGuest, builder: (column) => column);

  GeneratedColumn<String> get bowClass =>
      $composableBuilder(column: $table.bowClass, builder: (column) => column);

  GeneratedColumn<String> get distanceCategory => $composableBuilder(
      column: $table.distanceCategory, builder: (column) => column);

  GeneratedColumn<int> get distanceM =>
      $composableBuilder(column: $table.distanceM, builder: (column) => column);

  GeneratedColumn<int> get targetFaceCm => $composableBuilder(
      column: $table.targetFaceCm, builder: (column) => column);

  GeneratedColumn<int> get targetButt => $composableBuilder(
      column: $table.targetButt, builder: (column) => column);

  GeneratedColumn<String> get targetLetter => $composableBuilder(
      column: $table.targetLetter, builder: (column) => column);

  GeneratedColumn<int> get lastScoredByUserId => $composableBuilder(
      column: $table.lastScoredByUserId, builder: (column) => column);

  GeneratedColumn<int> get totalScore => $composableBuilder(
      column: $table.totalScore, builder: (column) => column);

  GeneratedColumn<int> get maxPossibleScore => $composableBuilder(
      column: $table.maxPossibleScore, builder: (column) => column);

  GeneratedColumn<int> get arrowsShot => $composableBuilder(
      column: $table.arrowsShot, builder: (column) => column);

  GeneratedColumn<int> get xCount =>
      $composableBuilder(column: $table.xCount, builder: (column) => column);

  GeneratedColumn<int> get tenCount =>
      $composableBuilder(column: $table.tenCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$GroupParticipantCacheRowsTableTableManager extends RootTableManager<
    _$ScoringDatabase,
    $GroupParticipantCacheRowsTable,
    GroupParticipantCacheRow,
    $$GroupParticipantCacheRowsTableFilterComposer,
    $$GroupParticipantCacheRowsTableOrderingComposer,
    $$GroupParticipantCacheRowsTableAnnotationComposer,
    $$GroupParticipantCacheRowsTableCreateCompanionBuilder,
    $$GroupParticipantCacheRowsTableUpdateCompanionBuilder,
    (
      GroupParticipantCacheRow,
      BaseReferences<_$ScoringDatabase, $GroupParticipantCacheRowsTable,
          GroupParticipantCacheRow>
    ),
    GroupParticipantCacheRow,
    PrefetchHooks Function()> {
  $$GroupParticipantCacheRowsTableTableManager(
      _$ScoringDatabase db, $GroupParticipantCacheRowsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupParticipantCacheRowsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupParticipantCacheRowsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupParticipantCacheRowsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> groupId = const Value.absent(),
            Value<int?> userId = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> guestName = const Value.absent(),
            Value<bool> isGuest = const Value.absent(),
            Value<String?> bowClass = const Value.absent(),
            Value<String?> distanceCategory = const Value.absent(),
            Value<int?> distanceM = const Value.absent(),
            Value<int?> targetFaceCm = const Value.absent(),
            Value<int?> targetButt = const Value.absent(),
            Value<String?> targetLetter = const Value.absent(),
            Value<int?> lastScoredByUserId = const Value.absent(),
            Value<int> totalScore = const Value.absent(),
            Value<int?> maxPossibleScore = const Value.absent(),
            Value<int> arrowsShot = const Value.absent(),
            Value<int> xCount = const Value.absent(),
            Value<int> tenCount = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupParticipantCacheRowsCompanion(
            id: id,
            groupId: groupId,
            userId: userId,
            displayName: displayName,
            guestName: guestName,
            isGuest: isGuest,
            bowClass: bowClass,
            distanceCategory: distanceCategory,
            distanceM: distanceM,
            targetFaceCm: targetFaceCm,
            targetButt: targetButt,
            targetLetter: targetLetter,
            lastScoredByUserId: lastScoredByUserId,
            totalScore: totalScore,
            maxPossibleScore: maxPossibleScore,
            arrowsShot: arrowsShot,
            xCount: xCount,
            tenCount: tenCount,
            status: status,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String groupId,
            Value<int?> userId = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> guestName = const Value.absent(),
            Value<bool> isGuest = const Value.absent(),
            Value<String?> bowClass = const Value.absent(),
            Value<String?> distanceCategory = const Value.absent(),
            Value<int?> distanceM = const Value.absent(),
            Value<int?> targetFaceCm = const Value.absent(),
            Value<int?> targetButt = const Value.absent(),
            Value<String?> targetLetter = const Value.absent(),
            Value<int?> lastScoredByUserId = const Value.absent(),
            Value<int> totalScore = const Value.absent(),
            Value<int?> maxPossibleScore = const Value.absent(),
            Value<int> arrowsShot = const Value.absent(),
            Value<int> xCount = const Value.absent(),
            Value<int> tenCount = const Value.absent(),
            Value<String?> status = const Value.absent(),
            required DateTime cachedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GroupParticipantCacheRowsCompanion.insert(
            id: id,
            groupId: groupId,
            userId: userId,
            displayName: displayName,
            guestName: guestName,
            isGuest: isGuest,
            bowClass: bowClass,
            distanceCategory: distanceCategory,
            distanceM: distanceM,
            targetFaceCm: targetFaceCm,
            targetButt: targetButt,
            targetLetter: targetLetter,
            lastScoredByUserId: lastScoredByUserId,
            totalScore: totalScore,
            maxPossibleScore: maxPossibleScore,
            arrowsShot: arrowsShot,
            xCount: xCount,
            tenCount: tenCount,
            status: status,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GroupParticipantCacheRowsTableProcessedTableManager
    = ProcessedTableManager<
        _$ScoringDatabase,
        $GroupParticipantCacheRowsTable,
        GroupParticipantCacheRow,
        $$GroupParticipantCacheRowsTableFilterComposer,
        $$GroupParticipantCacheRowsTableOrderingComposer,
        $$GroupParticipantCacheRowsTableAnnotationComposer,
        $$GroupParticipantCacheRowsTableCreateCompanionBuilder,
        $$GroupParticipantCacheRowsTableUpdateCompanionBuilder,
        (
          GroupParticipantCacheRow,
          BaseReferences<_$ScoringDatabase, $GroupParticipantCacheRowsTable,
              GroupParticipantCacheRow>
        ),
        GroupParticipantCacheRow,
        PrefetchHooks Function()>;

class $ScoringDatabaseManager {
  final _$ScoringDatabase _db;
  $ScoringDatabaseManager(this._db);
  $$ScoringSessionRowsTableTableManager get scoringSessionRows =>
      $$ScoringSessionRowsTableTableManager(_db, _db.scoringSessionRows);
  $$ScoringEndRowsTableTableManager get scoringEndRows =>
      $$ScoringEndRowsTableTableManager(_db, _db.scoringEndRows);
  $$ScoringArrowRowsTableTableManager get scoringArrowRows =>
      $$ScoringArrowRowsTableTableManager(_db, _db.scoringArrowRows);
  $$TargetFaceRowsTableTableManager get targetFaceRows =>
      $$TargetFaceRowsTableTableManager(_db, _db.targetFaceRows);
  $$GroupSessionRowsTableTableManager get groupSessionRows =>
      $$GroupSessionRowsTableTableManager(_db, _db.groupSessionRows);
  $$GroupParticipantCacheRowsTableTableManager get groupParticipantCacheRows =>
      $$GroupParticipantCacheRowsTableTableManager(
          _db, _db.groupParticipantCacheRows);
}
