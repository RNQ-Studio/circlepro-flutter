import 'package:flutter/material.dart';

/// ManahPro precision-archery palette.
///
/// Deep forest carries primary actions, graphite neutrals keep the product
/// crisp, and brass is reserved for secondary/domain emphasis.
abstract final class ManahColors {
  // Brand
  static const Color brand = Color(0xFF0B5D45);
  static const Color brandLight = Color(0xFF74D5B2);
  static const Color brandSurface = Color(0xFFD8F0E6);
  static const Color brandContainerDark = Color(0xFF124E3E);
  static const Color onBrandContainerDark = Color(0xFFC8F3E3);

  // Secondary (brass)
  static const Color amber = Color(0xFFD5A33A);
  static const Color amberDeep = Color(0xFF8A5B0B);
  static const Color amberSurface = Color(0xFFF5E8C8);
  static const Color amberDark = Color(0xFFE6B965);
  static const Color onAmberDark = Color(0xFF3F2B05);

  // Status
  static const Color success = Color(0xFF1E7A55);
  static const Color warning = Color(0xFF9A6700);
  static const Color error = Color(0xFFB3261E);
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color info = Color(0xFF0E7490);

  // Light graphite neutrals
  static const Color nearBlack = Color(0xFF121A16);
  static const Color darkGrey = Color(0xFF2A3931);
  static const Color mediumGrey = Color(0xFF46574E);
  static const Color lightGrey = Color(0xFFE9EFEB);
  static const Color nearWhite = Color(0xFFFAFCFA);
  static const Color lightBg = Color(0xFFF4F7F5);
  static const Color lightContainerLow = Color(0xFFF0F4F1);
  static const Color lightContainerHigh = Color(0xFFE1E9E4);
  static const Color lightContainerHighest = Color(0xFFD6E1DA);
  static const Color lightOutline = Color(0xFF687A70);
  static const Color lightOutlineVariant = Color(0xFFBECBC3);

  // Dark forest graphite surfaces
  static const Color darkBg = Color(0xFF0B1410);
  static const Color darkSurface = Color(0xFF101A15);
  static const Color darkContainerLow = Color(0xFF15211B);
  static const Color darkElevated = Color(0xFF1B2922);
  static const Color darkContainerHigh = Color(0xFF223229);
  static const Color darkContainerHighest = Color(0xFF2C3E34);
  static const Color darkOnSurface = Color(0xFFE8F0EB);
  static const Color darkOnSurfaceVariant = Color(0xFFBBC8C0);
  static const Color darkOutline = Color(0xFF82938A);
  static const Color darkOutlineVariant = Color(0xFF34473D);

  // Scoring-specific (high contrast for outdoor readability)
  /// 10 & X - target gold highlight.
  static const Color scoreGold = Color(0xFFF4C430);

  /// Miss (M) - assertive red.
  static const Color scoreMiss = Color(0xFFC94F5A);

  // Ranking badge colors
  static const Color rankDiamond = Color(0xFFB9F2FF);
  static const Color rankGold = Color(0xFFFFD700);
  static const Color rankSilver = Color(0xFFC0C0C0);
  static const Color rankBronze = Color(0xFFCD7F32);
  static const Color rankIron = Color(0xFF808080);

  /// Returns the canonical color for an arrow score value.
  static Color forScore(int value, {required bool isX, required bool isMiss}) {
    if (isMiss) return scoreMiss;
    if (isX || value == 10) return scoreGold;
    return brand;
  }
}
