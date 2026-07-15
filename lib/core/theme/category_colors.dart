import 'package:flutter/material.dart';

enum ReportCategory { bache, alumbrado, fuga, otro }

enum ReportStatus { recibido, enRevision, resuelto }

class CategoryColors {
  static const Color _orangeLight = Color(0xFFE17100);
  static const Color _greenTealLight = Color(0xFF029E72);
  static const Color _greenDarkLight = Color(0xFF007A55);
  static const Color _grayLight = Color(0xFF94A3B8);

  static const Color _orangeDark = Color(0xFFFDBA74);
  static const Color _greenTealDark = Color(0xFF5EEAD4);
  static const Color _greenDarkDark = Color(0xFF6EE7B7);
  static const Color _grayDark = Color(0xFFCBD5E1);

  static Color getColorForCategory(
    BuildContext context,
    ReportCategory category,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (category) {
      case ReportCategory.bache:
        return isDark ? _orangeDark : _orangeLight;
      case ReportCategory.alumbrado:
        return isDark ? _greenTealDark : _greenTealLight;
      case ReportCategory.fuga:
        return isDark ? _greenDarkDark : _greenDarkLight;
      case ReportCategory.otro:
        return isDark ? _grayDark : _grayLight;
    }
  }

  static Color getColorForStatus(BuildContext context, ReportStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case ReportStatus.resuelto:
        return isDark ? _greenDarkDark : _greenDarkLight;
      case ReportStatus.enRevision:
        return isDark ? _orangeDark : _orangeLight;
      case ReportStatus.recibido:
        return isDark ? _grayDark : _grayLight;
    }
  }
}
