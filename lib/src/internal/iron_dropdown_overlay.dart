import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../iron_widgets/iron_select_mode.dart';
import '../theme/iron_widgets_theme.dart';
import 'theme_resolver.dart';

/// Row height of every option inside the anchored menu.
const double kIronDropdownRowHeight = 36;

/// Resolves whether [mode] should render as an anchored dropdown on the
/// given [platform].
///
/// Pure function extracted for unit testing. [isWeb] defaults to [kIsWeb]
/// at call sites; it is injected here so tests can exercise the web branch.
///
/// Decision record (SPEC_WIDGETS_ROADMAP §4.2 / §6.4): `adaptive` maps to
/// dropdown on desktop platforms **and on the web**, and to the legacy
/// bottom sheet on touch-first platforms.
bool ironDropdownForPlatform(
  IronSelectMode mode, {
  required TargetPlatform platform,
  required bool isWeb,
}) {
  switch (mode) {
    case IronSelectMode.dropdown:
      return true;
    case IronSelectMode.bottomSheet:
      return false;
    case IronSelectMode.adaptive:
      if (isWeb) return true;
      switch (platform) {
        case TargetPlatform.linux:
        case TargetPlatform.macOS:
        case TargetPlatform.windows:
          return true;
        case TargetPlatform.android:
        case TargetPlatform.iOS:
        case TargetPlatform.fuchsia:
          return false;
      }
  }
}

/// Finandy-style select field with an anchored overlay menu.
///
/// Internal building block shared by the `Iron*` selectors in dropdown
/// mode (US-2.02). Owns the trigger rendering, the [OverlayPortal]
/// life-cycle, positioning (with vertical flip when space below the
/// trigger is insufficient), keyboard navigation, optional inline search
/// and accessibility semantics.
///
/// Visual language: `surfaceElevated` panel, `borderAccent` hairline,
/// `cornerRadius` corners and a gold check on the selected row — the Iron
/// translation of the reference dropdown.
class IronDropdownField<T> extends StatefulWidget {
  /// Creates the internal dropdown field.
  const IronDropdownField({
    super.key,
    required this.options,
    required this.onSelected,
    this.value,
    this.itemAsString,
    this.placeholder = '',
    this.height = 30,
    this.width = 200,
    this.menuWidth,
    this.menuMaxHeight,
    this.searchable = false,
    this.searchHint = 'Search…',
    this.emptyResultText = 'No results',
    this.enabled = true,
    this.semanticLabel,
  });

  /// Full list of selectable options.
  final List<T> options;

  /// Called when the user picks an option. The menu closes afterwards.
  final ValueChanged<T> onSelected;

  /// Currently selected value, marked with a gold check in the menu.
  final T? value;

  /// Converts an option to its display string. Falls back to [toString].
  final String Function(T)? itemAsString;

  /// Dimmed text shown in the trigger while [value] is `null`.
  final String placeholder;

  /// Height of the trigger field.
  final double height;

  /// Width of the trigger field.
  final double width;

  /// Width of the anchored menu. Defaults to the trigger width.
  final double? menuWidth;

  /// Maximum menu height before the option list scrolls internally.
  /// Defaults to the theme token `overlayMaxHeight`.
  final double? menuMaxHeight;

  /// When `true`, a filter text field is shown at the top of the menu and
  /// receives focus on open. Prefix typeahead is disabled in this mode
  /// (the field replaces it).
  final bool searchable;

  /// Hint of the search field (only used when [searchable]).
  final String searchHint;

  /// Text shown when the search filter yields no options.
  final String emptyResultText;

  /// Whether the field accepts interaction. When `false` the trigger is
  /// dimmed, not focusable and does not open.
  final bool enabled;

  /// Accessibility label override for the trigger.
  final String? semanticLabel;

  @override
  State<IronDropdownField<T>> createState() => _IronDropdownFieldState<T>();
}

