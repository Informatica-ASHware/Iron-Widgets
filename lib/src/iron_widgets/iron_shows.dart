import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';
import 'iron_micro_editor.dart';

/// A single-row label/value display cell.
///
/// Migrated from the legacy top-level `show()` function.
///
/// Width, height, and text styles resolve from the active [IronWidgetsTheme].
/// When [editable] is `true`, the value area becomes an [IronMicroEditor].
///
/// ```dart
/// Show(label: 'Price', value: '12.50')
/// Show(label: 'Qty', value: '3', editable: true, onChanged: (v) { … })
/// ```
class Show extends StatelessWidget {
  /// Creates a [Show] cell.
  const Show({
    super.key,
    required this.label,
    required this.value,
    this.editable = false,
    this.onChanged,
    this.semanticLabel,
  });

  /// Left-side label text.
  final String label;

  /// Right-side value text.
  final String value;

  /// When `true` renders an editable [IronMicroEditor] instead of plain text.
  final bool editable;

  /// Called when the user edits the value (requires [editable] = `true`).
  final ValueChanged<String>? onChanged;

  /// Accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    final Widget valueWidget = editable
        ? IronMicroEditor(
            initialValue: value,
            onChanged: onChanged ?? (_) {},
            width: 40,
            height: 14,
          )
        : Text(value, style: theme.baseStyleValue);

    return Semantics(
      label: semanticLabel ?? '$label $value',
      child: Container(
        width: theme.microValueWidth,
        height: theme.microWidgetHeight,
        color: Colors.white,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.baseStyleLabel),
            valueWidget,
          ],
        ),
      ),
    );
  }
}

/// A two-row panel showing a pair of label/value cells stacked vertically.
///
/// Migrated from the legacy `showValuesColumn()` function.
///
/// Background colour defaults to `IronWidgetsTheme.valueBackground` (gold).
///
/// ```dart
/// ShowValuesColumn(
///   topLabel: 'Open', topValue: '142.30',
///   bottomLabel: 'Close', bottomValue: '139.80',
/// )
/// ```
class ShowValuesColumn extends StatelessWidget {
  /// Creates a [ShowValuesColumn].
  const ShowValuesColumn({
    super.key,
    required this.topLabel,
    required this.topValue,
    required this.bottomLabel,
    required this.bottomValue,
    this.background,
    this.editable = false,
    this.onTopChanged,
    this.onBottomChanged,
    this.semanticLabel,
  });

  /// Label for the top row.
  final String topLabel;

  /// Value for the top row.
  final String topValue;

  /// Label for the bottom row.
  final String bottomLabel;

  /// Value for the bottom row.
  final String bottomValue;

  /// Background colour.  Defaults to `IronWidgetsTheme.valueBackground`.
  final Color? background;

  /// When `true`, both rows become editable.
  final bool editable;

  /// Called when the top value changes.
  final ValueChanged<String>? onTopChanged;

  /// Called when the bottom value changes.
  final ValueChanged<String>? onBottomChanged;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    return Semantics(
      label: semanticLabel ?? '$topLabel/$bottomLabel column',
      child: ColoredBox(
        color: background ?? theme.valueBackground,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Show(
              label: topLabel,
              value: topValue,
              editable: editable,
              onChanged: onTopChanged,
            ),
            Show(
              label: bottomLabel,
              value: bottomValue,
              editable: editable,
              onChanged: onBottomChanged,
            ),
          ],
        ),
      ),
    );
  }
}

/// A two-row panel showing a pair of label/percentage cells stacked vertically.
///
/// Migrated from the legacy `showPercColumn()` function.
///
/// Automatically appends `%` to the value strings.
///
/// ```dart
/// ShowPercColumn(
///   topLabel: 'Win', topValue: '62',
///   bottomLabel: 'Loss', bottomValue: '38',
/// )
/// ```
class ShowPercColumn extends StatelessWidget {
  /// Creates a [ShowPercColumn].
  const ShowPercColumn({
    super.key,
    required this.topLabel,
    required this.topValue,
    required this.bottomLabel,
    required this.bottomValue,
    this.background,
    this.editable = false,
    this.onTopChanged,
    this.onBottomChanged,
    this.semanticLabel,
  });

  /// Label for the top row.
  final String topLabel;

  /// Numeric string for the top row (shown as `value%`).
  final String topValue;

  /// Label for the bottom row.
  final String bottomLabel;

  /// Numeric string for the bottom row (shown as `value%`).
  final String bottomValue;

  /// Background colour.  Defaults to `IronWidgetsTheme.valueBackground`.
  final Color? background;

  /// When `true`, both rows become editable.
  final bool editable;

  /// Called when the top percentage changes.
  final ValueChanged<String>? onTopChanged;

  /// Called when the bottom percentage changes.
  final ValueChanged<String>? onBottomChanged;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    return Semantics(
      label: semanticLabel ?? '$topLabel/$bottomLabel percent column',
      child: ColoredBox(
        color: background ?? theme.valueBackground,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Show(
              label: topLabel,
              value: '$topValue%',
              editable: editable,
              onChanged: onTopChanged,
            ),
            Show(
              label: bottomLabel,
              value: '$bottomValue%',
              editable: editable,
              onChanged: onBottomChanged,
            ),
          ],
        ),
      ),
    );
  }
}
