import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../internal/iron_dropdown_overlay.dart';
import '../vendor/flutter_custom_selector/widget/flutter_single_select.dart';
import 'iron_select_mode.dart';

/// A single-select picker optimised for enum-like types.
///
/// Migrated from the legacy `Enum<T>` StatefulWidget.
///
/// Semantically identical to [IronSelect] but assumes [T] is one of a closed
/// set of values (e.g. a Dart `enum`).  Unlike [IronSelect], [value] is
/// non-nullable because an enum always has a current state.
///
/// ## Presentation modes (US-2.03)
/// [mode] selects between the legacy modal bottom sheet (default) and the
/// anchored dropdown introduced in US-2.02, or resolves automatically per
/// platform with [IronSelectMode.adaptive]. The dropdown supports full
/// keyboard navigation and an optional inline [searchable] filter; the
/// current [value] is marked with a gold check. `cancelButtonText` does
/// not apply in dropdown mode (tapping an option selects and closes).
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// The bottom-sheet picker uses Material default colours and the trigger
/// adopts the ambient [ThemeData] decoration. The dropdown trigger and
/// menu are fully token-driven (`surfaceElevated`, `borderAccent`,
/// `cornerRadius`, `overlayMaxHeight`, `gold`), falling back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// enum Mode { idle, active, turbo }
///
/// IronEnum<Mode>(
///   title: 'Mode',
///   label: 'Mode',
///   mode: IronSelectMode.adaptive,
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
  State<IronEnum<T>> createState() => _IronEnumState<T>();
}

class _IronEnumState<T> extends State<IronEnum<T>> {
  late T _value;

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
