import 'dart:developer';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/local/scoring_database.dart';
import '../data/local/scoring_local_data_source.dart';
import '../data/remote/scoring_remote_data_source.dart';
import '../data/scoring_repository_impl.dart';
import '../domain/scoring_entities.dart';
import '../domain/scoring_repository.dart';

part 'scoring_providers.g.dart';

@Riverpod(keepAlive: true)
DioClient _scoringDioClient(Ref ref) {
  return DioClient(
    ref.watch(storageServiceProvider),
    onLogout: () async {
      await ref.read(authProvider.notifier).logout();
    },
  );
}

@Riverpod(keepAlive: true)
ScoringDatabase scoringDatabase(Ref ref) {
  final db = ScoringDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
ScoringLocalDataSource _scoringLocalDataSource(Ref ref) {
  return ScoringLocalDataSource(ref.watch(scoringDatabaseProvider));
}

@Riverpod(keepAlive: true)
ScoringRemoteDataSource _scoringRemoteDataSource(Ref ref) {
  return ScoringRemoteDataSource(ref.watch(_scoringDioClientProvider).dio);
}

@Riverpod(keepAlive: true)
ScoringRepository scoringRepository(Ref ref) {
  return ScoringRepositoryImpl(
    ref.watch(_scoringLocalDataSourceProvider),
    ref.watch(_scoringRemoteDataSourceProvider),
  );
}

/// History list of sessions (most-recent first), local-first.
@riverpod
Future<List<ScoringSessionEntity>> sessionsList(Ref ref) {
  return ref.watch(scoringRepositoryProvider).getSessions();
}

/// List of all target faces (cached locally).
@riverpod
Stream<List<TargetFaceEntity>> targetFacesList(Ref ref) {
  final repo = ref.watch(scoringRepositoryProvider);
  repo.refreshTargetFaces().catchError((Object e) {
    log('Failed to refresh target faces in background: $e');
  });
  return repo.watchTargetFaces();
}
