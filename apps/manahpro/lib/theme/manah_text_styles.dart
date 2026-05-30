import 'package:flutter/material.dart';

/// ManahPro typography scale — ui-ux-design-guide.md §3.3.
///
/// The guide specifies Inter; to avoid adding a font dependency this uses the
/// platform default family with the correct sizes/weights. Numeric styles use
/// tabular figures so scores/ratings stay aligned. (Swap in `google_fonts`
/// Inter later without touching call sites.)
abstract final class ManahTextStyles {
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  /// 40 / Bold — rating number, hero stat.
  static const TextStyle display = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -0.5,
    fontFeatures: _tabular,
  );

  /// 32 / Bold — screen title.
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.3,
  );

  /// 24 / SemiBold — section header.
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// 20 / SemiBold — card title.
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// 16 / Regular — primary body (minimum body size).
  static const TextStyle bodyL = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 14 / Regular — secondary text.
  static const TextStyle bodyM = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// 12 / Regular — captions, timestamps.
  static const TextStyle bodyS = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// 12 / Medium / UPPERCASE — category labels, badges.
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0.5,
  );

  /// 40 / Bold / tabular — scores, rankings, stats.
  static const TextStyle number = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.0,
    fontFeatures: _tabular,
  );

  /// Builds the Material [TextTheme] from the scale above.
  static TextTheme textTheme(Color color) {
    final base = TextStyle(color: color);
    return TextTheme(
      displayLarge: base.merge(display),
      headlineLarge: base.merge(h1),
      headlineMedium: base.merge(h2),
      headlineSmall: base.merge(h3),
      titleLarge: base.merge(h3),
      titleMedium: base.merge(bodyL).copyWith(fontWeight: FontWeight.w600),
      titleSmall: base.merge(bodyM).copyWith(fontWeight: FontWeight.w600),
      bodyLarge: base.merge(bodyL),
      bodyMedium: base.merge(bodyM),
      bodySmall: base.merge(bodyS),
      labelLarge: base.merge(label).copyWith(fontSize: 14),
      labelMedium: base.merge(label),
      labelSmall: base.merge(label).copyWith(fontSize: 11),
    );
  }
}
