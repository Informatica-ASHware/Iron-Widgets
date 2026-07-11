# Directiva: formato de entregas

> Registrada el 2026-07-11 por indicación del owner. Aplica a toda entrega
> generada por agentes (Claude u otros) en este repositorio.

1. **Empaquetado**: cada entrega es un único archivo que sigue la plantilla
   `Iron-Widgets-*.{zip|md}` (zip para código/multiarchivo, md admisible
   para documentos sueltos).
2. **Contenido no incremental**: el zip contiene los archivos creados o
   modificados **completos**, con sus rutas relativas al raíz del repo,
   listos para extraer sobre la copia de trabajo. Nunca diffs ni parches.
3. **Alcance limpio**: solo archivos intencionalmente tocados por la US en
   curso. Reformateos colaterales (p. ej. `dart format` sobre `vendor/`)
   deben revertirse antes de empaquetar.
4. **Mensaje de commit**: cada entrega incluye un mensaje breve conforme a
   [Conventional Commits v1.0](https://www.conventionalcommits.org/en/v1.0.0/)
   (`tipo(ámbito): descripción`, cuerpo opcional).
5. **Hallazgos**: los problemas preexistentes detectados durante la US se
   reportan en el mensaje de entrega como candidatos a US de corrección;
   no se corrigen dentro de la US en curso salvo indicación expresa.
