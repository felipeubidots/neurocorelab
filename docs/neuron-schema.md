# The Neuron — schema

> The neuron is NeuroCoreLab's core primitive and its de-facto **API**: every unit of knowledge
> is one small Markdown file with typed frontmatter. Keep them atomic (one fact, one decision,
> one project per file) so they can be linked and recalled precisely.

## Frontmatter
```markdown
---
name: <short-kebab-case-slug>          # unique id, used by [[links]]
type: identity | config | decision | project | reference | skill | memory
description: <one line — used to judge relevance on recall>
created: YYYY-MM-DD                     # absolute date (never "today")
links: [other-neuron-name, ...]         # optional; synapses
---

<body — the knowledge itself. Link related neurons inline with [[their-name]].>
```

## Types
| type | What it holds |
|---|---|
| `identity` | Who the user is: name, role, how they work. **User-provided (never shipped).** |
| `config`   | Environment facts: repo roots, accounts, connectors, terminal. |
| `decision` | A decision or learning worth keeping. Body: context → decision → why. |
| `project`  | An engagement/initiative. Can be *internal* (content here) or *external* (a pointer/stub to its own repo). |
| `reference`| Pointer to an external resource (URL, dashboard, ticket). |
| `skill`    | A repeatable procedure the agent runs (`ncl-*`). |
| `memory`   | A durable fact/preference surfaced across sessions. |

## Synapses
- `[[neuron-name]]` links neurons. A link to a not-yet-written neuron is fine — it marks
  something worth writing later.
- **External pointer:** a `project` neuron may be a *stub* whose body points at another repo
  (local path + remote URL + one-paragraph context). The brain "knows" the project without
  hosting its (possibly confidential/heavy) content.

## Cortex
`INDEX.md` is working memory: it loads into every session, so keep it **light** — pointers and
the latest decisions, not full content. Detail lives in the neuron files it points to.

## Consolidation
Turning a session into long-term neurons (`/ncl-sync`) is like sleep fixing memory: capture
decisions as `decision` neurons, update `config`/`project`, keep the cortex trimmed, and stamp
which account did the work so accounts can see each other's contributions.
