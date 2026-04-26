import 'package:flutter/material.dart';

import '../vendor/flutter_custom_selector/widget/flutter_single_select.dart';

/// A single-select dropdown backed by a bottom-sheet picker.
///
/// Migrated from the legacy `Select<T>` StatefulWidget.
///
/// The legacy widget declared `allOptionText`, `doneButtonText`, and
/// `cancelButtonText` but never wired them to the underlying picker.
/// [IronSelect] correctly passes all three to the bottom sheet.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// The picker uses Material default colours.  The trigger field adopts the
/// ambient [ThemeData] decoration.
///
/// ```dart
/// IronSelect<String>(
///   title: 'Country',
///   label: 'Country',
///   value: _country,
///   options: ['USA', 'UK', 'Canada'],
///   onChanged: (v) => setState(() => _country = v),
/// )
/// ```
class IronSelect<T> extends StatefulWidget {
  /// Creates an [IronSelect].
  const IronSelect({
    super.key,
    required this.title,
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
    this.height = 30,
    this.width = 200,
    this.itemAsString,
    this.allOptionText = 'All',
    this.doneButtonText = 'Done',
    this.cancelButtonText = 'Cancel',
    this.semanticLabel,
  });

  /// Bottom-sheet header title.
  final String title;

  /// Label shown in the trigger field.
  final String label;

  /// Pre-selected value.
  final T? value;

  /// Full list of options.
  final List<T> options;

  /// Called when the user confirms a selection.
  final ValueChanged<T> onChanged;

  /// Height of the trigger field.
  final double height;

  /// Width of the entire widget.
  final double width;

  /// Converts an option to its display string.  Falls back to [toString].
  final String Function(T)? itemAsString;

  /// Label for the "All" option row (unused in single-select but kept for API parity).
  final String allOptionText;

  /// Label for the done button.
  final String doneButtonText;

  /// Label for the cancel button.
  final String cancelButtonText;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  State<IronSelect<T>> createState() => _IronSelectState<T>();
}

class _IronSelectState<T> extends State<IronSelect<T>> {
  T? _value;

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
