import 'dart:async';

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
import 'package:shared_preferences/shared_preferences.dart';

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

class _FakeScoringRepository implements ScoringRepository {
  _FakeScoringRepository({
    this.targets = const [_targetFace],
    this.targetStreamMode = _TargetStreamMode.data,
    this.failStart = false,
  });

  List<TargetFaceEntity> targets;
  final _TargetStreamMode targetStreamMode;
  final bool failStart;
  final _targetUpdates = StreamController<List<TargetFaceEntity>>.broadcast(
    sync: true,
  );

  int refreshCalls = 0;
  BowClass? startedBowClass;
  DistanceCategory? startedDistance;
  ArcheryEnvironment? startedEnvironment;
  int? startedNumEnds;
  int? startedArrowsPerEnd;
  int? startedSighterEndCount;
  String? startedTargetFaceId;
  int? startedDistanceM;
  int? startedTargetFaceCm;
  int? startedMaxPossibleScoreOverride;
  String? startedEquipmentProfileId;
  String? startedTitle;

  void emitTargets(List<TargetFaceEntity> value) {
    targets = value;
    _targetUpdates.add(value);
  }

  Future<void> dispose() => _targetUpdates.close();

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
    startedDistanceM = distanceM;
    startedTargetFaceCm = targetFaceCm;
    startedMaxPossibleScoreOverride = maxPossibleScoreOverride;
    startedEquipmentProfileId = equipmentProfileId;
    startedTitle = title;

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
      _TargetStreamMode.data => _targetDataStream(),
      _TargetStreamMode.loading => Stream<List<TargetFaceEntity>>.multi((_) {}),
      _TargetStreamMode.error =>
        Stream.error(StateError('target API failed internally')),
    };
  }

  Stream<List<TargetFaceEntity>> _targetDataStream() async* {
    yield targets;
    yield* _targetUpdates.stream;
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
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildSubject({
    required _FakeScoringRepository repository,
    ThemeMode themeMode = ThemeMode.light,
    TextScaler textScaler = TextScaler.noScaling,
  }) {
    addTearDown(repository.dispose);
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
      buildSubject(repository: _FakeScoringRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sesi baru'), findsOneWidget);
    expect(find.text('Siapkan sesi'), findsOneWidget);
    expect(find.text('Busur'), findsOneWidget);
    expect(find.text('Format latihan'), findsOneWidget);
    await _reveal(tester, find.text('Target'));
    expect(find.text('Target'), findsOneWidget);
    expect(find.byKey(const ValueKey('session-live-summary')), findsOneWidget);
    expect(find.byKey(const ValueKey('start-scoring-button')), findsOneWidget);
    expect(find.text('Pilih target untuk mulai'), findsOneWidget);
  });

  testWidgets('applies a round preset from the bottom sheet', (tester) async {
    final repository = _FakeScoringRepository();
    await tester.pumpWidget(
      buildSubject(repository: repository),
    );
    await tester.pumpAndSettle();

    final presetField = find.byKey(const ValueKey('round-preset-field'));
    await _reveal(tester, presetField);
    await tester.tap(presetField);
    await tester.pumpAndSettle();
    expect(find.text('Pilih preset ronde'), findsWidgets);

    repository.emitTargets(const [_targetFace80]);
    await tester.pump();
    await tester.tap(find.text('Latihan 30m'));
    await tester.pumpAndSettle();

    expect(find.text('30m · Recurve · Outdoor'), findsOneWidget);
    expect(find.text('30 panah dihitung · 6 percobaan'), findsOneWidget);
    expect(find.text('Latihan 30m'), findsOneWidget);
    expect(
      tester
          .widget<DropdownButtonFormField<DistanceCategory>>(
            find.byType(DropdownButtonFormField<DistanceCategory>),
          )
          .initialValue,
      DistanceCategory.d30m,
    );

    await _reveal(tester, find.text(_targetFace80.name));
    expect(find.text(_targetFace80.name), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('start-scoring-button')));
    await tester.pumpAndSettle();

    expect(repository.startedDistance, DistanceCategory.d30m);
    expect(repository.startedDistanceM, 30);
    expect(repository.startedTargetFaceId, _targetFace80.id);
    expect(repository.startedTargetFaceCm, 80);
    expect(repository.startedNumEnds, 6);
    expect(repository.startedArrowsPerEnd, 6);
    expect(repository.startedSighterEndCount, 1);
    expect(repository.startedMaxPossibleScoreOverride, 300);
    expect(repository.startedEquipmentProfileId, isNull);
    expect(repository.startedTitle, 'Latihan 30m');
    expect(find.text('Input new-session'), findsOneWidget);
  });

  testWidgets('restores the visible distance control from local preferences',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'last_selected_distance': DistanceCategory.d30m.value,
    });
    await tester.pumpWidget(
      buildSubject(repository: _FakeScoringRepository()),
    );
    await tester.pumpAndSettle();

    final distanceField =
        find.byType(DropdownButtonFormField<DistanceCategory>);
    await _reveal(tester, distanceField);
    expect(
      tester
          .widget<DropdownButtonFormField<DistanceCategory>>(distanceField)
          .initialValue,
      DistanceCategory.d30m,
    );
    expect(find.textContaining('30m'), findsWidgets);
  });

  testWidgets('blocks start when a preset has no compatible cached target',
      (tester) async {
    final repository = _FakeScoringRepository();
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();
    await _selectTarget(tester);

    final presetField = find.byKey(const ValueKey('round-preset-field'));
    await _reveal(tester, presetField);
    await tester.tap(presetField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Latihan 30m'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih target untuk mulai'), findsOneWidget);
    final button = tester.widget<FilledButton>(
      find.byKey(const ValueKey('start-scoring-button')),
    );
    expect(button.onPressed, isNull);
    expect(repository.startedTargetFaceId, isNull);
  });

  testWidgets('reconciles a late target cache with the active preset',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'last_selected_target_face_id': _targetFace.id,
    });
    final repository = _FakeScoringRepository(targets: const []);
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    final presetField = find.byKey(const ValueKey('round-preset-field'));
    await _reveal(tester, presetField);
    await tester.tap(presetField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Latihan 30m'));
    await tester.pumpAndSettle();
    expect(find.text('Pilih target untuk mulai'), findsOneWidget);

    repository.emitTargets(const [_targetFace, _targetFace80]);
    await tester.pumpAndSettle();
    await _reveal(tester, find.text(_targetFace80.name));

    expect(find.text(_targetFace80.name), findsOneWidget);
    expect(find.text(_targetFace.name), findsNothing);
    expect(find.text('Pilih target untuk mulai'), findsNothing);
  });

  testWidgets('shows and submits the exact WA 18 meter preset distance',
      (tester) async {
    final repository = _FakeScoringRepository(targets: const [_targetFace40]);
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    final presetField = find.byKey(const ValueKey('round-preset-field'));
    await _reveal(tester, presetField);
    await tester.tap(presetField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('WA 18m Indoor'));
    await tester.pumpAndSettle();

    expect(find.text('18m · Recurve · Indoor'), findsOneWidget);
    expect(find.text('20m · Recurve · Indoor'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('start-scoring-button')));
    await tester.pumpAndSettle();

    expect(repository.startedDistance, DistanceCategory.d20m);
    expect(repository.startedDistanceM, 18);
    expect(repository.startedTargetFaceId, _targetFace40.id);
    expect(repository.startedTargetFaceCm, 40);
    expect(repository.startedSighterEndCount, 2);
    expect(repository.startedMaxPossibleScoreOverride, 540);
    expect(repository.startedTitle, 'WA 18m Indoor');
  });

  testWidgets('shows human target error and retries the local-first provider',
      (tester) async {
    final repository = _FakeScoringRepository(
      targetStreamMode: _TargetStreamMode.error,
    );
    await tester.pumpWidget(buildSubject(repository: repository));
    await tester.pumpAndSettle();

    final errorTitle = find.text('Target belum bisa dimuat.');
    await _reveal(tester, errorTitle);
    expect(errorTitle, findsOneWidget);
    expect(find.textContaining('target API failed'), findsNothing);
    final callsBeforeRetry = repository.refreshCalls;

    await tester.tap(find.text('Coba lagi'));
    await tester.pump();
    expect(repository.refreshCalls, callsBeforeRetry + 1);
  });

  testWidgets('uses a target-shaped skeleton while local data is loading',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(
        repository: _FakeScoringRepository(
          targetStreamMode: _TargetStreamMode.loading,
        ),
      ),
    );
    await tester.pump();
    await tester.pump();

    final skeleton = find.byKey(const ValueKey('target-loading-skeleton'));
    await _reveal(tester, skeleton);
    expect(skeleton, findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('explains an empty target cache and offers refresh',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(repository: _FakeScoringRepository(targets: const [])),
    );
    await tester.pumpAndSettle();

    final emptyTitle = find.text('Belum ada target tersimpan.');
    await _reveal(tester, emptyTitle);
    expect(emptyTitle, findsOneWidget);
    expect(find.text('Muat target'), findsOneWidget);
  });

  testWidgets('creates a session and opens score input', (tester) async {
    final repository = _FakeScoringRepository();
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
    expect(repository.startedSighterEndCount, 0);
    expect(repository.startedTargetFaceId, _targetFace.id);
    expect(repository.startedDistanceM, 50);
    expect(repository.startedTargetFaceCm, 122);
    expect(repository.startedMaxPossibleScoreOverride, 360);
    expect(repository.startedEquipmentProfileId, isNull);
    expect(repository.startedTitle, isNull);
    expect(find.text('Input new-session'), findsOneWidget);
  });

  testWidgets('keeps the form intact when local session creation fails',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(repository: _FakeScoringRepository(failStart: true)),
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
          repository: _FakeScoringRepository(),
          themeMode: scenario.themeMode,
          textScaler: scenario.textScaler,
        ),
      );
      await tester.pumpAndSettle();

      final presetField = find.byKey(const ValueKey('round-preset-field'));
      await _reveal(tester, presetField);
      await tester.tap(presetField);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      await _reveal(tester, find.text('Target'));
      expect(tester.takeException(), isNull);
      expect(
          find.byKey(const ValueKey('start-scoring-button')), findsOneWidget);
    });
  }
}

Future<void> _selectTarget(WidgetTester tester) async {
  final selector = find.byKey(const ValueKey('target-face-selector'));
  await _reveal(tester, selector);
  await tester.tap(selector);
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('select-test-target')));
  await tester.pumpAndSettle();
  expect(find.text(_targetFace.name), findsOneWidget);
}

Future<void> _reveal(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    240,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
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

const _targetFace80 = TargetFaceEntity(
  id: 'target-80',
  organizationId: 'org-manahpro',
  organizationName: 'ManahPro',
  organizationSlug: 'manahpro',
  code: 'fita_80',
  name: 'Target FITA 80 cm',
  usedCount: 18,
  scoringRules: [
    TargetFaceRule(
      value: 10,
      label: '10',
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

const _targetFace40 = TargetFaceEntity(
  id: 'target-40',
  organizationId: 'org-manahpro',
  organizationName: 'ManahPro',
  organizationSlug: 'manahpro',
  code: 'fita_40',
  name: 'Target FITA 40 cm',
  usedCount: 9,
  scoringRules: [
    TargetFaceRule(
      value: 10,
      label: '10',
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
