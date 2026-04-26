# Migration Guide: Legacy IronWidgets → iron_widgets v1

This document covers every breaking or behavioural change introduced when
porting the pre-LLM (2023) widget codebase to the publishable
`iron_widgets` package.

---

## Rename map

| Legacy class / function | v1 class | Notes |
|---|---|---|
| `Label` | `IronLabel` | Prefix added; `StatefulWidget` → `StatelessWidget` |
| `MiniText` | `IronMiniText` | Prefix added; `StatefulWidget` → `StatelessWidget` |
| `Editor` | `IronEditor` | Prefix added; `text` → `initialValue`; `callback` → `onChanged`; `debounce` param added |
| `EditorDouble` | *(removed)* | Not in the published widget catalogue |
| `Check` | `IronCheck` | Prefix added; now fully **controlled** (see below) |
| `Select<T>` | `IronSelect<T>` | Prefix added; `callback` → `onChanged`; picker text params now wired |
| `Enum<T>` | `IronEnum<T>` | Prefix added; `callback` → `onChanged` |
| `MultiSelector<T>` | `IronMultiSelector<T>` | Prefix added; chips now use `FilterChip`; picker text params now wired |
| `WMicroSwitch` | `IronMicroSwitch` | `W` prefix → `Iron`; global refresh removed; now **controlled** |
| `WMicroEditor` | `IronMicroEditor` | `W` prefix → `Iron`; `value` → `initialValue` |
| `show(…)` | `Show` | Top-level function → `StatelessWidget` |
| `showValuesColumn(…)` | `ShowValuesColumn` | Top-level function → `StatelessWidget` |
| `showPercColumn(…)` | `ShowPercColumn` | Top-level function → `StatelessWidget` |

---

## Callback naming

All `callback` parameters renamed to idiomatic `onChanged` / `onSelected`.

```dart
// Legacy
Editor('Name', _text, (v) => _text = v)

// v1
IronEditor(label: 'Name', initialValue: _text, onChanged: (v) { … })
```

---

## IronCheck – controlled component

The legacy `Check` stored `_value` locally and never synced with new
`widget.value` props.  `IronCheck` is a **controlled** `StatelessWidget`:
the parent must hold state and rebuild on `onChanged`.

```dart
// Legacy (uncontrolled – parent state could drift)
Check('Enable', _flag, (v) => setState(() => _flag = v))

// v1 (controlled)
IronCheck(
  label: 'Enable',
  value: _flag,
  onChanged: (v) => setState(() => _flag = v),
)
```

---

## IronMicroSwitch – no global refresh

The legacy `WMicroSwitch.initState` called `addRefreshLotWidget(wSil, …)`,
a global singleton pattern.  `IronMicroSwitch` removes this dependency
entirely.  Ensure the parent `setState` triggers a rebuild:

```dart
// v1
IronMicroSwitch(
  text: 'HUD',
  value: _hud,
  onChanged: (v) => setState(() => _hud = v),
)
```

---

## IronEditor – initialValue vs controller

| Pattern | How to use |
|---|---|
| **Uncontrolled** (legacy-compatible) | Pass `initialValue`. External changes after construction are ignored. |
| **Controlled** | Pass a `TextEditingController`. You own its lifecycle. |

Debounce (new):
```dart
IronEditor(
  label: 'Search',
  initialValue: '',
  onChanged: _search,
  debounce: const Duration(milliseconds: 400),
)
```

---

## Show widgets – function → Widget

```dart
// Legacy
show('Open', '142.30', 60, baseStyleLabel, baseStyleValue)

// v1
Show(label: 'Open', value: '142.30')
```

Width, height and text styles are now resolved from `IronWidgetsTheme`
automatically.  Override via `IronWidgetsTheme.copyWith(…)`.

---

## Colours and dimensions – hardcoded → themed

All hardcoded colour literals and dimension variables have been removed.
Override them via `IronWidgetsTheme`:

```dart
IronWidgetsThemeScope(
  theme: IronWidgetsTheme.defaults().copyWith(
    gold: Colors.amber,        // change accent colour
    microWidgetHeight: 24,     // taller micro rows
    baseStyleValue: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
  ),
  child: MyDashboard(),
)
```

---

## Select / MultiSelector – picker text params now functional

The legacy `Select<T>` and `MultiSelector<T>` declared `allOptionText`,
`doneButtonText`, `cancelButtonText` but never passed them to the
underlying picker (a bug).  `IronSelect` and `IronMultiSelector` wire them
correctly:

```dart
IronMultiSelector<String>(
  title: 'Tags',
  label: 'Select Tags',
  value: _tags,
  options: allTags,
  onChanged: (list) => setState(() => _tags = list),
  allOptionText: 'Todos',
  doneButtonText: 'Listo',
  cancelButtonText: 'Cancelar',
)
```

---

## flutter_custom_selector – vendorised changes

The `flutter_custom_selector` package is vendorised under
`lib/src/vendor/flutter_custom_selector/`.  It is an internal dependency;
**do not import it directly** in consumer code.

Changes made:

| File | Change |
|---|---|
| All | `super.key`, trailing commas, `prefer_single_quotes` |
| `flutter_multi_select.dart` | Removed `with CustomBottomSheetSelector<T>` (invalid in Dart 3) |
| `flutter_single_select.dart` | Same; `mounted` guard added after `await` |
| `flutter_custom_selector_sheet.dart` | Added `doneButtonText`, `cancelButtonText`, `allOptionText` params; extracted private helper widgets |
| `utils/utils.dart` | `withOpacity` → `withAlpha`; `Color` constructor modernised |

---

## Removed

- `EditorDouble` – not in the published widget catalogue.
- `app_colors.dart` top-level constants – replaced by `IronColors`.
- Mutable top-level variables (`height`, `fontSize`, `widthInt`, etc.) –
  replaced by `IronDimens` constants and `IronWidgetsTheme` tokens.
- `refresh_widget.dart` / `addRefreshLotWidget` / `wSil` – global singleton
  pattern eliminated.
- `translations.dart` dependency – all strings are now parameters with
  English defaults.
