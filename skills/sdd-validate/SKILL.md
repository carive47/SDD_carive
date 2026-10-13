---
name: sdd-validate
description: 'Recorre la spec RF por RF: qué test cubre cada uno y su resultado, comprueba criterios de finalización y el diccionario de datos, y da un veredicto de spec cumplida.'
---

# Validación

## Proceso

1. Lee `specs/NNN-*/spec.md` y `tasks.md`.
2. Recorre la spec **RF por RF**. Para cada uno indica:
   - Qué test lo cubre (referencia `RF-x`).
   - El resultado de ejecutarlo.
   - Si no está cubierto o falla, dilo claramente.
3. Comprueba los **criterios de finalización** de la spec.
4. Verifica `docs/data-dictionary.md` (todo campo documentado).
5. Ejecuta `python scripts/check_spec_sync.py` y `python scripts/check_data_dict.py` (en macOS/Linux, `python3`).
6. Da un **veredicto**: ¿spec cumplida? (sí / no + qué falta).

## Reglas

- No des por bueno un RF sin test.
- Si algo falla, vuelve al paso correspondiente del flujo (código o spec),
  no "apañes" el veredicto.
