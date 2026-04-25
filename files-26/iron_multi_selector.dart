import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';
import '../vendor/flutter_custom_selector/flutter_custom_selector.dart';

/// A multi-select widget that displays selected items as [FilterChip]s and
/// opens a bottom-sheet for selection.
///
/// Migrated from the legacy `MultiSelector<T>` StatefulWidget.
///
/// ### Key differences from legacy
/// - Selected items render as Material 3 [FilterChip] widgets inside a [Wrap].
/// - Insertion order is preserved.
/// - `allOptionText`, `doneButtonText`, `cancelButtonText` are now wired to
///   the bottom-sheet picker (the legacy widget declared them but did not pass
///   them through).
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Chip selected colour resolves from `IronWidgetsTheme.dangerColor`.
///
/// ```dart
/// IronMultiSelector<String>(
///   title: 'Tags',
///   label: 'Tags',
///   value: _selected,
///   options: ['Flutter', 'Dart', 'Firebase'],
///   onChanged: (list) => setState(() => _selected = list),
/// )
/// ```
class IronMultiSelector<T> extends StatefulWidget {
  /// Creates an [IronMultiSelector].
  const IronMultiSelector({
    super.key,
    required this.title,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.height,
    this.width = 200,
    this.itemAsString,
    this.allOptionText = 'All',
    this.doneButtonText = 'Done',
    this.cancelButtonText = 'Cancel',
    this.semanticLabel,
  });

  /// Bottom-sheet header title.
  final String title;

  /// Label for the trigger button.
  final String label;

  /// Currently selected items.
  final List<T> value;

  /// All available options.
  final List<T> options;

  /// Called with the full new selection after the user confirms.
  final ValueChanged<List<T>> onChanged;

  /// Optional fixed height.
  final double? height;

  /// Width of the trigger area.
  final double width;

  /// Converts an option to its display string.  Falls back to [toString].
  final String Function(T)? itemAsString;

  /// Label for the "All" toggle row.
  final String allOptionText;

  /// Label for the done button.
  final String doneButtonText;

  /// Label for the cancel button.
  final String cancelButtonText;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  State<IronMultiSelector<T>> createState() => _IronMultiSelectorState<T>();
}

class _IronMultiSelectorState<T> extends State<IronMultiSelector<T>> {
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.value);
  }

  String _label(T item) =>
      widget.itemAsString?.call(item) ?? item.toString();

  Future<void> _openPicker() async {
    final dropdownItems = widget.options
        .map((item) => CustomMultiSelectDropdownItem<T>(item, _label(item)))
        .toList();

    final result = await CustomBottomSheetSelector<T>().customBottomSheet(
      buildContext: context,
      selectedItemColor: Colors.redAccent,
      initialSelection: _selected,
      buttonType: CustomDropdownButtonType.multiSelect,
      headerName: widget.title,
      dropdownItems: dropdownItems,
      isAllOptionEnable: true,
      allOptionText: widget.allOptionText,
      doneButtonText: widget.doneButtonText,
      cancelButtonText: widget.cancelButtonText,
    );

    if (!mounted) return;
    if (result[selectedList] != null) {
      final newSelection = List<T>.from(result[selectedList]!);
      setState(() => _selected = newSelection);
      widget.onChanged(newSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      button: true,
      child: Container(
        margin: const EdgeInsets.all(10),
        height: widget.height,
        width: widget.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Trigger ───────────────────────────────────────────────────
            OutlinedButton.icon(
              onPressed: _openPicker,
              icon: const Icon(Icons.keyboard_arrow_down_outlined),
              label: Text(widget.label),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.darkRed,
                side: BorderSide(color: theme.gold),
              ),
            ),
            // ── Chips ─────────────────────────────────────────────────────
            if (_selected.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _selected
                    .map(
                      (item) => FilterChip(
                        label: Text(_label(item)),
                        selected: true,
                        selectedColor: theme.dangerColor.withAlpha(0x33),
                        checkmarkColor: theme.dangerColor,
                        onSelected: (_) => _openPicker(),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
