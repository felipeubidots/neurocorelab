# 🧪 NeuroCoreLab

> A portable, model-agnostic **"second brain" for AI coding agents** — your identity, repos,
> decisions and projects, loaded into every session. Install it, answer a short setup
> interview (in English or Spanish), and your agent starts every session already knowing your
> context.

**NeuroCoreLab is the shareable, work-focused edition** of a personal knowledge system
("NeuroCore"). It ships *empty but structured* — a brain with the neurons wired, waiting for
you to fill them. Nothing about the original author is baked in.

## What it is
A file-based context layer for AI agents (Claude Code and others). Everything is plain,
git-versioned Markdown you can read and own — not a black-box vector database.

- **Agnostic to you** — you configure your own identity, repos, accounts and connectors.
- **Agnostic to your machine & terminal** — point it at any directories; the statusline renders
  inside Claude Code (any terminal) and degrades color gracefully.
- **Agnostic to the model** — it's just files an agent reads.

## The brain, made literal
| Cognitive part | In NeuroCoreLab |
|---|---|
| Neuron | an atomic `.md` note with typed frontmatter (`type`, `name`, `description`, links) |
| Synapse | `[[links]]` between neurons + pointers to external repos/projects |
| Working memory (cortex) | `INDEX.md` — lightweight, loaded into every session |
| Reflexes | skills (`ncl-*`) the agent can run |
| Consolidation | `/ncl-sync` — turning a session into long-term neurons |
| Senses | adapters that perceive your repos, accounts and connectors |

## Requirements
- **Claude Code** (the statusline, hooks and skills are Claude Code features).
- **macOS or Linux** with `bash`, `git` and `python3`. The multi-account helper uses the macOS
  Keychain model; the rest is cross-platform.

## Install & first run
```bash
git clone https://github.com/ftg-felipe/neurocorelab.git ~/neurocorelab
cd ~/neurocorelab
```
Open the folder with Claude Code. On first open you'll be asked to **trust the folder** — say
yes, so the `SessionStart`/`PostToolUse` hooks and the statusline activate. Then run:
```
/ncl-init
```
It interviews you (**in English or Spanish — your choice at this step**) and configures —
immediately — everything the author once built by hand: identity, repo map, accounts,
connectors. On every later session, a hook reminds you if setup is still pending, and the
`CLAUDE.md` at the repo root loads your cortex (`INDEX.md`) into the session automatically.

> The repo itself is English-only. The *only* bilingual moment is this onboarding, where you
> pick the language the agent talks to you in.

## Skills — operate at full power
| Skill | What it does |
|---|---|
| `/ncl-init` | Onboarding — configures your instance (identity, repos, accounts, connectors). |
| `/ncl-flow` | Start a focused session on a topic — loads all context, plans around the active account's capabilities, pre-wires handoffs. |
| `/ncl-accounts` | Set up 2+ Claude Code accounts on one machine (isolated creds, shared context). |
| `/ncl-sync` | Consolidate the session into the brain (decisions, cortex), stamped by account. |
| `/ncl-recall` | Answer from the brain before re-contextualizing (read-only). |
| `/ncl-handoff` | Cross-account bridge — queue/execute tasks between accounts. |
| `/ncl-decision` | Capture a decision/learning as a neuron (context → decision → why). |
| `/ncl-project` | Scaffold a project workspace (internal, or an external pointer to its own repo). |
| `/ncl-doctor` | Health-check the instance (config, scripts, pointers, account sync) and fix issues. |

Full catalog and how accounts "talk" (the neural connection): **`docs/skills.md`**.

## Live status (brain + statusline)
Set up automatically on init (Claude Code): the status bar shows the brain, the **active
account**, and **where it's actually working** — the live repo and branch of the file the
agent is touching, not the static launch directory. A `PostToolUse` hook tracks the real work
dir; the statusline follows it. Terminal-agnostic (truecolor → 256-color → none).
```
🧠 <you> · <account> · 📂 <repo> (<branch>)
```

## Multiple Claude accounts, no daily /login
Run 2+ Claude Code accounts on one machine the way that actually works: **isolate credentials
per account, share setup via symlink** (the fix for Claude Code bug #37512). `/ncl-accounts`
sets it up fast; full guide in **`docs/multi-account.md`**. All accounts share this one brain,
so they see each other's work (`/ncl-sync`, `/ncl-handoff`).

## Layout
```
INDEX.template.md      → your cortex (copied to INDEX.md on init)
config/*.template.md   → identity, repos, accounts, connectors (filled on init)
docs/                  → neuron-schema (the product's "API"), multi-account, skills
templates/             → neuron / decision / project templates
.claude/skills/ncl-*   → onboarding and brain skills
.claude/settings.json  → SessionStart + statusLine + PostToolUse (brain-aware status)
bin/                   → scaffolding, repo-map refresh, statusline, workdir tracker, account tools
decisions/ projects/ proposals/ memory/ handoffs/ → where your neurons live
```

## Relationship to NeuroCoreEngine
NeuroCoreLab is the **work lab**: lighter, distributable, for colleagues. A fuller personal
edition (**NeuroCoreEngine**) is where broader life-management learnings mature. Learnings flow
Lab → Engine; the distributable stays lean.

---

_License & distribution: TBD. NeuroCoreLab ships no user data; each instance is private to
whoever configures it._
