import 'package:drift/drift.dart';

import '../../../scoring/data/local/scoring_database.dart';
import '../../../scoring/domain/scoring_entities.dart';
import '../../../scoring/domain/scoring_enums.dart';
import '../../../scoring/utils/ulid.dart';
import '../../domain/board_participant_entity.dart';
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
      distanceCategory: Value(p.distanceCategory?.value),
      distanceM: Value(p.distanceM),
      targetFaceCm: Value(p.targetFaceCm),
      targetButt: Value(p.targetButt),
      targetLetter: Value(p.targetLetter),
      lastScoredByUserId: Value(p.lastScoredByUserId),
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
      distanceCategory: row.distanceCategory != null
          ? DistanceCategory.fromValue(row.distanceCategory)
          : null,
      distanceM: row.distanceM,
      targetFaceCm: row.targetFaceCm,
      targetButt: row.targetButt,
      targetLetter: row.targetLetter,
      lastScoredByUserId: row.lastScoredByUserId,
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

  // ─── Host board participant scores (Sprint 05) ──────────────────────────
  //
  // Participant scores live in the *same* [ScoringSessionRows] table as solo
  // sessions (Sprint 04 reuse decision), tagged with `scoringSessionGroupId`
  // and, for guests, `guestName`. They are offline-first: every saved end marks
  // the row unsynced + a `syncAction` so the group sync endpoint can reconcile
  // it later. Display identity is merged from the roster cache so the board can
  // label rows offline; a freshly-added guest carries its own cached label too.

  /// All participants of [groupId] that exist locally, hydrated with their
  /// ends/arrows for the host board. Display name / owner are merged from the
  /// roster cache; a guest falls back to its own `guest_name`.
  Future<List<BoardParticipant>> getBoardParticipants(String groupId) async {
    final scoreRows = await (_db.select(_db.scoringSessionRows)
          ..where((t) => t.scoringSessionGroupId.equals(groupId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();

    final cacheRows = await (_db.select(_db.groupParticipantCacheRows)
          ..where((t) => t.groupId.equals(groupId)))
        .get();
    final cacheById = {for (final c in cacheRows) c.id: c};

    final result = <BoardParticipant>[];
    for (final row in scoreRows) {
      final cache = cacheById[row.id];
      result.add(
        BoardParticipant(
          id: row.id,
          clientUuid: row.clientUuid,
          userId: cache?.userId,
          guestName: row.guestName ?? cache?.guestName,
          displayName: cache?.displayName,
          bowClass:
              row.bowClass != null ? BowClass.fromValue(row.bowClass) : null,
          distanceM: row.distanceM,
          targetFaceCm: row.targetFaceCm,
          targetButt: cache?.targetButt,
          targetLetter: cache?.targetLetter,
          status: ScoringSessionStatus.fromValue(row.status),
          isSynced: row.isSynced,
          syncAction: row.syncAction,
          completedAt: row.completedAt,
          ends: await _loadEnds(row.id),
        ),
      );
    }
    return result;
  }

  /// Ensure a local score row exists for every roster participant of [group]
  /// (so the host can score them offline). Existing local rows are left intact
  /// to preserve unsynced progress.
  Future<void> seedParticipantsFromRoster(ScoringGroupEntity group) async {
    if (group.participants.isEmpty) return;
    await _db.transaction(() async {
      for (final p in group.participants) {
        final existing = await (_db.select(_db.scoringSessionRows)
              ..where((t) => t.id.equals(p.id)))
            .getSingleOrNull();
        if (existing != null) continue;
        await _db.into(_db.scoringSessionRows).insert(
              _participantScoreCompanion(
                group: group,
                id: p.id,
                // The server row has no client_uuid exposed; mint one. Sync
                // still resolves the row by its id, so no duplicate is created.
                clientUuid: Ids.uuid(),
                guestName: p.guestName,
                bowClass: p.bowClass,
                distanceM: p.distanceM,
                targetFaceCm: p.targetFaceCm,
                status: p.status ?? ScoringSessionStatus.inProgress,
                isSynced: true,
                syncAction: null,
              ),
            );
      }
    });
  }

  /// Create a guest participant entirely offline (minimal add — Sprint 05).
  /// The row is minted on the server on first sync via its `name`. A roster
  /// cache row is written too so the board can label it before any sync.
  Future<BoardParticipant> createLocalGuest(
    ScoringGroupEntity group,
    String name,
  ) async {
    final created = await createLocalGuests(group, [name]);
    return created.single;
  }

  /// Create several guest participants at once (quick-add batch — Sprint 06).
  /// All rows are written in one transaction so eleven names land together,
  /// then minted on the server in a single sync (the group sync endpoint
  /// resolves-or-creates each by `client_uuid`). Blank names are skipped.
  Future<List<BoardParticipant>> createLocalGuests(
    ScoringGroupEntity group,
    List<String> names,
  ) async {
    final cleaned = [
      for (final raw in names)
        if (raw.trim().isNotEmpty) raw.trim(),
    ];
    if (cleaned.isEmpty) return const [];

    final created = <BoardParticipant>[];
    await _db.transaction(() async {
      for (final name in cleaned) {
        final id = Ids.ulid();
        final clientUuid = Ids.uuid();
        await _db.into(_db.scoringSessionRows).insert(
              _participantScoreCompanion(
                group: group,
                id: id,
                clientUuid: clientUuid,
                guestName: name,
                bowClass: null,
                status: ScoringSessionStatus.inProgress,
                isSynced: false,
                syncAction: 'create',
              ),
            );
        await _db.into(_db.groupParticipantCacheRows).insertOnConflictUpdate(
              GroupParticipantCacheRowsCompanion.insert(
                id: id,
                groupId: group.id,
                guestName: Value(name),
                isGuest: const Value(true),
                displayName: Value(name),
                cachedAt: DateTime.now(),
              ),
            );
        created.add(
          BoardParticipant(
            id: id,
            clientUuid: clientUuid,
            guestName: name,
            displayName: name,
            status: ScoringSessionStatus.inProgress,
            isSynced: false,
            syncAction: 'create',
          ),
        );
      }
    });
    return created;
  }

  /// Save one end's arrows for a participant, recompute cached aggregates, and
  /// mark the row unsynced. When every planned arrow is in, the row is flipped
  /// to `completed` so the backend can award PB/gamification for owned rows
  /// (guests stay walled off, §3.2). Idempotent: re-saving an end replaces it.
  Future<void> saveParticipantEnd({
    required ScoringGroupEntity group,
    required BoardParticipant participant,
    required int endNumber,
    required List<ArrowScore> arrows,
  }) async {
    await _db.transaction(() async {
      final ends = [...participant.ends];
      final idx = ends.indexWhere((e) => e.endNumber == endNumber);
      final endId = idx >= 0 ? ends[idx].id : Ids.ulid();
      final newEnd =
          ScoringEndEntity(id: endId, endNumber: endNumber, arrows: arrows);
      if (idx >= 0) {
        ends[idx] = newEnd;
      } else {
        ends.add(newEnd);
      }
      ends.sort((a, b) => a.endNumber.compareTo(b.endNumber));

      final allArrows = ends.expand((e) => e.arrows);
      final total = allArrows.fold(0, (s, a) => s + a.scoreValue);
      final shot = allArrows.length;
      final x = allArrows.where((a) => a.isX).length;
      final ten = allArrows.where((a) => a.isTen).length;
      final miss = allArrows.where((a) => a.isMiss).length;

      final plannedArrows = group.numEnds * group.arrowsPerEnd;
      final completed = shot >= plannedArrows;
      final status = completed
          ? ScoringSessionStatus.completed
          : ScoringSessionStatus.inProgress;
      final completedAt =
          completed ? (participant.completedAt ?? DateTime.now()) : null;

      // Keep 'create' until first sync, then 'update' (mirror solo engine).
      final nextAction =
          (!participant.isSynced && participant.syncAction == 'create')
              ? 'create'
              : 'update';

      await (_db.update(_db.scoringSessionRows)
            ..where((t) => t.id.equals(participant.id)))
          .write(
        ScoringSessionRowsCompanion(
          totalScore: Value(total),
          arrowsShot: Value(shot),
          xCount: Value(x),
          tenCount: Value(ten),
          missCount: Value(miss),
          status: Value(status.value),
          completedAt: Value(completedAt),
          isSynced: const Value(false),
          syncAction: Value(nextAction),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _replaceParticipantEnds(participant.id, ends);
    });
  }

  /// Participants of [groupId] with pending sync work (for the group sync push).
  Future<List<BoardParticipant>> getUnsyncedParticipants(String groupId) async {
    final all = await getBoardParticipants(groupId);
    return all.where((p) => !p.isSynced).toList();
  }

  /// Remove a participant's local row entirely — its score row + ends/arrows and
  /// its roster cache entry (Sprint 10, task 10.5: leaving a session). Used after
  /// the server delete succeeds so the row no longer lingers on the board.
  Future<void> removeLocalParticipant(String groupId, String sessionId) async {
    await _db.transaction(() async {
      final ends = await (_db.select(_db.scoringEndRows)
            ..where((t) => t.sessionId.equals(sessionId)))
          .get();
      for (final end in ends) {
        await (_db.delete(_db.scoringArrowRows)
              ..where((t) => t.endId.equals(end.id)))
            .go();
      }
      await (_db.delete(_db.scoringEndRows)
            ..where((t) => t.sessionId.equals(sessionId)))
          .go();
      await (_db.delete(_db.scoringSessionRows)
            ..where((t) => t.id.equals(sessionId)))
          .go();
      await (_db.delete(_db.groupParticipantCacheRows)
            ..where((t) => t.id.equals(sessionId) & t.groupId.equals(groupId)))
          .go();
    });
  }

  /// Mark a participant row reconciled with the server after a successful sync.
  Future<void> markParticipantSynced(String id) async {
    await (_db.update(_db.scoringSessionRows)..where((t) => t.id.equals(id)))
        .write(
      const ScoringSessionRowsCompanion(
        isSynced: Value(true),
        syncAction: Value(null),
      ),
    );
  }

  Future<List<ScoringEndEntity>> _loadEnds(String sessionId) async {
    final endRows = await (_db.select(_db.scoringEndRows)
          ..where((t) => t.sessionId.equals(sessionId))
          ..orderBy([(t) => OrderingTerm.asc(t.endNumber)]))
        .get();

    final ends = <ScoringEndEntity>[];
    for (final endRow in endRows) {
      final arrowRows = await (_db.select(_db.scoringArrowRows)
            ..where((t) => t.endId.equals(endRow.id))
            ..orderBy([(t) => OrderingTerm.asc(t.arrowIndex)]))
          .get();
      ends.add(
        ScoringEndEntity(
          id: endRow.id,
          endNumber: endRow.endNumber,
          arrows: arrowRows
              .map((a) => ArrowScore(
                    id: a.id,
                    arrowIndex: a.arrowIndex,
                    scoreValue: a.scoreValue,
                    isX: a.isX,
                    isMiss: a.isMiss,
                  ))
              .toList(),
        ),
      );
    }
    return ends;
  }

  Future<void> _replaceParticipantEnds(
    String sessionId,
    List<ScoringEndEntity> ends,
  ) async {
    final existing = await (_db.select(_db.scoringEndRows)
          ..where((t) => t.sessionId.equals(sessionId)))
        .get();
    for (final end in existing) {
      await (_db.delete(_db.scoringArrowRows)
            ..where((t) => t.endId.equals(end.id)))
          .go();
    }
    await (_db.delete(_db.scoringEndRows)
          ..where((t) => t.sessionId.equals(sessionId)))
        .go();

    for (final end in ends) {
      await _db.into(_db.scoringEndRows).insert(
            ScoringEndRowsCompanion.insert(
              id: end.id,
              sessionId: sessionId,
              endNumber: end.endNumber,
            ),
          );
      for (final arrow in end.arrows) {
        await _db.into(_db.scoringArrowRows).insert(
              ScoringArrowRowsCompanion.insert(
                id: arrow.id,
                endId: end.id,
                arrowIndex: arrow.arrowIndex,
                scoreValue: arrow.scoreValue,
                isX: Value(arrow.isX),
                isMiss: Value(arrow.isMiss),
              ),
            );
      }
    }
  }

  ScoringSessionRowsCompanion _participantScoreCompanion({
    required ScoringGroupEntity group,
    required String id,
    required String clientUuid,
    String? guestName,
    BowClass? bowClass,
    int? distanceM,
    int? targetFaceCm,
    required ScoringSessionStatus status,
    required bool isSynced,
    String? syncAction,
  }) {
    return ScoringSessionRowsCompanion.insert(
      id: id,
      clientUuid: clientUuid,
      bowClass: Value(bowClass?.value),
      distanceCategory:
          DistanceCategory.fromMeters(distanceM ?? group.distanceM).value,
      distanceM: distanceM ?? group.distanceM,
      environment: Value(group.environment.value),
      targetFaceCm: Value(targetFaceCm ?? group.targetFaceCm),
      targetFaceId: Value(group.targetFaceId),
      numEnds: group.numEnds,
      arrowsPerEnd: group.arrowsPerEnd,
      status: Value(status.value),
      startedAt: group.startedAt,
      scoringSessionGroupId: Value(group.id),
      guestName: Value(guestName),
      isSynced: Value(isSynced),
      syncAction: Value(syncAction),
      updatedAt: Value(DateTime.now()),
    );
  }
}
