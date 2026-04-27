# Changelog

## [1.0.1] – 2026-04-27

### Added
- Repository made public to allow pub.dev link verification.

---

## [1.0.0] – 2026-04-27

### Added

- `IronWidgetsTheme` – `ThemeExtension` carrying the full Iron Man design token
  set (palette, text styles, dimension tokens, semantic roles).
- `IronWidgetsThemeScope` – helper widget that injects an `IronWidgetsTheme`
  without replacing the consumer's `ThemeData`.
- `IronColors` – `abstract final class` with `darkRed`, `gold`, `darkGray`
  palette constants.
- `IronDimens` – `abstract final class` with micro-widget dimension tokens.
- `IronTextStyles` – `abstract final class` with default `TextStyle` instances.
- `IronLabel` – bold themed label (`StatelessWidget`).
- `IronMiniText` – compact auto-aligning text (`StatelessWidget`).
- `IronCheck` – controlled checkbox with label (`StatelessWidget`).
- `IronMicroSwitch` – compact toggle button (`StatelessWidget`).
- `IronMicroEditor` – inline numeric text field (`StatefulWidget`).
- `IronEditor` – full text editor with optional debounce (`StatefulWidget`).
- `IronSelect<T>` – single-select bottom-sheet picker (`StatefulWidget`).
- `IronEnum<T>` – enum single-select picker (`StatefulWidget`).
- `IronMultiSelector<T>` – multi-select with `FilterChip` display (`StatefulWidget`).
- `Show` – single label/value row (`StatelessWidget`).
- `ShowValuesColumn` – two-row value panel (`StatelessWidget`).
- `ShowPercColumn` – two-row percentage panel (`StatelessWidget`).
- Vendored `flutter_custom_selector` (BSD 2-Clause) under
  `lib/src/vendor/flutter_custom_selector/`, modernised to Dart 3.11.

### Changed

- All widgets migrated from Dart 2 / Flutter 2 legacy codebase to
  Dart 3.11 / Flutter 3.24.
- `Check` → `IronCheck`: converted to `StatelessWidget` (controlled component).
- `WMicroSwitch` → `IronMicroSwitch`: global refresh mechanism removed;
  widget now reads `value` directly from props.
- `Label` → `IronLabel`: converted to `StatelessWidget`.
- `MiniText` → `IronMiniText`: converted to `StatelessWidget`.
- `show()` / `showValuesColumn()` / `showPercColumn()` functions →
  `Show` / `ShowValuesColumn` / `ShowPercColumn` `StatelessWidget` classes.
- Top-level mutable dimension variables migrated to `IronWidgetsTheme` tokens.
- Hardcoded colour literals replaced with `IronWidgetsTheme` resolution.
- `EditorDouble` removed from public API (not in widget catalogue).

### Fixed

- `Select<T>` / `MultiSelector<T>` legacy bug: `allOptionText`,
  `doneButtonText`, `cancelButtonText` were declared but never passed to the
  picker.  `IronSelect` and `IronMultiSelector` now wire them correctly.
- `flutter_custom_selector`: removed invalid `with CustomBottomSheetSelector<T>`
  usage on `StatefulWidget` (not a valid Dart 3 mixin application).
- `mounted` checks added after every `await` in `StatefulWidget` build paths.
