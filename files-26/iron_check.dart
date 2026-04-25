import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';
import 'iron_label.dart';

/// A labelled checkbox widget.
///
/// Migrated from the legacy `Check` StatefulWidget.  Converted to a fully
/// **controlled** [StatelessWidget]: the parent owns the [value] state and
/// must call [setState] in response to [onChanged].
///
/// ### Legacy change
/// The original widget stored `_value` locally without syncing to new
/// `widget.value` props.  [IronCheck] reads `value` directly so the checkbox
/// always reflects the parent's state.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Label colour resolves via [IronLabel], which uses the active theme.
///
/// ```dart
/// bool _agreed = false;
///
/// IronCheck(
///   label: 'I agree',
///   value: _agreed,
///   onChanged: (v) => setState(() => _agreed = v),
/// )
/// ```
class IronCheck extends StatelessWidget {
  /// Creates an [IronCheck].
  const IronCheck({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.width = 200,
    this.enabled = true,
    this.semanticLabel,
  });

  /// Label shown to the left of the checkbox.
  final String label;

  /// Current checked state.
  final bool value;

  /// Called when the user toggles the checkbox.
  final ValueChanged<bool> onChanged;

  /// Optional fixed width for the row.
  final double? width;

  /// When `false` the checkbox is greyed out and non-interactive.
  final bool enabled;

  /// Accessibility label override.  Defaults to [label].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    return Semantics(
      label: semanticLabel ?? label,
      checked: value,
      child: SizedBox(
        width: width,
        child: Row(
          children: [
            if (label.isNotEmpty) IronLabel(label),
            Checkbox(
              value: value,
              onChanged: enabled
                  ? (v) {
                      if (v != null) onChanged(v);
                    }
                  : null,
              activeColor: theme.dangerColor,
            ),
          ],
        ),
      ),
    );
  }
}
