import 'package:app_main/features/home/domain/entities/user_profile.dart';
import 'package:app_main/features/home/presentation/home_provider.dart';
import 'package:app_main/features/home/presentation/home_screen.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  const testProfile = UserProfile(
    name: 'Test User',
    email: 'test@example.com',
    gender: 'Putra',
    age: '25',
    city: 'Jakarta',
  );

  Widget buildSubject() => ProviderScope(
        overrides: [
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
    expect(find.text('Menu 01'), findsOneWidget);
    expect(find.text('Menu 15'), findsOneWidget);
  });

  testWidgets('tap menu shows snackbar', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Menu 01'));
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
