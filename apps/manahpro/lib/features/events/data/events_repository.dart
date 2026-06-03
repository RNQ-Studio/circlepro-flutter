import 'package:dio/dio.dart';
import '../domain/event_entity.dart';
import '../domain/event_registration_entity.dart';
import 'event_model.dart';
import 'event_registration_model.dart';

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
}
