import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';
import 'package:iron_widgets/src/internal/sparkline_math.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: IronWidgetsThemeScope(
    child: Scaffold(body: Center(child: child)),
  ),
);

Color? _textColor(WidgetTester tester, Finder finder) =>
    tester.widget<Text>(finder).style?.color;

void main() {
  final defaults = IronWidgetsTheme.defaults();

  group('IronDeltaBadge (US-2.05)', () {
    testWidgets('formats value with sign, precision and suffix', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const IronDeltaBadge(2.34)));
      expect(find.text('+2.34%'), findsOneWidget);

      await tester.pumpWidget(_wrap(const IronDeltaBadge(-1.2, precision: 1)));
      expect(find.text('-1.2%'), findsOneWidget);

      await tester.pumpWidget(
        _wrap(const IronDeltaBadge(5, showSign: false, suffix: ' USDT')),
      );
      expect(find.text('5.00 USDT'), findsOneWidget);
    });

    testWidgets('colours by direction and renders zero as neutral', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const IronDeltaBadge(2.34)));
      expect(_textColor(tester, find.text('+2.34%')), defaults.bullColor);

      await tester.pumpWidget(_wrap(const IronDeltaBadge(-2.34)));
      expect(_textColor(tester, find.text('-2.34%')), defaults.bearColor);

      await tester.pumpWidget(_wrap(const IronDeltaBadge(0)));
      expect(_textColor(tester, find.text('0.00%')), Colors.white70);
      final box = tester.widget<Container>(
        find.ancestor(of: find.text('0.00%'), matching: find.byType(Container)),
      );
      expect((box.decoration! as BoxDecoration).color, defaults.neutralSurface);
    });
  });

  group('IronPriceTicker (US-2.06)', () {
    testWidgets('renders formatted price at resting colour', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const IronPriceTicker(
            price: 43250.5,
            precision: 1,
            prefix: r'$',
            suffix: ' USDT',
          ),
        ),
      );
      final text = find.text(r'$43250.5 USDT');
      expect(text, findsOneWidget);
      expect(_textColor(tester, text), defaults.baseStyleValue.color);
    });

    testWidgets('flashes bull on rise and fades back', (tester) async {
      await tester.pumpWidget(
        _wrap(const IronPriceTicker(price: 100, precision: 0)),
      );
      await tester.pumpWidget(
        _wrap(const IronPriceTicker(price: 101, precision: 0)),
      );
      await tester.pump();
      expect(_textColor(tester, find.text('101')), defaults.bullColor);

      await tester.pump(const Duration(milliseconds: 700));
      expect(
        _textColor(tester, find.text('101')),
        defaults.baseStyleValue.color,
      );
    });

    testWidgets('flashes bear on drop', (tester) async {
      await tester.pumpWidget(
        _wrap(const IronPriceTicker(price: 100, precision: 0)),
      );
      await tester.pumpWidget(
        _wrap(const IronPriceTicker(price: 99, precision: 0)),
      );
      await tester.pump();
      expect(_textColor(tester, find.text('99')), defaults.bearColor);
      await tester.pumpAndSettle();
    });

    testWidgets('previous baseline flashes on the very first frame', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const IronPriceTicker(price: 100, previous: 105, precision: 0)),
      );
      expect(_textColor(tester, find.text('100')), defaults.bearColor);
      await tester.pumpAndSettle();
    });
  });

  group('IronCountdown (US-2.07)', () {
    testWidgets('counts down from remaining with mm:ss format', (tester) async {
      await tester.pumpWidget(
        _wrap(const IronCountdown(remaining: Duration(seconds: 65))),
      );
      expect(find.text('01:05'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.text('01:03'), findsOneWidget);

      await tester.pumpWidget(const SizedBox()); // dispose active ticker
    });

    testWidgets('uses hh:mm:ss above one hour and custom format wins', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const IronCountdown(
            remaining: Duration(hours: 1, minutes: 1, seconds: 5),
          ),
        ),
      );
      expect(find.text('01:01:05'), findsOneWidget);

      await tester.pumpWidget(
        _wrap(
          IronCountdown(
            remaining: const Duration(seconds: 42),
            format: (d) => '${d.inSeconds}s',
          ),
        ),
      );
      expect(find.text('42s'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('finishes at zero and fires onFinished exactly once', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        _wrap(
          IronCountdown(
            remaining: const Duration(seconds: 2),
            onFinished: () => calls++,
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('00:00'), findsOneWidget);
      expect(calls, 1);

      await tester.pump(const Duration(seconds: 2));
      expect(calls, 1);
    });

    testWidgets('paused freezes and resuming continues', (tester) async {
      Widget build({required bool paused}) => _wrap(
        IronCountdown(remaining: const Duration(seconds: 10), paused: paused),
      );

      await tester.pumpWidget(build(paused: false));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('00:08'), findsOneWidget);

      await tester.pumpWidget(build(paused: true));
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('00:08'), findsOneWidget);

      await tester.pumpWidget(build(paused: false));
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('00:06'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('switches to dangerColor below warningFraction', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const IronCountdown(
            remaining: Duration(seconds: 10),
            warningFraction: 0.5,
          ),
        ),
      );
      expect(
        _textColor(tester, find.text('00:10')),
        defaults.baseStyleValue.color,
      );

      await tester.pump(const Duration(seconds: 6));
      expect(_textColor(tester, find.text('00:04')), defaults.dangerColor);

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('until in the past renders zero and finishes once', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpWidget(
        _wrap(
          IronCountdown(
            until: DateTime.now().subtract(const Duration(minutes: 1)),
            onFinished: () => calls++,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('00:00'), findsOneWidget);
      expect(calls, 1);
    });
  });

  group('sparkline math (US-2.08)', () {
    test('downsampleSparkline keeps short series untouched', () {
      final values = List<double>.generate(50, (i) => i.toDouble());
      expect(downsampleSparkline(values), same(values));
    });

    test('downsampleSparkline caps length and preserves endpoints', () {
      final values = List<double>.generate(401, (i) => i.toDouble());
      final sampled = downsampleSparkline(values);
      expect(sampled.length, 200);
      expect(sampled.first, values.first);
      expect(sampled.last, values.last);
    });

    test('sparklinePoints maps a flat series to the vertical centre', () {
      final points = sparklinePoints(
        [5, 5, 5],
        width: 100,
        height: 32,
        verticalPadding: 2,
      );
      expect(points.length, 3);
      expect(points.every((p) => p.dy == 16), isTrue);
      expect(points.last.dx, 100);
    });

    test('sparklinePoints maps higher values upwards within padding', () {
      final points = sparklinePoints(
        [0, 10],
        width: 90,
        height: 32,
        verticalPadding: 1.5,
      );
      expect(points.first.dy, 30.5); // min → bottom inset
      expect(points.last.dy, 1.5); // max → top inset
      expect(points.first.dx, 0);
      expect(points.last.dx, 90);
    });
  });

  group('IronSparkline widget (US-2.08)', () {
    testWidgets('renders a CustomPaint of the requested size', (tester) async {
      await tester.pumpWidget(
        _wrap(const IronSparkline([1, 3, 2, 5], width: 90, height: 24)),
      );
      final paint = find.descendant(
        of: find.byType(IronSparkline),
        matching: find.byType(CustomPaint),
      );
      expect(paint, findsOneWidget);
      expect(tester.getSize(paint), const Size(90, 24));
    });

    testWidgets('handles empty and single-point series without painting', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const IronSparkline([])));
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(_wrap(const IronSparkline([42])));
      expect(tester.takeException(), isNull);
    });

    testWidgets('exposes the semantic label', (tester) async {
      await tester.pumpWidget(
        _wrap(const IronSparkline([1, 2, 3], semanticLabel: 'BTC 24h trend')),
      );
      expect(find.bySemanticsLabel('BTC 24h trend'), findsOneWidget);
    });
  });
}
