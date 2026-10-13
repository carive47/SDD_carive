# Context pack: cli-tool

## Principios de constitución (fragmento)
- Lógica pura separada de la capa CLI; el núcleo no imprime ni lee de consola.
- stdout para resultados, stderr para errores; códigos de salida 0/1 claros.
- Argumentos validados; mensajes de usuario accionables y en el idioma fijado.

## RFs comunes (EARS — copiar/adaptar)
- RF: CUANDO se invoca un comando válido, EL SISTEMA lo ejecuta y sale 0.
- RF: SI faltan argumentos o son inválidos, ENTONCES EL SISTEMA muestra uso y sale con error (≠0).
- RF: SI ocurre un error en ejecución, EL SISTEMA lo escribe en stderr y sale con error.
- RF: EL SISTEMA es idempotente en comandos repetidos cuando corresponde.

## Casos límite típicos
Nombres con espacios, duplicados, mayúsculas, argumentos vacíos, entrada no UTF-8,
comandos encadenados, pipes, señales de interrupción.
