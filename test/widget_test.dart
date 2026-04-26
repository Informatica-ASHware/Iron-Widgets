import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: IronWidgetsThemeScope(child: Scaffold(body: child)),
    );

void main() {
  group('IronLabel', () {
    testWidgets('renders text with colon by default', (tester) async {
      await tester.pumpWidget(_wrap(const IronLabel('Power')));
      expect(find.text('Power:'), findsOneWidget);
    });

    testWidgets('renders without colon when colon=false', (tester) async {
      await tester.pumpWidget(_wrap(const IronLabel('Power', colon: false)));
      expect(find.text('Power'), findsOneWidget);
      expect(find.text('Power:'), findsNothing);
    });
  });

  group('IronMiniText', () {
    testWidgets('renders text', (tester) async {
      await tester.pumpWidget(_wrap(const IronMiniText('42.5')));
      expect(find.text('42.5'), findsOneWidget);
    });

    testWidgets('right-aligns numeric strings', (tester) async {
      await tester.pumpWidget(_wrap(const IronMiniText('123')));
      final text = tester.widget<Text>(find.text('123'));
      expect(text.textAlign, TextAlign.right);
    });

    testWidgets('left-aligns non-numeric strings', (tester) async {
      await tester.pumpWidget(_wrap(const IronMiniText('Revenue')));
      final text = tester.widget<Text>(find.text('Revenue'));
      expect(text.textAlign, TextAlign.left);
    });
  });

  group('IronCheck', () {
    testWidgets('renders unchecked', (tester) async {
      await tester.pumpWidget(
        _wrap(IronCheck(label: 'Enable', value: false, onChanged: (_) {})),
      );
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isFalse);
    });

    testWidgets('renders checked', (tester) async {
      await tester.pumpWidget(
        _wrap(IronCheck(label: 'Enable', value: true, onChanged: (_) {})),
      );
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, isTrue);
    });

    testWidgets('fires onChanged when tapped', (tester) async {
      var received = false;
      await tester.pumpWidget(
        _wrap(
          IronCheck(
            label: 'Toggle',
            value: false,
            onChanged: (v) => received = v,
          ),
        ),
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(received, isTrue);
    });

    testWidgets('disabled checkbox is not interactive', (tester) async {
      var called = false;
      await tester.pumpWidget(
        _wrap(
          IronCheck(
            label: 'Disabled',
            value: false,
            onChanged: (_) => called = true,
            enabled: false,
          ),
        ),
      );
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      expect(called, isFalse);
    });
  });

  group('IronMicroSwitch', () {
    testWidgets('renders with correct text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          IronMicroSwitch(text: 'HUD', value: false, onChanged: (_) {}),
        ),
      );
      expect(find.text('HUD'), findsOneWidget);
    });

    testWidgets('fires onChanged when tapped', (tester) async {
      bool? toggled;
      await tester.pumpWidget(
        _wrap(
          IronMicroSwitch(
            text: 'HUD',
            value: false,
            onChanged: (v) => toggled = v,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      expect(toggled, isTrue);
    });

    testWidgets('does not fire when disabled', (tester) async {
      var called = false;
      await tester.pumpWidget(
        _wrap(
          IronMicroSwitch(
            text: 'HUD',
            value: false,
            onChanged: (_) => called = true,
            enabled: false,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();
      expect(called, isFalse);
    });
  });

  group('IronMicroEditor', () {
    testWidgets('shows initial value', (tester) async {
      await tester.pumpWidget(
        _wrap(IronMicroEditor(initialValue: '99', onChanged: (_) {})),
      );
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('fires onChanged on input', (tester) async {
      String? received;
      await tester.pumpWidget(
        _wrap(
          IronMicroEditor(
            initialValue: '0',
            onChanged: (v) => received = v,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), '42');
      expect(received, '42');
    });
  });

  group('IronEditor', () {
    testWidgets('shows initial value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          IronEditor(
            label: 'Name',
            initialValue: 'Tony',
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('Tony'), findsOneWidget);
    });

    testWidgets('fires onChanged on input', (tester) async {
      String? received;
      await tester.pumpWidget(
        _wrap(
          IronEditor(
            label: 'Name',
            onChanged: (v) => received = v,
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Pepper');
      expect(received, 'Pepper');
    });

    testWidgets('shows label with colon by default', (tester) async {
      await tester.pumpWidget(
        _wrap(
          IronEditor(label: 'Field', onChanged: (_) {}),
        ),
      );
      expect(find.text('Field:'), findsOneWidget);
    });
  });

  group('Show', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(
        _wrap(const Show(label: 'Open', value: '142.30')),
      );
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('142.30'), findsOneWidget);
    });

    testWidgets('editable mode renders IronMicroEditor', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Show(
            label: 'Qty',
            value: '10',
            editable: true,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.byType(IronMicroEditor), findsOneWidget);
    });
  });

  group('ShowValuesColumn', () {
    testWidgets('renders two Show rows', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ShowValuesColumn(
            topLabel: 'O',
            topValue: '100',
            bottomLabel: 'C',
            bottomValue: '99',
          ),
        ),
      );
      expect(find.byType(Show), findsNWidgets(2));
    });
  });

  group('ShowPercColumn', () {
    testWidgets('appends percent sign', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ShowPercColumn(
            topLabel: 'W',
            topValue: '62',
            bottomLabel: 'L',
            bottomValue: '38',
          ),
        ),
      );
      expect(find.text('62%'), findsOneWidget);
      expect(find.text('38%'), findsOneWidget);
    });
  });
}
