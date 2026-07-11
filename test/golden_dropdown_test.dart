// Golden tests for the dropdown selector (US-2.02).
// Run `flutter test --update-goldens` to (re)generate the baselines.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';
import 'package:iron_widgets/src/internal/iron_dropdown_overlay.dart';

const _options = [
  'Last price',
  'Order book',
  '1m candle',
  '5m candle',
  '1h candle',
];

Widget _harness({String? value, bool enabled = true}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: IronWidgetsThemeScope(
    child: Scaffold(
      // Finandy-like dark navy canvas so the elevated surface reads.
      backgroundColor: const Color(0xFF1E2430),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topLeft,
          child: IronSelect<String>(
            title: 'Trigger price',
            label: 'Trigger price',
            mode: IronSelectMode.dropdown,
            options: _options,
            value: value,
            enabled: enabled,
            width: 220,
            onChanged: (_) {},
          ),
        ),
      ),
    ),
  ),
);

Future<void> _sizeView(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 420);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('Golden – IronSelect dropdown', () {
    testWidgets('trigger closed', (tester) async {
      await _sizeView(tester);
      await tester.pumpWidget(_harness(value: 'Last price'));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_select_dropdown_closed.png'),
      );
    });

    testWidgets('menu open with selected check', (tester) async {
      await _sizeView(tester);
      await tester.pumpWidget(_harness(value: 'Last price'));
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_select_dropdown_open.png'),
      );
    });

    testWidgets('trigger disabled', (tester) async {
      await _sizeView(tester);
      await tester.pumpWidget(_harness(value: 'Last price', enabled: false));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_select_dropdown_disabled.png'),
      );
    });
  });
}
