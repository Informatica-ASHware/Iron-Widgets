import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'iron_colors.dart';
import 'iron_dimens.dart';
import 'iron_text_styles.dart';

/// A [ThemeExtension] that carries the full Iron Widgets design token set.
///
/// ## Usage
///
/// ### Option A – standalone scope (recommended)
/// ```dart
/// IronWidgetsThemeScope(
///   child: MyScreen(),
/// )
/// ```
///
/// ### Option B – integrate with your MaterialApp
/// ```dart
/// MaterialApp(
///   theme: IronWidgetsTheme.defaults().buildMaterialTheme(),
/// )
/// ```
///
/// ### Override individual tokens
/// ```dart
/// IronWidgetsThemeScope(
///   theme: IronWidgetsTheme.defaults().copyWith(
///     baseStyleValue: TextStyle(fontSize: 12, color: Colors.white),
///   ),
///   child: MyScreen(),
/// )
/// ```
///
/// ## Without IronWidgetsTheme in tree
/// Every widget falls back to `IronWidgetsTheme.defaults()` automatically via
/// [resolveIronTheme], so no explicit setup is required.
@immutable
class IronWidgetsTheme extends ThemeExtension<IronWidgetsTheme> {
  /// Creates an [IronWidgetsTheme] with explicit values for every token.
  const IronWidgetsTheme({
    required this.darkRed,
    required this.gold,
    required this.darkGray,
    required this.baseStyleValue,
    required this.baseStyleLabel,
    required this.baseStyleTitle,
    required this.baseStylePercent,
    required this.microWidgetHeight,
    required this.microFontSize,
    required this.microIntWidth,
    required this.microValueWidth,
    required this.microPercentWidth,
    required this.valueBackground,
    required this.borderAccent,
    required this.dangerColor,
    required this.neutralSurface,
  });

  // ── Palette ──────────────────────────────────────────────────────────────

  /// Deep crimson.  Default: `0xFFB30000`.
  final Color darkRed;

  /// Arc-reactor gold.  Default: `0xFFFFD700`.
  final Color gold;

  /// Dark charcoal.  Default: `0xFF333333`.
  final Color darkGray;

  // ── Text styles ──────────────────────────────────────────────────────────

  /// Style for numeric / value cells.
  final TextStyle baseStyleValue;

  /// Style for label cells.
  final TextStyle baseStyleLabel;

  /// Style for section titles.
  final TextStyle baseStyleTitle;

  /// Style for percentage cells.
  final TextStyle baseStylePercent;

  // ── Dimension tokens ─────────────────────────────────────────────────────

  /// Height of a single micro-widget row.  Default: `20`.
  final double microWidgetHeight;

  /// Font size for micro-widget content.  Default: `10`.
  final double microFontSize;

  /// Width for integer cells.  Default: `20`.
  final double microIntWidth;

  /// Width for value cells.  Default: `60`.
  final double microValueWidth;

  /// Width for percentage cells.  Default: `60`.
  final double microPercentWidth;

  // ── Semantic roles ───────────────────────────────────────────────────────

  /// Background colour for value panels.  Defaults to [gold].
  final Color valueBackground;

  /// Border / accent colour.  Defaults to [gold].
  final Color borderAccent;

  /// Colour for danger / warning indicators.  Defaults to [darkRed].
  final Color dangerColor;

  /// Neutral surface colour.  Defaults to [darkGray].
  final Color neutralSurface;

  // ── Factory ───────────────────────────────────────────────────────────────

  /// Returns the canonical Iron Man default theme.
  factory IronWidgetsTheme.defaults() => const IronWidgetsTheme(
        darkRed: IronColors.darkRed,
        gold: IronColors.gold,
        darkGray: IronColors.darkGray,
        baseStyleValue: IronTextStyles.baseStyleValue,
        baseStyleLabel: IronTextStyles.baseStyleLabel,
        baseStyleTitle: IronTextStyles.baseStyleTitle,
        baseStylePercent: IronTextStyles.baseStylePercent,
        microWidgetHeight: IronDimens.microWidgetHeight,
        microFontSize: IronDimens.microFontSize,
        microIntWidth: IronDimens.microIntWidth,
        microValueWidth: IronDimens.microValueWidth,
        microPercentWidth: IronDimens.microPercentWidth,
        valueBackground: IronColors.gold,
        borderAccent: IronColors.gold,
        dangerColor: IronColors.darkRed,
        neutralSurface: IronColors.darkGray,
      );

  // ── Material theme builder ────────────────────────────────────────────────

