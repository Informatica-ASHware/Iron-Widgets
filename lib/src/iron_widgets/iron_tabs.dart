import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../internal/theme_resolver.dart';
import '../theme/iron_widgets_theme.dart';

/// Compact index-based tabs with a gold underline indicator (US-2.18) —
/// Order / SL / SLX / TP and friends.
///
/// Controlled widget: [index] marks the active tab and every tap (or
/// Left/Right arrow while focused, clamped at the ends) calls
/// [onChanged] with the new index. Visually complementary to
/// [IronSegmented]: tabs *navigate* (underline on a hairline baseline)
/// while segments *select* (filled pill).
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Uses `gold`, `borderAccent` and `baseStyleValue`, falling back to
/// [IronWidgetsTheme.defaults] when no theme is in the tree.
///
/// ```dart
/// IronTabs(
///   tabs: const ['Order', 'SL', 'SLX', 'TP'],
///   index: _tab,
///   onChanged: (i) => setState(() => _tab = i),
/// )
/// ```
class IronTabs extends StatelessWidget {
  /// Creates an [IronTabs].
  const IronTabs({
    super.key,
    required this.tabs,
    required this.index,
    required this.onChanged,
    this.height = 30,
    this.tabWidth,
    this.enabled = true,
    this.semanticLabel,
  }) : assert(tabs.length > 0, 'tabs must not be empty.');

  /// Tab labels in display order.
  final List<String> tabs;

  /// Active tab index.
  final int index;

  /// Called with the tapped (or keyboard-selected) index.
  final ValueChanged<int> onChanged;

  /// Height of the tab strip.
  final double height;

  /// Fixed width per tab. When `null` each tab sizes to its text.
  final double? tabWidth;

  /// Whether the strip accepts interaction.
  final bool enabled;

  /// Accessibility label for the whole strip.
  final String? semanticLabel;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || !enabled) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        index < tabs.length - 1) {
      onChanged(index + 1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && index > 0) {
      onChanged(index - 1);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);

    return Semantics(
      label: semanticLabel,
      enabled: enabled,
      child: Focus(
        canRequestFocus: enabled,
        skipTraversal: !enabled,
        onKeyEvent: _onKey,
        child: MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: Opacity(
            opacity: enabled ? 1 : 0.55,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.borderAccent.withValues(alpha: 0.25),
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < tabs.length; i++) _buildTab(theme, i),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(IronWidgetsTheme theme, int i) {
    final selected = i == index;

    return Semantics(
      button: true,
      selected: selected,
      label: tabs[i],
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled && !selected ? () => onChanged(i) : null,
        child: Container(
          width: tabWidth,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: selected ? theme.gold : Colors.transparent,
              ),
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 120),
            style: theme.baseStyleValue.copyWith(
              color: selected ? theme.gold : Colors.white54,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
            child: Text(tabs[i], maxLines: 1),
          ),
        ),
      ),
    );
  }
}
