import 'package:flutter/material.dart';

import '../../../internal/theme_resolver.dart';

/// A compact text widget that right-aligns numeric content and left-aligns
/// everything else.
///
/// Migrated from the legacy `MiniText` StatefulWidget.  Converted to
/// [StatelessWidget] because no mutable state was required.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Font size defaults to `IronWidgetsTheme.microFontSize` (10 pt).
/// When no theme is in the tree, `IronWidgetsTheme.defaults()` is used.
///
/// ```dart
/// IronMiniText('1234.56')       // right-aligned (numeric)
/// IronMiniText('Revenue')       // left-aligned  (text)
/// IronMiniText('', width: 60)   // empty, left-aligned
/// ```
class IronMiniText extends StatelessWidget {
  /// Creates an [IronMiniText].
  const IronMiniText(
    this.text, {
    super.key,
    this.width,
    this.margin,
    this.fontSize,
    this.color,
    this.semanticLabel,
  });

  /// The string to display.
  final String text;

  /// Optional fixed width.
  final double? width;

  /// Uniform margin applied on all sides.
  final double? margin;

  /// Overrides the theme font size.
  final double? fontSize;

  /// Overrides the text colour.
  final Color? color;

  /// Accessibility label.  Defaults to [text].
  final String? semanticLabel;

  /// Returns [TextAlign.right] when [text] starts with a digit, minus, or dot.
  static TextAlign _alignFor(String text) {
    if (text.isEmpty) return TextAlign.left;
    return '-0123456789.'.contains(text[0])
        ? TextAlign.right
        : TextAlign.left;
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final effectiveFontSize = fontSize ?? theme.microFontSize;

    // Micro widgets use a fixed small font by design, but we honour the OS
    // text-scaling factor so users with accessibility needs are not locked out.
    final scaledFontSize =
        MediaQuery.textScalerOf(context).scale(effectiveFontSize);

    return Semantics(
      label: semanticLabel ?? text,
      child: Container(
        width: width,
        margin: margin == null ? null : EdgeInsets.all(margin!),
        child: Text(
          text,
          style: TextStyle(
            fontSize: scaledFontSize,
            color: color,
          ),
          textAlign: _alignFor(text),
        ),
      ),
    );
  }
}
