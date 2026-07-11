import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// A price display that flashes towards `bullColor` / `bearColor` when the
/// price changes and fades back to its resting colour (US-2.06).
///
/// Direction is derived from consecutive [price] values across rebuilds
/// (and from [previous] for the very first frame, when provided). The
/// flash is driven by an [AnimationController] created once in `initState`
/// — no timers are created during build — and the text is isolated inside
/// a [RepaintBoundary] so high-frequency updates repaint only the ticker.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// The resting colour comes from `baseStyleValue`; flashes use
/// `bullColor` / `bearColor`. Falls back to [IronWidgetsTheme.defaults]
/// when no theme is in the tree.
///
/// ```dart
/// IronPriceTicker(price: 43250.5, previous: 43180.0, precision: 1)
/// ```
class IronPriceTicker extends StatefulWidget {
  /// Creates an [IronPriceTicker].
  const IronPriceTicker({
    super.key,
    required this.price,
    this.previous,
    this.precision = 2,
    this.flashDuration = const Duration(milliseconds: 600),
    this.prefix = '',
    this.suffix = '',
    this.semanticLabel,
  }) : assert(precision >= 0, 'precision must be >= 0.');

  /// Current price.
  final double price;

  /// Optional baseline used only for the first frame: when it differs
  /// from [price], the ticker mounts already flashing in that direction.
  final double? previous;

  /// Number of decimal digits.
  final int precision;

  /// Time the flash takes to fade back to the resting colour.
  final Duration flashDuration;

  /// Text prepended to the number (e.g. `'$'`).
  final String prefix;

  /// Text appended to the number (e.g. `' USDT'`).
  final String suffix;

  /// Accessibility label override. Defaults to the rendered text.
  final String? semanticLabel;

  @override
  State<IronPriceTicker> createState() => _IronPriceTickerState();
}

class _IronPriceTickerState extends State<IronPriceTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flash = AnimationController(
    vsync: this,
    duration: widget.flashDuration,
    value: 1, // resting
  );

  /// +1 rising, -1 falling, 0 no change yet.
  int _direction = 0;

  @override
  void initState() {
    super.initState();
    final previous = widget.previous;
    if (previous != null && previous != widget.price) {
      _direction = widget.price > previous ? 1 : -1;
      _flash.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(IronPriceTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _flash.duration = widget.flashDuration;
    if (widget.price != oldWidget.price) {
      _direction = widget.price > oldWidget.price ? 1 : -1;
      _flash.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _flash.dispose();
    super.dispose();
  }

  String get _text =>
      '${widget.prefix}${widget.price.toStringAsFixed(widget.precision)}'
      '${widget.suffix}';

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final restColor = theme.baseStyleValue.color ?? Colors.white;
    final flashColor = _direction >= 0 ? theme.bullColor : theme.bearColor;

    return Semantics(
      label: widget.semanticLabel,
      value: _text,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _flash,
          builder: (context, _) {
            final t = Curves.easeOut.transform(_flash.value);
            final color = _direction == 0
                ? restColor
                : Color.lerp(flashColor, restColor, t)!;
            return Text(
              _text,
              maxLines: 1,
              style: theme.baseStyleValue.copyWith(
                color: color,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            );
          },
        ),
      ),
    );
  }
}
