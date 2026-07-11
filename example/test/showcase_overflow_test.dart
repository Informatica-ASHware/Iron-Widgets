// Overflow guard for the full showcase.
//
// Pumps the complete example app at phone, default and desktop widths and
// scrolls through every section. Any RenderFlex overflow (or other layout
// exception) surfaces through `tester.takeException()` and fails the test,
// so no widget in the showcase may overflow at these sizes.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets_example/main.dart';

Future<void> _scrollThrough(WidgetTester tester) async {
  final scrollable = find.byType(Scrollable).first;
  for (var i = 0; i < 30; i++) {
    await tester.drag(scrollable, const Offset(0, -400));
    await tester.pump();
    final exception = tester.takeException();
    expect(
      exception,
      isNull,
      reason:
          'Layout exception while scrolling: '
          '$exception',
    );
  }
  await tester.pumpAndSettle();
}

void main() {
  const sizes = <String, Size>{
    'narrow phone': Size(360, 690),
    'default': Size(800, 600),
    'desktop': Size(1280, 800),
  };

  for (final entry in sizes.entries) {
    testWidgets('showcase renders without overflow at ${entry.key} '
        '(${entry.value.width.toInt()}×${entry.value.height.toInt()})', (
      tester,
    ) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const IronWidgetsExampleApp());
      await tester.pump();
      expect(tester.takeException(), isNull);

      await _scrollThrough(tester);
    });
  }
}
