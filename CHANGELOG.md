# Changelog

All notable changes to NeuroCoreLab. Format loosely follows Keep a Changelog.

## [0.1.0] — 2026-07-17
Initial engine — agnostic, distributable, English (bilingual only at onboarding).

### Added
- **Neuron schema** (`docs/neuron-schema.md`) — the file-based knowledge primitive (the "API").
- **Onboarding** — `/ncl-init` (bilingual EN/ES) configures the instance on install: identity,
  repos, accounts, connectors, from `config/*.template.md`.
- **Skills** — `/ncl-accounts`, `/ncl-sync`, `/ncl-recall`, `/ncl-handoff`, `/ncl-decision`,
  `/ncl-project`, `/ncl-doctor`.
- **Brain-aware statusline** + PostToolUse workdir tracker (terminal-agnostic: truecolor → 256
  → none; shows brain · account · repo (branch)).
- **Multi-account** — `docs/multi-account.md` + `bin/ncl-add-account.sh`, `bin/ncl-sync-accounts.sh`
  (isolate credentials, share setup via symlink — the fix for Claude Code #37512).
- **Session log** — `SessionStart` hook records account + timestamp to `log/sessions.jsonl`.
- **`CLAUDE.md`** wiring so Claude Code loads the cortex + skills every session.
- **`.gitignore`** separating the engine (tracked) from the instance (private per machine).
