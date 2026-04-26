import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// A compact inline numeric text editor, typically embedded in data-grid rows.
///
/// Renamed from the legacy `WMicroEditor` (prefix `W` → `Iron`).
///
/// The [initialValue] is used only for initialisation; subsequent external
/// changes to [initialValue] are **not** reflected (uncontrolled pattern
/// matching legacy behaviour).  Pass a [controller] to take full control.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Font size defaults to `IronWidgetsTheme.microFontSize`.
/// Width/height default to the values provided as constructor parameters;
/// they are **not** overridden by the theme so call sites keep pixel-precise
/// control.
///
/// ```dart
/// IronMicroEditor(
///   label: 'qty',
///   initialValue: '42',
///   onChanged: (v) => setState(() => _qty = v),
/// )
/// ```
class IronMicroEditor extends StatefulWidget {
  /// Creates an [IronMicroEditor].
  const IronMicroEditor({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.label = '',
    this.width = 50,
    this.height = 20,
    this.fontSize,
    this.controller,
    this.enabled = true,
    this.semanticLabel,
  });

  /// Initial text value.
  final String initialValue;

  /// Called whenever the text changes.
  final ValueChanged<String> onChanged;

  /// Optional label shown to the left of the field.
  final String label;

  /// Width of the text field.
  final double width;

  /// Height of the text field.
  final double height;

  /// Overrides the theme font size.
  final double? fontSize;

  /// Optional external controller; when provided [initialValue] is ignored.
  final TextEditingController? controller;

  /// When `false` the field is non-interactive.
  final bool enabled;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  State<IronMicroEditor> createState() => _IronMicroEditorState();
}

class _IronMicroEditorState extends State<IronMicroEditor> {
  late final TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _ownsController = true;
    }
    _controller.addListener(_onChanged);
  }

  void _onChanged() => widget.onChanged(_controller.text);

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final effectiveFontSize = widget.fontSize ?? theme.microFontSize;
    final scaler = MediaQuery.textScalerOf(context);
    final scaledFontSize = scaler.scale(effectiveFontSize);

    return Semantics(
      label: widget.semanticLabel ??
          (widget.label.isNotEmpty ? widget.label : 'numeric editor'),
      textField: true,
      enabled: widget.enabled,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.label.isNotEmpty)
            Text(
              '${widget.label}:',
              style: TextStyle(fontSize: scaledFontSize),
            ),
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: TextField(
              enabled: widget.enabled,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: scaledFontSize),
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlignVertical: TextAlignVertical.top,
              textAlign: TextAlign.right,
              strutStyle: StrutStyle(fontSize: scaledFontSize),
            ),
          ),
        ],
      ),
    );
  }
}
