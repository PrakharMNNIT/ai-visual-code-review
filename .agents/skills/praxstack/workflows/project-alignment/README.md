# Project alignment prompts

Generic, repo-agnostic prompts. Paste into any project after a long stretch of work when you no longer trust that you and the agent want the same thing.

These are **prompts**, not skills. They invoke wait-what, blank-stare, gstack, Superpowers, Matt Pocock setup, OpenSpec, and deep-research **by name**. They do not replace those packs.

The rest of the high-end operator family (Think → Ship, scrape, research, host gates) lives in [`../high-end-operator/`](../high-end-operator/).

## Which file

| File | Use when |
|---|---|
| [ALIGN-INSTALL-QA.md](ALIGN-INSTALL-QA.md) | Default. Three jobs: reconstruct the project, install skill packs, run report-only QA. |
| [ALIGN-ONLY.md](ALIGN-ONLY.md) | Alignment only. No install, no QA. |
| [INSTALL-SKILLS.md](INSTALL-SKILLS.md) | Install the named packs only. No alignment write-up, no QA. |

## How to use

1. Open the file.
2. Copy the fenced prompt.
3. Fill optional placeholders (`HTML source`, QA target URL).
4. Paste into a new agent session in the target repo.
5. Do not paste Sol’s Path investor brief or other project history into the same message.

## What these prompts refuse

- Rewriting existing books or resource catalogs
- Plan-mode gstack reviews (`office-hours`, `plan-ceo-review`, `plan-eng-review`, `autoplan`)
- Starting a `/deep-research` run during install
- Fixing bugs found by qa-only unless you ask after the report
