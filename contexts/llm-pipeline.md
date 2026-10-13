# Context pack: llm-pipeline

## Principios de constitución (fragmento)
- Prompts versionados y en un solo lugar; nunca inline dispersos.
- Toda salida del LLM se valida/parsea; nunca se confía en formato libre.
- Evaluación con ejemplos dorados antes de dar por buena una mejora de prompt.
- Costes y latencias medidos y con límites por operación.

## RFs comunes (EARS — copiar/adaptar)
- RF: CUANDO se llama al modelo, EL SISTEMA envía el prompt versionado y recoge la salida.
- RF: SI la salida no cumple el esquema esperado, ENTONCES EL SISTEMA reintenta N veces y luego devuelve error controlado.
- RF: EL SISTEMA registra latencia, tokens y coste de cada llamada.
- RF: MIENTRAS no haya evaluaciones en verde, EL SISTEMA no promociona un prompt nuevo a producción.

## Casos límite típicos
Respuestas malformadas, alucinaciones, límites de contexto, chunking/embeddings,
rate-limit del proveedor, timeouts, reproducibilidad, seguridad de prompts.
