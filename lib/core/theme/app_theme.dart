import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/core/theme/colors_list.dart';
import 'package:shopping_app/core/theme/colors_theme.dart';
import 'package:shopping_app/core/theme/text_theme.dart';

class AppTheme {
  //Light Theme
  static final light =
      ThemeData(fontFamily: GoogleFonts.montserrat().fontFamily).copyWith(
        extensions: [appColors, AppTypography.typography],
        colorScheme: ColorScheme.fromSeed(
          seedColor: appColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: appColors.white,
          titleTextStyle: AppTypography.typography.bodyLarge.copyWith(
            color: appColors.black,
            fontSize: 17,
          ),
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: appColors.white,
          labelTextStyle: WidgetStateProperty.resolveWith((
            Set<WidgetState> states,
          ) {
            final Color color = states.contains(WidgetState.selected)
                ? appColors.primary
                : appColors.black;
            return TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }),
        ),
        scaffoldBackgroundColor: appColors.white,
      );

  //Dark Theme
  static final dark = ThemeData.dark().copyWith(
    extensions: [appColors, AppTypography.typography],
    textTheme: TextTheme(
      bodyLarge: AppTypography.typography.bodyLarge.copyWith(
        color: Colors.white,
      ),
      bodyMedium: AppTypography.typography.bodyMedium.copyWith(
        color: Colors.white,
      ),
      bodySmall: AppTypography.typography.bodySmall.copyWith(
        color: Colors.white,
      ),
      displayLarge: AppTypography.typography.displayLarge.copyWith(
        color: Colors.white,
      ),
      displayMedium: AppTypography.typography.displayMedium.copyWith(
        color: Colors.white,
      ),
      displaySmall: AppTypography.typography.displaySmall.copyWith(
        color: Colors.white,
      ),
      labelLarge: AppTypography.typography.labelLarge.copyWith(
        color: Colors.white,
      ),
      labelMedium: AppTypography.typography.labelMedium.copyWith(
        color: Colors.white,
      ),
      labelSmall: AppTypography.typography.labelSmall.copyWith(
        color: Colors.white,
      ),
      headlineLarge: AppTypography.typography.headlineLarge.copyWith(
        color: Colors.white,
      ),
      headlineMedium: AppTypography.typography.headlineMedium.copyWith(
        color: Colors.white,
      ),
      headlineSmall: AppTypography.typography.headlineSmall.copyWith(
        color: Colors.white,
      ),
      titleLarge: AppTypography.typography.titleLarge.copyWith(
        color: Colors.white,
      ),
      titleMedium: AppTypography.typography.titleMedium.copyWith(
        color: Colors.white,
      ),
      titleSmall: AppTypography.typography.titleSmall.copyWith(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColors.primary,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: appColors.black,
      titleTextStyle: AppTypography.typography.bodyLarge.copyWith(
        color: appColors.white,
        fontSize: 17,
      ),
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: appColors.black,
      labelTextStyle: WidgetStateProperty.resolveWith((
        Set<WidgetState> states,
      ) {
        final Color color = states.contains(WidgetState.selected)
            ? appColors.primary
            : appColors.white;
        return TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        );
      }),
    ),
    scaffoldBackgroundColor: appColors.black,
  );
}

extension ColorThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColors get appColors => extension<AppColors>()!;
}

extension FontThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appTypography;
  AppTypography get appTypography => extension<AppTypography>()!;
}

extension ThemeGetter on BuildContext {
  // Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}
