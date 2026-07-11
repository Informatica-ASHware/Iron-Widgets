import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// A horizontal position range bar — stop-loss ([min]) to take-profit
/// ([max]) with the [current] price marker and an optional [entry] line
/// (US-2.14).
///
/// The segment between [entry] (or [min] when no entry is given) and
/// [current] fills with `bullColor` when the position is in profit
/// (current above the reference) or `bearColor` otherwise; the entry
/// renders as a thin `gold` line and the current price as a gold dot.
/// Values outside `[min, max]` are clamped for painting.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Colours resolve from `bullColor` / `bearColor` / `gold`, falling back
/// to [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// IronRangeBar(
///   min: 41000,   // SL
///   max: 45000,   // TP
///   entry: 43000,
///   current: 43850,
///   showLabels: true,
/// )
/// ```
class IronRangeBar extends StatelessWidget {
  /// Creates an [IronRangeBar].
  const IronRangeBar({
    super.key,
    required this.min,
    required this.max,
    required this.current,
    this.entry,
    this.showLabels = false,
    this.precision = 2,
    this.width = 160,
    this.height = 6,
    this.semanticLabel,
  }) : assert(min < max, 'min must be < max.'),
       assert(precision >= 0, 'precision must be >= 0.');

  /// Lower bound (typically the stop-loss).
  final double min;

  /// Upper bound (typically the take-profit).
  final double max;

  /// Current price, marked with a gold dot (clamped for painting).
  final double current;

  /// Optional entry price, marked with a thin gold line and used as the
  /// profit/loss reference for the fill colour.
  final double? entry;

  /// Renders min / entry / max labels under the bar.
  final bool showLabels;

  /// Decimal digits for the labels.
  final int precision;

  /// Width of the bar.
  final double width;

  /// Thickness of the track.
  final double height;

  /// Accessibility label override.
  final String? semanticLabel;

  String _fmt(double v) => v.toStringAsFixed(precision);

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final canvasHeight = height * 2.4 < 14 ? 14.0 : height * 2.4;
    final reference = entry ?? min;
    final inProfit = current >= reference;

    return Semantics(
      label: semanticLabel,
      value: _fmt(current),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            height: canvasHeight,
            child: CustomPaint(
              painter: _RangeBarPainter(
                min: min,
                max: max,
                current: current,
                entry: entry,
                trackHeight: height,
                fillColor: inProfit ? theme.bullColor : theme.bearColor,
                entryColor: theme.gold,
                markerColor: theme.gold,
              ),
            ),
          ),
          if (showLabels)
            SizedBox(
              width: width,
              child: Row(
                children: [
                  Text(
                    _fmt(min),
                    style: theme.baseStylePercent.copyWith(
                      color: theme.bearColor,
                    ),
                  ),
                  Expanded(
                    child: entry == null
                        ? const SizedBox.shrink()
                        : Text(
                            _fmt(entry!),
                            textAlign: TextAlign.center,
                            style: theme.baseStylePercent.copyWith(
                              color: theme.gold,
                            ),
                          ),
                  ),
                  Text(
                    _fmt(max),
                    style: theme.baseStylePercent.copyWith(
                      color: theme.bullColor,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RangeBarPainter extends CustomPainter {
  _RangeBarPainter({
    required this.min,
    required this.max,
    required this.current,
    required this.entry,
    required this.trackHeight,
    required this.fillColor,
    required this.entryColor,
    required this.markerColor,
  });

  final double min;
  final double max;
  final double current;
  final double? entry;
  final double trackHeight;
  final Color fillColor;
  final Color entryColor;
  final Color markerColor;

  double _dx(double value, double width) =>
      ((value - min) / (max - min)).clamp(0.0, 1.0) * width;

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height / 2;
    final radius = Radius.circular(trackHeight / 2);
    final track = RRect.fromLTRBR(
      0,
      centerY - trackHeight / 2,
      size.width,
      centerY + trackHeight / 2,
      radius,
    );
    canvas.drawRRect(
      track,
      Paint()..color = Colors.white.withValues(alpha: 0.12),
    );

    // Profit / loss segment between the reference and the current price.
    final referenceX = _dx(entry ?? min, size.width);
    final currentX = _dx(current, size.width);
    final left = referenceX < currentX ? referenceX : currentX;
    final right = referenceX < currentX ? currentX : referenceX;
    if (right - left > 0.5) {
      canvas.drawRRect(
        RRect.fromLTRBR(
          left,
          centerY - trackHeight / 2,
          right,
          centerY + trackHeight / 2,
          radius,
        ),
        Paint()..color = fillColor.withValues(alpha: 0.85),
      );
    }

    // Entry line.
    final entryValue = entry;
    if (entryValue != null) {
      final x = _dx(entryValue, size.width);
      canvas.drawLine(
        Offset(x, centerY - trackHeight * 1.1),
        Offset(x, centerY + trackHeight * 1.1),
        Paint()
          ..color = entryColor
          ..strokeWidth = 2,
      );
    }

    // Current price marker.
    canvas.drawCircle(
      Offset(currentX, centerY),
      trackHeight * 0.95,
      Paint()..color = markerColor,
    );
  }

  @override
  bool shouldRepaint(_RangeBarPainter oldDelegate) =>
      min != oldDelegate.min ||
      max != oldDelegate.max ||
      current != oldDelegate.current ||
      entry != oldDelegate.entry ||
      trackHeight != oldDelegate.trackHeight ||
      fillColor != oldDelegate.fillColor ||
      entryColor != oldDelegate.entryColor ||
      markerColor != oldDelegate.markerColor;
}
