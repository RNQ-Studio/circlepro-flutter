// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(eventsRepository)
final eventsRepositoryProvider = EventsRepositoryProvider._();

final class EventsRepositoryProvider extends $FunctionalProvider<
    EventsRepository,
    EventsRepository,
    EventsRepository> with $Provider<EventsRepository> {
  EventsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eventsRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventsRepositoryHash();

  @$internal
  @override
  $ProviderElement<EventsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EventsRepository create(Ref ref) {
    return eventsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventsRepository>(value),
    );
  }
}

String _$eventsRepositoryHash() => r'd575c5ade59b520b5c7c6aaa895a45ffc2a9dc9c';

@ProviderFor(EventFiltersState)
final eventFiltersStateProvider = EventFiltersStateProvider._();

final class EventFiltersStateProvider
    extends $NotifierProvider<EventFiltersState, EventFilters> {
  EventFiltersStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eventFiltersStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventFiltersStateHash();

  @$internal
  @override
  EventFiltersState create() => EventFiltersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventFilters>(value),
    );
  }
}

String _$eventFiltersStateHash() => r'53bfbbd951e51ae34cb4ac016386d6960e7d4fd5';

abstract class _$EventFiltersState extends $Notifier<EventFilters> {
  EventFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EventFilters, EventFilters>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<EventFilters, EventFilters>,
        EventFilters,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(eventsList)
final eventsListProvider = EventsListProvider._();

final class EventsListProvider extends $FunctionalProvider<
        AsyncValue<List<EventEntity>>,
        List<EventEntity>,
        FutureOr<List<EventEntity>>>
    with
        $FutureModifier<List<EventEntity>>,
        $FutureProvider<List<EventEntity>> {
  EventsListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'eventsListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventsListHash();

  @$internal
  @override
  $FutureProviderElement<List<EventEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventEntity>> create(Ref ref) {
    return eventsList(ref);
  }
}

String _$eventsListHash() => r'62630d31ab688fad1eae6f2554613322293d387b';

@ProviderFor(eventDetails)
final eventDetailsProvider = EventDetailsFamily._();

final class EventDetailsProvider extends $FunctionalProvider<
        AsyncValue<EventEntity>, EventEntity, FutureOr<EventEntity>>
    with $FutureModifier<EventEntity>, $FutureProvider<EventEntity> {
  EventDetailsProvider._(
      {required EventDetailsFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'eventDetailsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventDetailsHash();

  @override
  String toString() {
    return r'eventDetailsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EventEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<EventEntity> create(Ref ref) {
    final argument = this.argument as String;
    return eventDetails(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventDetailsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventDetailsHash() => r'affcbf472436128f048c5e836ec40f5a228a9529';

final class EventDetailsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EventEntity>, String> {
  EventDetailsFamily._()
      : super(
          retry: null,
          name: r'eventDetailsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  EventDetailsProvider call(
    String id,
  ) =>
      EventDetailsProvider._(argument: id, from: this);

  @override
  String toString() => r'eventDetailsProvider';
}

@ProviderFor(myEvents)
final myEventsProvider = MyEventsProvider._();

final class MyEventsProvider extends $FunctionalProvider<
        AsyncValue<List<EventEntity>>,
        List<EventEntity>,
        FutureOr<List<EventEntity>>>
    with
        $FutureModifier<List<EventEntity>>,
        $FutureProvider<List<EventEntity>> {
  MyEventsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myEventsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myEventsHash();

  @$internal
  @override
  $FutureProviderElement<List<EventEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventEntity>> create(Ref ref) {
    return myEvents(ref);
  }
}

String _$myEventsHash() => r'cf0abb237ac4a0cf75daa0da87e061f7acaaec5d';

@ProviderFor(myTickets)
final myTicketsProvider = MyTicketsProvider._();

final class MyTicketsProvider extends $FunctionalProvider<
        AsyncValue<List<EventRegistrationEntity>>,
        List<EventRegistrationEntity>,
        FutureOr<List<EventRegistrationEntity>>>
    with
        $FutureModifier<List<EventRegistrationEntity>>,
        $FutureProvider<List<EventRegistrationEntity>> {
  MyTicketsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myTicketsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myTicketsHash();

  @$internal
  @override
  $FutureProviderElement<List<EventRegistrationEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventRegistrationEntity>> create(Ref ref) {
    return myTickets(ref);
  }
}

String _$myTicketsHash() => r'f6020ab8b070a2dded82ad62b7e6f93f6a113ff8';

@ProviderFor(eventParticipants)
final eventParticipantsProvider = EventParticipantsFamily._();

final class EventParticipantsProvider extends $FunctionalProvider<
        AsyncValue<List<EventRegistrationEntity>>,
        List<EventRegistrationEntity>,
        FutureOr<List<EventRegistrationEntity>>>
    with
        $FutureModifier<List<EventRegistrationEntity>>,
        $FutureProvider<List<EventRegistrationEntity>> {
  EventParticipantsProvider._(
      {required EventParticipantsFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'eventParticipantsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventParticipantsHash();

  @override
  String toString() {
    return r'eventParticipantsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<EventRegistrationEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventRegistrationEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return eventParticipants(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventParticipantsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventParticipantsHash() => r'b3f824d487a6b7d423131822052d4bd72019b92e';

final class EventParticipantsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<EventRegistrationEntity>>,
            String> {
  EventParticipantsFamily._()
      : super(
          retry: null,
          name: r'eventParticipantsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  EventParticipantsProvider call(
    String eventId,
  ) =>
      EventParticipantsProvider._(argument: eventId, from: this);

  @override
  String toString() => r'eventParticipantsProvider';
}
