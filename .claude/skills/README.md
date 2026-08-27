# Agent skill packs

This directory vendors several agent-skill packs so they are available to
Claude Code and Cursor (which discover skills under `.claude/skills/`). The same
packs are mirrored under [`.agents/skills/`](../../.agents/skills/) for Codex and
Prime Agent.

| Pack | Source | License |
| --- | --- | --- |
| `superpowers/` | [`obra/superpowers`](https://github.com/obra/superpowers) | MIT |
| `mattpocock/` | [`mattpocock/skills`](https://github.com/mattpocock/skills) | MIT |
| `gstack/` | [`garrytan/gstack`](https://github.com/garrytan/gstack) | MIT |
| `pstack/` | [`michael-denyer/pstack-claude`](https://github.com/michael-denyer/pstack-claude) (poteto's pstack port) | MIT |

- Full, browsable index with every skill and its trigger description:
  [`docs/agent-skills.md`](../../docs/agent-skills.md).
- These are **slimmed** installs: only `SKILL.md` files and their Markdown
  references are vendored; upstream build scripts, browser extensions, tests and
  binaries are excluded to keep the repo lean.
- To refresh/update from upstream:
  `./scripts/install-agent-skills.sh && node scripts/gen-skills-index.js`.
- Each pack directory retains its upstream `LICENSE` for attribution.
