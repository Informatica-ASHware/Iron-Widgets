# Prompt para LLM — Crear paquete Flutter `iron_widgets`

> **Cómo usar este prompt:** copia todo el contenido entre `BEGIN PROMPT` y `END PROMPT` y pégalo en una sesión nueva con el LLM de codificación de tu elección (Claude Code, Cursor, Aider, Codex, etc.). El prompt es self-contained: incluye el código fuente legacy completo de cada widget a portar, los criterios de aceptación, las invariantes arquitectónicas y el plan de salida esperado.

---

## BEGIN PROMPT

Eres un Senior Flutter Package Author. Tu tarea es crear desde cero un paquete Flutter publicable en pub.dev llamado **`iron_widgets`**, basado en widgets legacy de un proyecto pre-LLM (2023). El paquete debe estar listo para que un equipo lo importe y lo use sin fricción.

---

## 0 — Contexto del entregable

**Nombre del paquete:** `iron_widgets`
**Identificador en pubspec:** `iron_widgets`
**Dart SDK constraint:** `>=3.11.0 <4.0.0`
**Flutter SDK constraint:** `>=3.41.0`
**Tipo:** package (no plugin, no app — solo widgets reutilizables).
**Plataformas declaradas:** android, ios, macos, windows, linux, web.
**Licencia:** MIT (incluir `LICENSE` en raíz).
**Publicable en pub.dev:** sí. Apuntar a pana score ≥ 130.
**Dependencias rígidas que NO debes incluir:** Riverpod, Provider, BLoC, GetX, get_it, Firebase, ningún provider de state management. Los widgets deben ser stateless o stateful clásicos consumibles desde cualquier arquitectura.
**Dependencias permitidas:** únicamente `flutter/material` y `flutter/foundation`. Si para un widget concreto necesitas una librería externa (ej. para un selector multi-valor), proponla como **dependencia opcional argumentada** y espera confirmación; no la añadas por iniciativa propia.

---

## 1 — Catálogo de widgets a portar

Debes portar **exactamente esta lista**, manteniendo cada nombre de clase/función con su capitalización original. La estructura del paquete se reorganiza pero los nombres públicos no.

### Grupo A — Widgets simples (de `lib/widgets_simples/*`)

| Nombre original | Tipo | Notas de uso original |
|---|---|---|
| `Label` | StatefulWidget | Etiqueta estilizada, opcional dos puntos al final. |
| `MiniText` | StatefulWidget | Texto compacto con auto-alineación derecha si comienza con dígito. |
| `Editor` | StatefulWidget | Campo de texto con label inline o label-on-top, multi-línea opcional, modo password. |
| `Enum<T>` | StatefulWidget genérico | Selector de un valor entre opciones de tipo arbitrario T. Usaba `flutter_custom_selector` legacy. |
| `WMicroSwitch` | StatefulWidget | Toggle compacto con label, tooltip opcional (`message`), tamaños configurables. |
| `WMicroEditor` | StatefulWidget | Versión micro del Editor, para uso embebido en filas densas. |
| `Select<T>` | StatefulWidget genérico | Dropdown estándar de un único valor. |
| `Check` | StatefulWidget | Checkbox con label horizontal. |
| `MultiSelector<T>` | StatefulWidget genérico | Selector multi-valor con chips. |
| `Button` | StatefulWidget | Botón estilizado consistente con el sistema. |

### Grupo B — Widgets de visualización tabular (de `lib/make_real/widgets/widgets_shows.dart`)

Originalmente eran funciones top-level. **Refactoríalas a clases Widget** manteniendo el nombre original donde sea posible:

| Nombre original | Tipo nuevo | Nombre nuevo (manteniendo la idea) |
|---|---|---|
| `show(...)` (función) | StatelessWidget | `Show` |
| `showValuesColumn(...)` (función) | StatelessWidget | `ShowValuesColumn` |
| `showPercColumn(...)` (función) | StatelessWidget | `ShowPercColumn` |
| Constantes `baseStyleValue`, `baseStyleLabel`, `baseStyleTitle`, `baseStylePercent` | static const en `IronStyles` | Mantener nombres como `IronStyles.baseStyleValue` etc. |

---

## 2 — Código fuente legacy completo

Aquí están los archivos legacy completos que debes analizar antes de escribir cualquier línea. Léelos con atención: cada decisión de UI (paddings, márgenes, fontSize, alineaciones, comportamiento) debe preservarse salvo donde explícitamente se indique mejorar.

