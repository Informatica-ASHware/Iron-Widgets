import 'package:flutter/material.dart';

import '../flutter_custom_selector.dart';

/// Presents a bottom-sheet that handles both single- and multi-select flows.
class CustomBottomSheetSelector<T> {
  /// Opens the bottom sheet and returns a map keyed by [selectedList].
  ///
  /// The value is the selected list when the user confirms, or `null` when
  /// the user cancels.
  Future<Map<String, List<T>?>> customBottomSheet({
    required BuildContext buildContext,
    required String headerName,
    required CustomDropdownButtonType buttonType,
    required List<CustomMultiSelectDropdownItem<T>> dropdownItems,
    required List<T> initialSelection,
    required Color selectedItemColor,
    bool isAllOptionEnable = false,
    String allOptionText = 'All',
    String doneButtonText = 'Done',
    String cancelButtonText = 'Cancel',
  }) async {
    final selectedList_ = <T>[];
    var selectionDone = false;
    var isAllSelected = false;

    for (final value in initialSelection) {
      selectedList_.add(value);
    }

    for (var i = 0; i < dropdownItems.length; i++) {
      if (selectedList_.contains(dropdownItems[i].buttonObjectValue)) {
        dropdownItems[i].selected = true;
      }
    }

    if (selectedList_.length == dropdownItems.length) {
      isAllSelected = true;
    }

    await showModalBottomSheet<void>(
      context: buildContext,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: StatefulBuilder(
                builder: (_, setState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ── Header ──────────────────────────────────────────
                    ColoredBox(
                      color: Colors.grey.shade200,
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            headerName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // ── Item list ────────────────────────────────────────
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          // "All" row (multi-select only)
                          if (isAllOptionEnable &&
                              buttonType ==
                                  CustomDropdownButtonType.multiSelect)
                            _AllRow(
                              isAllSelected: isAllSelected,
                              selectedItemColor: selectedItemColor,
                              allOptionText: allOptionText,
                              onPressed: () {
                                isAllSelected = !isAllSelected;
                                selectedList_.clear();
                                for (final item in dropdownItems) {
                                  item.selected = isAllSelected;
                                  if (isAllSelected) {
                                    selectedList_.add(item.buttonObjectValue);
                                  }
                                }
                                setState(() {});
                              },
                            ),
                          if (isAllOptionEnable &&
                              buttonType ==
                                  CustomDropdownButtonType.multiSelect)
                            const Divider(height: 1, thickness: 0.5),
                          // Item rows
                          Wrap(
                            children: dropdownItems
                                .map(
                                  (item) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomBottomSheetButton(
                                        trailing: buttonType ==
                                                CustomDropdownButtonType
                                                    .multiSelect
                                            ? _SelectionIndicator(
                                                selected: item.selected,
                                                selectedItemColor:
                                                    selectedItemColor,
                                              )
                                            : null,
                                        onPressed: () {
                                          if (buttonType ==
                                              CustomDropdownButtonType
                                                  .multiSelect) {
                                            item.selected = !item.selected;
                                            if (item.selected) {
                                              selectedList_.add(
                                                item.buttonObjectValue,
                                              );
                                              if (selectedList_.length ==
                                                  dropdownItems.length) {
                                                isAllSelected = true;
                                              }
                                            } else {
                                              isAllSelected = false;
                                              selectedList_.remove(
                                                item.buttonObjectValue,
                                              );
                                            }
                                            setState(() {});
                                          } else {
                                            selectedList_.clear();
                                            selectedList_
                                                .add(item.buttonObjectValue);
                                            selectionDone = true;
                                            Navigator.pop(buildContext);
                                          }
                                        },
                                        buttonTextStyle: defaultTextStyle(
                                          color: item.selected
                                              ? selectedItemColor
                                              : Colors.black,
                                        ),
                                        buttonText: item.buttonText,
                                      ),
                                      if (item != dropdownItems.last)
                                        const Divider(
                                          height: 1,
                                          thickness: 0.5,
                                        ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),
          // ── Action button ──────────────────────────────────────────────
          _ActionButton(
            buttonType: buttonType,
            doneButtonText: doneButtonText,
            cancelButtonText: cancelButtonText,
            onDone: () {
              selectionDone = true;
              Navigator.pop(buildContext);
            },
            onCancel: () {
              selectionDone = false;
              Navigator.pop(buildContext);
            },
            screenWidth: MediaQuery.sizeOf(bc).width,
          ),
        ],
      ),
    );

    return {selectedList: selectionDone ? selectedList_ : null};
  }
}

// ── Private helpers ──────────────────────────────────────────────────────────

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({
    required this.selected,
    required this.selectedItemColor,
  });

  final bool selected;
  final Color selectedItemColor;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? selectedItemColor : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Icon(
            Icons.done,
            color: selected ? Colors.white : Colors.transparent,
            size: 20,
          ),
        ),
      );
}

class _AllRow extends StatelessWidget {
  const _AllRow({
    required this.isAllSelected,
    required this.selectedItemColor,
    required this.allOptionText,
    required this.onPressed,
  });

  final bool isAllSelected;
  final Color selectedItemColor;
  final String allOptionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => CustomBottomSheetButton(
        trailing: _SelectionIndicator(
          selected: isAllSelected,
          selectedItemColor: selectedItemColor,
        ),
        onPressed: onPressed,
        buttonTextStyle: defaultTextStyle(
          color: isAllSelected ? selectedItemColor : Colors.black,
        ),
        buttonText: allOptionText,
      );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.buttonType,
    required this.doneButtonText,
    required this.cancelButtonText,
    required this.onDone,
    required this.onCancel,
    required this.screenWidth,
  });

  final CustomDropdownButtonType buttonType;
  final String doneButtonText;
  final String cancelButtonText;
  final VoidCallback onDone;
  final VoidCallback onCancel;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    final label = buttonType == CustomDropdownButtonType.multiSelect
        ? doneButtonText
        : cancelButtonText;
    final onTap = buttonType == CustomDropdownButtonType.multiSelect
        ? onDone
        : onCancel;

    return Container(
      width: screenWidth - 40,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: MaterialButton(
        onPressed: onTap,
        color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minWidth: screenWidth - 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Center(
            child: Text(label, style: const TextStyle(fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
