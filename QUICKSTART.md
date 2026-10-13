# QUICKSTART — Arrancar un proyecto nuevo con SDD

Guía paso a paso. El kit es **agnóstico de la herramienta**: lo único que cambia
es *dónde* viven las skills y *cómo* se piden las aprobaciones.

> Este es el **resumen**. Para el detalle de cada fase (sub-fases, gates, brief,
> contexto, supervisión, FAQ) usa el **[MANUAL.md](MANUAL.md)**.

---

## 0. Requisitos

- **DeepSeek Harness 0.2.x** (o VS Code + Cline: ver el final).
- El **kit instalado una vez por máquina** (ver `SHARING.md`):
  - Windows: `./install.ps1`
  - macOS / Linux: `./install.sh`
- `git` y `python` (Windows) o `python3` (macOS/Linux).

La instalación deja las 11 skills en `<DSH_HOME>/skills` (globales: se ven en
cualquier carpeta) y declara el preset **SDD**.

---

## 1. Crear el proyecto

```bash
mkdir mi-proyecto && cd mi-proyecto && git init
```

---

## 2. Preparar el contexto — SOLO si traes mucho

Si el proyecto tiene mucho contexto (ETL complejo, requisitos de cliente, fuentes
de datos, esquemas existentes…), **antes de arrancar** crea `brief/` con el
contexto crudo. Es un dump, no un prompt:

```
mi-proyecto/
└── brief/
    ├── negocio.md              ← qué hace, para quién, por qué
    ├── fuentes-de-datos.md     ← orígenes, formatos, volúmenes
    ├── transformaciones.md     ← reglas de negocio del ETL
    └── requisitos-cliente.md   ← notas, correos, capturas…
```

Si tu contexto es solo una idea de 1-3 frases, **salta este paso** y deja que el
agente te entreviste en la etapa de spec.

---

## 3. Arrancar (primer prompt)

Abre una sesión en la carpeta del proyecto, elige el preset **SDD** y escribe:

**Con `brief/`:**
```
Lee brief/ y propón docs/constitution.md + docs/roadmap.md con el desglose en
specs (001, 002…) y su orden. No escribas código. Espera mi aprobación.
```

**Sin `brief/` (idea corta):**
```
Vamos a crear <DESCRIPCIÓN en 1-3 frases>.
Usa sdd-scaffold para inicializar el proyecto, y seguimos el flujo SDD
etapa por etapa, esperando mi aprobación en cada una.
```

`sdd-scaffold` es **autocontenido**: trae sus plantillas, context packs y checks en
sus `references/`, y deja el proyecto con `docs/`, `AGENTS.md`, `CLAUDE.md`,
`specs/`, `contexts/` y `scripts/check_*.py` operativos. **Aprobar antes de seguir.**

> Si solo quieres las etapas iniciales, añade:
> *"…SOLO hasta tareas. No implementes código."*

---

## 4. Recorrer las etapas (siempre con aprobación)

| Etapa | Skill | Qué produce | Gate |
|---|---|---|---|
| Constitución | `sdd-constitution` | `docs/constitution.md` | Aprobar |
| Spec | `sdd-spec` | `specs/NNN-*/spec.md` (EARS) | Aprobar |
| Clarificación | `sdd-clarify` | informe de hallazgos | decidir |
| Plan | `sdd-plan` | `plan.md` + `data-dictionary.md` + `schema.json` | Aprobar |
| Tareas | `sdd-tasks` | `tasks.md` | Aprobar |
| Implementación | `sdd-implement` | código+tests (una tarea, PÁRATE) | Aprobar por tarea |
| Validación | `sdd-validate` | veredicto RF por RF | — |
| Cambio | `sdd-change` | diff de spec + fichero en `changes/` | Aprobar |

En cada etapa el agente usa su skill y se detiene con `ask_user_question` (DSH) o
pregunta en el chat (Cline). Cada spec se hace con su bucle completo, de una en
una, en el orden de `docs/roadmap.md`.

---

## 5. Mantener la sincronización

- **Cambio** → `sdd-change`: primero la spec, luego el código; deja fichero en
  `specs/NNN-*/changes/` + línea en `CHANGELOG.md`.
- **Checks** (al final de cada batch y en CI):

  ```
  python  scripts/check_spec_sync.py     # Windows
  python3 scripts/check_spec_sync.py     # macOS/Linux
  ```

  Lo mismo con `check_data_dict.py`.

---

## Diferencias DSH vs Cline

| | DSH | VS Code + Cline |
|---|---|---|
| Skills en | `<DSH_HOME>/skills` (global) o `.dsh/skills/` | `.cline/skills/` (v3.48+) o `~/.cline/skills/` |
| Reglas fijas | `AGENTS.md` + persona del preset | `AGENTS.md` + `.clinerules/` |
| Modo SDD | agent preset `sdd` (ver `presets/dsh/`) | Plan/Act + `.clinerules/` |
| Aprobación | `ask_user_question` / modo plan | Plan mode + aprobación nativa de Cline |
| Checks | los mismos scripts | los mismos scripts |

**Sí es posible con Cline**: el método es el mismo (specs + skills + checks), solo
cambian las rutas y el mecanismo de aprobación.
