# Prompt para LLM — Crear paquete Flutter `iron_widgets` (v2)

> **Versión:** 2.0 · Fecha de edición: 2026-04-22
> **Cambios respecto a v1:**
> 1. El **operador humano** inyectará el código fuente de cada widget legacy directamente en la conversación, en lugar de que el prompt los contenga inline.
> 2. `flutter_custom_selector` **se integra dentro de `iron_widgets`** como código vendorizado, en vez de reemplazarlo con widgets de Material 3.
> 3. Se incorpora **análisis obligatorio** de `app_colors.dart` legacy.
> 4. Se define un **`IronWidgetsTheme` como tema por defecto** del paquete, que codifica la paleta Iron Man y los `TextStyle` del legacy.
> 5. La **example app** incluye un toggle de tres estados: `IronWidgetsTheme` (default del paquete), light Material del consumidor, dark Material del consumidor.

> **Cómo usar este prompt:** copia todo el contenido entre `BEGIN PROMPT` y `END PROMPT` en una nueva sesión del LLM de codificación. El LLM te pedirá inyectar los archivos legacy uno a uno conforme los necesita (Fase 2). No peques los archivos legacy hasta que te los pida.

---

## BEGIN PROMPT

Eres un Senior Flutter Package Author. Tu tarea es crear desde cero un paquete Flutter publicable en pub.dev llamado **`iron_widgets`**, basado en widgets legacy de un proyecto pre-LLM (2023) que el usuario te proveerá archivo por archivo.

Este prompt funciona en **tres fases secuenciales**:
- **Fase 1 — Plan y confirmación.** Analizas este prompt, haces preguntas si las hay, presentas tu plan de trabajo.
- **Fase 2 — Ingesta del código legacy.** Pides los archivos legacy uno a uno, analizas cada uno al recibirlo, resumes tu entendimiento, y solo cuando tengas todos empiezas a codear.
- **Fase 3 — Generación.** Produces el paquete completo siguiendo el orden especificado.

---

## 0 — Contexto del entregable

**Nombre del paquete:** `iron_widgets`
**Identificador en pubspec:** `iron_widgets`
**Dart SDK constraint:** `>=3.11.0 <4.0.0`
**Flutter SDK constraint:** `>=3.41.0`
**Tipo:** package (no plugin, no app — solo widgets reutilizables).
**Plataformas declaradas:** android, ios, macos, windows, linux, web.
**Licencia:** MIT (incluir `LICENSE` en raíz). Si vendorizas `flutter_custom_selector`, **respeta su licencia original** (incluir `NOTICE` o `LICENSE-flutter_custom_selector` en el directorio correspondiente).
**Publicable en pub.dev:** sí. Apuntar a pana score ≥ 130.

### Dependencias

**NO debes incluir** bajo ninguna circunstancia: Riverpod, Provider, BLoC, GetX, get_it, Firebase, ningún paquete de state management, ningún paquete de red, ningún paquete de persistencia.

**Dependencias internas del paquete publicado** (en `pubspec.yaml`):
- `flutter: { sdk: flutter }`

**Código vendorizado** (copiado dentro de `lib/src/vendor/` del paquete, no declarado como dependencia externa):
- `flutter_custom_selector` (lo proveerá el usuario en Fase 2).

Si la lógica de `flutter_custom_selector` depende a su vez de paquetes terceros, **declaras esas dependencias en el `pubspec.yaml`** con sus versiones actualizadas a 2026. Documenta cualquier dependencia transitiva que necesites añadir en `MIGRATION.md`.

---

## 1 — Catálogo de widgets a portar

Debes portar **exactamente esta lista**, manteniendo cada nombre de clase/función con su capitalización original. La estructura de archivos se reorganiza; los nombres públicos no.

### Grupo A — Widgets simples (de `lib/widgets_simples/*` del legacy)

