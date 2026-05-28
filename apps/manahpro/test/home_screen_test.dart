import 'package:manahpro/features/home/domain/entities/user_profile.dart';
import 'package:manahpro/features/home/presentation/home_provider.dart';
import 'package:manahpro/features/home/presentation/home_screen.dart';
import 'package:manahpro/features/quotes/presentation/quotes_notifier.dart';
import 'package:manahpro/features/quotes/domain/entities/quote_entity.dart';
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

  Widget buildSubject() => ProviderScope(
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
            ],
          ),
        ),
      );

  testWidgets('shows user header after profile loads', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    expect(find.textContaining('Hi, Test User'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });

  testWidgets('shows all 15 menu items', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    expect(find.text('Kutipan'), findsOneWidget);
    expect(find.text('Menu 15'), findsOneWidget);
  });

  testWidgets('tap menu shows snackbar', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menu 02'));
    await tester.pump();
    expect(find.textContaining('Fitur belum tersedia'), findsOneWidget);
  });

  testWidgets('settings icon navigates to settings route', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });
}
