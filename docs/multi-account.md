# Multiple Claude Code accounts — one machine, no daily /login

> Shareable, reproducible guide. Explains the real problem and the fix that works.
> **Secrets (tokens) never live in this repo.** NeuroCoreLab ships the tooling
> (`bin/ncl-add-account.sh`, `bin/ncl-sync-accounts.sh`) and the `/ncl-accounts` skill to set
> this up fast.

## The problem
Running Claude Code with **2+ accounts on one machine** (your primary login + one or more via
token) hits two pains:
1. **Daily `/login`.** Running `claude` with a token wipes the primary account's Keychain login
   on exit — a known Claude Code bug (**#37512**): `CLAUDE_CODE_OAUTH_TOKEN` deletes the
   Keychain item on exit.
2. **Lost context.** Each account starts from zero — no skills, no `CLAUDE.md`, no MCP servers,
   re-trusting every project — if you isolate config to avoid #1.

## The fix (one line)
> **Isolate credentials per account, share setup via symlink.**

Each extra account uses its own `CLAUDE_CONFIG_DIR` (`~/.claude-<name>`), so its token never
touches the primary's Keychain (kills the daily `/login`), while **symlinking** the shared
setup from the primary so it inherits all context without duplication.

| Isolated per account (protects login) | Shared via symlink (inherits context) |
|---|---|
| Credentials / session (Keychain, tokens) | `CLAUDE.md` (incl. NeuroCoreLab `@import`) |
| `projects/`, cache, history | `settings.json`, `settings.local.json` |
| `oauthAccount` (comes from the token) | `skills/`, `commands/`, `plugins/`, `context/`, `output-styles/` |

MCP servers and project **trust** can't be symlinked (they live inside `.claude.json` next to
per-account data), so they're **seeded by copy** with an idempotent script — so integrations
and permissions work without dialogs.

## Setup (fast path)
Run the skill and answer a couple of questions:
```
/ncl-accounts
```
Or do it manually with the helpers:
```bash
bin/ncl-add-account.sh <name>     # e.g. work, personal — creates ~/.claude-<name>, syncs setup
```
Then, **once**, per the script's printed steps:
1. Generate a token in the OWNER account: `claude setup-token` (expires in 365 days, no
   auto-renew — note the date).
2. Add to your shell rc (`~/.zshrc` / `~/.bashrc`):
   ```bash
   CLAUDE_TOKEN_<NAME>=<paste-token>
   function <name> { CLAUDE_CONFIG_DIR="$HOME/.claude-<name>" CLAUDE_CODE_OAUTH_TOKEN="$CLAUDE_TOKEN_<NAME>" claude "$@"; }
   ```
3. Reload the shell and launch that account with: `<name>`.

## The neural connection — accounts that "talk"
All accounts share this one brain (symlinked setup + this instance), so what one account writes,
the others read. On top of that:
- **`/ncl-sync`** consolidates a session into the brain and **stamps the active account**, so the
  cortex shows who did what.
- **`/ncl-handoff`** queues a task for another account (e.g. work that needs an MCP/login only
  that account has) in `handoffs/<account>.md`.
- The `SessionStart` hook logs each session (account + timestamp) to `log/sessions.jsonl`.

## Maintenance
| When | Run |
|---|---|
| Added an MCP / skill / trusted a new project | `bin/ncl-sync-accounts.sh` (idempotent) |
| A token errored / the year is near | `claude setup-token` in the owner account → update `CLAUDE_TOKEN_<NAME>` |

## Notes
- Editing the primary setup once (`~/.claude/CLAUDE.md`, `settings.json`) affects all accounts —
  they symlink to it.
- `ncl-sync-accounts.sh` never copies `oauthAccount` or credentials — that isolation is exactly
  what protects the Keychain (#37512).
- Hosted claude.ai connectors (Calendar/Gmail/Drive) load only on interactive login, not via
  token — a platform limitation, not a config bug. MCP over URL/npx works on all accounts.
