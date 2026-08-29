# Graphify

PyPI package **`graphifyy`** (two y's), command **`graphify`**.

```
uv tool install graphifyy
graphify cursor install    # writes .cursor/rules/graphify.mdc
graphify agents install    # optional skill into ~/.agents/skills/graphify
```

This repo vendors the skill at `.claude/skills/graphify/graphify/` and
`.agents/skills/graphify/graphify/` (copied from the official agents
install). Flatten exposes `/graphify` via `.cursor/skills/graphify`.

## Indexing

Cloud Agent **boot does not index**. On this repo `graphify .` treats hundreds of
vendored `SKILL.md` files as docs and **requires an LLM API key**. Do not commit
keys. A no-key attempt:

```
graphify . --code-only --no-viz
```

still walks the skill vendor (slow, noisy). Prefer indexing application source
only (`public/`, `services/`, `server.js`) after flatten is idle — never run
Graphify concurrently with `scripts/link-agent-skills.sh` (that script prunes
and rewrites `.cursor/skills`).

`graphify-out/` is gitignored. The Cursor rule skips mandatory graph queries
when `graphify-out/graph.json` is missing.

```
graphify query "<question>"
graphify update .
```

`graphify-out/` is gitignored. The Cursor rule skips mandatory graph queries
when `graphify-out/graph.json` is missing.

## Graphify vs Serena

Graphify is an optional **knowledge graph** over files. Serena is **MCP**
semantic navigation of this working tree. Use Serena for precise code intel;
use Graphify once an index exists for cross-file inferred edges.
