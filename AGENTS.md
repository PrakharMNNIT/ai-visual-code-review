# AGENTS.md

Guidance for AI coding agents working in this repository (AI Visual Code Review —
a Node.js/Express visual git code-review tool).

## Project quick reference

- Install dependencies: `npm ci`
- Run the web app: `npm start` (serves `http://localhost:3002`)
- Tests: `npm test` · Lint: `npm run lint`

## Agent skills

This repo vendors several agent-skill packs. They are installed in both
`.claude/skills/` (Claude Code, Cursor) and `.agents/skills/` (Codex, Prime
Agent) and are discovered automatically by compatible agents.

- Browse the full index of all skills and their triggers:
  [`docs/agent-skills.md`](docs/agent-skills.md).
- Packs (all MIT licensed):
  - `superpowers/` — SDLC methodology skills ([obra/superpowers](https://github.com/obra/superpowers))
  - `mattpocock/` — engineering & productivity skills ([mattpocock/skills](https://github.com/mattpocock/skills))
  - `gstack/` — role-based "virtual engineering team" skills ([garrytan/gstack](https://github.com/garrytan/gstack))
  - `pstack/` — rigorous agent workflow skills ([michael-denyer/pstack-claude](https://github.com/michael-denyer/pstack-claude))
- These are slimmed installs (Markdown only). Refresh from upstream with:
  `./scripts/install-agent-skills.sh && node scripts/gen-skills-index.js`.

When a task matches a skill's trigger description, read that skill's `SKILL.md`
and follow it.
