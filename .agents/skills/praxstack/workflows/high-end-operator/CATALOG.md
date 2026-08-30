# Catalog — high-end operator prompts

Each row is one paste file. Fill placeholders in square brackets. One prompt per turn.

## 00 Router

| Prompt | Invokes | When |
|---|---|---|
| [CLAUDE-ROUTING.md](00-router/CLAUDE-ROUTING.md) | gstack router, using-superpowers | First wire-up of a repo. Always-on, short. |

## 01 Think

| Prompt | Invokes | When |
|---|---|---|
| [OFFICE-HOURS.md](01-think/OFFICE-HOURS.md) | `/office-hours` or `/gstack-office-hours` | New product idea. Is this worth building? |
| [BRAINSTORM.md](01-think/BRAINSTORM.md) | `brainstorming` | Any creative work before implementation. |
| [ALIGN.md](01-think/ALIGN.md) | wait-what, blank-stare | Lost the thread after weeks. Pointer to `../project-alignment/`. |

## 02 Plan

| Prompt | Invokes | When |
|---|---|---|
| [SPEC.md](02-plan/SPEC.md) | `/spec` or `/gstack-spec` | Vague intent → backlog-ready spec. |
| [WRITING-PLANS.md](02-plan/WRITING-PLANS.md) | `writing-plans` | Spec exists. Write the implementation plan. Do not code. |
| [OPENSPEC-PROPOSE.md](02-plan/OPENSPEC-PROPOSE.md) | `openspec-propose` | One-shot change: design + specs + tasks. |

## 03 Build

| Prompt | Invokes | When |
|---|---|---|
| [BUILD-TDD.md](03-build/BUILD-TDD.md) | `test-driven-development`, `/build` if present | One failing test, then the slice, then stop. |
| [EXECUTE-PLAN.md](03-build/EXECUTE-PLAN.md) | `executing-plans` or `subagent-driven-development` | Plan file exists. Execute task by task. |

## 04 Review

| Prompt | Invokes | When |
|---|---|---|
| [REVIEW.md](04-review/REVIEW.md) | `/review` or `/gstack-review` | Pre-landing diff review. |
| [DESIGN-REVIEW.md](04-review/DESIGN-REVIEW.md) | `/design-review` or `/gstack-design-review` | Live UI looks off. |
| [CSO.md](04-review/CSO.md) | `/cso` or `/gstack-cso` | Security audit, threat model, OWASP. |
| [PLAN-ENG-REVIEW.md](04-review/PLAN-ENG-REVIEW.md) | `/plan-eng-review` | Lock architecture before coding. Plan mode only. |

## 05 Test

| Prompt | Invokes | When |
|---|---|---|
| [QA-ONLY.md](05-test/QA-ONLY.md) | `/qa-only` or `/gstack-qa-only` | Report bugs. Do not fix. |
| [QA.md](05-test/QA.md) | `/qa` or `/gstack-qa` | Find and fix, then re-verify. |
| [HEALTH.md](05-test/HEALTH.md) | `/health` or `/gstack-health` | Typecheck, lint, tests, score. |

## 06 Ship

| Prompt | Invokes | When |
|---|---|---|
| [SHIP.md](06-ship/SHIP.md) | `/ship` or `/gstack-ship` | Tests pass. Create the PR. |
| [LAND.md](06-ship/LAND.md) | `/land-and-deploy` | Merge, deploy, canary. |

## 07 Reflect

| Prompt | Invokes | When |
|---|---|---|
| [RETRO.md](07-reflect/RETRO.md) | `/retro` or `/gstack-retro` | End of week. What shipped. |
| [LEARN.md](07-reflect/LEARN.md) | `/learn` or `/gstack-learn` | What has this repo taught the agent. |

## 08 Debug

| Prompt | Invokes | When |
|---|---|---|
| [INVESTIGATE.md](08-debug/INVESTIGATE.md) | `/investigate` or `/gstack-investigate` | Something is broken. Do not guess. |
| [SYSTEMATIC-DEBUG.md](08-debug/SYSTEMATIC-DEBUG.md) | `systematic-debugging` | Test failed or unexpected behavior. |

## 09 Browser

| Prompt | Invokes | When |
|---|---|---|
| [SCRAPE.md](09-browser/SCRAPE.md) | `/scrape` or `/gstack-scrape` | Read-only extract from a page. |
| [SKILLIFY.md](09-browser/SKILLIFY.md) | `/skillify` or `/gstack-skillify` | Persist the last scrape as a browser-skill. |
| [BROWSE.md](09-browser/BROWSE.md) | `/browse` or `/gstack-browse` | Drive a live page for QA. |

## 10 Research

| Prompt | Invokes | When |
|---|---|---|
| [DEEP-RESEARCH.md](10-research/DEEP-RESEARCH.md) | `deep-research` or `agentic-deep-research` | Cited landscape. Not a product rewrite. |
| [LAST30DAYS.md](10-research/LAST30DAYS.md) | `last30days` | What people are saying in the last 30 days. |

## 11 Session gates (host built-ins)

| Prompt | Invokes | When |
|---|---|---|
| [HOST-GATES.md](11-session/HOST-GATES.md) | `/plan`, `/context`, `/compact`, `/code-review`, `/security-review` | Use the host. Do not reimplement. |

## Sibling (already in this repo)

| Prompt | Path |
|---|---|
| Align + install + qa-only | [`../project-alignment/ALIGN-INSTALL-QA.md`](../project-alignment/ALIGN-INSTALL-QA.md) |
| Align only | [`../project-alignment/ALIGN-ONLY.md`](../project-alignment/ALIGN-ONLY.md) |
| Install packs only | [`../project-alignment/INSTALL-SKILLS.md`](../project-alignment/INSTALL-SKILLS.md) |
