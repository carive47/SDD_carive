---
name: sdd-context-pack
description: Captura un patrón reutilizable (dominio o stack) de un proyecto ya validado y lo convierte en un nuevo context pack en contexts/, actualizando INDEX.md. Úsala para extender el repertorio del kit.
---

# Crear/actualizar context pack

El agente puede extender su propio repertorio de contextos.

## Proceso

1. Recibe la petición (p. ej. "captura el patrón de ingestión de este proyecto").
2. Lee `docs/constitution.md` y las specs del proyecto terminado.
3. Extrae lo **reutilizable y genérico** (no lo específico de ese proyecto):
   - Principios de constitución.
   - RFs comunes en EARS (parametrizados).
   - Casos límite típicos.
4. Escribe `contexts/<nombre>.md` con la misma estructura de los packs existentes.
5. Actualiza `contexts/INDEX.md` (nombre, qué aporta, cuándo usarlo).
6. Pide aprobación antes de darlo por añadido.

## Reglas

- No copies nombres de tablas, rutas o reglas del proyecto concreto.
- Si el patrón ya existe, propón actualizarlo en vez de duplicarlo.
- Un pack nuevo no sustituye a la constitución base: se añade encima.
