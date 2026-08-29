# AGENTS.md

Guidance for AI coding agents working in this repository (AI Visual Code Review —
a Node.js/Express visual git code-review tool).

## Project quick reference

- Install dependencies: `npm ci`
- Run the web app: `npm start` (serves `http://localhost:3002`)
- Tests: `npm test` · Lint: `npm run lint`

## Agent skills

This repo vendors agent-skill packs into `.claude/skills/` (Claude Code) and
`.agents/skills/` (Codex, Prime Agent). Cursor slash discovery is **one-level
only**, so `scripts/link-agent-skills.sh` flattens every pack into
`.cursor/skills/<name>/SKILL.md`. That flatten is **discovery, not
personality** — do not always-apply the catalog.

- Full index: [`docs/agent-skills.md`](docs/agent-skills.md).
- Why these packs, XOR pipeline, bookmarks: [`docs/agent-skill-packs.md`](docs/agent-skill-packs.md).
- Collisions (same `name:` in two packs): [`docs/cursor-skill-collisions.md`](docs/cursor-skill-collisions.md).
- Refresh vendor: `./scripts/install-agent-skills.sh && node scripts/gen-skills-index.js`.
- Cloud Agent boot: `npm ci && bash scripts/install-cursor-native-stack.sh`.
- pstack Task slugs: [`.cursor/rules/pstack-models.mdc`](.cursor/rules/pstack-models.mdc).

### Methodology XOR (one conductor per task)

Do **not** run gstack, Superpowers, pstack, and Compound Engineering as
simultaneous always-on conductors.

| Role | Pick one |
| --- | --- |
| Spec / change | **OpenSpec (default)** · Spec Kit (huge greenfield only) · gstack spec · CE spec |
| Implement | **pstack** (native Cursor) · Superpowers · gstack implement |
| Learn after a run | Compound Engineering (`ce-compound`) |

pstack is native Cursor execution. gstack `./setup --host cursor` is accepted
but this slim vendor fails on a missing `scripts/resolve-codex-generation-model.ts`
— flatten remains the Cursor discovery path. Superpowers is disciplined
engineering. CE is organizational learning, not a fourth parallel methodology.

### 2026 high-signal layers

- **OpenSpec** — default spec/change layer (`openspec/`). See [`docs/openspec.md`](docs/openspec.md).
- **Spec Kit** — vendored templates only; never `specify init` into this Express app.
- **Graphify** — optional knowledge graph (`graphifyy` / `graphify`). See [`docs/graphify.md`](docs/graphify.md).
- **Serena + Context7** — the only approved MCP servers. See [`docs/mcp.md`](docs/mcp.md).
- **last30days** — recency radar. Treat hits as **leads, not evidence**; verify independently.
- **agent-deep-research** (`24601/agent-deep-research` only) — not other forks.
- **Hallmark** — taste / anti-slop gate. **Impeccable** — design engineering. Complementary, not XOR with each other; neither replaces gstack/pstack.
- **web-design-guidelines** — pinned copy of `vercel-labs/web-interface-guidelines` (do not fetch mutable `main`).

Specialist racks (wshobson/agents, everything-claude-code, NVIDIA/Remotion/etc.)
are **bookmark-only**. See the packs doc.

### Issue tracker

GitHub Issues for `praxstack/ai-visual-code-review` via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Default roles: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
