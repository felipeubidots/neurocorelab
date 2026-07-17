---
name: ncl-accounts
description: Set up 2+ Claude Code accounts on one machine (isolated credentials, shared context, no daily /login). Bilingual EN/ES. Usage: /ncl-accounts
---

# Skill: /ncl-accounts — multi-account setup

Help the user run **two or more Claude Code accounts on one machine** the way that actually
works: isolate credentials per account so a token never wipes the primary Keychain login
(Claude Code bug #37512), while sharing setup (skills, CLAUDE.md, MCP, project trust) via
symlink. Full rationale: `docs/multi-account.md`.

Conduct the conversation in the user's language (English / Español).

## 0. Explain briefly, then confirm
Tell the user what this does and what it touches: it creates isolated config dirs
(`~/.claude-<name>`), symlinks shared setup from their primary (`~/.claude`), and prints shell
lines for them to add. It does **not** touch their primary login, and **never handles their
token value** — they paste that into their own shell rc.

## 1. Interview (AskUserQuestion, short)
- **Primary config dir** — default `~/.claude`. Only ask if they use a non-standard location.
- **How many extra accounts**, and a **short name** for each (e.g. `work`, `personal`,
  `client`). Names become the launch command and the `~/.claude-<name>` dir.
- (Optional) whether they want you to append the shell lines to their rc automatically, or just
  print them to paste. **Default: print and let them paste** — appending to a shell rc is
  sensitive; only do it if they explicitly say yes, show the exact lines first, and back up the
  rc.

## 2. Create each account
For each name, run:
```
bash bin/ncl-add-account.sh <name>
```
(Set `CLAUDE_PRIMARY_DIR` first if their primary isn't `~/.claude`.) This creates the isolated
dir, syncs the shared setup, and prints the token + shell-function steps.

## 3. Guide the one-time token steps (do NOT do these for them)
Walk them through the printed steps:
1. `claude setup-token` in the OWNER account of each extra account (tokens expire in 365 days,
   no auto-renew — tell them to note the date).
2. Paste each token into their shell rc as `CLAUDE_TOKEN_<NAME>` next to the printed function.
3. Reload the shell; launch with the account name.

## 4. Record it (agnostic, no secrets)
Fill `config/accounts.md` (from its template) with the accounts: name, how it's detected
(`CLAUDE_CONFIG_DIR=~/.claude-<name>`), and notes (e.g. token owner, renewal date). **Never
write token values** — only their env-var names.

## 5. Maintenance note
Tell them: after adding an MCP / skill / trusting a new project in the primary, re-run
`bash bin/ncl-sync-accounts.sh` (idempotent) so the extra accounts inherit it.

## Rules
- Never handle, print, or store a token value. The user pastes tokens into their own rc.
- Never modify or copy the primary account's credentials/`oauthAccount`.
- Show any shell-rc edit before making it; prefer printing lines to paste. Back up rc if editing.
- Hosted claude.ai connectors (Calendar/Gmail/Drive) load only on interactive login, not via
  token — set expectations; MCP over URL/npx works everywhere.
