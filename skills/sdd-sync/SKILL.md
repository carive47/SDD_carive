---
name: sdd-sync
description: Ejecuta los checks deterministas de trazabilidad (check_spec_sync.py) y de diccionario de datos (check_data_dict.py), informa y corrige o se detiene.
---

# Sync spec ↔ código

Verifica de forma **determinista** (no por memoria del modelo) que spec, tareas,
tests y diccionario de datos están sincronizados.

## Proceso

1. Ejecuta `python scripts/check_spec_sync.py`.
2. Ejecuta `python scripts/check_data_dict.py`.
3. Interpreta el resultado:
   - **0 en ambos** → informa "sincronizado".
   - **Fallo** → lista los RF huérfanos / sin test / sin spec, o los campos del
     diccionario sin documentar, y propón la corrección (sin tocar nada todavía).
4. Pregunta al usuario si corriges o se detiene.

## Reglas

- Los scripts son la fuente de verdad del check; no "inspecciones a ojo" y des
   por bueno un resultado en rojo.
- Una corrección de sync puede implicar tocar spec, tareas, tests o diccionario:
   hazlo vía la skill correspondiente (`sdd-change` si toca spec).
