---
name: sdd-spec
description: Entrevista de requisitos y generación de spec.md con RF numerados en notación EARS. Úsala cuando el usuario pida crear, redactar o revisar una especificación.
---

# Generador de specs

Convierte una idea vaga en una especificación acordada. La spec es el contrato:
si algo no está aquí, no se implementa.

## Proceso

1. **Lee el contexto.** `docs/constitution.md`, `docs/roadmap.md`, y las specs
   previas de `specs/` para no contradecir lo acordado.
2. **Entrevista.** Preguntas de **UNA en UNA**, máximo 6, esperando respuesta
   antes de la siguiente. Céntrate en casos límite, comportamiento ante errores
   y qué queda fuera. Solo el QUÉ y el POR QUÉ; nunca el CÓMO.
3. **Elige el número.** Mira `specs/` y usa el siguiente libre con tres dígitos:
   `specs/NNN-<nombre-en-kebab-case>/spec.md`.
4. **Redacta** con `references/spec-template.md`, sin saltarte secciones.
   Criterios de aceptación **siempre en EARS**, numerados RF-1, RF-2, …
5. **Numera RF de forma global y continua** en todo el proyecto (spec 001 usa
   RF-1..N, spec 002 continúa RF-N+1…) para que la trazabilidad sea inequívoca.
6. **Marca lo que no sepas** como `[NECESITA ACLARACIÓN: pregunta concreta]`.
7. **Pide aprobación explícita** al terminar. No pases al plan sin `Aprobar`.

## Reglas

- QUÉ y POR QUÉ. Prohibido stack, arquitectura, nombres de archivos, esquemas,
  algoritmos o firmas: eso va en el plan.
- Incluye **siempre** "Fuera de alcance".
- Un requisito, una frase. Un "y" que une dos comportamientos = dos requisitos.
- Sin adjetivos no medibles.
- Idioma: el de la constitución; si no la hay, el del usuario.

## Notación EARS

| Patrón | Forma |
|---|---|
| Ubicuo | EL SISTEMA \<hará\> |
| Evento | CUANDO \<disparador\>, EL SISTEMA \<hará\> |
| Estado | MIENTRAS \<estado\>, EL SISTEMA \<hará\> |
| Opcional | DONDE \<característica\>, EL SISTEMA \<hará\> |
| No deseado | SI \<condición\>, ENTONCES EL SISTEMA \<hará\> |

## Al revisar (no crear)

Detecta y lista, numerado, en cuatro bloques: (1) ambigüedades,
(2) contradicciones, (3) casos límite no cubiertos, (4) conflictos con la
constitución. No propongas soluciones hasta que te lo pidan.
