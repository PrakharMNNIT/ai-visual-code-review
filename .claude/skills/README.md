# Agent skill packs

This directory vendors agent-skill packs so they are available to
Claude Code and Cursor (which discover skills under `.claude/skills/`). The same
packs are mirrored under [`.agents/skills/`](../../.agents/skills/) for Codex and
Prime Agent.

| Pack | Source | License |
| --- | --- | --- |
| `find-skills/` | [`vercel-labs/skills`](https://github.com/vercel-labs/skills) (`find-skills` only) | MIT |
| `superpowers/` | [`obra/superpowers`](https://github.com/obra/superpowers) | MIT |
| `mattpocock/` | [`mattpocock/skills`](https://github.com/mattpocock/skills) | MIT |
| `gstack/` | [`garrytan/gstack`](https://github.com/garrytan/gstack) | MIT |
| `pstack/` | [`cursor/plugins` pstack](https://github.com/cursor/plugins/tree/main/pstack) | MIT |
| `improve/` | [`shadcn/improve`](https://github.com/shadcn/improve) | MIT |
| `cursor-team-kit/` | [`cursor/plugins` cursor-team-kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit) | MIT |
| `vercel-agent-skills/` | [`vercel-labs/agent-skills`](https://github.com/vercel-labs/agent-skills) | MIT (README) |
| `addyosmani/` | [`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) | MIT |
| `trailofbits/` | [`trailofbits/skills`](https://github.com/trailofbits/skills) | CC-BY-SA-4.0 |
| `agent-browser/` | [`vercel-labs/agent-browser`](https://github.com/vercel-labs/agent-browser) | Apache-2.0 |
| `compound-engineering/` | [`EveryInc/compound-engineering-plugin`](https://github.com/EveryInc/compound-engineering-plugin) | MIT |
| `anthropics/` | [`anthropics/skills`](https://github.com/anthropics/skills) (engineering subset) | Apache-2.0 (per skill) |
| `awesome-copilot/` | [`github/awesome-copilot`](https://github.com/github/awesome-copilot) (issue/PR/`gh` subset) | MIT |

- Full index: [`docs/agent-skills.md`](../../docs/agent-skills.md).
- Why these packs: [`docs/agent-skill-packs.md`](../../docs/agent-skill-packs.md).
- Slimmed install: `SKILL.md`, Markdown references, and each skill's `scripts/`.
- Refresh: `./scripts/install-agent-skills.sh && node scripts/gen-skills-index.js`.
- Pipeline: find-skills → spec (gstack **or** spec-kit **or** CE) → interrogate → implement → review → ToB → agent-browser QA → ship → CE compound. One methodology per stage. Spec Kit is not vendored; see the packs doc.