| Nombre original | Tipo objetivo en V2 | Notas |
|---|---|---|
| `Label` | StatelessWidget | El legacy lo tenía como StatefulWidget por inercia. Sin estado real. |
| `MiniText` | StatelessWidget | Idem. |
| `Editor` | StatefulWidget | Mantiene estado (TextEditingController). |
| `Enum<T>` | StatefulWidget genérico | Usa el `flutter_custom_selector` vendorizado internamente. |
| `Select<T>` | StatefulWidget genérico | Dropdown de un valor. |
| `Check` | StatelessWidget | Checkbox con label horizontal. |
| `MultiSelector<T>` | StatefulWidget genérico | Chips multiselect. |
| `Button` | StatelessWidget | Botón estilizado. |
| `WMicroSwitch` | StatefulWidget | Toggle compacto con tooltip opcional. |
| `WMicroEditor` | StatefulWidget | Editor inline muy compacto. |

### Grupo B — Widgets de visualización tabular (de `lib/make_real/widgets/widgets_shows.dart` del legacy)

Funciones top-level legacy → Widgets con nombres preservando la idea:

| Legacy (función) | Nuevo (Widget) |
|---|---|
| `show(...)` | `Show` (StatelessWidget) |
| `showValuesColumn(...)` | `ShowValuesColumn` (StatelessWidget) |
| `showPercColumn(...)` | `ShowPercColumn` (StatelessWidget) |
| Constantes `baseStyleValue`, `baseStyleLabel`, `baseStyleTitle`, `baseStylePercent` | Migran a `IronWidgetsTheme` (ver §3). |

### Grupo C — Paquete vendorizado

| Legacy | Ubicación en V2 |
|---|---|
| `flutter_custom_selector` (paquete externo completo) | `lib/src/vendor/flutter_custom_selector/` |

Consumo interno. **No expongas** sus widgets en la API pública del barrel export salvo que sean necesarios para algún widget del catálogo (en ese caso, reexporta solo lo estrictamente necesario). Mantén la atribución de licencia original.

---

## 2 — Archivos legacy que el usuario te proveerá en Fase 2

Al iniciar Fase 2, solicita estos archivos **en este orden exacto**, uno a la vez. No pidas el siguiente hasta haber confirmado recepción y análisis del actual. Al recibir cada uno:

1. Confirmas que lo recibiste correctamente.
2. Produces un **análisis de 3-7 bullets**: qué hace, cuál es su API pública, qué efectos colaterales tiene, qué dependencias legacy lo tocan, qué decisiones de modernización propones.
3. **Guardas el código en tu contexto de trabajo** sin empezar a codear aún.

### Orden de solicitud:

1. `lib/app_colors.dart` — paleta de colores del legacy. De aquí saldrá la paleta default de `IronWidgetsTheme`.
2. `lib/widgets_simples/label.dart`
3. `lib/widgets_simples/mini_text.dart`
4. `lib/widgets_simples/editor.dart`
5. `lib/widgets_simples/enum.dart`
6. `lib/widgets_simples/select.dart` (si existe como archivo separado)
7. `lib/widgets_simples/check.dart` (si existe como archivo separado)
8. `lib/widgets_simples/multi_selector.dart`
9. `lib/widgets_simples/button.dart` (si existe como archivo separado)
10. `lib/widgets_simples/w_micro_switch.dart`
11. `lib/widgets_simples/w_micro_editor.dart`
12. `lib/widgets_simples/_exports.dart` (para entender la superficie pública interna legacy)
13. `lib/make_real/widgets/widgets_shows.dart` — muy importante; aquí están los `TextStyle` base.
14. `flutter_custom_selector/` — el paquete completo. El usuario te lo entregará en múltiples mensajes (un archivo por mensaje, con ruta relativa al root del paquete `flutter_custom_selector`). Pide todos los archivos hasta que el usuario indique "fin del paquete".

Si algún archivo no está disponible o es diferente de lo listado, el usuario te lo indicará y **tú adaptas el plan preguntando** antes de asumir.

---

