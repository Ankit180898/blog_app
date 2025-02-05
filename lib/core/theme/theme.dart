import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Constants for repeated values
  static const double _defaultBorderRadius = 10;
  static const double _defaultBorderWidth = 2.5;
  static const EdgeInsets _defaultPadding = EdgeInsets.all(24);

  // Reusable border method
  static OutlineInputBorder _border([Color color = AppPalette.textGrey]) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: _defaultBorderWidth,
      ),
      borderRadius: BorderRadius.circular(_defaultBorderRadius),
    );
  }

  // TextTheme for consistent typography
  static TextTheme _textTheme() {
    return GoogleFonts.montserratTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppPalette.focusedColor,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppPalette.focusedColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppPalette.focusedColor,
        ),
        bodySmall: TextStyle(
          fontSize: 14,
          color: AppPalette.focusedColor,
        ),
      ),
    );
  }

  // AppBarTheme for consistent app bars
  static AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      backgroundColor: AppPalette.transparent,
      surfaceTintColor: AppPalette.transparent,
    );
  }

  // DrawerTheme for consistent drawers
  static DrawerThemeData _drawerTheme() {
    return const DrawerThemeData(
      elevation: 0,
      backgroundColor: AppPalette.backgroundColor,
    );
  }

  // PopupMenuTheme for consistent popup menus
  static PopupMenuThemeData _popupMenuTheme() {
    return PopupMenuThemeData(
      color: AppPalette.backgroundColor,
      textStyle: TextStyle(
        color: AppPalette.focusedColor,
      ),
    );
  }

  // FloatingActionButtonTheme for consistent FABs
  static FloatingActionButtonThemeData _floatingActionButtonTheme() {
    return FloatingActionButtonThemeData(
      elevation: 1,
      backgroundColor: AppPalette.secondaryColor.withAlpha(150),
    );
  }

  // ChipTheme for consistent chips
  static ChipThemeData _chipTheme() {
    return ChipThemeData(
      color: WidgetStateProperty.all(
        AppPalette.backgroundColor,
      ),
      side: BorderSide.none,
    );
  }

  // InputDecorationTheme for consistent input fields
  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      contentPadding: _defaultPadding,
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppPalette.focusedColor),
      errorBorder: _border(AppPalette.error),
    );
  }

  // Light Theme
  static final lightThemeMode = ThemeData.light().copyWith(
    appBarTheme: _appBarTheme(),
    drawerTheme: _drawerTheme(),
    popupMenuTheme: _popupMenuTheme(),
    textTheme: _textTheme(),
    scaffoldBackgroundColor: AppPalette.backgroundColor,
    floatingActionButtonTheme: _floatingActionButtonTheme(),
    chipTheme: _chipTheme(),
    inputDecorationTheme: _inputDecorationTheme(),
  );

  // Dark Theme
  static final darkThemeMode = ThemeData.dark().copyWith(
    appBarTheme: _appBarTheme(),
    drawerTheme: _drawerTheme(),
    popupMenuTheme: _popupMenuTheme(),
    textTheme: _textTheme().copyWith(
      displayLarge: const TextStyle(color: AppPalette.whiteColor),
      displayMedium: const TextStyle(color: AppPalette.whiteColor),
      bodyLarge: const TextStyle(color: AppPalette.whiteColor),
      bodySmall: const TextStyle(color: AppPalette.whiteColor),
    ),
    scaffoldBackgroundColor: AppPalette.focusedColor,
    floatingActionButtonTheme: _floatingActionButtonTheme(),
    chipTheme: _chipTheme(),
    inputDecorationTheme: _inputDecorationTheme(),
    progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppPalette.secondaryColor,
        circularTrackColor: AppPalette.secondaryColor.withAlpha(20)),
  );
}
