import 'dart:convert';
import 'dart:typed_data';

import 'package:app_variant/features/home/presentation/home_screen.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAssetBundle extends CachingAssetBundle {
  final AssetBundle parent;
  FakeAssetBundle(this.parent);

  static final ByteData _transparentImage = Uint8List.fromList(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
    ),
  ).buffer.asByteData();

  @override
  Future<ByteData> load(String key) async {
    if (key.contains('AssetManifest')) {
      return parent.load(key);
    }
    return _transparentImage;
  }
}

void main() {
  testWidgets('shows the variant home placeholder', (tester) async {
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: FakeAssetBundle(rootBundle),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Welcome!'), findsOneWidget);
  });
}
