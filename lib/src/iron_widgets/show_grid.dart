import 'package:flutter/material.dart';

import 'iron_shows.dart';

/// Immutable label/value pair for [ShowGrid].
@immutable
class ShowItem {
  /// Creates a [ShowItem].
  const ShowItem(this.label, this.value);

  /// Cell label (e.g. `Volume`).
  final String label;

  /// Cell value (e.g. `1.2M`).
  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShowItem && other.label == label && other.value == value;

  @override
  int get hashCode => Object.hash(label, value);
}

/// A stats header that lays [Show] rows out in a fixed-column grid
/// (US-2.16) — Volume / High / Low / Funding and friends.
///
/// Items flow left-to-right, top-to-bottom into [columns] columns of
/// equal width; an incomplete last row is padded so columns stay
/// aligned.
///
/// Each cell embeds a [Show]; narrow columns degrade gracefully with
/// ellipsis instead of overflowing.
///
/// ## Behaviour with / without [IronWidgetsTheme]
/// Purely compositional: each cell is a [Show], which resolves its own
/// tokens (falling back to [IronWidgetsTheme.defaults]).
///
/// ```dart
/// ShowGrid(
///   columns: 2,
///   items: const [
///     ShowItem('Volume', '1.2M'),
///     ShowItem('High', '43910.0'),
///     ShowItem('Low', '42115.5'),
///     ShowItem('Funding', '0.0100%'),
///   ],
/// )
/// ```
class ShowGrid extends StatelessWidget {
  /// Creates a [ShowGrid].
  const ShowGrid({
    super.key,
    required this.items,
    this.columns = 2,
    this.columnSpacing = 12,
    this.rowSpacing = 2,
    this.semanticLabel,
  }) : assert(columns > 0, 'columns must be > 0.');

  /// Cells in reading order.
  final List<ShowItem> items;

  /// Number of columns.
  final int columns;

  /// Horizontal gap between columns.
  final double columnSpacing;

  /// Vertical gap between rows.
  final double rowSpacing;

  /// Accessibility label for the whole grid.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var start = 0; start < items.length; start += columns) {
      final end = start + columns > items.length
          ? items.length
          : start + columns;
      final cells = <Widget>[];
      for (var i = start; i < end; i++) {
        if (i > start) cells.add(SizedBox(width: columnSpacing));
        cells.add(
          Expanded(
            child: Show(label: items[i].label, value: items[i].value),
          ),
        );
      }
      // Pad an incomplete last row so columns stay aligned.
      for (var i = end; i < start + columns; i++) {
        cells
          ..add(SizedBox(width: columnSpacing))
          ..add(const Expanded(child: SizedBox.shrink()));
      }
      if (rows.isNotEmpty) rows.add(SizedBox(height: rowSpacing));
      rows.add(Row(children: cells));
    }

    return Semantics(
      label: semanticLabel,
      child: Column(mainAxisSize: MainAxisSize.min, children: rows),
    );
  }
}
