# Justificación de Cambio en Dependencias / CI

## Motivo del Cambio
Release 1.1.0: bump de `version` en `pubspec.yaml` (1.0.2 → 1.1.0) para
consolidar las fases 1–5 de `docs/specs/SPEC_WIDGETS_ROADMAP.md`
(US-2.01 … US-2.18: 16 widgets/tipos nuevos, tokens semánticos de tema y
modo dropdown de los selectores) más los fixes de overflow de los widgets
legados y la infraestructura de goldens (baselines versionadas +
comparador con tolerancia multi-plataforma). No se agregan, eliminan ni
cambian dependencias; no se modifica el workflow de CI.

## Impacto
Cambio aditivo (SemVer minor): ninguna firma pública se rompe. Los fixes
de overflow cambian el render de `Show`/`IronEditor`/`IronCheck` (celdas
que crecen, campo que flexiona, label que escala) — documentado como nota
de upgrade en `CHANGELOG.md § 1.1.0`. Consumidores con `^1.0.2`
resolverán 1.1.0 automáticamente.

## Pruebas Realizadas
`dart format --set-exit-if-changed .` (repo completo, limpio tras el
commit de estilo) · `flutter analyze` sin issues en paquete y example ·
`flutter test`: 164/164 (32 goldens) · `example/`: 3/3 incluida la
guardia anti-overflow a 360/800/1280 px · `flutter pub publish --dry-run`
sin errores · verificación manual del example en macOS por el owner.
