#!/usr/bin/env bash
# NeuroCoreLab — regenerate the repo map from the configured root(s).
# Agnostic: reads the root(s) the user set in config/repos.md ("Root(s):" line).
# Writes a git-aware listing between the NCL:MAP markers.
set -euo pipefail
DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CFG="$DIR/config/repos.md"

[[ -f "$CFG" ]] || { echo "config/repos.md missing — run /ncl-init first."; exit 1; }

# Parse the "Root(s):" line (comma-separated), expand ~.
roots_line="$(grep -m1 -E '\*\*Root' "$CFG" | sed 's/.*:\*\* *//' || true)"
[[ -n "$roots_line" ]] || { echo "No repo root configured in config/repos.md."; exit 1; }

tmp="$(mktemp)"
IFS=',' read -ra ROOTS <<< "$roots_line"
for raw in "${ROOTS[@]}"; do
  root="${raw//[[:space:]]/}"; root="${root/#\~/$HOME}"
  [[ -d "$root" ]] || { echo "- _(root no encontrado / not found: $raw)_" >> "$tmp"; continue; }
  echo "- **$root**" >> "$tmp"
  for d in "$root"/*/; do
    [[ -d "$d" ]] || continue
    name="$(basename "$d")"
    if [[ -d "$d/.git" ]]; then
      desc="$(head -1 "$d/README.md" 2>/dev/null | sed 's/^#* *//' | cut -c1-90)"
      echo "  - \`$name\` — ${desc:-—}" >> "$tmp"
    else
      echo "  - \`$name\` _(no-git)_" >> "$tmp"
    fi
  done
done

# Splice between markers.
awk -v f="$tmp" '
  /NCL:MAP:START/ {print; while((getline line < f)>0) print line; skip=1; next}
  /NCL:MAP:END/   {skip=0}
  !skip {print}
' "$CFG" > "$CFG.new" && mv "$CFG.new" "$CFG"
rm -f "$tmp"
echo "✓ repo map updated in config/repos.md"
