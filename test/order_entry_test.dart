import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: IronWidgetsThemeScope(
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  final defaults = IronWidgetsTheme.defaults();

  group('IronSegmented (US-2.09)', () {
    Widget build({
      required String value,
      ValueChanged<String>? onChanged,
      bool enabled = true,
      Color Function(String)? selectedColor,
    }) => _wrap(
      IronSegmented<String>(
        segments: const ['LONG', 'SHORT', 'BOTH'],
        value: value,
        enabled: enabled,
        selectedColor: selectedColor,
        onChanged: onChanged ?? (_) {},
      ),
    );

    testWidgets('tap selects a segment; tapping the selected one is a no-op', (
      tester,
    ) async {
      final calls = <String>[];
      await tester.pumpWidget(build(value: 'LONG', onChanged: calls.add));

      await tester.tap(find.text('SHORT'));
      expect(calls, ['SHORT']);

      await tester.tap(find.text('LONG'), warnIfMissed: false);
      expect(calls, ['SHORT']); // selected segment does not re-fire
    });

    testWidgets('arrow keys move the selection and clamp at the ends', (
      tester,
    ) async {
      final calls = <String>[];
      await tester.pumpWidget(build(value: 'SHORT', onChanged: calls.add));

      final focus = Focus.of(tester.element(find.text('LONG')));
      focus.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      expect(calls, ['BOTH']);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      expect(calls, ['BOTH', 'LONG']);

      // Clamped: from the first segment, Left does nothing.
      await tester.pumpWidget(build(value: 'LONG', onChanged: calls.add));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      expect(calls, ['BOTH', 'LONG']);
    });

    testWidgets('selected segment fills with gold by default and honours '
        'selectedColor', (tester) async {
      await tester.pumpWidget(build(value: 'LONG'));
      AnimatedContainer boxOf(String label) => tester.widget<AnimatedContainer>(
        find.ancestor(
          of: find.text(label),
          matching: find.byType(AnimatedContainer),
        ),
      );
      expect((boxOf('LONG').decoration! as BoxDecoration).color, defaults.gold);
      expect((boxOf('SHORT').decoration! as BoxDecoration).color, isNull);

      await tester.pumpWidget(
        build(
          value: 'SHORT',
          selectedColor: (s) =>
              s == 'SHORT' ? defaults.bearColor : defaults.bullColor,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        (boxOf('SHORT').decoration! as BoxDecoration).color,
        defaults.bearColor,
      );
    });

    testWidgets('disabled control ignores taps', (tester) async {
      final calls = <String>[];
      await tester.pumpWidget(
        build(value: 'LONG', enabled: false, onChanged: calls.add),
      );
      await tester.tap(find.text('SHORT'), warnIfMissed: false);
      expect(calls, isEmpty);
    });
  });

  group('IronPercentSlider (US-2.10)', () {
    Widget build({
      required double value,
      ValueChanged<double>? onChanged,
      bool editable = true,
      List<double> presets = const [10, 25, 50, 75, 97],
    }) => _wrap(
      SizedBox(
        width: 320,
        child: IronPercentSlider(
          value: value,
          editable: editable,
          presets: presets,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    );

    testWidgets('preset chips emit their value and mark selection', (
      tester,
    ) async {
      final calls = <double>[];
      await tester.pumpWidget(build(value: 0, onChanged: calls.add));

      await tester.tap(find.text('25%'));
      expect(calls, [25.0]);

      await tester.pumpWidget(build(value: 25, onChanged: calls.add));
      final chipBox = tester.widget<Container>(
        find.ancestor(of: find.text('25%'), matching: find.byType(Container)),
      );
      expect((chipBox.decoration! as BoxDecoration).color, defaults.gold);
    });

    testWidgets('dragging the slider emits clamped, rounded values', (
      tester,
    ) async {
      final calls = <double>[];
      await tester.pumpWidget(build(value: 50, onChanged: calls.add));

      await tester.drag(find.byType(Slider), const Offset(80, 0));
      expect(calls, isNotEmpty);
      expect(calls.last, greaterThan(50));
      expect(calls.last, lessThanOrEqualTo(100));
      expect(calls.last % 1, 0); // precision 0 → integers
    });

    testWidgets('typing in the coupled editor emits the parsed value '
        'and external changes update the text', (tester) async {
      final calls = <double>[];
      await tester.pumpWidget(build(value: 50, onChanged: calls.add));

      await tester.enterText(find.byType(TextField), '73');
      expect(calls, [73.0]);

      // External change (e.g. a preset elsewhere) rewrites the editor.
      await tester.pumpWidget(build(value: 97, onChanged: calls.add));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '97',
      );
    });

    testWidgets('editable: false hides the editor', (tester) async {
      await tester.pumpWidget(build(value: 50, editable: false));
      expect(find.byType(TextField), findsNothing);
    });
  });

  group('IronStepper (US-2.11)', () {
    Widget build({
      required double value,
      ValueChanged<double>? onChanged,
      double step = 1,
      double min = 0,
      double max = 10,
      int precision = 0,
    }) => _wrap(
      IronStepper(
        value: value,
        step: step,
        min: min,
        max: max,
        precision: precision,
        onChanged: onChanged ?? (_) {},
      ),
    );

    testWidgets('tapping ± steps once and clamps at the bounds', (
      tester,
    ) async {
      final calls = <double>[];
      await tester.pumpWidget(build(value: 9.0, onChanged: calls.add));

      await tester.tap(find.byIcon(Icons.add));
      expect(calls, [10.0]);

      await tester.pumpWidget(build(value: 10.0, onChanged: calls.add));
      await tester.tap(find.byIcon(Icons.add));
      expect(calls, [10.0]); // already at max → no extra call

      await tester.tap(find.byIcon(Icons.remove));
      expect(calls, [10.0, 9.0]);
    });

    testWidgets('holding a button repeats after the initial delay', (
      tester,
    ) async {
      var value = 0.0;
      late StateSetter rebuild;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return IronStepper(
                value: value,
                max: 100,
                onChanged: (v) => rebuild(() => value = v),
              );
            },
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byIcon(Icons.add)),
      );
      await tester.pump(); // immediate step on press
      expect(value, 1);

      // 400 ms delay + 5 × 100 ms pulses ≈ value 6.
      await tester.pump(const Duration(milliseconds: 950));
      expect(value, greaterThanOrEqualTo(5));

      await gesture.up();
      final settled = value;
      await tester.pump(const Duration(milliseconds: 500));
      expect(value, settled); // releasing stops the repeat
    });

    testWidgets('rounds to precision after stepping', (tester) async {
      final calls = <double>[];
      await tester.pumpWidget(
        build(
          value: 0.1,
          step: 0.2,
          max: 1,
          precision: 1,
          onChanged: calls.add,
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      expect(calls, [0.3]); // no floating-point noise
    });

    testWidgets('typing a value clamps and emits', (tester) async {
      final calls = <double>[];
      await tester.pumpWidget(build(value: 5, onChanged: calls.add));
      await tester.enterText(find.byType(TextField), '42');
      expect(calls, [10.0]); // clamped to max
    });
  });

  group('IronActionButton (US-2.12)', () {
    testWidgets('fires onPressed and renders label + sublabel', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          IronActionButton(
            label: 'Add SHORT',
            sublabel: '≈ 431.2 USDT',
            variant: IronActionVariant.danger,
            onPressed: () => taps++,
          ),
        ),
      );
      expect(find.text('Add SHORT'), findsOneWidget);
      expect(find.text('≈ 431.2 USDT'), findsOneWidget);

      await tester.tap(find.byType(IronActionButton));
      expect(taps, 1);
    });

    testWidgets('variants map to gold / bull / bear fills', (tester) async {
      Color fillOf(WidgetTester t) => t
          .widget<Material>(
            find.descendant(
              of: find.byType(IronActionButton),
              matching: find.byType(Material),
            ),
          )
          .color!;

      await tester.pumpWidget(
        _wrap(IronActionButton(label: 'Go', onPressed: () {})),
      );
      expect(fillOf(tester), defaults.gold);

      await tester.pumpWidget(
        _wrap(
          IronActionButton(
            label: 'Go',
            variant: IronActionVariant.success,
            onPressed: () {},
          ),
        ),
      );
      expect(fillOf(tester), defaults.bullColor);

      await tester.pumpWidget(
        _wrap(
          IronActionButton(
            label: 'Go',
            variant: IronActionVariant.danger,
            onPressed: () {},
          ),
        ),
      );
      expect(fillOf(tester), defaults.bearColor);
    });

    testWidgets('loading shows a spinner and suppresses taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          IronActionButton(label: 'Go', loading: true, onPressed: () => taps++),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Go'), findsNothing);

      await tester.tap(find.byType(IronActionButton));
      await tester.pump(const Duration(seconds: 1));
      expect(taps, 0);
    });

    testWidgets('null onPressed renders disabled with neutral fill', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const IronActionButton(label: 'Go', onPressed: null)),
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(IronActionButton),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, defaults.neutralSurface);
    });
  });
}
