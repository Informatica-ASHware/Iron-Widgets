// Golden tests for the position & status widgets (US-2.13 … US-2.16).
// Run `flutter test --update-goldens` to (re)generate the baselines.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _harness(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: IronWidgetsThemeScope(
    child: Scaffold(
      // Finandy-like dark navy canvas so semantic colours read.
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
  group('Golden – position & status', () {
    testWidgets('IronTag variants', (tester) async {
      await _sizeView(tester, const Size(380, 80));
      await tester.pumpWidget(
        _harness(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IronTag('SHORT', variant: IronTagVariant.bear),
              SizedBox(width: 6),
              IronTag('LONG', variant: IronTagVariant.bull),
              SizedBox(width: 6),
              IronTag('×20', variant: IronTagVariant.gold),
              SizedBox(width: 6),
              IronTag('Isol'),
              SizedBox(width: 6),
              IronTag('PERP'),
            ],
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_tag_variants.png'),
      );
    });

    testWidgets('IronRangeBar in profit and in loss', (tester) async {
      await _sizeView(tester, const Size(300, 140));
      await tester.pumpWidget(
        _harness(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronRangeBar(
                min: 41000,
                max: 45000,
                entry: 43000,
                current: 43850,
                width: 220,
                showLabels: true,
                precision: 0,
              ),
              SizedBox(height: 16),
              IronRangeBar(
                min: 41000,
                max: 45000,
                entry: 43000,
                current: 42100,
                width: 220,
              ),
            ],
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_range_bar_states.png'),
      );
    });

    testWidgets('IronGauge normal and danger', (tester) async {
      await _sizeView(tester, const Size(300, 130));
      await tester.pumpWidget(
        _harness(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IronGauge(value: 0.72, label: 'Margin', thresholds: [0.5, 0.9]),
              SizedBox(width: 24),
              IronGauge(value: 0.95, label: 'Risk', thresholds: [0.5, 0.9]),
            ],
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_gauge_states.png'),
      );
    });

    testWidgets('ShowGrid stats header', (tester) async {
      await _sizeView(tester, const Size(460, 120));
      await tester.pumpWidget(
        _harness(
          const SizedBox(
            width: 400,
            child: ShowGrid(
              items: [
                ShowItem('Volume', '1.2M'),
                ShowItem('High', '43910.0'),
                ShowItem('Low', '42115.5'),
                ShowItem('Funding', '0.0100%'),
              ],
            ),
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/show_grid_stats.png'),
      );
    });
  });
}
