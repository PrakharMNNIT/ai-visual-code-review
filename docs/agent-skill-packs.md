# Agent skill packs

This repo vendors Agent Skills packs for Cursor, Claude Code, and Codex.
Refresh with `./scripts/install-agent-skills.sh` then
`node scripts/gen-skills-index.js`. The generated catalog is
[`docs/agent-skills.md`](agent-skills.md).

Skills are **on-demand discovery**, not always-on personality. Read a
`SKILL.md` when the task matches its trigger. Do not load every security
or methodology skill into context on every turn.

## Pipeline (pick one methodology per stage)

```
find-skills → spec (gstack OR spec-kit OR CE, pick one) → interrogate (mattpocock + improve) → implement (pstack/superpowers) → review → ToB security → agent-browser QA → ship → CE compound
```

Never run Compound Engineering, gstack, Superpowers, and pstack on the
same task. CE is the learn/compound layer after a run, not a fourth
parallel methodology.

GitHub Spec Kit is **not vendored**. The repo has no useful `SKILL.md`
tree for this app (only `.github/skills/add-community-extension`). When
a Spec Kit project is wanted, install Specify from the Git tag (not a
random PyPI `specify-cli`) and run:

```
specify init --here --integration cursor-agent
```

`uv` is not assumed in Cloud Agent VMs. If `uv` is available:

