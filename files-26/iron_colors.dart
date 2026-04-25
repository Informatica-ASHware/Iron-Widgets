import 'package:flutter/painting.dart';

/// Iron Man–inspired colour palette used by [IronWidgetsTheme].
///
/// These constants are the **canonical defaults**. Override any colour by
/// providing a custom [IronWidgetsTheme] via [IronWidgetsThemeScope].
abstract final class IronColors {
  IronColors._();

  /// Deep crimson used for danger indicators and primary accents.
  ///
  /// Migrated from `app_colors.dart` legacy constant `darkRed`.
  static const Color darkRed = Color(0xFFB30000);

  /// Arc-reactor gold used for backgrounds and highlight borders.
  ///
  /// Migrated from `app_colors.dart` legacy constant `gold`.
  static const Color gold = Color(0xFFFFD700);

  /// Dark charcoal used for neutral surfaces and disabled text.
  ///
  /// Migrated from `app_colors.dart` legacy constant `darkGray`.
  static const Color darkGray = Color(0xFF333333);
}
