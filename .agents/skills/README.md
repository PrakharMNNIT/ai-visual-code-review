# Agent skill packs

This directory vendors several agent-skill packs so they are available to
Codex and Prime Agent (which discover skills under `.agents/skills/`). The same
packs are mirrored under [`.claude/skills/`](../../.claude/skills/) for Claude
Code and Cursor.

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
