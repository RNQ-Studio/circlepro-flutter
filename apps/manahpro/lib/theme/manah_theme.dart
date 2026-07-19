import 'package:flutter/material.dart';

import 'manah_colors.dart';
import 'manah_text_styles.dart';
import 'manah_tokens.dart';

/// ManahPro app-level Material 3 theme.
///
/// This remains isolated from the shared core theme used by `apps/variant`.
abstract final class ManahTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scaffoldBackground =
        isDark ? ManahColors.darkBg : ManahColors.lightBg;
    final surface = isDark ? ManahColors.darkSurface : ManahColors.nearWhite;
    final onSurface =
        isDark ? ManahColors.darkOnSurface : ManahColors.nearBlack;
    final primary = isDark ? ManahColors.brandLight : ManahColors.brand;
    final onPrimary = isDark ? ManahColors.darkBg : ManahColors.nearWhite;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: ManahColors.brand,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer:
          isDark ? ManahColors.brandContainerDark : ManahColors.brandSurface,
      onPrimaryContainer:
          isDark ? ManahColors.onBrandContainerDark : ManahColors.nearBlack,
      secondary: isDark ? ManahColors.brassDark : ManahColors.brassDeep,
      onSecondary: isDark ? ManahColors.onBrassDark : ManahColors.nearWhite,
      secondaryContainer:
          isDark ? ManahColors.darkContainerHigh : ManahColors.brassSurface,
      onSecondaryContainer:
          isDark ? ManahColors.brassDark : ManahColors.nearBlack,
      error: isDark ? ManahColors.errorDark : ManahColors.errorStrong,
      onError: isDark ? ManahColors.nearBlack : ManahColors.nearWhite,
      surface: surface,
      onSurface: onSurface,
      surfaceContainerLowest:
          isDark ? ManahColors.darkBg : ManahColors.nearWhite,
      surfaceContainerLow:
          isDark ? ManahColors.darkContainerLow : ManahColors.lightContainerLow,
      surfaceContainer:
          isDark ? ManahColors.darkElevated : ManahColors.lightGrey,
      surfaceContainerHigh: isDark
          ? ManahColors.darkContainerHigh
          : ManahColors.lightContainerHigh,
      surfaceContainerHighest: isDark
          ? ManahColors.darkContainerHighest
          : ManahColors.lightContainerHighest,
      onSurfaceVariant:
          isDark ? ManahColors.darkOnSurfaceVariant : ManahColors.mediumGrey,
      outline: isDark ? ManahColors.darkOutline : ManahColors.lightOutline,
      outlineVariant: isDark
          ? ManahColors.darkOutlineVariant
          : ManahColors.lightOutlineVariant,
    );

    final inputBorder = OutlineInputBorder(
      borderRadius: const BorderRadius.all(
        Radius.circular(ManahRadius.md),
      ),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: ManahTextStyles.textTheme(onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: ManahTextStyles.h3.copyWith(color: onSurface),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(ManahRadius.md),
          ),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.surfaceContainerHighest,
          disabledForegroundColor: colorScheme.onSurfaceVariant,
          minimumSize: const Size(double.infinity, 52),
          textStyle: ManahTextStyles.bodyM.copyWith(
            fontWeight: FontWeight.w600,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(ManahRadius.md),
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(ManahRadius.md),
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(color: colorScheme.outline),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(ManahRadius.md),
            ),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: colorScheme.surfaceContainerLowest,
        labelStyle: ManahTextStyles.bodyM.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: ManahTextStyles.bodyM.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: colorScheme.outlineVariant),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(ManahRadius.sm)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant;
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerLow;
          }),
          side: WidgetStatePropertyAll(
            BorderSide(color: colorScheme.outlineVariant),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(ManahRadius.md),
              ),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ManahSpacing.base,
          vertical: ManahSpacing.base,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: colorScheme.surface,
        modalBarrierColor: colorScheme.scrim.withValues(alpha: 0.48),
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ManahRadius.xl),
          ),
        ),
      ),
    );
  }
}
