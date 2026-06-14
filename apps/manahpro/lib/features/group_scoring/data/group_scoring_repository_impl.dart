import 'dart:developer';

import '../../scoring/domain/scoring_enums.dart';
import '../domain/group_entities.dart';
import '../domain/group_scoring_repository.dart';
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
}
