<!--
  This is the CORTEX TEMPLATE. /ncl-init copies it to INDEX.md and fills {{PLACEHOLDERS}}.
  Keep INDEX.md LIGHT — it loads into every session. Pointers + latest decisions only.
-->

# 🧠 {{USER_NAME}} — NeuroCoreLab index

_NeuroCoreLab actualizado / updated: **{{INIT_DATE}}**._

Auto-loaded every session as the always-present layer: map of what exists, pointers to
detail, and the latest decisions. **Keep it light.**

## How to use / Cómo usar
- Quick context is already loaded here; open the pointed file for detail.
- Update the repo map: `bin/ncl-refresh.sh`.
- Record a decision: create `decisiones/AAAA-MM-tema.md` (see `templates/decision.template.md`).
- Onboarding / reconfigure: run `/ncl-init`.

## Where things live / Dónde está cada cosa
| Need… | File |
|---|---|
| Who I am / Identity | `config/identity.md` |
| Repo map | `config/repos.md` · regenerate with `bin/ncl-refresh.sh` |
| AI accounts / workspaces | `config/accounts.md` |
| Connectors (MCP) | `config/connectors.md` |
| A decision / learning | `decisiones/` |
| A project (internal or external pointer) | `proyectos/<name>/README.md` |
| Proposals under review | `propuestas/<topic>.md` |
| The neuron spec (product API) | `docs/neuron-schema.md` |

## Repos
_Filled by `bin/ncl-refresh.sh` after init._

## Proyectos activos / Active projects
_None yet — create one under `proyectos/`._

## Últimas decisiones / Latest decisions
_None yet — the most recent goes on top._
