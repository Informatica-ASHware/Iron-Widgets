# SPEC — Roadmap de ampliación `iron_widgets` (inspiración Finandy)

> **Estado (2026-07-11):** Fases 1–5 implementadas (US-2.01 … US-2.18) con tests,
> goldens, docs y secciones de ejemplo. Pendiente: release 1.1.0+ (bump de `pubspec`,
> `PR_JUSTIFICATION.md` y `scripts/check_integrity.py`).

> **Fecha:** 2026-07-11 · **Base:** v1.0.2 publicada en pub.dev · **Estado:** propuesta para aprobación
> **Regla marco:** ningún cambio rompe la API pública 1.x. Todo entra como *feature* aditiva (SemVer minor).

---

## 1 — Contexto y objetivo

El paquete cubre hoy 12 widgets (texto, formularios, selectores bottom-sheet y paneles `Show*`).
El ecosistema CryptBot necesita componentes de UI de trading equivalentes a los observados en Finandy
(ticker, badges direccionales, sliders de porcentaje, dropdowns de escritorio, etc.).

Este documento planifica **15 unidades de trabajo** agrupadas en 5 fases, ordenadas por decisión del
operador: **Fase 1 = Selectores en modo dropdown** (prioridad confirmada), luego por valor para trading.

---

## 2 — Prerrequisito transversal: tokens semánticos (US-2.01)

Tokens actuales: `darkRed`, `gold`, `darkGray`, 4 `TextStyle`, 5 dimensiones micro,
`valueBackground`, `borderAccent`, `dangerColor`, `neutralSurface`.

Faltan roles que los nuevos widgets consumen. Se agregan al `ThemeExtension` como **parámetros
opcionales con default** (el constructor actual es `const` con todo `required`; agregar campos
requeridos rompería a los consumidores):

| Token nuevo | Tipo | Default propuesto | Consumidores |
|---|---|---|---|
| `bullColor` | `Color` | `0xFF26A69A` (teal alcista) | DeltaBadge, PriceTicker, RangeBar, Sparkline, ActionButton |
| `bearColor` | `Color` | `0xFFEF5350` (rojo bajista) | ídem |
| `surfaceElevated` | `Color` | `darkGray` aclarado +8 % | Dropdown, Panel, Tabs, Tag |
| `cornerRadius` | `double` | `8.0` | Dropdown, Panel, ActionButton, Tag, Segmented |
| `overlayMaxHeight` | `double` | `320.0` | Dropdown |

Alcance US-2.01: campos + `copyWith` + `lerp` + dartdoc + tests de igualdad/lerp + `theming_guide.md`.
`dangerColor` existente se reutiliza; **no** se duplica con `bearColor` (semántica distinta:
peligro/acción destructiva vs. dirección de mercado).

---

## 3 — Mapa de fases

| Fase | Versión objetivo | Contenido | USs |
|---|---|---|---|
| 0 | 1.1.0 | Tokens semánticos | US-2.01 |
| 1 | 1.1.0 | Selectores modo dropdown (desktop-first) | US-2.02 · US-2.03 · US-2.04 |
| 2 | 1.2.0 | Indicadores de mercado | US-2.05 a US-2.08 |
| 3 | 1.3.0 | Entrada de órdenes | US-2.09 a US-2.12 |
| 4 | 1.4.0 | Posiciones y estado | US-2.13 a US-2.16 |
| 5 | 1.5.0 | Contenedores | US-2.17 · US-2.18 |

Numeración `US-2.XX` ajustable al tablero real. Ramas: `feature/US-2.XX` según `CLAUDE.md`.

---

## 4 — Fase 1 (detallada): selectores en modo dropdown

### 4.1 Análisis de las capturas de referencia (Finandy)

**Estado cerrado** (`Selector_dropdown_tipo_Finandy.png`):

- Trigger: rectángulo redondeado (~8 px), borde 1 px sutil gris-azulado, fondo = superficie oscura.
- Valor actual alineado a la izquierda; chevron `▾` a la derecha; altura ≈ 48 px desktop.
- El label del formulario vive **fuera** del campo (columna izquierda), como ya hacen los `Iron*`.

**Estado abierto** (`Selector_dropdown_tipo_Finandy_-_Opciones.png`):

- Panel **overlay anclado al trigger**: se superpone al contenido inferior, no lo desplaza.
- Borde fino discontinuo, esquinas redondeadas, mismo fondo elevado.
- Lista vertical sin divisores, filas ≈ 40-44 px, texto alineado a la izquierda.
- Ítem seleccionado: check `✓` a la derecha del texto (verde en Finandy → **gold** en Iron).
- Sin buscador ni botones Done/Cancel: tap en opción selecciona y cierra.
- Con 12 opciones el panel excede el alto disponible → requiere `maxHeight` + scroll interno.

