# Repo routing block

Paste this into the project `CLAUDE.md` or `AGENTS.md` under `## Skill routing`. Keep the file under 200 lines total. Procedures live in skills, not here.

```text
## Skill routing

When a request matches a skill, invoke it. Do not answer ad-hoc if a skill exists.

Think / product
- New idea, "is this worth building" → /office-hours (or /gstack-office-hours)
- Lost the thread, "are we on the same page" → wait-what + blank-stare; see prompts/project-alignment/

Plan
- Spec / ticket / backlog item → /spec (or /gstack-spec)
- Implementation plan from a spec, do not code → writing-plans
- OpenSpec one-shot change → openspec-propose

Build
- Implement a slice → test-driven-development (failing test first)
- Execute an existing plan → executing-plans or subagent-driven-development

Review
- Diff / pre-landing → /review (or /gstack-review)
- Live UI polish → /design-review
- Security / OWASP / threat model → /cso
- Lock architecture of a plan → /plan-eng-review (plan mode)

Test
- Report only → /qa-only
- Find and fix → /qa
- Quality score → /health

Ship
- PR → /ship
- Merge + deploy + canary → /land-and-deploy

Debug
- Broken / unexpected → /investigate or systematic-debugging
- Do not guess a fix first

Browser
- Read-only extract → /scrape (or /gstack-scrape if prefix is on)
- Persist last scrape → /skillify
- Live QA drive → /browse (not mcp__claude-in-chrome__*)

Research
- Cited landscape → deep-research or agentic-deep-research
- Last 30 days chatter → last30days

Session
- Large change → host /plan
- Window full → host /context or /compact
- Branch security vs default → host /security-review

Do not vendor gstack bodies into this repo. Install globally. Do not load every skill every turn.
```
