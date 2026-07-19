import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:manahpro/features/monetization/domain/monetization_entities.dart';
import 'package:manahpro/features/monetization/presentation/monetization_providers.dart';
import 'package:manahpro/features/scoring/domain/equipment_profile_entity.dart';
import 'package:manahpro/features/scoring/domain/scoring_entities.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';
import 'package:manahpro/features/scoring/domain/scoring_repository.dart';
import 'package:manahpro/features/scoring/presentation/equipment_notifier.dart';
import 'package:manahpro/features/scoring/presentation/scoring_providers.dart';
import 'package:manahpro/features/scoring/presentation/scoring_routes.dart';
import 'package:manahpro/features/scoring/presentation/screens/scoring_setup_screen.dart';
import 'package:manahpro/theme/manah_theme.dart';

class FakeEquipmentList extends EquipmentList {
  @override
  Future<List<EquipmentProfileEntity>> build() async => const [];
}

class FakeUserSubscription extends UserSubscription {
  @override
  Future<UserSubscriptionStatus> build() async => const UserSubscriptionStatus(
        planCode: 'free',
        planName: 'Gratis',
        scoringSessionsThisWeek: 1,
        scoringSessionsLimit: 3,
        isGated: false,
      );
}

enum _TargetStreamMode { data, loading, error }

class FakeScoringRepository implements ScoringRepository {
  FakeScoringRepository({
    this.targets = const [_targetFace],
    this.targetStreamMode = _TargetStreamMode.data,
    this.failStart = false,
  });

  final List<TargetFaceEntity> targets;
  final _TargetStreamMode targetStreamMode;
  final bool failStart;

  int refreshCalls = 0;
  BowClass? startedBowClass;
  DistanceCategory? startedDistance;
  ArcheryEnvironment? startedEnvironment;
  int? startedNumEnds;
  int? startedArrowsPerEnd;
  int? startedSighterEndCount;
  String? startedTargetFaceId;

  @override
  Future<ScoringSessionEntity> startSession({
    required BowClass bowClass,
    required DistanceCategory distanceCategory,
    required int distanceM,
    required int numEnds,
    required int arrowsPerEnd,
    ArcheryEnvironment environment = ArcheryEnvironment.outdoor,
    int? targetFaceCm,
    String? targetFaceId,
    int? maxPossibleScoreOverride,
    String? equipmentProfileId,
    String? title,
    int sighterEndCount = 0,
  }) async {
    startedBowClass = bowClass;
    startedDistance = distanceCategory;
    startedEnvironment = environment;
    startedNumEnds = numEnds;
    startedArrowsPerEnd = arrowsPerEnd;
    startedSighterEndCount = sighterEndCount;
    startedTargetFaceId = targetFaceId;

    if (failStart) {
      throw StateError('local database write failed internally');
    }

    return ScoringSessionEntity(
      id: 'new-session',
      clientUuid: 'new-session-client',
      bowClass: bowClass,
      distanceCategory: distanceCategory,
      distanceM: distanceM,
      numEnds: numEnds,
      arrowsPerEnd: arrowsPerEnd,
      environment: environment,
      targetFaceCm: targetFaceCm,
      targetFaceId: targetFaceId,
      maxPossibleScoreOverride: maxPossibleScoreOverride,
      equipmentProfileId: equipmentProfileId,
      title: title,
      startedAt: DateTime(2026, 7, 19),
      ends: [
        for (var index = 0; index < numEnds; index++)
          ScoringEndEntity(
            id: 'end-$index',
            endNumber: index + 1,
            isSighter: index < sighterEndCount,
          ),
      ],
    );
  }

  @override
  Stream<List<TargetFaceEntity>> watchTargetFaces() {
    return switch (targetStreamMode) {
      _TargetStreamMode.data => Stream.value(targets),
      _TargetStreamMode.loading => Stream<List<TargetFaceEntity>>.multi((_) {}),
      _TargetStreamMode.error =>
        Stream.error(StateError('target API failed internally')),
    };
  }

  @override
  Future<void> refreshTargetFaces() async {
    refreshCalls++;
  }

  @override
  Future<void> deleteSession(String sessionId) => throw UnimplementedError();