## 3 — IronWidgetsTheme: el tema por defecto del paquete

Esta es una **pieza central** del paquete. Léela con atención.

### 3.1 Concepto

`IronWidgetsTheme` es un `ThemeExtension<IronWidgetsTheme>` que encapsula:

- **La paleta Iron Man legacy:** `darkRed`, `gold`, `darkGray` (extraídos de `app_colors.dart` — el usuario te pasará el archivo en Fase 2).
- **Los `TextStyle` base legacy:** `baseStyleValue`, `baseStyleLabel`, `baseStyleTitle`, `baseStylePercent` (extraídos de `widgets_shows.dart`).
- **Tokens de dimensión:** `microWidgetHeight` (≈14-20), `microFontSize` (≈10), `microValueWidth`, `microPercentWidth`, `microIntWidth` — extraídos de las variables top-level de `widgets_shows.dart`.
- **Roles semánticos derivados:** `valueBackground` (default `gold`), `borderAccent` (default `gold`), `dangerColor` (default `darkRed`), `neutralSurface` (default `darkGray`).

### 3.2 Contrato público

```dart
@immutable
class IronWidgetsTheme extends ThemeExtension<IronWidgetsTheme> {
  // Paleta base
  final Color darkRed;
  final Color gold;
  final Color darkGray;

  // Estilos de texto (migrados desde widgets_shows.dart)
  final TextStyle baseStyleValue;
  final TextStyle baseStyleLabel;
  final TextStyle baseStyleTitle;
  final TextStyle baseStylePercent;

  // Tokens de dimensión
  final double microWidgetHeight;
  final double microFontSize;
  final double microValueWidth;
  final double microPercentWidth;
  final double microIntWidth;

  // Roles semánticos
  final Color valueBackground;
  final Color borderAccent;
  final Color dangerColor;
  final Color neutralSurface;

  const IronWidgetsTheme({...});

  /// El tema por defecto del paquete — paleta Iron Man exacta del legacy.
  factory IronWidgetsTheme.defaults() => IronWidgetsTheme(
    darkRed: const Color(0xFFB30000),
    gold: const Color(0xFFFFD700),
    darkGray: const Color(0xFF333333),
    baseStyleValue: const TextStyle(
      color: Colors.black,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.fade,
    ),
    // ...resto según los valores exactos extraídos de widgets_shows.dart
  );

  /// Construye un ThemeData completo basado en la paleta IronWidgetsTheme.
  /// Útil para apps que quieren adoptar la estética Iron Man completa.
  ThemeData buildMaterialTheme({Brightness brightness = Brightness.light});

  @override
  IronWidgetsTheme copyWith({...});

  @override
  IronWidgetsTheme lerp(covariant ThemeExtension<IronWidgetsTheme>? other, double t);
}
```

### 3.3 Cómo lo consumen los widgets

Cada widget del paquete, al construir, resuelve su tema en este orden:

1. **Si el consumidor inyectó un `IronWidgetsTheme` en `Theme.of(context).extensions`**, úsalo.
2. **Si no**, usa `IronWidgetsTheme.defaults()`.

Patrón concreto:

```dart
static IronWidgetsTheme _resolve(BuildContext context) {
  return Theme.of(context).extension<IronWidgetsTheme>()
      ?? IronWidgetsTheme.defaults();
}
```

Los widgets **nunca** hardcodean colores o fontSizes. Todos pasan por el resolver.

### 3.4 Reglas de interacción con el `ColorScheme` del consumidor

Aunque `IronWidgetsTheme` trae su propia paleta, debe **cohabitar respetuosamente** con el `ColorScheme` del consumidor:

- Para texto sobre superficies del consumidor, usa `Theme.of(context).colorScheme.onSurface` si el consumidor no inyectó `IronWidgetsTheme`.
- Si el consumidor sí inyectó `IronWidgetsTheme`, usa los colores del theme extension.
- Resuelve contrastes: si `valueBackground` es claro (gold), usa texto oscuro; si es oscuro, usa texto claro. Provee helper `textColorOn(Color bg)` en `IronWidgetsTheme`.

