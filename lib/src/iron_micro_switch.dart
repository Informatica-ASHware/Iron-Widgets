import 'package:flutter/material.dart';

import 'internal/theme_resolver.dart';

/// A compact toggle button styled with the Iron Man palette.
///
/// Renamed from the legacy `WMicroSwitch` (prefix `W` → `Iron`).
/// Converted to a fully **controlled** [StatelessWidget]: the global
/// `addRefreshLotWidget` / `wSil` refresh mechanism has been removed.
/// The parent owns [value] state and rebuilds via [onChanged].
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Active state: gold background, darkRed text.
/// Inactive state: white background, darkGray text.
/// Both colours resolve from the active [IronWidgetsTheme].
///
/// ```dart
/// bool _active = false;
///
/// IronMicroSwitch(
///   text: 'HUD',
///   value: _active,
///   onChanged: (v) => setState(() => _active = v),
/// )
/// ```
class IronMicroSwitch extends StatelessWidget {
  /// Creates an [IronMicroSwitch].
  const IronMicroSwitch({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
    this.width = 58,
    this.height = 22,
    this.message = '',
    this.enabled = true,
    this.semanticLabel,
  });

  /// Button label.
  final String text;

  /// Optional tooltip message shown on long-press.
  final String message;

  /// Current toggle state.
  final bool value;

  /// Called when the user taps the switch.
  final ValueChanged<bool> onChanged;

  /// Width of the button.
  final double width;

  /// Height of the button.
  final double height;

  /// When `false`, the button is greyed and non-interactive.
  final bool enabled;

  /// Accessibility label override.  Defaults to [text].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    final activeColor = enabled ? theme.gold : Colors.grey.shade300;
    final borderColor = enabled ? theme.gold : Colors.grey;
    final textColor = enabled
        ? (value ? theme.darkRed : theme.darkGray)
        : Colors.grey;

    Widget child = Semantics(
      label: semanticLabel ?? text,
      toggled: value,
      button: true,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? () => onChanged(!value) : null,
        child: Container(
          width: width,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: value ? activeColor : Colors.white,
            border: Border.all(color: borderColor),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    if (message.isNotEmpty) {
      child = Tooltip(message: message, child: child);
    }

    return child;
  }
}
