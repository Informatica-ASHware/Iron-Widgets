# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## [Unreleased]

### Fixed

- Overflow-proof layouts for the legacy widgets (root cause of the
  RenderFlex stripes visible in the example app and of 7 failing
  tests): `Show` (fixed 60 px cell → min-width cell with ellipsis and
  edge-pinned label/value when bounded, also fixing `ShowValuesColumn`,
  `ShowPercColumn` and `ShowGrid`), `IronEditor` (double width
  accounting in beside-label mode → label flexes and the field expands
  within the declared `width`; multi-line fields now size to intrinsic
  height instead of the undercounting `lines × 18` formula) and
  `IronCheck` (long labels scale down within `width`).
- Example app hardened for narrow viewports (rows → `Wrap` in the
  market, order-entry and position sections; realistic `Show` labels)
  and guarded by a new overflow test that scrolls the full showcase at
  360 / 800 / 1280 px asserting zero layout exceptions.
- Golden baselines for the legacy widget suite checked in
  (`test/goldens/`, generated on the CI toolchain, Flutter 3.41.7 /
  Linux) reflecting the corrected layouts.

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
- **US-2.09** – `IronSegmented<T>`: compact segmented control for closed
  sets (LONG/SHORT, PNL filters, timeframes) with per-segment
  `selectedColor` (e.g. bull/bear sides), automatic text contrast via
  `textColorOn` and Left/Right keyboard navigation.
- **US-2.10** – `IronPercentSlider`: gold slider with preset chips
  (default `10/25/50/75/97`) and a coupled `IronMicroEditor`; all input
  sources emit clamped, precision-rounded values and the editor follows
  external changes without disturbing the caret.
- **US-2.11** – `IronStepper`: `IronMicroEditor` with `−`/`+` buttons,
  hold-to-repeat via `Ticker` (400 ms delay, 100 ms pulses, local
  accumulator so pulses never depend on parent rebuilds), min/max
  clamping and precision rounding.
- **US-2.12** – `IronActionButton`: large CTA with
  `IronActionVariant.{primary,success,danger}` mapped to
  `gold`/`bullColor`/`bearColor`, optional `sublabel` and `loading`
  spinner state. Completes Phase 3 (order entry); the example app gains
  an interactive "Order Entry" form section.
- **US-2.13** – `IronTag`: mini metadata chip with
  `IronTagVariant.{gold,bull,bear,neutral}` (SHORT / Isol ×20 / PERP
  style), tinted fills with hairline borders.
- **US-2.14** – `IronRangeBar`: `CustomPainter` SL→TP range bar with a
  gold entry line and current-price dot; the entry↔current segment fills
  `bullColor` in profit or `bearColor` in loss; optional coloured labels
  and clamped painting for out-of-range values.
- **US-2.15** – `IronGauge`: arc-reactor-style 270° gauge (`gold` arc
  with glow and concentric inner ring) for normalized values, threshold
  ticks and `dangerColor` past the last threshold.
- **US-2.16** – `ShowGrid` + `ShowItem`: stats-header grid of `Show`
  cells in equal-width columns with padded incomplete rows. Completes
  Phase 4 (position & status); the example app gains an interactive
  "Position & Status" card section.
- **US-2.17** – `IronPanel`: elevated card with gold header, optional
  `trailing` widget and animated `collapsible` body
  (`initiallyExpanded`, `onExpansionChanged`).
- **US-2.18** – `IronTabs`: compact index-based tabs with a gold
  underline indicator and Left/Right keyboard navigation; complementary
  to `IronSegmented` (tabs navigate, segments select). Completes
  Phase 5 (containers) and closes `SPEC_WIDGETS_ROADMAP` — all 18 user
  stories (US-2.01 … US-2.18) implemented; the example app gains a
  "Containers" section with a tabbed panel demo.

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
