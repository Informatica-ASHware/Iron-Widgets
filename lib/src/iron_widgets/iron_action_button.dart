import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// Visual intent of an [IronActionButton].
enum IronActionVariant {
  /// Neutral primary action — `gold` fill.
  primary,

  /// Bullish / confirming action (e.g. "Add LONG") — `bullColor` fill.
  success,

  /// Bearish / destructive action (e.g. "Add SHORT") — `bearColor` fill.
  danger,
}

/// A large call-to-action button in the Finandy style — "Add SHORT",
/// "Close position", etc. (US-2.12).
///
/// [variant] maps to the semantic colour tokens (`gold` / `bullColor` /
/// `bearColor`) with automatic foreground contrast via
/// `IronWidgetsTheme.textColorOn`. An optional [sublabel] renders under
/// the label (e.g. the estimated order size) and [loading] swaps the
/// content for a spinner while suppressing taps. A `null` [onPressed]
/// disables the button.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Colours resolve from `gold` / `bullColor` / `bearColor` /
/// `neutralSurface` and corners from `cornerRadius`, falling back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// IronActionButton(
///   label: 'Add SHORT',
///   sublabel: '≈ 431.2 USDT',
///   variant: IronActionVariant.danger,
///   onPressed: _submit,
/// )
/// ```
class IronActionButton extends StatelessWidget {
  /// Creates an [IronActionButton].
  const IronActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = IronActionVariant.primary,
    this.sublabel,
    this.loading = false,
    this.width,
    this.height = 40,
    this.semanticLabel,
  });

  /// Main button text.
  final String label;

  /// Tap callback. `null` renders the button disabled.
  final VoidCallback? onPressed;

  /// Semantic colour of the action.
  final IronActionVariant variant;

  /// Secondary line under [label] (e.g. estimated size).
  final String? sublabel;

  /// Shows a spinner and suppresses taps while `true`.
  final bool loading;

  /// Fixed width. `null` shrinks to content; use `double.infinity` to
  /// fill the parent.
  final double? width;

  /// Button height.
  final double height;

  /// Accessibility label override. Defaults to [label] (+ [sublabel]).
  final String? semanticLabel;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    final Color background;
    if (!_enabled && !loading) {
      background = theme.neutralSurface;
    } else {
      background = switch (variant) {
        IronActionVariant.primary => theme.gold,
        IronActionVariant.success => theme.bullColor,
        IronActionVariant.danger => theme.bearColor,
      };
    }
    final foreground = _enabled || loading
        ? theme.textColorOn(background)
        : Colors.white38;

    final sub = sublabel;
    final Widget content;
    if (loading) {
      content = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
      );
    } else {
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.baseStyleValue.copyWith(
              color: foreground,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          if (sub != null)
            Text(
              sub,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.baseStyleValue.copyWith(
                color: foreground.withValues(alpha: 0.8),
              ),
            ),
        ],
      );
    }

    return Semantics(
      button: true,
      enabled: _enabled,
      label: semanticLabel ?? (sub == null ? label : '$label, $sub'),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(theme.cornerRadius),
        child: InkWell(
          onTap: _enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(theme.cornerRadius),
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: content,
          ),
        ),
      ),
    );
  }
}
