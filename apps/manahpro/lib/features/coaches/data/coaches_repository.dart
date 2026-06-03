import 'package:dio/dio.dart';

import '../domain/coach_profile_entity.dart';

class CoachesRepository {
  const CoachesRepository(this._dio);

  final Dio _dio;

  Future<List<CoachProfileEntity>> directory({
    String? search,
    String? specialty,
    String? city,
  }) async {
    final response = await _dio.get('v1/coaches', queryParameters: {
      if (search != null && search.isNotEmpty) 'filter[search]': search,
      if (specialty != null && specialty.isNotEmpty) 'filter[specialty]': specialty,
      if (city != null && city.isNotEmpty) 'filter[city]': city,
    });
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => CoachProfileEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CoachProfileEntity> getCoach(String id) async {
    final response = await _dio.get('v1/coaches/$id');
    return CoachProfileEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<CoachProfileEntity> createProfile(Map<String, dynamic> data) async {
    final response = await _dio.post('v1/coaches', data: data);
    return CoachProfileEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<CoachProfileEntity> updateProfile(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('v1/coaches/$id', data: data);
    return CoachProfileEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<CoachReviewEntity>> getReviews(String coachId) async {
    final response = await _dio.get('v1/coaches/$coachId/reviews');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => CoachReviewEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CoachReviewEntity> addReview(String coachId, int rating, String? comment) async {
    final response = await _dio.post('v1/coaches/$coachId/reviews', data: {
      'rating': rating,
      if (comment != null) 'comment': comment,
    });
    return CoachReviewEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