class _IronDropdownFieldState<T> extends State<IronDropdownField<T>> {
  final OverlayPortalController _menuCtrl = OverlayPortalController();
  final LayerLink _link = LayerLink();
  final GlobalKey _triggerKey = GlobalKey();
  final FocusNode _focusNode = FocusNode(debugLabel: 'IronDropdownField');
  final Object _tapGroup = Object();
  final ScrollController _listCtrl = ScrollController();

  FocusNode? _searchFocusNode;
  TextEditingController? _searchTextCtrl;
  ScrollPosition? _ancestorPosition;

  int _highlight = -1;
  bool _openUp = false;
  double _effectiveMaxHeight = 0;
  double _triggerWidth = 0;
  String _query = '';
  String _typed = '';
  int _lastTypedMs = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    if (widget.searchable) {
      _searchFocusNode = FocusNode(debugLabel: 'IronDropdownSearch')
        ..addListener(_handleFocusChange);
      _searchTextCtrl = TextEditingController();
    }
  }

  @override
  void dispose() {
    _detachScrollListener();
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    _searchFocusNode
      ?..removeListener(_handleFocusChange)
      ..dispose();
    _searchTextCtrl?.dispose();
    _listCtrl.dispose();
    super.dispose();
  }

  // ── Derived state ─────────────────────────────────────────────────────

  String _asString(T option) =>
      widget.itemAsString?.call(option) ?? option.toString();

  List<T> get _filtered {
    if (_query.isEmpty) return widget.options;
    final q = _query.toLowerCase();
    return widget.options
        .where((o) => _asString(o).toLowerCase().contains(q))
        .toList();
  }

  // ── Open / close ──────────────────────────────────────────────────────

  void _toggle() {
    if (_menuCtrl.isShowing) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    if (!widget.enabled || _menuCtrl.isShowing) return;
    if (!_focusNode.hasFocus) _focusNode.requestFocus();

    final theme = resolveIronTheme(context);
    final box = _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final screen = MediaQuery.sizeOf(context);
    final origin = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    final triggerH = box?.size.height ?? widget.height;
    _triggerWidth = box?.size.width ?? widget.width;

    final configuredMax = widget.menuMaxHeight ?? theme.overlayMaxHeight;
    final searchExtra = widget.searchable ? 52.0 : 0.0;
    final contentEstimate =
        8 + searchExtra + widget.options.length * kIronDropdownRowHeight;
    final spaceBelow = screen.height - (origin.dy + triggerH) - 8;
    final spaceAbove = origin.dy - 8;
    final desired = math.min(configuredMax, contentEstimate);

    _openUp = spaceBelow < desired && spaceAbove > spaceBelow;
    _effectiveMaxHeight = math.max(
      kIronDropdownRowHeight * 2,
      math.min(configuredMax, _openUp ? spaceAbove : spaceBelow),
    );

    final selectedIndex = widget.value == null
        ? -1
        : widget.options.indexOf(widget.value as T);
    _highlight = selectedIndex >= 0 ? selectedIndex : 0;
    _typed = '';

    _attachScrollListener();
    _menuCtrl.show();
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_menuCtrl.isShowing) return;
      if (widget.searchable) _searchFocusNode?.requestFocus();
      _ensureHighlightVisible();
    });
  }

  void _close({bool refocusTrigger = true}) {
    if (!_menuCtrl.isShowing) return;
    _detachScrollListener();
    _menuCtrl.hide();
    _query = '';
    _searchTextCtrl?.clear();
    if (refocusTrigger) _focusNode.requestFocus();
    if (mounted) setState(() {});
  }

  void _select(T option) {
    widget.onSelected(option);
    _close();
  }

  // ── Ancestor scroll → close ───────────────────────────────────────────

  void _attachScrollListener() {
    _ancestorPosition = Scrollable.maybeOf(context)?.position;
    _ancestorPosition?.isScrollingNotifier.addListener(_onAncestorScroll);
  }

  void _detachScrollListener() {
    _ancestorPosition?.isScrollingNotifier.removeListener(_onAncestorScroll);
    _ancestorPosition = null;
  }

  void _onAncestorScroll() {
    if (_ancestorPosition?.isScrollingNotifier.value ?? false) {
      _close(refocusTrigger: false);
    }
  }

  // ── Focus loss → close ────────────────────────────────────────────────

  void _handleFocusChange() {
    // Let focus settle (trigger → search field hand-off) before deciding.
    Future<void>.microtask(() {
      if (!mounted || !_menuCtrl.isShowing) return;
      final anyFocus =
          _focusNode.hasFocus || (_searchFocusNode?.hasFocus ?? false);
      if (!anyFocus) _close(refocusTrigger: false);
    });
    if (mounted) setState(() {}); // repaint focus border
  }

  // ── Keyboard ──────────────────────────────────────────────────────────

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final open = _menuCtrl.isShowing;

    if (!open) {
      if (key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.arrowUp) {
        _open();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    final filtered = _filtered;
    if (key == LogicalKeyboardKey.escape) {
      _close();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      _moveHighlight((_highlight + 1) % math.max(1, filtered.length));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      final len = math.max(1, filtered.length);
      _moveHighlight((_highlight - 1 + len) % len);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.home) {
      _moveHighlight(0);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.end) {
      _moveHighlight(filtered.length - 1);
      return KeyEventResult.handled;
    }
    final selectWithSpace =
        !widget.searchable && key == LogicalKeyboardKey.space;
    if (key == LogicalKeyboardKey.enter || selectWithSpace) {
      if (_highlight >= 0 && _highlight < filtered.length) {
        _select(filtered[_highlight]);
      }
      return KeyEventResult.handled;
    }
    if (!widget.searchable) {
      final ch = event.character;
      if (ch != null && ch.trim().isNotEmpty) {
        _typeahead(ch);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _typeahead(String ch) {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTypedMs > 700) _typed = '';
    _lastTypedMs = now;
    _typed += ch.toLowerCase();
    final options = _filtered;
    final index = options.indexWhere(
      (o) => _asString(o).toLowerCase().startsWith(_typed),
    );
    if (index >= 0) _moveHighlight(index);
  }

  void _moveHighlight(int index) {
    setState(() => _highlight = index);
    _ensureHighlightVisible();
  }

  void _ensureHighlightVisible() {
    if (!_listCtrl.hasClients || _highlight < 0) return;
    final position = _listCtrl.position;
    final target = 4 + _highlight * kIronDropdownRowHeight;
    if (target < position.pixels) {
      _listCtrl.jumpTo(math.max(position.minScrollExtent, target - 4));
    } else if (target + kIronDropdownRowHeight >
        position.pixels + position.viewportDimension) {
      _listCtrl.jumpTo(
        math.min(
          position.maxScrollExtent,
          target + kIronDropdownRowHeight + 4 - position.viewportDimension,
        ),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = resolveIronTheme(context);
    final open = _menuCtrl.isShowing;
    final selText = widget.value == null ? null : _asString(widget.value as T);

    final Color borderColor;
    if (!widget.enabled) {
      borderColor = theme.neutralSurface;
    } else if (open || _focusNode.hasFocus) {
      borderColor = theme.borderAccent;
    } else {
      borderColor = theme.borderAccent.withValues(alpha: 0.45);
    }
    final textColor = !widget.enabled
        ? Colors.white38
        : (selText == null ? Colors.white54 : Colors.white);

    final trigger = Container(
      key: _triggerKey,
      height: widget.height,
      width: widget.width,
      padding: const EdgeInsetsDirectional.only(start: 10, end: 6),
      decoration: BoxDecoration(
        color: theme.surfaceElevated,
        borderRadius: BorderRadius.circular(theme.cornerRadius),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              selText ?? widget.placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.baseStyleValue.copyWith(color: textColor),
            ),
          ),
          AnimatedRotation(
            turns: open ? 0.5 : 0,
            duration: const Duration(milliseconds: 150),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: widget.enabled ? theme.gold : Colors.white38,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: true,
      enabled: widget.enabled,
      expanded: open,
      label: widget.semanticLabel ?? widget.placeholder,
      value: selText,
      child: TapRegion(
        groupId: _tapGroup,
        child: CompositedTransformTarget(
          link: _link,
          child: OverlayPortal(
            controller: _menuCtrl,
            overlayChildBuilder: _buildMenu,
            child: Focus(
              focusNode: _focusNode,
              canRequestFocus: widget.enabled,
              skipTraversal: !widget.enabled,
              onKeyEvent: _onKey,
              child: MouseRegion(
                cursor: widget.enabled
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.enabled ? _toggle : null,
                  child: trigger,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    final theme = resolveIronTheme(context);
    final filtered = _filtered;
    final menuWidth = widget.menuWidth ?? _triggerWidth;
    final highlight = math.min(_highlight, filtered.length - 1);

    final menu = Material(
      color: Colors.transparent,
      child: Container(
        width: menuWidth,
        constraints: BoxConstraints(maxHeight: _effectiveMaxHeight),
        decoration: BoxDecoration(
          color: theme.surfaceElevated,
          borderRadius: BorderRadius.circular(theme.cornerRadius),
          border: Border.all(color: theme.borderAccent.withValues(alpha: 0.45)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.searchable) _buildSearchField(theme),
            Flexible(
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        widget.emptyResultText,
                        style: theme.baseStyleValue.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _listCtrl,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      shrinkWrap: true,
                      itemExtent: kIronDropdownRowHeight,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          _buildRow(theme, filtered[index], index, highlight),
                    ),
            ),
          ],
        ),
      ),
    );

    return Positioned(
      width: menuWidth,
      child: CompositedTransformFollower(
        link: _link,
        showWhenUnlinked: false,
        targetAnchor: _openUp ? Alignment.topLeft : Alignment.bottomLeft,
        followerAnchor: _openUp ? Alignment.bottomLeft : Alignment.topLeft,
        offset: Offset(0, _openUp ? -4 : 4),
        child: TapRegion(
          groupId: _tapGroup,
          onTapOutside: (_) => _close(refocusTrigger: false),
          child: menu,
        ),
      ),
    );
  }

  Widget _buildSearchField(IronWidgetsTheme theme) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
    child: Focus(
      onKeyEvent: _onKey,
      child: TextField(
        controller: _searchTextCtrl,
        focusNode: _searchFocusNode,
        style: theme.baseStyleValue.copyWith(color: Colors.white),
        cursorColor: theme.gold,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.searchHint,
          hintStyle: theme.baseStyleValue.copyWith(color: Colors.white38),
          prefixIcon: Icon(Icons.search, size: 16, color: theme.gold),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 28,
            minHeight: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.cornerRadius / 2),
            borderSide: BorderSide(
              color: theme.borderAccent.withValues(alpha: 0.45),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(theme.cornerRadius / 2),
            borderSide: BorderSide(color: theme.borderAccent),
          ),
        ),
        onChanged: (q) => setState(() {
          _query = q;
          _highlight = _filtered.isEmpty ? -1 : 0;
        }),
      ),
    ),
  );

  Widget _buildRow(IronWidgetsTheme theme, T option, int index, int highlight) {
    final selected = widget.value != null && option == widget.value;
    final highlighted = index == highlight;
    final text = _asString(option);

    return Semantics(
      button: true,
      selected: selected,
      label: text,
      child: MouseRegion(
        onEnter: (_) => setState(() => _highlight = index),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _select(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            color: highlighted
                ? theme.gold.withValues(alpha: 0.12)
                : Colors.transparent,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.baseStyleValue.copyWith(
                      color: selected ? theme.gold : Colors.white,
                    ),
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.check, size: 16, color: theme.gold),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
