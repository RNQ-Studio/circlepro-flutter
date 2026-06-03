import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/api/manah_api.dart';
import '../data/events_repository.dart';
import '../domain/event_entity.dart';
import '../domain/event_registration_entity.dart';

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
