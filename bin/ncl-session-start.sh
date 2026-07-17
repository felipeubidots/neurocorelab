#!/usr/bin/env bash
# ncl-session-start.sh — SessionStart hook.
# 1) Reminds the user to configure the brain if setup is pending, else shows status.
# 2) Logs the session (account + timestamp) to log/sessions.jsonl — the substrate for
#    the "neural connection": every account records what it did, so accounts can see
#    each other's work (see /ncl-sync and /ncl-handoff). Agnostic; never fails loudly.
set -uo pipefail
DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
STDIN_JSON="$(cat 2>/dev/null || true)"

# Active account from CLAUDE_CONFIG_DIR.
ccd="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"; base="$(basename "$ccd")"
case "$base" in
  .claude)   acct="primary" ;;
  .claude-*) acct="${base#.claude-}" ;;
  *)         acct="$base" ;;
esac

sid="$(printf '%s' "$STDIN_JSON" | python3 -c "import sys,json
try: d=json.load(sys.stdin)
except: d={}
print(d.get('session_id','') or '')" 2>/dev/null || true)"

# Log the session (local, gitignored).
mkdir -p "$DIR/log" 2>/dev/null || true
printf '{"ts":"%s","account":"%s","session":"%s","event":"session_start"}\n' \
  "$(date -u +%FT%TZ)" "$acct" "$sid" >> "$DIR/log/sessions.jsonl" 2>/dev/null || true

# Status line for the session banner.
if [[ ! -f "$DIR/config/identity.md" || ! -f "$DIR/INDEX.md" ]]; then
  echo "🧪 NeuroCoreLab not configured yet — run: /ncl-init"
else
  name="$(grep -m1 -E '^\- \*\*Name' "$DIR/config/identity.md" 2>/dev/null | sed 's/.*:\*\* *//' || true)"
  echo "🧠 NeuroCoreLab · account: ${acct}${name:+ · $name}. Cortex: INDEX.md (load at session start)."
fi
