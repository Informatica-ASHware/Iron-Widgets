import 'package:flutter/material.dart';
import 'package:iron_widgets/iron_widgets.dart';

/// Governs the three display modes exposed in the AppBar.
enum ThemeMode3 {
  iron,
  materialLight,
  materialDark,
}

/// Provides the [ThemeMode3] value to descendants and rebuilds them on change.
class ThemeSwitcherNotifier extends ChangeNotifier {
  ThemeSwitcherNotifier() : _mode = ThemeMode3.iron;

  ThemeMode3 _mode;

  ThemeMode3 get mode => _mode;

  void set(ThemeMode3 m) {
    if (_mode == m) return;
    _mode = m;
    notifyListeners();
  }
}

/// Resolves [ThemeData] and whether to wrap with [IronWidgetsThemeScope].
({ThemeData theme, bool useIronScope}) resolveTheme(ThemeMode3 mode) =>
    switch (mode) {
      ThemeMode3.iron => (
          theme: IronWidgetsTheme.defaults()
              .buildMaterialTheme(brightness: Brightness.light),
          useIronScope: true,
        ),
      ThemeMode3.materialLight => (
          theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
          useIronScope: false,
        ),
      ThemeMode3.materialDark => (
          theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
          useIronScope: false,
        ),
    };

/// A [SegmentedButton] wired to [ThemeSwitcherNotifier].
class ThemeSegmentedButton extends StatelessWidget {
  const ThemeSegmentedButton({super.key, required this.notifier});

  final ThemeSwitcherNotifier notifier;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: notifier,
        builder: (context, _) => SegmentedButton<ThemeMode3>(
          segments: const [
            ButtonSegment(
              value: ThemeMode3.iron,
              label: Text('Iron'),
              icon: Icon(Icons.bolt),
            ),
            ButtonSegment(
              value: ThemeMode3.materialLight,
              label: Text('Light'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment(
              value: ThemeMode3.materialDark,
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode),
            ),
          ],
          selected: {notifier.mode},
          onSelectionChanged: (s) => notifier.set(s.first),
          style: SegmentedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      );
}