  /// Generates a [ThemeData] that integrates this Iron theme into the entire
  /// Material widget tree.
  ///
  /// ```dart
  /// MaterialApp(
  ///   theme: IronWidgetsTheme.defaults().buildMaterialTheme(),
  ///   darkTheme: IronWidgetsTheme.defaults()
  ///       .buildMaterialTheme(brightness: Brightness.dark),
  /// )
  /// ```
  ThemeData buildMaterialTheme({Brightness brightness = Brightness.light}) {
    final isLight = brightness == Brightness.light;
    final surfaceColor = isLight ? Colors.white : darkGray;
    final onSurfaceColor = isLight ? Colors.black : Colors.white;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: darkRed,
        onPrimary: Colors.white,
        primaryContainer: darkRed.withAlpha(0x33),
        onPrimaryContainer: darkRed,
        secondary: gold,
        onSecondary: Colors.black,
        secondaryContainer: gold.withAlpha(0x33),
        onSecondaryContainer: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: onSurfaceColor,
        outline: gold,
      ),
      extensions: [this],
    );
  }

  // ── Accessibility helper ──────────────────────────────────────────────────

  /// Returns [Colors.black] or [Colors.white] depending on which passes AA
  /// contrast against [bg].
  Color textColorOn(Color bg) =>
      bg.computeLuminance() > 0.179 ? Colors.black : Colors.white;

  // ── ThemeExtension overrides ──────────────────────────────────────────────

  @override
  IronWidgetsTheme copyWith({
    Color? darkRed,
    Color? gold,
    Color? darkGray,
    TextStyle? baseStyleValue,
    TextStyle? baseStyleLabel,
    TextStyle? baseStyleTitle,
    TextStyle? baseStylePercent,
    double? microWidgetHeight,
    double? microFontSize,
    double? microIntWidth,
    double? microValueWidth,
    double? microPercentWidth,
    Color? valueBackground,
    Color? borderAccent,
    Color? dangerColor,
    Color? neutralSurface,
  }) =>
      IronWidgetsTheme(
        darkRed: darkRed ?? this.darkRed,
        gold: gold ?? this.gold,
        darkGray: darkGray ?? this.darkGray,
        baseStyleValue: baseStyleValue ?? this.baseStyleValue,
        baseStyleLabel: baseStyleLabel ?? this.baseStyleLabel,
        baseStyleTitle: baseStyleTitle ?? this.baseStyleTitle,
        baseStylePercent: baseStylePercent ?? this.baseStylePercent,
        microWidgetHeight: microWidgetHeight ?? this.microWidgetHeight,
        microFontSize: microFontSize ?? this.microFontSize,
        microIntWidth: microIntWidth ?? this.microIntWidth,
        microValueWidth: microValueWidth ?? this.microValueWidth,
        microPercentWidth: microPercentWidth ?? this.microPercentWidth,
        valueBackground: valueBackground ?? this.valueBackground,
        borderAccent: borderAccent ?? this.borderAccent,
        dangerColor: dangerColor ?? this.dangerColor,
        neutralSurface: neutralSurface ?? this.neutralSurface,
      );

  @override
  IronWidgetsTheme lerp(
    covariant ThemeExtension<IronWidgetsTheme>? other,
    double t,
  ) {
    if (other is! IronWidgetsTheme) return this;
    return IronWidgetsTheme(
      darkRed: Color.lerp(darkRed, other.darkRed, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      darkGray: Color.lerp(darkGray, other.darkGray, t)!,
      baseStyleValue: TextStyle.lerp(baseStyleValue, other.baseStyleValue, t)!,
      baseStyleLabel: TextStyle.lerp(baseStyleLabel, other.baseStyleLabel, t)!,
      baseStyleTitle: TextStyle.lerp(baseStyleTitle, other.baseStyleTitle, t)!,
      baseStylePercent:
          TextStyle.lerp(baseStylePercent, other.baseStylePercent, t)!,
      microWidgetHeight:
          lerpDouble(microWidgetHeight, other.microWidgetHeight, t)!,
      microFontSize: lerpDouble(microFontSize, other.microFontSize, t)!,
      microIntWidth: lerpDouble(microIntWidth, other.microIntWidth, t)!,
      microValueWidth: lerpDouble(microValueWidth, other.microValueWidth, t)!,
      microPercentWidth:
          lerpDouble(microPercentWidth, other.microPercentWidth, t)!,
      valueBackground: Color.lerp(valueBackground, other.valueBackground, t)!,
      borderAccent: Color.lerp(borderAccent, other.borderAccent, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      neutralSurface: Color.lerp(neutralSurface, other.neutralSurface, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IronWidgetsTheme &&
        other.darkRed == darkRed &&
        other.gold == gold &&
        other.darkGray == darkGray &&
        other.baseStyleValue == baseStyleValue &&
        other.baseStyleLabel == baseStyleLabel &&
        other.baseStyleTitle == baseStyleTitle &&
        other.baseStylePercent == baseStylePercent &&
        other.microWidgetHeight == microWidgetHeight &&
        other.microFontSize == microFontSize &&
        other.microIntWidth == microIntWidth &&
        other.microValueWidth == microValueWidth &&
        other.microPercentWidth == microPercentWidth &&
        other.valueBackground == valueBackground &&
        other.borderAccent == borderAccent &&
        other.dangerColor == dangerColor &&
        other.neutralSurface == neutralSurface;
  }

  @override
  int get hashCode => Object.hash(
        darkRed,
        gold,
        darkGray,
        baseStyleValue,
        baseStyleLabel,
        baseStyleTitle,
        baseStylePercent,
        microWidgetHeight,
        microFontSize,
        microIntWidth,
        microValueWidth,
        microPercentWidth,
        valueBackground,
        borderAccent,
        dangerColor,
        neutralSurface,
      );
}
