# flutter_custom_selector (vendored)

This directory contains a vendored copy of
[flutter_custom_selector](https://github.com/hbrhbr/flutter_custom_select),
originally published on pub.dev under the BSD 2-Clause license.

## Modifications made for iron_widgets

| Change | Reason |
|---|---|
| Removed `with CustomBottomSheetSelector<T>` mixin usage on StatefulWidget classes | Invalid in Dart 3 – mixin must be declared with `mixin` keyword |
| Applied `super.key` in all constructors | Dart 3 super-parameter syntax |
| Replaced `Container` with `ColoredBox`/`SizedBox`/`DecoratedBox` where appropriate | Performance & lint compliance |
| Added `doneButtonText`, `cancelButtonText`, `allOptionText` parameters | Expose localisation surface to iron_widgets consumers |
| `const` constructors applied aggressively | Performance |
| All `var _list` → `final list` | `prefer_final_locals` lint |
| Trailing commas added throughout | `require_trailing_commas` lint |
| `prefer_single_quotes` applied | Lint compliance |

The public API consumed by IronEnum, IronSelect, IronMultiSelector is unchanged.

See `MIGRATION.md` at the package root for the full change log.
