# Agent skill packs

This directory vendors agent-skill packs so they are available to
Codex and Prime Agent (which discover skills under `.agents/skills/`). The same
packs are mirrored under [`.claude/skills/`](../../.claude/skills/) for Claude
Code and Cursor.

| Pack | Source | License |
| --- | --- | --- |
| `superpowers/` | [`obra/superpowers`](https://github.com/obra/superpowers) | MIT |
| `mattpocock/` | [`mattpocock/skills`](https://github.com/mattpocock/skills) | MIT |
| `gstack/` | [`garrytan/gstack`](https://github.com/garrytan/gstack) | MIT |
| `pstack/` | [`cursor/plugins` pstack](https://github.com/cursor/plugins/tree/main/pstack) | MIT |
| `improve/` | [`shadcn/improve`](https://github.com/shadcn/improve) | MIT |
| `cursor-team-kit/` | [`cursor/plugins` cursor-team-kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit) | MIT |
| `vercel-agent-skills/` | [`vercel-labs/agent-skills`](https://github.com/vercel-labs/agent-skills) | MIT (README) |
| `addyosmani/` | [`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) | MIT |

- Full index: [`docs/agent-skills.md`](../../docs/agent-skills.md).
- Why these packs: [`docs/agent-skill-packs.md`](../../docs/agent-skill-packs.md).
- Slimmed install: `SKILL.md`, Markdown references, and each skill's `scripts/`.
- Refresh: `./scripts/install-agent-skills.sh && node scripts/gen-skills-index.js`.
