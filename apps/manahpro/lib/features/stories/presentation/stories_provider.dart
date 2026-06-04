import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../shared/api/manah_api.dart';
import '../data/story_repository.dart';
import '../domain/story_entities.dart';

part 'stories_provider.g.dart';

@Riverpod(keepAlive: true)
StoryRepository storyRepository(Ref ref) {
  return StoryRepository(ref.watch(manahDioProvider));
}

@riverpod
class Stories extends _$Stories {
  @override
  Future<List<StoryGroupEntity>> build() {
    return ref.watch(storyRepositoryProvider).getStories();
  }

  Future<void> addStory(String filePath) async {
    state = const AsyncLoading();
    try {
      await ref.read(storyRepositoryProvider).uploadStory(filePath);
      // Invalidate provider to fetch latest list
      ref.invalidateSelf();
      await future;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> removeStory(String id) async {
    state = const AsyncLoading();
    try {
      await ref.read(storyRepositoryProvider).deleteStory(id);
      ref.invalidateSelf();
      await future;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> refreshStories() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(storyRepositoryProvider).getStories());
  }
}
