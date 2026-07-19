import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/shared/widgets/manah_navigation_button.dart';
import 'package:manahpro/theme/manah_theme.dart';

void main() {
  testWidgets('back button is accessible and pops one logical page',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ManahTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      leadingWidth: 64,
                      leading: ManahNavigationButton.back(),
                      title: Text('Halaman kedua'),
                    ),
                  ),
                ),
              ),
              child: const Text('Buka halaman'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Buka halaman'));
    await tester.pumpAndSettle();

    final backButton = find.byKey(const ValueKey('manah-back-button'));
    expect(backButton, findsOneWidget);
    expect(find.byTooltip('Kembali'), findsOneWidget);
    expect(tester.getSize(backButton).width, greaterThanOrEqualTo(48));
    expect(tester.getSize(backButton).height, greaterThanOrEqualTo(48));

    await tester.tap(backButton);
    await tester.pumpAndSettle();
    expect(find.text('Buka halaman'), findsOneWidget);
  });

  testWidgets('close variant keeps the same surface and custom action',
      (tester) async {
    var closed = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: ManahTheme.dark,
        home: Scaffold(
          appBar: AppBar(
            leadingWidth: 64,
            leading: ManahNavigationButton.close(
              onPressed: () => closed = true,
            ),
          ),
        ),
      ),
    );

    final closeButton = find.byKey(const ValueKey('manah-close-button'));
    expect(closeButton, findsOneWidget);
    expect(find.byTooltip('Tutup'), findsOneWidget);
    expect(find.descendant(of: closeButton, matching: find.byIcon(Icons.close)),
        findsOneWidget);

    await tester.tap(closeButton);
    expect(closed, isTrue);
  });
}