### Archivo: `lib/widgets_simples/label.dart`

```dart
import 'package:flutter/material.dart';

class Label extends StatefulWidget {
  const Label(
    this.text, {
    this.width,
    this.colon = true,
    Key? key,
  }) : super(key: key);

  final String text;
  final double? width;
  final bool colon;

  @override
  State<Label> createState() => _LabelState();
}

class _LabelState extends State<Label> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: widget.width,
      child: Text(
        '${widget.text}${widget.colon ? ':' : ''}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
```

### Archivo: `lib/widgets_simples/mini_text.dart`

```dart
import 'package:flutter/material.dart';

class MiniText extends StatefulWidget {
  const MiniText(
    this.text, {
    this.width,
    this.margin,
    this.fontSize,
    this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final double? width;
  final double? margin;
  final double? fontSize;
  final Color? color;

  @override
  State<MiniText> createState() => _MiniTextState();
}

class _MiniTextState extends State<MiniText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: widget.margin == null ? null : EdgeInsets.all(widget.margin!),
      child: Text(
        widget.text,
        style: TextStyle(fontSize: widget.fontSize ?? 10, color: widget.color),
        textAlign: widget.text.isEmpty
            ? TextAlign.left
            : '-1023456789'.contains(widget.text[0])
                ? TextAlign.right
                : TextAlign.left,
      ),
    );
  }
}
```

### Archivo: `lib/widgets_simples/editor.dart`

```dart
import 'package:flutter/material.dart';
import 'label.dart';

class Editor extends StatefulWidget {
  const Editor(
    this.label,
    this.text,
    this.callback, {
    this.width = 240,
    this.lines = 1,
    Key? key,
    this.password = false,
    this.labelOnTop = false,
  }) : super(key: key);

  final String label;
  final String text;
  final Function(String) callback;
  final double width;
  final int lines;
  final bool password;
  final bool labelOnTop;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  TextEditingController controller = TextEditingController();

  void listener() {
    widget.callback(controller.text);
  }

  @override
  void initState() {
    controller.text = widget.text;
    controller.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Label(widget.label),
      Container(
        width: widget.width,
        height: widget.lines == 1 ? 30 : widget.lines * 15,
        margin: EdgeInsets.zero,
        child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
            ),
            maxLines: widget.lines,
            obscureText: widget.password,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
    ];
    return Container(
      width: widget.width,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: (widget.lines == 1 ? 40 : (widget.lines * 18)) +
          (widget.labelOnTop ? 20 : 0),
      child: widget.labelOnTop
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
    );
  }
}
```

### Archivo: `lib/widgets_simples/enum.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_custom_selector/widget/flutter_single_select.dart';

class Enum<T> extends StatefulWidget {
  const Enum(this.title, this.label, this.value, this.options, this.callback,
      {this.height = 30, this.width = 200, Key? key})
      : super(key: key);

  final String title;
  final String label;
  final T value;
  final List<T> options;
  final Function(T) callback;
  final double height;
  final double width;

  @override
  State<Enum<T>> createState() => _EnumState<T>();
}

class _EnumState<T> extends State<Enum<T>> {
  late T _value;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: widget.height,
      width: widget.width,
      child: CustomSingleSelectField<T>(
        items: widget.options,
        title: widget.title,
        initialValue: _value,
        onSelectionDone: (value) {
          setState(() {
            _value = value;
          });
          widget.callback(value);
        },
        itemAsString: (item) => item,
      ),
    );
  }
}
```

> **Nota:** la dependencia `flutter_custom_selector` está abandonada. **Reemplázala con un selector implementado con widgets nativos de Material 3** (`DropdownMenu` o `MenuAnchor`) preservando la API pública (`title`, `label`, `value`, `options`, `callback`, `height`, `width`).

### Archivo: `lib/widgets_simples/w_micro_switch.dart` (reconstruido a partir de uso)

El archivo fuente directo no estaba disponible en el dump, pero se infiere a partir de su uso intensivo:

```dart
// Firma de uso documentada en el código legacy:
// WMicroSwitch(
//   String label,
//   bool value,
//   void Function(bool) onChanged, {
//   String? message,           // tooltip
//   double width = 80,
//   double height = 16,
// })
//
// Comportamiento: switch compacto horizontal con label visible.
// Cuando se hace tap, dispara onChanged(!value).
// Si message != null, muestra Tooltip al hover/long-press.
// Cuando value == true, fondo en color primario; si value == false, fondo gris.
// La altura es muy baja (14-20px) y se usa en filas densas.
```

Reconstrúyelo respetando esa firma exacta.

### Archivo: `lib/widgets_simples/w_micro_editor.dart` (reconstruido a partir de uso)

```dart
// Firma de uso documentada:
// WMicroEditor({
//   required String label,
//   required String value,
//   required void Function(String) onChanged,
//   double width = 40,
//   double height = 14,
// })
//
// Comportamiento: campo de texto compacto inline, sin border decoration pesada,
// fontSize ~10. Pensado para edición de valores numéricos en filas densas.
// onChanged se dispara en cada cambio del controller.
```

Reconstrúyelo respetando esa firma exacta.

### Archivo: `lib/make_real/widgets/widgets_shows.dart`

```dart
import 'package:cryptbotmultirealfutures/widgets_simples/w_micro_editor.dart';
import 'package:flutter/material.dart';
import '../../app_colors.dart';  // gold = Color(0xFFFFD700) aproximadamente

