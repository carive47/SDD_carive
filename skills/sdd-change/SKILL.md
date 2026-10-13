---
name: sdd-change
description: 'Gestiona un cambio o nuevo requisito: primero actualiza la spec (y plan/tareas), muestra el diff, y solo después toca el código. Registra el cambio en changes/ y CHANGELOG.md.'
---

# Cambio (spec primero, luego código)

Todo cambio nace en la spec. Nunca toques código antes de actualizar el contrato.

## Proceso

1. Recibe el nuevo requisito/cambio.
2. **NO toques código.** Actualiza primero, en orden:
   - `specs/NNN-*/spec.md` (nuevo RF en EARS + casos límite).
   - `plan.md` y `tasks.md` si el cambio lo requiere.
   - `docs/data-dictionary.md` + `docs/schema.json` si cambia el modelo de datos.
3. Muestra el **diff** de la spec y pide aprobación.
4. Tras `Aprobar`, implementa (vía `sdd-implement`) y valida (vía `sdd-validate`).
5. Registra el batch en `specs/NNN-*/changes/AAAA-MM-DD-slug.md` con
   `references/changelog-template.md` y añade una línea al `CHANGELOG.md` global.

## Reglas

- Un cambio = un fichero en `changes/` + una línea en `CHANGELOG.md`.
- Si el cambio contradice la constitución, detente y pregunta (la constitución
  solo cambia por decisión explícita del usuario).
- Si el requisito es ambiguo, pregunta antes de escribir la spec.
