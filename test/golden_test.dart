// Golden tests – run `flutter test --update-goldens` to generate baseline
// images before committing.  CI runs `flutter test` (read-only comparison).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _goldWrap(Widget child) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IronWidgetsThemeScope(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );

void main() {
  group('Golden – IronLabel', () {
    testWidgets('default', (tester) async {
      await tester.pumpWidget(_goldWrap(const IronLabel('Power Level')));
      await expectLater(
        find.byType(IronLabel),
        matchesGoldenFile('goldens/iron_label_default.png'),
      );
    });

    testWidgets('no colon', (tester) async {
      await tester.pumpWidget(
        _goldWrap(const IronLabel('Power Level', colon: false)),
      );
      await expectLater(
        find.byType(IronLabel),
        matchesGoldenFile('goldens/iron_label_no_colon.png'),
      );
    });
  });

  group('Golden – IronMiniText', () {
    testWidgets('numeric right-aligned', (tester) async {
      await tester.pumpWidget(
        _goldWrap(const SizedBox(width: 80, child: IronMiniText('1234.56'))),
      );
      await expectLater(
        find.byType(IronMiniText),
        matchesGoldenFile('goldens/iron_mini_text_numeric.png'),
      );
    });

    testWidgets('text left-aligned', (tester) async {
      await tester.pumpWidget(
        _goldWrap(const SizedBox(width: 80, child: IronMiniText('Revenue'))),
      );
      await expectLater(
        find.byType(IronMiniText),
        matchesGoldenFile('goldens/iron_mini_text_text.png'),
      );
    });
  });

  group('Golden – IronCheck', () {
    testWidgets('unchecked', (tester) async {
      await tester.pumpWidget(
        _goldWrap(
          IronCheck(label: 'Agree', value: false, onChanged: (_) {}),
        ),
      );
      await expectLater(
        find.byType(IronCheck),
        matchesGoldenFile('goldens/iron_check_unchecked.png'),
      );
    });

    testWidgets('checked', (tester) async {
      await tester.pumpWidget(
        _goldWrap(
          IronCheck(label: 'Agree', value: true, onChanged: (_) {}),
        ),
      );
      await expectLater(
        find.byType(IronCheck),
        matchesGoldenFile('goldens/iron_check_checked.png'),
      );
    });
  });

  group('Golden – IronMicroSwitch', () {
    testWidgets('inactive', (tester) async {
      await tester.pumpWidget(
        _goldWrap(
          IronMicroSwitch(text: 'HUD', value: false, onChanged: (_) {}),
        ),
      );
      await expectLater(
        find.byType(IronMicroSwitch),
        matchesGoldenFile('goldens/iron_micro_switch_off.png'),
      );
    });

    testWidgets('active', (tester) async {
      await tester.pumpWidget(
        _goldWrap(
          IronMicroSwitch(text: 'HUD', value: true, onChanged: (_) {}),
        ),
      );
      await expectLater(
        find.byType(IronMicroSwitch),
        matchesGoldenFile('goldens/iron_micro_switch_on.png'),
      );
    });
  });

  group('Golden – Show', () {
    testWidgets('read-only', (tester) async {
      await tester.pumpWidget(
        _goldWrap(const Show(label: 'Open', value: '142.30')),
      );
      await expectLater(
        find.byType(Show),
        matchesGoldenFile('goldens/show_readonly.png'),
      );
    });
  });

  group('Golden – ShowValuesColumn', () {
    testWidgets('default', (tester) async {
      await tester.pumpWidget(
        _goldWrap(
          const ShowValuesColumn(
            topLabel: 'O',
            topValue: '142.30',
            bottomLabel: 'C',
            bottomValue: '139.80',
          ),
        ),
      );
      await expectLater(
        find.byType(ShowValuesColumn),
        matchesGoldenFile('goldens/show_values_column.png'),
      );
    });
  });

  group('Golden – ShowPercColumn', () {
    testWidgets('default', (tester) async {
      await tester.pumpWidget(
        _goldWrap(
          const ShowPercColumn(
            topLabel: 'W',
            topValue: '62',
            bottomLabel: 'L',
            bottomValue: '38',
          ),
        ),
      );
      await expectLater(
        find.byType(ShowPercColumn),
        matchesGoldenFile('goldens/show_perc_column.png'),
      );
    });
  });
}
