# Context pack: api-backend

## Principios de constitución (fragmento)
- Capa de dominio pura separada de la capa HTTP; los endpoints son finos.
- Errores con códigos y mensajes claros; nunca filtrar detalles internos.
- Paginación y límites en toda colección; rate-limit si es servicio público.

## RFs comunes (EARS — copiar/adaptar)
- RF: CUANDO una petición es válida, EL SISTEMA devuelve 2xx con el recurso.
- RF: SI la entrada es inválida, ENTONCES EL SISTEMA devuelve 4xx con error descriptivo.
- RF: SI el recurso no existe, ENTONCES EL SISTEMA devuelve 404.
- RF: SI ocurre un error interno, ENTONCES EL SISTEMA devuelve 500 sin exponer detalles.
- RF: EL SISTEMA valida y sanea toda entrada antes de procesarla.

## Casos límite típicos
Autenticación/roles, paginación, ordenación, filtros, idempotencia de POST,
concurrencia, límites de tamaño, versionado de la API.
