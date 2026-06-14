import 'dart:developer';

import '../../scoring/domain/scoring_entities.dart';
import '../../scoring/domain/scoring_enums.dart';
import '../domain/board_participant_entity.dart';
import '../domain/group_entities.dart';
import '../domain/group_live_leaderboard.dart';
import '../domain/group_scoring_repository.dart';
import 'board_participant_mapper.dart';
import 'local/group_scoring_local_data_source.dart';
import 'remote/group_scoring_remote_data_source.dart';

/// Online-first [GroupScoringRepository] for Phase 0 group metadata.
///
/// Writes (create) go to the server first, then the result is cached locally.
/// Reads try the server and refresh the cache; on failure they fall back to the
/// local cache so the list & detail still render offline (task 4.5). The server
/// remains the single source of truth for group metadata & roster.
class GroupScoringRepositoryImpl implements GroupScoringRepository {
  GroupScoringRepositoryImpl(this._remote, this._local);

  final GroupScoringRemoteDataSource _remote;
  final GroupScoringLocalDataSource _local;

  @override
  Future<ScoringGroupEntity> createGroup({
    required DistanceCategory distanceCategory,
    required int distanceM,
    required int numEnds,
    required int arrowsPerEnd,
    ArcheryEnvironment environment = ArcheryEnvironment.outdoor,
    int? targetFaceCm,
    String? targetFaceId,
    String? title,
    bool hostParticipates = false,
    BowClass? hostBowClass,
  }) async {
    final body = <String, dynamic>{
      'distance_category': distanceCategory.value,
      'distance_m': distanceM,
      'environment': environment.value,
      'num_ends': numEnds,
      'arrows_per_end': arrowsPerEnd,
      'host_participates': hostParticipates,
      if (title != null && title.isNotEmpty) 'title': title,
      if (targetFaceCm != null) 'target_face_cm': targetFaceCm,
      if (targetFaceId != null) 'target_face_id': targetFaceId,
      if (hostParticipates && hostBowClass != null)
        'host_bow_class': hostBowClass.value,
    };

    final json = await _remote.createGroup(body);
    final group = ScoringGroupEntity.fromJson(json);
    await _local.upsertGroupWithRoster(group);
    return group;
  }

  @override
  Future<List<ScoringGroupEntity>> getGroups() async {
    try {
      final data = await _remote.getGroups();
      final groups = data.map(ScoringGroupEntity.fromJson).toList();
      await _local.upsertGroups(groups);
      return groups;
    } catch (e) {
      log('GroupScoringRepository.getGroups: falling back to cache: $e');
      return _local.getGroups();
    }
  }

  @override
  Future<ScoringGroupEntity?> getGroup(String groupId) async {
    try {
      final json = await _remote.getGroup(groupId);
      final group = ScoringGroupEntity.fromJson(json);
      await _local.upsertGroupWithRoster(group);
      return group;
    } catch (e) {
      log('GroupScoringRepository.getGroup: falling back to cache: $e');
      return _local.getGroup(groupId);
    }
  }

  @override
  Future<ScoringGroupEntity> lookup(String joinCode) async {
    final json = await _remote.lookup(joinCode);
    return ScoringGroupEntity.fromJson(json);
  }

  // ─── Self-join & self-scoring (Sprint 10) ───────────────────────────────

  @override
  Future<String> joinGroup(String groupId, {BowClass? bowClass}) async {
    final body = <String, dynamic>{
      if (bowClass != null) 'bow_class': bowClass.value,
    };
    final participant = await _remote.joinGroup(groupId, body);
    final sessionId = participant['id'] as String;

    // Refresh the group + roster into the cache so the joined member's own row
    // is seeded locally and can be scored offline-first (loadBoard seeds it).
    await getGroup(groupId);

    return sessionId;
  }

  @override
  Future<void> leaveGroup(String groupId, String sessionId) async {
    await _remote.leaveGroup(groupId, sessionId);
    await _local.removeLocalParticipant(groupId, sessionId);
  }

  // ─── Host board (Sprint 05) ─────────────────────────────────────────────

  @override
  Future<List<BoardParticipant>> loadBoard(ScoringGroupEntity group) async {
    await _local.seedParticipantsFromRoster(group);
    return _local.getBoardParticipants(group.id);
  }

  @override
  Future<List<BoardParticipant>> addGuest(
    ScoringGroupEntity group,
    String name,
  ) async {
    await _local.createLocalGuest(group, name);
    _backgroundSync(group);
    return _local.getBoardParticipants(group.id);
  }

  @override
  Future<List<BoardParticipant>> addGuests(
    ScoringGroupEntity group,
    List<String> names,
  ) async {
    await _local.createLocalGuests(group, names);
    _backgroundSync(group);
    return _local.getBoardParticipants(group.id);
  }

  @override
  Future<List<BoardParticipant>> saveEnd({
    required ScoringGroupEntity group,
    required int endNumber,
    required Map<String, List<ArrowScore>> arrowsByParticipantId,
    bool sync = true,
  }) async {
    final current = await _local.getBoardParticipants(group.id);
    final byId = {for (final p in current) p.id: p};

    for (final entry in arrowsByParticipantId.entries) {
      final participant = byId[entry.key];
      if (participant == null) continue;
      await _local.saveParticipantEnd(
        group: group,
        participant: participant,
        endNumber: endNumber,
        arrows: entry.value,
      );
    }

    if (sync) _backgroundSync(group);
    return _local.getBoardParticipants(group.id);
  }

  @override
  Future<void> syncBoard(ScoringGroupEntity group) async {
    final unsynced = await _local.getUnsyncedParticipants(group.id);
    if (unsynced.isEmpty) return;

    try {
      await _remote.syncBoard(
        group.id,
        unsynced.map(boardParticipantToSyncJson).toList(),
      );
      for (final participant in unsynced) {
        await _local.markParticipantSynced(participant.id);
      }
    } catch (e) {
      // Offline / flaky network is expected on the field — keep rows unsynced
      // for the next attempt; never surface a fatal error (K2 / task 5.5).
      log('GroupScoringRepository.syncBoard: deferred (will retry): $e');
    }
  }

  // ─── Live leaderboard polling (Sprint 11) ───────────────────────────────

  @override
  Future<LiveLeaderboardSnapshot> fetchLeaderboard(
    String groupId, {
    String? version,
  }) async {
    final body = await _remote.getLeaderboard(groupId, version: version);
    return LiveLeaderboardSnapshot.fromEnvelope(body);
  }

  /// Fire-and-forget sync; swallow errors (the field has no signal half the
  /// time, and the local store already holds the truth).
  void _backgroundSync(ScoringGroupEntity group) {
    syncBoard(group).catchError((Object e) {
      log('GroupScoringRepository background board sync error: $e');
    });
  }
}