double height = 20;
double fontSize = 10;
TextStyle baseStylePercent = const TextStyle(
  color: Colors.black,
  fontSize: 10,
  overflow: TextOverflow.fade,
);
TextStyle baseStyleValue = const TextStyle(
  color: Colors.black,
  fontSize: 10,
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.fade,
);
TextStyle baseStyleLabel = const TextStyle(
  color: Colors.black,
  fontSize: 10,
  fontWeight: FontWeight.bold,
  overflow: TextOverflow.fade,
);
TextStyle baseStyleTitle = const TextStyle(
  color: Colors.black,
  fontSize: 12,
  overflow: TextOverflow.fade,
);
double widthInt = 20;
double widthValue = 60;
double widthPercent = 60;

show(
  String l,
  String v,
  double width,
  TextStyle styleLabel,
  TextStyle styleValue, {
  bool editable = false,
  Function(String)? callback,
}) {
  Widget value = Text(
    v,
    style: styleValue,
  );
  if (editable) {
    value = WMicroEditor(
      label: '',
      onChanged: callback ?? (value) {},
      value: v,
      width: 40,
      height: 14,
    );
  }
  return Container(
    width: width,
    height: height,
    color: Colors.white,
    margin: const EdgeInsets.all(2),
    padding: const EdgeInsets.all(1),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l,
          style: styleLabel,
        ),
        value,
      ],
    ),
  );
}

Widget showValuesColumn(
  String l1,
  String v1,
  String l2,
  String v2,
  double width,
  TextStyle styleLabel,
  TextStyle styleValue, {
  Color? background,
  bool editable = false,
  Function(String)? editableTop,
  Function(String)? editableBottom,
}) {
  return Container(
    color: background ?? gold,
    child: Column(
      children: [
        show(l1, v1, width, styleLabel, styleValue,
            editable: editable, callback: editableTop),
        show(l2, v2, width, styleLabel, styleValue,
            editable: editable, callback: editableBottom),
      ],
    ),
  );
}

