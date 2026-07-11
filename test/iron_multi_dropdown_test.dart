import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';
import 'package:iron_widgets/src/internal/iron_dropdown_overlay.dart';

const _options = ['Alpha', 'Beta', 'Mango', 'Zeta'];

Widget _wrap(Widget child) => MaterialApp(
  home: IronWidgetsThemeScope(
    child: Scaffold(body: Center(child: child)),
  ),
);

IronMultiSelector<String> _multi({
  IronSelectMode mode = IronSelectMode.dropdown,
  List<String> value = const [],
  bool searchable = false,
  bool enabled = true,
  String Function(List<String>)? summaryBuilder,
  ValueChanged<List<String>>? onChanged,
}) => IronMultiSelector<String>(
  title: 'Tags',
  label: 'Tags',
  mode: mode,
  value: value,
  options: _options,
  searchable: searchable,
  enabled: enabled,
  summaryBuilder: summaryBuilder,
  onChanged: onChanged ?? (_) {},
);

Finder get _field => find.byType(IronDropdownField<String>);

void main() {
  group('IronMultiSelector dropdown mode – immediate apply', () {
    testWidgets('toggling a row fires onChanged and keeps the panel open', (
      tester,
    ) async {
      final calls = <List<String>>[];
      await tester.pumpWidget(_wrap(_multi(onChanged: calls.add)));

      await tester.tap(_field);
      await tester.pumpAndSettle();
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);

      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      // Immediate apply: one callback per toggle…
      expect(calls, [
        ['Beta'],
      ]);
      // …and the panel is still open (other rows remain visible).
      expect(find.text('Mango'), findsOneWidget);

      await tester.tap(find.text('Mango'));
      await tester.pumpAndSettle();
      expect(calls.last, ['Beta', 'Mango']);

      // Toggling off removes from the selection.
      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      expect(calls.last, ['Mango']);
    });

    testWidgets('All row selects everything and clears on second tap', (
      tester,
    ) async {
      final calls = <List<String>>[];
      await tester.pumpWidget(_wrap(_multi(onChanged: calls.add)));
      await tester.tap(_field);
      await tester.pumpAndSettle();

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(calls.last, _options);

      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
      expect(calls.last, isEmpty);
      expect(find.text('Beta'), findsOneWidget); // panel still open
    });
  });

  group('IronMultiSelector dropdown mode – trigger summary', () {
    testWidgets('placeholder → single label → "n selected"', (tester) async {
      await tester.pumpWidget(_wrap(_multi()));
      expect(find.text('Tags'), findsOneWidget); // placeholder

      await tester.tap(_field);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(2, 2)); // close
      await tester.pumpAndSettle();
      expect(find.text('Beta'), findsOneWidget); // single item label

      await tester.tap(_field);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mango'));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(2, 2));
      await tester.pumpAndSettle();
      expect(find.text('2 selected'), findsOneWidget);
    });

    testWidgets('summaryBuilder overrides the default summary', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _multi(
            value: const ['Alpha', 'Beta'],
            summaryBuilder: (sel) => '${sel.length} tags!',
          ),
        ),
      );
      expect(find.text('2 tags!'), findsOneWidget);
    });
  });

  group('IronMultiSelector dropdown mode – keyboard', () {
    testWidgets('Space toggles the highlighted row without closing', (
      tester,
    ) async {
      final calls = <List<String>>[];
      await tester.pumpWidget(_wrap(_multi(onChanged: calls.add)));
      await tester.tap(_field);
      await tester.pumpAndSettle();

      // Highlight opens at row 0 (All); ArrowDown twice → 'Beta'.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(calls.last, ['Beta']);
      expect(find.text('Mango'), findsOneWidget); // panel still open

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Mango'), findsNothing);
    });

    testWidgets('Enter on the All row toggles the whole set', (tester) async {
      final calls = <List<String>>[];
      await tester.pumpWidget(_wrap(_multi(onChanged: calls.add)));
      await tester.tap(_field);
      await tester.pumpAndSettle();

      // Highlight opens at the All row (index 0).
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(calls.last, _options);
    });
  });

  group('IronMultiSelector dropdown mode – search', () {
    testWidgets('All row hides while a query is active', (tester) async {
      await tester.pumpWidget(_wrap(_multi(searchable: true)));
      await tester.tap(_field);
      await tester.pumpAndSettle();
      expect(find.text('All'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'a');
      await tester.pump();
      expect(find.text('All'), findsNothing);
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Zeta'), findsOneWidget);
    });
  });

  group('IronMultiSelector adaptive / regression / disabled', () {
    testWidgets('adaptive uses dropdown on Windows and legacy on Android', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;
      await tester.pumpWidget(_wrap(_multi(mode: IronSelectMode.adaptive)));
      final onDesktop = _field;
      final desktopHasDropdown = tester.widgetList(onDesktop).length == 1;

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(_wrap(_multi(mode: IronSelectMode.adaptive)));
      final mobileHasDropdown = tester.widgetList(_field).isNotEmpty;
      debugDefaultTargetPlatformOverride = null;

      expect(desktopHasDropdown, isTrue);
      expect(mobileHasDropdown, isFalse);
    });

    testWidgets('default mode keeps the legacy chips path', (tester) async {
      await tester.pumpWidget(
        _wrap(_multi(mode: IronSelectMode.bottomSheet, value: const ['Beta'])),
      );
      expect(_field, findsNothing);
      expect(find.byType(FilterChip), findsOneWidget);
    });

    testWidgets('disabled field does not open', (tester) async {
      await tester.pumpWidget(_wrap(_multi(enabled: false)));
      await tester.tap(_field);
      await tester.pumpAndSettle();
      expect(find.text('All'), findsNothing);
    });
  });
}
