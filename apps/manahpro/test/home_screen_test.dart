import 'package:manahpro/features/home/domain/entities/user_profile.dart';
import 'package:manahpro/features/home/presentation/home_provider.dart';
import 'package:manahpro/features/home/presentation/home_screen.dart';
import 'package:manahpro/features/quotes/presentation/quotes_notifier.dart';
import 'package:manahpro/features/quotes/domain/entities/quote_entity.dart';
import 'package:manahpro/features/gamification/presentation/gamification_providers.dart';
import 'package:manahpro/features/gamification/domain/gamification_entities.dart';
import 'package:manahpro/features/scoring/domain/scoring_entities.dart';
import 'package:manahpro/features/scoring/domain/scoring_enums.dart';
import 'package:manahpro/features/scoring/presentation/scoring_providers.dart';
import 'package:core/core.dart';
import 'package:features_shared/features_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(this._initialState);
  final AuthState _initialState;

  @override
  AuthState build() => _initialState;
}

class FakeQuotesNotifier extends QuotesNotifier {
  @override
  Future<List<QuoteEntity>> build() async => [];
}

void main() {
  const testProfile = UserProfile(
    name: 'Test User',
    email: 'test@example.com',
    phone: '08123456789',
    avatarUrl: null,
    role: 'Member',
  );

  const testStats = UserStatsEntity(
    xp: 650,
    level: 2,
    currentStreak: 3,
    longestStreak: 5,
    lastSessionAt: null,
    badges: [],
  );

  Widget buildSubject({
    List<ScoringSessionEntity> sessions = const [],
  }) =>
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => FakeAuthNotifier(
                const AuthAuthenticated(User(
                  id: '1',
                  name: 'Test User',
                  email: 'test@example.com',
                  phone: '08123456789',
                  roles: ['Member'],
                )),
              )),
          quotesProvider.overrideWith(() => FakeQuotesNotifier()),
          userProfileProvider.overrideWith((_) async => testProfile),
          gamificationStatsProvider.overrideWith((_) async => testStats),
          sessionsListProvider.overrideWith((_) async => sessions),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const HomeScreen(),
              ),
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, __) => const Scaffold(body: Text('Settings')),
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
          ),
        ),
      );

  testWidgets('shows user header after profile loads', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });

  testWidgets('shows level, streak and progress bar', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    expect(find.text('LVL 2'), findsOneWidget);
    expect(find.textContaining('3 Hari'), findsOneWidget);
  });

  testWidgets('shows all 9 main menu items', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    expect(find.text('Scoring'), findsOneWidget);
    expect(find.text('Bersama'), findsOneWidget);
    expect(find.text('Statistik'), findsOneWidget);
    expect(find.text('Riwayat'), findsOneWidget);
    expect(find.text('Klub'), findsOneWidget);
    expect(find.text('Event'), findsOneWidget);
    expect(find.text('Pelatih'), findsOneWidget);
    expect(find.text('Lapangan'), findsOneWidget);
    expect(find.text('Artikel'), findsOneWidget);
  });

  testWidgets('settings icon navigates to settings route', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });

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

  testWidgets('continues the latest active scoring session', (tester) async {
    final activeSession = ScoringSessionEntity(
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

    await tester.pumpWidget(buildSubject(sessions: [activeSession]));
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
    final completedSession = ScoringSessionEntity(
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

    await tester.pumpWidget(buildSubject(sessions: [completedSession]));
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
}
