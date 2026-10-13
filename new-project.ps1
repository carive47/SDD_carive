<#
.SYNOPSIS
  Prepara un proyecto nuevo para Spec-Driven Development (SDD).

.DESCRIPTION
  Copia los assets del kit (templates, contexts, scripts) dentro del proyecto y crea
  la estructura base (docs/, specs/, brief/).

  Las 11 skills SDD ya viven globalmente en ~/.dsh/skills, asi que el agente las ve
  en cualquier carpeta. Usa -WithSkills si ademas quieres que ESTE proyecto sea
  autocontenido (skills dentro de .dsh/skills, util para compartir el repo).

.EXAMPLE
  ./new-project.ps1 -Path C:\ruta\mi-proyecto

.EXAMPLE
  ./new-project.ps1 -Path C:\ruta\mi-proyecto -WithSkills -GitInit
#>
param(
  [Parameter(Mandatory = $true)][string]$Path,
  [string]$KitRoot = $PSScriptRoot,
  [switch]$WithSkills,
  [switch]$GitInit
)

$ErrorActionPreference = 'Stop'
$Path = [System.IO.Path]::GetFullPath($Path)
Write-Host "Kit:     $KitRoot"
Write-Host "Destino: $Path"

if (-not (Test-Path $KitRoot)) { throw "No existe el kit: $KitRoot" }
New-Item -ItemType Directory -Force -Path $Path | Out-Null

foreach ($asset in @('templates', 'contexts', 'scripts')) {
  $src = Join-Path $KitRoot $asset
  if (-not (Test-Path $src)) { throw "No existe $src" }
  $dst = Join-Path $Path $asset
  New-Item -ItemType Directory -Force -Path $dst | Out-Null
  Get-ChildItem $src -Force | ForEach-Object { Copy-Item -Recurse -Force $_.FullName (Join-Path $dst $_.Name) }
  Write-Host "  copiado: $asset"
}

foreach ($dir in @('docs', 'specs', 'brief')) {
  New-Item -ItemType Directory -Force -Path (Join-Path $Path $dir) | Out-Null
}

if ($WithSkills) {
  $dst = Join-Path $Path '.dsh\skills'
  New-Item -ItemType Directory -Force -Path $dst | Out-Null
  Get-ChildItem (Join-Path $KitRoot 'skills') -Directory | ForEach-Object {
    Copy-Item -Recurse -Force $_.FullName (Join-Path $dst $_.Name)
  }
  Write-Host "  skills copiadas en .dsh/skills (proyecto autocontenido)"
}

if ($GitInit -and -not (Test-Path (Join-Path $Path '.git'))) {
  git init $Path | Out-Null
  Write-Host "  git init"
}

Write-Host ""
Write-Host "Listo. Abre una sesion con ese directorio y escribe:"
Write-Host '  "Quiero <idea>. Aplica el flujo SDD: sdd-scaffold, constitucion, spec,'
Write-Host '   clarificacion, plan y tareas, con mi aprobacion en cada etapa."'
