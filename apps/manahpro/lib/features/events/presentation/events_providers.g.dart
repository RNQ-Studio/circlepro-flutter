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

@ProviderFor(targetScorecard)
final targetScorecardProvider = TargetScorecardFamily._();

final class TargetScorecardProvider extends $FunctionalProvider<
        AsyncValue<List<TargetScorecardItem>>,
        List<TargetScorecardItem>,
        FutureOr<List<TargetScorecardItem>>>
    with
        $FutureModifier<List<TargetScorecardItem>>,
        $FutureProvider<List<TargetScorecardItem>> {
  TargetScorecardProvider._(
      {required TargetScorecardFamily super.from,
      required ({
        String eventId,
        String divisionId,
        int targetButt,
      })
          super.argument})
      : super(
          retry: null,
          name: r'targetScorecardProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$targetScorecardHash();

  @override
  String toString() {
    return r'targetScorecardProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TargetScorecardItem>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<TargetScorecardItem>> create(Ref ref) {
    final argument = this.argument as ({
      String eventId,
      String divisionId,
      int targetButt,
    });
    return targetScorecard(
      ref,
      eventId: argument.eventId,
      divisionId: argument.divisionId,
      targetButt: argument.targetButt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TargetScorecardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$targetScorecardHash() => r'07d3b8804e121c75158e38b695cad8a253440cb2';

final class TargetScorecardFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<TargetScorecardItem>>,
            ({
              String eventId,
              String divisionId,
              int targetButt,
            })> {
  TargetScorecardFamily._()
      : super(
          retry: null,
          name: r'targetScorecardProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  TargetScorecardProvider call({
    required String eventId,
    required String divisionId,
    required int targetButt,
  }) =>
      TargetScorecardProvider._(argument: (
        eventId: eventId,
        divisionId: divisionId,
        targetButt: targetButt,
      ), from: this);

  @override
  String toString() => r'targetScorecardProvider';
}

@ProviderFor(eventLeaderboard)
final eventLeaderboardProvider = EventLeaderboardFamily._();

final class EventLeaderboardProvider extends $FunctionalProvider<
        AsyncValue<List<EventLeaderboardEntry>>,
        List<EventLeaderboardEntry>,
        FutureOr<List<EventLeaderboardEntry>>>
    with
        $FutureModifier<List<EventLeaderboardEntry>>,
        $FutureProvider<List<EventLeaderboardEntry>> {
  EventLeaderboardProvider._(
      {required EventLeaderboardFamily super.from,
      required ({
        String eventId,
        String divisionId,
      })
          super.argument})
      : super(
          retry: null,
          name: r'eventLeaderboardProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$eventLeaderboardHash();

  @override
  String toString() {
    return r'eventLeaderboardProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<EventLeaderboardEntry>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<EventLeaderboardEntry>> create(Ref ref) {
    final argument = this.argument as ({
      String eventId,
      String divisionId,
    });
    return eventLeaderboard(
      ref,
      eventId: argument.eventId,
      divisionId: argument.divisionId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EventLeaderboardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$eventLeaderboardHash() => r'7e2ff19acb05d28e8889e733cdd4ec798821dfc1';

final class EventLeaderboardFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<EventLeaderboardEntry>>,
            ({
              String eventId,
              String divisionId,
            })> {
  EventLeaderboardFamily._()
      : super(
          retry: null,
          name: r'eventLeaderboardProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  EventLeaderboardProvider call({
    required String eventId,
    required String divisionId,
  }) =>
      EventLeaderboardProvider._(argument: (
        eventId: eventId,
        divisionId: divisionId,
      ), from: this);

  @override
  String toString() => r'eventLeaderboardProvider';
}

@ProviderFor(NationalLeaderboardFiltersState)
final nationalLeaderboardFiltersStateProvider =
    NationalLeaderboardFiltersStateProvider._();

final class NationalLeaderboardFiltersStateProvider extends $NotifierProvider<
    NationalLeaderboardFiltersState, NationalLeaderboardFilters> {
  NationalLeaderboardFiltersStateProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'nationalLeaderboardFiltersStateProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$nationalLeaderboardFiltersStateHash();

  @$internal
  @override
  NationalLeaderboardFiltersState create() => NationalLeaderboardFiltersState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NationalLeaderboardFilters value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NationalLeaderboardFilters>(value),
    );
  }
}

String _$nationalLeaderboardFiltersStateHash() =>
    r'db8e25225d2458559c04982abc37e8182e0055a1';

abstract class _$NationalLeaderboardFiltersState
    extends $Notifier<NationalLeaderboardFilters> {
  NationalLeaderboardFilters build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<NationalLeaderboardFilters, NationalLeaderboardFilters>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NationalLeaderboardFilters, NationalLeaderboardFilters>,
        NationalLeaderboardFilters,
        Object?,
        Object?>;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(nationalLeaderboard)
final nationalLeaderboardProvider = NationalLeaderboardProvider._();

final class NationalLeaderboardProvider extends $FunctionalProvider<
        AsyncValue<List<UserRatingEntity>>,
        List<UserRatingEntity>,
        FutureOr<List<UserRatingEntity>>>
    with
        $FutureModifier<List<UserRatingEntity>>,
        $FutureProvider<List<UserRatingEntity>> {
  NationalLeaderboardProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'nationalLeaderboardProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$nationalLeaderboardHash();

  @$internal
  @override
  $FutureProviderElement<List<UserRatingEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserRatingEntity>> create(Ref ref) {
    return nationalLeaderboard(ref);
  }
}

String _$nationalLeaderboardHash() =>
    r'819665b627ac029e73d90ec12dfa9db7b2112e70';

@ProviderFor(userRatings)
final userRatingsProvider = UserRatingsFamily._();

final class UserRatingsProvider extends $FunctionalProvider<
        AsyncValue<List<UserRatingEntity>>,
        List<UserRatingEntity>,
        FutureOr<List<UserRatingEntity>>>
    with
        $FutureModifier<List<UserRatingEntity>>,
        $FutureProvider<List<UserRatingEntity>> {
  UserRatingsProvider._(
      {required UserRatingsFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'userRatingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$userRatingsHash();

  @override
  String toString() {
    return r'userRatingsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<UserRatingEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserRatingEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return userRatings(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserRatingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userRatingsHash() => r'fa2e0fae9fe986d4079a001cb172053375374c3e';

final class UserRatingsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<UserRatingEntity>>, String> {
  UserRatingsFamily._()
      : super(
          retry: null,
          name: r'userRatingsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  UserRatingsProvider call(
    String userId,
  ) =>
      UserRatingsProvider._(argument: userId, from: this);

  @override
  String toString() => r'userRatingsProvider';
}

@ProviderFor(ratingHistory)
final ratingHistoryProvider = RatingHistoryFamily._();

final class RatingHistoryProvider extends $FunctionalProvider<
        AsyncValue<List<RatingHistoryEntry>>,
        List<RatingHistoryEntry>,
        FutureOr<List<RatingHistoryEntry>>>
    with
        $FutureModifier<List<RatingHistoryEntry>>,
        $FutureProvider<List<RatingHistoryEntry>> {
  RatingHistoryProvider._(
      {required RatingHistoryFamily super.from,
      required ({
        String userId,
        String ratingId,
      })
          super.argument})
      : super(
          retry: null,
          name: r'ratingHistoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$ratingHistoryHash();

  @override
  String toString() {
    return r'ratingHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<RatingHistoryEntry>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<RatingHistoryEntry>> create(Ref ref) {
    final argument = this.argument as ({
      String userId,
      String ratingId,
    });
    return ratingHistory(
      ref,
      userId: argument.userId,
      ratingId: argument.ratingId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RatingHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ratingHistoryHash() => r'dbc5e2b2975f578e11a7b6408fa19100766a5685';

final class RatingHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<RatingHistoryEntry>>,
            ({
              String userId,
              String ratingId,
            })> {
  RatingHistoryFamily._()
      : super(
          retry: null,
          name: r'ratingHistoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  RatingHistoryProvider call({
    required String userId,
    required String ratingId,
  }) =>
      RatingHistoryProvider._(argument: (
        userId: userId,
        ratingId: ratingId,
      ), from: this);

  @override
  String toString() => r'ratingHistoryProvider';
}

@ProviderFor(myRatings)
final myRatingsProvider = MyRatingsProvider._();

final class MyRatingsProvider extends $FunctionalProvider<
        AsyncValue<List<UserRatingEntity>>,
        List<UserRatingEntity>,
        FutureOr<List<UserRatingEntity>>>
    with
        $FutureModifier<List<UserRatingEntity>>,
        $FutureProvider<List<UserRatingEntity>> {
  MyRatingsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myRatingsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myRatingsHash();

  @$internal
  @override
  $FutureProviderElement<List<UserRatingEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<UserRatingEntity>> create(Ref ref) {
    return myRatings(ref);
  }
}

String _$myRatingsHash() => r'41ba0bd4884c49d2b499c93c78657888c1bb2493';
