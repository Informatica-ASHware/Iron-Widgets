import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../internal/sparkline_math.dart';
import '../internal/theme_resolver.dart';

/// A dependency-free mini trend line rendered with a [CustomPainter]
/// (US-2.08).
///
/// The stroke colour derives from the overall trend (last vs first
/// sample): rising uses `bullColor`, falling uses `bearColor` and a flat
/// series renders white-54. Set [positiveIsBull] to `false` to invert the
/// mapping (e.g. for spreads or fees, where rising is bad), or force a
/// specific [color]. Series longer than 200 points are uniformly
/// downsampled before painting.
///
/// This widget complements `AshCandleChart` (CryptBot ecosystem) for
/// inline micro-visualisations; it does not replace it.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Colours resolve from `bullColor` / `bearColor`, falling back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// IronSparkline([41.2, 41.8, 41.5, 42.9, 43.1])
/// IronSparkline(fees, positiveIsBull: false, fill: false)
/// ```
class IronSparkline extends StatelessWidget {
  /// Creates an [IronSparkline] for [values].
  const IronSparkline(
    this.values, {
    super.key,
    this.width = 120,
    this.height = 32,
    this.strokeWidth = 1.5,
    this.positiveIsBull = true,
    this.color,
    this.fill = true,
    this.semanticLabel,
  }) : assert(strokeWidth > 0, 'strokeWidth must be > 0.');

  /// Data series in chronological order. Fewer than two samples renders
  /// an empty box of the requested size.
  final List<double> values;

  /// Fixed width of the sparkline box.
  final double width;

  /// Fixed height of the sparkline box.
  final double height;

  /// Stroke width of the trend line.
  final double strokeWidth;

  /// When `true` (default) a rising trend is bullish. Set to `false` for
  /// series where rising is unfavourable.
  final bool positiveIsBull;

  /// Explicit stroke colour, overriding the trend-derived colour.
  final Color? color;

  /// Paints a subtle vertical gradient under the line.
  final bool fill;

  /// Accessibility label override.
  final String? semanticLabel;

  Color _trendColor(BuildContext context) {
    final theme = resolveIronTheme(context);
    final override = color;
    if (override != null) return override;
    if (values.length < 2 || values.last == values.first) {
      return Colors.white54;
    }
    final rising = values.last > values.first;
    return rising == positiveIsBull ? theme.bullColor : theme.bearColor;
  }

  @override
  Widget build(BuildContext context) {
    final stroke = _trendColor(context);
    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        width: width,
        height: height,
        child: CustomPaint(
          painter: _SparklinePainter(
            values: downsampleSparkline(values),
            color: stroke,
            strokeWidth: strokeWidth,
            fill: fill,
          ),
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.color,
    required this.strokeWidth,
    required this.fill,
  });

  final List<double> values;
  final Color color;
  final double strokeWidth;
  final bool fill;

  @override
  void paint(Canvas canvas, Size size) {
    final points = sparklinePoints(
      values,
      width: size.width,
      height: size.height,
      verticalPadding: strokeWidth,
    );
    if (points.isEmpty) return;

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }

    if (fill) {
      final area = Path.from(line)
        ..lineTo(points.last.dx, size.height)
        ..lineTo(points.first.dx, size.height)
        ..close();
      canvas.drawPath(
        area,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.20), color.withValues(alpha: 0)],
          ).createShader(Offset.zero & size),
      );
    }

    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      fill != oldDelegate.fill ||
      !listEquals(values, oldDelegate.values);
}
