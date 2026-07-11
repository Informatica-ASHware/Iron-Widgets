# SPEC — Plan de release `iron_widgets` 1.1.0

> **Fecha:** 2026-07-11 · **Rama de trabajo:** `new-widgets-july26` · **Estado:** propuesta para aprobación
> **Alcance:** consolidar las fases 1–5 del `SPEC_WIDGETS_ROADMAP` (US-2.01…US-2.18) y los fixes
> de overflow/tests en un único release minor.

---

## 1 — Estado real verificado (2026-07-11)

| Fuente | Hallazgo |
|---|---|
| **pub.dev** (`/api/packages/iron_widgets`) | Publicado: `1.0.0`, `1.0.1`, `1.0.2` · **latest = 1.0.2** |
| **GitHub tags** | Solo `v0.1.0` (vestigio previo a la publicación en pub.dev; los tags nunca acompañaron 1.0.x) |
| **GitHub Releases** | Ninguno |
| **`pubspec.yaml`** | `version: 1.0.2` en la rama default y en `new-widgets-july26` |
| **Rama `new-widgets-july26`** | Contiene todo el trabajo del roadmap + fixes (verificado: `docs/specs/SPEC_WIDGETS_ROADMAP.md` y `test/flutter_test_config.dart` responden 200; en `main`/`master`, 404) |
| **Suite** | 164/164 en Linux 3.41.7 (toolchain del CI); en macOS del owner con `fvm stable`: 133 lógicos verdes + goldens dentro de la tolerancia del 5 % |

## 2 — Decisión de versión

- **`0.2.0` — inviable.** pub.dev rechaza cualquier versión ≤ `1.0.2` ya publicada. El tag
  `v0.1.0` no representa el estado del paquete; la línea 1.0.x es la real.
- **`1.1.0` — recomendada.** Todo el roadmap entró como *feature aditiva* (parámetros opcionales
  con default, widgets nuevos, tokens nuevos con default): SemVer minor. Los fixes de overflow
  cambian el **render** de `Show`/`IronEditor`/`IronCheck` (celdas que crecen, campo que flexiona,
  label que escala) pero **no rompen ninguna firma**; corrigen defectos visibles (franjas
  amarillas), y los defectos se corrigen en minors. Nota de upgrade obligatoria en el CHANGELOG.
- **`2.0.0` — solo si** el owner considera el re-dimensionado de `Show`/`IronEditor` un cambio de
  contrato visual que exige *opt-in* (con `^1.0.2`, los consumidores reciben 1.1.0
  automáticamente). Dado que el consumidor principal (CryptBot) es del mismo owner y controla su
  upgrade, no se justifica el costo de señalizar *breaking*.

**Decisión propuesta: `1.1.0`.**

## 3 — Precondiciones (checklist)

- [x] Suite 164/164 con analyze y format limpios en los archivos del roadmap.
- [x] Example verificado en macOS (`flutter run -d macos`) y guardia anti-overflow (360/800/1280).
- [x] Goldens con tolerancia multi-plataforma (5 %) validada en ambas direcciones.
- [ ] Aprobación de la versión `1.1.0` por el owner.

## 4 — Pasos de ejecución (sobre `new-widgets-july26`)

1. **Commit de estilo repo-wide** *(mitiga el riesgo §6.1)*:
   `dart format .` → commit `style: formatear repo completo con dart format 3.41.7 (pin del CI)`.
   Sin cambios de lógica; alinea los archivos legados con el formatter *tall-style* que exige
   `ci.yml` (`--set-exit-if-changed .`).
2. **Bump y consolidación**:
   - `pubspec.yaml`: `version: 1.0.2` → `1.1.0`.
   - `CHANGELOG.md`: renombrar `## [Unreleased]` → `## 1.1.0 - <fecha del release>` conservando
     `### Fixed` / `### Added`, y añadir al inicio la **nota de upgrade** (cambio de render en
     `Show`/`IronEditor`/`IronCheck`).
   - `README.md`: revisar badge/refencias de versión si las hay.
3. **`PR_JUSTIFICATION.md`** desde `PR_JUSTIFICATION.md.example` (motivo: bump de versión +
   release 1.1.0; regla del repo al tocar `pubspec`).
