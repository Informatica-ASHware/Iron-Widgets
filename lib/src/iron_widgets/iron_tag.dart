import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// Visual intent of an [IronTag].
enum IronTagVariant {
  /// Accent tag — `gold` tint.
  gold,

  /// Bullish tag (e.g. `LONG`) — `bullColor` tint.
  bull,

  /// Bearish tag (e.g. `SHORT`) — `bearColor` tint.
  bear,

  /// Informational tag (e.g. `Isol ×20`, `PERP`) — neutral surface.
  neutral,
}

/// A mini chip for position metadata — `SHORT`, `Isol ×20`, `PERP`, etc.
/// (US-2.13).
///
/// Coloured variants render a tinted background with a matching hairline
/// border and coloured text; [IronTagVariant.neutral] sits quietly on
/// `surfaceElevated`. Smaller corner radius than [IronDeltaBadge] so the
/// two read as different species at a glance.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Colours resolve from `gold` / `bullColor` / `bearColor` /
/// `surfaceElevated` / `borderAccent` and text from `baseStylePercent`,
/// falling back to [IronWidgetsTheme.defaults] when no theme is in the
/// tree.
///
/// ```dart
/// IronTag('SHORT', variant: IronTagVariant.bear)
/// IronTag('Isol ×20')
/// IronTag('PERP')
/// ```
class IronTag extends StatelessWidget {
  /// Creates an [IronTag] for [text].
  const IronTag(
    this.text, {
    super.key,
    this.variant = IronTagVariant.neutral,
    this.semanticLabel,
  });

  /// Tag content.
  final String text;

  /// Semantic colour of the tag.
  final IronTagVariant variant;

  /// Accessibility label override. Defaults to [text].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    final Color background;
    final Color border;
    final Color foreground;
    switch (variant) {
      case IronTagVariant.gold:
        background = theme.gold.withValues(alpha: 0.18);
        border = theme.gold.withValues(alpha: 0.55);
        foreground = theme.gold;
      case IronTagVariant.bull:
        background = theme.bullColor.withValues(alpha: 0.18);
        border = theme.bullColor.withValues(alpha: 0.55);
        foreground = theme.bullColor;
      case IronTagVariant.bear:
        background = theme.bearColor.withValues(alpha: 0.18);
        border = theme.bearColor.withValues(alpha: 0.55);
        foreground = theme.bearColor;
      case IronTagVariant.neutral:
        background = theme.surfaceElevated;
        border = theme.borderAccent.withValues(alpha: 0.35);
        foreground = Colors.white70;
    }

    return Semantics(
      label: semanticLabel ?? text,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(theme.cornerRadius / 2),
          border: Border.all(color: border),
        ),
        child: Text(
          text,
          maxLines: 1,
          style: theme.baseStylePercent.copyWith(color: foreground),
        ),
      ),
    );
  }
}
