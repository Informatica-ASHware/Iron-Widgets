Now let's run verification:---

## Verification commands

Run these in order from the `iron_widgets/` root once you have Flutter installed:

```bash
# 1. Install dependencies
flutter pub get

# 2. Static analysis – expect 0 issues
flutter analyze

# 3. Unit + theme tests (pass immediately)
flutter test test/widget_test.dart test/theme_test.dart

# 4. Generate golden baselines (first run only)
flutter test test/golden_test.dart --update-goldens

# 5. Subsequent golden comparison
flutter test test/golden_test.dart

# 6. Dry-run publish check
dart pub publish --dry-run

# 7. Example app
cd example && flutter pub get && flutter run -d chrome
```

---

## What was delivered (49 files)

| Layer | Files |
|---|---|
| Config & licences | `pubspec.yaml`, `analysis_options.yaml`, `.gitignore`, `LICENSE`, `LICENSE-flutter_custom_selector.txt`, `NOTICE.md` |
| Theme | `iron_colors`, `iron_dimens`, `iron_text_styles`, `iron_widgets_theme`, `iron_widgets_theme_scope` |
| Internal | `theme_resolver.dart` |
| Vendor (modernised) | 8 files under `lib/src/vendor/flutter_custom_selector/` + `LICENSE.txt` + `README.md` |
| Widgets | `iron_label`, `iron_mini_text`, `iron_check`, `iron_micro_switch`, `iron_micro_editor`, `iron_editor`, `iron_select`, `iron_enum`, `iron_multi_selector`, `iron_shows` |
| Barrel | `lib/iron_widgets.dart` |
| Tests | `widget_test`, `theme_test`, `golden_test` |
| Example app | `main`, `showcase_screen`, `theme_switcher`, `simple_widgets_section`, `shows_section` + `pubspec.yaml` + `README.md` |
| Docs | `README.md`, `CHANGELOG.md`, `MIGRATION.md`, `doc/theming_guide.md`, `doc/api_reference.md` |
