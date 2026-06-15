// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_scoring_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(_groupRemoteDataSource)
final _groupRemoteDataSourceProvider = _GroupRemoteDataSourceProvider._();

final class _GroupRemoteDataSourceProvider extends $FunctionalProvider<
    GroupScoringRemoteDataSource,
    GroupScoringRemoteDataSource,
    GroupScoringRemoteDataSource> with $Provider<GroupScoringRemoteDataSource> {
  _GroupRemoteDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_groupRemoteDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_groupRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<GroupScoringRemoteDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GroupScoringRemoteDataSource create(Ref ref) {
    return _groupRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupScoringRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupScoringRemoteDataSource>(value),
    );
  }
}

String _$_groupRemoteDataSourceHash() =>
    r'54f61d6767f45265ea4738904f2fc9442c69fb66';

@ProviderFor(_groupLocalDataSource)
final _groupLocalDataSourceProvider = _GroupLocalDataSourceProvider._();

final class _GroupLocalDataSourceProvider extends $FunctionalProvider<
    GroupScoringLocalDataSource,
    GroupScoringLocalDataSource,
    GroupScoringLocalDataSource> with $Provider<GroupScoringLocalDataSource> {
  _GroupLocalDataSourceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'_groupLocalDataSourceProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$_groupLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<GroupScoringLocalDataSource> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GroupScoringLocalDataSource create(Ref ref) {
    return _groupLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupScoringLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupScoringLocalDataSource>(value),
    );
  }
}

String _$_groupLocalDataSourceHash() =>
    r'd4fa54041b93d5a2a968fac4d7aa16dcd9dccd30';

@ProviderFor(groupScoringRepository)
final groupScoringRepositoryProvider = GroupScoringRepositoryProvider._();

final class GroupScoringRepositoryProvider extends $FunctionalProvider<
    GroupScoringRepository,
    GroupScoringRepository,
    GroupScoringRepository> with $Provider<GroupScoringRepository> {
  GroupScoringRepositoryProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'groupScoringRepositoryProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$groupScoringRepositoryHash();

  @$internal
  @override
  $ProviderElement<GroupScoringRepository> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GroupScoringRepository create(Ref ref) {
    return groupScoringRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroupScoringRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroupScoringRepository>(value),
    );
  }
}

String _$groupScoringRepositoryHash() =>
    r'71d86ff317bc298b31d2128983d94efdb29fcda4';

/// Groups the user hosts or participates in (local-first, refreshed online).

@ProviderFor(groupsList)
final groupsListProvider = GroupsListProvider._();

/// Groups the user hosts or participates in (local-first, refreshed online).

final class GroupsListProvider extends $FunctionalProvider<
        AsyncValue<List<ScoringGroupEntity>>,
        List<ScoringGroupEntity>,
        FutureOr<List<ScoringGroupEntity>>>
    with
        $FutureModifier<List<ScoringGroupEntity>>,
        $FutureProvider<List<ScoringGroupEntity>> {
  /// Groups the user hosts or participates in (local-first, refreshed online).
  GroupsListProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'groupsListProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$groupsListHash();

  @$internal
  @override
  $FutureProviderElement<List<ScoringGroupEntity>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ScoringGroupEntity>> create(Ref ref) {
    return groupsList(ref);
  }
}

String _$groupsListHash() => r'e5a01284494bb70ad914154e3802a55a8908a7ab';

/// A single group with its roster (local-first, refreshed online).

@ProviderFor(groupDetail)
final groupDetailProvider = GroupDetailFamily._();

/// A single group with its roster (local-first, refreshed online).

