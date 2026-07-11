// Golden tests for the enum dropdown selector (US-2.03).
// Run `flutter test --update-goldens` to (re)generate the baselines.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';
import 'package:iron_widgets/src/internal/iron_dropdown_overlay.dart';

enum _Side { buy, sell, both }

Widget _harness() => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: IronWidgetsThemeScope(
    child: Scaffold(
      // Finandy-like dark navy canvas so the elevated surface reads.
      backgroundColor: const Color(0xFF1E2430),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(
          alignment: Alignment.topLeft,
          child: IronEnum<_Side>(
            title: 'Side',
            label: 'Side',
            mode: IronSelectMode.dropdown,
            value: _Side.sell,
            options: _Side.values,
            itemAsString: (s) => s.name.toUpperCase(),
            width: 220,
            onChanged: (_) {},
          ),
        ),
      ),
    ),
  ),
);

Future<void> _sizeView(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 300);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  group('Golden – IronEnum dropdown', () {
    testWidgets('trigger closed', (tester) async {
      await _sizeView(tester);
      await tester.pumpWidget(_harness());
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_enum_dropdown_closed.png'),
      );
    });

    testWidgets('menu open with selected check', (tester) async {
      await _sizeView(tester);
      await tester.pumpWidget(_harness());
      await tester.tap(find.byType(IronDropdownField<_Side>));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_enum_dropdown_open.png'),
      );
    });
  });
}
