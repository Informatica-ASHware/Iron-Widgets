import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../internal/iron_dropdown_overlay.dart';
import '../internal/theme_resolver.dart';
import '../vendor/flutter_custom_selector/utils/enum.dart';
import '../vendor/flutter_custom_selector/utils/flutter_custom_select_item.dart';
import '../vendor/flutter_custom_selector/utils/utils.dart';
import '../vendor/flutter_custom_selector/widget/flutter_custom_selector_sheet.dart';
import 'iron_select_mode.dart';

/// A multi-select widget with two presentation modes.
///
/// Migrated from the legacy `MultiSelector<T>` StatefulWidget.
///
/// ### Key differences from legacy
/// - Selected items render as Material 3 [FilterChip] widgets inside a [Wrap]
///   (bottom-sheet mode).
/// - Insertion order is preserved.
/// - `allOptionText`, `doneButtonText`, `cancelButtonText` are now wired to
///   the bottom-sheet picker (the legacy widget declared them but did not pass
///   them through).
///
/// ## Presentation modes (US-2.04)
/// [mode] selects between the legacy modal bottom sheet (default) and the
/// anchored dropdown introduced in US-2.02, or resolves automatically per
/// platform with [IronSelectMode.adaptive]. In dropdown mode:
///
/// - Rows show an Iron-style checkbox and toggling **applies immediately**
///   (every toggle fires [onChanged]; there is no Done step, so
///   `doneButtonText` / `cancelButtonText` do not apply).
/// - The panel stays open while toggling; it closes on outside tap, `Esc`,
///   focus loss or ancestor scroll.
/// - An [allOptionText] row toggles the whole set (hidden while a search
///   query is active).
/// - The compact trigger shows a selection summary instead of chips: the
///   single item's label when one is selected, otherwise `'n selected'`
///   (customisable via [summaryBuilder]).
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Chip and checkbox selected colour resolve from
/// `IronWidgetsTheme.dangerColor`; the dropdown surface uses
/// `surfaceElevated`, `borderAccent`, `cornerRadius` and
/// `overlayMaxHeight`, falling back to [IronWidgetsTheme.defaults] when no
/// theme is in the tree.
///
/// ```dart
/// IronMultiSelector<String>(
///   title: 'Tags',
///   label: 'Tags',
///   mode: IronSelectMode.adaptive,
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
    this.mode = IronSelectMode.bottomSheet,
    this.menuWidth,
    this.menuMaxHeight,
    this.searchable = false,
    this.enabled = true,
    this.summaryBuilder,
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
  /// menu.
  final bool searchable;

  /// Whether the field accepts interaction. Applies to both modes.
  final bool enabled;

  /// Dropdown mode only: builds the trigger summary from the current
  /// selection (called only when it is non-empty). Defaults to the single
  /// item's label when one is selected, otherwise `'n selected'`.
  final String Function(List<T> selected)? summaryBuilder;

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

  String _label(T item) => widget.itemAsString?.call(item) ?? item.toString();

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

  void _toggle(T option) {
    setState(() {
      if (_selected.contains(option)) {
        _selected.remove(option);
      } else {
        _selected.add(option);
      }
    });
    widget.onChanged(List<T>.from(_selected));
  }

  void _toggleAll() {
    setState(() {
      if (_selected.length == widget.options.length) {
        _selected.clear();
      } else {
        _selected = List<T>.from(widget.options);
      }
    });
    widget.onChanged(List<T>.from(_selected));
  }

  String? _summary() {
    if (_selected.isEmpty) return null;
    if (widget.summaryBuilder != null) {
      return widget.summaryBuilder!(List<T>.unmodifiable(_selected));
    }
    if (_selected.length == 1) return _label(_selected.first);
    return '${_selected.length} selected';
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
          multiSelected: _selected.toSet(),
          onToggled: _toggle,
          onToggleAll: _toggleAll,
          allOptionText: widget.allOptionText,
          triggerText: _summary(),
          itemAsString: widget.itemAsString,
          placeholder: widget.label,
          height: widget.height ?? 30,
          width: widget.width,
          menuWidth: widget.menuWidth,
          menuMaxHeight: widget.menuMaxHeight,
          searchable: widget.searchable,
          enabled: widget.enabled,
          semanticLabel: widget.semanticLabel ?? widget.label,
        ),
      );
    }

    final theme = resolveIronTheme(context);

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Trigger ───────────────────────────────────────────────
                OutlinedButton.icon(
                  onPressed: _openPicker,
                  icon: const Icon(Icons.keyboard_arrow_down_outlined),
                  label: Text(widget.label),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.darkRed,
                    side: BorderSide(color: theme.gold),
                  ),
                ),
                // ── Chips ─────────────────────────────────────────────────
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
        ),
      ),
    );
  }
}
