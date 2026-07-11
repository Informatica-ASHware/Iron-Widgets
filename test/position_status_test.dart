import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: IronWidgetsThemeScope(
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  final defaults = IronWidgetsTheme.defaults();

  group('IronTag (US-2.13)', () {
    Color _fg(WidgetTester tester, String text) =>
        tester.widget<Text>(find.text(text)).style!.color!;

    testWidgets('variants colour text and background', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IronTag('SHORT', variant: IronTagVariant.bear),
              IronTag('LONG', variant: IronTagVariant.bull),
              IronTag('GOLD', variant: IronTagVariant.gold),
              IronTag('PERP'),
            ],
          ),
        ),
      );
      expect(_fg(tester, 'SHORT'), defaults.bearColor);
      expect(_fg(tester, 'LONG'), defaults.bullColor);
      expect(_fg(tester, 'GOLD'), defaults.gold);
      expect(_fg(tester, 'PERP'), Colors.white70);

      final neutralBox = tester.widget<Container>(
        find.ancestor(of: find.text('PERP'), matching: find.byType(Container)),
      );
      expect(
        (neutralBox.decoration! as BoxDecoration).color,
        defaults.surfaceElevated,
      );
    });
  });

  group('IronRangeBar (US-2.14)', () {
    testWidgets('renders the requested size and no labels by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const IronRangeBar(
            min: 41000,
            max: 45000,
            entry: 43000,
            current: 43850,
            width: 180,
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(
        tester
            .getSize(
              find.descendant(
                of: find.byType(IronRangeBar),
                matching: find.byType(CustomPaint),
              ),
            )
            .width,
        180,
      );
      expect(find.text('41000.00'), findsNothing);
    });

    testWidgets('showLabels renders min / entry / max with precision', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const IronRangeBar(
            min: 41000,
            max: 45000,
            entry: 43000,
            current: 43850,
            showLabels: true,
            precision: 1,
          ),
        ),
      );
      expect(find.text('41000.0'), findsOneWidget);
      expect(find.text('43000.0'), findsOneWidget);
      expect(find.text('45000.0'), findsOneWidget);

      // Label colours: min → bear, entry → gold, max → bull.
      Color fg(String text) =>
          tester.widget<Text>(find.text(text)).style!.color!;
      expect(fg('41000.0'), defaults.bearColor);
      expect(fg('43000.0'), defaults.gold);
      expect(fg('45000.0'), defaults.bullColor);
    });

    testWidgets('out-of-range current does not throw (clamped painting)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const IronRangeBar(min: 0, max: 100, current: 250)),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('IronGauge (US-2.15)', () {
    testWidgets('shows the rounded percentage and label', (tester) async {
      await tester.pumpWidget(
        _wrap(const IronGauge(value: 0.724, label: 'Margin')),
      );
      expect(find.text('72%'), findsOneWidget);
      expect(find.text('Margin'), findsOneWidget);
    });

    testWidgets('value colour turns dangerColor past the last threshold', (
      tester,
    ) async {
      Color fg(WidgetTester t) =>
          t.widget<Text>(find.textContaining('%')).style!.color!;

      await tester.pumpWidget(
        _wrap(const IronGauge(value: 0.72, thresholds: [0.5, 0.9])),
      );
      expect(fg(tester), defaults.gold);

      await tester.pumpWidget(
        _wrap(const IronGauge(value: 0.95, thresholds: [0.5, 0.9])),
      );
      expect(fg(tester), defaults.dangerColor);
    });

    testWidgets('clamps out-of-range values and can hide the value', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const IronGauge(value: 1.7)));
      expect(find.text('100%'), findsOneWidget);

      await tester.pumpWidget(
        _wrap(const IronGauge(value: 0.5, showValue: false)),
      );
      expect(find.textContaining('%'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('ShowGrid (US-2.16)', () {
    const items = [
      ShowItem('Volume', '1.2M'),
      ShowItem('High', '43910.0'),
      ShowItem('Low', '42115.5'),
      ShowItem('Funding', '0.0100%'),
      ShowItem('OI', '820K'),
    ];

    testWidgets('renders every item as a Show cell', (tester) async {
      await tester.pumpWidget(
        _wrap(const SizedBox(width: 360, child: ShowGrid(items: items))),
      );
      expect(find.byType(Show), findsNWidgets(items.length));
      expect(find.text('Volume'), findsOneWidget);
      expect(find.text('0.0100%'), findsOneWidget);
    });

    testWidgets('chunks items into the requested number of columns', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SizedBox(width: 420, child: ShowGrid(items: items, columns: 3)),
        ),
      );
      // 5 items in 3 columns → rows of 3 + 2(+padding): the incomplete
      // row keeps the columns aligned, so both rows are equally wide.
      final volume = tester.getTopLeft(find.text('Volume'));
      final funding = tester.getTopLeft(find.text('Funding'));
      expect(funding.dx, volume.dx); // first column aligned across rows
      expect(funding.dy, greaterThan(volume.dy));
    });

    test('ShowItem implements value equality', () {
      expect(const ShowItem('A', '1'), const ShowItem('A', '1'));
      expect(
        const ShowItem('A', '1').hashCode,
        const ShowItem('A', '1').hashCode,
      );
      expect(const ShowItem('A', '1'), isNot(const ShowItem('A', '2')));
    });
  });
}
