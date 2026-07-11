import 'package:flutter/material.dart';

import '../internal/theme_resolver.dart';

/// A Finandy-style panel: an elevated card with a gold header, optional
/// [trailing] widget and an optionally [collapsible] body (US-2.17) —
/// the "Settings" / "Assets" building block.
///
/// When [collapsible] is `true`, tapping the header toggles the body
/// with an animated size transition and a rotating chevron;
/// [onExpansionChanged] reports the new state. A non-collapsible panel
/// renders a plain header and is always expanded.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Uses `surfaceElevated`, `gold`, `borderAccent` and `cornerRadius`,
/// falling back to [IronWidgetsTheme.defaults] when no theme is in the
/// tree.
///
/// ```dart
/// IronPanel(
///   title: 'SETTINGS',
///   trailing: IronTag('PERP'),
///   collapsible: true,
///   child: Column(children: [...]),
/// )
/// ```
class IronPanel extends StatefulWidget {
  /// Creates an [IronPanel].
  const IronPanel({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.collapsible = false,
    this.initiallyExpanded = true,
    this.onExpansionChanged,
    this.padding = const EdgeInsets.all(12),
    this.semanticLabel,
  });

  /// Header text (gold, bold).
  final String title;

  /// Panel body.
  final Widget child;

  /// Optional widget at the end of the header (tag, switch, icon…).
  final Widget? trailing;

  /// Whether tapping the header collapses / expands the body.
  final bool collapsible;

  /// Initial body state when [collapsible]. Ignored otherwise.
  final bool initiallyExpanded;

  /// Called with the new state after each toggle.
  final ValueChanged<bool>? onExpansionChanged;

  /// Padding around [child].
  final EdgeInsetsGeometry padding;

  /// Accessibility label override. Defaults to [title].
  final String? semanticLabel;

  @override
  State<IronPanel> createState() => _IronPanelState();
}

class _IronPanelState extends State<IronPanel> {
  late bool _expanded = !widget.collapsible || widget.initiallyExpanded;

  @override
  void didUpdateWidget(IronPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.collapsible && !_expanded) _expanded = true;
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    widget.onExpansionChanged?.call(_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final trailing = widget.trailing;

    final header = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.baseStyleValue.copyWith(
                color: theme.gold,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
          ),
          if (trailing != null) trailing,
          if (widget.collapsible) ...[
            const SizedBox(width: 6),
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 150),
              child: Icon(Icons.expand_more, size: 16, color: theme.gold),
            ),
          ],
        ],
      ),
    );

    return Semantics(
      label: widget.semanticLabel ?? widget.title,
      child: Container(
        decoration: BoxDecoration(
          color: theme.surfaceElevated,
          borderRadius: BorderRadius.circular(theme.cornerRadius),
          border: Border.all(color: theme.borderAccent.withValues(alpha: 0.25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.collapsible)
              Semantics(
                button: true,
                expanded: _expanded,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toggle,
                    child: header,
                  ),
                ),
              )
            else
              header,
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: !_expanded
                  ? const SizedBox(width: double.infinity)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 1,
                          color: theme.borderAccent.withValues(alpha: 0.2),
                        ),
                        Padding(padding: widget.padding, child: widget.child),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