Widget showPercColumn(
  String l1,
  String v1,
  String l2,
  String v2,
  double width,
  TextStyle styleLabel,
  TextStyle stylePercent, {
  Color? background,
  bool editable = false,
  Function(String)? editableTop,
  Function(String)? editableBottom,
}) {
  return Container(
    color: background ?? gold,
    child: Column(
      children: [
        show(l1, '$v1%', width, styleLabel, stylePercent,
            editable: editable, callback: editableTop),
        show(l2, '$v2%', width, styleLabel, stylePercent,
            editable: editable, callback: editableBottom),
      ],
    ),
  );
}
```

### Sobre `Select<T>`, `Check`, `MultiSelector<T>`, `Button`

Los archivos fuente directos no están disponibles, pero su uso queda claro:

```dart
// Select<T>(
//   String title, String label, T value, List<T> options,
//   void Function(T) callback,
// ) — dropdown de un valor.
//
// Check(
//   String label, bool value, void Function(bool) callback,
//   {double width = ...},
// ) — checkbox horizontal con label.
//
// MultiSelector<T>(
//   String title, String label, List<T> selected, List<T> options,
//   void Function(List<T>) callback,
// ) — chips multiselect.
//
// Button(label, onPressed, {...}) — botón estilizado.
```

Recuperar la idea desde estos usos: una API posicional simple (label/value/options/callback) consistente con el resto del catálogo. Si decides que algún parámetro debería ser nombrado en vez de posicional para 2026 (ej. `callback` siempre nombrado como `onChanged`), documenta esa decisión en `MIGRATION.md` y mantén compatibilidad con un alias deprecado durante una versión.

---

## 3 — Reglas de modernización (Flutter 3.41 / Dart 3.11, abril 2026)

Aplica estas reglas **a cada widget portado**, sin excepción:

### 3.1 Sintaxis y APIs
- Usa `super.key` en lugar de `Key? key, super(key: key)`.
- Reemplaza `StatefulWidget` por `StatelessWidget` cuando el legacy no necesitaba estado real (caso de `Label`, `MiniText`, `Show`, `ShowValuesColumn`, `ShowPercColumn`). El legacy declaró muchos como `StatefulWidget` por inercia; corrígelo.
- Tipa las callbacks con `ValueChanged<T>` o `void Function(T)` consistente; nada de `Function(T)` sin retorno explícito.
- Elimina el patrón legacy `controller.addListener(...)` en `Editor` si puedes resolverlo con `onChanged` directo; si necesitas mantener el controller (para programmatic updates), expón `TextEditingController? controller` opcional como en TextField idiomático.
- Usa `Widget? child` o builder patterns donde aporten composabilidad.
- Aplica `const` donde sea posible (constructores, hijos, paddings, EdgeInsets).
- Reemplaza `Container` por widgets más específicos (`Padding`, `SizedBox`, `DecoratedBox`, `ColoredBox`) cuando aporten claridad o eviten reconstrucción innecesaria.

### 3.2 Theming
- **Cero colores hardcodeados como default**. Usa `Theme.of(context).colorScheme.primary`, `.surface`, `.onSurface`, etc.
- El color `gold` legacy del background de `ShowValuesColumn` se mantiene como **default** de un parámetro nombrado `background`, pero el consumidor puede sobrescribirlo. Define `IronColors.gold = Color(0xFFFFD700)` como token.
- Soporta dark mode automáticamente (los textos negros legacy se vuelven `colorScheme.onSurface`).
- Define un `IronWidgetsTheme` extension de `ThemeExtension` que el consumidor pueda inyectar para customizar globalmente sin tocar cada widget.

### 3.3 Accesibilidad
- Todos los widgets interactivos exponen `Semantics` con `label` apropiado.
- `WMicroSwitch` usa `Switch.adaptive` interno o equivalente accesible; expone `semanticLabel`.
- `Editor`, `WMicroEditor` exponen `semanticLabel` y respetan `enabled`.
- Validar contraste AA en los colores default (especialmente texto negro sobre `gold`).

### 3.4 Internacionalización
- Cero strings hardcodeados en inglés/español dentro de los widgets. El consumidor pasa todos los textos.
- Usa `Directionality.of(context)` para soportar RTL en widgets con orientación.

### 3.5 Performance
- Los widgets que no necesiten estado son `StatelessWidget`.
- `const` constructors agresivamente.
- Evita rebuilds innecesarios: si un parámetro no cambia, no repintes.
- Para `Editor`, debounce opcional del `onChanged` con parámetro `debounce: Duration?`.

### 3.6 Lints
Incluye `analysis_options.yaml` con:
- `package:flutter_lints/flutter.yaml` como base.
- Reglas adicionales: `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `require_trailing_commas`, `sort_constructors_first`, `unnecessary_lambdas`, `prefer_single_quotes`, `use_super_parameters`.
- Configura `analyzer.errors.unused_import: error`.

### 3.7 Compatibilidad con Material 2 y Material 3
- Los widgets deben funcionar bien con `useMaterial3: true` y `useMaterial3: false`. Prueba ambos en los goldens.

---

## 4 — Estructura de archivos requerida

Crea exactamente esta estructura:

```
iron_widgets/
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
├── LICENSE                              (MIT)
├── analysis_options.yaml
├── .gitignore
├── lib/
│   ├── iron_widgets.dart                (barrel export — único entry point público)
│   └── src/
│       ├── theme/
│       │   ├── iron_colors.dart         (gold y otros tokens)
│       │   ├── iron_styles.dart         (baseStyleValue, baseStyleLabel, etc. como statics)
│       │   └── iron_widgets_theme.dart  (ThemeExtension)
│       ├── simple/
│       │   ├── label.dart               (Label)
│       │   ├── mini_text.dart           (MiniText)
│       │   ├── editor.dart              (Editor)
│       │   ├── enum.dart                (Enum<T>)
│       │   ├── select.dart              (Select<T>)
│       │   ├── check.dart               (Check)
│       │   ├── multi_selector.dart      (MultiSelector<T>)
│       │   ├── button.dart              (Button)
│       │   ├── w_micro_switch.dart      (WMicroSwitch)
│       │   └── w_micro_editor.dart      (WMicroEditor)
│       └── shows/
│           └── shows.dart               (Show, ShowValuesColumn, ShowPercColumn)
├── test/
│   ├── widget_test.dart                 (smoke tests por widget)
│   ├── golden_test.dart                 (goldens light + dark + M2/M3)
│   └── goldens/                         (imágenes de referencia)
├── example/
│   ├── pubspec.yaml
│   ├── lib/
│   │   └── main.dart                    (showcase de TODOS los widgets)
│   └── README.md
└── doc/
    ├── api_reference.md
    └── migration_from_legacy.md
```