### 4.2 Decisión de API

Se introduce un modo, no un widget paralelo, para no fragmentar la API:

```dart
enum IronSelectMode {
  bottomSheet, // comportamiento actual (default en 1.x)
  dropdown,    // overlay anclado, estilo Finandy
  adaptive,    // dropdown en desktop/web, bottomSheet en móvil táctil
}
```

- `IronSelect<T>`, `IronEnum<T>` e `IronMultiSelector<T>` reciben `this.mode = IronSelectMode.bottomSheet`.
- Default `bottomSheet` en 1.x para compatibilidad estricta; cambiar el default a `adaptive`
  queda anotado como candidato para 2.0.0.
- `adaptive` resuelve por `defaultTargetPlatform`: `macOS | windows | linux` → dropdown;
  `android | iOS | fuchsia` → bottomSheet.
- Parámetros nuevos opcionales: `menuMaxHeight` (default = token `overlayMaxHeight`),
  `menuWidth` (default = ancho del trigger), `searchable` (default `false`).
- `doneButtonText`/`cancelButtonText` no aplican en dropdown single-select (se documenta).

### 4.3 Infraestructura interna (US-2.02, núcleo)

Componente privado `IronDropdownOverlay<T>` en `lib/src/internal/`:

- `OverlayPortal` + `CompositedTransformTarget/Follower` (`LayerLink`) para anclaje.
- Posicionamiento: debajo del trigger; *flip* arriba si el espacio inferior < alto del menú.
- Cierre por: selección, tap fuera (`TapRegion`), `Esc`, pérdida de foco, scroll del ancestro.
- Teclado (desktop): `↑/↓` mueven foco, `Enter/Space` selecciona, `Home/End`, *typeahead* por prefijo.
- Semántica: trigger como botón con `expanded`; menú con roles de lista y opción seleccionada.
- Estados visuales del trigger: normal · hover (desktop) · focused (borde `gold`) · disabled.
- Estilo: fondo `surfaceElevated`, borde `borderAccent` 1 px, radio `cornerRadius`,
  check `gold` en el ítem activo, fila hover con `gold` al 12 % de opacidad.
- Sin dependencias nuevas: todo con Flutter SDK.

### 4.4 Distribución por US

| US | Alcance | Entregables clave |
|---|---|---|
| US-2.02 | Overlay interno + modo en `IronSelect<T>` | Infra completa, teclado, adaptive |
| US-2.03 | Modo en `IronEnum<T>` | Reuso de infra; paridad de API |
| US-2.04 | Modo en `IronMultiSelector<T>` | Filas con `IronCheck`, panel persiste abierto, fila "All", resumen en trigger (`n seleccionados`), apply inmediato |

### 4.5 Plan de pruebas Fase 1

- **Unit:** resolución de modo adaptive por plataforma; lógica de selección multi (toggle, All).
- **Widget:** abre/cierra overlay; tap fuera; `Esc`; navegación de teclado; flip vertical con
  espacio insuficiente; `onChanged` dispara con el valor correcto; disabled no abre.
- **Golden:** trigger cerrado (normal/hover/focused/disabled) y menú abierto, single y multi,
  con tema default y con `copyWith` de contraste.

### 4.6 Documentación Fase 1

`api_reference.md` (sección modos), `theming_guide.md` (tokens nuevos), página en `example/`,
`CHANGELOG.md → [Unreleased]`, `MIGRATION.md` (nota: sin migración requerida).

---

## 5 — Fases 2–5: especificación resumida

Complejidad: S (≤½ día), M (1 día), L (2+ días). Todos consumen `IronWidgetsTheme` con fallback
a `defaults()` y exponen `semanticLabel`.

### Fase 2 — Indicadores de mercado (v1.2.0)

| US | Widget | API esencial | Tokens | Notas técnicas | Cx |
|---|---|---|---|---|---|
| US-2.05 | `IronDeltaBadge` | `value` (double %), `precision`, `showSign` | bull/bear, cornerRadius | Pill; color por signo; cero = neutral | S |
| US-2.06 | `IronPriceTicker` | `price`, `previous?`, `precision`, `flashDuration` | bull/bear, baseStyleValue | Flash animado al cambiar; `RepaintBoundary`; sin timers en build | M |
| US-2.07 | `IronCountdown` | `until` (DateTime) o `remaining`, `onFinished?`, `format` | baseStyleValue, dangerColor (<10 %) | `Ticker` de `TickerProviderStateMixin`; pausable | M |
| US-2.08 | `IronSparkline` | `values`, `strokeWidth`, `positiveIsBull` | bull/bear | `CustomPainter`; downsampling si >200 puntos; complementa AshCandleChart, no lo reemplaza | M |

