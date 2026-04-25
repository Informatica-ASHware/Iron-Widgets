import 'package:flutter/material.dart';

import '../theme/iron_widgets_theme.dart';

/// Resolves the nearest [IronWidgetsTheme] from [context].
///
/// Falls back to [IronWidgetsTheme.defaults()] when no theme is found in the
/// widget tree, so widgets work correctly without explicit theme setup.
IronWidgetsTheme resolveIronTheme(BuildContext context) =>
    Theme.of(context).extension<IronWidgetsTheme>() ??
    IronWidgetsTheme.defaults();
