import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manahpro/theme/manah_colors.dart';
import 'package:manahpro/theme/manah_theme.dart';

void main() {
  test('uses the sharp forest and graphite palette in both themes', () {
    final light = ManahTheme.light;
    final dark = ManahTheme.dark;

    expect(ManahColors.brand, const Color(0xFF0B5D45));
    expect(light.scaffoldBackgroundColor, const Color(0xFFF4F7F5));
    expect(dark.scaffoldBackgroundColor, const Color(0xFF0B1410));
    expect(light.colorScheme.surface, isNot(Colors.white));
    expect(dark.colorScheme.surface, isNot(Colors.black));
    expect(light.colorScheme.primary, ManahColors.brand);
    expect(dark.colorScheme.primary, ManahColors.brandLight);
  });

  test('keeps primary actions readable at WCAG AA contrast', () {
    final light = ManahTheme.light.colorScheme;
    final dark = ManahTheme.dark.colorScheme;

    expect(
      _contrastRatio(light.primary, light.onPrimary),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _contrastRatio(dark.primary, dark.onPrimary),
      greaterThanOrEqualTo(4.5),
    );
  });

  test('uses crisp component borders and restrained radii', () {
    final theme = ManahTheme.light;
    final cardShape = theme.cardTheme.shape! as RoundedRectangleBorder;
    final cardRadius = cardShape.borderRadius as BorderRadius;
    final inputBorder = theme.inputDecorationTheme.enabledBorder!;
    final chipShape = theme.chipTheme.shape! as RoundedRectangleBorder;
    final chipRadius = chipShape.borderRadius as BorderRadius;

    expect(cardRadius.topLeft.x, 12);
    expect(inputBorder, isA<OutlineInputBorder>());
    expect((inputBorder as OutlineInputBorder).borderSide.style,
        BorderStyle.solid);
    expect(inputBorder.borderSide.width, 1);
    expect(chipRadius.topLeft.x, 8);
  });
}

double _contrastRatio(Color a, Color b) {
  final lighter = math.max(a.computeLuminance(), b.computeLuminance());
  final darker = math.min(a.computeLuminance(), b.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}
