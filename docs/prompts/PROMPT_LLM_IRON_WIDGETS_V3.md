# Prompt para LLM — Crear paquete Flutter `iron_widgets` (v3)

> **Versión:** 3.0 · Fecha de edición: 2026-04-22
> **Modelo de ejecución:** **single-shot**. El operador humano adjunta en la misma conversación este prompt + todos los archivos legacy necesarios. El LLM implementa el paquete completo en su respuesta, sin fases ni confirmaciones previas.
> **Cambios respecto a v2:**
> - Eliminado el protocolo de 3 fases.
> - Eliminadas las confirmaciones de recepción.
> - Eliminado el análisis previo del LLM.
> - Eliminadas las preguntas aclaratorias previas: **las decisiones ambiguas se resuelven con defaults sensatos documentados inline**.
> - La LLM recibe los archivos como adjuntos y ejecuta.

---

## BEGIN PROMPT

Eres un Senior Flutter Package Author. Vas a crear desde cero un paquete Flutter publicable en pub.dev llamado **`iron_widgets`**, basado en widgets legacy de un proyecto pre-LLM (2023) cuyos archivos fuente están adjuntos a esta conversación.

**No pidas confirmaciones. No pidas aclaraciones.** Analiza cada archivo e implementa directamente siguiendo las especificaciones abajo. Las ambigüedades se resuelven con los defaults declarados explícitamente en §9.

---

## 0 — Archivos adjuntos que recibirás

El operador humano adjunta a esta conversación los siguientes archivos legacy. **Úsalos como única fuente de verdad** sobre el comportamiento original; cuando entre en conflicto con la descripción textual de este prompt, la descripción textual gana (representa la evolución deseada, no la preservación literal del legacy).

**Archivos legacy:**
- `app_colors.dart`
- `label.dart`
- `mini_text.dart`
- `editor.dart`
- `editor_double.dart`
- `enum.dart`
- `select.dart`
- `check.dart`
- `multi_selector.dart`
- `w_micro_switch.dart`
- `w_micro_editor.dart`
- `widgets_shows.dart`

**Paquete `flutter_custom_selector` completo:** código fuente en múltiples archivos, a vendorizar dentro del paquete.

---

## 1 — Contexto del entregable

| Atributo | Valor |
|---|---|
| Nombre del paquete | `iron_widgets` |
| Dart SDK | `>=3.11.0 <4.0.0` |
| Flutter SDK | `>=3.41.0` |
| Tipo | package (no plugin, no app) |
| Plataformas | android, ios, macos, windows, linux, web |
| Licencia | MIT |
| Target pub.dev pana score | ≥ 130 |

**Dependencias externas PROHIBIDAS:** Riverpod, Provider, BLoC, GetX, get_it, Firebase, cualquier state management, cualquier paquete de red o persistencia.

**Dependencias externas PERMITIDAS en `pubspec.yaml`:**
- `flutter: { sdk: flutter }`

**Código vendorizado:** `flutter_custom_selector` se copia dentro de `lib/src/vendor/flutter_custom_selector/` con su licencia original preservada. Se moderniza a Flutter 3.41 / Dart 3.11 manteniendo su API pública interna intacta.

---

## 2 — Catálogo de widgets a portar

Mantén cada nombre de clase con su capitalización original, agregando el prefijo `Iron` (Ej. `Label` -> `IronLabel`).

### Grupo A — Widgets Simples

