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

/// A public user's profile (Phase 4). Supports follow/unfollow action.
@riverpod
class PublicProfile extends _$PublicProfile {
  @override
  Future<ProfileEntity> build(int userId) {
    return ref.watch(profileRepositoryProvider).getPublicProfile(userId);
  }

  Future<void> toggleFollow() async {
    final currentProfile = state.asData?.value;
    if (currentProfile == null) return;

    final repo = ref.read(profileRepositoryProvider);
    final nextFollowing = !currentProfile.isFollowing;
    final nextFollowersCount = currentProfile.followersCount + (nextFollowing ? 1 : -1);

    // Optimistic update
    state = AsyncData(currentProfile.copyWith(
      isFollowing: nextFollowing,
      followersCount: nextFollowersCount,
    ));

    try {
      if (nextFollowing) {
        await repo.followUser(userId);
      } else {
        await repo.unfollowUser(userId);
      }
      // Invalidate local following states/stats
      ref.invalidate(myProfileProvider);
      ref.invalidate(followersListProvider(userId));
      ref.invalidate(followingListProvider(userId));
    } catch (e) {
      // Revert if error
      state = AsyncData(currentProfile);
      rethrow;
    }
  }
}

@riverpod
Future<List<ProfileEntity>> followersList(Ref ref, int userId) {
  return ref.watch(profileRepositoryProvider).getFollowers(userId);
}

@riverpod
Future<List<ProfileEntity>> followingList(Ref ref, int userId) {
  return ref.watch(profileRepositoryProvider).getFollowing(userId);
}
