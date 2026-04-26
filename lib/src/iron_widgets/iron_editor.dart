import 'dart:async';

import 'package:flutter/material.dart';

import 'iron_label.dart';

/// A labelled text field with optional debouncing.
///
/// Migrated from the legacy `Editor` StatefulWidget.  The legacy widget
/// conflated `text` (initial value) with live state; this version makes the
/// distinction explicit via [initialValue] / [controller].
///
/// ## Controlled vs uncontrolled
/// - **Uncontrolled** (default): pass [initialValue].  External changes after
///   construction are ignored (matches legacy behaviour).
/// - **Controlled**: pass a [TextEditingController].  You own its lifecycle.
///
/// ## Debounce
/// When [debounce] is non-null, [onChanged] fires only after the user stops
/// typing for the specified duration.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Text colour resolves from `Theme.of(context).colorScheme.primary`.
/// Label colour resolves from `IronWidgetsTheme.darkRed`.
///
/// ```dart
/// IronEditor(
///   label: 'Username',
///   initialValue: 'tony',
///   onChanged: (v) => setState(() => _username = v),
///   debounce: const Duration(milliseconds: 400),
/// )
/// ```
class IronEditor extends StatefulWidget {
  /// Creates an [IronEditor].
  const IronEditor({
    super.key,
    required this.label,
    required this.onChanged,
    this.initialValue = '',
    this.controller,
    this.width = 240,
    this.lines = 1,
    this.password = false,
    this.labelOnTop = false,
    this.debounce,
    this.enabled = true,
    this.semanticLabel,
  });

  /// Label text.
  final String label;

  /// Called when the text changes, honouring [debounce] if set.
  final ValueChanged<String> onChanged;

  /// Initial text (uncontrolled mode).
  final String initialValue;

  /// External controller (controlled mode).  When provided [initialValue]
  /// is ignored.
  final TextEditingController? controller;

  /// Total widget width.
  final double width;

  /// Number of visible lines.
  final int lines;

  /// When `true`, the text is obscured (password mode).
  final bool password;

  /// When `true`, the label is placed above the field instead of beside it.
  final bool labelOnTop;

  /// When non-null, [onChanged] fires only after this duration of inactivity.
  final Duration? debounce;

  /// When `false` the field is read-only.
  final bool enabled;

  /// Accessibility label override.
  final String? semanticLabel;

  @override
  State<IronEditor> createState() => _IronEditorState();
}

class _IronEditorState extends State<IronEditor> {
  late final TextEditingController _controller;
  bool _ownsController = false;
  Timer? _debounceTimer;

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

  void _onChanged() {
    if (widget.debounce == null) {
      widget.onChanged(_controller.text);
      return;
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounce!, () {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldHeight =
        widget.lines == 1 ? 30.0 : (widget.lines * 18.0);
    final totalHeight =
        (widget.lines == 1 ? 40.0 : (widget.lines * 18.0)) +
            (widget.labelOnTop ? 20.0 : 0.0);

    final field = Semantics(
      label: widget.semanticLabel ?? widget.label,
      textField: true,
      enabled: widget.enabled,
      child: SizedBox(
        width: widget.width,
        height: widget.lines == 1 ? 30 : null,
        child: TextField(
          controller: _controller,
          enabled: widget.enabled,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(),
          ),
          maxLines: widget.lines,
          obscureText: widget.password,
          keyboardType: widget.lines > 1
              ? TextInputType.multiline
              : TextInputType.text,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );

    final children = <Widget>[
      if (widget.label.isNotEmpty) IronLabel(widget.label),
      SizedBox(
        width: widget.width,
        height: fieldHeight,
        child: field,
      ),
    ];

    return SizedBox(
      width: widget.width,
      height: totalHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: widget.labelOnTop
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
      ),
    );
  }
}
