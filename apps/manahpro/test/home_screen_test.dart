import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:manahpro/features/home/presentation/home_screen.dart';
import 'package:manahpro/features/scoring/domain/scoring_entities.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';
import 'package:manahpro/features/scoring/presentation/scoring_providers.dart';
import 'package:manahpro/features/scoring/presentation/scoring_routes.dart';
import 'package:manahpro/theme/manah_theme.dart';

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(this._initialState);

  final AuthState _initialState;

  @override
  AuthState build() => _initialState;
}

void main() {
  Widget buildSubject({
    List<ScoringSessionEntity> sessions = const [],
    Object? sessionsError,
    bool failSessionsOnce = false,
    ThemeMode themeMode = ThemeMode.light,
    TextScaler textScaler = TextScaler.noScaling,
    bool isAuthenticated = true,
  }) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(
          path: AppRoutes.settings,
          builder: (_, __) => const Scaffold(
            body: Text('Settings destination'),
          ),
        ),
        GoRoute(
          path: '/login',
          builder: (_, __) => const Scaffold(
            body: Text('Login destination'),
          ),
        ),
        GoRoute(
          path: ScoringRoutes.setup,
          builder: (_, __) => const Scaffold(
            body: Text('Setup destination'),
          ),
        ),
        GoRoute(
          path: ScoringRoutes.history,
          builder: (_, __) => const Scaffold(
            body: Text('History destination'),
          ),
        ),
        GoRoute(
          path: ScoringRoutes.dashboard,
          builder: (_, __) => const Scaffold(
            body: Text('Dashboard destination'),
          ),
        ),
        GoRoute(
          path: '/scoring/session/:id',
          builder: (_, state) => Scaffold(
            body: Text('Input ${state.pathParameters['id']}'),
          ),
        ),
        GoRoute(
          path: '/scoring/session/:id/summary',
          builder: (_, state) => Scaffold(
            body: Text('Summary ${state.pathParameters['id']}'),
          ),
        ),
      ],
    );

    final authState = isAuthenticated
        ? const AuthAuthenticated(
            User(
              id: '1',
              name: 'Test User',
              email: 'test@example.com',
              phone: '08123456789',
              roles: ['Member'],
            ),
          )
        : const AuthUnauthenticated();

    var sessionsHaveFailed = false;

    return ProviderScope(
      overrides: [
        authProvider.overrideWith(() => FakeAuthNotifier(authState)),
        sessionsListProvider.overrideWith((_) async {
          if (sessionsError != null &&
              (!failSessionsOnce || !sessionsHaveFailed)) {
            sessionsHaveFailed = true;
            throw sessionsError;
          }
          return sessions;
        }),
      ],
      child: MaterialApp.router(
        theme: ManahTheme.light,
        darkTheme: ManahTheme.dark,
        themeMode: themeMode,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('id'),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: textScaler),
          child: child!,
        ),
        routerConfig: router,
      ),
    );
  }

  testWidgets('focuses the home screen on individual scoring', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Scoring individu'), findsOneWidget);
    expect(find.text('Mulai scoring'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Statistik'), findsOneWidget);
    expect(find.text('Bersama'), findsNothing);
    expect(find.text('Klub'), findsNothing);
    expect(find.text('Event'), findsNothing);
    expect(find.text('Pelatih'), findsNothing);
    expect(find.text('Lapangan'), findsNothing);
    expect(find.text('Artikel'), findsNothing);
  });

  testWidgets('starts a new individual scoring session', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Mulai scoring'));
    await tester.pumpAndSettle();
    expect(find.text('Setup destination'), findsOneWidget);
  });

  testWidgets('continues the latest active scoring session', (tester) async {
    await tester.pumpWidget(buildSubject(sessions: [_activeSession()]));
    await tester.pumpAndSettle();

    expect(find.text('Lanjutkan scoring'), findsWidgets);
    expect(find.text('2 dari 36 panah'), findsOneWidget);

    await tester.tap(
      find.widgetWithText(FilledButton, 'Lanjutkan scoring'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Input active-session'), findsOneWidget);
  });

  testWidgets('opens the latest completed session summary', (tester) async {
    await tester.pumpWidget(buildSubject(sessions: [_completedSession()]));
    await tester.pumpAndSettle();

    expect(find.text('Sesi terakhir'), findsOneWidget);
    expect(find.text('28'), findsOneWidget);
    expect(find.text('/ 30'), findsOneWidget);

    final latestSession = find.byKey(
      const ValueKey('latest-completed-session'),
    );
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(latestSession);
    await tester.pumpAndSettle();
    expect(find.text('Summary completed-session'), findsOneWidget);
  });

  testWidgets('opens scoring history', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();
    expect(find.text('History destination'), findsOneWidget);
  });

  testWidgets('opens scoring statistics', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Statistik'));
    await tester.pumpAndSettle();
    expect(find.text('Dashboard destination'), findsOneWidget);
  });

  testWidgets('opens settings for an authenticated user', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();
    expect(find.text('Settings destination'), findsOneWidget);
  });

  testWidgets('offers sign in without blocking offline scoring',
      (tester) async {
    await tester.pumpWidget(buildSubject(isAuthenticated: false));
    await tester.pumpAndSettle();

    expect(find.text('Mulai scoring'), findsOneWidget);
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();
    expect(find.text('Login destination'), findsOneWidget);
  });

  testWidgets('recovers from a session loading error through retry',
      (tester) async {
    await tester.pumpWidget(
      buildSubject(
        sessionsError: StateError('database failed internally'),
        failSessionsOnce: true,
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Data scoring belum bisa dimuat.'), findsOneWidget);
    expect(find.text('Coba lagi'), findsOneWidget);
    expect(find.textContaining('database failed'), findsNothing);

    await tester.tap(find.text('Coba lagi'));
    await tester.pumpAndSettle();

    expect(find.text('Data scoring belum bisa dimuat.'), findsNothing);
    expect(find.text('Mulai scoring'), findsOneWidget);
  });

  testWidgets('fits compact light theme at 2.0 text scale', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 690));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildSubject(
        sessions: [_activeSession(), _completedSession()],
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('fits compact dark theme at 2.0 text scale', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 690));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      buildSubject(
        sessions: [_activeSession(), _completedSession()],
        themeMode: ThemeMode.dark,
        textScaler: const TextScaler.linear(2),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

ScoringSessionEntity _activeSession() {
  return ScoringSessionEntity(
    id: 'active-session',
    clientUuid: 'active-client',
    bowClass: BowClass.recurve,
    distanceCategory: DistanceCategory.d50m,
    distanceM: 50,
    numEnds: 6,
    arrowsPerEnd: 6,
    startedAt: DateTime(2026, 7, 19, 8),
    ends: const [
      ScoringEndEntity(
        id: 'active-end',
        endNumber: 1,
        arrows: [
          ArrowScore(id: 'a1', arrowIndex: 0, scoreValue: 10),
          ArrowScore(id: 'a2', arrowIndex: 1, scoreValue: 9),
        ],
      ),
    ],
  );
}

ScoringSessionEntity _completedSession() {
  return ScoringSessionEntity(
    id: 'completed-session',
    clientUuid: 'completed-client',
    bowClass: BowClass.recurve,
    distanceCategory: DistanceCategory.d20m,
    distanceM: 20,
    numEnds: 1,
    arrowsPerEnd: 3,
    status: ScoringSessionStatus.completed,
    startedAt: DateTime(2026, 7, 18, 8),
    completedAt: DateTime(2026, 7, 18, 8, 10),
    isSynced: true,
    ends: const [
      ScoringEndEntity(
        id: 'completed-end',
        endNumber: 1,
        arrows: [
          ArrowScore(id: 'c1', arrowIndex: 0, scoreValue: 10),
          ArrowScore(id: 'c2', arrowIndex: 1, scoreValue: 9),
          ArrowScore(id: 'c3', arrowIndex: 2, scoreValue: 9),
        ],
      ),
    ],
  );
}
