import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../../scoring/presentation/scoring_providers.dart';
import '../data/group_scoring_repository_impl.dart';
import '../data/local/group_scoring_local_data_source.dart';
import '../data/remote/group_scoring_remote_data_source.dart';
import '../domain/group_entities.dart';
import '../domain/group_scoring_repository.dart';

part 'group_scoring_providers.g.dart';

@Riverpod(keepAlive: true)
GroupScoringRemoteDataSource _groupRemoteDataSource(Ref ref) {
  return GroupScoringRemoteDataSource(ref.watch(manahDioProvider));
}

@Riverpod(keepAlive: true)
GroupScoringLocalDataSource _groupLocalDataSource(Ref ref) {
  // Reuse the shared scoring Drift DB (Sprint 04 decision, task 4.2).
  return GroupScoringLocalDataSource(ref.watch(scoringDatabaseProvider));
}

@Riverpod(keepAlive: true)
GroupScoringRepository groupScoringRepository(Ref ref) {
  return GroupScoringRepositoryImpl(
    ref.watch(_groupRemoteDataSourceProvider),
    ref.watch(_groupLocalDataSourceProvider),
  );
}

/// Groups the user hosts or participates in (local-first, refreshed online).
@riverpod
Future<List<ScoringGroupEntity>> groupsList(Ref ref) {
  return ref.watch(groupScoringRepositoryProvider).getGroups();
}

/// A single group with its roster (local-first, refreshed online).
@riverpod
Future<ScoringGroupEntity?> groupDetail(Ref ref, String groupId) {
  return ref.watch(groupScoringRepositoryProvider).getGroup(groupId);
}
