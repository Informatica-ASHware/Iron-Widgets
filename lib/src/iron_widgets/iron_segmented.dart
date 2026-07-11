import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../internal/theme_resolver.dart';
import '../theme/iron_widgets_theme.dart';

/// A compact segmented control for closed sets of options (US-2.09) —
/// LONG/SHORT pairs, PNL filters, timeframe pickers (L/F/M/S/T), etc.
///
/// Controlled widget: [value] marks the selected segment and every tap
/// (or Left/Right arrow while focused, clamped at the ends) calls
/// [onChanged]. The selected segment fills with `gold` by default; use
/// [selectedColor] to colour specific segments (e.g. LONG → `bullColor`,
/// SHORT → `bearColor`). Foreground contrast resolves via
/// `IronWidgetsTheme.textColorOn`.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Uses `surfaceElevated`, `gold`, `cornerRadius` and `baseStyleValue`,
/// falling back to [IronWidgetsTheme.defaults] when no theme is in the
/// tree.
///
/// ```dart
/// IronSegmented<String>(
///   segments: const ['LONG', 'SHORT'],
///   value: _side,
///   selectedColor: (s) =>
///       s == 'LONG' ? theme.bullColor : theme.bearColor,
///   onChanged: (s) => setState(() => _side = s),
/// )
/// ```
class IronSegmented<T> extends StatelessWidget {
  /// Creates an [IronSegmented].
  const IronSegmented({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
    this.itemAsString,
    this.selectedColor,
    this.height = 26,
    this.segmentWidth,
    this.enabled = true,
    this.semanticLabel,
  });

  /// Closed set of selectable segments, in display order.
  final List<T> segments;

  /// Currently selected segment.
  final T value;

  /// Called with the tapped (or keyboard-selected) segment.
  final ValueChanged<T> onChanged;

  /// Converts a segment to its display string. Falls back to [toString].
  final String Function(T)? itemAsString;

  /// Fill colour of a segment while selected. Defaults to `gold`.
  final Color Function(T segment)? selectedColor;

  /// Height of the control.
  final double height;

  /// Fixed width per segment. When `null` each segment sizes to its text.
  final double? segmentWidth;

  /// Whether the control accepts interaction.
  final bool enabled;

  /// Accessibility label for the whole control.
  final String? semanticLabel;

  String _asString(T segment) =>
      itemAsString?.call(segment) ?? segment.toString();

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || !enabled) return KeyEventResult.ignored;
    final index = segments.indexOf(value);
    if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        index < segments.length - 1) {
      onChanged(segments[index + 1]);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && index > 0) {
      onChanged(segments[index - 1]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    final control = Container(
      height: height,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: theme.surfaceElevated,
        borderRadius: BorderRadius.circular(theme.cornerRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final segment in segments) _buildSegment(theme, segment),
        ],
      ),
    );

    return Semantics(
      label: semanticLabel,
      enabled: enabled,
      child: Focus(
        canRequestFocus: enabled,
        skipTraversal: !enabled,
        onKeyEvent: _onKey,
        child: MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Opacity(opacity: enabled ? 1 : 0.55, child: control),
        ),
      ),
    );
  }

  Widget _buildSegment(IronWidgetsTheme theme, T segment) {
    final selected = segment == value;
    final background = selected
        ? (selectedColor?.call(segment) ?? theme.gold)
        : null;
    final foreground = selected
        ? theme.textColorOn(background!)
        : Colors.white70;

    return Semantics(
      button: true,
      selected: selected,
      label: _asString(segment),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled && !selected ? () => onChanged(segment) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          width: segmentWidth,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(theme.cornerRadius - 2),
          ),
          child: Text(
            _asString(segment),
            maxLines: 1,
            style: theme.baseStyleValue.copyWith(
              color: foreground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
