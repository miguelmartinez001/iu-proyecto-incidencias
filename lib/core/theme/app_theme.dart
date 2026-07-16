import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

enum AppTheme { light, dark, highContrast, neon }

class AppThemeData {
  static ThemeData getTheme(AppTheme theme) {
    switch (theme) {
      case AppTheme.light:
        return getLightTheme();
      case AppTheme.dark:
        return getDarkTheme();
      case AppTheme.highContrast:
      case AppTheme.neon:
        return getLightTheme();
    }
  }
}
