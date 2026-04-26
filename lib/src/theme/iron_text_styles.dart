import 'package:flutter/painting.dart';

import 'iron_colors.dart';

/// Default [TextStyle] instances that mirror `widgets_shows.dart` legacy globals.
///
/// These are the **package defaults**; every style is overridable via
/// [IronWidgetsTheme.copyWith].
abstract final class IronTextStyles {
  IronTextStyles._();

  /// Bold 10 sp label, black.  Migrated from legacy `baseStyleLabel`.
  static const TextStyle baseStyleLabel = TextStyle(
    color: IronColors.darkRed,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.fade,
  );

  /// Bold 10 sp numeric value, black.  Migrated from legacy `baseStyleValue`.
  static const TextStyle baseStyleValue = TextStyle(
    color: IronColors.darkGray,
    fontSize: 10,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.fade,
  );

  /// Regular 10 sp percentage text.  Migrated from legacy `baseStylePercent`.
  static const TextStyle baseStylePercent = TextStyle(
    color: IronColors.darkGray,
    fontSize: 10,
    overflow: TextOverflow.fade,
  );

  /// Regular 12 sp title text.  Migrated from legacy `baseStyleTitle`.
  static const TextStyle baseStyleTitle = TextStyle(
    color: IronColors.darkGray,
    fontSize: 12,
    overflow: TextOverflow.fade,
  );
}
