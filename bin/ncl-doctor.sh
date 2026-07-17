#!/usr/bin/env bash
# ncl-doctor.sh — health check for a NeuroCoreLab instance. Read-only: it reports
# issues; the /ncl-doctor skill proposes and applies fixes. Agnostic.
set -uo pipefail
DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
ok=0; warn=0
say_ok()   { echo "✓ $1"; ok=$((ok+1)); }
say_warn() { echo "⚠️  $1"; warn=$((warn+1)); }

echo "NeuroCoreLab doctor — $DIR"

# 1. Configured?
[ -f "$DIR/config/identity.md" ] && say_ok "identity configured" || say_warn "not configured — run /ncl-init"
[ -f "$DIR/INDEX.md" ] && say_ok "cortex (INDEX.md) present" || say_warn "INDEX.md missing — run /ncl-init"

# 2. Scripts executable
for s in "$DIR"/bin/*.sh; do
  [ -x "$s" ] && say_ok "executable: ${s#"$DIR"/}" || say_warn "not executable: ${s#"$DIR"/} (chmod +x)"
done

# 3. Skills well-formed
for d in "$DIR"/.claude/skills/*/; do
  [ -f "${d}SKILL.md" ] && say_ok "skill: $(basename "$d")" || say_warn "skill missing SKILL.md: $(basename "$d")"
done

# 4. External project pointers resolve
shopt -s nullglob
for p in "$DIR"/projects/*/README.md; do
  lp="$(grep -m1 -iE 'local repo' "$p" 2>/dev/null | sed 's/.*: *//; s/`//g; s/ *$//')"
  lp="${lp/#\~/$HOME}"
  [ -n "$lp" ] || continue
  [ -d "$lp" ] && say_ok "project pointer ok: $(basename "$(dirname "$p")") → $lp" \
               || say_warn "project pointer broken: $(basename "$(dirname "$p")") → $lp not found"
done
shopt -u nullglob

# 5. Extra accounts synced?
PRIMARY="${CLAUDE_PRIMARY_DIR:-$HOME/.claude}"
shopt -s nullglob
for a in "$PRIMARY"-*; do
  [ -d "$a" ] || continue
  { [ -L "$a/CLAUDE.md" ] || [ -L "$a/skills" ]; } \
    && say_ok "account synced: $(basename "$a")" \
    || say_warn "account not synced: $(basename "$a") — run bin/ncl-sync-accounts.sh"
done
shopt -u nullglob

echo "── $ok ok · $warn to review"
[ "$warn" -eq 0 ]
