/// A model class used to represent a selectable item in the custom selector.
class CustomMultiSelectDropdownItem<T> {
  CustomMultiSelectDropdownItem(this.buttonObjectValue, this.buttonText);

  /// The underlying data value for this item.
  final T buttonObjectValue;

  /// The display string shown in the bottom sheet.
  final String buttonText;

  /// Whether this item is currently selected.
  bool selected = false;
}
