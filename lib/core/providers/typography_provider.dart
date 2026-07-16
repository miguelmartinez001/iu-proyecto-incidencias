import 'package:flutter/material.dart';

enum AppFontSize { small, normal, large, extraLarge }

class TypographyProvider extends ChangeNotifier {
  AppFontSize _currentFontSize = AppFontSize.normal;

  AppFontSize get currentFontSize => _currentFontSize;

  void updateFontSize(AppFontSize newFontSize) {
    if (_currentFontSize == newFontSize) return;
    _currentFontSize = newFontSize;
    notifyListeners();
  }
}
