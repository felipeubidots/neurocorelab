---
name: ncl-decision
description: Record a decision or learning as a decisions/YYYY-MM-topic.md neuron and point to it from the cortex. Usage: /ncl-decision [topic]
---

# Skill: /ncl-decision — capture a decision as a neuron

Turn a decision or learning into an atomic, linkable neuron so it survives beyond this session.

Talk to the user in their language.

## Steps
1. **Ask for today's date** (never assume it). Convert any relative dates to absolute.
2. Draft `decisions/YYYY-MM-<topic>.md` from `templates/decision.template.md`:
   context → decision → **why** → how to apply. Frontmatter `type: decision`.
3. Link related neurons with `[[name]]`.
4. Add a one-line pointer to `INDEX.md` under "Latest decisions" (most recent on top), stamped
   with the active account (from `CLAUDE_CONFIG_DIR`).
5. **Show it before writing**; confirm.
6. If this brain is a git repo, offer to commit following the repo's convention.

## Rules
- One decision per file (atomic). Capture the **why** — that's the reusable value.
- Don't duplicate what code or git history already records.
