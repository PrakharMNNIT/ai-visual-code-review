gstack skills are nested under this pack for Claude Code / Codex. Cursor slash
commands index one-level skill directories (`.cursor/skills/<name>/SKILL.md`).
`scripts/link-agent-skills.sh` flattens each skill into `.cursor/skills/` and
`~/.cursor/skills/` using the SKILL.md `name:` field (e.g. `/plan-ceo-review`).
Do not always-apply the whole suite. Native `./setup --host cursor` requires bun
and is optional; this repo does not run it on boot.
