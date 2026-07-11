// Golden tests for the multi-select dropdown (US-2.04).
// Run `flutter test --update-goldens` to (re)generate the baselines.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';
import 'package:iron_widgets/src/internal/iron_dropdown_overlay.dart';

const _options = ['Take profit', 'Stop loss', 'Trailing', 'Breakeven'];

Widget _harness({List<String> value = const []}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: IronWidgetsThemeScope(
    child: Scaffold(
      // Finandy-like dark navy canvas so the elevated surface reads.
      backgroundColor: const Color(0xFF1E2430),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topLeft,
          child: IronMultiSelector<String>(
            title: 'Protections',
            label: 'Protections',
            mode: IronSelectMode.dropdown,
            value: value,
            options: _options,
            width: 220,
            onChanged: (_) {},
          ),
        ),
      ),
    ),
  ),
);

Future<void> _sizeView(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 360);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('Golden – IronMultiSelector dropdown', () {
    testWidgets('trigger with "n selected" summary', (tester) async {
      await _sizeView(tester);
      await tester.pumpWidget(
        _harness(value: const ['Take profit', 'Stop loss']),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_multi_dropdown_closed.png'),
      );
    });

    testWidgets('open panel with All row and mixed checks', (tester) async {
      await _sizeView(tester);
      await tester.pumpWidget(
        _harness(value: const ['Take profit', 'Stop loss']),
      );
      await tester.tap(find.byType(IronDropdownField<String>));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_multi_dropdown_open.png'),
      );
    });
  });
}
