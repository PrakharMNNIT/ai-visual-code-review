# Graphify

PyPI package **`graphifyy`** (two y's), command **`graphify`**.

```
uv tool install graphifyy
graphify cursor install    # writes .cursor/rules/graphify.mdc
graphify agents install    # optional skill into ~/.agents/skills/graphify
```

This repo vendors the skill at `.claude/skills/graphify/SKILL.md` and
`.agents/skills/graphify/SKILL.md` (from `graphify install --project`).
Flatten exposes `/graphify` via `.cursor/skills/graphify`.

## Indexing

Cloud Agent **boot does not index**. `graphify update . --no-cluster` can
run without an LLM key (AST only) but it walks the vendored skill trees and
writes a large `graphify-out/` (gitignored). Prefer indexing application
source (`public/`, `services/`, `server.js`) when you need a graph. Never run
Graphify concurrently with `scripts/link-agent-skills.sh` (that script prunes
and rewrites `.cursor/skills`).

`graphify-out/` is gitignored. The Cursor rule skips mandatory graph queries
when `graphify-out/graph.json` is missing.

```
graphify query "<question>"
graphify update .
```

## Graphify vs Serena

Graphify is an optional **knowledge graph** over files. Serena is **MCP**
semantic navigation of this working tree. Use Serena for precise code intel;
use Graphify once an index exists for cross-file inferred edges.