4. **`python3 scripts/check_integrity.py`** (regla del repo al tocar `pubspec`/CI) → debe pasar.
5. **Validación local completa**:
   `dart format --output=none --set-exit-if-changed . && flutter analyze && flutter test`
   y `cd example && flutter analyze && flutter test`.
6. **`flutter pub publish --dry-run`** → resolver cualquier hallazgo (tamaño, archivos ignorados,
   `LICENSE-flutter_custom_selector.txt`/`NOTICE.md` deben viajar en el paquete).
7. **PR** `new-widgets-july26` → rama default, con `PR_JUSTIFICATION.md`; merge tras CI verde
   (el CI corre en `pull_request`: es la única pasada automática, ver §6.3).
8. **Tag anotado en el merge commit**:
   `git tag -a v1.1.0 -m "iron_widgets 1.1.0" && git push origin v1.1.0`.
9. **GitHub Release `v1.1.0`** (el primero del repo) con las notas de §5. El tag `v0.1.0` se
   conserva como histórico; no borrar ni reetiquetar.
10. **Publicación**: desde el tag, `flutter pub publish` (auth del owner en pub.dev).
11. **Post-release**: verificar score/pana en pub.dev; actualizar el bloque *Estado* de
    `SPEC_WIDGETS_ROADMAP.md` a "release 1.1.0 publicado"; commit `docs:` de cierre.

## 5 — Plantilla de notas del Release (GitHub)

```markdown
## iron_widgets 1.1.0

16 widgets/tipos nuevos inspirados en UIs de trading (Finandy), cero dependencias añadidas.

### Added
- Selectores con modo dropdown anclado desktop-first (`IronSelectMode`: bottomSheet · dropdown ·
  adaptive) para `IronSelect`, `IronEnum` e `IronMultiSelector` (multi con apply inmediato,
  fila All y resumen), con teclado completo y búsqueda opcional.
- Indicadores de mercado: `IronDeltaBadge`, `IronPriceTicker`, `IronCountdown`, `IronSparkline`.
- Entrada de órdenes: `IronSegmented`, `IronPercentSlider`, `IronStepper`, `IronActionButton`.
- Posiciones y estado: `IronTag`, `IronRangeBar`, `IronGauge`, `ShowGrid`/`ShowItem`.
- Contenedores: `IronPanel`, `IronTabs`.
- Tokens semánticos de tema: `bullColor`, `bearColor`, `surfaceElevated`, `cornerRadius`,
  `overlayMaxHeight` (opcionales, retrocompatibles).

### Fixed
- Layouts a prueba de overflow en `Show`/`ShowValuesColumn`/`ShowPercColumn`, `IronEditor` e
  `IronCheck` (⚠ cambia el render: ver nota de upgrade en el CHANGELOG).
- Goldens versionados + comparador con tolerancia multi-plataforma (5 %).

Suite: 164 tests (32 goldens) · analyze/format limpios · example con guardia anti-overflow.
```

## 6 — Riesgos y mitigaciones

1. **Formato repo-wide:** el CI exige `dart format --set-exit-if-changed .` y los archivos
   legados no cumplen el formatter de 3.41.7 → commit `style:` dedicado (paso 1).
2. **Goldens multi-OS:** resuelto con `test/flutter_test_config.dart` (tolerancia 5 %; en el CI
   Linux el diff es 0 %, sigue siendo estricto de facto).
3. **CI solo en `pull_request`:** el push del tag no dispara CI → toda la validación ocurre en el
   PR del paso 7; publicar solo desde el commit ya validado.
4. **Consumidores con `^1.0.2`:** recibirán 1.1.0 automáticamente, incluido el nuevo render de
   los widgets legados → nota de upgrade destacada (paso 2) y verificación en CryptBot antes de
   actualizar allí.

## 7 — Rollback

- pub.dev: `dart pub retract 1.1.0` (ventana de retracción; los retracts no borran, marcan la
  versión como no-resoluble por defecto).
- GitHub: eliminar Release y tag `v1.1.0`; revertir el commit de bump en la rama default.
