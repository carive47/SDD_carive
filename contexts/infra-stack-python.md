# Context pack: infra-stack-python

## Principios de constitución (fragmento)
- Python 3.12+; type hints en todas las funciones públicas.
- Solo biblioteca estándar en la app; dependencias mínimas y justificadas.
- Tests con pytest; separados de la lógica (núcleo puro testeable).
- Código e identificadores en inglés; mensajes de usuario en el idioma del proyecto.

## RFs comunes (EARS — copiar/adaptar)
- RF: EL SISTEMA expone un núcleo importable sin efectos secundarios en el import.
- RF: SI una dependencia externa falla, ENTONCES EL SISTEMA la envuelve en un error propio (no propaga el error de la librería).
- RF: EL SISTEMA persiste en un formato legible y versionado (p. ej. JSON) sin sobrescribir datos corruptos.

## Casos límite típicos
Versionado de dependencias, empaquetado (pyproject), entornos virtuales,
diferencias de SO (Windows/macOS/Linux), encoding, fechas/zona horaria.
