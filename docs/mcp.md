# Project MCP (Serena + Context7)

Prax approved **two** MCP servers for this repo. They live in
[`.cursor/mcp.json`](../.cursor/mcp.json) so Cursor reads them as **project**
config. They are not ad-hoc `npx @modelcontextprotocol/server-*` shadow
servers. Do not add further MCP servers without a new approval. Never commit
API keys.

`scripts/link-agent-skills.sh` copies `.cursor/mcp.json` to
`~/.cursor/mcp.json` on Cloud Agent boot **only when the home file is
missing**, so a user-owned home config is never overwritten.

## Context7

```json
"context7": {
  "command": "npx",
  "args": ["-y", "@upstash/context7-mcp"]
}
```

No API key in git. Use when implementation depends on library / framework /
API docs that may have changed since training. Cursor rule:
[`.cursor/rules/context7.mdc`](../.cursor/rules/context7.mdc).

## Serena

```json
"serena": {
  "command": "uvx",
  "args": [
    "--from", "git+https://github.com/oraios/serena",
    "serena", "start-mcp-server",
    "--context", "ide",
    "--project", "${workspaceFolder}"
  ]
}
```

Use `--context ide`. Serena's built-in list has `ide`, not `ide-assistant`.

Semantic code intelligence for **this** tree. Optional index (not on boot):

```
uvx --from git+https://github.com/oraios/serena serena project index
```

Index artifacts belong under `.serena/` (gitignored). Non-interactive create
+ index for this Express app (Serena has no `javascript` language id; use
`typescript`):

```
uvx --from git+https://github.com/oraios/serena serena project create \
  --name ai-visual-code-review --language typescript --index
```

If Cursor does not expand `${workspaceFolder}`, pass an absolute project path
locally.

## Graphify vs Serena

| Tool | Role |
| --- | --- |
| **Graphify** | Optional knowledge graph (`graphify-out/`). Cursor rule is always-on but skips when `graphify-out/graph.json` is missing. CLI: `graphifyy` on PyPI, command `graphify`. |
| **Serena** | MCP language-server style tools over this repo. |

They complement; they are not methodology conductors.
