---
name: sdd-plan
description: Genera el plan técnico (plan.md) a partir de la spec y la constitución, más el diccionario de datos (data-dictionary.md) y su esquema machine-readable (schema.json). Sin código.
---

# Plan técnico

Traduce la spec (QUÉ) a diseño (CÓMO a alto nivel). Sin código todavía.

## Proceso

1. Lee `docs/constitution.md`, `specs/NNN-*/spec.md` y `brief/` si aplica.
2. Genera `specs/NNN-*/plan.md` con `references/plan-template.md`, cubriendo:
   - Estructura de módulos (qué RF cubre cada uno).
   - Modelo de datos (con ejemplo JSON).
   - Algoritmos/decisiones en pseudocódigo.
   - Contrato de interfaz (comandos, salidas, códigos de salida).
   - Decisiones técnicas justificadas **con su alternativa descartada**.
   - Estrategia de tests (qué test cubre cada RF).
3. Genera/actualiza `docs/data-dictionary.md`: una fila por tabla/campo, con
   descripción, tipo, restricciones y ejemplo (cabecera: | Tabla | Campo | Tipo |
   Descripción | Restricciones | Ejemplo |).
4. Genera `docs/schema.json` (machine-readable) para que `check_data_dict.py`
   pueda verificar completitud:
   ```json
   { "tables": [ { "name": "habits", "fields": ["name", "created_at", "completions"] } ] }
   ```
5. Pide aprobación explícita antes de pasar a tareas.

## Reglas

- Todo debe respetar la constitución y cubrir **todos** los RF.
- Marca qué RF cubre cada parte.
- El diccionario de datos es obligatorio: si un campo no está documentado, el
  check final fallará.
