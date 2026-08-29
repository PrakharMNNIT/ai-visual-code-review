# Agent skill packs

This repo vendors Agent Skills packs for Cursor, Claude Code, and Codex.
Refresh with `./scripts/install-agent-skills.sh` then
`node scripts/gen-skills-index.js`. The generated catalog is
[`docs/agent-skills.md`](agent-skills.md).

Skills are **on-demand discovery**, not always-on personality. Read a
`SKILL.md` when the task matches its trigger. Do not load every security
or methodology skill into context on every turn.

Prefer `npx skills add <repo> --skill '*'` targeting agents over `--all`
when installing into a live harness. This repo vendors into
`.claude/skills/` and `.agents/skills/` via
`scripts/install-agent-skills.sh` (not global-only npx).

## Pipeline (pick one methodology per stage)

```
find-skills → spec (gstack XOR Spec Kit XOR CE) → interrogate (mattpocock + improve)
  → implement (pstack XOR Superpowers) → review → ToB security → agent-browser QA → ship → ce-compound
```

Never run Compound Engineering, gstack, Superpowers, and pstack on the
same task. CE is the learn/compound layer after a run, not a fourth
parallel methodology. Spec, implement, and compound each pick **one**
source: gstack XOR Spec Kit XOR CE for spec; pstack XOR Superpowers for
implement.

## Why these packs