| Nombre | Tipo objetivo                                                       |
|---|---------------------------------------------------------------------|
| `Label` | StatelessWidget                                                     |
| `MiniText` | StatelessWidget                                                     |
| `Editor` | StatefulWidget                                                      |
| `Enum<T>` | StatefulWidget genérico (usa `flutter_custom_selector` vendorizado) |
| `Select<T>` | StatefulWidget genérico (usa `flutter_custom_selector` vendorizado) |
| `Check` | StatelessWidget                                                     |
| `MultiSelector<T>` | StatefulWidget genérico (usa `flutter_custom_selector` vendorizado) |
| `WMicroSwitch` | StatefulWidget (eliminar prefijo `W` y sustituir por `Iron`          |
| `WMicroEditor` | StatefulWidget (eliminar prefijo `W` y sustituir por `Iron`          |

Los que en el legacy eran `StatefulWidget` sin estado real se convierten a `StatelessWidget`. Esto incluye `Label` y `MiniText` con seguridad; evalúa el resto al leer el adjunto.

### Grupo B — Widgets Shows

Funciones legacy convertir a clases Widget:

| Legacy | V2 |
|---|---|
| `show(...)` | `Show` (StatelessWidget) |
| `showValuesColumn(...)` | `ShowValuesColumn` (StatelessWidget) |
| `showPercColumn(...)` | `ShowPercColumn` (StatelessWidget) |
| Constantes `baseStyleValue`, `baseStyleLabel`, `baseStyleTitle`, `baseStylePercent` | Migradas a `IronWidgetsTheme` |
| Variables top-level mutables (`height = 20`, `fontSize = 10`, `widthInt`, `widthValue`, `widthPercent`) | Migradas a tokens del `IronWidgetsTheme` |

---

## 3 — IronWidgetsTheme

Pieza central del paquete.

### 3.1 Contrato

```dart
@immutable
class IronWidgetsTheme extends ThemeExtension<IronWidgetsTheme> {
  // Paleta Iron Man (extraída de app_colors.dart legacy)
  final Color darkRed;     // 0xFFB30000
  final Color gold;        // 0xFFFFD700
  final Color darkGray;    // 0xFF333333

  // TextStyles (migrados de widgets_shows.dart)
  final TextStyle baseStyleValue;
  final TextStyle baseStyleLabel;
  final TextStyle baseStyleTitle;
  final TextStyle baseStylePercent;

  // Tokens de dimensión micro (migrados de widgets_shows.dart)
  final double microWidgetHeight;   // legacy 20
  final double microFontSize;        // legacy 10
  final double microIntWidth;        // legacy 20
  final double microValueWidth;      // legacy 60
  final double microPercentWidth;    // legacy 60

  // Roles semánticos
  final Color valueBackground;       // default = gold
  final Color borderAccent;          // default = gold
  final Color dangerColor;           // default = darkRed
  final Color neutralSurface;        // default = darkGray

  const IronWidgetsTheme({...});

  /// Tema por defecto del paquete: paleta Iron Man exacta del legacy.
  factory IronWidgetsTheme.defaults();

  /// Genera un ThemeData completo para consumidores que adopten
  /// la estética Iron Man en toda la app.
  ThemeData buildMaterialTheme({Brightness brightness = Brightness.light});

  /// Helper para resolver color de texto legible sobre un background dado.
  Color textColorOn(Color bg);

  @override
  IronWidgetsTheme copyWith({...});

  @override
  IronWidgetsTheme lerp(covariant ThemeExtension<IronWidgetsTheme>? other, double t);
}
```

### 3.2 Resolver interno

Cada widget del paquete resuelve su tema con:

```dart
// lib/src/internal/theme_resolver.dart
IronWidgetsTheme resolveIronTheme(BuildContext context) {
  return Theme.of(context).extension<IronWidgetsTheme>()
      ?? IronWidgetsTheme.defaults();
}
```

**Los widgets NUNCA hardcodean colores, fontSizes ni dimensiones micro.** Todo pasa por el resolver.

### 3.3 Scope helper

```dart
class IronWidgetsThemeScope extends StatelessWidget {
  const IronWidgetsThemeScope({
    super.key,
    required this.child,
    this.theme,
  });

  /// null → IronWidgetsTheme.defaults()
  final IronWidgetsTheme? theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final parentTheme = Theme.of(context);
    final ironTheme = theme ?? IronWidgetsTheme.defaults();
    return Theme(
      data: parentTheme.copyWith(
        extensions: [
          ...parentTheme.extensions.values.where((e) => e is! IronWidgetsTheme),
          ironTheme,
        ],
      ),
      child: child,
    );
  }
}
```

### 3.4 Cohabitación con ColorScheme del consumidor

- Si el consumidor inyectó `IronWidgetsTheme`, los widgets usan esa paleta.
- Si no, usan `IronWidgetsTheme.defaults()` como fallback, pero para textos sobre superficies del consumidor resuelven el contraste con `textColorOn(bg)` que elige entre `Colors.black` y `Colors.white` según la luminancia del background.
- En dark mode del consumidor, los textos negros legacy sobre `gold` siguen siendo legibles porque el `gold` es claro; valida con contraste AA en los goldens.

---

## 4 — Reglas de modernización (Flutter 3.41 / Dart 3.11, abril 2026)

Aplica a cada widget portado **y al código vendorizado** de `flutter_custom_selector`.

### 4.1 Sintaxis

- `super.key` en constructores.
- `StatefulWidget → StatelessWidget` cuando el legacy declaró Stateful sin estado real.
- Callbacks tipados: `ValueChanged<T>`, `void Function(T)`.
- `const` constructors agresivamente.
- Super parameters donde aporten.
- `Container` → `Padding`/`SizedBox`/`DecoratedBox`/`ColoredBox` cuando corresponda.
- Records de Dart 3 para retornos internos tupleados si mejoran tipado.

### 4.2 Theming

- Cero colores hardcodeados; todo vía `resolveIronTheme(context)`.
- Compatible con `useMaterial3: true` y `false`.
- Compatible con light y dark mode del consumidor.

### 4.3 Accesibilidad

- Widgets interactivos envueltos en `Semantics` con `label`.
- Exponen `semanticLabel` como parámetro.
- Respetan `enabled: false` visualmente y desactivan interacciones.
- Mantén `fontSize: 10` del legacy para preservar la idea visual, **pero** expón `textScaler: TextScaler.of(context)` en los widgets micro para que respeten el factor de escalado del sistema operativo.

### 4.4 Internacionalización

- Cero strings hardcodeados en español/inglés dentro de widgets.
- Usa `Directionality.of(context)` cuando la orientación importe.

### 4.5 Performance

- `const` donde sea posible.
- `StatelessWidget` cuando no haga falta estado.
- Debounce opcional en `Editor` con parámetro `debounce: Duration?`.

### 4.6 Lints

`analysis_options.yaml`:
- Base: `package:flutter_lints/flutter.yaml`.
- Reglas extra: `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `require_trailing_commas`, `sort_constructors_first`, `unnecessary_lambdas`, `prefer_single_quotes`, `use_super_parameters`, `avoid_redundant_argument_values`.
- `analyzer.errors.unused_import: error`.

### 4.7 Vendorización de flutter_custom_selector

- Copia bajo `lib/src/vendor/flutter_custom_selector/`.
- Moderniza siguiendo §4.1-4.6.
- Preserva `LICENSE` original en `LICENSE-flutter_custom_selector.txt` en la raíz del paquete + README de atribución en `lib/src/vendor/flutter_custom_selector/README.md`.
- Mantén su API pública interna para minimizar cambios en `Enum<T>`.
- Documenta cambios en `MIGRATION.md`.

---

## 5 — Estructura de archivos a producir

```
iron_widgets/
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
├── LICENSE                                 (MIT)
├── LICENSE-flutter_custom_selector.txt     (original del paquete vendorizado)
├── NOTICE.md                               (créditos de terceros)
├── analysis_options.yaml
├── .gitignore
├── lib/
│   ├── iron_widgets.dart                   (barrel export)
│   └── src/
│       ├── theme/
│       │   ├── iron_colors.dart
│       │   ├── iron_text_styles.dart
│       │   ├── iron_dimens.dart
│       │   ├── iron_widgets_theme.dart
│       │   └── iron_widgets_theme_scope.dart
│       ├── internal/
│       │   └── theme_resolver.dart
│       ├── iron_widgets/
│       │   ├── iron_mini_text.dart
│       │   ├── iron_label.dart
│       │   ├── iron_check.dart
│       │   ├── iron_micro_switch.dart
│       │   ├── iron_micro_editor.dart
│       │   ├── iron_editor.dart
│       │   ├── iron_select.dart
│       │   ├── iron_enum.dart
│       │   ├── iron_multi_selector.dart
│       │   └── iron_shows.dart
│       └── vendor/
│           └── flutter_custom_selector/
│               ├── LICENSE.txt
│               ├── README.md
│               └── [archivos originales modernizados]
├── test/
│   ├── widget_test.dart
│   ├── theme_test.dart
│   └── golden_test.dart
├── example/
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart
│   │   ├── showcase_screen.dart
│   │   ├── theme_switcher.dart
│   │   └── sections/
│   │       ├── simple_widgets_section.dart
│   │       └── shows_section.dart
│   └── README.md
└── doc/
    ├── api_reference.md
    ├── theming_guide.md
    └── migration_from_legacy.md
```

---

## 6 — Example app: toggle de tema 3 estados

`SegmentedButton` fijo en el AppBar con tres opciones exclusivas:

| Opción | Implementación | Resultado visual |
|---|---|---|
| **Iron (default)** | `IronWidgetsThemeScope` envuelve el body. `MaterialApp.theme = ironTheme.buildMaterialTheme(Brightness.light)`. | Paleta Iron Man completa (fondos gold, acentos darkRed). |
| **Material Light** | Sin `IronWidgetsThemeScope`. `MaterialApp.theme = ThemeData(useMaterial3: true, brightness: Brightness.light)`. | Widgets usan `IronWidgetsTheme.defaults()` como fallback interno pero conviven con Material light. |
| **Material Dark** | Sin `IronWidgetsThemeScope`. `MaterialApp.theme = ThemeData(useMaterial3: true, brightness: Brightness.dark)`. | Igual pero dark mode. Textos deben seguir legibles. |

La selección NO se persiste entre sesiones; se resetea a "Iron" en cada cold start.

Requisitos adicionales de la example app:

- Scrollable única con secciones por categoría (Simples / Shows).
- Cada widget se muestra con al menos 2 estados (on/off, vacío/lleno, checked/unchecked).
- Código de muestra visible debajo de cada widget con botón "Copy" usando `Clipboard.setData`.
- Corre en `flutter run -d chrome` sin errores.
- Responsive en 375px / 768px / 1280px.

---

## 7 — Orden estricto de generación

Genera los archivos **exactamente en este orden**, un archivo por bloque de código (nunca dos archivos en el mismo bloque). No narres entre archivos; solo el nombre de archivo como header.

**Paso 7.1 — Configuración y licencias:**
1. `pubspec.yaml`
2. `analysis_options.yaml`
3. `.gitignore`
4. `LICENSE` (MIT)
5. `LICENSE-flutter_custom_selector.txt`
6. `NOTICE.md`

**Paso 7.2 — Theme layer:**
7. `lib/src/theme/iron_colors.dart`
8. `lib/src/theme/iron_text_styles.dart`
9. `lib/src/theme/iron_dimens.dart`
10. `lib/src/theme/iron_widgets_theme.dart`
11. `lib/src/theme/iron_widgets_theme_scope.dart`

**Paso 7.3 — Internal helpers:**
12. `lib/src/internal/theme_resolver.dart`

**Paso 7.4 — Vendored flutter_custom_selector:**
13. Todos los archivos de `lib/src/vendor/flutter_custom_selector/` en orden de dependencia interna. Incluye LICENSE.txt y README.md de atribución al inicio.

**Paso 7.5 — Iron Widgets (orden de dependencia interna):**
14. `lib/src/iron_widgets/iron_mini_text.dart`
15. `lib/src/iron_widgets/iron_label.dart`
17. `lib/src/iron_widgets/iron_check.dart`
18. `lib/src/iron_widgets/iron_micro_switch.dart`
19. `lib/src/iron_widgets/iron_micro_editor.dart`
20. `lib/src/iron_widgets/iron_editor.dart`
21. `lib/src/iron_widgets/iron_select.dart`
22. `lib/src/iron_widgets/iron_enum.dart`
23. `lib/src/iron_widgets/iron_multi_selector.dart`

**Paso 7.6 — Shows:**
24. `lib/src/iron_widgets/iron_shows.dart`

**Paso 7.7 — Barrel export:**
25. `lib/iron_widgets.dart`

**Paso 7.8 — Tests:**
26. `test/widget_test.dart`
27. `test/theme_test.dart`
28. `test/golden_test.dart`

**Paso 7.9 — Example app:**
29. `example/pubspec.yaml`
30. `example/lib/theme_switcher.dart`
31. `example/lib/sections/simple_widgets_section.dart`
32. `example/lib/sections/shows_section.dart`
33. `example/lib/showcase_screen.dart`
34. `example/lib/main.dart`
35. `example/README.md`

**Paso 7.10 — Documentación:**
36. `README.md`
37. `CHANGELOG.md`
38. `MIGRATION.md` (equivale a `doc/migration_from_legacy.md`, ubicado en raíz del paquete)
39. `doc/theming_guide.md`
40. `doc/api_reference.md`

**Paso 7.11 — Comandos de verificación final:**
41. Un último bloque con los comandos que el operador debe correr, y qué debe ver en cada uno.

---

## 8 — Criterios de aceptación

Tu trabajo está completo cuando:

1. `flutter pub get` corre limpio.
2. `flutter analyze` 0 issues.
3. `flutter test` pasa 100% (unit + theme + goldens).
4. `dart pub publish --dry-run` sin warnings.
5. `flutter pub publish --dry-run` simula publicación exitosa.
6. Example app en `flutter run -d chrome`: toggle de 3 modos afecta correctamente todos los widgets.
7. Cada widget tiene Dartdoc completo: descripción, parámetros, snippet dart, nota de cambios respecto al legacy, nota de comportamiento con vs sin `IronWidgetsTheme`.
8. `README.md`, `CHANGELOG.md`, `MIGRATION.md`, `doc/theming_guide.md`, `doc/api_reference.md` completos y coherentes.
9. Atribución a `flutter_custom_selector` preservada en `NOTICE.md` y `LICENSE-flutter_custom_selector.txt`.

---

## 9 — Defaults para decisiones ambiguas (SIN preguntar)

Estas son las decisiones pre-resueltas. **No preguntes sobre ellas; aplícalas.**

| Pregunta | Default a aplicar |
|---|---|
| `buildMaterialTheme()` usa seed o construcción manual | Manual: `primary = darkRed`, `secondary = gold`, `surface = Colors.white` (light) / `darkGray` (dark), `onPrimary = Colors.white`, `onSecondary = Colors.black`. |
| `MultiSelector<T>` rendering | Chips dentro de `Wrap`, con `FilterChip` de Material 3. Selección mantiene orden de inserción. |
| `itemAsString` fallback en `Enum<T>` y `Select<T>` | Parámetro opcional `String Function(T)? itemAsString`; fallback a `item.toString()`. |
| Persistencia del tema en example app | NO persistir. Se resetea a "Iron" en cada cold start. |
| Linter base | `flutter_lints` (no `very_good_analysis`). |
| `fontSize: 10` del legacy y A11y | Preservar 10 como default del tema, exponer `TextScaler.of(context)` en widgets micro, documentar en `theming_guide.md` la trade-off y cómo sobreescribir vía `copyWith(baseStyleValue: ...)`. |
| Toggle de tema en example app | `SegmentedButton` (Material 3). |
| Debounce default en `Editor` | `null` (sin debounce). Parámetro opcional `debounce: Duration?`. |
| Comportamiento de `Editor` cuando `text` cambia desde fuera | Ignorar (controlled component) si no se pasó `controller` explícito; si se pasó `controller`, respetar sus cambios. |
| Versión de `flutter_custom_selector` a vendorizar | La que el adjunto contenga. |

---

## 10 — Reglas operativas

- **No pidas confirmación.** Ejecuta.
- **No pidas aclaraciones.** Usa §9 y §3-§6.
- Implementa directamente consultando los adjuntos según necesites.
- **No narres entre archivos.**
- **No muestres el código implementado en el chat conmigo, solo provee los archivos finales.**
- **Mantén la idea visual original.** Optimiza la implementación, no la estética.
- **Cada cambio respecto al legacy va en `MIGRATION.md`.**
- **No agregues widgets fuera del catálogo de §2.**
- **Cero `// TODO`, cero código incompleto, cero placeholders.**
- **Cero `print`, cero `debugPrint` en código de producción.**
- **Cero `BuildContext` post-async sin `mounted` check.**
- **Cero singletons globales.** Variables top-level mutables del legacy migran a tokens de `IronWidgetsTheme` o parámetros con default del theme.
- **Respeta la licencia de `flutter_custom_selector`** al vendorizarlo.

## END PROMPT

---

## Apéndice — Notas para el operador humano

### Cómo usar este prompt

1. Abre una nueva sesión con Claude Code / Cursor / Aider / Codex (el que prefieras).
2. **Adjunta** como archivos separados en el mismo mensaje:
   - Todos los archivos `.dart` del legacy listados en §0.
   - El paquete `flutter_custom_selector` completo (puedes comprimirlo o subir archivos individuales según soporte la herramienta).
3. **Pega este prompt** (el bloque entre `BEGIN PROMPT` y `END PROMPT`) como mensaje principal.
4. Envía. El LLM genera todo el paquete en una sola respuesta.

### Cambios respecto a v2

| Aspecto | v2 | v3 |
|---|---|---|
| Fases | 3 (Plan, Ingesta, Generación) | 1 (single-shot) |
| Confirmaciones | Confirmación por archivo recibido | Ninguna |
| Análisis previo | Análisis de 3-7 bullets por archivo | Ninguno |
| Preguntas | 7 preguntas al operador | 0 (todas pre-resueltas en §9) |
| Comunicación entre archivos | Permitida | Prohibida (solo header + bloque) |
| Tokens estimados | ~200k-350k output total (incluye narración) | ~150k-250k output total (solo código + docs) |

### Verificación post-generación

Tras recibir la respuesta completa:

```bash
mkdir iron_widgets && cd iron_widgets
# Copia los archivos generados respetando la estructura de §5

flutter pub get
flutter analyze
flutter test
dart pub publish --dry-run
cd example && flutter pub get && flutter run -d chrome
```

Visual check en la example app:

- Modo **Iron**: backgrounds gold visibles en `ShowValuesColumn`, textos negros bold.
- Modo **Material Light**: widgets integrados con colorScheme light del consumidor.
- Modo **Material Dark**: texto sigue siendo legible, contraste OK.

Si alguno de los 5 comandos falla, devuelve el error exacto al LLM con el comando `Corrige solo los archivos afectados por este error: [...]`.

---

*Fin del documento.*
