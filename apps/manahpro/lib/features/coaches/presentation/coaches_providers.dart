import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/coaches_repository.dart';
import '../domain/coach_profile_entity.dart';

part 'coaches_providers.g.dart';

@Riverpod(keepAlive: true)
CoachesRepository coachesRepository(Ref ref) {
  return CoachesRepository(ref.watch(manahDioProvider));
}

@riverpod
Future<List<CoachProfileEntity>> coachDirectory(
  Ref ref, {
  String? search,
  String? specialty,
  String? city,
}) {
  return ref.watch(coachesRepositoryProvider).directory(
        search: search,
        specialty: specialty,
        city: city,
      );
}

@riverpod
Future<CoachProfileEntity> coachDetail(Ref ref, String id) {
  return ref.watch(coachesRepositoryProvider).getCoach(id);
}

@riverpod
Future<List<CoachReviewEntity>> coachReviews(Ref ref, String coachId) {
  return ref.watch(coachesRepositoryProvider).getReviews(coachId);
}
