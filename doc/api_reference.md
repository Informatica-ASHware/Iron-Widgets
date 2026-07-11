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
  IronSelectMode mode = IronSelectMode.bottomSheet,
  double? menuWidth,
  double? menuMaxHeight,
  bool searchable = false,
  bool enabled = true,
})
```

#### Presentation modes (US-2.02)

`mode` chooses how options are presented:

| Mode | Behaviour |
|---|---|
| `IronSelectMode.bottomSheet` | Legacy modal bottom sheet (default in 1.x). |
| `IronSelectMode.dropdown` | Overlay menu anchored to the trigger, Finandy-style. Flips above the trigger when vertical space runs out. |
| `IronSelectMode.adaptive` | `dropdown` on desktop (macOS / Windows / Linux) and web; `bottomSheet` on Android / iOS / Fuchsia. |

Dropdown-mode extras:

- **Keyboard**: `↑`/`↓` (with wrap-around), `Enter`/`Space` select,
  `Esc` closes, `Home`/`End`, prefix typeahead while the menu is open.
- **`searchable: true`** replaces typeahead with an inline filter field
  that receives focus on open.
- **`menuWidth` / `menuMaxHeight`** override the trigger width and the
  `overlayMaxHeight` theme token respectively.
- The menu closes on outside tap, `Esc`, focus loss, item selection or
  ancestor scroll.
- `enabled: false` dims the trigger and blocks interaction (both modes).
- `doneButtonText` / `cancelButtonText` only apply to the bottom sheet.

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
  IronSelectMode mode = IronSelectMode.bottomSheet,
  double? menuWidth,
  double? menuMaxHeight,
  bool searchable = false,
  bool enabled = true,
})
```

