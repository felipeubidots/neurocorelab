#!/usr/bin/env bash
# NeuroCoreLab — SessionStart hook.
# Reminds the user to configure their brain if setup is still pending, and otherwise
# surfaces the cortex path. Agnostic: no user data here.
set -euo pipefail
DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

if [[ ! -f "$DIR/config/identity.md" || ! -f "$DIR/INDEX.md" ]]; then
  echo "🧪 NeuroCoreLab no configurado / not configured yet — corre/run: /ncl-init"
else
  name="$(grep -m1 -E '^\- \*\*Name' "$DIR/config/identity.md" 2>/dev/null | sed 's/.*:\*\* *//' || true)"
  echo "🧠 NeuroCoreLab activo${name:+ · $name}. Córtex: INDEX.md (cargar al inicio de sesión)."
fi
