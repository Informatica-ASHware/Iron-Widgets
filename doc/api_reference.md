# Iron Widgets API Reference

Full Dartdoc is available at `dart doc .` or on pub.dev.  This document
provides a quick-reference summary of every public symbol.

---

## Theme

### `IronWidgetsTheme`

`ThemeExtension<IronWidgetsTheme>` — carries the full design token set.

| Member | Type | Description |
|---|---|---|
| `darkRed` | `Color` | Primary accent / danger |
| `gold` | `Color` | Background / border |
| `darkGray` | `Color` | Neutral surface |
| `baseStyleValue` | `TextStyle` | Numeric value cells |
| `baseStyleLabel` | `TextStyle` | Label cells |
| `baseStyleTitle` | `TextStyle` | Section titles |
| `baseStylePercent` | `TextStyle` | Percentage cells |
| `microWidgetHeight` | `double` | Row height |
| `microFontSize` | `double` | Font size for micro widgets |
| `microIntWidth` | `double` | Integer cell width |
| `microValueWidth` | `double` | Value cell width |
| `microPercentWidth` | `double` | Percentage cell width |
| `valueBackground` | `Color` | Show panel background |
| `borderAccent` | `Color` | Border / outline colour |
| `dangerColor` | `Color` | Warning / active colour |
| `neutralSurface` | `Color` | Neutral container |

**Factory:** `IronWidgetsTheme.defaults()` — canonical Iron Man palette.

**Methods:**
- `copyWith({…})` → `IronWidgetsTheme`
- `lerp(other, t)` → `IronWidgetsTheme`
- `buildMaterialTheme({Brightness brightness})` → `ThemeData`
- `textColorOn(Color bg)` → `Color` (AA contrast helper)

---

### `IronWidgetsThemeScope`

```dart
IronWidgetsThemeScope({
  IronWidgetsTheme? theme,   // null → defaults()
  required Widget child,
})
```

---

### `IronColors`

```dart
IronColors.darkRed   // Color(0xFFB30000)
IronColors.gold      // Color(0xFFFFD700)
IronColors.darkGray  // Color(0xFF333333)
```

---

### `IronDimens`

```dart
IronDimens.microWidgetHeight   // 20
IronDimens.microFontSize       // 10
IronDimens.microIntWidth       // 20
IronDimens.microValueWidth     // 60
IronDimens.microPercentWidth   // 60
```

---

### `IronTextStyles`

```dart
IronTextStyles.baseStyleLabel    // bold 10 pt, darkRed
IronTextStyles.baseStyleValue    // bold 10 pt, darkGray
IronTextStyles.baseStylePercent  // regular 10 pt, darkGray
IronTextStyles.baseStyleTitle    // regular 12 pt, darkGray
```

---

## Widgets

### `IronLabel`

```dart
IronLabel(
  String text, {
  double? width,
  bool colon = true,            // append ':' to label
  String? semanticLabel,
})
```

### `IronMiniText`

```dart
IronMiniText(
  String text, {
  double? width,
  double? margin,
  double? fontSize,             // overrides theme.microFontSize
  Color? color,
  String? semanticLabel,
})
```

Numeric strings (starting with `-0123456789.`) are right-aligned.

### `IronCheck`

```dart
IronCheck({
  required String label,
  required bool value,
  required ValueChanged<bool> onChanged,
  double? width,
  bool enabled = true,
  String? semanticLabel,
})
```

Fully controlled — parent owns state.

### `IronMicroSwitch`

```dart
IronMicroSwitch({
  required String text,
  required bool value,
  required ValueChanged<bool> onChanged,
  double width = 58,
  double height = 22,
  String message = '',          // tooltip
  bool enabled = true,
  String? semanticLabel,
})
```

### `IronMicroEditor`

```dart
IronMicroEditor({
  required String initialValue,
  required ValueChanged<String> onChanged,
  String label = '',
  double width = 50,
  double height = 20,
  double? fontSize,
  TextEditingController? controller,
  bool enabled = true,
  String? semanticLabel,
})
```

### `IronEditor`

```dart
IronEditor({
  required String label,
  required ValueChanged<String> onChanged,
  String initialValue = '',
  TextEditingController? controller,
  double width = 240,
  int lines = 1,
  bool password = false,
  bool labelOnTop = false,
  Duration? debounce,           // null → no debounce
  bool enabled = true,
  String? semanticLabel,
})
```

### `IronSelect<T>`

```dart
IronSelect<T>({
  required String title,
  required String label,
  required List<T> options,
  required ValueChanged<T> onChanged,
  T? value,
  double height = 30,
  double width = 200,
  String Function(T)? itemAsString,
  String allOptionText = 'All',
  String doneButtonText = 'Done',
  String cancelButtonText = 'Cancel',
  String? semanticLabel,
})
```

### `IronEnum<T>`

```dart
IronEnum<T>({
  required String title,
  required String label,
  required T value,
  required List<T> options,
  required ValueChanged<T> onChanged,
  double height = 30,
  double width = 200,
  String Function(T)? itemAsString,
  String cancelButtonText = 'Cancel',
  String? semanticLabel,
})
```

### `IronMultiSelector<T>`

```dart
IronMultiSelector<T>({
  required String title,
  required String label,
  required List<T> value,
  required List<T> options,
  required ValueChanged<List<T>> onChanged,
  double? height,
  double width = 200,
  String Function(T)? itemAsString,
  String allOptionText = 'All',
  String doneButtonText = 'Done',
  String cancelButtonText = 'Cancel',
  String? semanticLabel,
})
```

### `Show`

```dart
Show({
  required String label,
  required String value,
  bool editable = false,
  ValueChanged<String>? onChanged,
  String? semanticLabel,
})
```

### `ShowValuesColumn`

```dart
ShowValuesColumn({
  required String topLabel,
  required String topValue,
  required String bottomLabel,
  required String bottomValue,
  Color? background,            // defaults to theme.valueBackground
  bool editable = false,
  ValueChanged<String>? onTopChanged,
  ValueChanged<String>? onBottomChanged,
  String? semanticLabel,
})
```

### `ShowPercColumn`

```dart
ShowPercColumn({
  required String topLabel,
  required String topValue,     // shown as "value%"
  required String bottomLabel,
  required String bottomValue,  // shown as "value%"
  Color? background,
  bool editable = false,
  ValueChanged<String>? onTopChanged,
  ValueChanged<String>? onBottomChanged,
  String? semanticLabel,
})
```
