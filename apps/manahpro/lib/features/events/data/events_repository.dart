import 'package:dio/dio.dart';
import '../domain/event_entity.dart';
import '../domain/event_registration_entity.dart';
import '../domain/target_scorecard_item.dart';
import '../domain/event_leaderboard_entry.dart';
import '../domain/user_rating_entity.dart';
import '../domain/rating_history_entry.dart';
import 'event_model.dart';
import 'event_registration_model.dart';
import 'target_scorecard_item_model.dart';
import 'event_leaderboard_entry_model.dart';
import 'user_rating_model.dart';
import 'rating_history_entry_model.dart';

/// Online events API client (Module 2, Phase 3).
class EventsRepository {
  const EventsRepository(this._dio);

  final Dio _dio;

  Future<List<EventEntity>> getEvents({
    String? search,
    String? province,
    String? city,
    String? tier,
    String? format,
    String? status,
  }) async {
    final response = await _dio.get('v1/events', queryParameters: {
      if (search != null && search.isNotEmpty) 'filter[search]': search,
      if (province != null && province.isNotEmpty) 'filter[province]': province,
      if (city != null && city.isNotEmpty) 'filter[city]': city,
      if (tier != null && tier.isNotEmpty) 'filter[tier]': tier,
      if (format != null && format.isNotEmpty) 'filter[format]': format,
      if (status != null && status.isNotEmpty) 'filter[status]': status,
    });
    return _list(response);
  }

  Future<List<EventEntity>> getMyEvents() async {
    final response = await _dio.get('v1/my-events');
    return _list(response);
  }

  Future<EventEntity> getEvent(String id) async {
    final response = await _dio.get('v1/events/$id');
    return eventFromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<EventEntity> createEvent(Map<String, dynamic> data) async {
    final response = await _dio.post('v1/events', data: data);
    return eventFromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<EventEntity> updateEvent(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('v1/events/$id', data: data);
    return eventFromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteEvent(String id) async {
    await _dio.delete('v1/events/$id');
  }

  List<EventEntity> _list(Response<dynamic> response) {
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => eventFromJson(e as Map<String, dynamic>)).toList();
  }

  // ─── Registration & Ticket methods ─────────────────────────────────────────

  Future<EventRegistrationEntity> registerForEvent(String eventId, String divisionId) async {
    final response = await _dio.post(
      'v1/events/$eventId/register',
      data: {'event_division_id': divisionId},
    );
    return eventRegistrationFromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<EventRegistrationEntity>> getMyTickets() async {
    final response = await _dio.get('v1/my-tickets');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => eventRegistrationFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<EventRegistrationEntity>> getEventParticipants(String eventId) async {
    final response = await _dio.get('v1/events/$eventId/participants');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => eventRegistrationFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<EventRegistrationEntity> checkInParticipant(String registrationId) async {
    final response = await _dio.post('v1/registrations/$registrationId/check-in');
    return eventRegistrationFromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<EventRegistrationEntity> updateParticipantStatus(String registrationId, String status) async {
    final response = await _dio.put(
      'v1/registrations/$registrationId/status',
      data: {'status': status},
    );
    return eventRegistrationFromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ─── Target & Scoring methods (Phase 3 COMPETE) ────────────────────────────

  Future<void> assignTargets(String eventId, List<Map<String, dynamic>> assignments) async {
    await _dio.post(
      'v1/events/$eventId/assign-targets',
      data: {'assignments': assignments},
    );
  }

  Future<List<TargetScorecardItem>> getTargetScorecard(
    String eventId,
    String divisionId,
    int targetButt,
  ) async {
    final response = await _dio.get(
      'v1/events/$eventId/divisions/$divisionId/targets/$targetButt/scorecard',
    );
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => targetScorecardItemFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveTargetEndScores(
    String eventId,
    String divisionId,
    int targetButt,
    int endNumber,
    List<Map<String, dynamic>> scores,
  ) async {
    await _dio.post(
      'v1/events/$eventId/divisions/$divisionId/targets/$targetButt/ends/$endNumber',
      data: {'scores': scores},
    );
  }

  Future<List<EventLeaderboardEntry>> getEventLeaderboard(
    String eventId,
    String divisionId,
  ) async {
    final response = await _dio.get(
      'v1/events/$eventId/divisions/$divisionId/leaderboard',
    );
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => eventLeaderboardEntryFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<UserRatingEntity>> getNationalLeaderboard({
    required String bowClass,
    required String gender,
    required String ageGroup,
    required String distanceCategory,
    String? province,
    String? city,
  }) async {
    final response = await _dio.get(
      'v1/leaderboard',
      queryParameters: {
        'bow_class': bowClass,
        'gender': gender,
        'age_group': ageGroup,
        'distance_category': distanceCategory,
        if (province != null && province.isNotEmpty) 'province': province,
        if (city != null && city.isNotEmpty) 'city': city,
      },
    );
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => userRatingFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<UserRatingEntity>> getUserRatings(String userId) async {
    final response = await _dio.get('v1/users/$userId/ratings');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => userRatingFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<RatingHistoryEntry>> getRatingHistory(String userId, String ratingId) async {
    final response = await _dio.get('v1/users/$userId/ratings/$ratingId/history');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ratingHistoryEntryFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<UserRatingEntity>> getMyRatings() async {
    final response = await _dio.get('v1/my-ratings');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => userRatingFromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> finalizeEventRatings(String eventId, String divisionId) async {
    await _dio.post('v1/events/$eventId/divisions/$divisionId/finalize-ratings');
  }
}
