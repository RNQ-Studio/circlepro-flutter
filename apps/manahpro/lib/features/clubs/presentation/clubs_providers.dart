import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/clubs_repository.dart';
import '../domain/club_entity.dart';
import '../domain/club_schedule_entity.dart';

part 'clubs_providers.g.dart';

@Riverpod(keepAlive: true)
ClubsRepository clubsRepository(Ref ref) {
  return ClubsRepository(ref.watch(manahDioProvider));
}

/// Club directory (optionally filtered by [search]).
@riverpod
Future<List<ClubEntity>> clubDirectory(Ref ref, {String? search}) {
  return ref.watch(clubsRepositoryProvider).directory(search: search);
}

/// Clubs the user belongs to.
@riverpod
Future<List<ClubEntity>> myClubs(Ref ref) {
  return ref.watch(clubsRepositoryProvider).myClubs();
}

/// A single club's detail.
@riverpod
Future<ClubEntity> clubDetail(Ref ref, String clubId) {
  return ref.watch(clubsRepositoryProvider).getClub(clubId);
}

/// A club's member list.
@riverpod
Future<List<ClubMemberEntity>> clubMembers(Ref ref, String clubId) {
  return ref.watch(clubsRepositoryProvider).members(clubId);
}

/// List of schedules for a club.
@riverpod
Future<List<ClubScheduleEntity>> clubSchedules(Ref ref, String clubId) {
  return ref.watch(clubsRepositoryProvider).getSchedules(clubId);
}

/// Attendance sheet for a specific club schedule.
@riverpod
Future<List<ClubAttendanceEntity>> scheduleAttendance(
    Ref ref, String clubId, String scheduleId) {
  return ref.watch(clubsRepositoryProvider).getScheduleAttendance(clubId, scheduleId);
}

/// Logged in user's attendance history in a club.
@riverpod
Future<List<ClubMyAttendanceHistoryEntity>> myAttendanceHistory(Ref ref, String clubId) {
  return ref.watch(clubsRepositoryProvider).getMyAttendanceHistory(clubId);
}
