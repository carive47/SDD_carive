<#
.SYNOPSIS
  Instala el modo SDD (Spec-Driven Development) en DeepSeek Harness.

.DESCRIPTION
  1. Copia las 11 skills a <DSH_HOME>/skills (global: las ve en cualquier carpeta).
  2. Declara el preset "sdd" en los perfiles de DSH
     (<DSH_HOME>/profiles/*/cordis.patch.yml), con copia de seguridad y sin
     duplicar si ya estaba.
  3. Verifica el YAML resultante si encuentra node + js-yaml.

  Despues: SAL del todo de DeepSeek Harness y vuelve a abrirlo. Luego elige el
  preset SDD (en Ajustes, o en el selector de nueva sesion con "Coding Tools"
  activo en Ajustes > General).

.PARAMETER DshHome
  Raiz de configuracion de DSH. Por defecto $env:DSH_HOME o ~/.dsh.

.PARAMETER SkillsOnly
  Solo instala las skills (no toca los perfiles).

.EXAMPLE
  ./install.ps1
#>
param(
  [string]$DshHome = $(if ($env:DSH_HOME) { $env:DSH_HOME } else { Join-Path $HOME '.dsh' }),
  [switch]$SkillsOnly
)

$ErrorActionPreference = 'Stop'
$kitRoot = $PSScriptRoot
$skillsSrc = Join-Path $kitRoot 'skills'
$declPath = Join-Path $kitRoot 'presets\dsh\sdd.patch.yml'

Write-Host "Kit:      $kitRoot"
Write-Host "DSH home: $DshHome"
Write-Host ""

if (-not (Test-Path $skillsSrc)) { throw "No existe $skillsSrc (ejecuta el script desde la raiz del kit)" }
if (-not (Test-Path $DshHome)) { throw "No existe $DshHome. Abre DeepSeek Harness al menos una vez y reintenta." }

# --- 1) skills globales -----------------------------------------------------
$skillsDst = Join-Path $DshHome 'skills'
New-Item -ItemType Directory -Force -Path $skillsDst | Out-Null
Get-ChildItem $skillsSrc -Directory | ForEach-Object {
  $dest = Join-Path $skillsDst $_.Name
  Remove-Item -Recurse -Force $dest -ErrorAction SilentlyContinue
  Copy-Item -Recurse -Force $_.FullName $dest
}
$skillCount = (Get-ChildItem -Recurse -File $skillsDst -Filter SKILL.md -ErrorAction SilentlyContinue).Count
Write-Host "[1/2] skills instaladas en $skillsDst : $skillCount"

if ($SkillsOnly) {
  Write-Host "Solo skills. Reinicia DeepSeek Harness."
  return
}

# --- 2) preset declarativo en cada perfil -----------------------------------
if (-not (Test-Path $declPath)) { throw "No existe $declPath" }
$decl = ([System.IO.File]::ReadAllText($declPath, [System.Text.Encoding]::UTF8)).TrimEnd()
$enc = New-Object System.Text.UTF8Encoding($false)
$profilesDir = Join-Path $DshHome 'profiles'
$changed = @()

if (-not (Test-Path $profilesDir)) {
  Write-Host "[2/2] AVISO: no existe $profilesDir; no se declaro el preset."
} else {
  foreach ($prof in Get-ChildItem $profilesDir -Directory) {
    $patch = Join-Path $prof.FullName 'cordis.patch.yml'
    if (-not (Test-Path $patch)) { continue }
    $cur = [System.IO.File]::ReadAllText($patch, [System.Text.Encoding]::UTF8)
    if ($cur.Contains('preset-sdd')) {
      Write-Host "[2/2] $($prof.Name): ya tenia preset-sdd (sin cambios)"
      continue
    }
    Copy-Item $patch "$patch.bak" -Force

    # Un patch que solo contiene "[]" (array vacio) se reemplaza; si no, se anexa.
    $lines = [System.IO.File]::ReadAllLines($patch, [System.Text.Encoding]::UTF8)
    $significant = @($lines | Where-Object { $_.Trim() -ne '' -and -not $_.TrimStart().StartsWith('#') })
    if ($significant.Count -eq 1 -and $significant[0].Trim() -eq '[]') {
      $out = foreach ($l in $lines) { if ($l.Trim() -eq '[]') { $decl } else { $l } }
      $new = ($out -join "`n")
    } else {
      $new = $cur.TrimEnd() + "`n`n" + $decl
    }
    [System.IO.File]::WriteAllText($patch, $new, $enc)
    $changed += $prof.Name
    Write-Host "[2/2] $($prof.Name): preset-sdd anadido (backup: cordis.patch.yml.bak)"
  }
  if ($changed.Count -eq 0 -and -not (Test-Path (Join-Path $profilesDir 'desktop'))) {
    Write-Host "[2/2] AVISO: ningun perfil con cordis.patch.yml encontrado."
  }
}

# --- verificacion YAML (si hay node + js-yaml) ------------------------------
$jyCandidates = @(
  (Join-Path $env:APPDATA 'npm\node_modules\@deepseek-ai\dsh\node_modules\js-yaml'),
  (Join-Path $profilesDir 'node_modules\js-yaml')
) | Where-Object { $_ -and (Test-Path $_) }
$jy = $jyCandidates | Select-Object -First 1
if ((Get-Command node -ErrorAction SilentlyContinue) -and $jy) {
  $js = 'const yaml=require(process.env.JY),fs=require("fs");for(const f of process.argv.slice(2)){try{const d=yaml.load(fs.readFileSync(f,"utf8").replace(/!!js\b/g,"!!str"));console.log("  OK   "+f+" ["+(Array.isArray(d)?d.length:"?")+" entradas]");}catch(e){console.log("  BROKEN "+f+": "+e.message.split("\n")[0]);}}'
  $tmp = Join-Path $env:TEMP "sdd-verify.js"
  Set-Content -Encoding UTF8 -Path $tmp -Value $js
  $env:JY = $jy
  $targets = @('desktop', 'web') | ForEach-Object { Join-Path $profilesDir "$_\cordis.patch.yml" } | Where-Object { Test-Path $_ }
  if ($targets) { node $tmp $targets }
  Remove-Item $tmp -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Instalado. SAL del todo de DeepSeek Harness y vuelve a abrirlo."
Write-Host "Luego elige el preset SDD (Ajustes, o el selector de nueva sesion con 'Coding Tools' activo)."
Write-Host "Para deshacer: restaura los cordis.patch.yml.bak de cada perfil."
