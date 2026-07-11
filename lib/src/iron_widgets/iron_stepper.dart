import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../internal/theme_resolver.dart';
import 'iron_micro_editor.dart';

/// A numeric stepper: an [IronMicroEditor] flanked by `−` / `+` buttons
/// with hold-to-repeat (US-2.11).
///
/// Controlled widget: taps step [value] by [step], typing edits it
/// directly, and holding a button repeats after 400 ms at 100 ms
/// intervals (driven by a [Ticker] — no `Timer`s). Every result is
/// clamped to `[min, max]` and rounded to [precision] before
/// [onChanged].
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Buttons use `surfaceElevated` / `borderAccent` / `gold` and the micro
/// dimension tokens. Falls back to [IronWidgetsTheme.defaults] when no
/// theme is in the tree.
///
/// ```dart
/// IronStepper(
///   value: _leverage,
///   step: 1,
///   min: 1,
///   max: 125,
///   onChanged: (v) => setState(() => _leverage = v),
/// )
/// ```
class IronStepper extends StatefulWidget {
  /// Creates an [IronStepper].
  const IronStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.step = 1,
    this.min = double.negativeInfinity,
    this.max = double.infinity,
    this.precision = 0,
    this.editorWidth = 50,
    this.enabled = true,
    this.semanticLabel,
  }) : assert(step > 0, 'step must be > 0.'),
       assert(min < max, 'min must be < max.'),
       assert(precision >= 0, 'precision must be >= 0.');

  /// Current value.
  final double value;

  /// Called with the clamped, precision-rounded new value.
  final ValueChanged<double> onChanged;

  /// Increment applied per tap / repeat pulse.
  final double step;

  /// Lower bound.
  final double min;

  /// Upper bound.
  final double max;

  /// Decimal digits used for rounding and display.
  final int precision;

  /// Width of the central editor.
  final double editorWidth;

  /// Whether the control accepts interaction.
  final bool enabled;

  /// Accessibility label for the whole control.
  final String? semanticLabel;

  @override
  State<IronStepper> createState() => _IronStepperState();
}

class _IronStepperState extends State<IronStepper>
    with SingleTickerProviderStateMixin {
  static const Duration _holdDelay = Duration(milliseconds: 400);
  static const int _holdIntervalMs = 100;

  late final Ticker _repeat;
  late final TextEditingController _editorCtrl = TextEditingController(
    text: _fmt(widget.value),
  );

  double _holdDirection = 0;
  double _holdValue = 0;
  int _firedPulses = 0;

  @override
  void initState() {
    super.initState();
    _repeat = createTicker(_onRepeatTick);
  }

  @override
  void didUpdateWidget(IronStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _holdValue = widget.value;
      if (double.tryParse(_editorCtrl.text) != widget.value) {
        _editorCtrl.text = _fmt(widget.value);
      }
    }
  }

  @override
  void dispose() {
    _repeat.dispose();
    _editorCtrl.dispose();
    super.dispose();
  }

  String _fmt(double v) => v.toStringAsFixed(widget.precision);

  double _round(double v) => double.parse(v.toStringAsFixed(widget.precision));

  /// Applies one step over the local hold accumulator, so repeated pulses
  /// inside a single frame do not depend on the parent having rebuilt.
  void _pulse() {
    final next = _round(
      (_holdValue + _holdDirection * widget.step)
          .clamp(widget.min, widget.max)
          .toDouble(),
    );
    if (next != _holdValue) {
      _holdValue = next;
      widget.onChanged(next);
    }
  }

  void _startHold(double direction) {
    if (!widget.enabled) return;
    _holdDirection = direction;
    _holdValue = widget.value;
    _firedPulses = 0;
    _pulse(); // immediate single step on press
    _repeat.start();
  }

  void _endHold() {
    if (_repeat.isActive) _repeat.stop();
  }

  void _onRepeatTick(Duration elapsed) {
    if (elapsed < _holdDelay) return;
    final due = (elapsed - _holdDelay).inMilliseconds ~/ _holdIntervalMs + 1;
    while (_firedPulses < due) {
      _firedPulses++;
      _pulse();
    }
  }

  void _onTyped(String text) {
    final parsed = double.tryParse(text);
    if (parsed == null) return;
    final next = _round(parsed.clamp(widget.min, widget.max).toDouble());
    if (next != widget.value) widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      enabled: widget.enabled,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.55,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepButton(
              icon: Icons.remove,
              tooltip: 'Decrease',
              active: widget.enabled && widget.value > widget.min,
              onDown: () => _startHold(-1),
              onUp: _endHold,
            ),
            const SizedBox(width: 4),
            IronMicroEditor(
              initialValue: _fmt(widget.value),
              controller: _editorCtrl,
              width: widget.editorWidth,
              enabled: widget.enabled,
              semanticLabel: widget.semanticLabel ?? 'Stepper value',
              onChanged: _onTyped,
            ),
            const SizedBox(width: 4),
            _StepButton(
              icon: Icons.add,
              tooltip: 'Increase',
              active: widget.enabled && widget.value < widget.max,
              onDown: () => _startHold(1),
              onUp: _endHold,
            ),
          ],
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.active,
    required this.onDown,
    required this.onUp,
  });

  final IconData icon;
  final String tooltip;
  final bool active;
  final VoidCallback onDown;
  final VoidCallback onUp;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    return Semantics(
      button: true,
      enabled: active,
      label: tooltip,
      child: MouseRegion(
        cursor: active ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: Listener(
          onPointerDown: active ? (_) => onDown() : null,
          onPointerUp: (_) => onUp(),
          onPointerCancel: (_) => onUp(),
          child: Container(
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.surfaceElevated,
              borderRadius: BorderRadius.circular(theme.cornerRadius / 2),
              border: Border.all(
                color: theme.borderAccent.withValues(alpha: 0.45),
              ),
            ),
            child: Icon(
              icon,
              size: 14,
              color: active ? theme.gold : Colors.white24,
            ),
          ),
        ),
      ),
    );
  }
}
