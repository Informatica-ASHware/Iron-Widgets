# IronWidgetsTheme – Theming Guide

## Overview

`IronWidgetsTheme` is a `ThemeExtension<IronWidgetsTheme>` that carries
every design token used by the `iron_widgets` library.  Widgets resolve it
via the internal `resolveIronTheme(context)` helper, which falls back to
`IronWidgetsTheme.defaults()` when no theme is found in the widget tree.

---

## Default palette

| Token | Value | Role |
|---|---|---|
| `darkRed` | `0xFFB30000` | Primary accent, danger indicators |
| `gold` | `0xFFFFD700` | Backgrounds, borders, highlights |
| `darkGray` | `0xFF333333` | Neutral surfaces, disabled text |
| `valueBackground` | `gold` | Background of Show panels |
| `borderAccent` | `gold` | Border colour of micro widgets |
| `dangerColor` | `darkRed` | Checkbox active colour, chip colour |
| `neutralSurface` | `darkGray` | Neutral container colour |

---

## Default text styles

| Token | Font size | Weight | Colour |
|---|---|---|---|
| `baseStyleLabel` | 10 pt | bold | `darkRed` |
| `baseStyleValue` | 10 pt | bold | `darkGray` |
| `baseStylePercent` | 10 pt | regular | `darkGray` |
| `baseStyleTitle` | 12 pt | regular | `darkGray` |

### Trade-off: `fontSize: 10` and accessibility

The default font size of 10 pt matches the original data-dense legacy UI.
Widgets respect the OS `TextScaler`, so system-level text scaling applies
without any extra configuration.

To raise the minimum font size globally:

```dart
IronWidgetsThemeScope(
  theme: IronWidgetsTheme.defaults().copyWith(
    microFontSize: 12,
    baseStyleValue: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    baseStyleLabel: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    baseStylePercent: const TextStyle(fontSize: 12),
    baseStyleTitle: const TextStyle(fontSize: 14),
  ),
  child: MyDashboard(),
)
```

---

## Default dimension tokens

| Token | Default | Legacy variable |
|---|---|---|
| `microWidgetHeight` | `20` | `height = 20` |
| `microFontSize` | `10` | `fontSize = 10` |
| `microIntWidth` | `20` | `widthInt = 20` |
| `microValueWidth` | `60` | `widthValue = 60` |
| `microPercentWidth` | `60` | `widthPercent = 60` |

---

## Setup options

### Option A – IronWidgetsThemeScope (recommended)

Injects the theme without replacing the consumer's `ThemeData`.

```dart
IronWidgetsThemeScope(
  child: MyDashboard(),
)
```

Custom theme:

```dart
IronWidgetsThemeScope(
  theme: IronWidgetsTheme.defaults().copyWith(gold: Colors.amber),
  child: MyDashboard(),
)
```

### Option B – buildMaterialTheme()

Generates a full `ThemeData` for `MaterialApp`:

```dart
MaterialApp(
  theme: IronWidgetsTheme.defaults().buildMaterialTheme(),
  darkTheme: IronWidgetsTheme.defaults()
      .buildMaterialTheme(brightness: Brightness.dark),
)
```

Generated `ColorScheme`:

| Role | Light | Dark |
|---|---|---|
| `primary` | `darkRed` | `darkRed` |
| `onPrimary` | `Colors.white` | `Colors.white` |
| `secondary` | `gold` | `gold` |
| `onSecondary` | `Colors.black` | `Colors.black` |
| `surface` | `Colors.white` | `darkGray` |
| `onSurface` | `Colors.black` | `Colors.white` |

### Option C – No setup

Every widget falls back to `IronWidgetsTheme.defaults()` automatically.

---

## Dark mode cohabitation

- When `IronWidgetsTheme` is injected, widgets use its palette.
- Without the scope, widgets call `IronWidgetsTheme.defaults()` as a fallback
  but `IronEditor` and `IronLabel` read `Theme.of(context).colorScheme.primary`
  for text colour, so they adapt to the consumer's dark/light mode.
- The `textColorOn(Color bg)` helper uses the WCAG relative luminance formula
  (threshold 0.179) to select black or white text, ensuring AA compliance for
  text on gold panels in both modes.

---

## Overriding colours per-widget

Every widget delegates colour resolution to `resolveIronTheme(context)`.
To change a colour for a single subtree, wrap it with a second `IronWidgetsThemeScope`:

```dart
IronWidgetsThemeScope(
  theme: IronWidgetsTheme.defaults().copyWith(valueBackground: Colors.teal),
  child: ShowValuesColumn(
    topLabel: 'Open', topValue: '100',
    bottomLabel: 'Close', bottomValue: '98',
  ),
)
```

---

## Animation / lerp

`IronWidgetsTheme` implements `lerp` so that animated theme transitions work
correctly with `AnimatedTheme`:

```dart
AnimatedTheme(
  data: activeTheme,
  child: MyWidget(),
)
```
