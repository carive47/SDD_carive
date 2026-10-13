---
name: sdd-implement
description: 'Implementa UNA sola tarea de tasks.md: tests primero, ejecuta la suite, marca la tarea como hecha y PÁRATE. No empieces la siguiente sin aprobación.'
---

# Implementación (una tarea cada vez)

## Proceso

1. Lee `docs/constitution.md`, la spec activa y `plan.md`.
2. Pregunta qué tarea implementar (o recibe el número Tn).
3. Implementa **SOLO Tn**, siguiendo plan y constitución.
4. **Tests primero**, luego el código.
5. Ejecuta la suite y muestra el resultado.
6. Marca Tn en `tasks.md` (`- [x]`), indica qué RF cubre, y **PÁRATE**.
7. Añade referencias `RF-x` en los tests que los cubren (comentario/docstring)
   para que `check_spec_sync.py` trace la cobertura.

## Reglas

- Prohibido avanzar con tests en rojo.
- No empieces T(n+1) sin aprobación explícita.
- Si el código cambia un comportamiento, la spec manda: detente y pasa a
  `sdd-change` en vez de improvisar.
- Al final de cada tarea, corre `python scripts/check_spec_sync.py` y
  `python scripts/check_data_dict.py`; si fallan, arréglalo antes de parar.
