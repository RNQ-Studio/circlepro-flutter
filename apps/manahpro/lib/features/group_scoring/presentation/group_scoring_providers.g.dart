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
    r'a88810f8462b9df46a83cebc9c73fb119bd3e11d';

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
