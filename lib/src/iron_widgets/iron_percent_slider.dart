import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';
import 'iron_micro_editor.dart';

/// A percentage slider with preset chips and an optional coupled
/// [IronMicroEditor] (US-2.10) — the Finandy-style "amount %" control.
///
/// Controlled widget: dragging the slider, tapping a preset chip or
/// typing in the editor calls [onChanged] with the new value, clamped to
/// `[min, max]` and rounded to [precision]. The editor text follows
/// external [value] changes without fighting the user's cursor while
/// typing.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Track and thumb use `gold`; chips use `surfaceElevated` /
/// `borderAccent` / `cornerRadius`. Falls back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// IronPercentSlider(
///   value: _percent,
///   onChanged: (v) => setState(() => _percent = v),
/// )
/// ```
class IronPercentSlider extends StatefulWidget {
  /// Creates an [IronPercentSlider].
  const IronPercentSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.presets = const [10, 25, 50, 75, 97],
    this.editable = true,
    this.precision = 0,
    this.enabled = true,
    this.semanticLabel,
  }) : assert(min < max, 'min must be < max.'),
       assert(precision >= 0, 'precision must be >= 0.');

  /// Current value (typically a percentage).
  final double value;

  /// Called with the clamped, precision-rounded new value.
  final ValueChanged<double> onChanged;

  /// Lower bound.
  final double min;

  /// Upper bound.
  final double max;

  /// Quick-pick chips shown under the slider. Empty hides the row.
  final List<double> presets;

  /// Shows the coupled numeric editor next to the slider.
  final bool editable;

  /// Decimal digits used for rounding and display.
  final int precision;

  /// Whether the control accepts interaction.
  final bool enabled;

  /// Accessibility label for the slider.
  final String? semanticLabel;

  @override
  State<IronPercentSlider> createState() => _IronPercentSliderState();
}

class _IronPercentSliderState extends State<IronPercentSlider> {
  late final TextEditingController _editorCtrl = TextEditingController(
    text: _fmt(widget.value),
  );

  String _fmt(double v) => v.toStringAsFixed(widget.precision);

  double _round(double v) => double.parse(v.toStringAsFixed(widget.precision));

  double get _clampedValue =>
      widget.value.clamp(widget.min, widget.max).toDouble();

  @override
  void didUpdateWidget(IronPercentSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Follow external value changes, but never rewrite the text the user
    // is currently producing (its parsed value already matches).
    if (widget.value != oldWidget.value &&
        double.tryParse(_editorCtrl.text) != widget.value) {
      _editorCtrl.text = _fmt(widget.value);
    }
  }

  @override
  void dispose() {
    _editorCtrl.dispose();
    super.dispose();
  }

  void _emit(double raw) {
    final next = _round(raw.clamp(widget.min, widget.max).toDouble());
    if (next != widget.value) widget.onChanged(next);
  }

  void _onTyped(String text) {
    final parsed = double.tryParse(text);
    if (parsed != null) _emit(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    final slider = SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        activeTrackColor: theme.gold,
        inactiveTrackColor: Colors.white24,
        thumbColor: theme.gold,
        overlayColor: theme.gold.withValues(alpha: 0.12),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
      ),
      child: Slider(
        value: _clampedValue,
        min: widget.min,
        max: widget.max,
        semanticFormatterCallback: (v) => '${_fmt(v)} %',
        onChanged: widget.enabled ? _emit : null,
      ),
    );

    return Semantics(
      label: widget.semanticLabel,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.55,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: slider),
                if (widget.editable) ...[
                  const SizedBox(width: 4),
                  IronMicroEditor(
                    initialValue: _fmt(widget.value),
                    controller: _editorCtrl,
                    width: 44,
                    enabled: widget.enabled,
                    semanticLabel: 'Percent value',
                    onChanged: _onTyped,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '%',
                    style: theme.baseStyleValue.copyWith(color: Colors.white54),
                  ),
                ],
              ],
            ),
            if (widget.presets.isNotEmpty)
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final preset in widget.presets)
                    _PresetChip(
                      label: preset % 1 == 0
                          ? '${preset.toStringAsFixed(0)}%'
                          : '$preset%',
                      selected: _fmt(_clampedValue) == _fmt(preset),
                      enabled: widget.enabled,
                      onTap: () => _emit(preset),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final background = selected ? theme.gold : theme.surfaceElevated;
    final foreground = selected
        ? theme.textColorOn(theme.gold)
        : Colors.white70;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(theme.cornerRadius),
              border: Border.all(
                color: selected
                    ? theme.gold
                    : theme.borderAccent.withValues(alpha: 0.45),
              ),
            ),
            child: Text(
              label,
              style: theme.baseStyleValue.copyWith(color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}