### 3.5 Helper de inyección

Facilita al consumidor la adopción con un wrapper:

```dart
/// Wrapper que inyecta IronWidgetsTheme.defaults() en el subtree,
/// así los widgets del paquete usan la estética Iron Man
/// sin que el consumidor tenga que configurar ThemeData manualmente.
class IronWidgetsThemeScope extends StatelessWidget {
  const IronWidgetsThemeScope({
    super.key,
    required this.child,
    this.theme,
  });

  final IronWidgetsTheme? theme;  // null = defaults()
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Inyecta el extension manteniendo todo lo demás del Theme del consumidor
  }
}
```

Uso en la app consumidora:

```dart
MaterialApp(
  theme: miTema,
  builder: (context, child) => IronWidgetsThemeScope(child: child!),
  home: HomeScreen(),
)
```

---

## 4 — Reglas de modernización (Flutter 3.41 / Dart 3.11, abril 2026)

Aplica estas reglas a cada widget portado:

### 4.1 Sintaxis y APIs

- `super.key` en lugar de `Key? key, super(key: key)`.
- `StatefulWidget → StatelessWidget` cuando el legacy lo declaró `Stateful` sin tener estado real.
- Tipa callbacks con `ValueChanged<T>` o `void Function(T)` consistente.
- Aplica `const` constructors agresivamente.
- `super.onTap`, `super.child`, etc. donde corresponda (super parameters).
- Reemplaza `Container` por widgets específicos (`Padding`, `SizedBox`, `DecoratedBox`, `ColoredBox`) cuando aporte claridad.
- Usa records de Dart 3 donde mejoren tipado (ej. retornos de helpers internos).

### 4.2 Theming

- **Cero colores hardcodeados.** Todo va por `_resolve(context)` que devuelve `IronWidgetsTheme`.
- Soporta M2 y M3 (`useMaterial3: true/false`) sin romper.
- Soporta light y dark mode del consumidor de forma coherente: si el consumidor está en dark, los widgets sin IronWidgetsTheme explícito usan colores apropiados del `colorScheme`.

### 4.3 Accesibilidad

- Todos los widgets interactivos exponen `Semantics` con `label` apropiado.
- Exponen parámetro `semanticLabel`.
- Respetan `enabled: false` desactivando interacciones con feedback visual.
- Contraste AA validado en la paleta default (texto negro sobre gold = OK; valida otros).

### 4.4 Internacionalización

- Cero strings hardcodeados en inglés/español dentro de widgets.
- Usa `Directionality.of(context)` donde la orientación importe.

### 4.5 Performance

- `const` constructors donde sea posible.
- `StatelessWidget` cuando no haga falta estado.
- Evita rebuilds innecesarios.
- Debounce opcional en `Editor` con parámetro `debounce: Duration?`.

### 4.6 Lints

