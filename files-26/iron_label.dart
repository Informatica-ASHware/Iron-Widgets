import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// A bold, themed label commonly paired with form fields.
///
/// Migrated from the legacy `Label` StatefulWidget.  Converted to
/// [StatelessWidget] because no mutable state was required.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Colour resolves to `IronWidgetsTheme.darkRed` when [IronWidgetsTheme] is
/// in the tree, falling back to the default palette otherwise.
///
/// ```dart
/// IronLabel('Voltage')              // "Voltage:"
/// IronLabel('Name', colon: false)   // "Name"
/// IronLabel('Size', width: 80)      // fixed-width label
/// ```
class IronLabel extends StatelessWidget {
  /// Creates an [IronLabel].
  const IronLabel(
    this.text, {
    super.key,
    this.width,
    this.colon = true,
    this.semanticLabel,
  });

  /// The label text.
  final String text;

  /// Optional fixed width.
  final double? width;

  /// When `true` (default), appends a colon after [text].
  final bool colon;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final display = colon ? '$text:' : text;

    return Semantics(
      label: semanticLabel ?? text,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: width,
        child: Text(
          display,
          style: TextStyle(
            color: theme.darkRed,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
