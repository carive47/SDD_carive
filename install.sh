#!/usr/bin/env bash
#
# Instala el modo SDD (Spec-Driven Development) en DeepSeek Harness.
# macOS / Linux.  En Windows usa install.ps1.
#
# 1. Copia las 11 skills a <DSH_HOME>/skills (global: se ven en cualquier carpeta).
# 2. Declara el preset "sdd" en cada perfil (<DSH_HOME>/profiles/*/cordis.patch.yml),
#    con copia de seguridad y sin duplicar si ya estaba.
#
# Despues: SAL del todo de DeepSeek Harness y vuelve a abrirlo.
# Luego elige el preset SDD (Ajustes, o el selector de nueva sesion con
# "Coding Tools" activo).
#
# Uso:
#   ./install.sh
#   DSH_HOME=/ruta/a/.dsh ./install.sh

set -euo pipefail

KIT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DSH_HOME="${DSH_HOME:-$HOME/.dsh}"
SKILLS_SRC="$KIT_ROOT/skills"
DECL="$KIT_ROOT/presets/dsh/sdd.patch.yml"

echo "Kit:      $KIT_ROOT"
echo "DSH home: $DSH_HOME"
echo

if [ ! -d "$SKILLS_SRC" ]; then
  echo "ERROR: no existe $SKILLS_SRC (ejecuta el script desde la raiz del kit)"; exit 1
fi
if [ ! -d "$DSH_HOME" ]; then
  echo "ERROR: no existe $DSH_HOME. Abre DeepSeek Harness al menos una vez y reintenta."; exit 1
fi
if [ ! -f "$DECL" ]; then
  echo "ERROR: no existe $DECL"; exit 1
fi

# --- 1) skills globales -----------------------------------------------------
mkdir -p "$DSH_HOME/skills"
for d in "$SKILLS_SRC"/*/; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"
  rm -rf "${DSH_HOME:?}/skills/$name"
  cp -R "$d" "$DSH_HOME/skills/$name"
done
skill_count="$(find "$DSH_HOME/skills" -name SKILL.md | wc -l | tr -d ' ')"
echo "[1/2] skills instaladas en $DSH_HOME/skills : $skill_count"

# --- 2) preset declarativo en cada perfil -----------------------------------
found=0
for patch in "$DSH_HOME"/profiles/*/cordis.patch.yml; do
  [ -f "$patch" ] || continue
  found=1
  prof="$(basename "$(dirname "$patch")")"

  if grep -q 'preset-sdd' "$patch"; then
    echo "[2/2] $prof: ya tenia preset-sdd (sin cambios)"
    continue
  fi

  cp "$patch" "$patch.bak"

  # Un patch que solo contiene "[]" (array vacio) se reemplaza; si no, se anexa.
  significant="$(grep -v '^[[:space:]]*#' "$patch" | grep -v '^[[:space:]]*$' | tr -d '[:space:]')"
  if [ "$significant" = "[]" ]; then
    tmp="$(mktemp)"
    while IFS= read -r line || [ -n "$line" ]; do
      if printf '%s' "$line" | grep -qE '^[[:space:]]*\[\][[:space:]]*$'; then
        cat "$DECL" >> "$tmp"
      else
        printf '%s\n' "$line" >> "$tmp"
      fi
    done < "$patch"
    mv "$tmp" "$patch"
  else
    printf '\n' >> "$patch"
    cat "$DECL" >> "$patch"
  fi

  echo "[2/2] $prof: preset-sdd anadido (backup: cordis.patch.yml.bak)"
done
[ "$found" -eq 1 ] || echo "[2/2] AVISO: no se encontro ningun perfil con cordis.patch.yml"

echo
echo "Instalado. Sal del todo de DeepSeek Harness y vuelve a abrirlo."
echo "Luego elige el preset SDD (Ajustes, o el selector de nueva sesion con 'Coding Tools' activo)."
echo "Para deshacer: restaura los cordis.patch.yml.bak de cada perfil."
