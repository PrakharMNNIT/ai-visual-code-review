# High-end operator prompt family

Paste prompts for prompt-heavy developers. They **name and invoke** installed skills. They do **not** copy skill bodies.

Research that produced this tree: [RESEARCH.md](RESEARCH.md) (workflow 2026-08-16, status Partial).

These are **prompts**, not a second gstack. Install the packs once (`../project-alignment/INSTALL-SKILLS.md`). Then paste one prompt per turn.

## Trees (folders, ready to split later)

| Tree | Path | Job |
|---|---|---|
| Router | [00-router/](00-router/) | Short always-on routing. Keep under 200 lines. |
| Think | [01-think/](01-think/) | Office hours, brainstorm, align |
| Plan | [02-plan/](02-plan/) | Spec, writing-plans, OpenSpec |
| Build | [03-build/](03-build/) | One TDD slice, then stop |
| Review | [04-review/](04-review/) | Diff review, design, CSO |
| Test | [05-test/](05-test/) | qa-only, qa, health |
| Ship | [06-ship/](06-ship/) | Ship, land-and-deploy |
| Reflect | [07-reflect/](07-reflect/) | Retro, learn |
| Debug | [08-debug/](08-debug/) | Investigate, systematic-debugging |
| Browser | [09-browser/](09-browser/) | scrape → skillify, browse |
| Research | [10-research/](10-research/) | deep-research, last30days |
| Session gates | [11-session/](11-session/) | Host `/plan`, `/context`, `/compact`, `/security-review` |

Full inventory: [CATALOG.md](CATALOG.md).

## Steady loop

`/spec` → `/plan` (or writing-plans) → `/build` (one failing test) → `/review` → `/ship`

Do not load every skill every session. One tree, one turn.

## Hard rules (from the research)

- Do not hand-copy gstack, Superpowers, or Matt Pocock skill files into this repo.
- With gstack `./setup --prefix`, scrape is `/gstack-scrape`. Keep that namespace.
- Use `/browse` for live pages. Do not use `mcp__claude-in-chrome__*` tools when gstack browse exists.
- Official host gates (`/plan`, `/context`, `/compact`, `/code-review`, `/security-review`) are host built-ins. Do not reimplement them.
- Mid-August 2026 add-ons (Whetstone, Product-Manager-Skills, Jeffallan) stay optional. Do not merge their bodies into this catalog.
