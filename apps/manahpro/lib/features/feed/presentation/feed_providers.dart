import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/feed_repository.dart';
import '../domain/post_entity.dart';

part 'feed_providers.g.dart';

@Riverpod(keepAlive: true)
FeedRepository feedRepository(Ref ref) {
  return FeedRepository(ref.watch(manahDioProvider));
}

/// Community feed (Module 5, task 2.12).
@riverpod
class Feed extends _$Feed {
  @override
  Future<List<PostEntity>> build() {
    return ref.watch(feedRepositoryProvider).feed();
  }

  /// Optimistic like/unlike toggle.
  Future<void> toggleLike(PostEntity post) async {
    final repo = ref.read(feedRepositoryProvider);
    final current = state.value ?? [];

    // Optimistic update.
    state = AsyncData(_replace(current, post.copyWith(
      isLiked: !post.isLiked,
      likeCount: post.likeCount + (post.isLiked ? -1 : 1),
    )));

    try {
      final count = post.isLiked ? await repo.unlike(post.id) : await repo.like(post.id);
      final list = state.value ?? [];
      final updated = list.firstWhere((p) => p.id == post.id, orElse: () => post);
      state = AsyncData(_replace(list, updated.copyWith(likeCount: count, isLiked: !post.isLiked)));
    } catch (_) {
      state = AsyncData(_replace(state.value ?? [], post)); // revert
    }
  }

  Future<void> refreshFeed() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(feedRepositoryProvider).feed());
  }

  List<PostEntity> _replace(List<PostEntity> list, PostEntity post) {
    return [for (final p in list) if (p.id == post.id) post else p];
  }
}

/// Comments for a post.
@riverpod
Future<List<CommentEntity>> postComments(Ref ref, String postId) {
  return ref.watch(feedRepositoryProvider).comments(postId);
}
