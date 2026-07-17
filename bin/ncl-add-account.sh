#!/usr/bin/env bash
# ncl-add-account.sh <name> — set up an extra Claude Code account that shares your
# context but keeps its credentials isolated, so it never wipes your primary login
# (Claude Code #37512). Creates the isolated config dir, syncs the shared setup, and
# prints the shell function + token steps for you to add. It NEVER handles your token.
#   Env: CLAUDE_PRIMARY_DIR (default ~/.claude)
set -euo pipefail

name="${1:-}"
[ -n "$name" ] || { echo "Usage: ncl-add-account.sh <name>   (e.g. work, personal)"; exit 1; }

PRIMARY="${CLAUDE_PRIMARY_DIR:-$HOME/.claude}"
DIR="$PRIMARY-$name"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UPPER="$(printf '%s' "$name" | tr '[:lower:]-' '[:upper:]_')"

mkdir -p "$DIR"
echo "✓ isolated config dir: $DIR"
bash "$HERE/ncl-sync-accounts.sh"

cat <<EOF

── Do this once ──────────────────────────────────────────────
1) Generate a token in the OWNER account of "$name":
     claude setup-token
   (Tokens expire after 365 days and do NOT auto-renew — note the date.)

2) Add to your shell rc (~/.zshrc or ~/.bashrc):
     CLAUDE_TOKEN_$UPPER=<paste-token-here>
     function $name { CLAUDE_CONFIG_DIR="$DIR" CLAUDE_CODE_OAUTH_TOKEN="\$CLAUDE_TOKEN_$UPPER" claude "\$@"; }

3) Reload your shell, then launch that account with:  $name
──────────────────────────────────────────────────────────────

Re-run  bin/ncl-sync-accounts.sh  whenever you add an MCP/skill or trust a new project.
EOF
