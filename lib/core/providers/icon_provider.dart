import 'package:flutter/material.dart';

enum AppIconSet { lucide, animated, threeD }

class IconProvider extends ChangeNotifier {
  AppIconSet _currentIconSet = AppIconSet.lucide;

  AppIconSet get currentIconSet => _currentIconSet;

  void updateIconSet(AppIconSet newIconSet) {
    if (_currentIconSet == newIconSet) return;
    _currentIconSet = newIconSet;
    notifyListeners();
  }
}