  @override
  Future<ScoringSessionEntity> finishSession(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<ScoringSessionEntity?> getSession(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<List<ScoringSessionEntity>> getSessions() =>
      throw UnimplementedError();

  @override
  Future<ScoringSessionEntity> saveEnd({
    required String sessionId,
    required int endNumber,
    required List<ArrowScore> arrows,
  }) =>
      throw UnimplementedError();

  @override
  Future<void> sync() => throw UnimplementedError();
}

void main() {
  Widget buildSubject({
    required FakeScoringRepository repository,
    ThemeMode themeMode = ThemeMode.light,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    final router = GoRouter(
      initialLocation: ScoringRoutes.setup,
      routes: [
        GoRoute(
          path: ScoringRoutes.setup,
          builder: (_, __) => const ScoringSetupScreen(),
        ),
        GoRoute(
          path: ScoringRoutes.targetFaceSelection,
          builder: (context, _) => Scaffold(
            body: Center(
              child: FilledButton(
                key: const ValueKey('select-test-target'),
                onPressed: () => context.pop(_targetFace),
                child: const Text('Gunakan target test'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/scoring/session/:id',
          builder: (_, state) => Scaffold(
            body: Text('Input ${state.pathParameters['id']}'),
          ),
        ),
        GoRoute(
          path: '/monetization/paywall',
          builder: (_, __) => const Scaffold(body: Text('Paywall')),
        ),
      ],
    );
    addTearDown(router.dispose);

    return ProviderScope(
      overrides: [
        scoringRepositoryProvider.overrideWithValue(repository),
        equipmentListProvider.overrideWith(FakeEquipmentList.new),
        userSubscriptionProvider.overrideWith(FakeUserSubscription.new),
      ],
      child: MaterialApp.router(
        theme: ManahTheme.light,
        darkTheme: ManahTheme.dark,
        themeMode: themeMode,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child!,
        ),
        routerConfig: router,
      ),
    );
  }

  testWidgets('presents a focused session composer with live summary',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(repository: FakeScoringRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sesi baru'), findsOneWidget);
    expect(find.text('Siapkan sesi'), findsOneWidget);
    expect(find.text('Busur'), findsOneWidget);
    expect(find.text('Format latihan'), findsOneWidget);
    expect(find.text('Target'), findsOneWidget);
    expect(find.byKey(const ValueKey('session-live-summary')), findsOneWidget);
    expect(find.byKey(const ValueKey('start-scoring-button')), findsOneWidget);
    expect(find.text('Pilih target untuk mulai'), findsOneWidget);
  });

  testWidgets('applies a round preset from the bottom sheet', (tester) async {
    await tester.pumpWidget(
      buildSubject(repository: FakeScoringRepository()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('round-preset-field')));
    await tester.pumpAndSettle();
    expect(find.text('Pilih preset ronde'), findsOneWidget);

    await tester.tap(find.text('Latihan 30m'));
    await tester.pumpAndSettle();

    expect(find.text('30m · Recurve · Outdoor'), findsOneWidget);
    expect(find.text('30 panah dihitung · 6 percobaan'), findsOneWidget);
    expect(find.text('Latihan 30m'), findsOneWidget);
  });

  testWidgets('shows human target error and retries the local-first provider',
      (tester) async {
    final repository = FakeScoringRepository(
      targetStreamMode: _TargetStreamMode.error,
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Target belum bisa dimuat.'), findsOneWidget);
    expect(find.textContaining('target API failed'), findsNothing);
    final callsBeforeRetry = repository.refreshCalls;

    await tester.tap(find.text('Coba lagi'));
    await tester.pump();
    expect(repository.refreshCalls, greaterThan(callsBeforeRetry));
  });

  testWidgets('uses a target-shaped skeleton while local data is loading',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(
        repository: FakeScoringRepository(
          targetStreamMode: _TargetStreamMode.loading,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(
        find.byKey(const ValueKey('target-loading-skeleton')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('explains an empty target cache and offers refresh',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(repository: FakeScoringRepository(targets: const [])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada target tersimpan.'), findsOneWidget);
    expect(find.text('Muat target'), findsOneWidget);
  });

  testWidgets('creates a session and opens score input', (tester) async {
    final repository = FakeScoringRepository();
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    await _selectTarget(tester);
    await tester.tap(find.byKey(const ValueKey('start-scoring-button')));
    await tester.pumpAndSettle();

    expect(repository.startedBowClass, BowClass.recurve);
    expect(repository.startedDistance, DistanceCategory.d50m);
    expect(repository.startedEnvironment, ArcheryEnvironment.outdoor);
    expect(repository.startedNumEnds, 6);
    expect(repository.startedArrowsPerEnd, 6);
    expect(repository.startedTargetFaceId, _targetFace.id);
    expect(find.text('Input new-session'), findsOneWidget);
  });

  testWidgets('keeps the form intact when local session creation fails',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(repository: FakeScoringRepository(failStart: true)),
    );
    await tester.pumpAndSettle();

    await _selectTarget(tester);
    await tester.tap(find.byKey(const ValueKey('start-scoring-button')));
    await tester.pumpAndSettle();

    expect(find.text('Sesi belum berhasil dibuat. Coba lagi.'), findsOneWidget);
    expect(find.textContaining('database write failed'), findsNothing);
    expect(find.text(_targetFace.name), findsOneWidget);
  });

  for (final scenario in <({
    String name,
    ThemeMode themeMode,
    TextScaler textScaler,
  })>[
    (
      name: 'compact light at 1.3 text scale',
      themeMode: ThemeMode.light,
      textScaler: const TextScaler.linear(1.3),
    ),
    (
      name: 'compact dark at 1.3 text scale',
      themeMode: ThemeMode.dark,
      textScaler: const TextScaler.linear(1.3),
    ),
    (
      name: 'compact light at 2.0 text scale',
      themeMode: ThemeMode.light,
      textScaler: const TextScaler.linear(2),
    ),
    (
      name: 'compact dark at 2.0 text scale',
      themeMode: ThemeMode.dark,
      textScaler: const TextScaler.linear(2),
    ),
  ]) {
    testWidgets('fits ${scenario.name}', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 690));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildSubject(
          repository: FakeScoringRepository(),
          themeMode: scenario.themeMode,
          textScaler: scenario.textScaler,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
          find.byKey(const ValueKey('start-scoring-button')), findsOneWidget);
    });
  }
}

Future<void> _selectTarget(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('target-face-selector')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('select-test-target')));
  await tester.pumpAndSettle();
  expect(find.text(_targetFace.name), findsOneWidget);
}

const _targetFace = TargetFaceEntity(
  id: 'target-122',
  organizationId: 'org-manahpro',
  organizationName: 'ManahPro',
  organizationSlug: 'manahpro',
  code: 'fita_122',
  name: 'Target FITA 122 cm',
  usedCount: 42,
  scoringRules: [
    TargetFaceRule(
      value: 10,
      label: '10',
      colorHex: '#F4C430',
    ),
    TargetFaceRule(
      value: 9,
      label: '9',
      colorHex: '#F4C430',
    ),
    TargetFaceRule(
      value: 0,
      label: 'M',
      colorHex: '#C94F5A',
      isMiss: true,
    ),
  ],
);
