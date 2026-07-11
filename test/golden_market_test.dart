// Golden tests for the market indicator widgets (US-2.05 … US-2.08).
// Run `flutter test --update-goldens` to (re)generate the baselines.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _harness(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: IronWidgetsThemeScope(
    child: Scaffold(
      // Finandy-like dark navy canvas so bull/bear colours read.
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
  group('Golden – market indicators', () {
    testWidgets('IronDeltaBadge states', (tester) async {
      await _sizeView(tester, const Size(300, 90));
      await tester.pumpWidget(
        _harness(
          const Row(
            children: [
              IronDeltaBadge(2.34),
              SizedBox(width: 8),
              IronDeltaBadge(-1.2, precision: 1),
              SizedBox(width: 8),
              IronDeltaBadge(0),
            ],
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_delta_badge_states.png'),
      );
    });

    testWidgets('IronPriceTicker resting and flashing', (tester) async {
      await _sizeView(tester, const Size(300, 110));
      await tester.pumpWidget(
        _harness(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronPriceTicker(price: 43250.5, precision: 1, suffix: ' USDT'),
              SizedBox(height: 8),
              IronPriceTicker(
                price: 43250.5,
                previous: 43000,
                precision: 1,
                suffix: ' USDT',
              ),
              SizedBox(height: 8),
              IronPriceTicker(
                price: 43250.5,
                previous: 43500,
                precision: 1,
                suffix: ' USDT',
              ),
            ],
          ),
        ),
      );
      // First frame: flashing tickers sit exactly on bull/bear.
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_price_ticker_states.png'),
      );
      await tester.pumpAndSettle(); // let flashes finish before teardown
    });

    testWidgets('IronCountdown normal and warning', (tester) async {
      await _sizeView(tester, const Size(300, 100));
      await tester.pumpWidget(
        _harness(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronCountdown(remaining: Duration(seconds: 125)),
              SizedBox(height: 8),
              IronCountdown(
                remaining: Duration(seconds: 10),
                warningFraction: 0.5,
              ),
            ],
          ),
        ),
      );
      // Advance a deterministic 6 s: 125 s → 01:59, 10 s → 00:04 (warning).
      await tester.pump(const Duration(seconds: 6));
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_countdown_states.png'),
      );
      await tester.pumpWidget(const SizedBox()); // dispose active tickers
    });

    testWidgets('IronSparkline trends', (tester) async {
      await _sizeView(tester, const Size(300, 180));
      await tester.pumpWidget(
        _harness(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IronSparkline([41.2, 41.8, 41.5, 42.9, 42.4, 43.1]),
              SizedBox(height: 12),
              IronSparkline([43.1, 42.4, 42.9, 41.5, 41.8, 41.2]),
              SizedBox(height: 12),
              IronSparkline([42, 42, 42, 42], fill: false),
            ],
          ),
        ),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_sparkline_states.png'),
      );
    });
  });
}