`analysis_options.yaml` con:
- Base: `package:flutter_lints/flutter.yaml`.
- Reglas extra: `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `require_trailing_commas`, `sort_constructors_first`, `unnecessary_lambdas`, `prefer_single_quotes`, `use_super_parameters`, `avoid_redundant_argument_values`.
- `analyzer.errors.unused_import: error`.

### 4.7 Código vendorizado

Para `flutter_custom_selector` integrado bajo `lib/src/vendor/flutter_custom_selector/`:

- **Modernízalo** a Flutter 3.41 / Dart 3.11 aplicando las mismas reglas de §4.1-4.6.
- **Mantén su API pública interna** tal cual para minimizar cambios en `Enum<T>` y cualquier otro widget del catálogo que lo use.
- **Preserva autoría y licencia original** en `LICENSE-flutter_custom_selector.txt` o similar.
- Documenta en `MIGRATION.md` qué cambios hiciste al código vendorizado y por qué.

---

## 5 — Estructura de archivos requerida

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
│   ├── iron_widgets.dart                   (barrel export público)
│   └── src/
│       ├── theme/
│       │   ├── iron_colors.dart            (darkRed, gold, darkGray tokens)
│       │   ├── iron_text_styles.dart       (baseStyle* migrados)
│       │   ├── iron_dimens.dart            (tokens de dimensión micro)
│       │   ├── iron_widgets_theme.dart     (ThemeExtension + defaults + buildMaterialTheme)
│       │   └── iron_widgets_theme_scope.dart (helper wrapper)
│       ├── simple/
│       │   ├── label.dart
│       │   ├── mini_text.dart
│       │   ├── editor.dart
│       │   ├── enum.dart
│       │   ├── select.dart
│       │   ├── check.dart
│       │   ├── multi_selector.dart
│       │   ├── button.dart
│       │   ├── w_micro_switch.dart
│       │   └── w_micro_editor.dart
│       ├── shows/
│       │   └── shows.dart                  (Show, ShowValuesColumn, ShowPercColumn)
│       ├── internal/
│       │   └── theme_resolver.dart         (_resolve helper compartido)
│       └── vendor/
│           └── flutter_custom_selector/
│               ├── LICENSE.txt             (licencia original)
│               ├── README.md               (atribución)
│               └── [archivos del paquete original, modernizados]
├── test/
│   ├── widget_test.dart                    (smoke test por widget)
│   ├── theme_test.dart                     (resolución del IronWidgetsTheme)
│   ├── golden_test.dart                    (goldens por widget)
│   └── goldens/
│       ├── default_theme/                  (cada widget con IronWidgetsTheme.defaults())
│       ├── material_light/                 (cada widget con Material light del consumidor)
│       └── material_dark/                  (cada widget con Material dark del consumidor)
├── example/
│   ├── pubspec.yaml
│   ├── lib/
│   │   ├── main.dart                       (app con toggle de tema 3 estados)
│   │   ├── showcase_screen.dart            (sección por categoría)
│   │   ├── sections/
│   │   │   ├── simple_widgets_section.dart
│   │   │   └── shows_section.dart
│   │   └── theme_switcher.dart             (selector 3 estados)
│   └── README.md
└── doc/
    ├── api_reference.md
    ├── theming_guide.md
    └── migration_from_legacy.md
```

---

## 6 — Ejemplo app: toggle de tema de tres estados

La example app debe incluir un selector persistente (top bar, `SegmentedButton` o `DropdownMenu`) con estas **tres opciones mutuamente exclusivas**:

| Opción | Tema aplicado al árbol | Resultado visual esperado |
|---|---|---|
| **Iron (default)** | `IronWidgetsThemeScope(child: ...)` inyecta `IronWidgetsTheme.defaults()`. `MaterialApp.theme` = `ironTheme.buildMaterialTheme(Brightness.light)`. | Paleta Iron Man completa: fondos gold, acentos darkRed, textos negros bold como en el legacy. |
| **Material Light** | No inyecta `IronWidgetsTheme`. `MaterialApp.theme` = `ThemeData.light(useMaterial3: true)`. | Los widgets usan `IronWidgetsTheme.defaults()` como fallback interno pero conviven con el `colorScheme` Material light del consumidor. |
| **Material Dark** | No inyecta `IronWidgetsTheme`. `MaterialApp.theme` = `ThemeData.dark(useMaterial3: true)`. | Idem pero en dark mode. Validar que los textos siguen siendo legibles. |

Criterios de la example app:

- **Scrollable único** con secciones por categoría (widgets simples, widgets show).
- Cada widget se muestra con **al menos dos estados visuales** (ej. `WMicroSwitch` on/off, `Editor` vacío/lleno, `Check` checked/unchecked).
- **Selector de tema fijo en el AppBar** con las tres opciones.
- **Código de muestra visible** debajo de cada widget con un botón "Copy" (usar `Clipboard.setData`).
- **Funciona en `flutter run -d chrome`** sin errores de consola.
- **Responsive:** se ve bien en mobile (375px), tablet (768px) y desktop (1280px).

