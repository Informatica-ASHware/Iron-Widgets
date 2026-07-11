# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## [Unreleased]

### Added

- **US-2.01** – Semantic theme tokens in `IronWidgetsTheme` (all optional
  with defaults; fully backward compatible): `bullColor`, `bearColor`
  (market *direction*, distinct from `dangerColor` severity),
  `surfaceElevated`, `cornerRadius`, `overlayMaxHeight`. New matching
  constants in `IronColors` / `IronDimens`.
- **US-2.02** – `IronSelectMode` (`bottomSheet` | `dropdown` | `adaptive`)
  and desktop-first anchored dropdown for `IronSelect`. The overlay flips
  vertically when space runs out, closes on outside tap / `Esc` / focus
  loss / ancestor scroll, and supports full keyboard navigation (arrows
  with wrap, `Enter`/`Space`, `Home`/`End`, prefix typeahead) plus an
  optional inline `searchable` filter. New `IronSelect` parameters:
  `mode`, `menuWidth`, `menuMaxHeight`, `searchable`, `enabled` (the
  latter also applies to the bottom-sheet mode). Default mode remains
  `bottomSheet` — no behavioural change for existing code.
- **US-2.03** – `IronEnum` gains the same presentation modes and
  parameters as `IronSelect` (`mode`, `menuWidth`, `menuMaxHeight`,
  `searchable`, `enabled`). In dropdown mode the keyboard highlight opens
  on the current value (non-nullable in `IronEnum`), marked with a gold
  check. Default remains `bottomSheet`.
- **US-2.04** – `IronMultiSelector` gains dropdown mode with immediate
  apply: rows show an Iron-style checkbox (`dangerColor` fill, matching
  `IronCheck`), every toggle fires `onChanged` and the panel stays open;
  an `allOptionText` row toggles the whole set (hidden while searching);
  the compact trigger shows a selection summary (`'n selected'`,
  customisable via the new `summaryBuilder`). Same new parameters as the
  other selectors (`mode`, `menuWidth`, `menuMaxHeight`, `searchable`,
  `enabled`). Closes Phase 1 of `SPEC_WIDGETS_ROADMAP`; the example app
  gains a "Selectors – Dropdown Mode" section.
- **US-2.05** – `IronDeltaBadge`: signed-change pill coloured by market
  direction (`bullColor` / `bearColor`), neutral at exactly zero, with
  `precision`, `showSign` and `suffix`.
- **US-2.06** – `IronPriceTicker`: price display that flashes towards
  `bullColor` / `bearColor` on change and fades back over
  `flashDuration`; tabular figures, `RepaintBoundary`, no timers created
  in build.
- **US-2.07** – `IronCountdown`: `Ticker`-driven countdown (no `Timer`s)
  from `until` or `remaining`; pausable, `onFinished` fires exactly once,
  `dangerColor` below `warningFraction`, custom `format` supported.
- **US-2.08** – `IronSparkline`: zero-dependency `CustomPainter` trend
  line with bull/bear colouring (`positiveIsBull` to invert), optional
  gradient `fill` and uniform downsampling above 200 points. Completes
  Phase 2 (market indicators); the example app gains a "Market
  Indicators" section.

## 2026-04-28

### Changes

---

Packages with breaking changes:

 - There are no breaking changes in this release.

Packages with other changes:

 - [`iron_widgets` - `v1.0.2`](#iron_widgets---v102)

---

#### `iron_widgets` - `v1.0.2`

## 1.0.2

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
