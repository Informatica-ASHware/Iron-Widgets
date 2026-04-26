import 'package:flutter/material.dart';

import 'showcase_screen.dart';
import '../theme_switcher.dart';

void main() => runApp(const IronWidgetsExampleApp());

class IronWidgetsExampleApp extends StatefulWidget {
  const IronWidgetsExampleApp({super.key});

  @override
  State<IronWidgetsExampleApp> createState() => _IronWidgetsExampleAppState();
}

class _IronWidgetsExampleAppState extends State<IronWidgetsExampleApp> {
  // Resets to Iron on every cold start – not persisted.
  final ThemeSwitcherNotifier _notifier = ThemeSwitcherNotifier();

  @override
  void dispose() {
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _notifier,
        builder: (context, _) {
          final (:theme, useIronScope: _) = resolveTheme(_notifier.mode);
          return MaterialApp(
            title: 'Iron Widgets',
            debugShowCheckedModeBanner: false,
            theme: theme,
            // IronWidgetsTheme is injected per-screen by ShowcaseScreen so
            // that the three-mode switcher demo works correctly.
            home: ShowcaseScreen(notifier: _notifier),
          );
        },
      );
}
