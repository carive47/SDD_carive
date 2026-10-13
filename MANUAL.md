# Manual de uso — SDD Kit

Guía completa para la **persona** que trabaja con este kit: qué hace el agente,
qué haces tú, qué artefacto produce cada fase y qué decides en cada control.

> Si solo quieres arrancar ya: ve al [QUICKSTART](QUICKSTART.md). Este manual
> explica el *por qué* y el *detalle* de cada paso.

## Índice

1. [La idea en 2 minutos](#1-la-idea-en-2-minutos)
2. [Conceptos que necesitas](#2-conceptos-que-necesitas)
3. [Los artefactos y dónde viven](#3-los-artefactos-y-dónde-viven)
4. [El flujo, fase por fase](#4-el-flujo-fase-por-fase)
5. [El `brief`: meter contexto desde el principio](#5-el-brief-meter-contexto-desde-el-principio)
6. [El contexto y cómo evoluciona](#6-el-contexto-y-cómo-evoluciona)
7. [Tu papel: la supervisión](#7-tu-papel-la-supervisión)
8. [Trabajar solo las etapas iniciales](#8-trabajar-solo-las-etapas-iniciales)
9. [Sincronización y mantenimiento](#9-sincronización-y-mantenimiento)
10. [Preguntas frecuentes](#10-preguntas-frecuentes)
11. [Glosario](#11-glosario)

---

## 1. La idea en 2 minutos

**Spec-Driven Development (SDD)** = antes de escribir código, se escribe **una
especificación** (el QUÉ y el POR QUÉ). El agente implementa a partir de ella.

La diferencia con "pedirle cosas al agente":

| Sin SDD | Con SDD |
|---|---|
| El prompt es la fuente de verdad | La **spec aprobada** es la fuente de verdad |
| Resultado distinto cada vez | Resultado acotado y verificable |
| Nadie sabe qué se decidió | Todo queda escrito y trazado |
| El código se desvía de lo pedido | Un **check automático** lo detecta |

Y la regla que lo hace funcionar: **el humano aprueba cada fase**. El agente
nunca avanza solo.

---

## 2. Conceptos que necesitas

| Concepto | Qué es | Ejemplo |
|---|---|---|
| **Constitución** | Los principios innegociables del proyecto. Se escribe una vez. | "Solo biblioteca estándar"; "toda tabla documentada" |
| **RF** (Requisito Funcional) | Una frase verificable, numerada, en notación **EARS**. | `RF-3: SI el nombre está vacío, ENTONCES EL SISTEMA rechaza la orden.` |
| **EARS** | 5 patrones para escribir requisitos sin ambigüedad. | Ubicuo, evento, estado, opcional, no deseado |
| **Spec** | El documento con contexto, usuarios, historias y RF. Es el contrato. | `specs/001-x/spec.md` |
| **Clarificación** | Revisión tipo QA que **detecta** huecos (no los resuelve). | "RF-7 no aclara qué pasa si hay empate" |
| **Plan** | El CÓMO técnico: módulos, datos, algoritmo, decisiones. | `specs/001-x/plan.md` |
| **Tareas** | El plan troceado en pasos de <30 min, con su "Hecho cuando:". | `T1 … Hecho cuando: tests en verde` |
| **Diccionario de datos** | Cada tabla/campo documentado. Obligatorio. | `docs/data-dictionary.md` |
| **Gate** | El control donde **tú** apruebas o pides cambios. | Aprobar / Pedir cambios / Cancelar |
| **Brief** | Tu contexto crudo de entrada (notas, requisitos, esquemas). | `brief/fuentes-de-datos.md` |
| **Check** | Script que detecta desincronización spec↔código. | `check_spec_sync.py` |

### Los 5 patrones EARS

| Patrón | Forma | Cuándo usarlo |
|---|---|---|
| Ubicuo | EL SISTEMA \<hará\> | Siempre cierto |
| Evento | CUANDO \<disparador\>, EL SISTEMA \<hará\> | Responde a algo |
| Estado | MIENTRAS \<estado\>, EL SISTEMA \<hará\> | Durante una condición |
| Opcional | DONDE \<característica\>, EL SISTEMA \<hará\> | Solo si está presente |
| No deseado | SI \<condición\>, ENTONCES EL SISTEMA \<hará\> | Errores y casos límite |

Regla de oro de una spec: **un requisito, una frase**. Si necesitas un "y" para
unir dos comportamientos, son dos RF.

---

## 3. Los artefactos y dónde viven

Todo lo que produce el flujo queda en **tu repositorio**, versionado:

```
mi-proyecto/
├── AGENTS.md                    # contexto operativo (comandos, estilo, reglas)
├── CLAUDE.md                    # una línea: @AGENTS.md
├── CHANGELOG.md                 # índice de cambios (una línea por batch)
├── brief/                       # TU contexto crudo de entrada (opcional)
├── docs/
│   ├── constitution.md          # constitución = base (invariantes) + proyecto
│   ├── data-dictionary.md       # cada tabla/campo documentado
│   ├── schema.json              # esquema machine-readable (para el check)
│   └── roadmap.md               # qué specs habrá y en qué orden
├── specs/
│   └── 001-mi-feature/
│       ├── spec.md              # EL CONTRATO
│       ├── plan.md              # el CÓMO
│       ├── tasks.md             # el troceado
│       └── changes/             # historial por batch (como commits, en ficheros)
│           └── 2026-08-29-algo.md
├── contexts/                    # context packs de dominio (ETL, API, LLM…)
├── scripts/
│   ├── check_spec_sync.py       # trazabilidad RF ↔ tareas ↔ tests
│   └── check_data_dict.py       # diccionario de datos completo
└── tests/                       # cada test referencia su RF
```

**Quién escribe qué:**

| Artefacto | Lo escribe… |
|---|---|
| `brief/` | **Tú**, antes de empezar |
| `docs/constitution.md` | El agente lo propone; **tú apruebas** |
| `spec.md` | El agente (tras entrevistarte); **tú apruebas** |
| `plan.md`, `tasks.md` | El agente; **tú apruebas** |
| Código y tests | El agente, una tarea cada vez |
| `changes/` + `CHANGELOG.md` | El agente, en cada cambio |

---

## 4. El flujo, fase por fase

El flujo tiene 8 fases. Cada una termina en un **gate**: el agente se para y te
pide aprobación.

```
0 Scaffold → 1 Constitución → 2 Spec → 3 Clarificación → 4 Plan → 5 Tareas
   → 6 Implementación → 7 Validación → 8 Cambio ↺ (vuelve a 2)
```

### Fase 0 — Scaffold (inicializar el proyecto)

**Qué pasa:** el agente pregunta el nombre del proyecto y qué dominios aplican
(ETL, API, LLM…), y crea la estructura completa.

**Sub-pasos:** crea `docs/`, `specs/`, `scripts/`, `contexts/` → escribe
`docs/constitution.md` (base + proyecto) → `AGENTS.md` y `CLAUDE.md` →
`docs/data-dictionary.md` y `docs/schema.json` → `docs/roadmap.md` → copia los
checks a `scripts/` → copia los context packs → **verifica** que los dos checks
salen 0.

**Prompt:**
```
Quiero <tu idea en 1-3 frases>. Usa sdd-scaffold para inicializar el proyecto,
y seguimos el flujo SDD etapa por etapa, esperando mi aprobación.
```

**Gate:** ¿aceptas la estructura y los principios? Si no, pides cambios.

**Sub-fase importante:** dentro del scaffold, la **constitución** (`sdd-constitution`)
propone los principios innegociables del proyecto (máx. 15 líneas). Todo lo que
venga después debe cumplirlos.

---

### Fase 1 — Constitución (si la refinas aparte)

**Qué pasa:** si la constitución del scaffold no te convence, esta skill la
revisa y propone una nueva versión.

**Artefacto:** `docs/constitution.md`.

**Gate:** la aprobación de la constitución es la más importante: **es la que
gobierna todas las specs futuras**.

---

### Fase 2 — Spec (la entrevista)

**Qué pasa:** el agente te hace **preguntas de una en una, máximo 6**, centradas
en casos límite, errores y qué queda fuera. Después escribe la spec.

**Sub-pasos:** lee constitución y specs previas → entrevista (1 pregunta a la
vez) → elige el número libre (`specs/NNN-…`) → redacta con RF en EARS → marca las
dudas como `[NECESITA ACLARACIÓN]`.

**Prompt:**
```
Vamos a redactar la spec de <funcionalidad>. NO escribas código.
Hazme preguntas de UNA en UNA (máx. 6) sobre casos límite, errores y qué queda
fuera. Después genera specs/NNN-<nombre>/spec.md con RF en EARS.
```

**Qué NO debe aparecer en la spec:** stack, arquitectura, nombres de ficheros,
algoritmos. Eso es el **plan** (fase 4). La spec es **QUÉ y POR QUÉ**.

**Gate:** aquí revisas **tú** la spec de verdad: ¿los RF dicen lo que quieres?
¿Falta un caso? ¿Sobra algo?

---

### Fase 3 — Clarificación (QA sobre la spec)

**Qué pasa:** el agente revisa la spec **como un QA** y lista problemas en 4
bloques: ambigüedades, contradicciones, casos límite ausentes y conflictos con la
constitución.

**Importante:** en esta fase el agente **solo detecta, no resuelve**. Tú decides
qué hacer con cada hallazgo.

**Prompt:**
```
Revisa specs/NNN-<nombre>/spec.md como un QA muy profesional. Lista
ambigüedades, contradicciones, casos límite no cubiertos y conflictos con la
constitución. No propongas soluciones todavía.
```

**Gate:** ¿aplicamos cambios a la spec o seguimos?

---

### Fase 4 — Plan (el CÓMO técnico)

**Qué pasa:** convierte la spec en diseño: módulos, modelo de datos, algoritmo,
contrato de la interfaz, decisiones justificadas (con la alternativa descartada)
y estrategia de tests.

**Sub-pasos:** `plan.md` → `docs/data-dictionary.md` (una fila por campo) →
`docs/schema.json`.

**Gate:** ¿el diseño es el que quieres? Aquí se decide el "cómo" — es tu última
oportunidad barata de cambiarlo.

---

### Fase 5 — Tareas

**Qué pasa:** parte el plan en tareas de **máx. 20-30 min**, en orden de
dependencia. Cada una lleva los RF que cubre y una línea `Hecho cuando:`.

**Artefacto:** `specs/NNN-*/tasks.md` con checkboxes.

**Gate:** ¿el troceado es razonable? ¿Falta alguna tarea?

> **Las 5 fases anteriores son las "etapas iniciales".** Mucha gente trabaja solo
> hasta aquí y luego implementa a su ritmo. Ver [sección 8](#8-trabajar-solo-las-etapas-iniciales).

---

### Fase 6 — Implementación (una tarea cada vez)

**Qué pasa:** el agente implementa **UNA sola tarea** (`Tn`): primero los tests,
luego el código, ejecuta la suite, marca la tarea y **se para**.

**Prompt:**
```
Implementa SOLO la tarea T2 de tasks.md, siguiendo plan.md y la constitución.
Escribe primero los tests, luego el código. Ejecuta los tests y muéstrame el
resultado. Marca T2 y PÁRATE. No empieces T3.
```

**Sub-fase clave:** cada test lleva una referencia `RF-x` en su comentario o
docstring. Eso es lo que permite que el check trace la cobertura.

**Gate por tarea:** apruebas cada tarea antes de pasar a la siguiente. Lento a
propósito: así el error se detecta cuando es pequeño.

---

### Fase 7 — Validación

**Qué pasa:** el agente recorre la spec **RF por RF** y dice, para cada uno, qué
test lo cubre y el resultado. Después comprueba los criterios de finalización y
da un veredicto.

**Prompt:**
```
Recorre specs/NNN-<nombre>/spec.md RF por RF: qué test cubre cada uno y el
resultado de ejecutarlo. Si alguno no está cubierto o falla, dilo. Después
comprueba los criterios de finalización y dame un veredicto.
```

**Gate:** ¿spec cumplida sí o no? Si no, vuelve a la fase que toque.

---

### Fase 8 — Cambio (nuevo requisito o mejora)

**Qué pasa:** cuando aparece algo nuevo, **la spec va primero**. El agente
actualiza `spec.md` (y plan/tareas si hace falta), te muestra el **diff**, y solo
después toca el código.

**Prompt:**
```
Nuevo requisito: <X>. NO toques código. Primero actualiza la spec
(nuevo RF en EARS + casos límite) y muéstrame el diff.
```

**Sub-pasos:** spec → (plan/tareas/diccionario si aplica) → tu aprobación →
implementación → validación → **fichero en `specs/NNN-*/changes/`** + línea en
`CHANGELOG.md`.

**Gate:** el diff de la spec. Es la fase que mantiene todo sincronizado.

Después de un cambio, **el flujo vuelve a la fase 2** (nueva spec) o se queda en
la misma spec (si es un ajuste). El bucle no termina hasta que no hay más specs.

---

## 5. El `brief`: meter contexto desde el principio

### ¿Qué es?

Tu **contexto crudo de entrada**: notas, requisitos del cliente, esquemas de
datos, correos, capturas de lo que sea. Es un volcado, **no un prompt**.

### ¿Cuándo usarlo?

| Situación | Qué hacer |
|---|---|
| Tienes una idea de 1-3 frases | **No** hace falta. El agente te entrevista. |
| Tienes MUCHO contexto (ETL complejo, requisitos, esquemas) | **Sí**: créalo **antes** de arrancar. |

### ¿Por qué en ficheros y no en el prompt?

Un prompt gigante desborda el contexto del modelo, mezcla preocupaciones y se
degrada. En ficheros, el agente los lee **bajo demanda**, cuando los necesita.

### Cómo estructurarlo

```
mi-proyecto/
└── brief/
    ├── negocio.md              ← qué hace el proyecto, para quién, por qué
    ├── fuentes-de-datos.md     ← orígenes, formatos, volúmenes, calendarios
    ├── transformaciones.md     ← reglas de negocio del ETL
    ├── requisitos-cliente.md   ← notas, correos, capturas…
    └── esquema-actual.md       ← tablas/columnas si ya existen
```

No hay formato obligatorio: son **tus** notas. Cuanto más concretas, mejor.

### Cómo arrancar con `brief/`

```
Lee brief/ y propón docs/constitution.md + docs/roadmap.md con el desglose en
specs (001, 002…) y su orden. No escribas código. Espera mi aprobación.
```

Fíjate en la diferencia: con `brief/`, el agente **propone el mapa de specs**;
sin él, te entrevista para la primera spec.

---

## 6. El contexto y cómo evoluciona

El agente no "recuerda" entre sesiones: **lee ficheros**. Por eso el contexto vive
en el repo y se lee en cascada:

```
invariantes globales   (constitución base, dentro de la skill)
        ↓
constitución           docs/constitution.md      ← reglas del proyecto
        ↓
contexto operativo     AGENTS.md                 ← comandos, estilo, límites
        ↓
context packs          contexts/*.md             ← patrones de dominio
        ↓
brief                  brief/*.md                ← tu contexto crudo
        ↓
spec → plan → tareas   specs/NNN-*/              ← el trabajo concreto
```

| Capa | Qué decide | Cuándo cambia |
|---|---|---|
| **Invariantes** | Reglas que aplican a TODO proyecto (todo campo documentado, todo RF con test, changelog obligatorio) | Nunca (los pone el kit) |
| **Constitución** | Stack, política de tests, límites, idioma | Una vez por proyecto |
| **AGENTS.md** | Comandos y convenciones del proyecto | Cuando cambia el proyecto |
| **Context packs** | Principios y RF típicos de tu dominio (ETL, API, LLM…) | Al crear el proyecto |
| **Brief** | Tu contexto de entrada | Al empezar |
| **Spec/plan/tareas** | El trabajo | En cada iteración |

**La constitución es el "dial" de adaptación**: el mismo agente SDD sirve para una
CLI, un backend o un pipeline — lo que cambia es la constitución y el `AGENTS.md`.

---

## 7. Tu papel: la supervisión

El kit existe para que **tú** decidas, no para que el agente improvise.

### Los 3 botones de cada gate

| Opción | Cuándo |
|---|---|
| **Aprobar** | Estás de acuerdo. El agente sigue. |
| **Pedir cambios** | Falta o sobra algo. El agente rehace y te lo enseña otra vez. |
| **Cancelar** | Quieres parar y repensar. |

### Qué revisar en cada gate

| Gate | Revisa… |
|---|---|
| Constitución | ¿Los principios son los que quieres para TODO el proyecto? |
| Spec | ¿Los RF dicen lo que quieres? ¿Falta un caso límite? ¿Sobra alcance? |
| Clarificación | ¿Los hallazgos del QA son reales? ¿Qué hacemos con cada uno? |
| Plan | ¿El diseño y las decisiones técnicas te convencen? |
| Tareas | ¿El troceado es razonable? ¿Cada tarea tiene su "Hecho cuando:"? |
| Cada tarea | ¿Los tests pasan? ¿El código hace lo que dice la spec? |
| Validación | ¿El veredicto RF por RF te cuadra? |
| Cambio | ¿El diff de la spec refleja lo que pediste? |

### La regla de oro

**No apruebes sin leer.** El agente puede equivocarse y puede "sonar convincente"
sin ser correcto. El responsable del software eres tú, no el agente.

> Si algo no te cuadra en la spec, **cámbialo ahí** (o pídeselo). Es tu contrato.

---

## 8. Trabajar solo las etapas iniciales

No tienes que usar el flujo completo. Lo normal es:

> **Usar SDD para pensar** (constitución → spec → clarificación → plan → tareas) y
> luego implementar a tu ritmo (con o sin el agente).

Para eso, dilo explícitamente en el prompt inicial:

```
Quiero <idea>. Aplica el flujo SDD SOLO hasta tareas: sdd-scaffold,
sdd-constitution, sdd-spec, sdd-clarify, sdd-plan y sdd-tasks.
Párate en cada etapa para mi aprobación. NO implementes código.
```

Al terminar tendrás **constitución + spec + plan + tareas** listas, y podrás
implementar cuando quieras. Si más adelante quieres retomar con el agente, pídele
`sdd-implement` sobre la tarea que toque.

---

## 9. Sincronización y mantenimiento

El riesgo del desarrollo con IA es que **el código se desvíe de la spec** sin que
nadie se entere. El kit lo evita con 4 capas:

| Capa | Qué hace | Cuándo |
|---|---|---|
| **1. Cambio = spec primero** | Todo cambio nace en la spec | Cada nuevo requisito |
| **2. Trazabilidad RF→test** | Cada tarea y cada test declara su RF | Al planificar e implementar |
| **3. Validación RF por RF** | Recorre la spec y comprueba cobertura | Al cerrar cada spec |
| **4. Checks automáticos** | Scripts que fallan si algo está desincronizado | Al final de cada batch y en CI |

### Los checks

```bash
python  scripts/check_spec_sync.py     # Windows
python3 scripts/check_spec_sync.py     # macOS / Linux
python  scripts/check_data_dict.py
```

- `check_spec_sync.py` → busca RF **sin tarea**, RF **sin test** y tests que
  citan un RF que no existe.
- `check_data_dict.py` → comprueba que cada campo del esquema está documentado en
  `docs/data-dictionary.md`.

Salida `0` = todo en orden; `1` = hay problemas (te los lista).

### El historial de cambios

Cada batch deja un **fichero atómico** en `specs/NNN-*/changes/AAAA-MM-DD-slug.md`
con: motivo, qué cambió en spec/plan/tareas/datos/código y cómo se validó. Más una
línea en `CHANGELOG.md`.

¿Por qué ficheros y no solo commits? Porque un commit dice *qué líneas cambiaron*;
el fichero de cambio dice ***por qué*** y *qué RF* lo justifica.

---

## 10. Preguntas frecuentes

**¿Tengo que escribir yo la spec?**
No. El agente la redacta tras entrevistarte. Tú la **revisas y apruebas** — y
puedes editarla directamente: es tu contrato.

**¿Y si el agente se equivoca en la spec?**
La detectas en el gate de la spec o en la clarificación. Por eso existen: barato
corregir ahí, caro corregir en el código.

**¿Puedo saltarme la clarificación?**
Puedes, pero es donde aparecen los huecos. Cuesta 1 minuto y ahorra retrabajo.

**¿Qué pasa si el código ya existe?**
El flujo sirve igual: la spec describe lo que quieres, y el plan/implementación se
adaptan. También puedes pedir la spec "de lo que ya hay" como punto de partida.

**¿Los checks son obligatorios?**
Recomendados en local, **obligatorios en CI**: un PR con spec desincronizada no
debería mergear.

**¿Puedo usar esto sin DeepSeek Harness?**
Sí: las skills son ficheros `SKILL.md` estándar. Se colocan en `.claude/skills/`,
`.cline/skills/`, `.opencode/skill/`… El método es el mismo.

**¿Varias funcionalidades a la vez?**
Cada una es una spec (`001`, `002`…). Se implementan **de una en una**, en el orden
de `docs/roadmap.md`. Los RF se numeran de forma **global y continua** entre specs
(spec 001 usa RF-1…N; spec 002 continúa en RF-N+1…).

**¿Qué hago si algo del kit falla?**
Repórtalo con el formato: defecto confirmado + cómo reproducirlo + qué esperabas.
Ese formato hace que se arregle rápido.

---

## 11. Glosario

| Término | Significado |
|---|---|
| **SDD** | Spec-Driven Development: desarrollar a partir de una especificación acordada. |
| **EARS** | Notación de 5 patrones para escribir requisitos sin ambigüedad. |
| **RF** | Requisito Funcional, numerado y verificable. |
| **Gate** | Control donde el humano aprueba o pide cambios. |
| **Human-in-the-loop** | El humano decide en cada etapa; el agente no avanza solo. |
| **Spec-anchored** | La spec acompaña al código siempre (doble fuente de verdad sincronizada). |
| **Brief** | Contexto crudo de entrada, en ficheros. |
| **Context pack** | Principios + RF típicos de un dominio (ETL, API, LLM…). |
| **Scaffold** | Inicializar el proyecto con toda la estructura SDD. |
| **Check** | Script que detecta desincronización spec↔código. |
| **Batch** | Un conjunto de cambios que se registra junto en `changes/`. |