---

## 7 — Criterios de aceptación (definition of done)

Tu trabajo está completo cuando:

1. `flutter pub get` corre limpio sin warnings.
2. `flutter analyze` devuelve 0 issues.
3. `flutter test` pasa 100% incluidos goldens para las tres variantes de tema.
4. `dart pub publish --dry-run` sin warnings.
5. `flutter pub publish --dry-run` simula publicación exitosa.
6. La example app corre en `flutter run -d chrome` y el **toggle de tema de 3 estados** funciona correctamente en todos los widgets.
7. Cada widget tiene **Dartdoc completo**: descripción, parámetros, ejemplo mínimo con snippet dart, nota sobre cambios respecto al legacy si los hay, nota sobre comportamiento con vs sin `IronWidgetsTheme` si difiere.
8. `README.md` con: badges (pub version, license, Flutter), tabla del catálogo, screenshot/GIF de los 3 modos de tema en la example app, quick-start de 10 líneas que muestra `IronWidgetsThemeScope`, link a `theming_guide.md` y `migration_from_legacy.md`.
9. `CHANGELOG.md` con entrada `## 0.1.0 - 2026-04-22` listando cada widget portado y la vendorización de `flutter_custom_selector`.
10. `MIGRATION.md` documentando:
    - Funciones legacy convertidas a Widgets (`show` → `Show`, etc.).
    - Cambios de tipo (StatefulWidget → StatelessWidget).
    - Breaking changes de API con alternativas.
    - Vendorización de `flutter_custom_selector`: qué cambios se hicieron a su código y por qué.
    - Cómo el consumidor migra desde el legacy CryptBot a `iron_widgets`.
11. `theming_guide.md` con:
    - Explicación del patrón de resolución `IronWidgetsTheme` → fallback a defaults.
    - Ejemplos de los 3 modos (Iron default, Material light, Material dark).
    - Cómo hacer un tema custom (copyWith).
    - Cómo inyectar solo algunos overrides.
12. `NOTICE.md` con atribución a `flutter_custom_selector` y su licencia.

---

## 8 — Plan de salida esperado

### Fase 1 — Plan y preguntas

Responde PRIMERO con:

1. **Confirmación** de que entendiste el entregable.
2. **Plan de trabajo en bullets** (5-15 bullets máximo).
3. **Preguntas de aclaración** si las hay. No inventes respuestas — pregunta.
4. **Instrucción al usuario** de que envíe el primer archivo legacy según el orden de §2.

**No generes código en Fase 1.**

### Fase 2 — Ingesta del código legacy

El usuario te enviará archivos uno por uno. Para cada archivo:

1. Confirma recepción: `✓ Recibí lib/widgets_simples/label.dart (XX líneas)`.
2. **Análisis breve** (3-7 bullets): propósito, API pública, side effects, decisiones de modernización propuestas.
3. **Solicita el siguiente archivo** según el orden de §2.
4. **No empieces a codear** hasta que el usuario te diga "OK, procede a generar" o confirme fin de ingesta.

Para `flutter_custom_selector/`, acepta múltiples archivos sucesivos sin analizar cada uno individualmente si son boilerplate (main.dart del paquete, widgets internos, etc.). Sí identifica y resume **qué clases públicas expone** y cuáles necesitas modernizar.

### Fase 3 — Generación

Una vez el usuario confirme "procede", genera los archivos en este orden exacto, un archivo por bloque de código (nunca dos archivos en el mismo bloque):

1. `pubspec.yaml`
2. `analysis_options.yaml`
3. `.gitignore`
4. `LICENSE` (MIT)
5. `LICENSE-flutter_custom_selector.txt`
6. `NOTICE.md`
7. **Theme layer** (en este orden):
   - `lib/src/theme/iron_colors.dart`
   - `lib/src/theme/iron_text_styles.dart`
   - `lib/src/theme/iron_dimens.dart`
   - `lib/src/theme/iron_widgets_theme.dart`
   - `lib/src/theme/iron_widgets_theme_scope.dart`
