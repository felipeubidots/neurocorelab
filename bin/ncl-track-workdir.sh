#!/usr/bin/env bash
# ncl-track-workdir.sh — tracks WHERE the brain is actually working.
#
# Invoked by the PostToolUse hook. Every time the agent touches a file
# (Edit/Write/Read/MultiEdit/NotebookEdit → any tool with tool_input.file_path),
# this derives the git repo of that file and stores it in a per-session state
# file. The statusline reads that state and shows THAT repo + branch, instead of
# the static cwd where the session started.
#
# So if the brain edits in repo-A, the statusline says repo-A; if it jumps to
# repo-B, it follows. It reflects the real work, not where the user is standing.
#
# Shared state (read by the statusline): $HOME/.claude/state/ncl-workdir/<session_id>
# Never fails loudly: whatever happens, it exits 0 so it can't break the tool.
set -uo pipefail

STATE_DIR="$HOME/.claude/state/ncl-workdir"
STDIN_JSON="$(cat 2>/dev/null || true)"

get() { printf '%s' "$STDIN_JSON" | python3 -c "import sys,json
try: d=json.load(sys.stdin)
except: d={}
print(d.get('$1','') or '')" 2>/dev/null || true; }

get_file_path() { printf '%s' "$STDIN_JSON" | python3 -c "import sys,json
try: d=json.load(sys.stdin)
except: d={}
ti=d.get('tool_input') or {}
print((ti.get('file_path') or '') if isinstance(ti,dict) else '')" 2>/dev/null || true; }

SESSION="$(get session_id)"
FILE_PATH="$(get_file_path)"

[ -z "$SESSION" ] && exit 0
[ -z "$FILE_PATH" ] && exit 0

DIR="$(dirname "$FILE_PATH")"
case "$DIR" in
  /*) : ;;
  *)  CWD="$(get cwd)"; [ -n "$CWD" ] && DIR="$CWD/$DIR" ;;
esac
[ -d "$DIR" ] || exit 0

ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null || true)"
[ -z "$ROOT" ] && ROOT="$DIR"

mkdir -p "$STATE_DIR" 2>/dev/null || true
printf '%s\n' "$ROOT" > "$STATE_DIR/$SESSION" 2>/dev/null || true
exit 0
