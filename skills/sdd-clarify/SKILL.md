---
name: sdd-clarify
description: 'Revisa una spec como un QA profesional: detecta ambigüedades, contradicciones, casos límite ausentes y conflictos con la constitución. Solo detecta, no resuelve.'
---

# Clarificación de spec

Antes de planificar, valida que la spec no tenga huecos. El objetivo es detectar,
no arreglar: un hueco visible es información; una suposición silenciosa es deuda.

## Proceso

1. Lee `docs/constitution.md` y la spec objetivo.
2. Revisa y produce una **lista numerada** en cuatro bloques:
   1. Ambigüedades restantes.
   2. Contradicciones entre requisitos.
   3. Casos límite no cubiertos.
   4. Conflictos con la constitución.
3. **No propongas soluciones** hasta que el usuario lo pida.
4. Entrega el informe y pregunta al usuario qué hacer (aplicar cambios a la spec
   o continuar). No modifiques la spec sin su aprobación.

## Reglas

- Cita el RF o sección exacta en cada hallazgo.
- Sin juicios de valor ("esto está mal"); describe el problema concreto.
- No reescribas la spec en esta etapa.
