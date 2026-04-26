import 'package:flutter/material.dart';

import '../utils/enum.dart';
import '../utils/flutter_custom_select_item.dart';
import '../utils/utils.dart';
import 'flutter_custom_selector_sheet.dart';

/// A single-select field that opens a bottom-sheet for item selection.
class CustomSingleSelectField<T> extends StatefulWidget {
  CustomSingleSelectField({
    super.key,
    required this.items,
    required this.title,
    required this.onSelectionDone,
    this.width,
    this.itemAsString,
    this.decoration,
    this.validator,
    this.initialValue,
    this.selectedItemColor = Colors.redAccent,
    this.cancelButtonText = 'Cancel',
  });

  /// The full list of selectable items.
  final List<T> items;

  /// Header title shown in the bottom sheet.
  final String title;

  /// Called with the confirmed selection.
  final void Function(T)? onSelectionDone;

  /// Optional fixed width.
  final double? width;

  /// Converts a [T] to its display string.  Falls back to [Object.toString].
  final String Function(T)? itemAsString;

  /// Custom decoration for the trigger TextFormField.
  final InputDecoration? decoration;

  /// Optional FormField validator.
  final String? Function(String?)? validator;

  /// Pre-selected item.
  final T? initialValue;

  /// Highlight colour for the selected item.
  final Color selectedItemColor;

  /// Label for the cancel button.
  final String cancelButtonText;

  @override
  State<CustomSingleSelectField<T>> createState() =>
      _CustomSingleSelectFieldState<T>();
}

class _CustomSingleSelectFieldState<T>
    extends State<CustomSingleSelectField<T>> {
  final TextEditingController _controller = TextEditingController();
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
    _controller.text = _asString(_selectedItem);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _asString(T? data) {
    if (data == null) return '';
    return widget.itemAsString?.call(data) ?? data.toString();
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
  Widget build(BuildContext context) {
    _controller.text = _asString(_selectedItem);

    return GestureDetector(
      onTap: () async {
        final result =
            await CustomBottomSheetSelector<T>().customBottomSheet(
          buildContext: context,
          selectedItemColor: widget.selectedItemColor,
          initialSelection:
              _selectedItem != null ? [_selectedItem as T] : [],
          buttonType: CustomDropdownButtonType.singleSelect,
          headerName: widget.title,
          dropdownItems: _buildDropdownItems(widget.items),
          cancelButtonText: widget.cancelButtonText,
        );
        if (!mounted) return;
        if (result[selectedList] != null &&
            result[selectedList]!.isNotEmpty) {
          final selected = result[selectedList]!.first;
          widget.onSelectionDone?.call(selected);
          setState(() {
            _selectedItem = selected;
            _controller.text = _asString(_selectedItem);
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
          validator: widget.validator,
          style: defaultTextStyle(fontSize: 16),
          decoration: widget.decoration ??
              InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                labelText: widget.title,
                labelStyle: defaultTextStyle(color: labelColor, fontSize: 16),
                suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
                suffixIconColor: Colors.black,
                enabledBorder: inputFieldBorder(),
                border: inputFieldBorder(),
                focusedBorder: inputFieldBorder(),
              ),
        ),
      ),
    );
  }
}
