import 'package:flutter/material.dart';

import '../vendor/flutter_custom_selector/flutter_custom_selector.dart';

/// A single-select dropdown optimised for enum-like types.
///
/// Migrated from the legacy `Enum<T>` StatefulWidget.
///
/// Semantically identical to [IronSelect] but assumes [T] is one of a closed
/// set of values (e.g. a Dart `enum`).  Unlike [IronSelect], [value] is
/// non-nullable because an enum always has a current state.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// The picker uses Material default colours. The trigger field adopts the
/// ambient [ThemeData] decoration.
///
/// ```dart
/// enum Mode { idle, active, turbo }
///
/// IronEnum<Mode>(
///   title: 'Mode',
///   label: 'Mode',
///   value: _mode,
///   options: Mode.values,
///   onChanged: (v) => setState(() => _mode = v),
///   itemAsString: (m) => m.name.toUpperCase(),
/// )
/// ```
class IronEnum<T> extends StatefulWidget {
  /// Creates an [IronEnum].
  const IronEnum({
    super.key,
    required this.title,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.height = 30,
    this.width = 200,
    this.itemAsString,
    this.cancelButtonText = 'Cancel',
    this.semanticLabel,
  });

  /// Bottom-sheet header title.
  final String title;

  /// Label shown in the trigger field.
  final String label;

  /// Current selected value (non-nullable).
  final T value;

  /// All possible values.
  final List<T> options;

  /// Called when the user confirms a selection.
  final ValueChanged<T> onChanged;

  /// Height of the trigger field.
  final double height;

  /// Width of the entire widget.
  final double width;

  /// Converts a value to its display string.  Falls back to [toString].
  final String Function(T)? itemAsString;

  /// Label for the cancel button.
  final String cancelButtonText;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  State<IronEnum<T>> createState() => _IronEnumState<T>();
}

class _IronEnumState<T> extends State<IronEnum<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) => Semantics(
        label: widget.semanticLabel ?? widget.label,
        button: true,
        child: Container(
          margin: const EdgeInsets.all(10),
          height: widget.height,
          width: widget.width,
          child: CustomSingleSelectField<T>(
            items: widget.options,
            title: widget.title,
            initialValue: _value,
            itemAsString: widget.itemAsString,
            cancelButtonText: widget.cancelButtonText,
            onSelectionDone: (value) {
              setState(() => _value = value);
              widget.onChanged(value);
            },
          ),
        ),
      );
}
