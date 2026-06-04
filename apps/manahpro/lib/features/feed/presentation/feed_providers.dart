import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/feed_repository.dart';
import '../domain/post_entity.dart';

part 'feed_providers.g.dart';

@Riverpod(keepAlive: true)
FeedRepository feedRepository(Ref ref) {
  return FeedRepository(ref.watch(manahDioProvider));
}

@riverpod
class FeedFilter extends _$FeedFilter {
  @override
  String? build() => null;

  void setFilter(String? value) => state = value;
}

@riverpod
class FeedSort extends _$FeedSort {
  @override
  String? build() => null; // e.g., 'engagement' or null (newest)

  void setSort(String? value) => state = value;
}

/// Community feed (Module 5, task 2.12).
@riverpod
class Feed extends _$Feed {
  @override
  Future<List<PostEntity>> build() {
    final filter = ref.watch(feedFilterProvider);
    final sort = ref.watch(feedSortProvider);
    return ref.watch(feedRepositoryProvider).feed(filter: filter, sort: sort);
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

  /// Optimistic vote casting in a poll.
  Future<void> vote(String postId, String pollId, String optionId) async {
    final repo = ref.read(feedRepositoryProvider);
    final current = state.value ?? [];
    final postIndex = current.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;
    
    final post = current[postIndex];
    final poll = post.poll;
    if (poll == null) return;

    final updatedOptions = poll.options.map((opt) {
      int change = 0;
      if (opt.id == optionId) change = 1;
      if (poll.userVotedOptionId == opt.id) change = -1;
      return PollOptionEntity(
        id: opt.id,
        optionText: opt.optionText,
        votesCount: opt.votesCount + change,
      );
    }).toList();

    final updatedPoll = PollEntity(
      id: poll.id,
      question: poll.question,
      expiresAt: poll.expiresAt,
      isExpired: poll.isExpired,
      options: updatedOptions,
      totalVotes: poll.totalVotes + (poll.userVotedOptionId == null ? 1 : 0),
      userVotedOptionId: optionId,
    );

    state = AsyncData(_replace(current, post.copyWith(poll: updatedPoll)));

    try {
      final freshPost = await repo.voteInPoll(pollId, optionId);
      state = AsyncData(_replace(state.value ?? [], freshPost));
    } catch (_) {
      state = AsyncData(_replace(state.value ?? [], post)); // revert
    }
  }

  Future<void> refreshFeed() async {
    state = const AsyncLoading();
    final filter = ref.read(feedFilterProvider);
    final sort = ref.read(feedSortProvider);
    state = await AsyncValue.guard(() => ref.read(feedRepositoryProvider).feed(filter: filter, sort: sort));
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
