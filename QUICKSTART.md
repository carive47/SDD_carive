# QUICKSTART — Arrancar un proyecto nuevo con SDD

Guía paso a paso desde cero. El contenido del kit es **agnóstico de la
herramienta**: lo único que cambia es *dónde* se colocan las skills y *cómo* se
piden las aprobaciones.

---

## 0. Requisitos

- Tener `sdd-kit/` a mano (este repositorio).
- Git instalado (`git init` marca la raíz del proyecto y da el historial).
- Un agente: DeepSeek Harness (DSH) **o** VS Code + Cline.

---

## 1. Crear y entrar al proyecto

```powershell
mkdir mi-proyecto; cd mi-proyecto; git init
```

---

## 2. Copiar los assets del kit (una vez por proyecto)

### Desde DSH (DeepSeek Harness)

```powershell
Copy-Item -Recurse ..\sdd-kit\skills    .dsh\skills
Copy-Item -Recurse ..\sdd-kit\scripts   scripts
Copy-Item -Recurse ..\sdd-kit\contexts  contexts
Copy-Item -Recurse ..\sdd-kit\templates templates
```

> DSH descubre las skills del proyecto en `<raíz>/.dsh/skills/`. La raíz es el
> ancestro con `.git` (por eso `git init` va primero).

### Desde VS Code + Cline

```powershell
Copy-Item -Recurse ..\sdd-kit\skills    .cline\skills
Copy-Item -Recurse ..\sdd-kit\scripts   scripts
Copy-Item -Recurse ..\sdd-kit\contexts  contexts
Copy-Item -Recurse ..\sdd-kit\templates templates
```

> Cline lee skills de `.cline/skills/` (proyecto) o `~/.cline/skills/` (global),
> y reglas de `.clinerules/`. Docs: https://docs.cline.bot/customization/skills y
> https://docs.cline.bot/customization/cline-rules

### (Opcional, Cline) Reglas globales del proyecto

Crea `.clinerules/sdd.md` con las reglas fijas para que Cline las cargue siempre:

```markdown
---
alwaysApply: true
---
Eres un facilitador SDD. La spec es el contrato: nada se implementa si no está
en una spec aprobada. Trabaja por etapas y PÁRATE al final de cada etapa para
pedir aprobación explícita. Lee docs/constitution.md y la spec activa antes de
tocar código. Al terminar una tarea: corre los tests y
`python scripts/check_spec_sync.py && python scripts/check_data_dict.py`.
```

---

## 3. Preparar el contexto — SOLO si traes mucho

Si el proyecto tiene mucho contexto (ETL complejo, requisitos de cliente,
fuentes de datos, esquemas existentes…), **antes de arrancar** crea `brief/` con
todo el contexto crudo. Es un dump, no un prompt:

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

## 4. Arrancar (primer prompt)

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

El agente leerá `contexts/INDEX.md`, te preguntará qué dominios aplican, y
generará `docs/constitution.md`, `AGENTS.md`, `docs/data-dictionary.md`,
`docs/roadmap.md` y `specs/`. **Aprobar antes de seguir.**

---

## 5. Recorrer las etapas (siempre con aprobación)

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

En cada etapa el agente usa su skill correspondiente y se detiene con
`ask_user_question` (DSH) o pregunta en el chat (Cline).

Cada spec se hace con su bucle completo (spec → clarificación → plan → tareas →
implementación → validación), de una en una, en el orden de `docs/roadmap.md`.

---

## 6. Mantener la sincronización

- **Cambio** → `sdd-change`: primero la spec, luego el código; deja fichero en
  `specs/NNN-*/changes/` + línea en `CHANGELOG.md`.
- **Checks** (al final de cada batch y en CI):
  ```powershell
  python scripts/check_spec_sync.py
  python scripts/check_data_dict.py
  ```

---

## Diferencias DSH vs Cline

| | DSH | VS Code + Cline |
|---|---|---|
| Skills en | `.dsh/skills/` | `.cline/skills/` (v3.48+) |
| Reglas fijas | `AGENTS.md` + persona del preset | `AGENTS.md` + `.clinerules/` |
| Modo SDD | agent preset `sdd` (ver `presets/dsh/sdd/`) | Plan/Act + `.clinerules/` |
| Aprobación | `ask_user_question` / modo plan | Plan mode + aprobación nativa de Cline |
| Checks | scripts (mismo) | scripts (mismo) |

**Sí es posible con Cline**: el método es el mismo (specs + skills + checks), solo
cambian las rutas y el mecanismo de aprobación.
