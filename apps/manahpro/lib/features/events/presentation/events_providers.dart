import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/events_repository.dart';
import '../domain/event_entity.dart';
import '../domain/event_registration_entity.dart';
import '../domain/target_scorecard_item.dart';
import '../domain/event_leaderboard_entry.dart';
import '../domain/user_rating_entity.dart';
import '../domain/rating_history_entry.dart';

part 'events_providers.g.dart';

@Riverpod(keepAlive: true)
EventsRepository eventsRepository(Ref ref) {
  return EventsRepository(ref.watch(manahDioProvider));
}

class EventFilters {
  const EventFilters({
    this.search,
    this.province,
    this.city,
    this.tier,
    this.format,
    this.status,
  });

  final String? search;
  final String? province;
  final String? city;
  final String? tier;
  final String? format;
  final String? status;

  EventFilters copyWith({
    String? search,
    String? province,
    String? city,
    String? tier,
    String? format,
    String? status,
  }) {
    return EventFilters(
      search: search ?? this.search,
      province: province ?? this.province,
      city: city ?? this.city,
      tier: tier ?? this.tier,
      format: format ?? this.format,
      status: status ?? this.status,
    );
  }
}

@riverpod
class EventFiltersState extends _$EventFiltersState {
  @override
  EventFilters build() => const EventFilters();

  void updateSearch(String? search) => state = state.copyWith(search: search);
  void updateProvince(String? province) => state = state.copyWith(province: province);
  void updateCity(String? city) => state = state.copyWith(city: city);
  void updateTier(String? tier) => state = state.copyWith(tier: tier);
  void updateFormat(String? format) => state = state.copyWith(format: format);
  void updateStatus(String? status) => state = state.copyWith(status: status);
  void reset() => state = const EventFilters();
}

@riverpod
Future<List<EventEntity>> eventsList(Ref ref) {
  final filters = ref.watch(eventFiltersStateProvider);
  return ref.watch(eventsRepositoryProvider).getEvents(
        search: filters.search,
        province: filters.province,
        city: filters.city,
        tier: filters.tier,
        format: filters.format,
        status: filters.status,
      );
}

@riverpod
Future<EventEntity> eventDetails(Ref ref, String id) {
  return ref.watch(eventsRepositoryProvider).getEvent(id);
}

@riverpod
Future<List<EventEntity>> myEvents(Ref ref) {
  return ref.watch(eventsRepositoryProvider).getMyEvents();
}

@riverpod
Future<List<EventRegistrationEntity>> myTickets(Ref ref) {
  return ref.watch(eventsRepositoryProvider).getMyTickets();
}

@riverpod
Future<List<EventRegistrationEntity>> eventParticipants(Ref ref, String eventId) {
  return ref.watch(eventsRepositoryProvider).getEventParticipants(eventId);
}

@riverpod
Future<List<TargetScorecardItem>> targetScorecard(
  Ref ref, {
  required String eventId,
  required String divisionId,
  required int targetButt,
}) {
  return ref.watch(eventsRepositoryProvider).getTargetScorecard(
        eventId,
        divisionId,
        targetButt,
      );
}

@riverpod
Future<List<EventLeaderboardEntry>> eventLeaderboard(
  Ref ref, {
  required String eventId,
  required String divisionId,
}) {
  return ref.watch(eventsRepositoryProvider).getEventLeaderboard(
        eventId,
        divisionId,
      );
}

class NationalLeaderboardFilters {
  const NationalLeaderboardFilters({
    required this.bowClass,
    required this.gender,
    required this.ageGroup,
    required this.distanceCategory,
    this.province,
    this.city,
  });

  final String bowClass;
  final String gender;
  final String ageGroup;
  final String distanceCategory;
  final String? province;
  final String? city;

  NationalLeaderboardFilters copyWith({
    String? bowClass,
    String? gender,
    String? ageGroup,
    String? distanceCategory,
    String? province,
    String? city,
  }) {
    return NationalLeaderboardFilters(
      bowClass: bowClass ?? this.bowClass,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      distanceCategory: distanceCategory ?? this.distanceCategory,
      province: province ?? this.province,
      city: city ?? this.city,
    );
  }
}

@riverpod
class NationalLeaderboardFiltersState extends _$NationalLeaderboardFiltersState {
  @override
  NationalLeaderboardFilters build() => const NationalLeaderboardFilters(
        bowClass: 'recurve',
        gender: 'male',
        ageGroup: 'dewasa',
        distanceCategory: '70m',
      );

  void updateBowClass(String bowClass) => state = state.copyWith(bowClass: bowClass);
  void updateGender(String gender) => state = state.copyWith(gender: gender);
  void updateAgeGroup(String ageGroup) => state = state.copyWith(ageGroup: ageGroup);
  void updateDistanceCategory(String distanceCategory) => state = state.copyWith(distanceCategory: distanceCategory);
  void updateProvince(String? province) => state = state.copyWith(province: province);
  void updateCity(String? city) => state = state.copyWith(city: city);
  void reset() => state = const NationalLeaderboardFilters(
        bowClass: 'recurve',
        gender: 'male',
        ageGroup: 'dewasa',
        distanceCategory: '70m',
      );
}

@riverpod
Future<List<UserRatingEntity>> nationalLeaderboard(Ref ref) {
  final filters = ref.watch(nationalLeaderboardFiltersStateProvider);
  return ref.watch(eventsRepositoryProvider).getNationalLeaderboard(
        bowClass: filters.bowClass,
        gender: filters.gender,
        ageGroup: filters.ageGroup,
        distanceCategory: filters.distanceCategory,
        province: filters.province,
        city: filters.city,
      );
}

@riverpod
Future<List<UserRatingEntity>> userRatings(Ref ref, String userId) {
  return ref.watch(eventsRepositoryProvider).getUserRatings(userId);
}

@riverpod
Future<List<RatingHistoryEntry>> ratingHistory(
  Ref ref, {
  required String userId,
  required String ratingId,
}) {
  return ref.watch(eventsRepositoryProvider).getRatingHistory(userId, ratingId);
}

@riverpod
Future<List<UserRatingEntity>> myRatings(Ref ref) {
  return ref.watch(eventsRepositoryProvider).getMyRatings();
}
