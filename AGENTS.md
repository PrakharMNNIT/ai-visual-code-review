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
- Packs:
  - `superpowers/` — SDLC methodology ([obra/superpowers](https://github.com/obra/superpowers))
  - `mattpocock/` — engineering skills ([mattpocock/skills](https://github.com/mattpocock/skills))
  - `gstack/` — virtual engineering team ([garrytan/gstack](https://github.com/garrytan/gstack))
  - `pstack/` — official Cursor pstack ([cursor/plugins pstack](https://github.com/cursor/plugins/tree/main/pstack))
  - `improve/` — codebase audit and plans ([shadcn/improve](https://github.com/shadcn/improve))
  - `cursor-team-kit/` — Cursor CI, review, ship ([cursor-team-kit](https://github.com/cursor/plugins/tree/main/cursor-team-kit))
  - `vercel-agent-skills/` — Vercel web and writing skills ([vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills))
  - `addyosmani/` — spec, build, test, review, ship ([addyosmani/agent-skills](https://github.com/addyosmani/agent-skills))
- Why these packs, and which ones were skipped:
  [`docs/agent-skill-packs.md`](docs/agent-skill-packs.md).
- Slimmed installs (`SKILL.md`, references, skill `scripts/`). Refresh with:
  `./scripts/install-agent-skills.sh && node scripts/gen-skills-index.js`.

When a task matches a skill's trigger description, read that skill's `SKILL.md`
and follow it.

### Issue tracker

GitHub Issues for `praxstack/ai-visual-code-review` via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Default roles: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
