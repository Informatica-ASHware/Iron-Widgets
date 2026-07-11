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

  /// Bullish / upward market direction (teal-green).
  ///
  /// Introduced in US-2.01 for market-direction widgets. Distinct from
  /// [gold] (accent) and from danger semantics: it encodes *direction*,
  /// not severity.
  static const Color bull = Color(0xFF26A69A);

  /// Bearish / downward market direction (soft red).
  ///
  /// Introduced in US-2.01. Intentionally different from [darkRed]
  /// ([IronWidgetsTheme.dangerColor]): bearish is a market direction,
  /// not a destructive action.
  static const Color bear = Color(0xFFEF5350);

  /// Elevated surface for overlays, panels and menus.
  ///
  /// [darkGray] lightened ≈ 8 % so floating layers read as raised against
  /// the base surface. Introduced in US-2.01.
  static const Color surfaceElevated = Color(0xFF474747);
}
