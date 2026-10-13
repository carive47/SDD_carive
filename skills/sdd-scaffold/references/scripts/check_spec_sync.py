#!/usr/bin/env python3
"""Verifica trazabilidad RF-x entre spec, tasks y tests (spec-anchored).

Convenciones:
- specs/NNN-*/spec.md   DEFINE los requisitos en lineas "- RF-n: ...".
- specs/NNN-*/tasks.md  referencia los RF que cada tarea cubre (RF-n, o (RF: todos)).
- tests/**              referencia RF-n en comentarios/docstrings.

Errores (salida 1): RF sin tarea, RF sin test, test que cita un RF no definido.
Avisos (no afectan la salida): RF definido en varias specs, cobertura (RF: todos).

Uso: python scripts/check_spec_sync.py [--dir RUTA]
"""

import argparse
import re
import sys
from pathlib import Path

# Solo lineas de DEFINICION: "- RF-n:" (ignora citas como "-> RF-5" o "RF-2" en prosa).
DEF_RE = re.compile(r"^\s*[-*]\s*RF-(\d+)\s*:", re.IGNORECASE | re.MULTILINE)
RF_RE = re.compile(r"\bRF-(\d+)\b", re.IGNORECASE)
TODOS_RE = re.compile(r"\(RF:\s*(todos|todas|all)\s*\)", re.IGNORECASE)


def _read(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8-sig", errors="replace")
    except OSError:
        return ""


def _defined_rfs(text: str) -> set[int]:
    return {int(m) for m in DEF_RE.findall(text)}


def _cited_rfs(text: str) -> set[int]:
    return {int(m) for m in RF_RE.findall(text)}


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="Verifica trazabilidad RF-x.")
    parser.add_argument("--dir", default=str(Path(__file__).resolve().parent.parent),
                        help="Raiz del proyecto.")
    args = parser.parse_args(argv)
    root = Path(args.dir).resolve()
    specs_dir = root / "specs"
    tests_dir = root / "tests"

    if not specs_dir.is_dir():
        print(f"[sdd-sync] No existe {specs_dir}. Nada que comprobar.")
        return 0

    spec_rfs: dict[int, list[str]] = {}
    spec_files = sorted(specs_dir.glob("*/spec.md"))
    for f in spec_files:
        for n in _defined_rfs(_read(f)):
            spec_rfs.setdefault(n, []).append(f.parent.name)

    tasks_rfs: set[int] = set()
    tasks_has_todos = False
    tasks_files = sorted(specs_dir.glob("*/tasks.md"))
    for f in tasks_files:
        t = _read(f)
        tasks_rfs |= _cited_rfs(t)
        if TODOS_RE.search(t):
            tasks_has_todos = True

    test_rfs: set[int] = set()
    if tests_dir.is_dir():
        for f in tests_dir.rglob("*"):
            if f.is_file():
                test_rfs |= _cited_rfs(_read(f))
    else:
        print(f"[sdd-sync] Aviso: no existe {tests_dir}.")

    problems: list[str] = []
    warnings: list[str] = []
    all_spec = set(spec_rfs)

    for n, specs in spec_rfs.items():
        if len(specs) > 1:
            warnings.append(f"RF-{n} definido en varias specs: {', '.join(specs)} (numera RF global y continuo).")

    if tasks_has_todos:
        warnings.append("tasks.md usa (RF: todos): cobertura de tarea debil, no verificada RF a RF.")
        missing = all_spec - tasks_rfs
        if missing:
            warnings.append("RF solo cubiertos por (RF: todos): "
                            + ", ".join(f"RF-{n}" for n in sorted(missing)) + ".")
    else:
        for n in sorted(all_spec - tasks_rfs):
            problems.append(f"RF-{n} no aparece en tasks.md (sin tarea).")

    for n in sorted(all_spec - test_rfs):
        problems.append(f"RF-{n} no aparece en ningun test (sin cobertura).")

    for n in sorted(test_rfs - all_spec):
        problems.append(f"RF-{n} referenciado en tests pero no definido en ninguna spec.")

    print(f"[sdd-sync] specs={len(spec_files)} tasks={len(tasks_files)} "
          f"RF_en_spec={len(all_spec)} RF_en_tasks={len(tasks_rfs)} RF_en_tests={len(test_rfs)}")

    for w in warnings:
        print(f"  [aviso] {w}")

    if problems:
        print(f"[sdd-sync] {len(problems)} problema(s):")
        for p in problems:
            print(f"  - {p}")
        return 1

    print("[sdd-sync] OK: spec, tasks y tests sincronizados.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
