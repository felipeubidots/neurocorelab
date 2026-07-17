---
name: ncl-sync
description: Consolidate the current session into the brain — capture decisions, update the cortex, stamped by the active account. Usage: /ncl-sync
---

# Skill: /ncl-sync — consolidate the session (the brain's "sleep")

Turn what happened this session into long-term neurons, so every account and future-you can
see it. This is the consolidation step of the brain.

Talk to the user in their language (whatever the session is using).

## Steps
1. **Detect the active account** (from `CLAUDE_CONFIG_DIR`: `~/.claude` → primary,
   `~/.claude-<x>` → `<x>`). You'll stamp the work with it.
2. **Review what changed** this session and propose:
   - New `decisions/YYYY-MM-topic.md` neurons for anything worth keeping (use
     `templates/decision.template.md`). Convert relative dates to absolute — ask for today's
     date, never assume it.
   - Updates to `config/*`, `projects/*` where reality changed.
3. **Keep `INDEX.md` (cortex) light**: refresh pointers + a "Latest decisions" list (most
   recent on top). Stamp each entry with the active account so accounts see who did what.
4. **Show the summary BEFORE writing**; wait for confirmation on bulk writes.
5. If this brain is a git repo, offer to commit (and push) following the repo's commit
   convention.

## Rules
- Never invent — capture only what actually happened.
- Stamp entries with the active account. This is the neural connection: all accounts converge
  to one brain and can read each other's work.
- Don't duplicate what a file already records; link related neurons with `[[name]]`.
