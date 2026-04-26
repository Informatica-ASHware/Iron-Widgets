import 'package:flutter/material.dart';

import '../utils/enum.dart';
import '../utils/flutter_custom_select_item.dart';
import '../utils/utils.dart';
import 'flutter_custom_selector_sheet.dart';

/// A multi-select field that opens a bottom-sheet for item selection.
///
/// Selected items are shown as chips below the trigger field.
class CustomMultiSelectField<T> extends StatefulWidget {
  const CustomMultiSelectField({
    super.key,
    required this.items,
    required this.title,
    required this.onSelectionDone,
    this.width,
    this.decoration,
    this.validator,
    this.initialValue,
    this.itemAsString,
    this.selectedItemColor = Colors.redAccent,
    this.enableAllOptionSelect = false,
    this.allOptionText = 'All',
    this.doneButtonText = 'Done',
    this.cancelButtonText = 'Cancel',
  });

  /// The full list of selectable items.
  final List<T> items;

  /// Header title shown in the bottom sheet.
  final String title;

  /// Called with the confirmed selection.
  final void Function(List<T>)? onSelectionDone;

  /// Optional fixed width.
  final double? width;

  /// Custom decoration for the trigger TextFormField.
  final InputDecoration? decoration;

  /// Optional FormField validator.
  final String? Function(List<T>)? validator;

  /// Pre-selected items.
  final List<T>? initialValue;

  /// Converts a [T] to its display string.  Falls back to [Object.toString].
  final String Function(T)? itemAsString;

  /// Highlight colour for selected items.
  final Color selectedItemColor;

  /// Whether to show an "All" toggle in multi-select mode.
  final bool enableAllOptionSelect;

  /// Label for the "All" toggle row.
  final String allOptionText;

  /// Label for the confirm button.
  final String doneButtonText;

  /// Label for the cancel button.
  final String cancelButtonText;

  @override
  State<CustomMultiSelectField<T>> createState() =>
      _CustomMultiSelectFieldState<T>();
}

class _CustomMultiSelectFieldState<T>
    extends State<CustomMultiSelectField<T>> {
  final TextEditingController _controller = TextEditingController();
  late List<T> _selectedItems;
  late List<CustomMultiSelectDropdownItem<T>> _dropdownItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List<T>.from(widget.initialValue ?? <T>[]);
    _controller.text = widget.title;
    _dropdownItems = _buildDropdownItems(widget.items);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<CustomMultiSelectDropdownItem<T>> _buildDropdownItems(List<T> list) =>
      list
          .map(
            (item) => CustomMultiSelectDropdownItem<T>(
              item,
              widget.itemAsString?.call(item) ?? item.toString(),
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final result =
                  await CustomBottomSheetSelector<T>().customBottomSheet(
                buildContext: context,
                selectedItemColor: widget.selectedItemColor,
                initialSelection: _selectedItems,
                buttonType: CustomDropdownButtonType.multiSelect,
                headerName: widget.title,
                dropdownItems: _dropdownItems,
                isAllOptionEnable: widget.enableAllOptionSelect,
                allOptionText: widget.allOptionText,
                doneButtonText: widget.doneButtonText,
                cancelButtonText: widget.cancelButtonText,
              );
              if (!mounted) return;
              if (result[selectedList] != null) {
                widget.onSelectionDone?.call(result[selectedList]!);
                setState(() {
                  _selectedItems = List<T>.from(result[selectedList]!);
                });
              }
            },
            child: SizedBox(
              width: widget.width ?? double.infinity,
              child: TextFormField(
                controller: _controller,
                readOnly: true,
                enabled: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (_) => widget.validator?.call(_selectedItems),
                style: defaultTextStyle(fontSize: 16),
                decoration: widget.decoration ??
                    InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      suffixIcon:
                          const Icon(Icons.keyboard_arrow_down_outlined),
                      suffixIconColor: Colors.black,
                      enabledBorder: inputFieldBorder(),
                      border: inputFieldBorder(),
                      focusedBorder: inputFieldBorder(),
                    ),
              ),
            ),
          ),
          if (_selectedItems.isNotEmpty) ...[
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: _dropdownItems
                  .where(
                    (item) =>
                        _selectedItems.contains(item.buttonObjectValue),
                  )
                  .map(
                    (item) => Chip(
                      label: Text(
                        item.buttonText,
                        style: defaultTextStyle(),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Colors.grey.shade300,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 5),
          ],
        ],
      );
}
