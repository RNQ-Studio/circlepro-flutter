import 'package:app_main/home/home_screen.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  Widget buildSubject() => MaterialApp.router(
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
      );

  testWidgets('shows home title and welcome text', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome!'), findsOneWidget);
  });

  testWidgets('settings icon navigates to settings route', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);
  });
}
