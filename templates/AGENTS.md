# AGENTS.md — <proyecto>

## Proyecto
<Qué es, en 2-3 frases. Arquitectura, tecnologías.>

## Comandos
- Ejecutar: `<comando>`
- Tests: `<comando>`
- Lint/formato: `<comando>`
- Sync: `python scripts/check_spec_sync.py && python scripts/check_data_dict.py` _(macOS/Linux: `python3`)_

## Estilo y convenciones
<Versión del lenguaje, convenciones de nombres, idioma del código y mensajes.>

## Reglas
- Lee `docs/constitution.md` y la spec activa antes de tocar código.
- La spec manda: comportamiento no especificado = no se implementa; pregunta.
- Documenta todo campo/tabla en `docs/data-dictionary.md`.
- <Límites: qué no tocar, qué no añadir sin preguntar.>

## Al terminar cualquier tarea
- Ejecuta los tests y confirma en tu respuesta que pasan.
- Ejecuta `python scripts/check_spec_sync.py` y `python scripts/check_data_dict.py`; si fallan, arréglalo.
- Registra el batch en `specs/NNN-*/changes/` + `CHANGELOG.md`.
