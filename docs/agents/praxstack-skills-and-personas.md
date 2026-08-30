# Prax skills-and-personas (personal OS)

Source: [praxstack/skills-and-personas](https://github.com/praxstack/skills-and-personas) (MIT, pin `78a7ee9`).
Companion notes: [praxstack/developer-workflow](https://github.com/praxstack/developer-workflow) `PRAXSTACK-SKILLS.md` / `INSTALL.sh`.

This is **Prax's personal OS / personas rack**. Discover a skill when the
task matches. Do **not** run it as a fifth methodology conductor next to
gstack, Superpowers, pstack, and Compound Engineering.

## Where it lives in this repo

| Surface | Path |
| --- | --- |
| Claude Code / nested pack | `.claude/skills/praxstack/` |
| Codex / Prime Agent | `.agents/skills/praxstack/` |
| Cursor one-level index | `.cursor/skills/<name>/` (symlink) |
| Claude agents | `.claude/agents/` |
| Cursor agents | `.cursor/agents/` |
| Codex agents | `.codex/agents/` |
| Collision log | `docs/praxstack-skill-collisions.md` |

Refresh:

```bash
./scripts/install-agent-skills.sh
node scripts/gen-skills-index.js
```

The installer clones `praxstack/skills-and-personas`, copies `new-skills/`
(skipping `_audit`), then `scripts/vendor-praxstack-extras.sh` adds the public
skills (slim Teach Pro Max), `SAFETY.md`, personas, and workflows.
`scripts/link-praxstack-skills.sh` flattens Cursor slash names.

## Official upstream install (not used on boot)

Upstream `new-skills/_audit/install.sh` hardcodes a machine-local `SRC` path.
The documented local install is:

```bash
git clone https://github.com/praxstack/skills-and-personas.git
# copy new-skills/<name> into ~/.claude/skills/<name> (collision backup)
npx skills add praxstack/skills-and-personas --skill teach-pro-max
```

This Express app vendors into the pack directories above instead of dumping
41 skills into the global `~/.claude/skills` root. There is **no**
`./setup --host cursor` in skills-and-personas; that command is gstack's.

## Skills vendored

Canonical portfolio (`new-skills/`, 41 skills) plus four public extras.

**Goals / autonomous execution (no Cursor Goal files upstream):**

| Pattern | Skill or prompt |
| --- | --- |
| APEX | `apex-autonomous-mode` (`/apex`, `/autonomous`) |
| Host-neutral autonomous protocol | `autonomous-orchestrion` |
| Operator loop | pack `workflows/high-end-operator/` (`/spec` → `/plan` → `/build` → `/review` → `/ship`) |
| Align / install packs | pack `workflows/project-alignment/` |
| Teach Pro Max research `/goal` | bookmark only (`docs/teach-pro-max/research/` upstream) |

**Personas (invoke, do not always-apply):**

| Role | How |
| --- | --- |
| Constellation team | skill `constellation-team` + `.cursor/agents/*.md` |
| Kingmode / ultrathink | `kingmode`, `super-mode-core`, `ultrathink-frontend` |
| Teach Pro Max identity | skill `teach-pro-max` + pack `personas/teach-pro-max-agent-persona/` |
| Markdown personas | pack `personas/md-personas/` |

Not vendored: `personas/prax-lannister` (personal memory / PII), Chronicle
multi-file journal packs, `skills/` legacy dump, teach-pro-max `evidence/` and
tests, NVIDIA/Remotion (other worker).

## Bookmarks (related praxstack repos)

Do not clone these into this app. High-signal neighbors:

| Repo | Why |
| --- | --- |
| [praxstack/developer-workflow](https://github.com/praxstack/developer-workflow) | Personal stack + replay install |
| [praxstack/moa-x](https://github.com/praxstack/moa-x) | Mixture-of-Agents-X reference |
| [praxstack/agent-org](https://github.com/praxstack/agent-org) | Reviewer↔coder gated loop |
| [praxstack/cursor-plugins](https://github.com/praxstack/cursor-plugins) | Cursor plugin spec fork |

## Mental health

`mental-health-screening-companion` is screening + journaling, not therapy.
Read pack `SAFETY.md` (988 and instrument attribution) before using it.
