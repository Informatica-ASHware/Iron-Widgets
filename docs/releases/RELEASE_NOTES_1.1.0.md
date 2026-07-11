# iron_widgets 1.1.0

16 new widgets/types inspired by trading UIs (Finandy), **zero new
dependencies** — all custom painting is `CustomPainter`-based.

## Added

- **Selectors, desktop-first**: `IronSelectMode` (`bottomSheet` ·
  `dropdown` · `adaptive`) for `IronSelect`, `IronEnum` and
  `IronMultiSelector`. The anchored dropdown flips when space runs out,
  closes on outside tap / `Esc` / focus loss / ancestor scroll, and ships
  full keyboard navigation (arrows with wrap, Enter/Space, Home/End,
  prefix typeahead) plus an optional inline search. Multi-select applies
  immediately, keeps the panel open, and adds an *All* row and a
  `'n selected'` trigger summary.
- **Market indicators**: `IronDeltaBadge`, `IronPriceTicker` (directional
  flash), `IronCountdown` (`Ticker`-driven, pausable), `IronSparkline`
  (trend-coloured, downsampling above 200 points).
- **Order entry**: `IronSegmented<T>` (per-segment colours — LONG=bull /
  SHORT=bear), `IronPercentSlider` (preset chips + coupled editor),
  `IronStepper` (hold-to-repeat via `Ticker`), `IronActionButton`
  (primary / success / danger, sublabel, loading).
- **Position & status**: `IronTag`, `IronRangeBar` (SL→TP with entry
  line and price marker), `IronGauge` (arc-reactor style with
  thresholds), `ShowGrid`/`ShowItem`.
- **Containers**: `IronPanel` (gold header, collapsible), `IronTabs`
  (gold underline indicator).
- **Semantic theme tokens** (optional, backward compatible): `bullColor`,
  `bearColor`, `surfaceElevated`, `cornerRadius`, `overlayMaxHeight`.

## Fixed

- Overflow-proof layouts for the legacy widgets (`Show` family,
  `IronEditor`, `IronCheck`) — root cause of the RenderFlex stripes in
  the example app. ⚠ **Upgrade note:** this changes their rendering (no
  API change); see `CHANGELOG.md § 1.1.0`.
- Golden baselines checked in + cross-platform comparator with a 5 %
  rasterization tolerance (`test/flutter_test_config.dart`).

## Quality

164 tests (32 goldens) · `analyze`/`format` clean across package and
example · example app guarded by an anti-overflow test at
360 / 800 / 1280 px · verified on macOS desktop.

Full details: `CHANGELOG.md § 1.1.0` and
`docs/specs/SPEC_WIDGETS_ROADMAP.md`.
