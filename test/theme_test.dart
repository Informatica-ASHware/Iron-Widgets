import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

void main() {
  group('IronWidgetsTheme.defaults()', () {
    test('has expected palette values', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.darkRed, const Color(0xFFB30000));
      expect(theme.gold, const Color(0xFFFFD700));
      expect(theme.darkGray, const Color(0xFF333333));
    });

    test('semantic role defaults match palette', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.valueBackground, theme.gold);
      expect(theme.borderAccent, theme.gold);
      expect(theme.dangerColor, theme.darkRed);
      expect(theme.neutralSurface, theme.darkGray);
    });

    test('micro dimension defaults match legacy constants', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.microWidgetHeight, 20);
      expect(theme.microFontSize, 10);
      expect(theme.microIntWidth, 20);
      expect(theme.microValueWidth, 60);
      expect(theme.microPercentWidth, 60);
    });
  });

  group('IronWidgetsTheme.copyWith()', () {
    test('overrides only specified fields', () {
      final base = IronWidgetsTheme.defaults();
      final custom = base.copyWith(darkRed: Colors.blue);
      expect(custom.darkRed, Colors.blue);
      expect(custom.gold, base.gold);
      expect(custom.darkGray, base.darkGray);
    });

    test('returns equal theme when no fields changed', () {
      final base = IronWidgetsTheme.defaults();
      final copy = base.copyWith();
      expect(copy, equals(base));
    });
  });

  group('IronWidgetsTheme.lerp()', () {
    test('returns self when other is null', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.lerp(null, 0.5), same(theme));
    });

    test('returns start at t=0', () {
      final a = IronWidgetsTheme.defaults();
      final b = a.copyWith(darkRed: Colors.blue);
      final result = a.lerp(b, 0);
      expect(result.darkRed, a.darkRed);
    });

    test('returns end at t=1', () {
      final a = IronWidgetsTheme.defaults();
      final b = a.copyWith(darkRed: Colors.blue);
      final result = a.lerp(b, 1);
      expect(result.darkRed, Colors.blue);
    });

    test('interpolates colour at t=0.5', () {
      final a = IronWidgetsTheme.defaults();
      final b = a.copyWith(microWidgetHeight: 40);
      final result = a.lerp(b, 0.5);
      expect(result.microWidgetHeight, closeTo(30, 0.1));
    });
  });

  group('IronWidgetsTheme.textColorOn()', () {
    test('returns black on light background', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.textColorOn(Colors.white), Colors.black);
    });

    test('returns white on dark background', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.textColorOn(Colors.black), Colors.white);
    });

    test('returns black on gold (luminance > 0.179)', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.textColorOn(theme.gold), Colors.black);
    });
  });

  group('IronWidgetsTheme.buildMaterialTheme()', () {
    test('light theme has correct primary', () {
      final theme = IronWidgetsTheme.defaults();
      final material = theme.buildMaterialTheme();
      expect(material.colorScheme.primary, const Color(0xFFB30000));
    });

    test('dark theme has dark surface', () {
      final theme = IronWidgetsTheme.defaults();
      final material = theme.buildMaterialTheme(brightness: Brightness.dark);
      expect(material.colorScheme.brightness, Brightness.dark);
    });

    test('theme extension is registered', () {
      final ironTheme = IronWidgetsTheme.defaults();
      final material = ironTheme.buildMaterialTheme();
      expect(material.extension<IronWidgetsTheme>(), isNotNull);
    });
  });

  group('IronWidgetsThemeScope', () {
    testWidgets('injects IronWidgetsTheme into tree', (tester) async {
      IronWidgetsTheme? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: IronWidgetsThemeScope(
            child: Builder(
              builder: (context) {
                captured = Theme.of(context).extension<IronWidgetsTheme>();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(captured, isNotNull);
    });

    testWidgets('uses provided theme over defaults', (tester) async {
      IronWidgetsTheme? captured;
      final custom = IronWidgetsTheme.defaults().copyWith(
        darkRed: Colors.purple,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: IronWidgetsThemeScope(
            theme: custom,
            child: Builder(
              builder: (context) {
                captured = Theme.of(context).extension<IronWidgetsTheme>();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(captured?.darkRed, Colors.purple);
    });

    testWidgets('falls back to defaults when no scope in tree', (tester) async {
      IronWidgetsTheme? captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              captured = Theme.of(context).extension<IronWidgetsTheme>();
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      // No scope → no extension in theme, resolveIronTheme returns defaults.
      expect(captured, isNull);
    });
  });

  group('IronColors', () {
    test('constants have expected values', () {
      expect(IronColors.darkRed, const Color(0xFFB30000));
      expect(IronColors.gold, const Color(0xFFFFD700));
      expect(IronColors.darkGray, const Color(0xFF333333));
    });
  });

  group('IronDimens', () {
    test('constants have expected values', () {
      expect(IronDimens.microWidgetHeight, 20);
      expect(IronDimens.microFontSize, 10);
      expect(IronDimens.microIntWidth, 20);
      expect(IronDimens.microValueWidth, 60);
      expect(IronDimens.microPercentWidth, 60);
    });
  });
}
