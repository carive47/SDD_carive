# Constitución — <proyecto>

Principios innegociables. Toda spec, plan, tarea y código debe cumplirlos.

## Invariantes globales (aplican a TODOS los proyectos — no modificar)

1. **La spec manda**: ningún comportamiento se implementa si no está en la spec
   activa aprobada. Si falta una decisión, se detiene el trabajo y se pregunta.
2. **Todo RF tiene test**: cada requisito funcional está cubierto por al menos un
   test automático referenciado con `RF-x`. Prohibido avanzar con tests en rojo.
3. **Modelo de datos documentado**: toda tabla/campo del modelo de datos tiene su
   fila en `docs/data-dictionary.md` con descripción, tipo, restricciones y
   ejemplo. `check_data_dict.py` lo verifica.
4. **Trazabilidad**: spec, plan y tareas referencian los RF que cubren;
   `check_spec_sync.py` verifica que no haya RF huérfano ni sin test.
5. **Historial obligatorio**: todo batch de cambios termina con su fichero en
   `specs/NNN-*/changes/` y su línea en `CHANGELOG.md`.
6. **Idioma**: código e identificadores en inglés; mensajes al usuario y
   documentación en español (salvo decisión contraria abajo).

## Principios del proyecto

<A rellenar por sdd-constitution: stack, separación lógica/interfaz,
persistencia, límites, etc. N principios cortos y verificables.>
