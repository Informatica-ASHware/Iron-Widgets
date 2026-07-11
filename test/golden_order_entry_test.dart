// Golden tests for the order-entry widgets (US-2.09 … US-2.12).
// Run `flutter test --update-goldens` to (re)generate the baselines.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _harness(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: IronWidgetsThemeScope(
    child: Scaffold(
      // Finandy-like dark navy canvas so gold/bull/bear colours read.
      backgroundColor: const Color(0xFF1E2430),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Align(alignment: Alignment.topLeft, child: child),
      ),
    ),
  ),
);

Future<void> _sizeView(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  final theme = IronWidgetsTheme.defaults();

  group('Golden – order entry', () {
    testWidgets('IronSegmented default and per-segment colours', (
      tester,
    ) async {
      await _sizeView(tester, const Size(320, 130));
      await tester.pumpWidget(
        _harness(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronSegmented<String>(
                segments: const ['LONG', 'SHORT'],
                value: 'SHORT',
                segmentWidth: 70,
                selectedColor: (s) =>
                    s == 'LONG' ? theme.bullColor : theme.bearColor,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              IronSegmented<String>(
                segments: const ['L', 'F', 'M', 'S', 'T'],
                value: 'M',
                segmentWidth: 34,
                onChanged: (_) {},
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_segmented_states.png'),
      );
    });

    testWidgets('IronPercentSlider with presets and editor', (tester) async {
      await _sizeView(tester, const Size(340, 140));
      await tester.pumpWidget(
        _harness(
          SizedBox(
            width: 280,
            child: IronPercentSlider(value: 75, onChanged: (_) {}),
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_percent_slider.png'),
      );
    });

    testWidgets('IronStepper', (tester) async {
      await _sizeView(tester, const Size(240, 90));
      await tester.pumpWidget(
        _harness(IronStepper(value: 5, min: 1, max: 125, onChanged: (_) {})),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_stepper.png'),
      );
    });

    testWidgets('IronActionButton variants, loading and disabled', (
      tester,
    ) async {
      await _sizeView(tester, const Size(280, 300));
      await tester.pumpWidget(
        _harness(
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IronActionButton(label: 'Confirm', onPressed: () {}),
              const SizedBox(height: 8),
              IronActionButton(
                label: 'Add LONG',
                sublabel: '≈ 431.2 USDT',
                variant: IronActionVariant.success,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              IronActionButton(
                label: 'Add SHORT',
                sublabel: '≈ 431.2 USDT',
                variant: IronActionVariant.danger,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              IronActionButton(
                label: 'Sending…',
                loading: true,
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              const IronActionButton(label: 'Disabled', onPressed: null),
            ],
          ),
        ),
      );
      // Single pump keeps the indeterminate spinner at a deterministic
      // first frame.
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_action_button_states.png'),
      );
      await tester.pumpWidget(const SizedBox()); // dispose the spinner
    });
  });
}
