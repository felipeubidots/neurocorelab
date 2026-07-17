---
name: ncl-flow
description: Start a focused work session on a topic — the brain loads everything it knows about it, plans around what the active account can and can't do, and pre-wires handoffs for the rest. Usage: /ncl-flow [topic]
---

# Skill: /ncl-flow — "today we work on X"

Prime a focused session: gather all context on a topic, plan around the active account's
capabilities, and queue whatever this account can't finish for the account that can. This is
the session opener that ties together recall, account-awareness, handoff and sync.

Talk to the user in their language.

## Steps
1. **Topic.** Take what the user wants to work on (e.g., "iterate the wellair repo").
2. **Load everything on it (proactive recall).** Find the matching project (internal, or an
   external pointer in `projects/<name>/`) and related decisions/neurons. If it's external,
   open its repo — README, CHANGELOG, recent commits, open items. Summarize: *here's what we
   have on X and where it stands.*
3. **Account awareness.** Detect the active account (`CLAUDE_CONFIG_DIR`: `~/.claude` → primary,
   `~/.claude-<x>` → `<x>`) and read its **capabilities** from `config/accounts.md` — what it
   *can* and *can't* do (e.g., publishing artifacts, a login-only connector, a specific MCP).
   State it plainly: *on this account you CAN … , you CAN'T … .*
4. **Plan the session.** What to do now, here; and explicitly, what must wait for another account.
5. **Pre-wire the handoff.** For the deferred work, queue it for the capable account via
   `/ncl-handoff` (an entry in `handoffs/<account>.md`) with enough context to execute later —
   e.g. *"from this session, update the artifacts to reflect what changed in the repo."*
6. **At session end,** run `/ncl-sync` to consolidate, and confirm the handoff captured what
   actually changed (commits, decisions) so the other account can pick up cleanly.

## Rules
- Don't attempt what the active account can't do — plan it and hand it off.
- Ground the plan in what the brain actually holds; don't invent scope.
- Keep the opening summary tight: what we have, where it stands, the plan, the handoff.
