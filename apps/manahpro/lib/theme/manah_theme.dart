import 'package:flutter/material.dart';

import 'manah_colors.dart';
import 'manah_text_styles.dart';
import 'manah_tokens.dart';

/// ManahPro app-level theme (light & dark) built on Material 3 with the
/// Forest Archery brand. Used by [App] instead of the shared core theme so the
/// `variant` flavor is unaffected.
abstract final class ManahTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: ManahColors.brand,
      brightness: brightness,
      primary: ManahColors.brand,
      secondary: ManahColors.amberDeep,
      error: ManahColors.error,
    );

    final textColor = isDark ? const Color(0xFFE8E8E8) : ManahColors.nearBlack;
    final scaffoldBg = isDark ? ManahColors.darkBg : ManahColors.nearWhite;
    final surface = isDark ? ManahColors.darkSurface : Colors.white;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      textTheme: ManahTextStyles.textTheme(textColor),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: textColor,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: ManahTextStyles.h3.copyWith(color: textColor),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ManahRadius.lg),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ManahColors.brand,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          textStyle: ManahTextStyles.bodyL.copyWith(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ManahRadius.md),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ManahColors.brand,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ManahRadius.md),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ManahColors.brand,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: ManahColors.brand),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ManahRadius.md),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ManahRadius.full),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? ManahColors.darkElevated : ManahColors.lightGrey,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base,
          vertical: ManahSpacing.base,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ManahRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ManahRadius.md),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ManahRadius.md),
          borderSide: const BorderSide(color: ManahColors.brand, width: 1.5),
        ),
      ),
    );
  }
}
