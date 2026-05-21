import 'package:app_variant/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the variant home placeholder', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    expect(find.text('Variant'), findsOneWidget);
    expect(find.text('Welcome to Variant!'), findsOneWidget);
  });
}
