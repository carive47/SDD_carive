# Modo SDD para DeepSeek Harness (0.2.x)

Esta carpeta contiene la **declaración declarativa** del preset `sdd` para las
versiones 0.2.x de DSH (la arquitectura que usan tanto la app de escritorio como
`dsh web` en este equipo).

## Instalación (para un compañero)

Desde la raíz del kit:

```powershell
./install.ps1
```

El instalador hace tres cosas:

1. Copia las 11 skills a `<DSH_HOME>/skills` (global: se ven en cualquier carpeta).
2. Declara el preset `sdd` en cada perfil de DSH
   (`<DSH_HOME>/profiles/*/cordis.patch.yml`), con copia de seguridad y sin
   duplicar si ya estaba.
3. Verifica el YAML resultante (si encuentra node + js-yaml).

Después **hay que salir del todo de DeepSeek Harness y volver a abrirlo**.

Para elegir el modo:

- **Ajustes (Settings)** → el preset aparece como **tarjeta** (`SDD`).
- **Nueva sesión** → selector de preset. Requiere **"Coding Tools" activado** en
  Ajustes → General (con ellos apagados, la doc de DSH dice que el selector de
  nueva sesión desaparece).

Opciones del instalador:

```powershell
./install.ps1 -SkillsOnly              # solo las skills, sin tocar perfiles
./install.ps1 -DshHome 'D:\otro\dsh'   # otra raíz de configuración
```

Deshacer: restaura los `cordis.patch.yml.bak` que deja en cada perfil.

## Ficheros de esta carpeta

| Fichero | Qué es |
|---|---|
| `sdd.patch.yml` | La declaración del preset `sdd` (persona SDD + plugins de `standard`). Es lo que el instalador inserta en el perfil. |
| `standard.patch.yml` | Copia de la declaración `standard` de esta build, usada como plantilla de referencia (por si hay que actualizar `sdd.patch.yml`). |

## Por qué no es una carpeta de preset

Las versiones **0.2.x** de DSH usan presets **declarativos**: el registro dice
literalmente que *"neither scans directories nor accepts preset paths"*. Un preset
nuevo es una fila de bundle insertada en el perfil. (Las versiones **0.1.x**
usaban carpetas en `~/.dsh/.agent-presets/`; ese formato **no** se usa aquí.)

## Nota sobre las skills

Las skills viven en `<DSH_HOME>/skills` (global), no dentro del preset: el preset
monta `skill-filesystem` con sus raíces por defecto, que incluyen esa carpeta.
`sdd-scaffold` es autocontenida (sus plantillas, context packs y checks viajan en
`sdd-scaffold/references/`), así que no hace falta copiar nada a mano por proyecto.