final class GroupDetailProvider extends $FunctionalProvider<
        AsyncValue<ScoringGroupEntity?>,
        ScoringGroupEntity?,
        FutureOr<ScoringGroupEntity?>>
    with
        $FutureModifier<ScoringGroupEntity?>,
        $FutureProvider<ScoringGroupEntity?> {
  /// A single group with its roster (local-first, refreshed online).
  GroupDetailProvider._(
      {required GroupDetailFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'groupDetailProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$groupDetailHash();

  @override
  String toString() {
    return r'groupDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ScoringGroupEntity?> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ScoringGroupEntity?> create(Ref ref) {
    final argument = this.argument as String;
    return groupDetail(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GroupDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groupDetailHash() => r'8b49abe78f6ffab5851e9834b2fa6104842f1317';

/// A single group with its roster (local-first, refreshed online).

final class GroupDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ScoringGroupEntity?>, String> {
  GroupDetailFamily._()
      : super(
          retry: null,
          name: r'groupDetailProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// A single group with its roster (local-first, refreshed online).

  GroupDetailProvider call(
    String groupId,
  ) =>
      GroupDetailProvider._(argument: groupId, from: this);

  @override
  String toString() => r'groupDetailProvider';
}

/// Preview a group by its join code before joining (online-only lookup, full
/// round format — Sprint 09, tasks 9.2/9.6). Every entry point (deep link, QR,
/// typed code) funnels through this so the join preview is identical.

@ProviderFor(joinPreview)
final joinPreviewProvider = JoinPreviewFamily._();

/// Preview a group by its join code before joining (online-only lookup, full
/// round format — Sprint 09, tasks 9.2/9.6). Every entry point (deep link, QR,
/// typed code) funnels through this so the join preview is identical.

final class JoinPreviewProvider extends $FunctionalProvider<
        AsyncValue<ScoringGroupEntity>,
        ScoringGroupEntity,
        FutureOr<ScoringGroupEntity>>
    with
        $FutureModifier<ScoringGroupEntity>,
        $FutureProvider<ScoringGroupEntity> {
  /// Preview a group by its join code before joining (online-only lookup, full
  /// round format — Sprint 09, tasks 9.2/9.6). Every entry point (deep link, QR,
  /// typed code) funnels through this so the join preview is identical.
  JoinPreviewProvider._(
      {required JoinPreviewFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'joinPreviewProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$joinPreviewHash();

  @override
  String toString() {
    return r'joinPreviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ScoringGroupEntity> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ScoringGroupEntity> create(Ref ref) {
    final argument = this.argument as String;
    return joinPreview(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is JoinPreviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$joinPreviewHash() => r'12bbea9f7d822f1aa355678d4e708b0bcfd56170';

/// Preview a group by its join code before joining (online-only lookup, full
/// round format — Sprint 09, tasks 9.2/9.6). Every entry point (deep link, QR,
/// typed code) funnels through this so the join preview is identical.

final class JoinPreviewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ScoringGroupEntity>, String> {
  JoinPreviewFamily._()
      : super(
          retry: null,
          name: r'joinPreviewProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Preview a group by its join code before joining (online-only lookup, full
  /// round format — Sprint 09, tasks 9.2/9.6). Every entry point (deep link, QR,
  /// typed code) funnels through this so the join preview is identical.

  JoinPreviewProvider call(
    String joinCode,
  ) =>
      JoinPreviewProvider._(argument: joinCode, from: this);

  @override
  String toString() => r'joinPreviewProvider';
}

/// Persists a pending join code across an unauthenticated gap so a deferred deep
/// link resumes after register/login (Sprint 09, task 9.4).

@ProviderFor(pendingJoinStore)
final pendingJoinStoreProvider = PendingJoinStoreProvider._();

/// Persists a pending join code across an unauthenticated gap so a deferred deep
/// link resumes after register/login (Sprint 09, task 9.4).

final class PendingJoinStoreProvider extends $FunctionalProvider<
    PendingJoinStore,
    PendingJoinStore,
    PendingJoinStore> with $Provider<PendingJoinStore> {
  /// Persists a pending join code across an unauthenticated gap so a deferred deep
  /// link resumes after register/login (Sprint 09, task 9.4).
  PendingJoinStoreProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'pendingJoinStoreProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$pendingJoinStoreHash();

  @$internal
  @override
  $ProviderElement<PendingJoinStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PendingJoinStore create(Ref ref) {
    return pendingJoinStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PendingJoinStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PendingJoinStore>(value),
    );
  }
}

String _$pendingJoinStoreHash() => r'abbeb5a314cb9e6759b42e3c0d7908cf1ecf24e9';

/// Guest slots of a group a code-holder may claim (task 14.1). Online-only —
/// the deep-link landing needs the live truth; each slot carries this user's own
/// claim status so the badge ("Menunggu persetujuan host") needs no extra call.

@ProviderFor(claimableSlots)
final claimableSlotsProvider = ClaimableSlotsFamily._();

/// Guest slots of a group a code-holder may claim (task 14.1). Online-only —
/// the deep-link landing needs the live truth; each slot carries this user's own
/// claim status so the badge ("Menunggu persetujuan host") needs no extra call.

final class ClaimableSlotsProvider extends $FunctionalProvider<
        AsyncValue<List<ClaimableSlot>>,
        List<ClaimableSlot>,
        FutureOr<List<ClaimableSlot>>>
    with
        $FutureModifier<List<ClaimableSlot>>,
        $FutureProvider<List<ClaimableSlot>> {
  /// Guest slots of a group a code-holder may claim (task 14.1). Online-only —
  /// the deep-link landing needs the live truth; each slot carries this user's own
  /// claim status so the badge ("Menunggu persetujuan host") needs no extra call.
  ClaimableSlotsProvider._(
      {required ClaimableSlotsFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'claimableSlotsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$claimableSlotsHash();

  @override
  String toString() {
    return r'claimableSlotsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ClaimableSlot>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<ClaimableSlot>> create(Ref ref) {
    final argument = this.argument as String;
    return claimableSlots(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ClaimableSlotsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$claimableSlotsHash() => r'eb0a29df8410379ef787d9ef57680d4b86295bd8';

/// Guest slots of a group a code-holder may claim (task 14.1). Online-only —
/// the deep-link landing needs the live truth; each slot carries this user's own
/// claim status so the badge ("Menunggu persetujuan host") needs no extra call.

final class ClaimableSlotsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ClaimableSlot>>, String> {
  ClaimableSlotsFamily._()
      : super(
          retry: null,
          name: r'claimableSlotsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Guest slots of a group a code-holder may claim (task 14.1). Online-only —
  /// the deep-link landing needs the live truth; each slot carries this user's own
  /// claim status so the badge ("Menunggu persetujuan host") needs no extra call.

  ClaimableSlotsProvider call(
    String groupId,
  ) =>
      ClaimableSlotsProvider._(argument: groupId, from: this);

  @override
  String toString() => r'claimableSlotsProvider';
}

/// The host inbox of claims to review for a group (task 14.3).

@ProviderFor(hostClaims)
final hostClaimsProvider = HostClaimsFamily._();

/// The host inbox of claims to review for a group (task 14.3).

final class HostClaimsProvider extends $FunctionalProvider<
        AsyncValue<List<HostClaim>>, List<HostClaim>, FutureOr<List<HostClaim>>>
    with $FutureModifier<List<HostClaim>>, $FutureProvider<List<HostClaim>> {
  /// The host inbox of claims to review for a group (task 14.3).
  HostClaimsProvider._(
      {required HostClaimsFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'hostClaimsProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$hostClaimsHash();

  @override
  String toString() {
    return r'hostClaimsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HostClaim>> $createElement(
          $ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<HostClaim>> create(Ref ref) {
    final argument = this.argument as String;
    return hostClaims(
      ref,
      argument,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HostClaimsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hostClaimsHash() => r'3e6c870ad4e2a35269f0c38fbee361be9acfc7ee';

/// The host inbox of claims to review for a group (task 14.3).

final class HostClaimsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HostClaim>>, String> {
  HostClaimsFamily._()
      : super(
          retry: null,
          name: r'hostClaimsProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// The host inbox of claims to review for a group (task 14.3).

  HostClaimsProvider call(
    String groupId,
  ) =>
      HostClaimsProvider._(argument: groupId, from: this);

  @override
  String toString() => r'hostClaimsProvider';
}

/// Drives the host board (Sprint 05): loads the group + participants, adds
/// guests, and saves each round offline-first (the repository persists locally
/// then syncs in the background). The screen only ever talks to this notifier.

@ProviderFor(HostBoardController)
final hostBoardControllerProvider = HostBoardControllerFamily._();

/// Drives the host board (Sprint 05): loads the group + participants, adds
/// guests, and saves each round offline-first (the repository persists locally
/// then syncs in the background). The screen only ever talks to this notifier.
final class HostBoardControllerProvider
    extends $AsyncNotifierProvider<HostBoardController, HostBoardState> {
  /// Drives the host board (Sprint 05): loads the group + participants, adds
  /// guests, and saves each round offline-first (the repository persists locally
  /// then syncs in the background). The screen only ever talks to this notifier.
  HostBoardControllerProvider._(
      {required HostBoardControllerFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'hostBoardControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$hostBoardControllerHash();

  @override
  String toString() {
    return r'hostBoardControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HostBoardController create() => HostBoardController();

  @override
  bool operator ==(Object other) {
    return other is HostBoardControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hostBoardControllerHash() =>
    r'3c93ad6a98cd3a8d075936f4b142600398586fbc';

/// Drives the host board (Sprint 05): loads the group + participants, adds
/// guests, and saves each round offline-first (the repository persists locally
/// then syncs in the background). The screen only ever talks to this notifier.

final class HostBoardControllerFamily extends $Family
    with
        $ClassFamilyOverride<HostBoardController, AsyncValue<HostBoardState>,
            HostBoardState, FutureOr<HostBoardState>, String> {
  HostBoardControllerFamily._()
      : super(
          retry: null,
          name: r'hostBoardControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Drives the host board (Sprint 05): loads the group + participants, adds
  /// guests, and saves each round offline-first (the repository persists locally
  /// then syncs in the background). The screen only ever talks to this notifier.

  HostBoardControllerProvider call(
    String groupId,
  ) =>
      HostBoardControllerProvider._(argument: groupId, from: this);

  @override
  String toString() => r'hostBoardControllerProvider';
}

/// Drives the host board (Sprint 05): loads the group + participants, adds
/// guests, and saves each round offline-first (the repository persists locally
/// then syncs in the background). The screen only ever talks to this notifier.

abstract class _$HostBoardController extends $AsyncNotifier<HostBoardState> {
  late final _$args = ref.$arg as String;
  String get groupId => _$args;

  FutureOr<HostBoardState> build(
    String groupId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HostBoardState>, HostBoardState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<HostBoardState>, HostBoardState>,
        AsyncValue<HostBoardState>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}

/// Lifecycle-aware live leaderboard poller (Sprint 11, tasks 11.1/11.2).
///
/// It polls the server leaderboard every [pollInterval] **only while** the live
/// screen is mounted (the provider auto-disposes on pop) and the session is
/// `in_progress`; it stops the moment the group is finished/abandoned (even by
/// another device) or the app is backgrounded (task 11.2). Each poll re-sends
/// the last [version] so the server can short-circuit to an empty payload when
/// nothing changed — no battery/bandwidth drain when idle (DoD). A failed poll
/// is non-fatal: the screen falls back to the offline local board and the poll
/// keeps retrying until signal returns.

@ProviderFor(LiveLeaderboardController)
final liveLeaderboardControllerProvider = LiveLeaderboardControllerFamily._();

/// Lifecycle-aware live leaderboard poller (Sprint 11, tasks 11.1/11.2).
///
/// It polls the server leaderboard every [pollInterval] **only while** the live
/// screen is mounted (the provider auto-disposes on pop) and the session is
/// `in_progress`; it stops the moment the group is finished/abandoned (even by
/// another device) or the app is backgrounded (task 11.2). Each poll re-sends
/// the last [version] so the server can short-circuit to an empty payload when
/// nothing changed — no battery/bandwidth drain when idle (DoD). A failed poll
/// is non-fatal: the screen falls back to the offline local board and the poll
/// keeps retrying until signal returns.
final class LiveLeaderboardControllerProvider extends $AsyncNotifierProvider<
    LiveLeaderboardController, LiveLeaderboardState> {
  /// Lifecycle-aware live leaderboard poller (Sprint 11, tasks 11.1/11.2).
  ///
  /// It polls the server leaderboard every [pollInterval] **only while** the live
  /// screen is mounted (the provider auto-disposes on pop) and the session is
  /// `in_progress`; it stops the moment the group is finished/abandoned (even by
  /// another device) or the app is backgrounded (task 11.2). Each poll re-sends
  /// the last [version] so the server can short-circuit to an empty payload when
  /// nothing changed — no battery/bandwidth drain when idle (DoD). A failed poll
  /// is non-fatal: the screen falls back to the offline local board and the poll
  /// keeps retrying until signal returns.
  LiveLeaderboardControllerProvider._(
      {required LiveLeaderboardControllerFamily super.from,
      required String super.argument})
      : super(
          retry: null,
          name: r'liveLeaderboardControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$liveLeaderboardControllerHash();

  @override
  String toString() {
    return r'liveLeaderboardControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LiveLeaderboardController create() => LiveLeaderboardController();

  @override
  bool operator ==(Object other) {
    return other is LiveLeaderboardControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$liveLeaderboardControllerHash() =>
    r'24b0136f51d7b47a65adaff5e04a2705052cee0b';

/// Lifecycle-aware live leaderboard poller (Sprint 11, tasks 11.1/11.2).
///
/// It polls the server leaderboard every [pollInterval] **only while** the live
/// screen is mounted (the provider auto-disposes on pop) and the session is
/// `in_progress`; it stops the moment the group is finished/abandoned (even by
/// another device) or the app is backgrounded (task 11.2). Each poll re-sends
/// the last [version] so the server can short-circuit to an empty payload when
/// nothing changed — no battery/bandwidth drain when idle (DoD). A failed poll
/// is non-fatal: the screen falls back to the offline local board and the poll
/// keeps retrying until signal returns.

final class LiveLeaderboardControllerFamily extends $Family
    with
        $ClassFamilyOverride<
            LiveLeaderboardController,
            AsyncValue<LiveLeaderboardState>,
            LiveLeaderboardState,
            FutureOr<LiveLeaderboardState>,
            String> {
  LiveLeaderboardControllerFamily._()
      : super(
          retry: null,
          name: r'liveLeaderboardControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Lifecycle-aware live leaderboard poller (Sprint 11, tasks 11.1/11.2).
  ///
  /// It polls the server leaderboard every [pollInterval] **only while** the live
  /// screen is mounted (the provider auto-disposes on pop) and the session is
  /// `in_progress`; it stops the moment the group is finished/abandoned (even by
  /// another device) or the app is backgrounded (task 11.2). Each poll re-sends
  /// the last [version] so the server can short-circuit to an empty payload when
  /// nothing changed — no battery/bandwidth drain when idle (DoD). A failed poll
  /// is non-fatal: the screen falls back to the offline local board and the poll
  /// keeps retrying until signal returns.

  LiveLeaderboardControllerProvider call(
    String groupId,
  ) =>
      LiveLeaderboardControllerProvider._(argument: groupId, from: this);

  @override
  String toString() => r'liveLeaderboardControllerProvider';
}

/// Lifecycle-aware live leaderboard poller (Sprint 11, tasks 11.1/11.2).
///
/// It polls the server leaderboard every [pollInterval] **only while** the live
/// screen is mounted (the provider auto-disposes on pop) and the session is
/// `in_progress`; it stops the moment the group is finished/abandoned (even by
/// another device) or the app is backgrounded (task 11.2). Each poll re-sends
/// the last [version] so the server can short-circuit to an empty payload when
/// nothing changed — no battery/bandwidth drain when idle (DoD). A failed poll
/// is non-fatal: the screen falls back to the offline local board and the poll
/// keeps retrying until signal returns.

abstract class _$LiveLeaderboardController
    extends $AsyncNotifier<LiveLeaderboardState> {
  late final _$args = ref.$arg as String;
  String get groupId => _$args;

  FutureOr<LiveLeaderboardState> build(
    String groupId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref
        as $Ref<AsyncValue<LiveLeaderboardState>, LiveLeaderboardState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<LiveLeaderboardState>, LiveLeaderboardState>,
        AsyncValue<LiveLeaderboardState>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
