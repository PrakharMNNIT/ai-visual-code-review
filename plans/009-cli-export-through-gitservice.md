# Plan 009: Drive CLI export listing through the Git working-tree module

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report — do not improvise. When done, update the status row for this plan
> in `plans/README.md` — unless a reviewer dispatched you and told you they
> maintain the index.
>
> **Drift check (run first)**: `git diff --stat 37ac800..HEAD -- scripts/export-ai-review.js services/GitService.js`
> If any in-scope file changed since this plan was written, compare the
> "Current state" excerpts against the live code before proceeding; on a
> mismatch, treat it as a STOP condition.

## Status

- **Priority**: P2
- **Effort**: S
- **Risk**: MED
- **Depends on**: plans/007-route-git-listing-through-gitservice.md
- **Category**: tech-debt
- **Planned at**: commit `37ac800`, 2026-08-29

## Why this matters

`bin/ai-review.js` `quick` runs `scripts/export-ai-review.js`. That script still calls `execFileSync('git', ['diff', '--cached', '--name-only'])` and `execFileSync('git', ['ls-files', '--deleted'])` even though it already `require`s `ReviewGenerator`. Staging/deletion listing is a third git adapter beside `GitService` and unused `src/utils/gitCommands.js`. Deleted-file semantics differ from the web app (`ls-files --deleted` vs porcelain ` D` / `AD`). After plan 007, `GitService.getStagedFiles` and `getUnstagedDeletedFiles` are the interface. The CLI should cross the same seam.

## Current state

- `scripts/export-ai-review.js` already requires:

```13:16:scripts/export-ai-review.js
const DiffService = require('../services/diffService');
const GitStatusParser = require('../services/gitStatusParser');
const ReviewGenerator = require('../services/ReviewGenerator');
```

(`DiffService` / `GitStatusParser` may be unused in this file — do not remove them in this plan unless `npm run lint` warns on this file and you can prove they have zero references. Prefer leaving unused requires if lint does not fail.)

- Repo check (keep `execFileSync`; `rev-parse` is **not** in `GitService.ALLOWED_COMMANDS`):

```115:121:scripts/export-ai-review.js
try {
  execFileSync('git', ['rev-parse', '--git-dir'], { stdio: 'ignore' });
} catch (error) {
```

- Staged listing to replace:

```127:133:scripts/export-ai-review.js
try {
  const output = execFileSync('git', ['diff', '--cached', '--name-only'], { encoding: 'utf-8' });
  stagedFiles = output.trim() ? output.trim().split('\n').filter(f => f.length > 0) : [];
} catch (error) {
  console.error('❌ Error getting staged files:', error.message);
  process.exit(1);
}
```

- Deleted listing to replace:

```135:140:scripts/export-ai-review.js
try {
  const deletedOutput = execFileSync('git', ['ls-files', '--deleted'], { encoding: 'utf-8' });
  deletedFiles = deletedOutput.trim() ? deletedOutput.trim().split('\n').filter(f => f.length > 0) : [];
} catch (error) {
  // Ignore error, deletedFiles will remain empty
}
```

- `isTooLarge` uses `execFileSync('git', ['show', \`:${file}\`])`. **Leave it.** `GitService` has no `show` allowlist key. Do not add `git show` in this plan.
- The file is async only inside the generate IIFEs at the bottom; the listing at the top is sync. Switching to `GitService` means the listing block must become `async` (top-level await is fine in a Node script run as `node scripts/export-ai-review.js` on CI Node 18/20). If you cannot use top-level await because of parser settings, wrap from “Check if there are staged changes” through generate in one `async function main()`.
- `bin/ai-review.js` `quickReview` uses `execFileSync('node', [scriptPath, ...])` — do not change the bin.
- There is no dedicated test for this script. `test/spaces-in-paths.test.js` documents `execFile` vs `exec` and is not a runner for this script.
- Plan 007 must have landed `getUnstagedDeletedFiles`. If it is missing, STOP (dependency).

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Tests | `npm test` | exit 0 |
| Lint | `npm run lint` | exit 0 (warnings allowed) |
| Prove no name-only execFileSync | `rg -n "diff', '--cached', '--name-only'" scripts/export-ai-review.js` | no matches |
| Prove GitService listing | `rg -n "getStagedFiles" scripts/export-ai-review.js` | at least one match |
| Syntax | `node --check scripts/export-ai-review.js` | exit 0 |

