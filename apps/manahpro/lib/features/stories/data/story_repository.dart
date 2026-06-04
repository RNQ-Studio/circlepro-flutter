import 'package:dio/dio.dart';
import '../../../../shared/models/user_simple_entity.dart';
import '../domain/story_entities.dart';

class StoryRepository {
  const StoryRepository(this._dio);

  final Dio _dio;

  Future<List<StoryGroupEntity>> getStories() async {
    final response = await _dio.get('v1/stories');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => StoryGroupEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<StoryItemEntity> uploadStory(String filePath, {String? caption}) async {
    final fileName = filePath.split('/').last;
    final mapData = <String, dynamic>{
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    };
    if (caption != null && caption.isNotEmpty) {
      mapData['caption'] = caption;
    }
    final formData = FormData.fromMap(mapData);

    final response = await _dio.post(
      'v1/stories',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    return StoryItemEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteStory(String id) async {
    await _dio.delete('v1/stories/$id');
  }

  Future<void> markStoryAsViewed(String storyId) async {
    await _dio.post('v1/stories/$storyId/view');
  }

  Future<List<UserSimpleEntity>> getStoryViewers(String storyId) async {
    final response = await _dio.get('v1/stories/$storyId/viewers');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => UserSimpleEntity.fromJson(e as Map<String, dynamic>)).toList();
  }
}
