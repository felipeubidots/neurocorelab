---
name: ncl-handoff
description: Cross-account bridge — queue a task for another account, or list/execute the ones queued for the current account. Usage: /ncl-handoff [task]
---

# Skill: /ncl-handoff — let accounts hand work to each other

Some work must run from a specific account (e.g. an MCP or login only that account has). This
queues it, using the shared brain as the channel.

Talk to the user in their language.

## Model
- One file per target account: `handoffs/<account>.md` — a checklist of pending tasks, each with
  the date, the source account, and one line of context.
- Because all accounts share the brain (symlinked setup + this instance), the target account
  sees what another account queued.

## Usage
- **Queue** (from any account): append a task to `handoffs/<target-account>.md` with today's
  date (ask — never assume), the source account, and context. Confirm before writing.
- **Run** (when in the target account): read `handoffs/<this-account>.md`, help execute each
  task, and check off / remove done items, stamping completion.

## Rules
- Detect the current account from `CLAUDE_CONFIG_DIR` (`~/.claude` → primary, `~/.claude-<x>` → `<x>`).
- Never store secrets in handoff files.
- Show what you'll write before writing.
