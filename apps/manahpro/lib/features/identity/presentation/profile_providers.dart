import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/profile_repository.dart';
import '../domain/profile_entity.dart';

part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(ref.watch(manahDioProvider));
}

/// The signed-in user's profile (Module 0/2, task 2.3).
@riverpod
class MyProfile extends _$MyProfile {
  @override
  Future<ProfileEntity> build() {
    return ref.watch(profileRepositoryProvider).getMyProfile();
  }

  /// Apply changes and refresh.
  Future<void> save(Map<String, dynamic> changes) async {
    state = const AsyncLoading();
    final updated = await ref.read(profileRepositoryProvider).updateProfile(changes);
    state = AsyncData(updated);
  }
}
