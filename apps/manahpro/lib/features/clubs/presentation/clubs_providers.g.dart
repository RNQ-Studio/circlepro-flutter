// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clubs_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clubsRepository)
final clubsRepositoryProvider = ClubsRepositoryProvider._();

final class ClubsRepositoryProvider extends $FunctionalProvider<ClubsRepository,
    ClubsRepository, ClubsRepository> with $Provider<ClubsRepository> {
  ClubsRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'clubsRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ClubsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ClubsRepository create(Ref ref) {
    return clubsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClubsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClubsRepository>(value),
    );
  }
}

String _$clubsRepositoryHash() => r'6ed192af4a6926f0f109185872884d74de523399';

/// Club directory (optionally filtered by [search]).

@ProviderFor(clubDirectory)
final clubDirectoryProvider = ClubDirectoryFamily._();

/// Club directory (optionally filtered by [search]).

final class ClubDirectoryProvider extends $FunctionalProvider<
        AsyncValue<List<ClubEntity>>,
        List<ClubEntity>,
        FutureOr<List<ClubEntity>>>
    with $FutureModifier<List<ClubEntity>>, $FutureProvider<List<ClubEntity>> {
  /// Club directory (optionally filtered by [search]).
  ClubDirectoryProvider._(
      {required ClubDirectoryFamily super.from,
      required String? super.argument})
      : super(
          retry: null,
          name: r'clubDirectoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubDirectoryHash();

  @override
  String toString() {
    return r'clubDirectoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClubEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubEntity>> create(Ref ref) {
    final argument = this.argument as String?;
    return clubDirectory(
      ref,
      search: argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClubDirectoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clubDirectoryHash() => r'a326e96cc841b159d4b7acaadce5572d79a5f54e';

/// Club directory (optionally filtered by [search]).

final class ClubDirectoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ClubEntity>>, String?> {
  ClubDirectoryFamily._()
      : super(
          retry: null,
          name: r'clubDirectoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Club directory (optionally filtered by [search]).

  ClubDirectoryProvider call({
    String? search,
  }) =>
      ClubDirectoryProvider._(argument: search, from: this);

  @override
  String toString() => r'clubDirectoryProvider';
}

/// Clubs the user belongs to.

@ProviderFor(myClubs)
final myClubsProvider = MyClubsProvider._();

/// Clubs the user belongs to.

final class MyClubsProvider extends $FunctionalProvider<
        AsyncValue<List<ClubEntity>>,
        List<ClubEntity>,
        FutureOr<List<ClubEntity>>>
    with $FutureModifier<List<ClubEntity>>, $FutureProvider<List<ClubEntity>> {
  /// Clubs the user belongs to.
  MyClubsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'myClubsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myClubsHash();

  @$internal
  @override
  $FutureProviderElement<List<ClubEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubEntity>> create(Ref ref) {
    return myClubs(ref);
  }
}

String _$myClubsHash() => r'aa1ab4befb4136f86e220834aa6ed3c5ea5d139f';

/// A single club's detail.

@ProviderFor(clubDetail)
final clubDetailProvider = ClubDetailFamily._();

/// A single club's detail.

final class ClubDetailProvider extends $FunctionalProvider<
        AsyncValue<ClubEntity>, ClubEntity, FutureOr<ClubEntity>>
    with $FutureModifier<ClubEntity>, $FutureProvider<ClubEntity> {
  /// A single club's detail.
  ClubDetailProvider._(
      {required ClubDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'clubDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubDetailHash();

  @override
  String toString() {
    return r'clubDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ClubEntity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ClubEntity> create(Ref ref) {
    final argument = this.argument as String;
    return clubDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClubDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clubDetailHash() => r'62b71d24790c3272ed2ebf0c34662d04ee8711f8';

/// A single club's detail.

final class ClubDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ClubEntity>, String> {
  ClubDetailFamily._()
      : super(
          retry: null,
          name: r'clubDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A single club's detail.

  ClubDetailProvider call(
    String clubId,
  ) =>
      ClubDetailProvider._(argument: clubId, from: this);

  @override
  String toString() => r'clubDetailProvider';
}

/// A club's member list.

@ProviderFor(clubMembers)
final clubMembersProvider = ClubMembersFamily._();

/// A club's member list.

final class ClubMembersProvider extends $FunctionalProvider<
        AsyncValue<List<ClubMemberEntity>>,
        List<ClubMemberEntity>,
        FutureOr<List<ClubMemberEntity>>>
    with
        $FutureModifier<List<ClubMemberEntity>>,
        $FutureProvider<List<ClubMemberEntity>> {
  /// A club's member list.
  ClubMembersProvider._(
      {required ClubMembersFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'clubMembersProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubMembersHash();

  @override
  String toString() {
    return r'clubMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClubMemberEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubMemberEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return clubMembers(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClubMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clubMembersHash() => r'34c72701b5f3502a97fcf9e338f3a793e4aa35c8';

/// A club's member list.

final class ClubMembersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ClubMemberEntity>>, String> {
  ClubMembersFamily._()
      : super(
          retry: null,
          name: r'clubMembersProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A club's member list.

  ClubMembersProvider call(
    String clubId,
  ) =>
      ClubMembersProvider._(argument: clubId, from: this);

  @override
  String toString() => r'clubMembersProvider';
}

/// List of schedules for a club.

@ProviderFor(clubSchedules)
final clubSchedulesProvider = ClubSchedulesFamily._();

/// List of schedules for a club.

final class ClubSchedulesProvider extends $FunctionalProvider<
        AsyncValue<List<ClubScheduleEntity>>,
        List<ClubScheduleEntity>,
        FutureOr<List<ClubScheduleEntity>>>
    with
        $FutureModifier<List<ClubScheduleEntity>>,
        $FutureProvider<List<ClubScheduleEntity>> {
  /// List of schedules for a club.
  ClubSchedulesProvider._(
      {required ClubSchedulesFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'clubSchedulesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$clubSchedulesHash();

  @override
  String toString() {
    return r'clubSchedulesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClubScheduleEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubScheduleEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return clubSchedules(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClubSchedulesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$clubSchedulesHash() => r'5647004087f4bb7cb78d7cdf46ec3ce05c43ebe3';

/// List of schedules for a club.

final class ClubSchedulesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ClubScheduleEntity>>, String> {
  ClubSchedulesFamily._()
      : super(
          retry: null,
          name: r'clubSchedulesProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// List of schedules for a club.

  ClubSchedulesProvider call(
    String clubId,
  ) =>
      ClubSchedulesProvider._(argument: clubId, from: this);

  @override
  String toString() => r'clubSchedulesProvider';
}

/// Attendance sheet for a specific club schedule.

@ProviderFor(scheduleAttendance)
final scheduleAttendanceProvider = ScheduleAttendanceFamily._();

/// Attendance sheet for a specific club schedule.

final class ScheduleAttendanceProvider extends $FunctionalProvider<
        AsyncValue<List<ClubAttendanceEntity>>,
        List<ClubAttendanceEntity>,
        FutureOr<List<ClubAttendanceEntity>>>
    with
        $FutureModifier<List<ClubAttendanceEntity>>,
        $FutureProvider<List<ClubAttendanceEntity>> {
  /// Attendance sheet for a specific club schedule.
  ScheduleAttendanceProvider._(
      {required ScheduleAttendanceFamily super.from,
      required (
        String,
        String,
      )
          super.argument})
      : super(
          retry: null,
          name: r'scheduleAttendanceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$scheduleAttendanceHash();

  @override
  String toString() {
    return r'scheduleAttendanceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClubAttendanceEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubAttendanceEntity>> create(Ref ref) {
    final argument = this.argument as (
      String,
      String,
    );
    return scheduleAttendance(
      ref,
      argument.$1,
      argument.$2,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ScheduleAttendanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$scheduleAttendanceHash() =>
    r'71948a60eed5e4670360ade1e1021830fb94d19c';

/// Attendance sheet for a specific club schedule.

final class ScheduleAttendanceFamily extends $Family
    with
        $FunctionalFamilyOverride<
            FutureOr<List<ClubAttendanceEntity>>,
            (
              String,
              String,
            )> {
  ScheduleAttendanceFamily._()
      : super(
          retry: null,
          name: r'scheduleAttendanceProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Attendance sheet for a specific club schedule.

  ScheduleAttendanceProvider call(
    String clubId,
    String scheduleId,
  ) =>
      ScheduleAttendanceProvider._(argument: (
        clubId,
        scheduleId,
      ), from: this);

  @override
  String toString() => r'scheduleAttendanceProvider';
}

/// Logged in user's attendance history in a club.

@ProviderFor(myAttendanceHistory)
final myAttendanceHistoryProvider = MyAttendanceHistoryFamily._();

/// Logged in user's attendance history in a club.

final class MyAttendanceHistoryProvider extends $FunctionalProvider<
        AsyncValue<List<ClubMyAttendanceHistoryEntity>>,
        List<ClubMyAttendanceHistoryEntity>,
        FutureOr<List<ClubMyAttendanceHistoryEntity>>>
    with
        $FutureModifier<List<ClubMyAttendanceHistoryEntity>>,
        $FutureProvider<List<ClubMyAttendanceHistoryEntity>> {
  /// Logged in user's attendance history in a club.
  MyAttendanceHistoryProvider._(
      {required MyAttendanceHistoryFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'myAttendanceHistoryProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$myAttendanceHistoryHash();

  @override
  String toString() {
    return r'myAttendanceHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClubMyAttendanceHistoryEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClubMyAttendanceHistoryEntity>> create(Ref ref) {
    final argument = this.argument as String;
    return myAttendanceHistory(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MyAttendanceHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myAttendanceHistoryHash() =>
    r'1e29f687ac58d82cadf10f930f41d05c203959ff';

/// Logged in user's attendance history in a club.

final class MyAttendanceHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<List<ClubMyAttendanceHistoryEntity>>,
            String> {
  MyAttendanceHistoryFamily._()
      : super(
          retry: null,
          name: r'myAttendanceHistoryProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Logged in user's attendance history in a club.

  MyAttendanceHistoryProvider call(
    String clubId,
  ) =>
      MyAttendanceHistoryProvider._(argument: clubId, from: this);

  @override
  String toString() => r'myAttendanceHistoryProvider';
}
