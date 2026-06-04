import 'package:dio/dio.dart';
import '../domain/story_entities.dart';

class StoryRepository {
  const StoryRepository(this._dio);

  final Dio _dio;

  Future<List<StoryGroupEntity>> getStories() async {
    final response = await _dio.get('v1/stories');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => StoryGroupEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<StoryItemEntity> uploadStory(String filePath) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });

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
}
