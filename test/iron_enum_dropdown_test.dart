import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iron_widgets/iron_widgets.dart';
import 'package:iron_widgets/src/internal/iron_dropdown_overlay.dart';

enum _Mode { idle, active, turbo }

Widget _wrap(Widget child) => MaterialApp(
  home: IronWidgetsThemeScope(
    child: Scaffold(body: Center(child: child)),
  ),
);

IronEnum<_Mode> _enum({
  IronSelectMode mode = IronSelectMode.dropdown,
  _Mode value = _Mode.active,
  String Function(_Mode)? itemAsString,
  bool enabled = true,
  ValueChanged<_Mode>? onChanged,
}) => IronEnum<_Mode>(
  title: 'Mode',
  label: 'Mode',
  mode: mode,
  value: value,
  options: _Mode.values,
  itemAsString: itemAsString ?? (m) => m.name.toUpperCase(),
  enabled: enabled,
  onChanged: onChanged ?? (_) {},
);

void main() {
  group('IronEnum dropdown mode', () {
    testWidgets('opens on tap, marks current value and selects on tap', (
      tester,
    ) async {
      _Mode? selected;
      await tester.pumpWidget(_wrap(_enum(onChanged: (v) => selected = v)));

      // Trigger shows the current value (never a placeholder: value is
      // non-nullable in IronEnum).
      expect(find.text('ACTIVE'), findsOneWidget);
      expect(find.text('TURBO'), findsNothing);

      await tester.tap(find.byType(IronDropdownField<_Mode>));
      await tester.pumpAndSettle();
      expect(find.text('IDLE'), findsOneWidget);
      expect(find.text('TURBO'), findsOneWidget);
      // Gold check on the current value row.
      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(find.text('TURBO'));
      await tester.pumpAndSettle();
      expect(selected, _Mode.turbo);
      expect(find.text('TURBO'), findsOneWidget); // now in the trigger
      expect(find.text('IDLE'), findsNothing); // menu closed
    });

    testWidgets('falls back to toString when itemAsString is omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          IronEnum<_Mode>(
            title: 'Mode',
            label: 'Mode',
            mode: IronSelectMode.dropdown,
            value: _Mode.idle,
            options: _Mode.values,
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('_Mode.idle'), findsOneWidget);
    });

    testWidgets('keyboard highlight starts at the current value', (
      tester,
    ) async {
      _Mode? selected;
      await tester.pumpWidget(_wrap(_enum(onChanged: (v) => selected = v)));
      await tester.tap(find.byType(IronDropdownField<_Mode>));
      await tester.pumpAndSettle();

      // Current value is `active` (index 1); one ArrowDown → `turbo`.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(selected, _Mode.turbo);
    });

    testWidgets('disabled field does not open', (tester) async {
      await tester.pumpWidget(_wrap(_enum(enabled: false)));
      await tester.tap(find.byType(IronDropdownField<_Mode>));
      await tester.pumpAndSettle();
      expect(find.text('IDLE'), findsNothing);
    });
  });

  group('IronEnum adaptive mode', () {
    testWidgets('uses dropdown on macOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      await tester.pumpWidget(_wrap(_enum(mode: IronSelectMode.adaptive)));
      final dropdown = find.byType(IronDropdownField<_Mode>);
      // Reset inside the body: the binding verifies foundation debug
      // variables right after it, before tear-downs run.
      debugDefaultTargetPlatformOverride = null;
      expect(dropdown, findsOneWidget);
    });

    testWidgets('uses bottom sheet on iOS', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(_wrap(_enum(mode: IronSelectMode.adaptive)));
      final dropdown = find.byType(IronDropdownField<_Mode>);
      debugDefaultTargetPlatformOverride = null;
      expect(dropdown, findsNothing);
    });
  });

  group('IronEnum bottom-sheet mode regression', () {
    testWidgets('default mode keeps the legacy picker path', (tester) async {
      await tester.pumpWidget(_wrap(_enum(mode: IronSelectMode.bottomSheet)));
      expect(find.byType(IronDropdownField<_Mode>), findsNothing);
    });
  });
}
