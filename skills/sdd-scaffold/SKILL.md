---
name: sdd-scaffold
description: 'Inicializa un proyecto nuevo con la estructura SDD completa: constitution, AGENTS.md/CLAUDE.md, data-dictionary, schema.json, roadmap, specs/, scripts/ y contexts/. Autocontenida: trae sus plantillas, packs y checks en references/.'
---

# Scaffold de proyecto SDD

Convierte una idea en un proyecto listo para SDD. No escribas código de negocio:
solo estructura, constitución y contexto operativo. Los recursos (plantillas,
context packs y scripts de verificación) viven en `references/` de esta skill.

## Proceso

1. **Pregunta lo mínimo** (con `ask_user_question`):
   - Nombre del proyecto (kebab-case).
   - Dominios de `references/contexts/INDEX.md` que aplican (pueden ser varios).
   - Si existe un `brief/`, su ruta.
2. **Crea la estructura**: `docs/`, `specs/`, `scripts/`, `contexts/`.
3. **Genera `docs/constitution.md`** = `references/templates/constitution-base.md`
   (verbatim) + principios del proyecto (destilados del brief/packs seleccionados).
   Marca `[AWAITING APPROVAL]` al final.
4. **Genera `AGENTS.md`** rellenando `references/templates/AGENTS.md` con comandos,
   estilo y reglas del proyecto (usa el intérprete del sistema: `python` en
   Windows, `python3` en macOS/Linux). `CLAUDE.md` = `@AGENTS.md`.
5. **Genera `docs/data-dictionary.md`** (desde
   `references/templates/data-dictionary.md`, vacío) y `docs/schema.json` con
   `{ "tables": [] }`.
6. **Genera `docs/roadmap.md`** (desde `references/templates/roadmap.md`).
7. **Copia los checks**: `references/scripts/check_spec_sync.py` y
   `references/scripts/check_data_dict.py` → `scripts/`.
8. **Copia los context packs**: `references/contexts/*` → `contexts/` (para
   futuras specs y `sdd-context-pack`).
9. **Verificación final**: ejecuta `python scripts/check_spec_sync.py` y
   `python scripts/check_data_dict.py` (`python3` en macOS/Linux). El scaffold NO
   se da por bueno si alguno falla (salida distinta de 0).
10. **Pide aprobación explícita** antes de pasar a la spec 001.

## Reglas

- No inventes principios de negocio: si el brief no lo dice, pregunta.
- La constitución base (`references/templates/constitution-base.md`) NO se
  modifica por proyecto.
- Si dos context packs se contradicen, márcalo y pregunta; no decidas solo.
- Nunca borres el `brief/` del usuario.
- Criterio de "kit sano": al terminar el scaffold deben existir
  `docs/constitution.md`, `AGENTS.md`, `CLAUDE.md`, `docs/data-dictionary.md`,
  `docs/roadmap.md`, `docs/schema.json`, `specs/`, `scripts/check_spec_sync.py` y
  `scripts/check_data_dict.py`, con ambos checks ejecutables y salida 0.
