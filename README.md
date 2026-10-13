# sdd-kit — Kit de Spec-Driven Development

Kit reutilizable para desarrollar software con agentes de IA mediante
**Spec-Driven Development (SDD)**, con *human-in-the-loop* (aprobación humana en
cada etapa). Es la destilación de la metodología de `hello-sdd/` empaquetada como
skills + plantillas + context packs + checks automáticos.

> El contenido es **agnóstico de la herramienta**: funciona en DeepSeek Harness
> (DSH), Claude Code, opencode, Cursor… Solo cambia dónde se colocan las skills.

## Flujo (una línea)

```
Scaffold + Constitución → Spec (entrevista EARS) → Clarificación → Plan →
Tareas → Implementación (una tarea cada vez, tests primero) → Validación →
Cambio (spec primero, luego código) → [bucle]
```

Cada etapa termina con un **gate de aprobación** (`ask_user_question` / modo plan).
Nada avanza sin `Aprobar`.

## Estructura

```
sdd-kit/
├── README.md
├── skills/            # 11 skills (una por etapa + scaffold + sync + context-pack)
│   ├── sdd-scaffold/SKILL.md
│   ├── sdd-constitution/SKILL.md
│   ├── sdd-spec/SKILL.md            (+ references/spec-template.md)
│   ├── sdd-clarify/SKILL.md
│   ├── sdd-plan/SKILL.md            (+ references/plan-template.md)
│   ├── sdd-tasks/SKILL.md           (+ references/tasks-template.md)
│   ├── sdd-implement/SKILL.md
│   ├── sdd-validate/SKILL.md
│   ├── sdd-change/SKILL.md          (+ references/changelog-template.md)
│   ├── sdd-sync/SKILL.md
│   └── sdd-context-pack/SKILL.md
├── templates/         # plantillas que se copian a cada proyecto nuevo
│   ├── constitution-base.md   # invariantes SIEMPRE presentes
│   ├── AGENTS.md              # contexto operativo del proyecto
│   ├── CLAUDE.md              # una línea: @AGENTS.md
│   ├── data-dictionary.md     # diccionario de datos obligatorio
│   └── roadmap.md             # mapa de specs (cuáles y en qué orden)
├── contexts/          # "context packs" de dominio/stack (componibles)
│   ├── INDEX.md
│   ├── ingestion.md / etl.md / api-backend.md / llm-pipeline.md / cli-tool.md
│   └── infra-stack-python.md
├── scripts/           # checks deterministas (no dependen de la memoria del agente)
│   ├── check_spec_sync.py    # trazabilidad RF-x entre spec/tasks/tests
│   └── check_data_dict.py    # diccionario de datos completo y sin huérfanos
└── presets/dsh/sdd/   # referencia para montar el "modo" SDD en DSH
    ├── preset.yml
    └── README.md      # pasos exactos de construcción
```

## Cómo usarlo

### A. En DeepSeek Harness (modo SDD)

1. Las skills viven en `~/.dsh/skills/` (global) y el preset `sdd` está declarado
   en el perfil (`~/.dsh/profiles/desktop/cordis.patch.yml`). Ver `presets/dsh/sdd/`.
2. Reinicia la app y elige el preset **SDD** (en Ajustes, como tarjeta; y en el
   selector de nueva sesión con "Coding Tools" activo).
3. En una sesión SDD escribe: *"Quiero <idea>. Usa sdd-scaffold para inicializar."*
   `sdd-scaffold` es **autocontenido**: trae plantillas, context packs y checks en
   sus `references/` y deja el proyecto con `scripts/check_*.py` funcionando.

### B. Por proyecto (sin modo)

Con las skills en `~/.dsh/skills/` (global) o `proyecto/.dsh/skills/`, arranca con
el agente estándar y pide `sdd-scaffold`. No hay que copiar assets a mano:
`sdd-scaffold` los genera/copia desde sus `references/`.

### C. En otras herramientas

Misma skill, distinta ruta: `.claude/skills/`, `.opencode/skill/`,
`.cursor/rules/`. El contenido de `SKILL.md` no cambia.

## Sincronización spec ↔ código (spec-anchored)

Cuatro capas, todas activas (ver `skills/sdd-sync/SKILL.md`):

1. **Cambio = spec primero** (`sdd-change`): todo cambio nace en la spec.
2. **Trazabilidad RF→test** (`sdd-plan` + `sdd-tasks`): cada tarea/test declara su RF.
3. **Validación RF por RF** (`sdd-validate`): recorre la spec y verifica cobertura.
4. **Checks automáticos** (`scripts/`): `check_spec_sync.py` y `check_data_dict.py`
   fallan si hay RF huérfano, RF sin test, o diccionario de datos incompleto.
   Blando en interacción, duro en CI.

## Historial de cambios (como commits, en ficheros)

Cada batch de arreglos/mejoras deja un fichero atómico en
`specs/NNN-*/changes/AAAA-MM-DD-slug.md` (qué cambió en spec/plan/tareas/código y
cómo se validó) más una línea en el `CHANGELOG.md` global. Lo mantiene `sdd-change`.

## Invariantes obligatorios en todos los proyectos

`templates/constitution-base.md` se copia como preámbulo fijo de todo
`docs/constitution.md` (descripción de cada campo/tabla, todo RF con test,
changelog obligatorio…). El diccionario de datos es un artefacto obligatorio
generado por `sdd-plan` y verificado por `check_data_dict.py`.

## Chequeos

```bash
python scripts/check_spec_sync.py        # trazabilidad RF
python scripts/check_data_dict.py        # diccionario de datos
```

Ambos aceptan `--dir RUTA` (por defecto, el proyecto que contiene `scripts/`).
Salida `0` = OK, `1` = hay problemas.
