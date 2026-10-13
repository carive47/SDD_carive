# Context pack: ingestion (origen de datos)

## Principios de constitución (fragmento)
- Los datos entran por **adaptadores intercambiables**; el núcleo no conoce la fuente.
- Toda ingesta es **idempotente**: mismo input → mismo estado.
- Errores por registro, no por lote: un registro corrupto no aborta la ingesta.
- Sin acceso a red si no es imprescindible; si lo es, timeouts y reintentos acotados.

## RFs comunes (EARS — copiar/adaptar)
- RF: CUANDO se recibe un registro válido, EL SISTEMA lo persiste y confirma (idempotente).
- RF: SI llega un registro duplicado, ENTONCES EL SISTEMA no lo inserta dos veces.
- RF: SI un registro es corrupto o inválido, ENTONCES EL SISTEMA lo marca en error y continúa el lote.
- RF: SI la fuente no responde en el tiempo límite, ENTONCES EL SISTEMA reintenta N veces y luego reporta el fallo.
- RF: EL SISTEMA registra un log de ingesta (procesados, errores, timestamp).

## Casos límite típicos
Fuente caída, timeouts, cambios de esquema, late-data (datos que llegan tarde),
valores nulos, codificación, duplicados parciales, reintentos que producen dobles.
