---
name: sdd-tasks
description: Descompón el plan en tareas pequeñas, ordenadas por dependencia, cada una con sus RF y una línea "Hecho cuando:" verificable. Genera tasks.md con checkboxes.
---

# Tareas

Divide el plan en pasos pequeños y verificables (divide y vencerás).

## Proceso

1. Lee `specs/NNN-*/spec.md` y `plan.md`.
2. Genera `specs/NNN-*/tasks.md` con `references/tasks-template.md`:
   - Tareas de **máx. 20-30 min** cada una.
   - Ordenadas por dependencia.
   - Cada una con los RF que cubre y una línea `Hecho cuando:` verificable.
   - Con checkboxes `- [ ]`.
3. Pide aprobación explícita antes de implementar.

## Reglas

- Cada tarea debe cubrir al menos un RF (o ser esqueleto/infra, marcado RF: —).
- "Hecho cuando:" debe ser comprobable (p. ej. "tests de X en verde"), no subjetivo.
- La última tarea debe ser siempre de validación final (checklist RF + docs).
