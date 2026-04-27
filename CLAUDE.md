# CLAUDE.md - Reglas del Repositorio para Agentes IA

## 🎯 Propósito y Contexto del Ecosistema
Este archivo proporciona el contexto crítico y las instrucciones obligatorias para los agentes IA (Antigravity, Cursor, Claude, etc.) que trabajen en este monorepo. Seguir estas reglas es mandatorio para mantener la estabilidad a través de los proyectos de Dart y Flutter.

> [!IMPORTANT]
> **Contexto del Ecosistema:** Este repositorio es un componente crítico del ecosistema **CryptBot System** (junto con *Iron Widgets, binance_dart_sdk, KChart2 y CryptBot*). Las reglas de integridad existen porque compartimos dependencias núcleo y patrones de CI; cualquier desalineación aquí puede propagar inestabilidad a todo el sistema.

---

## 🤖 INSTRUCCIONES GLOBALES Y DEFINICIÓN DE TERMINADO (Definition of Done)

Para **CADA** Historia de Usuario (US) generada mediante un Pull Request (PR), el Agente IA debe cumplir estrictamente este `Definition of Done` (DoD). Si falta un punto, el PR será rechazado.

1.  **Código Limpio:** Cero advertencias del linter.
2.  **Testing Obligatorio:** Unit tests para lógica; Golden tests para UI.
3.  **Documentación:** Todo método y clase pública debe tener `/// Dartdoc`.
4.  **Inmutabilidad:** Uso de `@freezed` o `final` con `copyWith`.
5.  **Performance:** Uso estricto de `double`, colecciones numéricas optimizadas.
6.  **Platform Target:** Desktop (MacOS) y Mobile nativo. Soporte Web relegado.
7.  **ChangeLog:** Actualizar `CHANGELOG.md` bajo `## [Unreleased]`.

---

## 🛠 REGLAS DE GESTIÓN DE DEPENDENCIAS

### 1. The "SDK Pinning" Rule (CRÍTICO)
- **Restricción:** NUNCA fuerces una versión de dependencia que exceda lo que el Flutter SDK actual soporta.
- **Acción:** Verifica los constraints del Flutter SDK antes de actualizar dependencias core.

### 2. The "Stale Package" Rule
- **Restricción:** Evita dependencias sin actualizaciones por más de **1 año**.
- **Acción:** Busca alternativas modernas si un paquete es stale.

### 3. Version Hard-Locking
- Usa `^` para actualizaciones seguras. Prohibido el uso de `any`.

### 4. Realidad Temporal (CRÍTICO)
- **Restricción:** NUNCA asumas la fecha basada en datos de entrenamiento. DEBES usar comandos del sistema o metadata para obtener la fecha REAL (Hoy es Abril de 2026).
- **Acción:** Antes de actualizar cualquier CHANGELOG.md o documentación, verifica el año y día real mediante el comando `date`.

---

## 🚀 MODO DE OPERACIÓN Y FLUJO DE TRABAJO DEL AGENTE

1. **Sincronización:** Branching siguiendo `feature/US-X.XX`.
2. **Integridad (Guardian):** Ejecutar `scripts/check_integrity.py` antes de commits en pubspec/CI.
3. **Ciclo de Código:** Tests -> Implementación -> `dart format` -> `dart analyze`.
4. **Sincronización Monorepo:** Ejecutar `scripts/sincronizar_dependencias_dart.py`.
5. **ChangeLog:** Documentar en `## [Unreleased]`.

---

## 🧠 SISTEMA DE MEMORIA Y DIRECTIVAS
Este repositorio utiliza un **sistema de 3 componentes**: `directivas/`, `scripts/` y `AGENTS.md`. SIEMPRE consulta la carpeta `directivas/` antes de implementar nueva lógica.
