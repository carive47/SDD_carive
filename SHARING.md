# Compartir el kit SDD con compañeros

El kit se comparte como **repo de git + instalador**. El repo lleva las skills, las
plantillas, los checks y la declaración del preset; el instalador los coloca en el
`~/.dsh` de cada compañero.

## Windows y macOS/Linux

El kit es **multiplataforma**:

| Pieza | Windows | macOS / Linux |
|---|---|---|
| Instalador | `install.ps1` | `install.sh` |
| Shell del agente | `pwsh` (el preset lo activa) | `bash` (el preset lo activa) |
| Intérprete de los checks | `python` | `python3` |

El preset `sdd` ya trae las dos condiciones de plataforma
(`!!js process.platform ...`), así que **el mismo `sdd.patch.yml` sirve en ambos
sistemas**. Las skills y los scripts de verificación son idénticos.

## Opción A — Git (recomendado)

### Tú, una vez

1. Crea un repo **vacío** en tu GitHub/GitLab (p. ej. `sdd-kit`).
2. Conéctalo y súbelo:

```bash
cd /ruta/a/sdd-kit
git remote add origin <URL_DEL_REPO>
git push -u origin main
```

### Cada compañero

**Windows (PowerShell):**

```powershell
git clone <URL_DEL_REPO>
cd sdd-kit
./install.ps1
```

Si la política de ejecución bloquea el script:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

**macOS / Linux:**

```bash
git clone <URL_DEL_REPO>
cd sdd-kit
./install.sh
```

Si no tiene permiso de ejecución: `bash install.sh`.

Después: **salir del todo de DeepSeek Harness y volver a abrirlo**, y elegir el
preset **SDD** (en Ajustes como tarjeta, o en el selector de nueva sesión con
"Coding Tools" activo en Ajustes → General).

## Opción B — ZIP

1. Comprime la carpeta `sdd-kit` (puedes excluir `.git`) y envíala.
2. El compañero descomprime y ejecuta su instalador (`install.ps1` o `install.sh`).

## Qué recibe exactamente el compañero

- Las **11 skills SDD** en `<DSH_HOME>/skills` (globales: se ven en cualquier
  carpeta y proyecto).
- El **preset `sdd`** declarado en sus perfiles (`cordis.patch.yml`), con copia de
  seguridad previa.
- **Nada más**: no toca sus proyectos, ni sus modelos, ni sus credenciales.

## Requisitos

| Requisito | Nota |
|---|---|
| DeepSeek Harness **0.2.x** | Arquitectura de presets declarativos. |
| PowerShell 5+ (Windows) o bash (macOS/Linux) | Para el instalador. |
| `git` | Solo para clonar (o usa el ZIP). |
| `python` (Windows) / `python3` (macOS/Linux) | Para los checks del proyecto. |
| `node` | Opcional; solo para la verificación YAML del instalador. |

## Actualizar el kit

Tú: `git push`. Ellos:

```bash
git pull
./install.sh    # o ./install.ps1  (idempotente: refresca skills, no duplica preset)
```

Y reiniciar DeepSeek Harness.

## Desinstalar

1. Restaura los `cordis.patch.yml.bak` de cada perfil en `<DSH_HOME>/profiles/*/`.
2. Borra las skills: `<DSH_HOME>/skills`.
3. Reinicia la app.
