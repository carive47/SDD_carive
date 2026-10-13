# Diccionario de datos — <proyecto>

Documentación obligatoria de todas las tablas/estructuras y sus campos. Una fila
por campo. `check_data_dict.py` verifica que esté completo y sin huérfanos.

| Tabla | Campo | Tipo | Descripción | Restricciones | Ejemplo |
|---|---|---|---|---|---|
| habits | name | text | Nombre único del hábito | no vacío, único (casefold+strip) | "Estudiar Python" |
| habits | created_at | text (ISO) | Fecha de creación | YYYY-MM-DD | "2026-08-27" |
| habits | completions | text[] | Fechas en que se completó | orden asc, sin duplicados | ["2026-08-25", "2026-08-26"] |
