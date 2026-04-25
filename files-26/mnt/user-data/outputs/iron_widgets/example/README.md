# iron_widgets – Example App

Interactive showcase of every widget in the `iron_widgets` package.

## Running

```bash
cd example
flutter pub get
flutter run          # mobile / desktop
flutter run -d chrome  # web
```

## Three-mode theme switcher

The AppBar contains a `SegmentedButton` with three options:

| Mode | Effect |
|---|---|
| **Iron** | `IronWidgetsThemeScope` active; full Iron Man palette |
| **Light** | No `IronWidgetsThemeScope`; standard Material 3 light theme; widgets fall back to `IronWidgetsTheme.defaults()` |
| **Dark** | No `IronWidgetsThemeScope`; standard Material 3 dark theme |

The selection is **not** persisted between sessions; it resets to **Iron** on every cold start.

## Layout

| Breakpoint | Layout |
|---|---|
| < 768 px | Single-column, 16 px horizontal padding |
| ≥ 768 px | Centred column capped at 900 px, 48 px horizontal padding |
| ≥ 1280 px | Same as 768 px |
