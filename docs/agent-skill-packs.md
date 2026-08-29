# Agent skill packs

This repo vendors a small set of Agent Skills packs for Cursor, Claude Code,
and Codex. Refresh with `./scripts/install-agent-skills.sh` then
`node scripts/gen-skills-index.js`. The generated catalog is
[`docs/agent-skills.md`](agent-skills.md).

## Why these packs

The bar is a named author or first-party org, an OSI license when one exists,
a `SKILL.md` tree that agents can discover, and a workflow a staff engineer
would actually run. Install count on [skills.sh](https://skills.sh) is a signal,
not a substitute for that bar.

| Pack | Source | Why it is here |
| --- | --- | --- |
| Superpowers | [obra/superpowers](https://github.com/obra/superpowers) | SDLC methodology. Brainstorm, plan, TDD, review, worktrees. |
| Matt Pocock | [mattpocock/skills](https://github.com/mattpocock/skills) | Engineering skills: grill, domain model, code review, TDD. |
| gstack | [garrytan/gstack](https://github.com/garrytan/gstack) | Role-based CEO, design, eng, DX, QA, ship. |
| pstack | [cursor/plugins pstack](https://github.com/cursor/plugins/tree/main/pstack) | Official Cursor pstack. This workspace runs on Cursor, so this tree is the source, not the Claude Code port. |
| improve | [shadcn/improve](https://github.com/shadcn/improve) | Expensive-model audit that writes plans for cheaper executors. |
| Cursor Team Kit | [cursor/plugins cursor-team-kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit) | Cursor's own CI, review, ship, and verify skills. |
| Vercel Agent Skills | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) | First-party web, writing, React, and deploy skills. |
| Addy Osmani | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | Spec → build → test → review → ship, with gates. |

pstack was previously vendored from [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude), a Claude Code and Codex port of the same skills. That port remains useful on those harnesses. This repo's agents run in Cursor, so the installer now clones `cursor/plugins` and copies `pstack/skills`.

## Also credible, not vendored here

These passed the credibility bar and failed the "this repo needs the files" bar.

| Source | Why skip |
| --- | --- |
| [anthropics/skills](https://github.com/anthropics/skills) | Spec author's examples. Mix of pptx/xlsx/art/branding plus a few engineering skills (`frontend-design`, `webapp-testing`, `mcp-builder`). Install from the Claude marketplace when you need a document skill. Do not dump the whole tree into this Express app. |
| [openai/skills](https://github.com/openai/skills) | Codex and ChatGPT system skills (`skill-creator`). Useful on Codex. Duplicate of what Codex already ships. |
| [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) | Apache-2.0 browser CLI, not a `SKILL.md` pack. Use it as a tool when UI verification needs a real browser. |
| [vercel-labs/skills](https://github.com/vercel-labs/skills) | The `npx skills` CLI and registry client, not a workflow pack. |
| [agentskills/agentskills](https://github.com/agentskills/agentskills) | The open standard, not a skill pack. |

Awesome-list scrapes and 50k-skill indexes are discovery surfaces. They are not packs.

## How to add another pack

1. Confirm license, `SKILL.md` layout, and that it does not duplicate a pack already in `scripts/install-agent-skills.sh`.
2. Append a `pack|owner/repo|skills-subdir|LICENSE-path` line to `PACKS`.
3. Add a `PACK_META` entry in `scripts/gen-skills-index.js`.
4. Run `./scripts/install-agent-skills.sh && node scripts/gen-skills-index.js`.
5. Update the tables in `AGENTS.md` and `.claude/skills/README.md`.

## Sources for this note

- [shadcn/improve README](https://github.com/shadcn/improve)
- [cursor/plugins README](https://github.com/cursor/plugins)
- [pstack plugin.json](https://github.com/cursor/plugins/blob/main/pstack/.cursor-plugin/plugin.json) (v0.14.5)
- [cursor-team-kit plugin.json](https://github.com/cursor/plugins/blob/main/cursor-team-kit/.cursor-plugin/plugin.json) (v1.2.0)
- [vercel-labs/agent-skills README](https://github.com/vercel-labs/agent-skills) (MIT stated in README)
- [addyosmani/agent-skills README](https://github.com/addyosmani/agent-skills) (v0.6.8)
- [anthropics/skills](https://github.com/anthropics/skills)
- [Agent Skills spec](https://agentskills.io)
- [Cursor skills docs](https://cursor.com/docs/skills)
- [michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude) (Claude Code port of official pstack)