8. **Internal helper:**
   - `lib/src/internal/theme_resolver.dart`
9. **Vendored flutter_custom_selector** (en `lib/src/vendor/flutter_custom_selector/`), archivo por archivo, modernizados.
10. **Simple widgets** (orden de dependencia):
    1. `lib/src/simple/mini_text.dart`
    2. `lib/src/simple/label.dart`
    3. `lib/src/simple/button.dart`
    4. `lib/src/simple/check.dart`
    5. `lib/src/simple/w_micro_switch.dart`
    6. `lib/src/simple/w_micro_editor.dart`
    7. `lib/src/simple/editor.dart`
    8. `lib/src/simple/select.dart`
    9. `lib/src/simple/enum.dart`
    10. `lib/src/simple/multi_selector.dart`
11. **Shows:**
    - `lib/src/shows/shows.dart`
12. **Barrel:**
    - `lib/iron_widgets.dart`
13. **Tests:**
    - `test/widget_test.dart`
    - `test/theme_test.dart`
    - `test/golden_test.dart` (sin binarios — el usuario los aprueba tras la primera ejecución)
14. **Example app:**
    - `example/pubspec.yaml`
    - `example/lib/theme_switcher.dart`
    - `example/lib/sections/simple_widgets_section.dart`
    - `example/lib/sections/shows_section.dart`
    - `example/lib/showcase_screen.dart`
    - `example/lib/main.dart`
    - `example/README.md`
15. **Documentación:**
    - `README.md`
    - `CHANGELOG.md`
    - `MIGRATION.md`
    - `doc/theming_guide.md`
    - `doc/api_reference.md`
16. **Comandos de verificación** al final.

### Entre cada archivo de Fase 3

- Al terminar cada archivo, continúa directamente con el siguiente sin pedir confirmación, salvo que detectes un problema.
- Si el archivo que vas a generar depende de una decisión que el usuario aún no aprobó, **detente y pregunta**.

---

## 9 — Reglas operativas

- **No inventes APIs.** Si un detalle del legacy es ambiguo, pregunta en Fase 2 al recibir el archivo.
- **Mantén la idea visual original.** Los usuarios finales ya están acostumbrados a esta UI; optimiza la implementación, no la estética.
- **Cada cambio respecto al legacy se documenta** en el dartdoc del widget Y en `MIGRATION.md`.
- **No agregues widgets que no estén en el catálogo de §1.**
- **No uses comentarios `// TODO` ni código incompleto.** Si no puedes completar algo, pregunta.
- **Cero `print`, cero `debugPrint`** en código de producción del paquete.
- **Cero acceso a `BuildContext` después de async gaps** sin `mounted` check.
- **Cero singletons globales.** Las variables top-level mutables del legacy (`double height = 20;` en `widgets_shows.dart`) se convierten en **tokens del `IronWidgetsTheme`** o en parámetros opcionales con defaults tomados del theme.
- **Respeta la licencia de `flutter_custom_selector`** al vendorizarlo.

---

## 10 — Aclaraciones que probablemente pedirás al usuario en Fase 1

Estas son candidatas razonables a preguntar antes de empezar. Pregúntalas **al final de tu respuesta de Fase 1**, agrupadas y numeradas:

