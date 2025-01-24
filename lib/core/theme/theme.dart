import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static _border([Color color = AppPalette.textGrey]) => OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2.5,
      ),
      borderRadius: BorderRadius.circular(10));
      
  static final lightThemeMode = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppPalette.transparent,
        surfaceTintColor: AppPalette.transparent,
      ),
      textTheme: GoogleFonts.montserratTextTheme(TextTheme(
        displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppPalette.focusedColor), // Main headings
        displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppPalette.focusedColor),
        // Sub-headings
        bodyLarge: TextStyle(
            fontSize: 16, color: AppPalette.focusedColor), // Content text
        bodySmall: TextStyle(fontSize: 14, color: AppPalette.focusedColor),
      )),
      scaffoldBackgroundColor: AppPalette.backgroundColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 1,
        backgroundColor: AppPalette.secondaryColor.withAlpha(150),
      ),
      chipTheme: ChipThemeData(
          color: WidgetStateProperty.all(
            AppPalette.backgroundColor,
          ),
          side: BorderSide.none),
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(24),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(AppPalette.focusedColor),
          errorBorder: _border(AppPalette.error)));
}
