import 'package:drift/drift.dart';

import '../../../scoring/data/local/scoring_database.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../../domain/group_entities.dart';

/// Read-only local cache of group (Latihan Bersama) metadata & roster, backed
/// by the shared [ScoringDatabase] (Sprint 04 decision, task 4.2/4.5). The
/// server stays authoritative; this only lets the list & detail render offline.
class GroupScoringLocalDataSource {
  const GroupScoringLocalDataSource(this._db);

  final ScoringDatabase _db;

  /// Cache many groups (metadata only — no roster). Used after a list fetch.
  Future<void> upsertGroups(List<ScoringGroupEntity> groups) async {
    await _db.transaction(() async {
      for (final group in groups) {
        await _db
            .into(_db.groupSessionRows)
            .insertOnConflictUpdate(_groupCompanion(group));
      }
    });
  }

  /// Cache one group + replace its roster cache. Used after a detail fetch.
  Future<void> upsertGroupWithRoster(ScoringGroupEntity group) async {
    await _db.transaction(() async {
      await _db
          .into(_db.groupSessionRows)
          .insertOnConflictUpdate(_groupCompanion(group));
      await (_db.delete(_db.groupParticipantCacheRows)
            ..where((t) => t.groupId.equals(group.id)))
          .go();
      for (final p in group.participants) {
        await _db
            .into(_db.groupParticipantCacheRows)
            .insert(_participantCompanion(group.id, p));
      }
    });
  }

  /// All cached groups, most recent first (metadata only).
  Future<List<ScoringGroupEntity>> getGroups() async {
    final rows = await (_db.select(_db.groupSessionRows)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
    return rows.map(_toEntity).toList();
  }

  /// One cached group with its roster, or null when not cached.
  Future<ScoringGroupEntity?> getGroup(String groupId) async {
    final row = await (_db.select(_db.groupSessionRows)
          ..where((t) => t.id.equals(groupId)))
        .getSingleOrNull();
    if (row == null) return null;

    final participantRows = await (_db.select(_db.groupParticipantCacheRows)
          ..where((t) => t.groupId.equals(groupId))
          ..orderBy([(t) => OrderingTerm.desc(t.totalScore)]))
        .get();

    return _toEntity(row,
        participants: participantRows.map(_toParticipant).toList());
  }

  GroupSessionRowsCompanion _groupCompanion(ScoringGroupEntity group) {
    return GroupSessionRowsCompanion.insert(
      id: group.id,
      joinCode: group.joinCode,
      title: Value(group.title),
      hostUserId: group.hostUserId,
      hostName: Value(group.hostName),
      distanceCategory: group.distanceCategory.value,
      distanceM: group.distanceM,
      environment: Value(group.environment.value),
      targetFaceCm: Value(group.targetFaceCm),
      targetFaceId: Value(group.targetFaceId),
      numEnds: group.numEnds,
      arrowsPerEnd: group.arrowsPerEnd,
      status: Value(group.status.value),
      participantCount: Value(group.participantCount),
      startedAt: group.startedAt,
      completedAt: Value(group.completedAt),
      cachedAt: DateTime.now(),
    );
  }

  GroupParticipantCacheRowsCompanion _participantCompanion(
    String groupId,
    GroupParticipantEntity p,
  ) {
    return GroupParticipantCacheRowsCompanion.insert(
      id: p.id,
      groupId: groupId,
      userId: Value(p.userId),
      displayName: Value(p.displayName),
      guestName: Value(p.guestName),
      isGuest: Value(p.isGuest),
      bowClass: Value(p.bowClass?.value),
      distanceM: Value(p.distanceM),
      totalScore: Value(p.totalScore),
      maxPossibleScore: Value(p.maxPossibleScore),
      arrowsShot: Value(p.arrowsShot),
      xCount: Value(p.xCount),
      tenCount: Value(p.tenCount),
      status: Value(p.status?.value),
      cachedAt: DateTime.now(),
    );
  }

  ScoringGroupEntity _toEntity(
    GroupSessionRow row, {
    List<GroupParticipantEntity> participants = const [],
  }) {
    return ScoringGroupEntity(
      id: row.id,
      joinCode: row.joinCode,
      title: row.title,
      hostUserId: row.hostUserId,
      hostName: row.hostName,
      distanceCategory: DistanceCategory.fromValue(row.distanceCategory),
      distanceM: row.distanceM,
      environment: ArcheryEnvironment.fromValue(row.environment),
      targetFaceCm: row.targetFaceCm,
      targetFaceId: row.targetFaceId,
      numEnds: row.numEnds,
      arrowsPerEnd: row.arrowsPerEnd,
      status: ScoringSessionStatus.fromValue(row.status),
      participantCount: row.participantCount,
      startedAt: row.startedAt,
      completedAt: row.completedAt,
      participants: participants,
    );
  }

  GroupParticipantEntity _toParticipant(GroupParticipantCacheRow row) {
    return GroupParticipantEntity(
      id: row.id,
      userId: row.userId,
      displayName: row.displayName,
      guestName: row.guestName,
      isGuest: row.isGuest,
      bowClass: row.bowClass != null ? BowClass.fromValue(row.bowClass) : null,
      distanceM: row.distanceM,
      totalScore: row.totalScore,
      maxPossibleScore: row.maxPossibleScore,
      arrowsShot: row.arrowsShot,
      xCount: row.xCount,
      tenCount: row.tenCount,
      status: row.status != null
          ? ScoringSessionStatus.fromValue(row.status)
          : null,
    );
  }
}
