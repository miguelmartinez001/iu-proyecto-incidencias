import 'package:flutter/material.dart';

ThemeData getLightTheme() {
  const colorScheme = ColorScheme.light(
    primary: Color(0xFF01A274),
    onPrimary: Colors.white,
    secondary: Color(0xFF1D293E),
    onSecondary: Colors.white,
    error: Color(0xFFDA3734),
    onError: Colors.white,
    errorContainer: Color(0xFFFFE0E2),
    onErrorContainer: Color(0xFFDA3734),
    surface: Color(0xFFFEFFFE),
    onSurface: Color(0xFF1D293E),
  );

  return ThemeData.light().copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: const Color.fromARGB(255, 247, 249, 252),
    canvasColor: const Color.fromARGB(255, 247, 249, 252),
  );
}