Supports the same presentation modes as `IronSelect<T>` (see
[Presentation modes](#presentation-modes-us-202) above). Since [value] is
non-nullable, the trigger always shows the current selection and the menu
opens with the keyboard highlight on it. `cancelButtonText` only applies
to the bottom sheet.

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
  IronSelectMode mode = IronSelectMode.bottomSheet,
  double? menuWidth,
  double? menuMaxHeight,
  bool searchable = false,
  bool enabled = true,
  String Function(List<T> selected)? summaryBuilder,
})
```

Supports the same presentation modes as `IronSelect<T>` (see
[Presentation modes](#presentation-modes-us-202) above). Dropdown-mode
specifics (US-2.04):

- Rows render an Iron-style checkbox and **apply immediately**: every
  toggle fires `onChanged` with the full new selection; there is no Done
  step, so `doneButtonText` / `cancelButtonText` only apply to the
  bottom sheet.
- The panel stays open while toggling; it closes on outside tap, `Esc`,
  focus loss or ancestor scroll. `Enter`/`Space` toggle the highlighted
  row.
- The `allOptionText` row toggles the whole set and hides while a search
  query is active.
- The trigger shows a compact summary instead of chips: the single item's
  label, or `'n selected'`, customisable via `summaryBuilder`.

## Market indicators (US-2.05 … US-2.08)

### `IronDeltaBadge`

```dart
IronDeltaBadge(
  double value, {
  int precision = 2,
  bool showSign = true,
  String suffix = '%',
  String? semanticLabel,
})
```

Pill coloured by sign: positive → `bullColor`, negative → `bearColor`,
zero → neutral (white-70 on `neutralSurface`). Corners use the
`cornerRadius` token; text uses `baseStylePercent`.

### `IronPriceTicker`

```dart
IronPriceTicker({
  required double price,
  double? previous,
  int precision = 2,
  Duration flashDuration = const Duration(milliseconds: 600),
  String prefix = '',
  String suffix = '',
  String? semanticLabel,
})
```

Flashes towards `bullColor` / `bearColor` when `price` changes across
rebuilds (or vs `previous` on the very first frame) and fades back to the
`baseStyleValue` colour over `flashDuration`. Uses tabular figures, an
`AnimationController` created once (no timers in build) and a
`RepaintBoundary`.

### `IronCountdown`

```dart
IronCountdown({
  DateTime? until,            // exactly one of until / remaining
  Duration? remaining,
  VoidCallback? onFinished,   // fires exactly once at zero
  String Function(Duration)? format,  // default mm:ss / hh:mm:ss
  bool paused = false,
  double warningFraction = 0.1,
  String? semanticLabel,
})
```

Driven by a `Ticker` (`TickerProviderStateMixin`), no `Timer`s. `paused`
freezes and resumes from the frozen value; the text switches to
`dangerColor` when the remaining fraction drops below `warningFraction`.
Rebuilds only when the displayed second changes.

### `IronSparkline`

```dart
IronSparkline(
  List<double> values, {
  double width = 120,
  double height = 32,
  double strokeWidth = 1.5,
  bool positiveIsBull = true,
  Color? color,
  bool fill = true,
  String? semanticLabel,
})
```

Zero-dependency `CustomPainter` trend line. Colour derives from the
overall trend (`bullColor` / `bearColor`, white-54 when flat);
`positiveIsBull: false` inverts the mapping and `color` forces one.
Series longer than 200 points are uniformly downsampled. Complements
`AshCandleChart`; it does not replace it.

## Order entry (US-2.09 … US-2.12)

### `IronSegmented<T>`

```dart
IronSegmented<T>({
  required List<T> segments,
  required T value,
  required ValueChanged<T> onChanged,
  String Function(T)? itemAsString,
  Color Function(T segment)? selectedColor,  // default: gold
  double height = 26,
  double? segmentWidth,
  bool enabled = true,
  String? semanticLabel,
})
```

Segmented control for closed sets (LONG/SHORT, PNL filters, L/F/M/S/T).
Selected segment fills with `gold` (or `selectedColor`, e.g. LONG →
`bullColor` / SHORT → `bearColor`) with automatic contrast via
`textColorOn`. Left/Right arrows move the selection while focused
(clamped at the ends).

### `IronPercentSlider`

```dart
IronPercentSlider({
  required double value,
  required ValueChanged<double> onChanged,
  double min = 0,
  double max = 100,
  List<double> presets = const [10, 25, 50, 75, 97],
  bool editable = true,
  int precision = 0,
  bool enabled = true,
  String? semanticLabel,
})
```

Gold slider + preset chips + coupled `IronMicroEditor`. Every source
(drag, chip, typing) emits through `onChanged`, clamped to `[min, max]`
and rounded to `precision`; the editor follows external changes without
fighting the caret while typing. Empty `presets` hides the chip row.

### `IronStepper`

```dart
IronStepper({
  required double value,
  required ValueChanged<double> onChanged,
  double step = 1,
  double min = double.negativeInfinity,
  double max = double.infinity,
  int precision = 0,
  double editorWidth = 50,
  bool enabled = true,
  String? semanticLabel,
})
```

`IronMicroEditor` flanked by `−` / `+` buttons. Press steps once
immediately; holding repeats after 400 ms at 100 ms intervals (driven by
a `Ticker`, no `Timer`s). Results are clamped and precision-rounded
(`0.1 + 0.2 → 0.3`, no floating-point noise).

### `IronActionButton`

```dart
IronActionButton({
  required String label,
  required VoidCallback? onPressed,  // null → disabled
  IronActionVariant variant = IronActionVariant.primary,
  String? sublabel,
  bool loading = false,
  double? width,          // double.infinity to fill
  double height = 40,
  String? semanticLabel,
})
```

Large CTA in the Finandy style ("Add SHORT"). `variant` maps to `gold` /
`bullColor` / `bearColor` with automatic contrast; `sublabel` renders a
secondary line (e.g. the estimated size) and `loading` swaps the content
for a spinner while suppressing taps.

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
