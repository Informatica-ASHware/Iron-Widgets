import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: IronWidgetsThemeScope(
    child: Scaffold(
      body: Center(child: SizedBox(width: 320, child: child)),
    ),
  ),
);

void main() {
  final defaults = IronWidgetsTheme.defaults();

  group('IronPanel (US-2.17)', () {
    testWidgets('renders title, trailing and child', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const IronPanel(
            title: 'SETTINGS',
            trailing: IronTag('PERP'),
            child: Text('body'),
          ),
        ),
      );
      expect(find.text('SETTINGS'), findsOneWidget);
      expect(find.text('PERP'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
      // Non-collapsible: no chevron.
      expect(find.byIcon(Icons.expand_more), findsNothing);
    });

    testWidgets('collapsible toggles the body and reports the state', (
      tester,
    ) async {
      final states = <bool>[];
      await tester.pumpWidget(
        _wrap(
          IronPanel(
            title: 'ASSETS',
            collapsible: true,
            onExpansionChanged: states.add,
            child: const Text('body'),
          ),
        ),
      );
      expect(find.text('body'), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsOneWidget);

      await tester.tap(find.text('ASSETS'));
      await tester.pumpAndSettle();
      expect(find.text('body'), findsNothing);
      expect(states, [false]);

      await tester.tap(find.text('ASSETS'));
      await tester.pumpAndSettle();
      expect(find.text('body'), findsOneWidget);
      expect(states, [false, true]);
    });

    testWidgets('initiallyExpanded: false starts collapsed', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const IronPanel(
            title: 'ASSETS',
            collapsible: true,
            initiallyExpanded: false,
            child: Text('body'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('body'), findsNothing);
    });

    testWidgets('tapping a non-collapsible header does nothing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const IronPanel(title: 'SETTINGS', child: Text('body'))),
      );
      await tester.tap(find.text('SETTINGS'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('body'), findsOneWidget);
    });
  });

  group('IronTabs (US-2.18)', () {
    const tabs = ['Order', 'SL', 'SLX', 'TP'];

    Widget build({
      required int index,
      ValueChanged<int>? onChanged,
      bool enabled = true,
    }) => _wrap(
      IronTabs(
        tabs: tabs,
        index: index,
        enabled: enabled,
        onChanged: onChanged ?? (_) {},
      ),
    );

    testWidgets('tap emits the tapped index; active tab is a no-op', (
      tester,
    ) async {
      final calls = <int>[];
      await tester.pumpWidget(build(index: 0, onChanged: calls.add));

      await tester.tap(find.text('SLX'));
      expect(calls, [2]);

      await tester.tap(find.text('Order'), warnIfMissed: false);
      expect(calls, [2]); // active tab does not re-fire
    });

    testWidgets('active tab paints gold and bold', (tester) async {
      await tester.pumpWidget(build(index: 1));
      await tester.pumpAndSettle();

      TextStyle styleOf(String label) => tester
          .widget<AnimatedDefaultTextStyle>(
            find
                .ancestor(
                  of: find.text(label),
                  matching: find.byType(AnimatedDefaultTextStyle),
                )
                .first,
          )
          .style;
      expect(styleOf('SL').color, defaults.gold);
      expect(styleOf('SL').fontWeight, FontWeight.bold);
      expect(styleOf('Order').color, Colors.white54);
    });

    testWidgets('arrow keys move the index and clamp at the ends', (
      tester,
    ) async {
      final calls = <int>[];
      await tester.pumpWidget(build(index: 2, onChanged: calls.add));

      Focus.of(tester.element(find.text('Order'))).requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      expect(calls, [3]);

      await tester.pumpWidget(build(index: 3, onChanged: calls.add));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      expect(calls, [3]); // clamped at the last tab

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      expect(calls, [3, 2]);
    });

    testWidgets('disabled strip ignores taps', (tester) async {
      final calls = <int>[];
      await tester.pumpWidget(
        build(index: 0, enabled: false, onChanged: calls.add),
      );
      await tester.tap(find.text('TP'), warnIfMissed: false);
      expect(calls, isEmpty);
    });
  });
}
