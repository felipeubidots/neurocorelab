---
name: ncl-recall
description: Answer from the brain before re-contextualizing — search the cortex, config, decisions and projects, and answer concisely citing the source. Read-only. Usage: /ncl-recall [question]
---

# Skill: /ncl-recall — answer from the brain

Before asking the user to re-explain something, search the brain and answer from it.

Talk to the user in their language.

## Steps
1. Search `INDEX.md`, `config/`, `decisions/`, `projects/`, `proposals/` for what's relevant to
   the question.
2. Answer concisely, **citing the source neuron (its path)** as a pointer so the user can open
   the detail.
3. If nothing relevant is found, say so plainly — do not invent an answer.

## Rules
- **Read-only.** Never write during a recall.
- Prefer the pointer over dumping full file contents.
