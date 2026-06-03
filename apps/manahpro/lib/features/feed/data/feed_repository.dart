import 'package:dio/dio.dart';

import '../domain/post_entity.dart';

/// Online community feed API client (Module 5, task 2.11).
class FeedRepository {
  const FeedRepository(this._dio);

  final Dio _dio;

  Future<List<PostEntity>> feed({String? filter}) async {
    final response = await _dio.get(
      'v1/posts',
      queryParameters: filter != null ? {'feed': filter} : null,
    );
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => PostEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PostEntity> createPost(Map<String, dynamic> data) async {
    final response = await _dio.post('v1/posts', data: data);
    return PostEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deletePost(String id) async {
    await _dio.delete('v1/posts/$id');
  }

  /// Returns the new like_count.
  Future<int> like(String id) async {
    final response = await _dio.post('v1/posts/$id/like');
    return response.data['data']['like_count'] as int;
  }

  Future<int> unlike(String id) async {
    final response = await _dio.delete('v1/posts/$id/like');
    return response.data['data']['like_count'] as int;
  }

  Future<List<CommentEntity>> comments(String postId) async {
    final response = await _dio.get('v1/posts/$postId/comments');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => CommentEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CommentEntity> addComment(String postId, String body) async {
    final response = await _dio.post('v1/posts/$postId/comments', data: {'body': body});
    return CommentEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
