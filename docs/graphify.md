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

`graphify .` builds `graphify-out/` (can be slow on a large skill vendor).
Cloud Agent **boot does not index**. After a successful index:

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
