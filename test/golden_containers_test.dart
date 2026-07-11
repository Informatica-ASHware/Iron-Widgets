// Golden tests for the container widgets (US-2.17, US-2.18).
// Run `flutter test --update-goldens` to (re)generate the baselines.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _harness(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  home: IronWidgetsThemeScope(
    child: Scaffold(
      // Finandy-like dark navy canvas so the elevated surface reads.
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
  group('Golden – containers', () {
    testWidgets('IronPanel expanded and collapsed', (tester) async {
      await _sizeView(tester, const Size(340, 260));
      await tester.pumpWidget(
        _harness(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IronPanel(
                title: 'SETTINGS',
                trailing: IronTag('PERP'),
                collapsible: true,
                child: Row(
                  children: [
                    IronDeltaBadge(2.34),
                    SizedBox(width: 8),
                    IronTag('×20', variant: IronTagVariant.gold),
                  ],
                ),
              ),
              SizedBox(height: 12),
              IronPanel(
                title: 'ASSETS',
                collapsible: true,
                initiallyExpanded: false,
                child: Text('hidden'),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_panel_states.png'),
      );
    });

    testWidgets('IronTabs with gold indicator', (tester) async {
      await _sizeView(tester, const Size(320, 90));
      await tester.pumpWidget(
        _harness(
          IronTabs(
            tabs: const ['Order', 'SL', 'SLX', 'TP'],
            index: 1,
            onChanged: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/iron_tabs.png'),
      );
    });
  });
}
