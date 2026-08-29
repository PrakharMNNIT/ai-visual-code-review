# Agent Skills

Vendored agent-skill packs, installed into both `.claude/skills/` (Claude Code, Cursor) and `.agents/skills/` (Codex, Prime Agent). Skills are discovered automatically by compatible agents via the [Agent Skills standard](https://agentskills.io).

> Slimmed install: `SKILL.md`, Markdown references, and each skill's `scripts/` directory. Refresh with `./scripts/install-agent-skills.sh` then `node scripts/gen-skills-index.js`. Packs keep their upstream LICENSE when the clone has one. Why these packs, and which ones were skipped: [`docs/agent-skill-packs.md`](agent-skill-packs.md).

## Superpowers

Source: [`obra/superpowers`](https://github.com/obra/superpowers) · v6.3.0 · Composable SDLC methodology skills.

| Skill | Description |
| --- | --- |
| `brainstorming` | You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation. |
| `dispatching-parallel-agents` | Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies |
| `executing-plans` | Use when you have a written implementation plan to execute in a separate session with review checkpoints |
| `finishing-a-development-branch` | Use when implementation is complete, all tests pass, and you need to decide how to integrate the work |
| `receiving-code-review` | Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation |
| `requesting-code-review` | Use when completing tasks, implementing major features, or before merging to verify work meets requirements |
| `subagent-driven-development` | Use when executing implementation plans with independent tasks in the current session |
| `systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes |
| `test-driven-development` | Use when implementing any feature or bugfix, before writing implementation code |
| `using-git-worktrees` | Use when starting feature work that needs isolation from current workspace or before executing implementation plans - ensures an isolated workspace exists via native tools or git worktree fallback |
| `using-superpowers` | Use when starting any conversation - establishes how to find and use skills, requiring skill invocation before ANY response including clarifying questions |
| `verification-before-completion` | Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always |
| `writing-plans` | Use when you have a spec or requirements for a multi-step task, before touching code |
| `writing-skills` | Use when creating new skills, editing existing skills, or verifying skills work before deployment |

## Matt Pocock — Skills for Real Engineers

Source: [`mattpocock/skills`](https://github.com/mattpocock/skills) · v1.2.3 · Engineering and productivity skills.

| Skill | Description |
| --- | --- |
| `ask-matt` | Ask which skill or flow fits your situation. A router over the skills in this repo. |
| `claude-handoff` | Hand the current conversation off to a fresh background agent that picks up the work immediately. |
| `code-review` | Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes: Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/spec asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to \"review since X\". |
| `codebase-design` | Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary. |
| `diagnosing-bugs` | Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this", or reports something broken/throwing/failing/slow. |
| `domain-modeling` | Build and sharpen a project's domain model. Use when discussing codebase terminology, writing or editing a CONTEXT.md, or recording or editing an ADR. |
| `git-guardrails-claude-code` | Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent destructive git operations, add git safety hooks, or block git push/reset in Claude Code. |
| `grill-me` | A relentless interview to sharpen a plan or design. |
| `grill-with-docs` | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| `grilling` | Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. |
| `handoff` | Compact the current conversation into a handoff document for another agent to pick up. |
| `implement-spec` | Implement a specification in code. |
| `implement` | Implement a piece of work based on a spec or set of tickets. |
| `improve-codebase-architecture` | Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick. |
| `loop-me` | Grill me about specs for the workflows I want to build, within this workspace. |
| `migrate-to-shoehorn` | Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to replace `as` in tests, or needs partial test data. |
| `prototype` | Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model or logic feels right, or explore what a UI should look like. |
| `research` | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent. |
| `resolving-merge-conflicts` | Use when you need to resolve an in-progress git merge/rebase conflict. |
| `retro` | Conduct a retrospective on a coding session. |
| `scaffold-exercises` | Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user wants to scaffold exercises, create exercise stubs, or set up a new course section. |
| `setup-matt-pocock-skills` | Configure this repo for the engineering skills: set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the other engineering skills. |
| `setup-pre-commit` | Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up Husky, configure lint-staged, or add commit-time formatting/typechecking/testing. |
| `setup-ts-deep-modules` | Wire dependency-cruiser into a TypeScript repo so each package is a deep module, with implementation hidden in subfolders and reachable only through its entry-point files. User-invoked. |
| `tdd` | Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests. |
| `teach` | Teach the user a new skill or concept, within this workspace. |
| `to-questionnaire` | Turn a decision you can't fully answer into a questionnaire for someone else to fill in. |
| `to-spec` | Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of what you've already discussed. |
| `to-tickets` | Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker (edges as text in one file per ticket locally, or native blocking links on a real tracker). |
| `triage` | Move issues and external PRs through a state machine of triage roles, categorise, verify, grill if needed, and write agent-ready briefs. |
| `wait-what` | Stop. That last message did not land: re-pitch it. |
| `wayfinder` | Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear. |
| `wizard` | Generate an interactive bash wizard that walks a human through steps only they can perform. Use when provisioning infrastructure, setting up credentials or CI secrets, walking an unfamiliar third-party dashboard, or running a one-off migration or cutover. Don't invoke this for steps the agent can perform itself. |
| `writing-beats` | Writing, exploit; assemble raw material into a journey of beats, grounding each term before a beat leans on it. |
| `writing-for-agents` | Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md. |
| `writing-fragments` | Writing, explore: mine raw fragments, no structure yet. |
| `writing-shape` | Writing, exploit: shape raw material into an article, paragraph by paragraph. |

## gstack (Garry Tan)

Source: [`garrytan/gstack`](https://github.com/garrytan/gstack) · v1.72.0.0 · Role-based virtual engineering team skills (slimmed: Markdown plus skill scripts).

| Skill | Description |
| --- | --- |
| `gstack` | Router for the gstack skill suite. (gstack) |
| `autoplan` | Auto-review pipeline — reads the full CEO, design, eng, and DX review skills from disk and runs them sequentially with auto-decisions using 6 decision principles. (gstack) |
| `benchmark-models` | Cross-model benchmark for gstack skills. (gstack) |
| `benchmark` | Performance regression detection using the browse daemon. (gstack) |
| `browse` | Fast headless browser for QA testing and site dogfooding. (gstack) |
| `canary` | Post-deploy canary monitoring. (gstack) |
| `careful` | Safety guardrails for destructive commands. (gstack) |
| `codex` | OpenAI Codex CLI wrapper — three modes. (gstack) |
| `context-restore` | Restore working context saved earlier by /context-save. (gstack) |
| `context-save` | Save working context. (gstack) |
| `cso` | Chief Security Officer mode. (gstack) |
| `design-consultation` | Design consultation: understands your product, researches the landscape, proposes a complete design system (aesthetic, typography, color, layout, spacing, motion), and generates font+color preview... (gstack) |
| `design-html` | Design finalization: generates production-quality Pretext-native HTML/CSS. (gstack) |
| `design-review` | Designer's eye QA: finds visual inconsistency, spacing issues, hierarchy problems, AI slop patterns, and slow interactions — then fixes them. (gstack) |
| `design-shotgun` | Design shotgun: generate multiple AI design variants, open a comparison board, collect structured feedback, and iterate. (gstack) |
| `devex-review` | Live developer experience audit. (gstack) |
| `diagram` | Turn an English description (or mermaid source) into a diagram triplet: the source, an editable .excalidraw file you can open on excalidraw.com, and rendered SVG + PNG. (gstack) |
| `document-generate` | Generate missing documentation from scratch for a feature, module, or entire project. (gstack) |
| `document-release` | Post-ship documentation update. (gstack) |
| `freeze` | Restrict file edits to a specific directory for the session. (gstack) |
| `gstack-openclaw-ceo-review` | Use when asked to review a plan, challenge a proposal, run a CEO review, poke holes in an approach, think bigger about scope, or decide whether to expand or reduce the plan. |
| `gstack-openclaw-investigate` | Use when asked to debug, fix a bug, investigate an error, or do root cause analysis, and when users report errors, stack traces, unexpected behavior, or say something stopped working. |
| `gstack-openclaw-office-hours` | Use when asked to brainstorm, evaluate whether an idea is worth building, run office hours, or think through a new product idea or design direction before any code is written. |
| `gstack-openclaw-retro` | Weekly engineering retrospective. Analyzes commit history, work patterns, and code quality metrics with persistent history and trend tracking. Team-aware with per-person contributions, praise, and growth areas. Use when asked for weekly retro, what shipped this week, or engineering retrospective. |
| `gstack-upgrade` | Upgrade gstack to the latest version. |
| `guard` | Full safety mode: destructive command warnings + directory-scoped edits. (gstack) |
| `hackernews-frontpage` | Scrape the Hacker News front page (titles, points, comment counts). |
| `health` | Code quality dashboard. (gstack) |
| `investigate` | Systematic debugging with root cause investigation. (gstack) |
| `ios-clean` | Remove the DebugBridge SPM package and all #if DEBUG wiring from an iOS app. (gstack) |
| `ios-design-review` | Visual design audit for iOS apps on real hardware. (gstack) |
| `ios-fix` | Autonomous iOS bug fixer. (gstack) |
| `ios-qa` | Live-device iOS QA for SwiftUI apps. (gstack) |
| `ios-sync` | Regenerate the iOS debug bridge against the latest upstream gstack templates. (gstack) |
| `land-and-deploy` | Land and deploy workflow. (gstack) |
| `landing-report` | Read-only queue dashboard for workspace-aware ship. (gstack) |
| `learn` | Manage project learnings. |
| `make-pdf` | Turn any markdown file into a publication-quality PDF. (gstack) |
| `office-hours` | YC Office Hours — two modes. (gstack) |
| `open-gstack-browser` | Launch GStack Browser — AI-controlled Chromium with the sidebar extension baked in. |
| `pair-agent` | Pair a remote AI agent with your browser. (gstack) |
| `plan-ceo-review` | CEO/founder-mode plan review. (gstack) |
| `plan-design-review` | Designer's eye plan review — interactive, like CEO and Eng review. (gstack) |
| `plan-devex-review` | Interactive developer experience plan review. (gstack) |
| `plan-eng-review` | Eng manager-mode plan review. (gstack) |
| `plan-tune` | Self-tuning question sensitivity + developer psychographic for gstack (v1: observational). (gstack) |
| `qa-only` | Report-only QA testing. (gstack) |
| `qa` | Systematically QA test a web application and fix bugs found. (gstack) |
| `retro` | Weekly engineering retrospective. (gstack) |
| `review` | Pre-landing PR review. (gstack) |
| `scrape` | Pull data from a web page. (gstack) |
| `setup-browser-cookies` | Import cookies from your real Chromium browser into the headless browse session. (gstack) |
| `setup-deploy` | Configure deployment settings for /land-and-deploy. |
| `setup-gbrain` | Set up gbrain for this coding agent: install the CLI, initialize a local PGLite or Supabase brain, register MCP, capture per-remote trust policy. (gstack) |
| `ship` | Ship workflow: detect + merge base branch, run tests, review diff, bump VERSION, update CHANGELOG, commit, push, create PR. (gstack) |
| `skillify` | Codify the most recent successful /scrape flow into a permanent browser-skill on disk. (gstack) |
| `spec` | Turn vague intent into a precise, executable spec in five phases. (gstack) |
| `sync-gbrain` | Keep gbrain current with this repo's code and refresh agent search guidance in CLAUDE.md. (gstack) |
| `unfreeze` | Clear the freeze boundary set by /freeze, allowing edits to all directories again. (gstack) |

## pstack (Lauren Tan / poteto)

Source: [`cursor/plugins/pstack`](https://github.com/cursor/plugins/tree/main/pstack) · v0.14.5 · Official Cursor pstack. Rigorous agent workflow skills.

| Skill | Description |
| --- | --- |
| `architect` | Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for /architect, 'architect this', 'design this', or non-trivial work where jumping to code would lock in the wrong shape. |
| `arena` | Spawn N parallel candidates at the same task, pick a base, graft the strongest parts of the losers into it. Use for /arena, 'arena this', 'throw it in the arena', or when one attempt at a non-trivial artifact would lock in the wrong shape. |
| `automate-me` | Use for \"automate me\", \"create/update/refresh my -mode skill\", \"turn/capture my preferences or working style into a skill\", or wanting agents to follow how the user works. Drafts or revises a personal -mode skill via create-skill + unslop, optionally pulling fresh evidence from recent transcripts. |
| `blast-radius` | Find what a change could break somewhere else before it ships, beyond the diff, and prove the one fact it's safe because of by running real code instead of writing it up. Use for 'blast radius of X', 'what could this break', or reviewing a small diff you don't trust. |
| `bro` | Restate the last message in plain human language, with no jargon. |
| `create-verification-skill` | Generate a project-local verification skill that drives your app the way a user does — any language, framework, or platform. Use for /create-verification-skill, \"make a control skill for this repo\", or when a project has no scripted way to prove UI/CLI/service behavior. |
| `figure-it-out` | Design an auditable playbook when no narrower one fits: a large migration, an ambitious multi-part change, or work a human reviews after stepping away. Scales rigor to the task, runs a hypothesis loop, and logs decisions via show-me-your-work. Use for /figure-it-out, 'figure it out', a large migration, or when no narrower playbook applies. |
| `how` | Use for \"how does X work\", code walkthroughs before changing something, and placement / ownership / layering questions (\"where should this live\", \"which package owns this\", \"is this the right layer\"). Explains subsystem architecture, runtime flow, onboarding mental models. Can critique architecture. Use why for motivation. |
| `interrogate` | Use for \"interrogate\", \"adversarial review\", \"multi-model review\", \"challenge this\", \"stress test this code\", \"find blind spots\", or \"tear this apart\". Multiple LLM reviewers challenge changes from independent angles. |
| `maintain-verification-skill` | Periodic pass that keeps a project's verification skill and feature map honest: parallel source readers per feature, one live session driving every feature, at most one PR of proven corrections. Use for /maintain-verification-skill or \"audit the verify skill\". |
| `Make Bot UI` | >- |
| `no-comments` | Spawn Comment Sicko, fix accepted findings, and offer encodings for claimed constraints. |
| `Poteto Mode` | poteto's agent style for concise, detailed responses, deliberate subagents, unslopped prose, simple code, and verified work. Use for poteto, /poteto-mode, or requests to work in this style. |
| `principle-boundary-discipline` | Apply when wiring validation, error handling, or framework adapters. Concentrate guards at system boundaries (CLI, config, network, external APIs); trust internal types and keep business logic in pure functions. |
| `principle-build-the-lever` | Apply to any non-trivial work, not just bulk work: edits, migrations, analyses, checks. Build the tool that does it or proves it (codemod, script, generator, or a skill your subagents follow) instead of working by hand. The tool is the artifact a reviewer can rerun. |
| `principle-encode-lessons-in-structure` | Apply when you catch yourself writing the same instruction a second time, or notice a recurring correction. Encode the rule as a lint, metadata flag, runtime check, or script instead of more text. |
| `principle-exhaust-the-design-space` | Apply when facing a novel UI interaction or architectural decision with no precedent in the codebase. Build 2-3 competing prototypes and compare side by side before committing. |
| `principle-experience-first` | Apply when product, UX, or feature-scope tradeoffs come up. Choose user delight over implementation convenience; ship fewer polished features over more rough ones. |
| `principle-fix-root-causes` | Apply when debugging. Trace each symptom to its root cause and fix it there; reproduce first, ask why until you reach it, resist nil-check guards that silence crashes. |
| `principle-foundational-thinking` | Apply before writing logic: choosing core types and data structures, sequencing scaffold-vs-feature work, asking what concurrent actors share. Get the data structures right so downstream code becomes obvious. |
| `principle-guard-the-context-window` | Apply when context is filling up: large outputs, long files, repeated reads, fan-out planning. Route bulk to subagents; keep summaries in the main thread, not raw payloads. |
| `principle-laziness-protocol` | Apply when refactoring, evaluating diff size, or tempted to add abstractions, layers, or signal threading. Bias toward deletion and the smallest change that solves the problem. |
| `principle-make-operations-idempotent` | Apply when designing commands, lifecycle steps, or processing loops that run amid crashes, restarts, and retries. Converge to the same end state regardless of partial prior runs. |
| `principle-migrate-callers-then-delete-legacy-apis` | Apply when introducing a new internal API while old callers still exist. Migrate callers and delete the old API in the same wave instead of preserving compatibility layers. |
| `principle-minimize-reader-load` | Apply when reviewing or shaping code that's hard to trace. Count layers between question and answer, and hidden state in the reader's head; collapse one-caller wrappers and shrink mutable scope. |
| `principle-model-the-domain` | Apply when writing stateful logic, or when code branches a lot or repeats a shape assumption across files. Encode the domain in a structure instead of scattered conditionals. |
| `principle-never-block-on-the-human` | Apply when tempted to ask 'should I do X?' on reversible work. Proceed, present the result, let the human course-correct after the fact; reserve confirmation for irreversible actions. |
| `principle-outcome-oriented-execution` | Apply during planned rewrites and migrations with explicit phase boundaries. Converge on the target architecture; don't preserve smooth intermediate states with throwaway compatibility code. |
| `principle-prove-it-works` | Apply after completing a task, before declaring done. Verify against the real artifact (run the feature, read the actual value, inspect the diff), not a proxy, self-report, or 'it compiles.' |
| `principle-redesign-from-first-principles` | Apply when integrating a new requirement into an existing design. Redesign as if the requirement had been a foundational assumption from day one, instead of bolting it on. |
| `principle-separate-before-serializing-shared-state` | Apply when concurrent actors might write to the same file, branch, key, or state object. Eliminate the sharing first; serialize structurally only when one shared writer is a real invariant. |
| `principle-sequence-verifiable-units` | Apply to multi-step work (sweeps, migrations, runs of similar edits) and to how you stack commits and PRs. Break work into small units that each end in a verifiable state, check each before the next, and order delivery so the sequence proves itself to a reviewer. |
| `principle-subtract-before-you-add` | Apply when sequencing an addition, refactor, or rewrite. Remove dead weight, redundant validators, and stub references first, then build on the simpler base. |
| `principle-type-system-discipline` | Apply when designing types, reviewing a function signature, or writing code in any statically-typed language. Make illegal states unrepresentable, brand semantic primitives, parse external data at boundaries, refuse to lie to the compiler, exhaust variants, derive from authoritative schemas. |
| `recall` | Reconstruct your recent working context from your own chat history, live state, and the shared record (user reports, prior fixes, incidents), then hand back a tight current-state brief. Use for 'recall my work on X', 'catch me up', 'what have I been working on', 'where did I leave off', before starting or resuming work. |
| `reflect` | Spawn three parallel review subagents over the active transcript, surface learnings, and route each to a concrete edit on an existing skill. Use when the user says reflect. |
| `setup-pstack` | Configure which models pstack uses per role. Detects your available models and writes an always-applied rule that overrides the skill defaults. Use for /setup-pstack, "configure pstack models", or changing pstack's model choices. |
| `show-me-your-work` | Keep a reviewable decision trail for long-running or unattended work: a TSV log with one row per decision (what, why, evidence, result). Local by default; commit it when a reviewer needs the trail to trust the result. Use for /show-me-your-work, autonomous or multi-phase runs, or work a human reviews after stepping away. |
| `swarm` | Fan out N parallel workers, drain them, and return one report. Use for /swarm, 'swarm this', or parallel coverage, races, gauntlets, and exploration. |
| `tdd` | Use only when the user explicitly asks for TDD, a failing test, or a regression test, OR when the bug has an obvious cheap local test target. Skip when the test path is unclear, expensive, integration-heavy, or not requested. |
| `teach` | Explain a body of work plainly so a person actually understands it. Runs the `how` and `why` skills and weaves what they find into one clear explanation. Use for 'teach me this', 'help me really understand X', 'explain this change or subsystem to me'. |
| `technical-writing` | Layered technical-writing standard: Diátaxis structure, Google developer style sentences, STE instruction rules, Global English syntax. Use for /technical-writing or when writing or reviewing docs, RFCs, readmes, PR descriptions, or commit messages. |
| `typescript-best-practices` | TypeScript best practices. Use when reading or editing any .ts or .tsx file. |
| `unslop` | Cut AI tells from any writing. Must always apply. |
| `why` | Use for 'why does X work this way', 'why we picked Y', design rationale, regressions, postmortems, or data-backed thresholds. Discovers available MCPs and queries each evidence category (source control, issue tracker, long-form docs, real-time chat, infrastructure observability, error tracking, product analytics warehouse) in parallel, then returns a cited read on decisions and tradeoffs. Use how for runtime behavior. |

## improve (shadcn)

Source: [`shadcn/improve`](https://github.com/shadcn/improve) · v03369ee · Audits a codebase and writes execution plans. Does not implement the plans itself.

| Skill | Description |
| --- | --- |
| `improve` | Survey any codebase as a senior advisor and produce prioritized, self-contained implementation plans for OTHER models/agents to execute. Strictly read-only on source code — never implements, fixes, or refactors anything itself. Use when asked to audit a codebase, find improvement opportunities (bugs, security, performance, test coverage, tech debt, migrations, DX), suggest features or where to take the project next (roadmap, product direction), or generate handoff plans for another agent to implement. |

## Cursor Team Kit

Source: [`cursor/plugins/cursor-team-kit`](https://github.com/cursor/plugins/tree/main/cursor-team-kit) · v1.2.0 · Cursor internal CI, review, shipping, and verification workflows.

| Skill | Description |
| --- | --- |
| `check-compiler-errors` | Run compile and type-check commands and report failures |
| `control-cli` | Build or adapt a local harness to drive, inspect, and profile an interactive CLI or TUI without external services. Use for CLI UX checks, startup regressions, memory leaks, hangs, prompt flows, or terminal demos. |
| `control-ui` | Build or adapt a local browser/CDP harness to drive and inspect a web, IDE, or Electron UI. Use for local UI verification, screenshots, accessibility snapshots, perf profiles, visual diffs, or reproducing UI bugs. |
| `deslop` | Remove AI-generated code slop and clean up code style |
| `fix-ci` | Find failing PR checks, inspect logs or external check links, and apply focused fixes |
| `fix-merge-conflicts` | Resolve merge conflicts non-interactively, validate build and tests, and finalize conflict resolution |
| `get-pr-comments` | Fetch and summarize review comments from the active pull request |
| `loop-on-ci` | Monitor PR checks and fix failures until green. Uses gh pr checks as the source of truth for PR-attached checks. |
| `make-pr-easy-to-review` | Prepare PRs for review by cleaning noisy history, improving PR descriptions, and adding reviewer guidance without changing code behavior. Use for "make this easy to review", "tidy this PR", "clean up commits", or "annotate the diff". |
| `new-branch-and-pr` | Create a fresh branch, complete work, and open a pull request |
| `pr-review-canvas` | Generate an interactive PR review walkthrough as an HTML page. Fetches PR data via gh API, categorizes files into core vs mechanical changes, adds reviewer annotations, and renders diffs with moved-code detection. Use when the user pastes a GitHub PR URL and asks for a review, walkthrough, or summary, or says "review this PR". |
| `review-and-ship` | Review the current branch for bugs, intent fit, and test coverage; run or write tests; commit focused work; open or update a PR. |
| `run-smoke-tests` | Run Playwright smoke tests, debug failures, and verify fixes |
| `thermo-nuclear-code-quality-review` | Run an extremely strict maintainability review for abstraction quality, giant files, and spaghetti-condition growth. Use for a thermo-nuclear code quality review, thermonuclear review, deep code quality audit, or especially harsh maintainability review. |
| `verify-this` | Verify a claim with fresh local evidence: restate it falsifiably, capture baseline and treatment, compare artifacts, and return VERIFIED, NOT VERIFIED, or INCONCLUSIVE. |
| `weekly-review` | Produce a weekly synthesis of authored commits with highlights by bugfix, tech debt, and net-new work |
| `what-did-i-get-done` | Summarize authored commits over a user-specified time period into a concise update |
| `workflow-from-chats` | Extract durable working preferences from recent Cursor chats and convert them into skills, rules, or workflow docs. Use when asked to learn preferences, mine feedback, personalize workflows, or generate team/person-specific agent guidance. |

## Vercel Agent Skills

Source: [`vercel-labs/agent-skills`](https://github.com/vercel-labs/agent-skills) · v063bee9 · Official Vercel web, React, writing, and deploy skills.

| Skill | Description |
| --- | --- |
| `vercel-composition-patterns` |  |
| `deploy-to-vercel` | Deploy applications and websites to Vercel. Use when the user requests deployment actions like "deploy my app", "deploy and give me the link", "push this live", or "create a preview deployment". |
| `vercel-react-best-practices` | React and Next.js performance optimization guidelines from Vercel Engineering. This skill should be used when writing, reviewing, or refactoring React/Next.js code to ensure optimal performance patterns. Triggers on tasks involving React components, Next.js pages, data fetching, bundle optimization, or performance improvements. |
| `vercel-react-native-skills` |  |
| `vercel-react-view-transitions` | Guide for implementing smooth, native-feeling animations using React's View Transition API (`<ViewTransition>` component, `addTransitionType`, and CSS view transition pseudo-elements). Use this skill whenever the user wants to add page transitions, animate route changes, create shared element animations, animate enter/exit of components, animate list reorder, implement directional (forward/back) navigation animations, or integrate view transitions in Next.js. Also use when the user mentions view transitions, `startViewTransition`, `ViewTransition`, transition types, or asks about animating between UI states in React without third-party animation libraries. |
| `vercel-cli-with-tokens` | Deploy and manage projects on Vercel using token-based authentication. Use when working with Vercel CLI using access tokens rather than interactive login — e.g. "deploy to vercel", "set up vercel", "add environment variables to vercel". |
| `vercel-optimize` | Use for Vercel cost and performance optimization on deployed projects, especially Next.js, SvelteKit, Nuxt, and limited Astro apps. Collect Vercel metrics, usage, project config, and code scan results first; investigate only metric-backed candidates; produce ranked recommendations grounded in verified files and version-aware Vercel/framework docs. Trigger for Vercel bill reduction, slow or expensive routes, caching opportunities, Function Invocations, Build Minutes, Fast Data Transfer, Core Web Vitals, Bot Management, Fluid compute, or cost breakdown requests. |
| `web-design-guidelines` | Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices". |
| `writing-guidelines` | Review docs/prose for Writing Guidelines compliance. Use when asked to "review my docs", "check writing style", "audit prose", "review docs voice and tone", or "check this page against the writing handbook". |

## Addy Osmani — Agent Skills

Source: [`addyosmani/agent-skills`](https://github.com/addyosmani/agent-skills) · v0.6.8 · Production engineering skills across spec, build, test, review, and ship.

| Skill | Description |
| --- | --- |
| `api-and-interface-design` | Guides stable API and interface design. Use when designing APIs, module boundaries, or any public interface. Use when creating REST or GraphQL endpoints, defining type contracts between modules, or establishing boundaries between frontend and backend. |
| `browser-testing-with-devtools` | Tests in real browsers via Chrome DevTools MCP. Use when building or debugging anything that runs in a browser. Use when you need to inspect the DOM, capture console errors, analyze network requests, profile performance, or verify visual output with real runtime data. Requires the chrome-devtools MCP server to be configured. |
| `ci-cd-and-automation` | Automates CI/CD pipeline setup. Use when setting up or modifying build and deployment pipelines. Use when you need to automate quality gates, configure test runners in CI, or establish deployment strategies. |
| `code-review-and-quality` | Conducts multi-axis code review. Use before merging any change. Use when reviewing code written by yourself, another agent, or a human. Use when you need to assess code quality across multiple dimensions before it enters the main branch. |
| `code-simplification` | Simplifies code for clarity. Use when refactoring code for clarity without changing behavior. Use when code works but is harder to read, maintain, or extend than it should be. Use when reviewing code that has accumulated unnecessary complexity. |
| `constraint-driven-development` | Establishes a project's quality bar as a written contract and stops agents quietly lowering it. Interviews the user on which dimensions matter, supplies sane default thresholds when they have no number in mind, records everything in CONSTRAINTS.md, and watches the diff for a weakened bar — new @ts-ignore or eslint-disable suppressions, skipped or deleted tests, assertions stripped out, unimplemented stubs, thresholds edited down. Use when no quality bar is written down, when the user says "set up constraints" or "define our standards", when an agent keeps silencing checks or skipping tests to get to green, when you need a coverage or performance threshold and don't know what number to pick, or when an agent writes more code than anyone will read. |
| `context-engineering` | Optimizes agent context setup. Use when starting a new session, when agent output quality degrades, when switching between tasks, or when you need to configure rules files and context for a project. |
| `debugging-and-error-recovery` | Guides systematic root-cause debugging. Use when tests fail, builds break, behavior doesn't match expectations, or you encounter any unexpected error. Use when you need a systematic approach to finding and fixing the root cause rather than guessing. |
| `deprecation-and-migration` | Manages deprecation and migration. Use when removing old systems, APIs, or features. Use when migrating users from one implementation to another. Use when deciding whether to maintain or sunset existing code. |
| `documentation-and-adrs` | Records decisions and documentation. Use when making architectural decisions, changing public APIs, shipping features, or when you need to record context that future engineers and agents will need to understand the codebase. |
| `doubt-driven-development` | Subjects every non-trivial decision to a fresh-context adversarial review before it stands. Use when correctness matters more than speed, when working in unfamiliar code, when stakes are high (production, security-sensitive logic, irreversible operations), or any time a confident output would be cheaper to verify now than to debug later. |
| `frontend-ui-engineering` | Builds production-quality, accessible, responsive user-facing UIs. Use when building or modifying interfaces and pages, creating components, implementing layouts, meeting WCAG accessibility requirements, managing state, or when the output needs to look and feel production-quality rather than AI-generated. |
| `git-workflow-and-versioning` | Structures git workflow practices. Use when making any code change. Use when committing, branching, resolving conflicts, opening or reviewing a pull request (PR), pushing to a remote, or when you need to organize work across multiple parallel streams. Use when cutting a release, choosing a semantic version bump, tagging, or writing a changelog. |
| `idea-refine` | Refines raw ideas into sharp, actionable concepts through structured divergent and convergent thinking. Use when an idea is still vague, when you need to stress-test assumptions before committing to a plan, or when you want to expand options before converging on one. Triggers on "ideate", "refine this idea", or "stress-test my plan". |
| `incremental-implementation` | Delivers changes incrementally. Use when implementing any feature or change that touches more than one file. Use when you're about to write a large amount of code at once, or when a task feels too big to land in one step. |
| `interview-me` | Extracts what the user actually wants instead of what they think they should want. Achieves this through one-question-at-a-time interview until ~95% confidence about the underlying intent. Use when an ask is underspecified ("build me X" without "for whom" or "why now"), when the user explicitly invokes ("interview me", "grill me", "are we sure?", "stress-test my thinking"), or when you catch yourself silently filling in ambiguous requirements before any plan, spec, or code exists. |
| `observability-and-instrumentation` | Instruments code so production behavior is visible and diagnosable. Use when adding logging, metrics, tracing, or alerting. Use when shipping any feature that runs in production and you need evidence it works. Use when production issues are reported but you can't tell what happened from the available data. |
| `performance-optimization` | Optimizes application performance across frontend, backend, queries, and databases. Use when performance requirements exist, when you suspect performance regressions, when Core Web Vitals or load times need improvement, when N+1 query patterns need fixing, or when profiling reveals bottlenecks. |
| `planning-and-task-breakdown` | Breaks work into ordered tasks. Use when you have a spec or clear requirements and need to break work into implementable tasks. Use when a task feels too large to start, when you need to estimate scope, or when parallel work is possible. |
| `security-and-hardening` | Hardens code against vulnerabilities. Use when handling user input, authentication, data storage, or external integrations. Use when building any feature that accepts untrusted data, manages user sessions, or interacts with third-party services. Use when personal data or privacy compliance (GDPR, CCPA) is involved. |
| `shipping-and-launch` | Prepares production launches. Use when preparing to deploy to production. Use when you need a pre-launch checklist, when setting up monitoring, when planning a staged rollout, or when you need a rollback strategy. |
| `source-driven-development` | Grounds every implementation decision in official documentation. Use when you want authoritative, source-cited code free from outdated patterns. Use when building with any framework or library where correctness matters. |
| `spec-driven-development` | Creates specs before coding. Use when starting a new project, feature, or significant change and no specification exists yet. Use when requirements are unclear, ambiguous, or only exist as a vague idea. Use when a single requirement spans several independently testable capabilities and needs decomposing into a capability map of modules before specifying. |
| `test-driven-development` | Drives development with tests. Use when implementing any logic, fixing any bug, or changing any behavior. Use when you need to prove that code works, when a bug report arrives, or when you're about to modify existing functionality. |
| `using-agent-skills` | Discovers and invokes agent skills. Use when starting a session or when you need to discover which skill applies to the current task. This is the meta-skill that governs how all other skills are discovered and invoked. |

## find-skills (Vercel Labs)

Source: [`vercel-labs/skills`](https://github.com/vercel-labs/skills) · v1.5.23 · Skill #0 / discovery. On-demand lookup, not an always-on personality.

| Skill | Description |
| --- | --- |
| `find-skills` | Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending capabilities. This skill should be used when the user is looking for functionality that might exist as an installable skill. |

## Trail of Bits

Source: [`trailofbits/skills`](https://github.com/trailofbits/skills) · vd1f1575 · Security research, review, and audit skills. Discover on demand; do not always-apply every skill.

| Skill | Description |
| --- | --- |
| `address-sanitizer` | Builds and runs code under AddressSanitizer to catch buffer overflows, use-after-free, and other memory errors during fuzzing or tests. Covers -fsanitize=address builds, ASAN_OPTIONS, reading the crash report, LeakSanitizer, and the overhead and platform trade-offs. Use when fuzzing C/C++ or Rust that has unsafe blocks or FFI, when debugging a memory corruption crash, or when reading an ASan stack trace. |
| `aflpp` | Sets up and runs AFL++ for multi-core fuzzing of C/C++ projects built with afl-clang-fast or afl-gcc-fast. Covers instrumentation modes, parallel main and secondary campaigns, persistent mode, corpus minimization, and crash triage. Use when scaling fuzzing across cores, fuzzing a mature C/C++ codebase, reading the afl-fuzz status screen, or moving on after libFuzzer has plateaued. |
| `agentic-actions-auditor` | Audits GitHub Actions workflows for security vulnerabilities in AI agent integrations including Claude Code Action, Gemini CLI, OpenAI Codex, and GitHub AI Inference. Detects attack vectors where attacker-controlled input reaches AI agents running in CI/CD pipelines, including env var intermediary patterns, direct expression injection, dangerous sandbox configurations, and wildcard user allowlists. Use when reviewing workflow files that invoke AI coding agents, auditing CI/CD pipeline security for prompt injection risks, or evaluating agentic action configurations. |
| `algorand-vulnerability-scanner` | Scans Algorand smart contracts for 11 common vulnerabilities including rekeying attacks, unchecked transaction fees, missing field validations, and access control issues. Use when auditing Algorand projects (TEAL/PyTeal). |
| `atheris` | Sets up and runs Atheris, the coverage-guided Python fuzzer built on libFuzzer. Covers TestOneInput harnesses, FuzzedDataProvider, instrumenting both pure Python and native C extensions, and running under AddressSanitizer. Use when fuzzing a Python package, hunting memory corruption in a Python C extension, or choosing between Atheris and Hypothesis for a Python target. |
| `audit-augmentation` | > |
| `audit-context-building` | Understand a codebase before looking for bugs in it - what each function assumes, what it guarantees, and what it depends on elsewhere. Use when starting an audit, threat model, or architecture review on unfamiliar code, and before any vulnerability-hunting pass. |
| `audit-prep-assistant` | Prepares codebases for security review using Trail of Bits' checklist. Helps set review goals, runs static analysis tools, increases test coverage, removes dead code, ensures accessibility, and generates documentation (flowcharts, user stories, inline comments). Use when preparing your own codebase to be audited by someone else, getting a repository review-ready before an external security review, deciding what to fix before auditors start, or asking what assessors need from a project. For understanding unfamiliar code you are about to audit, use audit-context-building instead. |
| `burpsuite-project-parser` | Searches and explores Burp Suite project files (.burp) from the command line. Use when searching response headers or bodies with regex patterns, extracting security audit findings, dumping proxy history or site map data, or analyzing HTTP traffic captured in a Burp project. |
| `c-review` | Performs comprehensive C/C++ security review for memory corruption, integer overflows, race conditions, and platform-specific vulnerabilities. Use when auditing native C/C++ applications, reviewing daemons or services for memory safety, or hunting integer overflow / use-after-free / race conditions in userspace code. |
| `cairo-vulnerability-scanner` | Scans Cairo/StarkNet smart contracts for 6 critical vulnerabilities including felt252 arithmetic overflow, L1-L2 messaging issues, address conversion problems, and signature replay. Use when auditing StarkNet projects. |
| `cargo-fuzz` | Sets up and runs cargo-fuzz, the standard fuzzing tool for Cargo-based Rust projects. Covers cargo fuzz init, the nightly toolchain requirement, fuzz_target! harnesses, Arbitrary-derived structured inputs, sanitizer options, cargo fuzz coverage, and reproducing a crash artifact. Use when fuzzing a Rust crate, writing a fuzz_target!, exercising unsafe blocks or FFI in Rust, or triaging a cargo fuzz crash. |
| `chrome-mcp-troubleshooting` | Diagnose and fix Claude in Chrome MCP extension connectivity issues. Use when mcp__claude-in-chrome__* tools fail, return "Browser extension is not connected", or behave erratically. |
| `code-improver` | Runs an autonomous review-and-fix improvement loop over any code target — a skill, plugin, module, or directory — using a reviewer the user names: any installed skill or agent. Keeps a cross-round findings ledger, escalates when fixes stop converging, and guards scope mechanically. Use when asked to 'improve this code until review passes', 'run an improvement loop with <reviewer>', or to iterate review-and-fix with a specific reviewer. For skills prefer the skill-improver entry; for a branch prefer pr-improver. |
| `code-maturity-assessor` | Systematic code maturity assessment using Trail of Bits' 9-category framework. Analyzes codebase for arithmetic safety, auditing practices, access controls, complexity, decentralization, documentation, MEV risks, low-level code, and testing, then produces a scorecard with evidence-based ratings and a priority-ordered roadmap. Use when assessing or scoring the maturity of a smart contract or blockchain codebase, producing a maturity scorecard or evaluation, or judging how mature, well-tested, or well-documented such a project is against a rubric. |
| `codeql` | >- |
| `constant-time-analysis` | Detects timing side-channel vulnerabilities in cryptographic code. Use when implementing or reviewing crypto code, encountering division on secrets, secret-dependent branches, or constant-time programming questions in C, C++, Go, Rust, Swift, Java, Kotlin, C#, PHP, JavaScript, TypeScript, Python, or Ruby. |
| `constant-time-testing` | Measures timing side channels in cryptographic implementations by running them, using dudect for statistical analysis and Timecop over Valgrind for dynamic tracing. Covers the formal, symbolic, dynamic, and statistical tool categories and how to read a result. Use when testing whether a running implementation is constant-time, measuring timing variance on a compiled binary, or investigating a suspected timing attack. Not for statically inspecting compiler output — the constant-time-analysis plugin covers that. |
| `cosmos-vulnerability-scanner` | Scans Cosmos SDK blockchain modules and CosmWasm contracts for consensus-critical vulnerabilities — chain halts, fund loss, state divergence. 25 core + 16 IBC + 10 EVM + 3 CosmWasm patterns. Use when auditing custom x/ modules, reviewing IBC integrations, or assessing pre-launch chain security. Updated for SDK v0.53.x. |
| `coverage-analysis` | Measures and interprets what a fuzzing campaign actually reaches, using llvm-cov, lcov, or a fuzzer's own coverage output. Covers baselining a new campaign, reading coverage reports, and turning uncovered regions into harness, seed, or dictionary work. Use when a fuzzer plateaus, when judging whether a harness is effective, after changing a harness, or when asking why some code is never reached. |
| `crypto-protocol-diagram` | Extracts protocol message flow from source code, RFCs, academic papers, pseudocode, informal prose, ProVerif (.pv), or Tamarin (.spthy) models and generates Mermaid sequenceDiagrams with cryptographic annotations. Use when diagramming a crypto protocol, visualizing a handshake or key exchange flow, extracting message flow from a spec or RFC, diagramming a ProVerif or Tamarin model, or drawing sequence diagrams for TLS, Noise, Signal, X3DH, Double Ratchet, FROST, DH, or ECDH protocols. |
| `devcontainer-setup` | Creates devcontainers with Claude Code, language-specific tooling (Python/Node/Rust/Go), and persistent volumes. Use when adding devcontainer support to a project, setting up isolated development environments, or configuring sandboxed Claude Code workspaces. |
| `diagramming-code` | > |
| `differential-review` | Performs security-focused differential review of code changes. Adapts analysis depth to codebase size, uses git blame for context, calculates blast radius by counting callers, checks test coverage of modified code, and generates a markdown report. Use when reviewing a PR, commit, or diff for security vulnerabilities, checking whether a change re-introduces a previously fixed bug, asking what else a change could break, or finding which modified code has no test covering it. |
| `dimensional-analysis` | Annotates codebases with dimensional analysis comments documenting units, dimensions, and decimal scaling. Use when someone asks to annotate units in a codebase, perform a dimensional analysis, or find vulnerabilities in a DeFi protocol, offchain code, or other blockchain-related codebase with arithmetic. Prevents dimensional mismatches and catches formula bugs early. |
| `dwarf-expert` | Analyzes DWARF debug information in compiled binaries. Use when inspecting .debug_* sections, DIE trees, or DW_TAG_/DW_AT_ entries with dwarfdump/llvm-dwarfdump or readelf, verifying debug info with llvm-dwarfdump --verify, answering DWARF standard questions, or writing code that parses DWARF (libdwarf, pyelftools, gimli). |
| `entry-point-analyzer` | Analyzes smart contract codebases to identify state-changing entry points for security auditing. Detects externally callable functions that modify state, categorizes them by access level (public, admin, role-restricted, contract-only), and generates structured audit reports. Excludes view/pure/read-only functions. Use when auditing smart contracts (Solidity, Vyper, Solana/Rust, Move, TON, CosmWasm) or when asked to find entry points, audit flows, external functions, access control patterns, or privileged operations. |
| `firebase-apk-scanner` | Scans Android APKs for Firebase security misconfigurations including open databases, storage buckets, authentication issues, and exposed cloud functions. Use when analyzing APK files for Firebase vulnerabilities, performing mobile app security audits, or testing Firebase endpoint security. For authorized security research only. |
| `fp-check` | Systematically verifies suspected security bugs to eliminate false positives, producing a TRUE POSITIVE or FALSE POSITIVE verdict with documented evidence for each. Use when asked whether a specific finding is real, exploitable, or a false positive, or to verify or validate a suspected vulnerability — not for hunting or discovering new bugs. |
| `fuzzing-dictionary` | Builds and applies fuzzing dictionaries so a fuzzer can produce the keywords, magic bytes, and tokens a target expects. Covers extracting tokens from source, headers, binaries, and specifications, dictionary syntax, and wiring one into libFuzzer or AFL++. Use when fuzzing a parser, protocol, or file format, when coverage stalls at input validation, or when a target compares against fixed strings. |
| `fuzzing-obstacles` | Patches past the barriers that stop a fuzzer making progress — checksum and hash verification, magic-value validation, time-based seeds, and other non-deterministic global state. Covers locating the blocking check, neutering it behind a fuzzing build flag, and avoiding the false positives a patch can introduce. Use when a fuzzer is stuck at validation, when coverage shows large regions behind a checksum, or when valid inputs are impractical to generate. |
| `genotoxic` | Graph-informed mutation testing triage. Parses codebases with Trailmark, runs mutation testing and necessist, then uses survived mutants, unnecessary test statements, and call graph data to identify false positives, missing test coverage, and fuzzing targets. Use when triaging survived mutants, analyzing mutation testing results, identifying test gaps, finding fuzzing targets from weak tests, running mutation frameworks (including circomvent and cairo-mutants), or using necessist. |
| `gh-cli` | Enforces authenticated gh CLI workflows over unauthenticated curl, WebFetch, and MCP fetch patterns. Use when working with GitHub URLs, API access, pull requests, or issues. |
| `github-triage` | Triages a repository's open GitHub issues and pull requests via the gh CLI. Optionally reviews and merges ready PRs — incrementally merging passing automated/bot PRs and maintainer-approved ones, and spawning review subagents for never-reviewed ones — then closes already-resolved issues with comments citing the resolving PR or commit, cross-links issues with their pending fix PRs, and assigns local-only priority and change-size estimates for everything outstanding. Use when triaging, grooming, or reviewing a repository's open issues and PRs. |
| `goal-prompt` | Drafts copy-paste-ready /goal commands for goal mode in Claude Code and Codex. Use when the user asks to create, write, rewrite, improve, compress, clean up, or prepare a goal prompt, goal condition, /goal command, goal-mode objective, or copy-ready long-running task objective. |
| `graph-evolution` | > |
| `guidelines-advisor` | Smart contract development advisor based on Trail of Bits' best practices. Analyzes codebase to generate documentation/specifications, review architecture, check upgradeability patterns, assess implementation quality, identify pitfalls, review dependencies, and evaluate testing. Use when asking whether a smart contract project follows development best practices, reviewing on-chain/off-chain split, upgradeability, or delegatecall proxy patterns against guidelines, or seeking recommendations on contract design, inheritance, events, documentation, dependencies, or test strategy. |
| `harness-writing` | Designs and improves fuzzing harnesses for C/C++ and Rust. Covers mapping raw bytes onto a target API, generating structured inputs, avoiding non-determinism and false crashes, and deciding what to fuzz together. Use when writing a first LLVMFuzzerTestOneInput or fuzz_target! harness, when a campaign finds nothing or reports crashes that will not reproduce, or when the target API needs structured rather than raw input. |
| `interpreting-culture-index` | Interprets Culture Index (CI) surveys, behavioral profiles, and personality assessment data. Supports individual profile interpretation, team composition analysis (gas/brake/glue), burnout detection, profile comparison, hiring profiles, manager coaching, interview transcript analysis for trait prediction, candidate debrief, onboarding planning, and conflict mediation. Accepts extracted JSON or PDF input via OpenCV extraction script. |
| `let-fate-decide` | Draws the 12 Houses of the Zodiac Tarot spread to inject entropy into planning when prompts are vague, ambiguous, or casually delegated. Interprets the spread to guide next steps. Use when the user says 'let fate decide', 'YOLO', 'whatever', 'idk', or other nonchalant phrases, makes Yu-Gi-Oh references, or when you are about to arbitrarily pick between multiple reasonable approaches. Prefer over asking clarifying questions when the user's tone is casual or playful rather than precision-seeking. |
| `libafl` | Builds custom fuzzers with LibAFL, the modular Rust fuzzing library. Covers composing observers, feedbacks, mutators, schedulers, and executors into a fuzzer for targets the standard tools do not fit. Use when writing a bespoke fuzzer or mutator, fuzzing a non-standard target or architecture, implementing a fuzzing research idea, or when libFuzzer and AFL++ lack the control you need. |
| `libfuzzer` | Sets up and runs libFuzzer, the coverage-guided fuzzer built into LLVM, on C/C++ code that compiles with Clang. Covers harness structure, -fsanitize=fuzzer builds, corpus and dictionary management, sanitizer integration, and campaign triage. Use when writing or debugging an LLVMFuzzerTestOneInput harness, starting fuzzing on a C/C++ library, choosing between libFuzzer and AFL++, or working out why a libFuzzer run finds nothing. |
| `mermaid-to-proverif` | Translates Mermaid sequenceDiagrams describing cryptographic protocols into ProVerif formal verification models (.pv files). Use when generating a ProVerif model, formally verifying a protocol, converting a Mermaid diagram to ProVerif, verifying protocol security properties (secrecy, authentication, forward secrecy), checking for replay attacks, or producing a .pv file from a sequence diagram. |
| `modern-cpp` | Guides C++ code toward modern idioms (C++20/23/26). Use when writing new C++ code, modernizing legacy patterns, or working on security-critical C++. Replaces raw pointers with smart pointers, SFINAE with concepts, printf with std::print, error codes with std::expected. |
| `modern-python` | Configures Python projects with modern tooling (uv, ruff, ty). Use when creating projects, writing standalone scripts, or migrating from pip/Poetry/mypy/black. |
| `mutation-testing` | Configures mewt or muton mutation testing campaigns — scopes targets, tunes timeouts, and optimizes long-running runs. Use when the user mentions mewt, muton, mutation testing, or wants to configure or optimize a mutation testing campaign. |
| `open-sourcing` | This skill should be used when the user asks to "open source this project", "prepare this repository for public release", "make this repo public", "check open-source readiness", "choose a license for this project", or "set up release automation" ahead of a public launch. Provides a release-readiness workflow covering secrets hygiene, licensing, documentation, CI, and language-specific packaging. |
| `ossfuzz` | Enrolls a project in OSS-Fuzz, Google's free continuous fuzzing service for open source, and drives it locally. Covers project.yaml, Dockerfile and build.sh setup, the helper scripts, reproducing OSS-Fuzz crash reports, and the acceptance criteria. Use when setting up continuous fuzzing for an open-source project, reproducing an OSS-Fuzz bug report, or testing an OSS-Fuzz build before submitting it. |
| `pr-improver` | Runs an autonomous review-and-fix improvement loop over the current branch's changes until a PR review comes back clean, scoped mechanically to the directories the branch touched. Reviews are performed by an installed PR-review skill (default: pr-review-toolkit's review-pr). Use to fix review findings on a branch before opening or updating a pull request ('clean up this branch', 'fix this PR until review passes', 'run review-and-fix on my changes'). NOT for a one-time review — run the PR-review skill directly. |
| `property-based-testing` | Writes, reviews, and debugs property-based tests — Hypothesis, fast-check, proptest, jqwik, rapid, and Echidna or Medusa for Solidity invariants. Use whenever tests should cover a whole input domain instead of a hand-picked list of examples: encode/decode and serialize/deserialize pairs, parsers, canonicalizers and normalizers, validators, numeric and Decimal types, comparators and sort order, data structures, and smart-contract state invariants. Also use when adding cases to an existing @given, fast-check, or proptest suite, when judging whether existing property tests assert anything real, and when a generator has shrunk a counterexample and you need to tell a wrong property from a genuine bug. Not for coverage-guided binary fuzzing (libFuzzer, AFL), mutation-testing campaigns, static analysis, benchmarking, or end-to-end UI tests. |
| `rust-review` | Performs comprehensive Rust security review for safe/unsafe boundary issues, memory safety in unsafe blocks, concurrency hazards, panic-induced DoS, FFI safety, and async runtime mistakes. Use when auditing Rust crates, services, or libraries — particularly those with `unsafe`, FFI, or concurrent code. |
| `ruzzy` | Sets up and runs Ruzzy, Trail of Bits' coverage-guided Ruby fuzzer and the only production-ready one for the language. Covers harness structure, fuzzing pure Ruby and the native C extensions in gems, and sanitizer builds. Use when fuzzing a Ruby library or gem, testing a Ruby C extension for memory safety, or asking how to fuzz Ruby at all. |
| `sarif-parsing` | >- |
| `second-opinion` | Runs external LLM code reviews (OpenAI Codex or Google Gemini CLI) on uncommitted changes, branch diffs, or specific commits. Use when the user asks for a second opinion, external review, codex review, gemini review, or mentions /second-opinion. |
| `secure-workflow-guide` | Guides through Trail of Bits' 5-step secure development workflow. Runs Slither scans, checks special features (upgradeability/ERC conformance/token integration), generates visual security diagrams, helps document security properties for fuzzing/verification, and reviews manual security areas. Use when securing a smart contract end to end rather than hunting one bug, checking a project on every check-in or before deployment, triaging a Slither report, or asking where to start on smart contract security. |
| `semgrep-rule-creator` | Creates custom Semgrep rules for detecting security vulnerabilities, bug patterns, and code patterns. Use when writing Semgrep rules or building custom static analysis detections. |
| `semgrep-rule-variant-creator` | Creates language variants of existing Semgrep rules. Use when porting a Semgrep rule to specified target languages. Takes an existing rule and target languages as input, produces independent rule+test directories for each language. |
| `semgrep` | >- |
| `sharp-edges` | Identifies error-prone APIs, dangerous configurations, and footgun designs that enable security mistakes. Use when reviewing API designs, configuration schemas, cryptographic library ergonomics, or evaluating whether code follows 'secure by default' and 'pit of success' principles. Triggers: footgun, misuse-resistant, secure defaults, API usability, dangerous configuration. |
| `skill-improver` | Runs an autonomous review-and-fix improvement loop over a Claude Code skill until a review comes back clean, with a cross-round findings ledger, escalation when fixes stop converging, and a mechanical scope guard. Reviews are performed by the plugin-dev skill-reviewer agent. Use to fix skill quality issues, iteratively refine a skill, or resume a loop after an escalation ('fix my skill', 'improve this skill until it passes review', 'skill improvement loop'). NOT for a one-time review — use the plugin-dev skill-reviewer agent directly. |
| `slicing-code-context` | Selects bounded, graph-informed source slices with Trailmark and delegates focused code analysis or patch-proposal work to a smaller subagent. Use when offloading function-, class-, caller-, callee-, call-path-, entrypoint-, or line-focused code tasks to constrained or locally hosted models without exposing the full repository. |
| `solana-vulnerability-scanner` | Scans Solana programs for 6 critical vulnerabilities including arbitrary CPI, improper PDA validation, missing signer/ownership checks, and sysvar spoofing. Use when auditing Solana/Anchor programs. |
| `spec-to-code-compliance` | Check code against the documentation that specifies it - which requirements hold, which the code contradicts, which are absent, and what the code does that no document mentions. Use when comparing an implementation against a whitepaper, protocol spec, or design document. |
| `substrate-vulnerability-scanner` | Scans Substrate/Polkadot pallets for 7 critical vulnerabilities including arithmetic overflow, panic DoS, incorrect weights, and bad origin checks. Use when auditing Substrate runtimes or FRAME pallets. |
| `supply-chain-risk-auditor` | Audits a project's dependencies for supply-chain risk: version-matched advisories for direct dependencies and the full lockfile tree, abandoned or archived upstreams, npm publisher concentration, and install-time script execution. Use when asked to audit dependencies, assess supply-chain or third-party package risk, or review a dependency tree before an engagement. |
| `testing-handbook-generator` | Generates Claude Code skills from the Trail of Bits Testing Handbook (appsec.guide), analyzing handbook pages and emitting SKILL.md files with the structure each skill type requires. Use when creating or refreshing a skill from handbook content, or when the user names the testing handbook or appsec.guide. Not for answering security testing questions — the generated skills cover those. |
| `token-integration-analyzer` | Token integration and implementation analyzer based on Trail of Bits' token integration checklist. Analyzes token implementations for ERC20/ERC721 conformity, checks for 20+ weird token patterns, assesses contract composition and owner privileges, performs on-chain scarcity analysis, and evaluates how protocols handle non-standard tokens. Use when integrating or accepting arbitrary ERC20/ERC721 tokens, auditing a token implementation for standards conformity, or assessing risk from weird tokens such as fee-on-transfer, rebasing, missing return values, or blocklists. |
| `ton-vulnerability-scanner` | Scans TON (The Open Network) smart contracts for 3 critical vulnerabilities including integer-as-boolean misuse, fake Jetton contracts, and forward TON without gas checks. Use when auditing FunC contracts. |
| `trailmark-finding-triage` | Performs graph-assisted triage of a single security finding, SARIF result, weAudit annotation, suspicious function, or report excerpt using Trailmark reachability, entrypoint paths, taint, privilege-boundary, blast-radius, caller/callee, and neighborhood evidence. Use when deciding whether one candidate issue is reachable, prioritizing a finding before PoC work, preparing evidence for exploit validation, or checking whether a static-analysis result is actionable. |
| `trailmark-review-gate` | Runs a Trailmark structural review gate over a branch, pull request, fix commit, release diff, or git ref range to detect new entrypoints, new tainted paths, removed validation or authorization calls, privilege-boundary drift, blast-radius growth, complexity growth, and newly reachable sensitive sinks. Use when reviewing a PR, branch, remediation commit, or release diff where graph-level security regressions should be checked before merge. |
| `trailmark-structural` | Runs full Trailmark structural analysis by building a graph, running `preanalysis()`, and reporting hotspots, taint, blast radius, privilege boundaries, attack surface, and version-gated Trailmark 0.4+/0.5+ data such as proxy counts, subgraph edges, type/reference summaries, and entrypoint attributes. Use when vivisect needs detailed structural data for a target. Triggers: structural analysis, blast radius, taint analysis, complexity hotspots, proxy nodes, type references. |
| `trailmark-summary` | Runs a Trailmark summary analysis on a codebase. Returns auto-detected languages, entry point count, and dependency list. Use when vivisect or galvanize needs a quick structural overview. Triggers: trailmark summary, code summary, structural overview. |
| `trailmark-variant-neighborhood` | Expands one confirmed or suspected vulnerability into a Trailmark graph neighborhood of variant candidates by finding sibling functions, shared callers and callees, common sensitive sinks, common entrypoint paths, interface implementations, override relationships, type/reference neighbors, and structurally similar nodes. Use after one issue is found to seed variant-analysis, semgrep-rule-creator, static-analysis, or manual review with graph-derived candidate locations. |
| `trailmark` | Builds and queries multi-language source and binary code graphs for security analysis. Includes pre-analysis passes for blast radius, taint propagation, privilege boundaries, entry point enumeration, proxy/unresolved-call tracking, type/reference queries, structural traversal, graph diffs, audit augmentation, declared cross-language/FFI/external links via `.trailmark/links.toml`, and SQL schema graphs. Use when analyzing call paths, mapping attack surface, finding complexity hotspots, enumerating entry points, tracing taint propagation, measuring blast radius, importing SARIF/weAudit/binary findings, linking source graphs across language or RPC boundaries, or building a code graph for audit prioritization. Feature-gate version-specific Trailmark APIs before using them; prefer `trailmark.parse.detect_languages()` or `--language auto` when the target language is unknown or polyglot. |
| `variant-analysis` | Hunts for the other instances of a bug already found — the variants of one root cause across a codebase. Use immediately after a vulnerability, logic bug, or bad pattern turns up in a specific file and the question becomes where else it occurs, including the bare conversational form ("are there others like this?", "is this the same bug?"). Also for generalizing one known instance into a CodeQL or Semgrep query for its whole pattern family, and for triaging a set of look-alike candidates against a known root cause. Not for initial discovery with no bug in hand. |
| `vector-forge` | Mutation-driven test vector generation. Finds implementations of a cryptographic algorithm or protocol, runs mutation testing to identify escaped mutants, then generates new test vectors that deliberately exercise the uncovered code paths. Compares before/after mutation kill rates to prove vector effectiveness. Use when generating cryptographic test vectors, measuring Wycheproof coverage gaps, finding escaped mutants via mutation testing, creating cross-implementation test suites, or improving test vector coverage for crypto primitives. |
| `vulnerability-triage-brocards` | >- |
| `writing-lean-proofs` | Writes and reviews structured Lean 4 proofs and designs Lean libraries following Mathlib conventions. Use when proving theorems in Lean, formalizing mathematics or specifications in Lean 4, defining new types or definitions in a Lean library, reviewing Lean proofs for readability and maintainability, refactoring long tactic proofs into lemmas, filling in sorry placeholders in a Lean development, setting up CI or linters for a Lean project, diagnosing slow proofs or maxHeartbeats timeouts, or writing custom tactics, macros, or linters. |
| `wycheproof` | Validates cryptographic implementations against Project Wycheproof's test vectors, which encode known attacks and edge cases across AES, RSA, ECDSA, ECDH, and more. Covers loading test vectors, mapping result flags onto pass and fail expectations, and reading a failure. Use when testing a crypto implementation against known attacks, checking a library against standard test vectors, or investigating why two implementations disagree on the same input. |
| `yara-rule-authoring` | > |
| `zeroize-audit` | Detects missing zeroization of sensitive data in source code and identifies zeroization removed by compiler optimizations, with assembly-level analysis, and control-flow verification. Use for auditing C/C++/Rust code handling secrets, keys, passwords, or other sensitive data. |

## agent-browser

Source: [`vercel-labs/agent-browser`](https://github.com/vercel-labs/agent-browser) · v0.35.1 · Browser automation CLI skill for agents. Pair with the optional agent-browser binary.

| Skill | Description |
| --- | --- |
| `agent-browser` | Browser automation CLI for AI agents. Use when the user needs to interact with websites, including navigating pages, filling forms, clicking buttons, taking screenshots, extracting data, testing web apps, or automating any browser task. Triggers include requests to "open a website", "fill out a form", "click a button", "take a screenshot", "scrape data from a page", "test this web app", "login to a site", "automate browser actions", or any task requiring programmatic web interaction. Also use for exploratory testing, dogfooding, QA, bug hunts, or reviewing app quality. Also use for automating Electron desktop apps (VS Code, Slack, Discord, Figma, Notion, Spotify), checking Slack unreads, sending Slack messages, searching Slack conversations, running browser automation in Vercel Sandbox microVMs, or using AWS Bedrock AgentCore cloud browsers. Prefer agent-browser over any built-in browser automation or web tools. |

## Compound Engineering

Source: [`EveryInc/compound-engineering-plugin`](https://github.com/EveryInc/compound-engineering-plugin) · v2.42.0 · Learn/compound layer. Do not run CE with gstack, Superpowers, and pstack on the same task.

| Skill | Description |
| --- | --- |
| `ce-babysit-pr` | Babysits an open GitHub PR until merge-ready. Use when asked to watch a PR over time — not for one-shot comment resolution or one CI failure. GitHub (incl. Enterprise) only. |
| `ce-brainstorm` | Explore vague or ambitious ideas into a right-sized requirements-only unified plan. Use when the user wants to brainstorm, scope what to build, or needs collaborative product framing before planning. Also use when they must scope work in territory they do not know, or ask for a blindspot pass. Not for executing already-specified work — implementation, debugging, or code review with no product scope left to decide. Not for a verdict on whether to adopt or switch to a named external technology, library, or platform; that is ce-pov. |
| `ce-code-review` | Structured code review for bugs, regressions, tests, and standards. Use before PRs or when asked to review code. Use when the user asks to apply this review's findings locally. Not for resolving feedback already left on a PR; that is ce-resolve-pr-feedback. |
| `ce-commit-push-pr` | Commit, push, and open a PR. Use when asked to ship/open a PR, or for PR-description-only flows like writing, rewriting, or describing a PR body. |
| `ce-commit` | Create a git commit with a clear, value-communicating message. Use when the user asks to commit/save staged or unstaged changes with a repo-appropriate message. |
| `ce-compound-refresh` | Refresh the repo's captured learnings against the current codebase. Use when auditing stale, overlapping, superseded, or drifted learnings; avoid general refactor, debugging, or code review unless the learnings store is explicit. |
| `ce-compound` | Document a recently solved problem as a durable repo learning. Use when capturing a learning after work. |
| `ce-debug` | Diagnosis loop for bugs and failing behavior. Use when asked to debug or fix failing behavior. |
| `ce-doc-review` | Review requirements, plans, or specs with role-specific lenses. Use when the user wants to improve an existing planning document. |
| `ce-dogfood` | Hands-off, diff-scoped browser QA of the active branch: maps user flows, drives a real browser, autonomously fixes small breakages with regression tests and commits, judges experience against product personas, and writes a durable dogfood report. Manual invocation only. |
| `ce-explain` | Create a durable visual teaching artifact for something worth learning. Use when the user wants to be taught, wants a deep explainer, wants to understand a substantial change, or wants a work recap built for retention. Not for ordinary Q&A, operational diagnosis, or a concise trade-off that belongs in chat. For learning, not repo docs or verdicts. |
| `ce-handoff` | Create a session handoff for another agent, or resume, find, and read any user-selected continuity source. Use when work or conversation must continue without access to the current session history. |
| `ce-ideate` | Generate and evaluate grounded ideas. Use when the user wants ideas, improvements, or surprising directions before choosing one to develop. Not for refining an idea they already have (ce-brainstorm) or judging one already on the table (ce-pov). |
| `ce-optimize` | Run metric-driven optimization loops. Use when improving a measurable outcome through experiments. |
| `ce-plan` | Create structured plans for multi-step work, including software and non-software tasks. Use when asked to plan, break down implementation, plan from requirements, or deepen an existing plan; prefer ce-brainstorm for exploratory framing. |
| `ce-polish` | Polish a working feature through user-directed live browser feedback. Use when a functional feature needs focused UX refinement before shipping. |
| `ce-pov` | Give a decisive, project-grounded point of view: a graded verdict on an external-adoption question, a holistic take on a document, or a position on a supplied approach set. Use for a solo POV. Use when asked to consult other models, reconcile their opinions, or `oracle`. Not for findings review (use ce-doc-review), neutral explainers, or generating options (use ce-ideate or ce-brainstorm). |
| `ce-product-pulse` | Generate time-windowed product pulse reports from configured signals. |
| `ce-promote` | Draft launch or promotion copy for a shipped feature. |
| `ce-proof` | Publish, read, comment on, or edit markdown in Proof. Use for Proof links, sharing specs/plans/drafts, or publish handoffs from planning workflows; avoid proofread, math, evidence, or proof-of-concept meanings. |
| `ce-prototype` | Build a throwaway prototype to answer how something should work, feel, or read. Use when committing the wrong answer would be expensive to unravel and a cheap sketch cannot settle it. Not a rough visual probe during brainstorming, not for deciding what to build, not polishing a feature that already works, not implementing the real thing. |
| `ce-resolve-pr-feedback` | Resolve PR review feedback. Use when addressing feedback already left on a PR. Not for reviewing the code before feedback exists; that is ce-code-review. |
| `ce-retune` | Retune a skill corpus for a new model, measurement-first: mine the run archive for a baseline, establish a noise floor, audit the corpus adversarially, then cut in measured passes until a pre-registered bar clears. Requires a benchmark harness that can A/B two builds of the corpus; refuses without one. |
| `ce-riffrec-feedback-analysis` | Analyze recorded product feedback into evidence for bugs and requirements. Use when a Riffrec capture or other screen, voice, or notes artifact needs interpretation. Use for Riffrec setup, capture, or sharing help when no recording exists yet. |
| `ce-setup` | Check Compound Engineering health and repo-local config. |
| `ce-simplify-code` | Simplify settled, recently changed code for clarity, reuse, quality, and efficiency while preserving behavior. Use after implementation and before review; use ce-debug for bugs. |
| `ce-strategy` | Create or update STRATEGY.md. Use when starting a product, adding a strategy doc to an existing repo, changing direction or roadmap, or when ce-ideate, ce-brainstorm, or ce-plan need upstream product grounding. |
| `ce-sweep` | Sweep configured feedback sources (Slack, GitHub Issues; email experimental) for new items: acknowledge at source, analyze recordings, verify fixes merged to main, and emit an `lfg`-ready plan. First run sets up sources; supports mode:non-interactive for scheduled runs. |
| `ce-test-browser` | Run browser tests for pages affected by the current branch or PR. Use when asked to run or check browser tests for the current change. |
| `ce-test-xcode` | Test iOS apps in a simulator with XcodeBuildMCP. Use when iOS changes need simulator evidence before handoff. |
| `ce-work` | Execute a plan or concrete work prompt end-to-end. Use when implementing from a plan document, a spec path, or a clear build request; use ce-debug for open-ended bugs. Use when an outer orchestrator needs implementation and local verification only, without the shipping tail. |
| `ce-worktree` | Set up isolated git worktrees — create a new branch for fresh work, or attach a worktree to an existing branch, PR, or commit. Use when starting isolated work or isolating an existing ref. |
| `lfg` | Run the full autonomous shipping pipeline end-to-end, hands-off with no check-ins. Use only when the user explicitly asks to build or ship something autonomously all the way to an open PR, or invokes lfg directly — it pushes and opens a PR without stopping. Not for in-the-loop work where the user reviews each step: use ce-plan, ce-work, ce-debug, or ce-commit-push-pr instead. |

## Anthropic example skills (subset)

Source: [`anthropics/skills`](https://github.com/anthropics/skills) · v3b3fad9 · frontend-design, webapp-testing, mcp-builder, skill-creator, claude-api only. No pptx/xlsx/docx/art/branding/gifs.

| Skill | Description |
| --- | --- |
| `claude-api` | \|- |
| `frontend-design` | Guidance for distinctive, intentional visual design when building new UI or reshaping an existing one. Helps with aesthetic direction, typography, and making choices that don't read as templated defaults. |
| `mcp-builder` | Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK). |
| `skill-creator` | Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy. |
| `webapp-testing` | Toolkit for interacting with and testing local web applications using Playwright. Supports verifying frontend functionality, debugging UI behavior, capturing browser screenshots, and viewing browser logs. |

## Awesome Copilot (GitHub workflow subset)

Source: [`github/awesome-copilot`](https://github.com/github/awesome-copilot) · vf11a4e4 · Issue, PR, Actions, and gh workflow skills only. Upstream is 400+ skills; this repo vendors a documented subset.

| Skill | Description |
| --- | --- |
| `copilot-pr-autopilot` | Copilot left 14 review comments on your PR — half are nits. Hours of fix → reply → resolve → re-request, and each round lands MORE comments. This skill runs loop engineering: auto-triggers Copilot Code Review via GraphQL (no @copilot mention), triages every open thread (Copilot, humans, advanced-security) with a fix / decline / escalate rubric, dispatches parallel fix sub-agents that obey the repo build/test/lint conventions, commits per iteration, replies+resolves citing the pushed SHA, then re-triggers until HEAD is reviewed with zero threads awaiting the agent''s reply (remaining open threads are explicit hand-offs to the human — escalated declines, design tradeoffs). You merge a clean PR; the bot runs it. Trigger phrases: "address copilot comments", "run a copilot review loop", "fix this PR", "iterate on copilot feedback". Repo-agnostic, gh CLI + PowerShell. Full autopilot needs repo Triage/Write; external PR authors get single-iteration mode plus manual re-trigger (UI 🔄 or substantive-commit push). |
| `create-github-action-workflow-specification` | Create a formal specification for an existing GitHub Actions CI/CD workflow, optimized for AI consumption and workflow maintenance. |
| `create-github-issue-feature-from-specification` | Create GitHub Issue for feature request from specification file using feature_request.yml template. |
| `create-github-issues-feature-from-implementation-plan` | Create GitHub Issues from implementation plan phases using feature_request.yml or chore_request.yml templates. |
| `create-github-issues-for-unmet-specification-requirements` | Create GitHub Issues for unimplemented requirements from specification files using feature_request.yml template. |
| `gen-specs-as-issues` | This workflow guides you through a systematic approach to identify missing features, prioritize them, and create detailed specifications for implementation. |
| `gh-attach` | Uploads a local file (screenshot, image, PDF, zip, video) to GitHub user-attachments, downloads GitHub user-attachments, and embeds local files in a PR, issue, or comment. Use when asked to "attach a screenshot to the PR", "add an image to the issue", "embed before/after screenshots", "attach this file", or "download this GitHub attachment". Powered by `gh-attach`. |
| `github-actions-efficiency` | Audit GitHub Actions workflow efficiency and recommend fixes to reduce CI minutes and costs. |
| `github-actions-hardening` | Security hardening reviewer for GitHub Actions workflow files (.github/workflows/*.yml). Reasons about the Actions threat model that pattern matchers and general code linters miss — untrusted-input script injection, privileged triggers running fork code, mutable action references, and over-scoped tokens. Use this skill when asked to review, audit, harden, or secure a GitHub Actions workflow, when writing a new workflow, or for any request like "is this workflow safe?", "review my CI for security issues", "why is pull_request_target dangerous here?", "pin my actions", or "lock down GITHUB_TOKEN permissions". Covers script injection via ${{ }} interpolation, pull_request_target / workflow_run privilege escalation, SHA-pinning of third-party actions, least-privilege permissions, GITHUB_ENV/GITHUB_OUTPUT injection, secret exposure, OIDC over long-lived credentials, and self-hosted runner exposure on public repositories. |
| `github-actions-runtime-upgrade-conventions` | Upgrade GitHub Actions to supported runtimes by selecting safe action versions, preserving workflow behavior, and validating post-upgrade execution. |
| `github-issues` | Create, update, and manage GitHub issues using MCP tools. Use this skill when users want to create bug reports, feature requests, or task issues, update existing issues, add labels/assignees/milestones, set issue fields (dates, priority, custom fields), set issue types, manage issue workflows, link issues, add dependencies, or track blocked-by/blocking relationships. Triggers on requests like "create an issue", "file a bug", "request a feature", "update issue X", "set the priority", "set the start date", "link issues", "add dependency", "blocked by", "blocking", or any GitHub issue management task. |
| `github-release` | > |
| `issue-fields-migration` | Bulk-migrate metadata to GitHub issue fields from two sources: repo labels (e.g. priority labels to a Priority field) and Project V2 fields. Use when users say "migrate my labels to issue fields", "migrate project fields to issue fields", "convert labels to issue fields", "copy project field values to issue fields", or ask about adopting issue fields. Issue fields are org-level typed metadata (single select, text, number, date) that replace label-based workarounds with structured, searchable, cross-repo fields. |
| `pr-dashboard` | Open a GitHub PR dashboard in the browser. Use when the user asks to see their pull requests, open the PR dashboard, show PRs for a date range, or check PR status. Trigger phrases include "show my PRs", "open PR dashboard", "pull request dashboard". |
| `pr-screenshots` | Embed before/after screenshots and annotated images in pull request descriptions. Covers PR description patterns, image upload for Azure DevOps and GitHub, and sizing best practices. |

---

**Total: 344 skills across 14 packs.**

## Recommended for this project

This project is a Node.js/Express web app (a security-hardened visual git
code-review tool). The following vendored skills map directly to its needs:

| Project need | Use these skills |
| --- | --- |
| Discover which skill applies | `find-skills/find-skills` |
| Full-repo audit and execution plans | `improve/improve` |
| Security review (on demand) | `trailofbits/*`, `gstack/cso`, `addyosmani/security-and-hardening` |
| Code review before merge | `mattpocock/code-review`, `addyosmani/code-review-and-quality`, `superpowers/requesting-code-review`, `cursor-team-kit/make-pr-easy-to-review` |
| Testing (the repo uses Jest) | `superpowers/test-driven-development`, `mattpocock/tdd`, `addyosmani/test-driven-development` |
| Debugging server/API issues | `superpowers/systematic-debugging`, `mattpocock/diagnosing-bugs`, `gstack/investigate` |
| Fixing CI / merge conflicts | `cursor-team-kit/fix-ci`, `cursor-team-kit/fix-merge-conflicts`, `cursor-team-kit/loop-on-ci` |
| QA of the web UI | `agent-browser/agent-browser`, `gstack/qa`, `anthropics/webapp-testing` |
| Planning and shipping | `superpowers/writing-plans`, `superpowers/executing-plans`, `gstack/ship`, `addyosmani/shipping-and-launch` |
| UI craft | `anthropics/frontend-design`, `vercel-agent-skills/web-design-guidelines` |
| GitHub issues / PRs | `awesome-copilot/github-issues`, `mattpocock/triage` |
| Compound after ship | `compound-engineering/ce-compound` (not on the same task as gstack, Superpowers, or pstack) |

Pick **one** spec/implement methodology per task. Do not run gstack, Superpowers, pstack, and Compound Engineering together.

### Complementary Cursor tooling (enable in the Cursor UI)

- **CodeRabbit** — deep automated code review (`code-review` skill / `code-reviewer` agent). Requires a `CODERABBIT_API_KEY` secret to run non-interactively in Cloud Agents.
- **Security Review** and **Bugbot** agents — on-demand security and bug review of local changes.
- These are Cursor plugins/agents, not filesystem skills, so they are enabled from Cursor rather than vendored here.