```
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

## Why these packs

The bar is a named author or first-party org, an OSI license when one exists,
a `SKILL.md` tree that agents can discover, and a workflow a staff engineer
would actually run. Install count on [skills.sh](https://skills.sh) is a signal,
not a substitute for that bar.

| Pack | Source | Why it is here |
| --- | --- | --- |
| Superpowers | [obra/superpowers](https://github.com/obra/superpowers) | SDLC methodology. Brainstorm, plan, TDD, review, worktrees. |
| Matt Pocock | [mattpocock/skills](https://github.com/mattpocock/skills) | Engineering skills: grill, domain model, code review, TDD. |
| gstack | [garrytan/gstack](https://github.com/garrytan/gstack) | Role-based CEO, design, eng, DX, QA, ship. Pick this **or** Spec Kit **or** CE for spec, not all three. Prefer Claude/Codex until `./setup --host cursor` matches the README ([issue 2361](https://github.com/garrytan/gstack/issues/2361)). |
| pstack | [cursor/plugins pstack](https://github.com/cursor/plugins/tree/main/pstack) | Official Cursor pstack. This workspace runs on Cursor, so this tree is the source, not the Claude Code port. |
| improve | [shadcn/improve](https://github.com/shadcn/improve) | Expensive-model audit that writes plans for cheaper executors. |
| Cursor Team Kit | [cursor/plugins cursor-team-kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit) | Cursor's own CI, review, ship, and verify skills. |
| Vercel Agent Skills | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | First-party web, writing, React, and deploy skills. |
| Addy Osmani | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | Spec → build → test → review → ship, with gates. |
| find-skills | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Skill #0 / discovery only. Not the `npx skills` CLI tree. |
| Trail of Bits | [trailofbits/skills](https://github.com/trailofbits/skills) | Security research and audit. CC-BY-SA-4.0. Discover on demand; do not always-apply every skill. |
| agent-browser | [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) | Agent Skill for the browser CLI. Optional binary: `scripts/install-agent-browser.sh`. |
| Compound Engineering | [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) | Learn/compound layer after a run. Do not combine with gstack + Superpowers + pstack on one task. |
| Anthropic (subset) | [anthropics/skills](https://github.com/anthropics/skills) | `frontend-design`, `webapp-testing`, `mcp-builder`, `skill-creator`, `claude-api` (Apache-2.0). No pptx/xlsx/docx/art/branding/gifs. |
| Awesome Copilot (subset) | [github/awesome-copilot](https://github.com/github/awesome-copilot) | Issue, PR, Actions, and `gh` workflow skills only. Upstream is 400+ skills. |

pstack was previously vendored from [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude), a Claude Code and Codex port of the same skills. That port remains useful on those harnesses. This repo's agents run in Cursor, so the installer clones `cursor/plugins` and copies `pstack/skills`.

Cursor pstack model overrides live at [`.cursor/rules/pstack-models.mdc`](../.cursor/rules/pstack-models.mdc) (`alwaysApply: true`). `scripts/link-agent-skills.sh` copies that file to `~/.cursor/rules/` on Cloud Agent boot.

## Awesome Copilot subset

Vendored skill directories:

- Issues: `github-issues`, `create-github-issue-feature-from-specification`, `create-github-issues-feature-from-implementation-plan`, `create-github-issues-for-unmet-specification-requirements`, `gen-specs-as-issues`, `issue-fields-migration`
- PRs: `copilot-pr-autopilot`, `pr-dashboard`, `pr-screenshots`
- `gh`: `gh-attach`
- Actions / release: `create-github-action-workflow-specification`, `github-actions-efficiency`, `github-actions-hardening`, `github-actions-runtime-upgrade-conventions`, `github-release`

## agent-browser CLI

The Agent Skill is vendored. The CLI is optional and installed by
`scripts/install-agent-browser.sh` on environment boot:

1. `npm install -g agent-browser`, then `agent-browser install` (Chrome for Testing).
2. If `/usr/lib/node_modules` is not writable (typical Cloud Agent VM), the script falls back to `npm install -g --prefix "$HOME/.local"` and prepends `$HOME/.local/bin` to `PATH`.
3. Failures must not fail boot. The skill text is still in git.

This VM: system-global npm failed with `EACCES`. User-prefix install succeeded (`agent-browser 0.27.0` plus Chrome 152). `uv` is not installed, so Spec Kit was not installed via `uv tool install`.

## Also credible, not vendored here

These passed the credibility bar and failed the "this repo needs the files" bar.

| Source | Why skip |
| --- | --- |
| [github/spec-kit](https://github.com/github/spec-kit) | Spec-driven toolkit, not a `SKILL.md` pack for this app. Use `specify init --here --integration cursor-agent` when you want Spec Kit. Do not install random PyPI `specify-cli`. |
| [openai/skills](https://github.com/openai/skills) | Codex and ChatGPT system skills (`skill-creator`). Useful on Codex. Duplicate of what Codex already ships. |
| [agentskills/agentskills](https://github.com/agentskills/agentskills) | The open standard, not a skill pack. |
| [anthropics/skills](https://github.com/anthropics/skills) (remainder) | pptx/xlsx/docx, art, branding, gifs stay upstream. |

Awesome-list scrapes and 50k-skill indexes are discovery surfaces. They are not packs. Use `find-skills` instead of `npx skills add ... --all`.

## Stack cartridges (add when the project uses that stack)

Do **not** vendor these whole-set trees. They rot context on an Express git-review app that does not use that cloud. Clone a pack into the installer only when the product actually depends on that stack.

| Source | When to add |
| --- | --- |
| [microsoft/skills](https://github.com/microsoft/skills) | Azure / Microsoft stack work |
| [aws/agent-toolkit-for-aws](https://github.com/aws/agent-toolkit-for-aws) | AWS API and IaC work |
| [cloudflare/skills](https://github.com/cloudflare/skills) | Workers, Pages, R2, and related Cloudflare products |
| [supabase/agent-skills](https://github.com/supabase/agent-skills) | Supabase backend, auth, or RLS work |

## How to add another pack

1. Confirm license, `SKILL.md` layout, and that it does not duplicate a pack already in `scripts/install-agent-skills.sh`.
2. Append a `pack|owner/repo|skills-subdir|LICENSE-path|allowlist` line to `PACKS`. Leave the allowlist empty to take every skill, or pass comma-separated directory names for a subset.
3. Add a `PACK_META` entry in `scripts/gen-skills-index.js`.
4. Run `./scripts/install-agent-skills.sh && node scripts/gen-skills-index.js`.
5. Update the tables in `AGENTS.md` and `.claude/skills/README.md`.

Do not run `npx skills add ... --all`. Cloud Agents need the files in git.

## Sources for this note

- [shadcn/improve README](https://github.com/shadcn/improve)
- [cursor/plugins README](https://github.com/cursor/plugins)
- [pstack plugin.json](https://github.com/cursor/plugins/blob/main/pstack/.cursor-plugin/plugin.json) (v0.14.5)
- [cursor-team-kit plugin.json](https://github.com/cursor/plugins/blob/main/cursor-team-kit/.cursor-plugin/plugin.json) (v1.2.0)
- [vercel-labs/agent-skills README](https://github.com/vercel-labs/agent-skills) (MIT stated in README)
- [addyosmani/agent-skills README](https://github.com/addyosmani/agent-skills) (v0.6.8)
- [trailofbits/skills](https://github.com/trailofbits/skills)
- [vercel-labs/skills](https://github.com/vercel-labs/skills)
- [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser)
- [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin)
- [github/spec-kit](https://github.com/github/spec-kit)
- [anthropics/skills](https://github.com/anthropics/skills)
- [github/awesome-copilot](https://github.com/github/awesome-copilot)
- [Agent Skills spec](https://agentskills.io)
- [Cursor skills docs](https://cursor.com/docs/skills)
- [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude) (Claude Code port of official pstack)
