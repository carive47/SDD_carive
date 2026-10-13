# Context pack: etl (tipos de procesamiento)

## Principios de constitución (fragmento)
- Pipelines por **etapas separadas y testeables** (extract → transform → load).
- Cada etapa es **reintentable e idempotente**; los checkpoints permiten reanudar.
- La lógica de transformación es pura (sin I/O) para poder testearla aislada.
- Nada de estado global entre ejecuciones salvo lo persistido explícitamente.

## RFs comunes (EARS — copiar/adaptar)
- RF: CUANDO se ejecuta el pipeline, EL SISTEMA procesa las etapas en orden y persiste un checkpoint entre ellas.
- RF: SI una etapa falla, ENTONCES EL SISTEMA reintenta N veces y luego marca el lote como fallido sin procesar etapas posteriores.
- RF: EL SISTEMA produce un resumen de ejecución (procesados, errores, duración) al terminar.
- RF: MIENTRAS existan registros pendientes de una ejecución anterior, EL SISTEMA los retoma en la siguiente sin duplicarlos.

## Casos límite típicos
Reintentos, ejecuciones solapadas, dependencias entre etapas, datos que llegan a
medias, transformaciones que dependen del orden, backfills históricos.
