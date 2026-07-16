import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;

  ThemeData get themeData => AppThemeData.getTheme(_currentTheme);

  void updateTheme(AppTheme newTheme) {
    if (_currentTheme == newTheme) return;
    _currentTheme = newTheme;
    notifyListeners();
  }
}