The bar is a named author or first-party org, an OSI license when one exists,
a `SKILL.md` tree that agents can discover, and a workflow a staff engineer
would actually run. Install count on [skills.sh](https://skills.sh) is a signal,
not a substitute for that bar.

| Pack | Source | Why it is here |
| --- | --- | --- |
| Superpowers | [obra/superpowers](https://github.com/obra/superpowers) | SDLC methodology. Brainstorm, plan, TDD, review, worktrees. |
| Matt Pocock | [mattpocock/skills](https://github.com/mattpocock/skills) | Engineering skills: grill, domain model, code review, TDD. |
| gstack | [garrytan/gstack](https://github.com/garrytan/gstack) | Role-based CEO, design, eng, DX, QA, ship. Pick this **or** Spec Kit **or** CE for spec, not all three. Cursor slash commands (`/plan-ceo-review`) come from flattened `.cursor/skills/<name>/` links, not the nested pack directory. |
| pstack | [cursor/plugins pstack](https://github.com/cursor/plugins/tree/main/pstack) | Official Cursor pstack. This workspace runs on Cursor, so this tree is the source, not the Claude Code port. |
| improve | [shadcn/improve](https://github.com/shadcn/improve) | Expensive-model audit that writes plans for cheaper executors. |
| Cursor Team Kit | [cursor/plugins cursor-team-kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit) | Cursor's own CI, review, ship, and verify skills. |
| Vercel Agent Skills | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | First-party web, writing, React, and deploy skills. Whole pack. |
| Addy Osmani | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | Spec → build → test → review → ship, with gates. |
| find-skills | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Skill #0 / discovery only. Not the `npx skills` CLI tree. |
| Trail of Bits | [trailofbits/skills](https://github.com/trailofbits/skills) | Security research and audit. CC-BY-SA-4.0. Entire marketplace/skills tree, on demand; do not always-apply every skill. |
| agent-browser | [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) | Agent Skill **and** optional CLI: `scripts/install-agent-browser.sh`. |
| Compound Engineering | [EveryInc/compound-engineering-plugin](https://github.com/EveryInc/compound-engineering-plugin) | Full portable skills slice. Learn/compound layer after a run. Do not combine with gstack + Superpowers + pstack on one task. |
| Anthropic (subset) | [anthropics/skills](https://github.com/anthropics/skills) | Engineering subset: `frontend-design`, `webapp-testing`, `mcp-builder`, `skill-creator`, `claude-api` (Apache-2.0). No pptx/xlsx/docx/art/branding/gifs. |
| Awesome Copilot | [github/awesome-copilot](https://github.com/github/awesome-copilot) | Full `skills/` toolbox shelf (`npx skills add github/awesome-copilot --skill '*'`). Slimmed copy. Discover on demand. |
| Spec Kit | [github/spec-kit](https://github.com/github/spec-kit) | Command templates vendored as Agent Skills (pin `v1.0.1`). See below. |
| Microsoft (subset) | [microsoft/skills](https://github.com/microsoft/skills) | Documented selective subset. Microsoft warns the whole ~175-skill set causes context rot. |
| AWS | [aws/agent-toolkit-for-aws](https://github.com/aws/agent-toolkit-for-aws) | `skills/` core + specialized (Apache-2.0). Layout confirmed: `skills/core-skills` and `skills/specialized-skills`. |
| Cloudflare | [cloudflare/skills](https://github.com/cloudflare/skills) | Workers, Wrangler, Durable Objects, and related (Apache-2.0). |
| Supabase | [supabase/agent-skills](https://github.com/supabase/agent-skills) | Backend, Postgres, RLS (MIT). |

pstack was previously vendored from [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude), a Claude Code and Codex port of the same skills. That port remains useful on those harnesses. This repo's agents run in Cursor, so the installer clones `cursor/plugins` and copies `pstack/skills`.

Cursor pstack model overrides live at [`.cursor/rules/pstack-models.mdc`](../.cursor/rules/pstack-models.mdc) (`alwaysApply: true`). `scripts/link-agent-skills.sh` copies that file to `~/.cursor/rules/` on Cloud Agent boot, and flattens each gstack skill into [`.cursor/skills/`](../.cursor/skills/) plus `~/.cursor/skills/` so Cursor's one-level index lists `/plan-ceo-review` the same way plugin skills like `/setup-pstack` appear.

## Spec Kit

Pinned to Git tag **v1.0.1** (MIT). Latest observed release when this pack
was added. Do **not** install a random PyPI `specify-cli`.

This Express app does **not** run `specify init`. That would dump a Spec
Kit project (`.specify/`, constitution, feature branches) into application
source. Instead the installer converts `templates/commands/*.md` into
Agent Skills so Cursor / Claude / Codex can run:

- `constitution`
- `specify`
- `plan`
- `tasks`
- `implement`

plus `clarify`, `analyze`, `checklist`, `converge`, and `taskstoissues`.
Helper bash/python/powershell scripts and the document templates land in
the pack's `scripts/` and `references/`.

If `uv` is available, pin the CLI from the same tag:

```
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v1.0.1
```

For a **greenfield** repo that should be a Spec Kit project:

```
specify init --here --integration cursor-agent
```

gstack does **not** ship a Cursor plugin manifest (no `.cursor-plugin`). Native
`./setup --host cursor` is accepted by the installer even when `--help` omits
`cursor` ([issue 2361](https://github.com/garrytan/gstack/issues/2361) is
closed; the help text can still lag). That path requires bun and generates
host-specific docs under `~/.cursor/skills/gstack-*`. This repo does not run
it on boot. Instead `scripts/link-agent-skills.sh` flattens the vendored pack
into `.cursor/skills/<name>` (project-local relative symlinks) and
`~/.cursor/skills/<name>` using each skill's `name:` field. The slim vendor
includes gstack `bin/` and `setup` so `gstack-skill-start` exists at
`~/.claude/skills/gstack/bin/` (the preamble path in SKILL.md).

## Microsoft subset

Allowlist in `scripts/install-agent-skills.sh` (`MICROSOFT_SKILLS`) and
this table. Scan root is `.github` so both `.github/skills/` and
plugin skill trees (deep-wiki) are visible; the allowlist keeps Azure SDK
dumps out.

| Skill | Why |
| --- | --- |
| `cloud-solution-architect` | Architecture / well-architected review |
| `continual-learning` | Agent learning loop |
| `copilot-sdk` | GitHub Copilot SDK (this app is a git review tool) |
| `frontend-design-review` | Visual git-review UI |
| `github-issue-creator` | Issues from notes/logs |
| `mcp-builder` | MCP servers (Node/TypeScript) |
| `microsoft-docs` | Docs lookup |
| `skill-creator` | Authoring Agent Skills |
| `wiki-agents-md` | AGENTS.md |
| `wiki-architect` | Architecture wiki |
| `wiki-changelog` | Changelog |
| `wiki-llms-txt` | llms.txt |
| `wiki-onboarding` | Onboarding docs |
| `wiki-page-writer` | Doc pages |
| `wiki-qa` | Doc QA |
| `wiki-researcher` | Research notes |

Skipped on purpose: Azure SDK `*-py` / `*-dotnet` / `*-java` / `*-ts` /
`*-rust` dumps, Foundry, Kusto, M365 Agents Toolkit, DebugView,
`podcast-generation`, `entra-agent-id`.

## Awesome Copilot

ChatGPT's portable install is `--skill '*'`: the entire `skills/` tree as
a toolbox shelf. This repo vendors that tree slimmed (`SKILL.md` +
Markdown + `scripts/` + `references/` + `LICENSE*`). Skill count is
hundreds, not the previous 15-skill GitHub-only subset. Discover a skill
when the task matches; do not always-apply the catalog.

## agent-browser CLI

The Agent Skill is vendored. The CLI is optional and installed by
`scripts/install-agent-browser.sh` on environment boot:

1. `npm install -g agent-browser`, then `agent-browser install` (Chrome for Testing).
2. If `/usr/lib/node_modules` is not writable (typical Cloud Agent VM), the script falls back to `npm install -g --prefix "$HOME/.local"` and prepends `$HOME/.local/bin` to `PATH`.
3. Failures must not fail boot. The skill text is still in git.

This VM: system-global npm failed with `EACCES`. User-prefix install succeeded (`agent-browser 0.27.0` plus Chrome 152). `uv` is not assumed in Cloud Agent VMs.

## Also credible, not vendored here

These passed the credibility bar and failed the "this repo needs the files" bar.

| Source | Why skip |
| --- | --- |
| [openai/skills](https://github.com/openai/skills) | Codex and ChatGPT system skills (`skill-creator`). Useful on Codex. Duplicate of what Codex already ships. |
| [agentskills/agentskills](https://github.com/agentskills/agentskills) | The open standard, not a skill pack. |
| [anthropics/skills](https://github.com/anthropics/skills) (remainder) | pptx/xlsx/docx, art, branding, gifs stay upstream. |
| [microsoft/skills](https://github.com/microsoft/skills) (remainder) | Azure SDK / Foundry / Kusto / M365 dumps. Context rot. |

Awesome-list scrapes and 50k-skill indexes are discovery surfaces. They are not packs. Use `find-skills` instead of `npx skills add ... --all`.

## How to add another pack

1. Confirm license, `SKILL.md` layout, and that it does not duplicate a pack already in `scripts/install-agent-skills.sh`.
2. Append a `pack|owner/repo|skills-subdir|LICENSE-path|allowlist|ref` line to `PACKS`. Leave the allowlist empty to take every skill, or pass comma-separated directory names for a subset. Leave `ref` empty for the default branch, or pass a tag.
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
- [github/spec-kit](https://github.com/github/spec-kit) (v1.0.1, MIT)
- [anthropics/skills](https://github.com/anthropics/skills)
- [github/awesome-copilot](https://github.com/github/awesome-copilot) (MIT)
- [microsoft/skills](https://github.com/microsoft/skills) (MIT; selective use)
- [aws/agent-toolkit-for-aws](https://github.com/aws/agent-toolkit-for-aws) (Apache-2.0)
- [cloudflare/skills](https://github.com/cloudflare/skills) (Apache-2.0)
- [supabase/agent-skills](https://github.com/supabase/agent-skills) (MIT)
- [Agent Skills spec](https://agentskills.io)
- [Cursor skills docs](https://cursor.com/docs/skills)
- [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude) (Claude Code port of official pstack)
