# Align, install skills, then report-only QA

Generic paste prompt for any repo. Three jobs, in order. Do not add project history to the same message.

Copy everything inside the fence.

```text
Wait, what? Blank stare.

We have been working on this project for a while. I have lost the thread. I know what I want. I do not know if you want the same thing.

This turn has three jobs, in this order:

1. Reconstruct the current project so we can check alignment.
2. Install (or confirm already installed) the skill packs listed below.
3. Run report-only verification with /gstack-qa-only (or /qa-only).

Do not implement product features. Do not plan the next phase. Do not run plan-mode gstack skills (office-hours, plan-ceo-review, plan-eng-review, autoplan). Do not start a /deep-research run. Do not fix bugs found in Job 3 unless I say so after the report.

------------------------------------------------------------
JOB 1 — ALIGNMENT
------------------------------------------------------------

Explain the whole picture in simple language, including architecture and what we are trying to build. Be as descriptive as you need. Use bullet points.

Speak as if I am an early investor with no prior knowledge. Present the project from 0 to 100 as it exists now. Starting intent does not matter. Evolution does. Cover:

- What the product is, in one sentence
- What problem it solves
- What we are actually building (and what we are not)
- The directive you are following
- Your current vision
- Architecture, in plain language
- What exists today vs what is still missing
- What we have improved
- What the final vision has become
- How supporting material (docs, books, courses, resource lists, notes) fits — they are inputs, not the product
- What one active focus should be right now, if the repo makes that clear

Hard constraints:

- Do not rewrite or regenerate existing books, courses, or long reference material.
- Do not treat a resource catalog as work to consume in full.
- Do not invent a second product beside what the repo supports.
- Do not silently change the primary goal, scope, or success definition.
- If a phrase in this message looks like noise or a pasted artifact, ignore it.
- If you are unsure, say what the repo supports and what is only your inference.

Separate three layers explicitly:

1. Product — the thing a user or I get
2. Method — how we work (gates, evidence, specs, reviews)
3. Library — books, papers, docs, links we consult when stuck

I will come to you when I am stuck on a specific resource or implementation. Until then, do not re-teach the whole field.

Optional, only if I add a path below: copy one existing HTML file to a local folder and prove the copy matches (size + hash). Do not redesign it. Do not deploy it.

HTML source (optional): [path or "none"]

------------------------------------------------------------
JOB 2 — INSTALL SKILLS (real names)
------------------------------------------------------------

Use find-skills / `npx skills` where that is the install path. Prefer global user-level install (`-g -y`) unless this repo already vendors the pack.

Check first. Install only what is missing. Do not reinstall a working copy. After each pack, report: installed | already present | failed, plus the on-disk path.

Required packs and skill names:

A. gstack
   - Router: gstack
   - Verification skills (install the suite; Job 3 runs only qa-only):
     gstack-qa, gstack-qa-only, gstack-review, gstack-health,
     gstack-devex-review, gstack-design-review, gstack-canary,
     gstack-investigate
   - Spec / ship (install only; do not run them now):
     gstack-spec, gstack-ship
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

------------------------------------------------------------
JOB 3 — REPORT-ONLY VERIFICATION
------------------------------------------------------------

Only after Job 2, read and follow:

- ~/.agents/skills/gstack/qa-only/SKILL.md
  or ~/.agents/skills/gstack-qa-only/SKILL.md
  (slash: /gstack-qa-only or /qa-only)

Rules for this job:

- Report only. Do not fix bugs.
- Do not switch to /qa (the fix loop).
- Do not run /review, /health, /canary, or plan reviews unless qa-only's own skill file requires a prerequisite check.
- Target, in this order, whichever exists:
  1. [URL or local path I paste here, or "none"]
  2. The HTML file from Job 1 if one was copied
  3. The project's documented local preview / README start command
- If there is no runnable UI and no URL, run the closest substitute the skill allows (tests, curl, render script) and say what you could not click.
- Produce the qa-only report: health, repro steps, evidence (screenshots or command output).
- Stop after the report. Ask me before fixing anything.

------------------------------------------------------------
END OF TURN
------------------------------------------------------------

End with:

- Alignment one-liner (the product, not the library)
- Skill install table (name → status → path)
- QA-only verdict (pass / fail / blocked) and where the report file is
- What you did not do (no product implementation, no plan reviews, no deep-research run, no bugfixes)
```
