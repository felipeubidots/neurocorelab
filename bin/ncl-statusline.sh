#!/usr/bin/env bash
# ncl-statusline.sh — shows the brain and WHERE it is actually working.
#
# Reads the per-session state written by ncl-track-workdir.sh (the PostToolUse
# tracker) and prints: the brain label + the live repo:branch the agent is
# touching, falling back to the current dir. This is the "brain + statusline"
# gain: the status bar reflects real work, not the static launch cwd.
input="$(cat 2>/dev/null || true)"
DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

field() { printf '%s' "$input" | python3 -c "import sys,json
try: d=json.load(sys.stdin)
except: d={}
ws=d.get('workspace') or {}
print(d.get('$1','') or ws.get('$1','') or '')" 2>/dev/null || true; }

sid="$(field session_id)"
cwd="$(field current_dir)"; [ -z "$cwd" ] && cwd="$(field cwd)"

# Where is the brain actually working? (set by the tracker)
work=""
state="$HOME/.claude/state/ncl-workdir/$sid"
[ -f "$state" ] && work="$(cat "$state" 2>/dev/null || true)"
[ -z "$work" ] && work="$cwd"

repo=""; branch=""
if [ -n "$work" ] && [ -d "$work" ]; then
  root="$(git -C "$work" rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -n "$root" ]; then
    repo="$(basename "$root")"
    branch="$(git -C "$work" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
  else
    repo="$(basename "$work")"
  fi
fi

# Brain label: user's name from identity, else the product name.
brain="NeuroCoreLab"
name="$(grep -m1 -E '^\- \*\*Name' "$DIR/config/identity.md" 2>/dev/null | sed 's/.*:\*\* *//' || true)"
[ -n "$name" ] && brain="$name"

C_ACCENT="\033[38;2;90;139;255m"; C_OK="\033[38;2;92;255;157m"; C_DIM="\033[2m"; C_R="\033[0m"
out="${C_ACCENT}🧠 ${brain}${C_R}"
[ -n "$repo" ]   && out="${out} ${C_DIM}·${C_R} 📂 ${repo}"
[ -n "$branch" ] && out="${out} ${C_OK}(${branch})${C_R}"
printf "%b" "$out"
