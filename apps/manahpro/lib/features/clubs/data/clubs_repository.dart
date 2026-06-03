import 'package:dio/dio.dart';

import '../domain/club_entity.dart';
import '../domain/club_schedule_entity.dart';

/// Online clubs API client (Module 0, task 2.7).
class ClubsRepository {
  const ClubsRepository(this._dio);

  final Dio _dio;

  Future<List<ClubEntity>> directory({String? search}) async {
    final response = await _dio.get('v1/clubs', queryParameters: {
      if (search != null && search.isNotEmpty) 'filter[search]': search,
    });
    return _list(response);
  }

  Future<List<ClubEntity>> myClubs() async {
    final response = await _dio.get('v1/clubs/mine');
    return _list(response);
  }

  Future<ClubEntity> getClub(String id) async {
    final response = await _dio.get('v1/clubs/$id');
    return ClubEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ClubEntity> createClub(Map<String, dynamic> data) async {
    final response = await _dio.post('v1/clubs', data: data);
    return ClubEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ClubEntity> updateClub(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('v1/clubs/$id', data: data);
    return ClubEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ClubEntity> join(String id) async {
    final response = await _dio.post('v1/clubs/$id/join');
    return ClubEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> leave(String id) async {
    await _dio.post('v1/clubs/$id/leave');
  }

  Future<List<ClubMemberEntity>> members(String id) async {
    final response = await _dio.get('v1/clubs/$id/members');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ClubMemberEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> removeMember(String clubId, int userId) async {
    await _dio.delete('v1/clubs/$clubId/members/$userId');
  }

  Future<List<ClubScheduleEntity>> getSchedules(String clubId) async {
    final response = await _dio.get('v1/clubs/$clubId/schedules');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ClubScheduleEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ClubScheduleEntity> createSchedule(String clubId, Map<String, dynamic> data) async {
    final response = await _dio.post('v1/clubs/$clubId/schedules', data: data);
    return ClubScheduleEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ClubScheduleEntity> updateSchedule(
      String clubId, String scheduleId, Map<String, dynamic> data) async {
    final response = await _dio.put('v1/clubs/$clubId/schedules/$scheduleId', data: data);
    return ClubScheduleEntity.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteSchedule(String clubId, String scheduleId) async {
    await _dio.delete('v1/clubs/$clubId/schedules/$scheduleId');
  }

  Future<List<ClubAttendanceEntity>> getScheduleAttendance(
      String clubId, String scheduleId) async {
    final response = await _dio.get('v1/clubs/$clubId/schedules/$scheduleId/attendance');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ClubAttendanceEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveScheduleAttendance(
      String clubId, String scheduleId, List<Map<String, dynamic>> attendances) async {
    await _dio.post('v1/clubs/$clubId/schedules/$scheduleId/attendance', data: {
      'attendances': attendances,
    });
  }

  Future<List<ClubMyAttendanceHistoryEntity>> getMyAttendanceHistory(String clubId) async {
    final response = await _dio.get('v1/clubs/$clubId/my-attendance');
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ClubMyAttendanceHistoryEntity.fromJson(e as Map<String, dynamic>)).toList();
  }

  List<ClubEntity> _list(Response<dynamic> response) {
    final data = response.data['data'] as List<dynamic>;
    return data.map((e) => ClubEntity.fromJson(e as Map<String, dynamic>)).toList();
  }
}
