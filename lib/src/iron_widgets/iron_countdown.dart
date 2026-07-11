import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../internal/theme_resolver.dart';

/// A countdown driven by a [Ticker] (no `Timer`s), pausable, with a
/// danger colour below a configurable remaining fraction (US-2.07).
///
/// Provide exactly one time source:
/// - [until]: a wall-clock target; the remaining time is captured once at
///   mount (or when [until] changes) and then counted down monotonically.
/// - [remaining]: an explicit starting duration.
///
/// While [paused] is `true` the ticker stops and the remaining time is
/// frozen; resuming continues from the frozen value. [onFinished] fires
/// exactly once when the countdown reaches zero. The widget rebuilds only
/// when the displayed second changes, not on every ticker frame.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Uses `baseStyleValue`, switching to `dangerColor` when the remaining
/// fraction drops below [warningFraction]. Falls back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// IronCountdown(
///   remaining: const Duration(minutes: 1),
///   onFinished: () => debugPrint('candle closed'),
/// )
/// ```
class IronCountdown extends StatefulWidget {
  /// Creates an [IronCountdown]. Provide exactly one of [until] /
  /// [remaining].
  const IronCountdown({
    super.key,
    this.until,
    this.remaining,
    this.onFinished,
    this.format,
    this.paused = false,
    this.warningFraction = 0.1,
    this.semanticLabel,
  }) : assert(
         (until != null) ^ (remaining != null),
         'Provide exactly one of until / remaining.',
       ),
       assert(
         warningFraction >= 0 && warningFraction <= 1,
         'warningFraction must be within [0, 1].',
       );

  /// Wall-clock target. Captured once per change; see class docs.
  final DateTime? until;

  /// Explicit starting duration.
  final Duration? remaining;

  /// Called exactly once when the countdown reaches zero.
  final VoidCallback? onFinished;

  /// Formats the remaining time. Defaults to `mm:ss`, or `hh:mm:ss` when
  /// at least one hour remains.
  final String Function(Duration remaining)? format;

  /// Freezes the countdown while `true`.
  final bool paused;

  /// Remaining fraction below which the text uses `dangerColor`.
  final double warningFraction;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  State<IronCountdown> createState() => _IronCountdownState();
}

class _IronCountdownState extends State<IronCountdown>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  Duration _total = Duration.zero;
  Duration _left = Duration.zero;

  /// Remaining time when the current ticker run started (pause basis).
  Duration _basis = Duration.zero;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _reset();
  }

  @override
  void didUpdateWidget(IronCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.until != oldWidget.until ||
        widget.remaining != oldWidget.remaining) {
      _ticker.stop();
      _reset();
    } else if (widget.paused != oldWidget.paused) {
      if (widget.paused) {
        _basis = _left;
        _ticker.stop();
      } else if (!_finished) {
        _ticker.start();
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _reset() {
    final resolved =
        widget.remaining ?? widget.until!.difference(DateTime.now());
    _total = resolved.isNegative ? Duration.zero : resolved;
    _left = _total;
    _basis = _total;
    _finished = false;
    if (_total == Duration.zero) {
      _finished = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onFinished?.call();
      });
    } else if (!widget.paused) {
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    final raw = _basis - elapsed;
    final left = raw.isNegative ? Duration.zero : raw;
    if (left.inSeconds != _left.inSeconds) {
      setState(() => _left = left);
    }
    if (left == Duration.zero) {
      _ticker.stop();
      if (!_finished) {
        _finished = true;
        widget.onFinished?.call();
      }
    }
  }

  static String _defaultFormat(Duration d) {
    String two(int v) => v.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return h > 0 ? '${two(h)}:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final fraction = _total.inMilliseconds == 0
        ? 0.0
        : _left.inMilliseconds / _total.inMilliseconds;
    final warning = fraction < widget.warningFraction;
    final text = (widget.format ?? _defaultFormat)(_left);

    return Semantics(
      label: widget.semanticLabel,
      value: text,
      child: Text(
        text,
        maxLines: 1,
        style: warning
            ? theme.baseStyleValue.copyWith(color: theme.dangerColor)
            : theme.baseStyleValue,
      ),
    );
  }
}
