# Install named skill packs

Generic paste prompt for any machine or repo. Install or confirm the packs. Do not write an investor brief. Do not run QA or deep research.

Copy everything inside the fence.

```text
Install (or confirm already installed) these skill packs. Do not implement product work. Do not reconstruct the project. Do not run /qa, /gstack-qa-only, plan-mode gstack skills, or /deep-research.

Use find-skills / `npx skills` where that is the install path. Prefer global user-level install (`-g -y`) unless this repo already vendors the pack.

Check first. Install only what is missing. Do not reinstall a working copy. After each pack, report: installed | already present | failed, plus the on-disk path.

Required packs and skill names:

A. gstack
   - Router: gstack
   - Verification: gstack-qa, gstack-qa-only, gstack-review, gstack-health,
     gstack-devex-review, gstack-design-review, gstack-canary, gstack-investigate
   - Spec / ship (install only): gstack-spec, gstack-ship
   Typical source: ~/.agents/skills/gstack and ~/.claude/skills/gstack

B. Superpowers
   - using-superpowers
   - brainstorming
   - writing-plans
   - executing-plans
   - subagent-driven-development
   - test-driven-development
   - systematic-debugging
   - requesting-code-review
   - receiving-code-review
   - verification-before-completion
   - finishing-a-development-branch
   - using-git-worktrees
   Typical source: obra/superpowers (plugin: superpowers-marketplace)

C. Matt Pocock engineering skills
   - setup-matt-pocock-skills
   After install, run setup-matt-pocock-skills only if this repo has no
   docs/agents/issue-tracker.md yet. Confirm with me before writing
   CLAUDE.md / AGENTS.md.

D. OpenSpec
   - openspec (CLI + repo change folders under openspec/changes/)
   Install the OpenSpec skill/CLI if missing. Do not create a new change
   in this turn.

E. Deep research
   - deep-research
   - agentic-deep-research
   - local-deep-research
   Install them. Do not start a research run in this turn.

F. Discovery helper
   - find-skills
   Use it to locate any pack above that is not already on disk.

If a pack cannot be installed, say the exact command you tried and the error. Do not invent a substitute workflow.

End with a table: name → status → path. Then list what you did not do.
```
