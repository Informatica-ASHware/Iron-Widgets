/// Dimension tokens for micro-widgets.
///
/// Migrated from mutable top-level variables in `widgets_shows.dart`.
/// All values are package defaults overridable via [IronWidgetsTheme].
abstract final class IronDimens {
  IronDimens._();

  /// Height of a single micro-widget row.  Legacy: `height = 20`.
  static const double microWidgetHeight = 20;

  /// Base font size for micro-widget text.  Legacy: `fontSize = 10`.
  static const double microFontSize = 10;

  /// Column width for integer display cells.  Legacy: `widthInt = 20`.
  static const double microIntWidth = 20;

  /// Column width for value display cells.  Legacy: `widthValue = 60`.
  static const double microValueWidth = 60;

  /// Column width for percentage display cells.  Legacy: `widthPercent = 60`.
  static const double microPercentWidth = 60;
}
