import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: Brightness.light,
    );
    return _baseTheme(scheme).copyWith(
      scaffoldBackgroundColor: AppPalette.lightBackground,
      cardColor: AppPalette.lightCard,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: AppPalette.primary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.accent,
      brightness: Brightness.dark,
      surface: AppPalette.darkBackground,
    );
    return _baseTheme(scheme).copyWith(
      scaffoldBackgroundColor: AppPalette.darkBackground,
      cardColor: AppPalette.cardBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  static ThemeData _baseTheme(ColorScheme colorScheme) {
    final ThemeData seedTheme = ThemeData(
      brightness: colorScheme.brightness,
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Manrope',
    );
    final TextTheme textTheme = seedTheme.textTheme.apply(
      fontFamily: 'Manrope',
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: 'Manrope',
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.black.withValues(alpha: 0.18),
        indicatorColor: AppPalette.accent.withValues(alpha: 0.2),
        labelTextStyle: WidgetStatePropertyAll<TextStyle>(
          textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppPalette.accent);
          }
          return IconThemeData(color: Colors.white.withValues(alpha: 0.85));
        }),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.brightness == Brightness.dark
            ? AppPalette.cardBackground
            : AppPalette.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle>(
            textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.08),
        thickness: 1,
      ),
    );
  }
}
