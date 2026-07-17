---
name: ncl-doctor
description: Health-check the NeuroCoreLab instance — config, scripts, skills, project pointers, account sync, broken links, stale cortex — and offer fixes. Usage: /ncl-doctor
---

# Skill: /ncl-doctor — audit the brain's health

Check that the instance is wired correctly and offer to fix what isn't.

Talk to the user in their language.

## Steps
1. Run `bash bin/ncl-doctor.sh` and read its checklist (config present, scripts executable,
   skills well-formed, external project pointers resolve, extra accounts synced).
2. Check what the script can't (read the files):
   - **Broken `[[links]]`** — a synapse pointing to a neuron name that doesn't exist yet.
   - **Stale cortex** — `INDEX.md`'s "updated" stamp far behind recent changes, or "Latest
     decisions" missing recent `decisions/` files.
   - **Malformed neurons** — decisions/projects missing required frontmatter (`type`, `name`).
3. Report a concise checklist: what's healthy, what to fix.
4. **Offer fixes; apply only on confirmation:** `chmod +x bin/*.sh`; run `bin/ncl-refresh.sh`;
   run `bin/ncl-sync-accounts.sh`; run `/ncl-init` if unconfigured; repair a broken pointer or
   link; refresh the INDEX stamp / decisions list.

## Rules
- The script is read-only; every fix is confirmed before applying.
- Don't invent problems — report only what a check actually found.
