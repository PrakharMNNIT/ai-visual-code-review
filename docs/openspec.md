# OpenSpec vs GitHub Spec Kit

**OpenSpec is the default spec/change layer** in this repository.

## OpenSpec (default)

- CLI: `@fission-ai/openspec` (Node >= 20.19). This VM / Cloud Agent install
  uses `npm install -g --prefix "$HOME/.local" @fission-ai/openspec`.
- Project root: [`openspec/`](../openspec/) (`config.yaml`, `changes/`, `specs/`).
- Cursor skills (generated, real files — not flatten-overwritten):
  `.cursor/skills/openspec-{propose,explore,apply-change,archive-change,sync-specs,update-change}/`
- Commands: `.cursor/commands/opsx-*.md`
- Nested vendor copies for Claude/Codex catalogs:
  `.claude/skills/openspec/` and `.agents/skills/openspec/`
- Init used here (non-interactive, did not wipe app source):

```
openspec init --tools cursor,agents --profile core --force --no-animation
```

Do **not** run `specify init` into this Express app.

## Spec Kit (heavyweight greenfield)

Vendored as Agent Skills only (`spec-kit/` pack, pin **v1.0.1**). Templates
for constitution / specify / plan / tasks / implement. Use Spec Kit when
starting a **new** repo that should be a Spec Kit project:

```
specify init --here --integration cursor-agent
```

CLI pin (optional):

```
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v1.0.1
```

## Methodology XOR

OpenSpec (or Spec Kit, or gstack spec, or CE spec) is **one** spec conductor
per task. Do not run gstack, Superpowers, pstack, and Compound Engineering
as simultaneous always-on conductors. See
[`docs/agent-skill-packs.md`](agent-skill-packs.md).
