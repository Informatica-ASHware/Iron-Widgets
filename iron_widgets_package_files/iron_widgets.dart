/// Iron Widgets – a Flutter widget library with Iron Man aesthetics.
///
/// ## Quick start
///
/// Wrap your app (or any subtree) with [IronWidgetsThemeScope]:
///
/// ```dart
/// import 'package:iron_widgets/iron_widgets.dart';
///
/// IronWidgetsThemeScope(
///   child: MyScreen(),
/// )
/// ```
///
/// Or integrate fully with MaterialApp:
///
/// ```dart
/// MaterialApp(
///   theme: IronWidgetsTheme.defaults().buildMaterialTheme(),
///   home: MyScreen(),
/// )
/// ```
///
/// ## Widgets
///
/// | Widget | Description |
/// |---|---|
/// | [IronLabel] | Bold themed label |
/// | [IronMiniText] | Compact text, auto-aligns numerics |
/// | [IronCheck] | Labelled checkbox (controlled) |
/// | [IronMicroSwitch] | Compact toggle button |
/// | [IronMicroEditor] | Inline numeric text editor |
/// | [IronEditor] | Full text editor with label + debounce |
/// | [IronSelect] | Single-select bottom-sheet picker |
/// | [IronEnum] | Enum single-select picker |
/// | [IronMultiSelector] | Multi-select with FilterChip display |
/// | [Show] | Single label/value row |
/// | [ShowValuesColumn] | Two-row value panel |
/// | [ShowPercColumn] | Two-row percentage panel |
library iron_widgets;

// Theme
export 'src/theme/iron_colors.dart';
export 'src/theme/iron_dimens.dart';
export 'src/theme/iron_text_styles.dart';
export 'src/theme/iron_widgets_theme.dart';
export 'src/theme/iron_widgets_theme_scope.dart';

// Widgets
export 'src/iron_widgets/iron_check.dart';
export 'src/iron_widgets/iron_editor.dart';
export 'src/iron_widgets/iron_enum.dart';
export 'src/iron_widgets/iron_label.dart';
export 'src/iron_widgets/iron_micro_editor.dart';
export 'src/iron_widgets/iron_micro_switch.dart';
export 'src/iron_widgets/iron_mini_text.dart';
export 'src/iron_widgets/iron_multi_selector.dart';
export 'src/iron_widgets/iron_select.dart';
export 'src/iron_widgets/iron_shows.dart';