## Scope

**In scope**:

- `scripts/export-ai-review.js` (listing + async main wiring only)
- `services/GitService.js` **only if** `getUnstagedDeletedFiles` is missing **and** plan 007 was marked DONE but the method is absent — then STOP rather than reimplement porcelain here.

**Out of scope**:

- `isTooLarge` / `git show`
- `git rev-parse` repo check
- `bin/ai-review.js`
- Pattern matching (`matchPattern`, include/exclude)
- `ReviewGenerator` comment passing (plan 005)
- Adding tests that spawn the script against a fixture repo (optional, not required)

## Git workflow

- Branch: stay on the current working branch if dispatched. Otherwise `prax/cli-export-gitservice-3d82`.
- Commit message example: `refactor(cli): list staged files via GitService`
- Do not push or open a PR unless the operator instructed it.

## Steps

### Step 1: Confirm plan 007 method exists

**Verify**: `rg -n "getUnstagedDeletedFiles" services/GitService.js` → a method definition. If none, STOP.

### Step 2: Require `GitService` and replace listing

At the top of `scripts/export-ai-review.js`, add:

```js
const GitService = require('../services/GitService');
```

Replace the staged + deleted `execFileSync` blocks with:

```js
let stagedFiles = [];
let deletedFiles = [];

try {
  stagedFiles = await GitService.getStagedFiles();
} catch (error) {
  console.error('❌ Error getting staged files:', error.message);
  process.exit(1);
}

try {
  deletedFiles = await GitService.getUnstagedDeletedFiles();
} catch (error) {
  deletedFiles = [];
}
```

Because `await` needs an async context, wrap the script from the git-repo check **or** from the listing through `process.exit` in:

```js
async function main() {
  // existing repo check (sync execFileSync) stays first
  // then listing
  // then shouldProcessFile loop
  // then split/unified generate (already async)
}

main().catch((error) => {
  console.error('❌ Error generating reviews:', error.message);
  process.exit(1);
});
```

Keep the existing `--help` path **synchronous and before** `main()` so `node export-ai-review.js --help` does not open git.

**Verify**: `node --check scripts/export-ai-review.js` → exit 0. `rg -n "ls-files" scripts/export-ai-review.js` → no matches.

### Step 3: Full suite

Do not run the export script against this repo in a way that overwrites `AI_REVIEW.md` in a dirty tree. `npm test` does not invoke the script today.

**Verify**: `npm test` → exit 0. `npm run lint` → exit 0.

## Test plan

- No new Jest file required. If you add one, it must **not** write `AI_REVIEW.md` into the repo; mock `ReviewGenerator` instead.
- Manual check (operator, not required for DONE): `node scripts/export-ai-review.js --help` still prints usage.
- Pattern: none (script-level). Existing `test/server.test.js` still covers HTTP export.

## Done criteria

- [ ] `npm test` exits 0
- [ ] `node --check scripts/export-ai-review.js` exits 0
- [ ] `rg -n "diff', '--cached', '--name-only'" scripts/export-ai-review.js` no matches
- [ ] `rg -n "ls-files" scripts/export-ai-review.js` no matches
- [ ] `getStagedFiles` and `getUnstagedDeletedFiles` are called
- [ ] `git rev-parse` and `git show` (isTooLarge) still use `execFileSync` as today
- [ ] `--help` still works without awaiting git (`node scripts/export-ai-review.js --help`)
- [ ] No files outside the in-scope list are modified
- [ ] `plans/README.md` status row for 009 is DONE

## STOP conditions

- `getUnstagedDeletedFiles` is missing (007 not done).
- Top-level await fails `node --check` on the CI Node versions — switch to `async function main()` rather than adding Babel.
- `isTooLarge` appears to require a GitService allowlist change — leave `git show` as `execFileSync`.
- Help output disappears because you wrapped argv parsing inside `main` incorrectly.

## Maintenance notes

- A later plan may add `git show` to the GitService allowlist for size checks; do not sneak it in here.
- Reviewers should confirm `--help` still short-circuits before git.
- Deleted-file meaning now matches the web app (porcelain), not `ls-files --deleted`. That is intentional alignment with 007.
