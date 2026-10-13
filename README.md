# SDD Kit — Spec-Driven Development con agentes de IA

Kit para desarrollar software con agentes de IA mediante **Spec-Driven
Development (SDD)**, con **aprobación humana en cada etapa**.

```
Scaffold + Constitución → Spec (EARS) → Clarificación → Plan → Tareas →
Implementación (una tarea, tests primero) → Validación → Cambio (spec primero)
```

El contenido de las skills es **agnóstico de la herramienta**: funciona en
**DeepSeek Harness (DSH)**, Claude Code, opencode y Cursor. Solo cambia dónde se
colocan.

---

## 1. Instalar (una vez por máquina)

**Windows:**

```powershell
git clone https://github.com/carive47/SDD_carive.git
cd SDD_carive
./install.ps1
```

Si la política de ejecución bloquea el script:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

**macOS / Linux:**

```bash
git clone https://github.com/carive47/SDD_carive.git
cd SDD_carive
./install.sh
```

El instalador hace tres cosas y **no toca nada más** (ni tus proyectos, ni tus
modelos, ni tus credenciales):

1. Copia las **11 skills** a `<DSH_HOME>/skills` (globales: se ven en cualquier
   carpeta).
2. Declara el preset **SDD** en tus perfiles, **con copia de seguridad** previa.
3. Verifica el resultado.

Después: **sal del todo de DeepSeek Harness y vuelve a abrirlo**.

---

## 2. Usar (3 pasos)

1. **Crea el proyecto** y abre una sesión en esa carpeta:

   ```bash
   mkdir mi-proyecto && cd mi-proyecto && git init
   ```

2. **Elige el preset `SDD`** — en Ajustes aparece como **tarjeta**; para tenerlo
   también en el selector de nueva sesión, activa *"Coding Tools"* en
   Ajustes → General.

3. **Pide el scaffold:**

   > Quiero \<tu idea\>. Usa `sdd-scaffold` para inicializar el proyecto, y
   > seguimos el flujo SDD etapa por etapa, esperando mi aprobación.

   ¿Solo las etapas iniciales? Añade: *"…SOLO hasta tareas. No implementes código."*

`sdd-scaffold` es **autocontenido**: trae sus plantillas, context packs y checks, y
deja el proyecto con `docs/`, `AGENTS.md`, `CLAUDE.md`, `specs/`, `contexts/` y
`scripts/check_*.py` funcionando.

El flujo completo, etapa por etapa, está en **[QUICKSTART.md](QUICKSTART.md)**.
Para el detalle de cada fase (sub-fases, gates, brief, contexto, supervisión, FAQ)
usa el **[MANUAL.md](MANUAL.md)**.

---

## 3. Requisitos

| Requisito | Nota |
|---|---|
| DeepSeek Harness **0.2.x** | Arquitectura de presets declarativos. |
| Windows | PowerShell 5+ y el ssh del sistema (OpenSSH). |
| macOS / Linux | bash. |
| Python | `python` en Windows; `python3` en macOS/Linux. |
| git | Para clonar (o usa el ZIP). |
| node | Opcional; solo para la verificación YAML del instalador. |

---

## Documentación

| Documento | Para qué |
|---|---|
| **README.md** (este) | Puerta de entrada: instalar y usar. |
| [MANUAL.md](MANUAL.md) | **Manual completo**: fases, sub-fases, gates, brief, contexto, supervisión, FAQ y glosario. |
| [QUICKSTART.md](QUICKSTART.md) | Resumen del flujo, etapa por etapa. |
| [SHARING.md](SHARING.md) | Publicar/actualizar el kit y repartirlo. |
| [presets/dsh/README.md](presets/dsh/README.md) | Detalle del preset y por qué se declara así. |

---

## Qué hay dentro

```
SDD_carive/
├── README.md · QUICKSTART.md · SHARING.md
├── install.ps1 / install.sh        # instaladores (Windows / macOS-Linux)
├── skills/                         # 11 skills SDD
│   ├── sdd-scaffold/               # + references/{templates,contexts,scripts}
│   ├── sdd-constitution/ · sdd-spec/ · sdd-clarify/ · sdd-plan/
│   ├── sdd-tasks/ · sdd-implement/ · sdd-validate/ · sdd-change/
│   └── sdd-sync/ · sdd-context-pack/
├── templates/                      # plantillas base (fuente canónica)
├── contexts/                       # context packs de dominio/stack
├── scripts/                        # checks deterministas
└── presets/dsh/                    # declaración del preset SDD (DSH 0.2.x)
    ├── sdd.patch.yml
    ├── standard.patch.yml          # plantilla de referencia de la build
    └── README.md
```

---

## Cómo funciona

### Sincronización spec ↔ código (spec-anchored)

Cuatro capas, todas activas (ver `skills/sdd-sync/SKILL.md`):

1. **Cambio = spec primero** (`sdd-change`): todo cambio nace en la spec.
2. **Trazabilidad RF→test** (`sdd-plan` + `sdd-tasks`): cada tarea/test declara su RF.
3. **Validación RF por RF** (`sdd-validate`): recorre la spec y verifica cobertura.
4. **Checks automáticos** (`scripts/`): `check_spec_sync.py` y `check_data_dict.py`
   fallan si hay RF huérfano, RF sin test o diccionario de datos incompleto.
   Blando en interacción, duro en CI.

### Historial de cambios (como commits, en ficheros)

Cada batch de arreglos/mejoras deja un fichero atómico en
`specs/NNN-*/changes/AAAA-MM-DD-slug.md` (qué cambió en spec/plan/tareas/código y
cómo se validó) más una línea en el `CHANGELOG.md` global. Lo mantiene `sdd-change`.

### Invariantes obligatorios en todos los proyectos

El preámbulo de `templates/constitution-base.md` se copia en todo
`docs/constitution.md` (cada campo/tabla documentado, todo RF con test, changelog
obligatorio…). El diccionario de datos es un artefacto obligatorio generado por
`sdd-plan` y verificado por `check_data_dict.py`.

### Chequeos

```bash
python  scripts/check_spec_sync.py     # Windows
python3 scripts/check_spec_sync.py     # macOS / Linux
python  scripts/check_data_dict.py
```

Ambos aceptan `--dir RUTA` (por defecto, el proyecto que contiene `scripts/`).
Salida `0` = OK, `1` = hay problemas.
