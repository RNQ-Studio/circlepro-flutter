import 'package:flutter/material.dart';

/// ManahPro "Forest Archery" palette — see ui-ux-design-guide.md §3.4.
abstract final class ManahColors {
  // Brand
  static const Color brand = Color(0xFF1565C0); // Royal Blue 800
  static const Color brandLight = Color(0xFF2196F3); // Sky Blue 500
  static const Color brandSurface = Color(0xFFE3F2FD); // Ice Blue 50

  // Secondary (amber)
  static const Color amber = Color(0xFFFFC107);
  static const Color amberDeep = Color(0xFFFF8F00);
  static const Color amberSurface = Color(0xFFFFF8E1);

  // Status
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF1E88E5);

  // Neutrals
  static const Color nearBlack = Color(0xFF1A1A1A);
  static const Color darkGrey = Color(0xFF333333);
  static const Color mediumGrey = Color(0xFF666666);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color nearWhite = Color(0xFFFAFAFA);

  // Scoring-specific (high contrast for outdoor readability)
  /// 10 & X — gold highlight.
  static const Color scoreGold = Color(0xFFFFC107);

  /// Miss (M) — soft red.
  static const Color scoreMiss = Color(0xFFE57373);

  // Ranking badge colors (used later in ranking phase)
  static const Color rankDiamond = Color(0xFFB9F2FF);
  static const Color rankGold = Color(0xFFFFD700);
  static const Color rankSilver = Color(0xFFC0C0C0);
  static const Color rankBronze = Color(0xFFCD7F32);
  static const Color rankIron = Color(0xFF808080);

  // Dark surfaces
  static const Color darkBg = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkElevated = Color(0xFF2C2C2C);

  /// Returns the canonical color for an arrow score value.
  static Color forScore(int value, {required bool isX, required bool isMiss}) {
    if (isMiss) return scoreMiss;
    if (isX || value == 10) return scoreGold;
    return brand;
  }
}
