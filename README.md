# iron_widgets

[![pub package](https://img.shields.io/pub/v/iron_widgets.svg)](https://pub.dev/packages/iron_widgets)
[![License: BSD 3-Clause](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

A Flutter widget library inspired by Iron Man aesthetics — micro-editors,
compact toggles, labelled form controls and financial-style show panels, all
driven by a single `IronWidgetsTheme` that integrates cleanly with your
existing `MaterialApp`.

---

## Features

| Widget | Description |
|---|---|
| `IronLabel` | Bold, themed label |
| `IronMiniText` | Compact text — auto right-aligns numerics |
| `IronCheck` | Controlled checkbox with label |
| `IronMicroSwitch` | Compact toggle button (gold / white) |
| `IronMicroEditor` | Inline numeric text field |
| `IronEditor` | Full text editor with optional debounce |
| `IronSelect<T>` | Single-select picker — bottom sheet or anchored dropdown (`IronSelectMode`) |
| `IronEnum<T>` | Enum single-select picker (same modes) |
| `IronMultiSelector<T>` | Multi-select — FilterChips or dropdown with All row and immediate apply |
| `IronDeltaBadge` | Signed change pill (bull / bear / neutral) |
| `IronPriceTicker` | Price with directional flash on change |
| `IronCountdown` | Ticker-driven pausable countdown |
| `IronSparkline` | Zero-dependency mini trend line |
| `IronSegmented<T>` | Segmented control (LONG/SHORT, filters) |
| `IronPercentSlider` | Percent slider with preset chips and coupled editor |
| `IronStepper` | Numeric stepper with hold-to-repeat |
| `IronActionButton` | Large CTA (primary / success / danger, loading) |
| `IronTag` | Mini metadata chip (gold / bull / bear / neutral) |
| `IronRangeBar` | SL → TP range bar with entry line and price marker |
| `IronGauge` | Arc-reactor gauge with thresholds |
| `ShowGrid` | Stats-header grid of `Show` cells |
| `IronPanel` | Elevated card with gold header (collapsible) |
| `IronTabs` | Compact tabs with gold underline indicator |
| `Show` | Single label/value row |
| `ShowValuesColumn` | Two-row value panel |
| `ShowPercColumn` | Two-row percentage panel |

Desktop-first keyboard support across the interactive widgets, semantic
bull/bear/gold theming via `IronWidgetsTheme`, and **zero new
dependencies** (all custom painting is `CustomPainter`-based).

---

## Installation

```yaml
dependencies:
  iron_widgets: ^1.0.0
```

---

## Quick Start

### Option A — Wrap a subtree

```dart
import 'package:iron_widgets/iron_widgets.dart';

IronWidgetsThemeScope(
  child: MyDashboard(),
)
```

### Option B — Integrate with MaterialApp

```dart
MaterialApp(
  theme: IronWidgetsTheme.defaults().buildMaterialTheme(),
  darkTheme: IronWidgetsTheme.defaults()
      .buildMaterialTheme(brightness: Brightness.dark),
  home: MyHome(),
)
```

### Option C — No setup needed

Every widget falls back to `IronWidgetsTheme.defaults()` automatically, so
you can drop in any widget without ceremony:

```dart
IronMicroSwitch(text: 'HUD', value: _hud, onChanged: (v) => setState(() => _hud = v))
```

---

## Theming

Override individual tokens with `copyWith`:

```dart
IronWidgetsThemeScope(
  theme: IronWidgetsTheme.defaults().copyWith(
    gold: Colors.amber,
    microFontSize: 12,
  ),
  child: MyPanel(),
)
```

See [doc/theming_guide.md](doc/theming_guide.md) for the complete guide.

---

## Accessibility

- All interactive widgets wrap their content in `Semantics`.
- Every widget exposes a `semanticLabel` parameter.
- Micro-widget text respects the OS `TextScaler`.
- Disabled state is honoured visually and functionally.

---

## Third-party code

This package vendors a modernised copy of
[flutter_custom_selector](https://github.com/hbrhbr/flutter_custom_select)
(BSD 2-Clause) for the bottom-sheet picker used by `IronSelect`, `IronEnum`,
and `IronMultiSelector`.  Full attribution in [NOTICE.md](NOTICE.md).

---

## Migration from legacy IronWidgets

See [MIGRATION.md](MIGRATION.md).
