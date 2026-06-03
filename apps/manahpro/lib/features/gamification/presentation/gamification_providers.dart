import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/gamification_repository.dart';
import '../domain/gamification_entities.dart';

part 'gamification_providers.g.dart';

@Riverpod(keepAlive: true)
GamificationRepository gamificationRepository(Ref ref) {
  return GamificationRepository(ref.watch(manahDioProvider));
}

@riverpod
Future<UserStatsEntity> gamificationStats(Ref ref) {
  return ref.watch(gamificationRepositoryProvider).getStats();
}
