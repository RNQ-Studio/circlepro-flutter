import 'package:dio/dio.dart';

/// Remote API for Latihan Bersama (group scoring), Phase 0 lifecycle endpoints
/// under `v1/scoring/groups`. The Passport bearer token is injected by the
/// shared authenticated [Dio] (see `manahDio`). Every response uses the
/// `App\Support\ApiResponse` envelope: `{ success, message, data, meta }`.
class GroupScoringRemoteDataSource {
  const GroupScoringRemoteDataSource(this._dio);

  final Dio _dio;

  /// Create a group + unique join_code. `POST /v1/scoring/groups`.
  Future<Map<String, dynamic>> createGroup(Map<String, dynamic> body) async {
    final response = await _dio.post('v1/scoring/groups', data: body);
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Groups the caller hosts or participates in. `GET /v1/scoring/groups`.
  Future<List<Map<String, dynamic>>> getGroups() async {
    final response = await _dio.get('v1/scoring/groups');
    final data = response.data['data'] as List<dynamic>? ?? const [];
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  /// Group detail with roster. `GET /v1/scoring/groups/{group}`.
  Future<Map<String, dynamic>> getGroup(String groupId) async {
    final response = await _dio.get('v1/scoring/groups/$groupId');
    return response.data['data'] as Map<String, dynamic>;
  }

  /// Preview a group by its join code. `GET /v1/scoring/groups/lookup?code=`.
  Future<Map<String, dynamic>> lookup(String joinCode) async {
    final response = await _dio.get(
      'v1/scoring/groups/lookup',
      queryParameters: {'code': joinCode},
    );
    return response.data['data'] as Map<String, dynamic>;
  }
}
