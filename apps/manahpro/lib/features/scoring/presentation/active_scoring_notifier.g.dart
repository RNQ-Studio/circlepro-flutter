// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_scoring_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages an in-progress scoring session. Every arrow tap persists to local
/// Drift immediately (offline-first), so progress survives a crash/restart.

@ProviderFor(ActiveScoring)
final activeScoringProvider = ActiveScoringFamily._();

/// Manages an in-progress scoring session. Every arrow tap persists to local
/// Drift immediately (offline-first), so progress survives a crash/restart.
final class ActiveScoringProvider
    extends $AsyncNotifierProvider<ActiveScoring, ActiveScoringState> {
  /// Manages an in-progress scoring session. Every arrow tap persists to local
  /// Drift immediately (offline-first), so progress survives a crash/restart.
  ActiveScoringProvider._(
      {required ActiveScoringFamily super.from, required String super.argument})
      : super(
          retry: null,
          name: r'activeScoringProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$activeScoringHash();

  @override
  String toString() {
    return r'activeScoringProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ActiveScoring create() => ActiveScoring();

  @override
  bool operator ==(Object other) {
    return other is ActiveScoringProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeScoringHash() => r'bcd1d9f5a993d74e8b69904a35ed6220ff9310e0';

/// Manages an in-progress scoring session. Every arrow tap persists to local
/// Drift immediately (offline-first), so progress survives a crash/restart.

final class ActiveScoringFamily extends $Family
    with
        $ClassFamilyOverride<ActiveScoring, AsyncValue<ActiveScoringState>,
            ActiveScoringState, FutureOr<ActiveScoringState>, String> {
  ActiveScoringFamily._()
      : super(
          retry: null,
          name: r'activeScoringProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  /// Manages an in-progress scoring session. Every arrow tap persists to local
  /// Drift immediately (offline-first), so progress survives a crash/restart.

  ActiveScoringProvider call(
    String sessionId,
  ) =>
      ActiveScoringProvider._(argument: sessionId, from: this);

  @override
  String toString() => r'activeScoringProvider';
}

/// Manages an in-progress scoring session. Every arrow tap persists to local
/// Drift immediately (offline-first), so progress survives a crash/restart.

abstract class _$ActiveScoring extends $AsyncNotifier<ActiveScoringState> {
  late final _$args = ref.$arg as String;
  String get sessionId => _$args;

  FutureOr<ActiveScoringState> build(
    String sessionId,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ActiveScoringState>, ActiveScoringState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<ActiveScoringState>, ActiveScoringState>,
        AsyncValue<ActiveScoringState>,
        Object?,
        Object?>;
    element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
