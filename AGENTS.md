# AGENTS.md - Repository Rules for AI Agents

## 🎯 Purpose
This file provides critical context and constraints for AI agents (Antigravity, Cursor, Claude, etc.) working on this monorepo. Following these rules is mandatory to maintain stability across Dart and Flutter projects.
> [!IMPORTANT]
> **Contexto del Ecosistema:** Este repositorio es un componente crítico del ecosistema **ASHware Antigravity** (junto con *Iron Widgets, binance_dart_sdk, KChart2 y CryptBot*). Las reglas de integridad existen porque compartimos dependencias núcleo y patrones de CI; cualquier desalineación aquí puede propagar inestabilidad a todo el sistema.


## 🛠 Dependency Management Rules

### 1. The "SDK Pinning" Rule (CRITICAL)
- **Problem:** Flutter SDK often pins specific versions of core packages (like `meta`, `path`, `analyzer`).
- **Constraint:** NEVER force a dependency version that exceeds what the current Flutter SDK supports in its `flutter_test` or core components.
- **Example:** If `flutter_test` depends on `meta 1.15.0`, do NOT set `meta: ^1.16.0` even if it is available. This will cause a version solving failure.
- **Action:** Always check the current Flutter SDK constraints before upgrading core transitive dependencies.

### 2. The "Stale Package" Rule
- **Constraint:** Avoid adding or maintaining dependencies that have not been updated for more than **1 year**.
- **Reasoning:** Dart and Flutter evolve rapidly. Stale packages lead to `breaking changes` and incompatibility with newer SDKs.
- **Action:** If a package is stale, look for a modern alternative or notify the user to consider forking or replacing it.

### 3. Version Hard-Locking
- Use `^` for flexible but safe updates (semver).
- DO NOT use `any` unless explicitly allowed in the `directivas/` for internal monorepo packages.

---

## 🚀 Workflow & Tooling

### 1. Integrity Guardian
- You MUST run `python3 scripts/check_integrity.py` before suggesting a commit that touches `pubspec.yaml` or `.github/workflows/`.
- If changes are needed, you MUST create a `PR_JUSTIFICATION.md` with a detailed technical explanation.

### 2. Dart/Flutter Synchronization
- After any dependency change, run `python3 scripts/sincronizar_dependencias_dart.py` to ensure the entire monorepo is still in sync and passes analysis.

---

## 🧠 Memory & Directives
- This repository uses a **3-component system**:
  1. `directivas/`: Standard Operating Procedures (SOPs).
  2. `scripts/`: Deterministic execution scripts.
  3. `AGENTS.md`: This context file.
- ALWAYS consult the `directivas/` folder before implementing new logic.
