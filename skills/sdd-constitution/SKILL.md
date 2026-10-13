---
name: sdd-constitution
description: Propón o refina la constitución de un proyecto (principios innegociables). Úsala para definir las reglas base antes de cualquier spec.
---

# Constitución

La constitución son los principios innegociables. Toda spec, plan, tarea y código
debe cumplirlos. Se escribe una vez y solo cambia por decisión explícita del
usuario.

## Proceso

1. Lee `docs/constitution.md` (si existe) y `brief/` (si existe).
2. Propón **N principios cortos y verificables** (máx. 15 líneas totales) que
   cubran: stack, relación spec↔código, separación lógica/interfaz, política de
   tests, persistencia/datos, idioma y límites.
3. El preámbulo de `templates/constitution-base.md` es fijo: NO lo reescribas,
   solo añade los principios del proyecto debajo.
4. Pide aprobación explícita antes de continuar.

## Reglas

- Cada principio debe poder comprobarse (nada de "robusto", "rápido", "bueno").
- "La spec manda" siempre debe estar (comportamiento no especificado = no se implementa).
- Si falta una decisión, detente y pregunta; no asumas.
