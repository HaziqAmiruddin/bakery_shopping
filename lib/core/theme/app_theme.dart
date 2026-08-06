import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/core/theme/colors_list.dart';
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
}
