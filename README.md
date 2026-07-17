<!--
  NeuroCoreLab — README (bilingual EN / ES)
  English first, Español abajo.
-->

# 🧪 NeuroCoreLab

> A portable, model-agnostic **"second brain" for AI coding agents** — your identity,
> repos, decisions and projects, loaded into every session. Install it, answer a short
> setup interview, and your agent starts every session already knowing your context.

**NeuroCoreLab is the shareable, work-focused edition** of a personal knowledge system
("NeuroCore"). It ships *empty but structured* — a brain with the neurons wired, waiting
for you to fill them. Nothing about the original author is baked in.

---

## English

### What it is
A file-based context layer for AI agents (Claude Code and others). Everything is plain,
git-versioned Markdown you can read and own — not a black-box vector database.

- **Agnostic to you** — you configure your own identity, repos, accounts and connectors.
- **Agnostic to your machine** — point it at any directories.
- **Agnostic to the model** — it's just files an agent reads.

### The brain, made literal
| Cognitive part | In NeuroCoreLab |
|---|---|
| Neuron | an atomic `.md` note with typed frontmatter (`type`, `name`, `description`, links) |
| Synapse | `[[links]]` between neurons + pointers to external repos/projects |
| Working memory (cortex) | `INDEX.md` — lightweight, loaded into every session |
| Reflexes | skills (`ncl-*`) the agent can run |
| Consolidation | the sync ritual — turning a session into long-term neurons |
| Senses | adapters that perceive your repos, accounts and connectors |

### Install & first run
```bash
git clone https://github.com/felipeubidots/neurocorelab.git ~/neurocorelab
cd ~/neurocorelab
```
Open the folder with your AI agent and run the onboarding:
```
/ncl-init
```
It interviews you (in English or Spanish) and configures — **immediately** — everything
the author built up by hand: identity, repo map, accounts, connectors. On every later
session, a hook reminds you if setup is still pending.

### Layout
```
INDEX.template.md      → your cortex (copied to INDEX.md on init)
config/*.template.md   → identity, repos, accounts, connectors (filled on init)
docs/neuron-schema.md  → the neuron spec (the product's "API")
templates/             → neuron / decision / project templates
.claude/skills/ncl-*   → onboarding and brain skills
bin/                   → scaffolding + repo-map refresh (agnostic)
decisions/ projects/ proposals/ memory/ → where your neurons live
```

### Relationship to NeuroCore (global)
NeuroCoreLab is the **work lab**: lighter, distributable, for colleagues. A fuller
personal edition ("NeuroCore global") is where broader life-management learnings mature.
Learnings flow Lab → global; the distributable stays lean.

---

## Español

### Qué es
Una capa de contexto basada en archivos para agentes de IA (Claude Code y otros). Todo es
Markdown plano, versionado en git, que puedes leer y poseer — no una base vectorial caja-negra.

- **Agnóstico a ti** — configuras tu propia identidad, repos, cuentas y conectores.
- **Agnóstico a tu máquina** — apúntalo a cualquier carpeta.
- **Agnóstico al modelo** — son solo archivos que un agente lee.

### El cerebro, hecho literal
| Parte cognitiva | En NeuroCoreLab |
|---|---|
| Neurona | una nota `.md` atómica con frontmatter tipado (`type`, `name`, `description`, enlaces) |
| Sinapsis | `[[enlaces]]` entre neuronas + punteros a repos/proyectos externos |
| Memoria de trabajo (córtex) | `INDEX.md` — ligero, cargado en cada sesión |
| Reflejos | skills (`ncl-*`) que el agente ejecuta |
| Consolidación | el ritual de sync — convertir una sesión en neuronas de largo plazo |
| Sentidos | adaptadores que perciben tus repos, cuentas y conectores |

### Instalar y primer arranque
```bash
git clone https://github.com/felipeubidots/neurocorelab.git ~/neurocorelab
cd ~/neurocorelab
```
Abre la carpeta con tu agente de IA y corre el onboarding:
```
/ncl-init
```
Te entrevista (en inglés o español) y configura — **de inmediato** — todo lo que el autor
armó a mano: identidad, mapa de repos, cuentas, conectores. En cada sesión posterior, un
hook te recuerda si la configuración sigue pendiente.

### Relación con NeuroCore (global)
NeuroCoreLab es el **laboratorio de trabajo**: más liviano, distribuible, para compañeros.
Una edición personal más completa ("NeuroCore global") es donde maduran los aprendizajes
de autogestión de vida. El aprendizaje fluye Lab → global; lo distribuible se mantiene liviano.

---

_Licencia y distribución: por definir. NeuroCoreLab no incluye datos de ningún usuario;
cada instancia es privada de quien la configura._
