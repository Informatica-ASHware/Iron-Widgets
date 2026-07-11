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

  group('Semantic tokens (US-2.01)', () {
    test('defaults expose the new tokens', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.bullColor, IronColors.bull);
      expect(theme.bearColor, IronColors.bear);
      expect(theme.surfaceElevated, IronColors.surfaceElevated);
      expect(theme.cornerRadius, IronDimens.cornerRadius);
      expect(theme.overlayMaxHeight, IronDimens.overlayMaxHeight);
    });

    test('bearColor is distinct from dangerColor by default', () {
      final theme = IronWidgetsTheme.defaults();
      expect(theme.bearColor, isNot(theme.dangerColor));
    });

    test('copyWith overrides each new token independently', () {
      final theme = IronWidgetsTheme.defaults().copyWith(
        bullColor: const Color(0xFF00FF00),
        bearColor: const Color(0xFFFF0000),
        surfaceElevated: const Color(0xFF101010),
        cornerRadius: 2,
        overlayMaxHeight: 100,
      );
      expect(theme.bullColor, const Color(0xFF00FF00));
      expect(theme.bearColor, const Color(0xFFFF0000));
      expect(theme.surfaceElevated, const Color(0xFF101010));
      expect(theme.cornerRadius, 2);
      expect(theme.overlayMaxHeight, 100);
      // Untouched tokens keep their defaults.
      expect(theme.gold, IronColors.gold);
    });

    test('equality and hashCode account for the new tokens', () {
      final base = IronWidgetsTheme.defaults();
      final changed = base.copyWith(cornerRadius: 3);
      expect(base, isNot(changed));
      expect(base.hashCode, isNot(changed.hashCode));
      expect(base, IronWidgetsTheme.defaults());
    });

    test('lerp interpolates the new tokens', () {
      final a = IronWidgetsTheme.defaults().copyWith(
        cornerRadius: 0,
        overlayMaxHeight: 100,
      );
      final b = IronWidgetsTheme.defaults().copyWith(
        cornerRadius: 10,
        overlayMaxHeight: 300,
      );
      final mid = a.lerp(b, 0.5);
      expect(mid.cornerRadius, 5);
      expect(mid.overlayMaxHeight, 200);
      final midBull = Color.lerp(a.bullColor, b.bullColor, 0.5);
      expect(mid.bullColor, midBull);
    });
  });

  group('IronColors', () {
    test('constants have expected values', () {
      expect(IronColors.darkRed, const Color(0xFFB30000));
      expect(IronColors.gold, const Color(0xFFFFD700));
      expect(IronColors.darkGray, const Color(0xFF333333));
      expect(IronColors.bull, const Color(0xFF26A69A));
      expect(IronColors.bear, const Color(0xFFEF5350));
      expect(IronColors.surfaceElevated, const Color(0xFF474747));
    });
  });

  group('IronDimens', () {
    test('constants have expected values', () {
      expect(IronDimens.microWidgetHeight, 20);
      expect(IronDimens.microFontSize, 10);
      expect(IronDimens.microIntWidth, 20);
      expect(IronDimens.microValueWidth, 60);
      expect(IronDimens.microPercentWidth, 60);
      expect(IronDimens.cornerRadius, 8);
      expect(IronDimens.overlayMaxHeight, 320);
    });
  });
}
