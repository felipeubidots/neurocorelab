---
name: ncl-init
description: Onboarding for NeuroCoreLab — interviews the user and configures their brain (identity, repos, accounts, connectors) on first install. Bilingual EN/ES. Usage: /ncl-init
---

# Skill: /ncl-init — NeuroCoreLab onboarding

You are setting up a fresh NeuroCoreLab instance on this person's machine. The engine ships
empty; your job is to fill it the way the author once did by hand — but for THIS user, fast.
Nothing about any previous user should remain.

## 0. Language first
Detect or ask the user's preferred language (English / Español) and **conduct the whole
interview in that language**. Write config file bodies in that language too. Keep frontmatter
keys in English (they are the schema).

## 1. Guard
If `config/identity.md` already exists, this instance is configured. Do **not** overwrite
silently — summarize the current config and ask whether to (a) reconfigure from scratch,
(b) update one section, or (c) cancel.

## 2. Interview (use AskUserQuestion; keep it short, one topic at a time)
Cover exactly what a NeuroCore instance needs to work. Ask only what you cannot infer; offer
sensible defaults. Topics:

1. **Identity** (`type: identity`) — name, role, email, one line on how they work / what they
   use their agent for.
2. **Repos** (`type: config`) — the root directory(ies) that hold their repos (e.g. `~/dev`,
   `~/work`). Used by `bin/ncl-refresh.sh` to build the map. Agnostic — accept any paths.
3. **Accounts / workspaces** (`type: config`) — the AI accounts or profiles they switch
   between (if any), and how each is detected (e.g. an env var). Optional.
4. **Connectors** (`type: config`) — which MCP servers / integrations they use (Slack,
   trackers, cloud, etc.). Store names and how each is reached (URL/npx/hosted). Optional.
5. **Team** (optional) — only if they manage/collaborate with a team worth remembering.

## 3. Write the instance (from templates, do not invent facts)
For each topic, copy the matching `config/*.template.md` to `config/<name>.md` and fill it
with the user's answers. Leave a field blank/"—" rather than guessing.
- `config/identity.md`, `config/repos.md`, `config/accounts.md`, `config/connectors.md`.
- Copy `INDEX.template.md` → `INDEX.md`, filling `{{USER_NAME}}` and `{{INIT_DATE}}`
  (ask the user for today's date — do not assume it).

## 4. Wire the senses
- Run `bash bin/ncl-refresh.sh` to build the initial repo map into `config/repos.md` / INDEX.
- `.claude/settings.json` ships pre-wired (Claude Code) — confirm it's active:
  - **SessionStart** → reminds future sessions if setup is incomplete.
  - **statusLine** → `bin/ncl-statusline.sh`: shows the brain + the live repo/branch it's
    working in.
  - **PostToolUse** → `bin/ncl-track-workdir.sh`: tracks where the brain actually works so
    the statusline follows the real repo, not the static launch cwd. **This brain + statusline
    combo is a core part of the value** — it ships on by default.
  Make the scripts executable if needed: `chmod +x bin/*.sh`. If the agent isn't Claude Code,
  tell the user to load `INDEX.md` at session start however their tool supports it (the
  statusline/hooks are Claude Code specific).

## 5. Confirm & teach
Show a summary of what was written (files + one line each). Then point the user to:
- `/ncl-init` again to reconfigure.
- **`/ncl-accounts`** if they use (or want) 2+ Claude Code accounts on one machine — isolated
  credentials + shared context, no daily `/login` (see `docs/multi-account.md`).
- `docs/neuron-schema.md` to understand how to add neurons (decisions, projects).
- `templates/` for decision/project/neuron starters.

## Rules
- **Never keep another user's data.** This is a fresh brain for the current user.
- Show what you'll write **before** writing; wait for confirmation on bulk writes.
- Convert relative dates to absolute. Ask for today's date; never assume it.
- Respect the `.gitignore`: filled `config/*.md`, `INDEX.md` and the user's neurons stay
  private to their machine — only templates and the engine are tracked/distributed.
