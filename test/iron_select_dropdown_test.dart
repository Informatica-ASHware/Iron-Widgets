import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';
import 'package:iron_widgets/src/internal/iron_dropdown_overlay.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: IronWidgetsThemeScope(
    child: Scaffold(body: Center(child: child)),
  ),
);

IronSelect<String> _select({
  IronSelectMode mode = IronSelectMode.dropdown,
  List<String> options = const ['Alpha', 'Beta', 'Mango'],
  String? value,
  bool searchable = false,
  bool enabled = true,
  ValueChanged<String>? onChanged,
}) => IronSelect<String>(
  title: 'Fruit',
  label: 'Fruit',
  mode: mode,
  options: options,
  value: value,
  searchable: searchable,
  enabled: enabled,
  onChanged: onChanged ?? (_) {},
);

void main() {
  group('ironDropdownForPlatform (US-2.02 resolver)', () {
    test('explicit modes ignore platform and web', () {
      for (final platform in TargetPlatform.values) {
        for (final web in [true, false]) {
          expect(
            ironDropdownForPlatform(
              IronSelectMode.dropdown,
              platform: platform,
              isWeb: web,
            ),
            isTrue,
          );
          expect(
            ironDropdownForPlatform(
              IronSelectMode.bottomSheet,
              platform: platform,
              isWeb: web,
            ),
            isFalse,
          );
        }
      }
    });

    test('adaptive resolves dropdown on desktop, bottom sheet on touch', () {
      const desktop = [
        TargetPlatform.linux,
        TargetPlatform.macOS,
        TargetPlatform.windows,
      ];
      const touch = [
        TargetPlatform.android,
        TargetPlatform.iOS,
        TargetPlatform.fuchsia,
      ];
      for (final platform in desktop) {
        expect(
          ironDropdownForPlatform(
            IronSelectMode.adaptive,
            platform: platform,
            isWeb: false,
          ),
          isTrue,
        );
      }
      for (final platform in touch) {
        expect(
          ironDropdownForPlatform(
            IronSelectMode.adaptive,
            platform: platform,
            isWeb: false,
          ),
          isFalse,
        );
      }
    });

    test('adaptive on web resolves dropdown regardless of platform', () {
      for (final platform in TargetPlatform.values) {
        expect(
          ironDropdownForPlatform(
            IronSelectMode.adaptive,
            platform: platform,
            isWeb: true,
          ),
          isTrue,
        );
      }
    });
  });

  group('IronSelect dropdown mode – pointer interaction', () {
    testWidgets('opens on tap and selects on option tap', (tester) async {
      String? selected;
      await tester.pumpWidget(_wrap(_select(onChanged: (v) => selected = v)));
      expect(find.text('Beta'), findsNothing);

      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(selected, 'Beta');
      // Menu closed: other options are gone, trigger shows the selection.
      expect(find.text('Mango'), findsNothing);
      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('tap outside closes without selecting', (tester) async {
      String? selected;
      await tester.pumpWidget(_wrap(_select(onChanged: (v) => selected = v)));
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();
      expect(find.text('Mango'), findsOneWidget);

      await tester.tapAt(const Offset(2, 2));
      await tester.pumpAndSettle();
      expect(find.text('Mango'), findsNothing);
      expect(selected, isNull);
    });

    testWidgets('selected value shows a gold check in the menu', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_select(value: 'Beta')));
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('disabled field does not open', (tester) async {
      await tester.pumpWidget(_wrap(_select(enabled: false)));
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('menu flips above the trigger when space below is short', (
      tester,
    ) async {
      final options = List.generate(10, (i) => 'Item $i');
      await tester.pumpWidget(
        MaterialApp(
          home: IronWidgetsThemeScope(
            child: Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: _select(options: options),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();

      final menuRowTop = tester.getTopLeft(find.text('Item 0')).dy;
      final triggerTop = tester
          .getTopLeft(find.byType(IronDropdownField<String>))
          .dy;
      expect(menuRowTop, lessThan(triggerTop));
    });
  });

  group('IronSelect dropdown mode – keyboard', () {
    testWidgets('Escape closes the menu', (tester) async {
      await tester.pumpWidget(_wrap(_select()));
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('ArrowDown + Enter selects the highlighted option', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(_wrap(_select(onChanged: (v) => selected = v)));
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();

      // Highlight starts at index 0 (Alpha); one ArrowDown → Beta.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected, 'Beta');
    });

    testWidgets('typeahead jumps to the first prefix match', (tester) async {
      String? selected;
      await tester.pumpWidget(_wrap(_select(onChanged: (v) => selected = v)));
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();

      await tester.sendKeyEvent(LogicalKeyboardKey.keyM);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected, 'Mango');
    });
  });

  group('IronSelect dropdown mode – searchable', () {
    testWidgets('typing filters options and Enter selects the first match', (
      tester,
    ) async {
      String? selected;
      await tester.pumpWidget(
        _wrap(_select(searchable: true, onChanged: (v) => selected = v)),
      );
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'man');
      await tester.pump();
      expect(find.text('Alpha'), findsNothing);
      expect(find.text('Mango'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected, 'Mango');
    });

    testWidgets('empty filter shows the empty-result text', (tester) async {
      await tester.pumpWidget(_wrap(_select(searchable: true)));
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();
      expect(find.text('No results'), findsOneWidget);
    });
  });

  group('IronSelect adaptive mode', () {
    testWidgets('uses dropdown on macOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      await tester.pumpWidget(_wrap(_select(mode: IronSelectMode.adaptive)));
      final dropdown = find.byType(IronDropdownField<String>);
      // Reset inside the body: the binding verifies foundation debug
      // variables right after it, before tear-downs run.
      debugDefaultTargetPlatformOverride = null;
      expect(dropdown, findsOneWidget);
    });

    testWidgets('uses bottom sheet on iOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(_wrap(_select(mode: IronSelectMode.adaptive)));
      final dropdown = find.byType(IronDropdownField<String>);
      debugDefaultTargetPlatformOverride = null;
      expect(dropdown, findsNothing);
    });
  });

  group('IronSelect bottom-sheet mode regression', () {
    testWidgets('default mode keeps the legacy picker path', (tester) async {
      await tester.pumpWidget(_wrap(_select(mode: IronSelectMode.bottomSheet)));
      expect(find.byType(IronDropdownField<String>), findsNothing);
    });
  });
}