---

## 5 — Criterios de aceptación (definition of done)

Tu trabajo está completo cuando:

1. **`flutter pub get` corre limpio** sin warnings.
2. **`flutter analyze` devuelve 0 issues.**
3. **`flutter test` pasa al 100%**, incluyendo los goldens.
4. **`dart pub publish --dry-run` no emite warnings.**
5. **`flutter pub publish --dry-run` simula publicación exitosa.**
6. **El `example/` corre en `flutter run -d chrome` y muestra TODOS los widgets en una scrollable showcase**, con secciones por categoría (Simples / Shows), toggle light/dark, toggle M2/M3.
7. **Cada widget tiene Dartdoc completo** con: descripción, parámetros, ejemplo mínimo de uso (snippet `dart`), nota sobre cambios respecto al legacy si los hubo.
8. **`README.md`** con: badges (pub version, license, Flutter), tabla del catálogo de widgets, screenshot/GIF del example app, quick start de 10 líneas, link al `MIGRATION.md`.
9. **`CHANGELOG.md`** con la entrada `## 0.1.0 - 2026-04-22` listando cada widget portado.
10. **`MIGRATION.md`** documentando: cambios de tipo (StatefulWidget → StatelessWidget), funciones convertidas a Widgets (show → Show, etc.), API breaking changes respecto al legacy con alternativas, removal de dependencia `flutter_custom_selector` y reemplazo por DropdownMenu.

---

## 6 — Plan de salida esperado (cómo debes responder)

Responde estructurado en este orden:

### Paso 1: Plan
Lista de 5-10 bullets describiendo tu enfoque antes de generar código. No empieces a codear si tu plan tiene huecos — pídeme aclaraciones.

### Paso 2: pubspec.yaml + analysis_options.yaml
Genera los dos archivos de configuración primero. Confirma que las dependencias son mínimas.

### Paso 3: Theme tokens
Genera los tres archivos de `lib/src/theme/` (`iron_colors.dart`, `iron_styles.dart`, `iron_widgets_theme.dart`). Estos son la base sobre la que el resto se apoya.

### Paso 4: Widgets simples (uno por archivo, en este orden)
Genera cada archivo de `lib/src/simple/` en este orden de dependencia:
1. `mini_text.dart`
2. `label.dart`
3. `button.dart`
4. `check.dart`
5. `w_micro_switch.dart`
6. `w_micro_editor.dart`
7. `editor.dart` (depende de Label)
8. `select.dart`
9. `enum.dart` (después de migrar de flutter_custom_selector)
10. `multi_selector.dart`

### Paso 5: Widgets de show
Genera `lib/src/shows/shows.dart` con `Show`, `ShowValuesColumn`, `ShowPercColumn` como StatelessWidget classes.

### Paso 6: Barrel export
Genera `lib/iron_widgets.dart` exportando solo la API pública. Marca como privado (`src/`) todo lo que no debería ser importado directamente.

### Paso 7: Tests
Genera `test/widget_test.dart` con un smoke test por widget (`testWidgets` que verifique que el widget renderiza sin crash con sus parámetros mínimos) y `test/golden_test.dart` con goldens para light/dark.

### Paso 8: Example app
Genera `example/lib/main.dart` con un showcase scrollable, agrupado por categorías, con switch para alternar light/dark y M2/M3.

### Paso 9: Documentación
Genera `README.md`, `CHANGELOG.md`, `MIGRATION.md`, `LICENSE` (MIT), y `doc/api_reference.md`.

### Paso 10: Verificación final
Lista los comandos que el desarrollador debe correr para validar:
```
flutter pub get
flutter analyze
flutter test
dart pub publish --dry-run
cd example && flutter run -d chrome
```
Y describe qué debe ver en cada uno.

---

## 7 — Reglas operativas

