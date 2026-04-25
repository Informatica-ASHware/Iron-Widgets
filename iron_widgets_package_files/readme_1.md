49 archivos entregados. El paquete está completo.

---

## Resumen de lo generado

### Pasos de verificación (ejecutar en orden)

```bash
cd iron_widgets
flutter pub get                                    # sin errores
flutter analyze                                    # 0 issues
flutter test test/widget_test.dart test/theme_test.dart   # pasa 100%
flutter test test/golden_test.dart --update-goldens       # genera goldens
flutter test test/golden_test.dart                 # comparación
dart pub publish --dry-run                         # simulación exitosa

cd example && flutter pub get && flutter run -d chrome
```

---

### Decisiones arquitectónicas aplicadas

| Decisión | Implementación |
|---|---|
| `Check`, `Label`, `MiniText` → `StatelessWidget` | Confirmado al leer el legacy: no tenían estado real. `IronCheck` es ahora un **controlled component** |
| `WMicroSwitch` global refresh eliminado | `addRefreshLotWidget` / `wSil` removidos; el widget lee `widget.value` directamente |
| `flutter_custom_selector` vendorizado | Bajo `lib/src/vendor/`; bug `with CustomBottomSheetSelector<T>` corregido (inválido en Dart 3); `mounted` guards agregados |
| Bug `Select`/`MultiSelector` solucionado | `allOptionText`, `doneButtonText`, `cancelButtonText` ahora se pasan correctamente al bottom-sheet |
| `IronMultiSelector` usa `FilterChip` | Selección visible con Material 3 `FilterChip` en `Wrap`; orden de inserción preservado |
| `IronEditor` debounce | `Timer` de `dart:async`; `null` por defecto |
| `fontSize: 10` + a11y | Valor preservado como default del tema; `MediaQuery.textScalerOf(context).scale()` aplicado en todos los widgets micro |
| Colores hardcodeados eliminados | Todo resuelve vía `resolveIronTheme(context)` → `IronWidgetsTheme.defaults()` como fallback |