1. ¿El usuario quiere que `buildMaterialTheme()` del `IronWidgetsTheme` genere un `ColorScheme` usando `ColorScheme.fromSeed(seedColor: darkRed)` o construido manualmente para mantener `gold` como `secondary` exacto?
2. ¿El `Button` legacy era un `ElevatedButton`, `FilledButton.tonal`, o un wrapper con gradient gold-darkRed? El usuario lo confirmará al enviar `button.dart` o indicará si usar un default.
3. ¿El paquete `flutter_custom_selector` que el usuario enviará está en alguna versión específica o es el último código que usaban? Si es muy viejo, ¿aprobado modernizarlo significativamente?
4. En la example app, ¿prefiere el toggle de tema como `SegmentedButton` (Material 3), `ToggleButtons` (Material 2), o `DropdownMenu`?
5. ¿Quiere que la example app guarde la selección de tema en `SharedPreferences` entre sesiones, o es fine que se resetee en cada cold start?
6. ¿Añadimos `flutter_lints` o una versión más estricta como `very_good_analysis`?
7. ¿Se considera OK que `IronWidgetsTheme.defaults()` aplique `fontSize: 10` al `baseStyleValue` tal cual el legacy, aun sabiendo que 10px falla criterios A11y en algunos casos? Opción: duplicar el default a 12 y documentar la divergencia en `MIGRATION.md`.

## END PROMPT

---

## Apéndice — Notas para el operador humano del prompt

Esta sección NO va dentro del prompt; es para ti, que ejecutarás el prompt con el LLM.

### Cambios clave respecto a v1

| Aspecto | v1 | v2 |
|---|---|---|
| Código legacy | Inline en el prompt | Usuario lo inyecta archivo por archivo en Fase 2 |
| `flutter_custom_selector` | Reemplazado con `DropdownMenu` | Vendorizado dentro del paquete, modernizado |
| `app_colors.dart` | Mencionado tangencialmente | Primer archivo que se pide analizar |
| Theme | Tokens separados, tema opcional | `IronWidgetsTheme` como ThemeExtension + `IronWidgetsThemeScope` + `buildMaterialTheme()` |
| Example app | Toggle light/dark | Toggle de 3 estados (Iron default / Material light / Material dark) |
| Estructura | 8 pasos lineales | 3 fases (Plan → Ingesta → Generación) |

### Cómo alimentar los archivos al LLM

El LLM te pedirá los archivos en el orden de §2. Para cada archivo:

1. **Copia el contenido completo** del archivo legacy (no un resumen).
2. **Pégalo en bloque de código** con la ruta como header:

   ````markdown
   `lib/widgets_simples/label.dart`:

   ```dart
   [contenido completo]
   ```
   ````

3. **Espera el análisis del LLM** antes de enviar el siguiente.
4. Si el LLM pide un archivo que no tienes, dile "no existe como archivo separado; aquí va su uso inferido" y pégale los fragmentos donde se usa.

Para `flutter_custom_selector`, idealmente empaca los archivos del paquete original en un único mensaje en estructura clara:

```markdown
Paquete flutter_custom_selector:

`pubspec.yaml`:
```yaml
[...]
```

`lib/flutter_custom_selector.dart`:
```dart
[...]
```

`lib/widget/flutter_single_select.dart`:
```dart
[...]
```

(resto de archivos)

Fin del paquete flutter_custom_selector.
```

### Qué validar antes de aceptar el resultado

Comandos para correr tras recibir todos los archivos:

```bash
mkdir iron_widgets && cd iron_widgets
# Copiar los archivos generados según la estructura

flutter pub get
flutter analyze
flutter test
dart pub publish --dry-run
cd example && flutter pub get && flutter run -d chrome
```

Checks visuales en la example app:

- El toggle de tema cambia la apariencia de TODOS los widgets, no solo algunos.
- En modo "Iron default", los backgrounds amarillo-gold son visibles en `ShowValuesColumn`.
- En modo "Material light", los widgets se integran con el tema light del consumidor (colores del `colorScheme.primary`).
- En modo "Material dark", los textos no son negros sobre gold — el adapter detecta contraste y cambia el texto.

### Costos esperados

Con Claude 4.7 Opus o equivalente: ~200k-350k tokens output total (incluye código vendorizado modernizado + tests + example + docs). Tiempo: 15-40 minutos dependiendo de la cantidad de archivos que tenga `flutter_custom_selector` y de si el usuario responde rápido a las preguntas de Fase 1.

---

*Fin del documento.*
