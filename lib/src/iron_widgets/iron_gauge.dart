import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// An arc-reactor-style gauge for a normalized [value] in `0..1`
/// (US-2.15) — margin usage, risk level, capacity, etc.
///
/// A 270° arc fills clockwise with `gold`, switching to `dangerColor`
/// once [value] crosses the **last** entry of [thresholds]; every
/// threshold is drawn as a tick on the track. The active arc casts a
/// soft glow (the arc-reactor touch) and the centre shows the value as a
/// percentage with an optional [label] beneath. Values outside `0..1`
/// are clamped.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Colours resolve from `gold` / `dangerColor`, falling back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// IronGauge(
///   value: 0.72,
///   label: 'Margin',
///   thresholds: const [0.5, 0.9],
/// )
/// ```
class IronGauge extends StatelessWidget {
  /// Creates an [IronGauge].
  const IronGauge({
    super.key,
    required this.value,
    this.label,
    this.thresholds,
    this.size = 72,
    this.strokeWidth = 6,
    this.showValue = true,
    this.semanticLabel,
  }) : assert(size > 0, 'size must be > 0.'),
       assert(strokeWidth > 0, 'strokeWidth must be > 0.');

  /// Normalized value in `0..1` (clamped).
  final double value;

  /// Small caption under the value.
  final String? label;

  /// Ascending marks in `0..1`, drawn as ticks; the arc turns
  /// `dangerColor` once [value] reaches the last one.
  final List<double>? thresholds;

  /// Diameter of the gauge.
  final double size;

  /// Thickness of the arc.
  final double strokeWidth;

  /// Shows the percentage in the centre.
  final bool showValue;

  /// Accessibility label override. Defaults to [label].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final clamped = value.clamp(0.0, 1.0);
    final marks = thresholds;
    final danger = marks != null && marks.isNotEmpty && clamped >= marks.last;
    final activeColor = danger ? theme.dangerColor : theme.gold;
    final caption = label;

    return Semantics(
      label: semanticLabel ?? caption,
      value: '${(clamped * 100).round()} %',
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _GaugePainter(
            value: clamped,
            activeColor: activeColor,
            strokeWidth: strokeWidth,
            thresholds: marks ?? const [],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showValue)
                  Text(
                    '${(clamped * 100).round()}%',
                    style: theme.baseStyleValue.copyWith(
                      color: activeColor,
                      fontSize: size / 5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (caption != null)
                  Text(
                    caption,
                    style: theme.baseStylePercent.copyWith(
                      color: Colors.white54,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.value,
    required this.activeColor,
    required this.strokeWidth,
    required this.thresholds,
  });

  /// Gauge geometry: a 270° arc opening downwards (135° → 405°).
  static const double _startAngle = 3 * math.pi / 4;
  static const double _totalSweep = 3 * math.pi / 2;

  final double value;
  final Color activeColor;
  final double strokeWidth;
  final List<double> thresholds;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track.
    canvas.drawArc(
      rect,
      _startAngle,
      _totalSweep,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Inner ring — the arc-reactor concentric detail.
    canvas.drawCircle(
      center,
      radius - strokeWidth * 1.6,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    final sweep = _totalSweep * value;
    if (sweep > 0) {
      // Soft glow beneath the active arc.
      canvas.drawArc(
        rect,
        _startAngle,
        sweep,
        false,
        Paint()
          ..color = activeColor.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );
      // Active arc.
      canvas.drawArc(
        rect,
        _startAngle,
        sweep,
        false,
        Paint()
          ..color = activeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }

    // Threshold ticks.
    final tickPaint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 2;
    for (final t in thresholds) {
      final angle = _startAngle + _totalSweep * t.clamp(0.0, 1.0);
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * (radius - strokeWidth / 2 - 2),
        center + direction * (radius + strokeWidth / 2 + 2),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      value != oldDelegate.value ||
      activeColor != oldDelegate.activeColor ||
      strokeWidth != oldDelegate.strokeWidth ||
      thresholds != oldDelegate.thresholds;
}
