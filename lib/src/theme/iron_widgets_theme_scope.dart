import 'package:flutter/material.dart';

import '../lib/src/theme/iron_widgets_theme.dart';

/// Injects an [IronWidgetsTheme] into the widget tree without replacing the
/// consumer's [ThemeData].
///
/// Wrap any subtree that should render with Iron Widgets theming:
///
/// ```dart
/// IronWidgetsThemeScope(
///   child: MyDashboard(),
/// )
/// ```
///
/// Pass a custom theme to override individual tokens:
///
/// ```dart
/// IronWidgetsThemeScope(
///   theme: IronWidgetsTheme.defaults().copyWith(gold: Colors.amber),
///   child: MyDashboard(),
/// )
/// ```
///
/// When [theme] is `null`, [IronWidgetsTheme.defaults()] is used.
class IronWidgetsThemeScope extends StatelessWidget {
  /// Creates an [IronWidgetsThemeScope].
  const IronWidgetsThemeScope({
    super.key,
    required this.child,
    this.theme,
  });

  /// The Iron Widgets theme to inject.  Defaults to [IronWidgetsTheme.defaults()].
  final IronWidgetsTheme? theme;

  /// The widget subtree that will receive the injected theme.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parentTheme = Theme.of(context);
    final ironTheme = theme ?? IronWidgetsTheme.defaults();
    return Theme(
      data: parentTheme.copyWith(
        extensions: [
          ...parentTheme.extensions.values
              .where((e) => e is! IronWidgetsTheme),
          ironTheme,
        ],
      ),
      child: child,
    );
  }
}
