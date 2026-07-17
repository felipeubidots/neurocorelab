# NeuroCoreLab skills

Run these to operate the brain at full power. The repo is English; each skill talks to you in
your language (set during `/ncl-init`).

| Skill | What it does |
|---|---|
| `/ncl-init` | **Onboarding.** Interviews you and configures your instance: identity, repos, accounts, connectors. Also wires the statusline + hooks. Run first. |
| `/ncl-accounts` | **Multi-account.** Sets up 2+ Claude Code accounts on one machine — isolated credentials, shared context, no daily `/login`. See `multi-account.md`. |
| `/ncl-sync` | **Consolidate.** Turns the session into long-term neurons (decisions, cortex updates), stamped by the active account. The brain's "sleep". |
| `/ncl-recall` | **Recall.** Answers from the brain before you re-explain — searches the cortex/config/decisions/projects and cites the source. Read-only. |
| `/ncl-handoff` | **Bridge.** Queues a task for another account (or runs the ones queued for you). For work that needs a specific account's login/MCP. |
| `/ncl-decision` | **Capture.** Records a decision/learning as a `decisions/` neuron (context → decision → why) and points to it from the cortex. |
| `/ncl-project` | **Scaffold.** Sets up a project workspace under `projects/` — internal content or an external pointer to its own repo — and registers it. |
| `/ncl-doctor` | **Audit.** Health-checks the instance (config, scripts, skills, project pointers, account sync, broken links, stale cortex) and offers fixes. |

## The neural connection — how accounts "talk"
NeuroCoreLab lets several Claude accounts on one machine share one brain and see each other's
work. Three layers make it happen:

1. **Shared brain.** All accounts symlink the same setup and point at the same instance, so a
   neuron written by one account is readable by all (see `multi-account.md`).
2. **Consolidation with attribution.** `/ncl-sync` writes what happened and **stamps the active
   account**, so the cortex shows who did what.
3. **Handoffs + session log.** `/ncl-handoff` queues cross-account tasks in `handoffs/`; the
   `SessionStart` hook logs each session (account + time) to `log/sessions.jsonl`.

## Adding your own skills
Skills live in `.claude/skills/<name>/SKILL.md` (Claude Code). Follow the `ncl-*` pattern:
a short frontmatter (`name`, `description`) + numbered steps + explicit rules. Keep them
scaffolding for a ritual — they guide the work, they don't replace your judgment.
