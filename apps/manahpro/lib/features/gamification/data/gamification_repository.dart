import 'package:dio/dio.dart';

import '../domain/gamification_entities.dart';

class GamificationRepository {
  const GamificationRepository(this._dio);

  final Dio _dio;

  Future<UserStatsEntity> getStats() async {
    final response = await _dio.get('v1/gamification/stats');
    return UserStatsEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
