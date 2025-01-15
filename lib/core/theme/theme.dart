import 'package:blog_app/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPalette.textGrey]) => OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: 2.5,
      ),
      borderRadius: BorderRadius.circular(10));
  static final lightThemeMode = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(backgroundColor: AppPalette.transparent),
      scaffoldBackgroundColor: AppPalette.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(24),
        enabledBorder: _border(),
        focusedBorder: _border(AppPalette.focusedColor),
      ));
}
