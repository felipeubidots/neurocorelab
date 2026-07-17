---
name: ncl-project
description: Scaffold a project workspace under projects/<name>/ (internal content, or an external pointer to its own repo) and register it in the cortex. Usage: /ncl-project [name]
---

# Skill: /ncl-project — set up a project workspace

Projects come in two shapes:
- **Internal** — content lives here in the brain (typical for light/personal projects).
- **External** — a **stub** pointing to the project's own repo (for sensitive or heavy work,
  e.g. client engagements, shared separately). The brain knows it exists and where it lives,
  but the content stays out.

Talk to the user in their language.

## Steps
1. Ask **internal or external**, and gather context (client/goal, sources, status). Ask for
   today's date — never assume it.
2. Create `projects/<name>/README.md` from `templates/project.template.md`:
   - **internal:** fill context; create `sources/` etc. as needed.
   - **external:** make it a stub — local path + remote URL + one-paragraph context. Do **not**
     copy the project's content into the brain.
3. Register it in `INDEX.md` under "Active projects" (mark external ones as external).
4. **Show before writing**; confirm.

## Rules
- External projects keep confidential/heavy content out of the brain — only the pointer stays.
- Link related decisions/neurons with `[[name]]`.
