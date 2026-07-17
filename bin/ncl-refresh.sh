#!/usr/bin/env bash
# ncl-refresh.sh — regenerate the repo map from the configured root(s).
# Agnostic: reads the root(s) the user set in config/repos.md ("Root(s):" line) and writes a
# git-aware listing between the NCL:MAP markers.
set -uo pipefail
DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
CFG="$DIR/config/repos.md"

[ -f "$CFG" ] || { echo "config/repos.md missing — run /ncl-init first."; exit 1; }

# Parse the "Root(s):" line: strip the label, any inline HTML comment, trailing whitespace.
roots_line="$(grep -m1 -E '\*\*Root' "$CFG" | sed -E 's/^[^:]*:\*\* *//; s/<!--.*-->//; s/[[:space:]]+$//')"
[ -n "$roots_line" ] || { echo "No repo root configured in config/repos.md."; exit 1; }

map=""
IFS=',' read -ra ROOTS <<< "$roots_line"
for raw in "${ROOTS[@]}"; do
  root="${raw//[[:space:]]/}"; root="${root/#\~/$HOME}"
  if [ ! -d "$root" ]; then map+="- _(root not found: $raw)_"$'\n'; continue; fi
  map+="- **$root**"$'\n'
  for d in "$root"/*/; do
    [ -d "$d" ] || continue
    name="$(basename "$d")"
    if [ -d "$d/.git" ]; then
      desc="$(head -1 "$d/README.md" 2>/dev/null | sed 's/^#* *//' | cut -c1-90)"
      map+="  - \`$name\` — ${desc:-—}"$'\n'
    else
      map+="  - \`$name\` _(no-git)_"$'\n'
    fi
  done
done

# Splice the map between the markers (python: robust).
MAP="$map" python3 - "$CFG" <<'PY'
import os, sys
cfg = sys.argv[1]
mp = os.environ.get('MAP', '').rstrip('\n')
lines = open(cfg).read().split('\n')
out, skip = [], False
for ln in lines:
    if 'NCL:MAP:START' in ln:
        out.append(ln)
        if mp:
            out.extend(mp.split('\n'))
        skip = True
        continue
    if 'NCL:MAP:END' in ln:
        skip = False
        out.append(ln)
        continue
    if not skip:
        out.append(ln)
open(cfg, 'w').write('\n'.join(out))
PY
echo "✓ repo map updated in config/repos.md"
