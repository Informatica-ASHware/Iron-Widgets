import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../internal/iron_dropdown_overlay.dart';
import '../vendor/flutter_custom_selector/widget/flutter_single_select.dart';
import 'iron_select_mode.dart';

/// A single-select picker with two presentation modes.
///
/// Migrated from the legacy `Select<T>` StatefulWidget.
///
/// The legacy widget declared `allOptionText`, `doneButtonText`, and
/// `cancelButtonText` but never wired them to the underlying picker.
/// [IronSelect] correctly passes all three to the bottom sheet.
///
/// ## Presentation modes (US-2.02)
/// [mode] selects between the legacy modal bottom sheet (default) and a
/// desktop-friendly anchored dropdown, or resolves automatically per
/// platform with [IronSelectMode.adaptive]:
///
/// ```dart
/// IronSelect<String>(
///   mode: IronSelectMode.adaptive,
///   ...
/// )
/// ```
///
/// In dropdown mode the menu supports full keyboard navigation (arrows,
/// Enter, Escape, Home/End, prefix typeahead) and an optional inline
/// [searchable] filter. `doneButtonText` / `cancelButtonText` do not apply
/// (tapping an option selects and closes).
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// The bottom-sheet picker uses Material default colours and the trigger
/// adopts the ambient [ThemeData] decoration. The dropdown trigger and
/// menu are fully token-driven (`surfaceElevated`, `borderAccent`,
/// `cornerRadius`, `overlayMaxHeight`, `gold`), falling back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
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
    this.mode = IronSelectMode.bottomSheet,
    this.menuWidth,
    this.menuMaxHeight,
    this.searchable = false,
    this.enabled = true,
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

  /// Presentation mode. Defaults to [IronSelectMode.bottomSheet] for
  /// backward compatibility with the 1.x series.
  final IronSelectMode mode;

  /// Dropdown mode only: width of the anchored menu. Defaults to the
  /// trigger width.
  final double? menuWidth;

  /// Dropdown mode only: maximum menu height before internal scrolling.
  /// Defaults to the `overlayMaxHeight` theme token.
  final double? menuMaxHeight;

  /// Dropdown mode only: shows an inline filter field at the top of the
  /// menu (replaces prefix typeahead).
  final bool searchable;

  /// Whether the field accepts interaction. Applies to both modes.
  final bool enabled;

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

  void _handleSelected(T value) {
    setState(() => _value = value);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final useDropdown = ironDropdownForPlatform(
      widget.mode,
      platform: Theme.of(context).platform,
      isWeb: kIsWeb,
    );

    if (useDropdown) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: IronDropdownField<T>(
          options: widget.options,
          value: _value,
          itemAsString: widget.itemAsString,
          placeholder: widget.label,
          height: widget.height,
          width: widget.width,
          menuWidth: widget.menuWidth,
          menuMaxHeight: widget.menuMaxHeight,
          searchable: widget.searchable,
          enabled: widget.enabled,
          semanticLabel: widget.semanticLabel ?? widget.label,
          onSelected: _handleSelected,
        ),
      );
    }

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      button: true,
      enabled: widget.enabled,
      child: Container(
        margin: const EdgeInsets.all(10),
        height: widget.height,
        width: widget.width,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: Opacity(
            opacity: widget.enabled ? 1 : 0.55,
            child: CustomSingleSelectField<T>(
              items: widget.options,
              title: widget.title,
              initialValue: _value,
              itemAsString: widget.itemAsString,
              cancelButtonText: widget.cancelButtonText,
              onSelectionDone: _handleSelected,
            ),
          ),
        ),
      ),
    );
  }
}
