import 'flutter_custom_select_item.dart';

/// Utility actions for multi-select dropdown state management.
class CustomMultiSelectDropdownActions<T> {
  /// Adds or removes [itemValue] from [selectedValues] based on [checked].
  List<T> onItemCheckedChange(
    List<T> selectedValues,
    T itemValue,
    bool checked,
  ) {
    if (checked) {
      selectedValues.add(itemValue);
    } else {
      selectedValues.remove(itemValue);
    }
    return selectedValues;
  }

  /// Filters [allItems] to those whose [buttonText] contains [val] (case-insensitive).
  /// Returns [allItems] unchanged when [val] is null or blank.
  List<CustomMultiSelectDropdownItem<T>> updateSearchQuery(
    String? val,
    List<CustomMultiSelectDropdownItem<T>> allItems,
  ) {
    if (val != null && val.trim().isNotEmpty) {
      return allItems
          .where(
            (item) =>
                item.buttonText.toLowerCase().contains(val.toLowerCase()),
          )
          .toList();
    }
    return allItems;
  }
}
