import 'package:dio/dio.dart';

import '../domain/profile_entity.dart';

/// Online profile API client (Module 0/2). `GET/PUT /v1/profile`.
class ProfileRepository {
  const ProfileRepository(this._dio);

  final Dio _dio;

  Future<ProfileEntity> getMyProfile() async {
    final response = await _dio.get('v1/profile');
    return ProfileEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ProfileEntity> updateProfile(Map<String, dynamic> changes) async {
    final response = await _dio.put('v1/profile', data: changes);
    return ProfileEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ProfileEntity> getPublicProfile(int userId) async {
    final response = await _dio.get('v1/users/$userId/profile');
    return ProfileEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> followUser(int userId) async {
    await _dio.post('v1/users/$userId/follow');
  }

  Future<void> unfollowUser(int userId) async {
    await _dio.post('v1/users/$userId/unfollow');
  }

  Future<List<ProfileEntity>> getFollowers(int userId) async {
    final response = await _dio.get('v1/users/$userId/followers');
    final list = response.data['data'] as List;
    return list.map((item) => ProfileEntity.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<List<ProfileEntity>> getFollowing(int userId) async {
    final response = await _dio.get('v1/users/$userId/following');
    final list = response.data['data'] as List;
    return list.map((item) => ProfileEntity.fromJson(item as Map<String, dynamic>)).toList();
  }
}