- **No inventes APIs.** Si un detalle del legacy es ambiguo, pregunta antes de codear.
- **Mantén la idea visual original.** El usuario ya está acostumbrado a esta UI; no la rediseñes. Optimiza la implementación, no la estética.
- **Cada cambio respecto al legacy se documenta** en el dartdoc del widget Y en `MIGRATION.md`.
- **No agregues widgets que no estén en el catálogo de §1.** Si crees que falta algo evidente (ej. un `Spacer` custom), propónlo y espera confirmación.
- **No uses comentarios `// TODO` ni código incompleto.** Si no puedes completar algo, dilo explícitamente y para.
- **Cero `print`, cero `debugPrint` en código de producción** del paquete.
- **Cero acceso a `BuildContext` después de async gaps** sin `mounted` check.
- **Cero singletons globales.** Si el legacy tenía variables globales mutables (`double height = 20;` en `widgets_shows.dart`), conviértelas a parámetros opcionales con defaults sensatos.

---

## 8 — Aclaraciones que probablemente necesites pedirme antes de empezar

Si alguna de estas preguntas te bloquea, **pregúntalas al inicio del Paso 1** en lugar de adivinar:

1. **`Button` legacy:** ¿quiero un `ElevatedButton`, `FilledButton.tonal`, o un wrapper más estilizado? Sugiere y espera mi decisión.
2. **`MultiSelector<T>` rendering:** ¿chips dentro de un `Wrap`, lista vertical con checkboxes, bottom sheet selector, o adaptable? Sugiere.
3. **`Enum<T>`/`Select<T>` con tipos no-string:** ¿cómo serializar a UI para el display? Acepta un parámetro opcional `String Function(T)? itemAsString` con fallback a `.toString()`. Confirma esta política.
4. **Color `gold` exacto:** el legacy usaba `gold = ?`. Asume `Color(0xFFFFD700)` salvo que indique otro. Confirma.
5. **Behavior de `Editor` cuando `text` cambia desde fuera por el padre:** ¿el controller debe sincronizarse o ignorar? La práctica idiomática es ignorar (controlled component) salvo que recibas `controller` explícito. Confirma.

## END PROMPT

---

## Apéndice — Notas para el operador humano del prompt

Esta sección NO va dentro del prompt; es para ti que vas a ejecutarlo.

### Por qué este prompt está estructurado así

1. **Self-contained con código real.** El LLM no tiene que adivinar comportamiento; ve el código fuente legacy in-line. Esto reduce alucinaciones a casi cero en widgets simples.

2. **Plan-first.** El paso 1 obliga al LLM a pensar antes de codear. Si el plan tiene huecos, los detectas en 30 segundos en vez de tras 2000 líneas generadas.

3. **Orden de dependencia explícito.** El Paso 4 numera los archivos en orden topológico (`Label` antes de `Editor` porque Editor importa Label). Esto evita que el LLM genere imports rotos.

4. **Criterios de aceptación binarios.** Cada item de §5 es verificable con un comando concreto. No hay subjetividad — el código pasa o no.

5. **Pregunta antes de inventar.** §8 pre-formula las decisiones controvertidas para que el LLM no arranque con suposiciones erradas.

### Cómo verificar la salida del LLM

Tras recibir todos los pasos, antes de aceptar:

```bash
# Crea el directorio del paquete
mkdir iron_widgets && cd iron_widgets

# Copia/escribe los archivos generados según la estructura del Paso 4

# Verifica
flutter pub get
flutter analyze
flutter test
dart pub publish --dry-run
cd example && flutter pub get && flutter run -d chrome
```

Si cualquiera de los 5 comandos falla, devuelve el error exacto al LLM y pídele corrección dirigida (no un rewrite completo).

### Cómo iterar

Después del primer pase, considera estos prompts de seguimiento:

- *"Añade screenshots automatizados al README usando `golden_toolkit`."*
- *"Migra `Editor` para soportar `TextEditingController` opcional como en el TextField idiomático."*
- *"Añade `tearDown` en widget tests que verifique que no quedan timers ni listeners pendientes."*
- *"Configura GitHub Actions con job de `flutter analyze` + `flutter test` + `dart pub publish --dry-run`."*

### Costos esperados

Un LLM moderno (Claude 4.7 Opus, GPT-5, etc.) debería completar este prompt en una sola ejecución consumiendo ~80k-150k tokens output, dependiendo de la verbosidad de los goldens y la documentación. Tiempo de pared: 5-15 minutos.

---

*Fin del documento.*