### Fase 3 — Entrada de órdenes (v1.3.0)

| US | Widget | API esencial | Tokens | Notas técnicas | Cx |
|---|---|---|---|---|---|
| US-2.09 | `IronSegmented<T>` | `segments`, `value`, `onChanged`, `itemAsString` | gold, surfaceElevated, cornerRadius | Sustituye pares LARGO/CORTO, filtros PNL, L/F/M/S/T | M |
| US-2.10 | `IronPercentSlider` | `value`, `onChanged`, `presets: [10,25,50,75,97]`, `editable` | gold, bull/bear opc. | Slider + chips preset + `IronMicroEditor` acoplado | M |
| US-2.11 | `IronStepper` | `value`, `step`, `min/max`, `onChanged`, `precision` | tokens micro | `IronMicroEditor` + botones ± con repeat-on-hold | S |
| US-2.12 | `IronActionButton` | `label`, `onPressed`, `variant: {primary, success, danger}`, `sublabel?` | bull/bear/gold, cornerRadius | CTA grande tipo "Agregar SHORT"; estado loading opc. | S |

### Fase 4 — Posiciones y estado (v1.4.0)

| US | Widget | API esencial | Tokens | Notas técnicas | Cx |
|---|---|---|---|---|---|
| US-2.13 | `IronTag` | `text`, `variant: {gold, bull, bear, neutral}` | todos los semánticos | Chip mini (SHORT, Isol ×20, PERP) | S |
| US-2.14 | `IronRangeBar` | `min` (SL), `max` (TP), `current`, `entry?` | bull/bear/gold | `CustomPainter`; marcador de posición; labels opc. | M |
| US-2.15 | `IronGauge` | `value 0..1`, `label?`, `thresholds?` | gold, dangerColor | Arco estilo *arc reactor*; `CustomPainter`; el más temático | L |
| US-2.16 | `ShowGrid` | `items: List<ShowItem>`, `columns` | familia Show | Cabecera de stats (Volumen/Máx/Mín/Financiación); reusa `Show` | S |

### Fase 5 — Contenedores (v1.5.0)

| US | Widget | API esencial | Tokens | Notas técnicas | Cx |
|---|---|---|---|---|---|
| US-2.17 | `IronPanel` | `title`, `child`, `trailing?`, `collapsible` | gold, surfaceElevated, cornerRadius | Card con header dorado (Ajustes/Activos) | M |
| US-2.18 | `IronTabs` | `tabs`, `index`, `onChanged` | gold, surfaceElevated | Tabs compactas (Orden/SL/SLX/TP); indicador dorado | M |

---

## 6 — Decisiones y riesgos

1. **Cero dependencias nuevas.** Sparkline, gauge y range-bar se implementan con `CustomPainter`
   (regla *Stale Package* y peso del paquete).
2. **Compatibilidad de constructor del tema.** Los tokens nuevos entran como opcionales con
   default; `lerp` y `==`/`hashCode` (si aplica) se actualizan en la misma US-2.01.
3. **Animaciones** (`PriceTicker`, `Countdown`): prohibido `Timer.periodic` suelto; usar
   `Ticker`/`AnimationController` con `dispose` correcto. Golden tests con `pump` determinista.
4. **Adaptive y web:** en web no se distingue táctil/puntero por plataforma; `adaptive` en web
   usa dropdown (criterio: web se consume mayormente en desktop). Documentado en dartdoc.
5. **Riesgo de scope en US-2.02:** el overlay (posicionamiento, teclado, foco) concentra la
   complejidad; US-2.03/04 son delgadas por diseño para amortizarlo.

---

## 7 — Definition of Done (por US, según `CLAUDE.md`)

1. `dart analyze` sin advertencias · 2. Unit + golden tests · 3. Dartdoc en todo lo público ·
4. Inmutabilidad (`final`, `copyWith`) · 5. `double` estricto en numéricos ·
6. Verificado en macOS desktop + móvil · 7. `CHANGELOG.md → [Unreleased]` ·
8. `scripts/check_integrity.py` si se toca `pubspec`/CI.

---

## 8 — Orden de ejecución propuesto

```
US-2.01 → US-2.02 → US-2.03 → US-2.04   (release 1.1.0)
US-2.05 → US-2.06 → US-2.07 → US-2.08   (release 1.2.0)
US-2.09 → US-2.12 → US-2.10 → US-2.11   (release 1.3.0)
US-2.13 → US-2.16 → US-2.14 → US-2.15   (release 1.4.0)
US-2.17 → US-2.18                        (release 1.5.0)
```
