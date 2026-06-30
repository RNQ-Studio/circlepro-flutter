import 'dart:developer';

import '../domain/scoring_entities.dart';
import '../domain/scoring_enums.dart';
import '../domain/scoring_repository.dart';
import '../utils/ulid.dart';
import 'local/scoring_local_data_source.dart';
import 'remote/scoring_remote_data_source.dart';
import 'scoring_session_mapper.dart';

/// Offline-first [ScoringRepository].
///
/// Writes always land in local Drift first (optimistic), then a best-effort
/// background sync pushes unsynced sessions to the server via the idempotent
/// batch endpoint. The local store is the single source of truth for the UI.
class ScoringRepositoryImpl implements ScoringRepository {
  ScoringRepositoryImpl(this._local, this._remote);

  final ScoringLocalDataSource _local;
  final ScoringRemoteDataSource _remote;

  @override
  Future<ScoringSessionEntity> startSession({
    required BowClass bowClass,
    required DistanceCategory distanceCategory,
    required int distanceM,
    required int numEnds,
    required int arrowsPerEnd,
    ArcheryEnvironment environment = ArcheryEnvironment.outdoor,
    int? targetFaceCm,
    String? targetFaceId,
    int? maxPossibleScoreOverride,
    String? equipmentProfileId,
    String? title,
    int sighterEndCount = 0,
  }) async {
    final normalizedSighterEndCount =
        sighterEndCount.clamp(0, numEnds - 1).toInt();
    final session = ScoringSessionEntity(
      id: Ids.ulid(),
      clientUuid: Ids.uuid(),
      bowClass: bowClass,
      distanceCategory: distanceCategory,
      distanceM: distanceM,
      numEnds: numEnds,
      arrowsPerEnd: arrowsPerEnd,
      environment: environment,
      targetFaceCm: targetFaceCm,
      targetFaceId: targetFaceId,
      equipmentProfileId: equipmentProfileId,
      title: title,
      startedAt: DateTime.now(),
      ends: List.generate(
        numEnds,
        (i) => ScoringEndEntity(
          id: Ids.ulid(),
          endNumber: i + 1,
          isSighter: i < normalizedSighterEndCount,
        ),
      ),
      maxPossibleScoreOverride: maxPossibleScoreOverride,
    );

    await _local.upsertSession(session, syncAction: 'create');
    return session;
  }

  @override
  Future<ScoringSessionEntity> saveEnd({
    required String sessionId,
    required int endNumber,
    required List<ArrowScore> arrows,
  }) async {
    final session = await _local.getSession(sessionId);
    if (session == null) {
      throw StateError('Session $sessionId not found');
    }

    final ends = session.ends.map((end) {
      return end.endNumber == endNumber ? end.copyWith(arrows: arrows) : end;
    }).toList();

    final updated = session.copyWith(ends: ends);
    await _local.upsertSession(updated, syncAction: _nextAction(session));
    return updated;
  }

  @override
  Future<ScoringSessionEntity> finishSession(String sessionId) async {
    final session = await _local.getSession(sessionId);
    if (session == null) {
      throw StateError('Session $sessionId not found');
    }

    final isPb = await _detectPersonalBest(session);

    final finished = session.copyWith(
      status: ScoringSessionStatus.completed,
      completedAt: DateTime.now(),
      isPersonalBest: isPb,
    );

    await _local.upsertSession(finished, syncAction: _nextAction(session));
    _backgroundSync();
    return finished;
  }

  @override
  Future<ScoringSessionEntity?> getSession(String sessionId) =>
      _local.getSession(sessionId);

  @override
  Future<List<ScoringSessionEntity>> getSessions() => _local.getAllSessions();

  @override
  Future<void> deleteSession(String sessionId) async {
    await _local.markDeleted(sessionId);
    _backgroundSync();
  }

  @override
  Future<void> sync() async {
    final online = await _remote.checkHealth();
    if (!online) {
      log('ScoringRepository.sync: server unreachable, skipping');
      return;
    }

    final unsynced = await _local.getUnsynced();
    if (unsynced.isEmpty) return;

    final deletes = unsynced.where((s) => s.syncAction == 'delete').toList();
    final upserts = unsynced.where((s) => s.syncAction != 'delete').toList();

    // Process queued deletes individually (sync endpoint only upserts).
    for (final session in deletes) {
      try {
        await _remote.deleteSession(session.id);
        await _local.deletePermanently(session.id);
      } catch (e) {
        log('ScoringRepository.sync: delete failed for ${session.id}: $e');
      }
    }

    // Idempotent batch upsert (server dedups by client_uuid).
    if (upserts.isNotEmpty) {
      try {
        await _remote.syncBatch(upserts.map(scoringSessionToSyncJson).toList());
        for (final session in upserts) {
          await _local.markSynced(session.id);
        }
      } catch (e) {
        log('ScoringRepository.sync: batch upsert failed: $e');
      }
    }
  }

  /// Keep 'create' until the session has been synced once, then 'update'.
  String _nextAction(ScoringSessionEntity existing) {
    if (!existing.isSynced && existing.syncAction == 'create') return 'create';
    return 'update';
  }

  Future<bool> _detectPersonalBest(ScoringSessionEntity session) async {
    final all = await _local.getAllSessions();
    final comparable = all.where((s) =>
        s.id != session.id &&
        s.status == ScoringSessionStatus.completed &&
        s.bowClass == session.bowClass &&
        s.distanceCategory == session.distanceCategory &&
        s.arrowsShot == session.arrowsShot);

    if (comparable.isEmpty) return session.arrowsShot > 0;

    final bestOther =
        comparable.map((s) => s.totalScore).reduce((a, b) => a > b ? a : b);
    return session.totalScore > bestOther;
  }

  void _backgroundSync() {
    sync().catchError((Object e) {
      log('ScoringRepository background sync error: $e');
    });
  }

  @override
  Stream<List<TargetFaceEntity>> watchTargetFaces() =>
      _local.watchTargetFaces();

  @override
  Future<void> refreshTargetFaces() async {
    try {
      final data = await _remote.getTargetFaces();
      final entities =
          data.map((json) => TargetFaceEntity.fromJson(json)).toList();
      await _local.saveTargetFaces(entities);
    } catch (e) {
      log('ScoringRepository.refreshTargetFaces failed: $e');
    }
  }
}
