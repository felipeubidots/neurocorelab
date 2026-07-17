#!/usr/bin/env bash
# ncl-statusline.sh — shows the brain, the active account, and WHERE it is working.
#
# Terminal-agnostic: it renders inside Claude Code (any terminal), and degrades color
# gracefully — truecolor if the terminal advertises it, else 256-color, else none
# (honors NO_COLOR). Output: 🧠 <brain> · <account> · 📂 <repo> (<branch>)
input="$(cat 2>/dev/null || true)"
DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

field() { printf '%s' "$input" | python3 -c "import sys,json
try: d=json.load(sys.stdin)
except: d={}
ws=d.get('workspace') or {}
print(d.get('$1','') or ws.get('$1','') or '')" 2>/dev/null || true; }

sid="$(field session_id)"
cwd="$(field current_dir)"; [ -z "$cwd" ] && cwd="$(field cwd)"

# Active account, from CLAUDE_CONFIG_DIR (agnostic): ~/.claude → "primary", ~/.claude-<x> → "<x>"
ccd="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"; base="$(basename "$ccd")"
case "$base" in
  .claude)   acct="primary" ;;
  .claude-*) acct="${base#.claude-}" ;;
  *)         acct="$base" ;;
esac

# Where is the brain actually working? (set by ncl-track-workdir.sh)
work=""; state="$HOME/.claude/state/ncl-workdir/$sid"
[ -f "$state" ] && work="$(cat "$state" 2>/dev/null || true)"
[ -z "$work" ] && work="$cwd"
repo=""; branch=""
if [ -n "$work" ] && [ -d "$work" ]; then
  root="$(git -C "$work" rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -n "$root" ]; then
    repo="$(basename "$root")"; branch="$(git -C "$work" rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
  else repo="$(basename "$work")"; fi
fi

# Brain label: user's name from identity, else product name.
brain="NeuroCoreLab"
name="$(grep -m1 -E '^\- \*\*Name' "$DIR/config/identity.md" 2>/dev/null | sed 's/.*:\*\* *//' || true)"
[ -n "$name" ] && brain="$name"

# Color: truecolor → 256-color → none. Honor NO_COLOR.
if [ -n "${NO_COLOR:-}" ]; then
  C_A=""; C_OK=""; C_DIM=""; C_R=""
elif printf '%s' "${COLORTERM:-}" | grep -qiE 'truecolor|24bit'; then
  C_A="\033[38;2;90;139;255m"; C_OK="\033[38;2;92;255;157m"; C_DIM="\033[2m"; C_R="\033[0m"
else
  C_A="\033[38;5;69m"; C_OK="\033[38;5;78m"; C_DIM="\033[2m"; C_R="\033[0m"
fi

out="${C_A}🧠 ${brain}${C_R}"
[ -n "$acct" ]   && out="${out} ${C_DIM}·${C_R} ${acct}"
[ -n "$repo" ]   && out="${out} ${C_DIM}·${C_R} 📂 ${repo}"
[ -n "$branch" ] && out="${out} ${C_OK}(${branch})${C_R}"
printf "%b" "$out"
