#!/usr/bin/env python3
"""Verifica el diccionario de datos (docs/data-dictionary.md).

Soporta VARIAS tablas markdown (una spec posterior puede anadir campos a una
tabla ya documentada). Comprobaciones:
1. El fichero existe y cada tabla tiene las columnas esperadas.
2. Toda fila tiene Tabla, Campo y Descripcion no vacios.
3. No hay pares (Tabla, Campo) duplicados.
4. Si existe docs/schema.json: todo campo esta documentado, y se avisa de
   entradas documentadas que ya no estan en schema.json (huerfanas).

Formato de docs/schema.json:
    { "tables": [ { "name": "habits", "fields": ["name", "created_at"] } ] }

Uso: python scripts/check_data_dict.py [--dir RUTA]
Salida: 0 = OK, 1 = problemas, 2 = error de uso.
"""

import argparse
import json
import re
import sys
from pathlib import Path


def _parse_tables(text):
    """Devuelve una lista de (columnas, filas) de TODAS las tablas markdown."""
    tables = []
    header = None
    rows = []
    in_table = False
    for ln in text.splitlines():
        s = ln.strip()
        if s.startswith("|") and s.endswith("|"):
            cells = [c.strip() for c in s.strip("|").split("|")]
            if all(re.match(r"^:?-{3,}:?$", c) for c in cells if c):
                continue  # linea separadora
            if not in_table:
                header = [c.lower() for c in cells]
                in_table = True
                continue
            rows.append(cells)
        else:
            if in_table:
                tables.append((header, rows))
                header = None
                rows = []
                in_table = False
    if in_table:
        tables.append((header, rows))
    return tables


def _norm_cols(header):
    aliases = {
        "tabla": "tabla",
        "campo": "campo",
        "tipo": "tipo",
        "descripción": "descripcion",
        "descripcion": "descripcion",
        "restricciones": "restricciones",
        "restricción": "restricciones",
        "ejemplo": "ejemplo",
    }
    return [aliases.get(c, c) for c in header]


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="Verifica docs/data-dictionary.md.")
    parser.add_argument("--dir", default=str(Path(__file__).resolve().parent.parent),
                        help="Raiz del proyecto.")
    args = parser.parse_args(argv)

    root = Path(args.dir).resolve()
    dd_path = root / "docs" / "data-dictionary.md"
    schema_path = root / "docs" / "schema.json"

    if not dd_path.is_file():
        print(f"[data-dict] No existe {dd_path}. El diccionario de datos es obligatorio.")
        return 1

    text = dd_path.read_text(encoding="utf-8-sig", errors="replace")
    tables = _parse_tables(text)
    if not tables:
        print("[data-dict] No se encontro ninguna tabla markdown en data-dictionary.md.")
        return 1

    problems = []
    documented = set()

    for header, rows in tables:
        header = _norm_cols(header)
        for col in ("tabla", "campo", "descripcion"):
            if col not in header:
                problems.append(f"Falta la columna '{col}' en una tabla.")
        idx = {col: header.index(col) for col in ("tabla", "campo", "descripcion")
               if col in header}
        if "tabla" not in idx or "campo" not in idx:
            continue
        for i, row in enumerate(rows, start=2):
            if len(row) <= max(idx.values()):
                problems.append(f"Fila {i}: celdas incompletas.")
                continue
            tabla = row[idx["tabla"]]
            campo = row[idx["campo"]]
            desc = row[idx["descripcion"]]
            if not tabla or not campo or not desc:
                problems.append(f"Fila {i}: Tabla, Campo y Descripcion no pueden estar vacios.")
                continue
            key = (tabla, campo)
            if key in documented:
                problems.append(f"Duplicado: {tabla}.{campo}.")
            documented.add(key)

    if schema_path.is_file():
        try:
            schema = json.loads(schema_path.read_text(encoding="utf-8-sig"))
            schema_fields = {}
            for t in schema.get("tables", []):
                name = t.get("name")
                if not name:
                    continue
                for f in t.get("fields", []):
                    schema_fields[(name, f)] = None
            for key in schema_fields:
                if key not in documented:
                    problems.append(f"Campo '{key[1]}' de la tabla '{key[0]}' esta en schema.json pero no documentado.")
            for key in documented:
                if key not in schema_fields:
                    problems.append(f"Entrada '{key[1]}' de '{key[0]}' esta documentada pero ya no existe en schema.json (huerfana).")
        except (json.JSONDecodeError, OSError) as e:
            problems.append(f"No se pudo leer docs/schema.json: {e}")
    else:
        print(f"[data-dict] Aviso: no existe {schema_path}; no se comprueba completitud contra el esquema.")

    print(f"[data-dict] tablas={len(tables)} campos_documentados={len(documented)}")

    if problems:
        print(f"[data-dict] {len(problems)} problema(s):")
        for p in problems:
            print(f"  - {p}")
        return 1

    print("[data-dict] OK: diccionario de datos valido y completo.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
