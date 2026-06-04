import 'package:dio/dio.dart';

/// Remote scoring API (ManahPro backend, Module 1). Endpoints require the
/// Passport bearer token injected by the shared [DioClient] interceptor.
class ScoringRemoteDataSource {
  const ScoringRemoteDataSource(this._dio);

  final Dio _dio;

  /// Idempotent batch sync. `POST /v1/scoring/sessions/sync`.
  ///
  /// [sessions] are pre-built sync payloads (see [scoringSessionToSyncJson]).
  Future<void> syncBatch(List<Map<String, dynamic>> sessions) async {
    if (sessions.isEmpty) return;
    await _dio.post('v1/scoring/sessions/sync', data: {'sessions': sessions});
  }

  /// Delete a session on the server. `DELETE /v1/scoring/sessions/{id}`.
  Future<void> deleteSession(String id) async {
    await _dio.delete('v1/scoring/sessions/$id');
  }

  /// Whether the server is reachable. `GET /v1/health`.
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('v1/health');
      return response.data['success'] == true;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Fetch all target faces from the backend. `GET /v1/scoring/target-faces`.
  Future<List<Map<String, dynamic>>> getTargetFaces() async {
    final response = await _dio.get('v1/scoring/target-faces');
    final data = response.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => e as Map<String, dynamic>).toList();
  }
}
