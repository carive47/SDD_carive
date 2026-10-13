# Compartir el kit SDD con compañeros

El kit se comparte como **repo de git + instalador de un comando**. El repo lleva
las skills, las plantillas, los checks y la declaración del preset; el instalador
los coloca en el `~/.dsh` de cada compañero.

## Opción A — Git (recomendado)

### Tú, una vez

1. Crea un repo **vacío** en tu GitHub/GitLab (p. ej. `sdd-kit`).
2. Conéctalo y súbelo:

```powershell
cd C:\Users\usuario\Wseeds\sdd\sdd-kit
git remote add origin <URL_DEL_REPO>
git push -u origin main
```

### Cada compañero

```powershell
git clone <URL_DEL_REPO>
cd sdd-kit
./install.ps1
```

Si la política de ejecución bloquea el script:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

Después: **salir del todo de DeepSeek Harness y volver a abrirlo**, y elegir el
preset **SDD** (en Ajustes como tarjeta, o en el selector de nueva sesión con
"Coding Tools" activo en Ajustes → General).

## Opción B — ZIP

1. Comprime la carpeta `sdd-kit` (puedes excluir `.git`) y envíala.
2. El compañero descomprime y ejecuta `install.ps1` igual que arriba.

## Qué recibe exactamente el compañero

- Las **11 skills SDD** instaladas en `<DSH_HOME>/skills` (globales: se ven en
  cualquier carpeta y proyecto).
- El **preset `sdd`** declarado en sus perfiles (`cordis.patch.yml`), con copia de
  seguridad previa.
- **Nada más**: no toca sus proyectos, ni sus modelos, ni su configuración de
  credenciales.

## Requisitos

| Requisito | Nota |
|---|---|
| Windows + PowerShell | El instalador es `.ps1`. |
| DeepSeek Harness **0.2.x** | Es la arquitectura de presets declarativos. |
| `git` | Solo para clonar (o usa el ZIP). |
| `node` | Opcional; solo para la verificación YAML del instalador. |

## Actualizar el kit

Tú: `git push`. Ellos:

```powershell
git pull
./install.ps1     # idempotente: refresca skills y no duplica el preset
```

Y reiniciar DeepSeek Harness.

## Desinstalar

1. Restaura los `cordis.patch.yml.bak` de cada perfil en `<DSH_HOME>/profiles/*/`.
2. Borra las skills: `Remove-Item -Recurse <DSH_HOME>/skills`.
3. Reinicia la app.
