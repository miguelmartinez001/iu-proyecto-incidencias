import 'package:flutter/material.dart';

ThemeData getDarkTheme() {
  const colorScheme = ColorScheme.dark(
    primary: Color(0xFF01A274),
    onPrimary: Colors.white,
    secondary: Color(0xFF1D293E),
    onSecondary: Colors.white,
    error: Color(0xFFDA3734),
    onError: Colors.white,
    errorContainer: Color(0xFF4A1010),
    onErrorContainer: Color(0xFFFFE0E2),
    surface: Color(0xFF1D293E),
    onSurface: Color(0xFFFEFFFE),
  );

  return ThemeData.dark().copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color(0xFF0B1120),
    canvasColor: const Color(0xFF0B1120),
  );
}
