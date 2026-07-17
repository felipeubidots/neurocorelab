#!/usr/bin/env bash
# ncl-sync-accounts.sh — share your primary Claude setup into isolated per-account
# config dirs, so extra accounts (via token) inherit context WITHOUT the token ever
# touching the primary account's Keychain login.
#
# The hard-won fix for Claude Code #37512: isolate credentials per account, share
# setup via symlink. Each extra account uses its own CLAUDE_CONFIG_DIR
# ("$PRIMARY-<name>"). This symlinks the shared setup from the primary and seeds each
# account's isolated .claude.json with MCP servers + project trust. It never copies
# oauthAccount or credentials (that isolation protects the Keychain login).
#
# Idempotent: re-run after adding an MCP, a skill, or trusting a new project.
#   Env: CLAUDE_PRIMARY_DIR (default ~/.claude), CLAUDE_PRIMARY_JSON (default ~/.claude.json)
set -euo pipefail

PRIMARY="${CLAUDE_PRIMARY_DIR:-$HOME/.claude}"
PRIMARY_JSON="${CLAUDE_PRIMARY_JSON:-$HOME/.claude.json}"
SHARED=(CLAUDE.md settings.json settings.local.json skills commands plugins context output-styles)

[ -d "$PRIMARY" ] || { echo "Primary config dir not found: $PRIMARY (set CLAUDE_PRIMARY_DIR)"; exit 1; }

shopt -s nullglob
alias_dirs=( "$PRIMARY"-* )
shopt -u nullglob
if [ ${#alias_dirs[@]} -eq 0 ]; then
  echo "No extra account dirs found ($PRIMARY-*). Create one with: bin/ncl-add-account.sh <name>"
  exit 0
fi

echo "Syncing setup from $PRIMARY ..."
for dir in "${alias_dirs[@]}"; do
  [ -d "$dir" ] || continue
  echo "── $dir"
  # 1) Symlink the shared pieces (only if the source exists).
  for item in "${SHARED[@]}"; do
    src="$PRIMARY/$item"; dst="$dir/$item"
    [ -e "$src" ] || continue
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
      echo "   ⚠️  $item is a real file in the account — left untouched"
    else
      ln -sfn "$src" "$dst"; echo "   🔗 $item"
    fi
  done
  # 2) Seed the isolated .claude.json with mcpServers + project trust (not credentials).
  ALIAS_JSON="$dir/.claude.json" PRIMARY_JSON="$PRIMARY_JSON" python3 - <<'PY'
import json, os
pj = os.environ['PRIMARY_JSON']; path = os.environ['ALIAS_JSON']
prim = json.load(open(pj)) if os.path.exists(pj) else {}
cur = json.load(open(path)) if os.path.exists(path) else {}
cur['mcpServers'] = prim.get('mcpServers', {})
cur['hasCompletedOnboarding'] = True
TRUST = ['hasTrustDialogAccepted','hasCompletedProjectOnboarding','projectOnboardingSeenCount',
         'hasClaudeMdExternalIncludesApproved','hasClaudeMdExternalIncludesWarningShown',
         'mcpServers','enabledMcpjsonServers','disabledMcpjsonServers']
projs = cur.setdefault('projects', {})
for p, c in prim.get('projects', {}).items():
    if isinstance(c, dict) and c.get('hasTrustDialogAccepted'):
        e = projs.setdefault(p, {})
        for f in TRUST:
            if f in c: e[f] = c[f]
tmp = path + '.tmp'; json.dump(cur, open(tmp, 'w'), indent=2); os.replace(tmp, path)
print(f"   🌱 .claude.json seeded (mcp: {len(cur['mcpServers'])}, trusted projects: {sum(1 for v in projs.values() if v.get('hasTrustDialogAccepted'))})")
PY
done
echo "Done."
