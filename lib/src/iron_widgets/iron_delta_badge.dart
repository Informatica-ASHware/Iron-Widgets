import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// A compact pill that displays a signed percentage change, coloured by
/// market direction (US-2.05).
///
/// Positive values use `bullColor`, negative values use `bearColor` and
/// exactly zero renders neutral (white-70 text on `neutralSurface`), so a
/// flat move never reads as a gain or a loss.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Colours resolve from `bullColor` / `bearColor` / `neutralSurface` and
/// the text style from `baseStylePercent`, falling back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// IronDeltaBadge(2.34)                 // +2.34 %
/// IronDeltaBadge(-1.2, precision: 1)   // -1.2 %
/// IronDeltaBadge(5.0, suffix: ' USDT', showSign: false)
/// ```
class IronDeltaBadge extends StatelessWidget {
  /// Creates an [IronDeltaBadge] for [value].
  const IronDeltaBadge(
    this.value, {
    super.key,
    this.precision = 2,
    this.showSign = true,
    this.suffix = '%',
    this.semanticLabel,
  }) : assert(precision >= 0, 'precision must be >= 0.');

  /// Signed change to display (typically a percentage).
  final double value;

  /// Number of decimal digits.
  final int precision;

  /// Whether to prefix positive values with `+` (negative values always
  /// carry their `-` sign).
  final bool showSign;

  /// Unit appended to the number. Defaults to `%`.
  final String suffix;

  /// Accessibility label override. Defaults to the rendered text.
  final String? semanticLabel;

  String get _text {
    final sign = showSign && value > 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(precision)}$suffix';
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    final Color foreground;
    final Color background;
    if (value > 0) {
      foreground = theme.bullColor;
      background = theme.bullColor.withValues(alpha: 0.16);
    } else if (value < 0) {
      foreground = theme.bearColor;
      background = theme.bearColor.withValues(alpha: 0.16);
    } else {
      foreground = Colors.white70;
      background = theme.neutralSurface;
    }

    return Semantics(
      label: semanticLabel ?? _text,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(theme.cornerRadius),
        ),
        child: Text(
          _text,
          maxLines: 1,
          style: theme.baseStylePercent.copyWith(color: foreground),
        ),
      ),
    );
  }
}
