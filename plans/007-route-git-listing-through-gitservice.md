# Plan 007: Route Git listing through the Git working-tree module

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report — do not improvise. When done, update the status row for this plan
> in `plans/README.md` — unless a reviewer dispatched you and told you they
> maintain the index.
>
> **Drift check (run first)**: `git diff --stat 37ac800..HEAD -- services/GitService.js server.js test/gitService.test.js`
> If any in-scope file changed since this plan was written, compare the
> "Current state" excerpts against the live code before proceeding; on a
> mismatch, treat it as a STOP condition.

## Status

- **Priority**: P2
- **Effort**: M
- **Risk**: MED
- **Depends on**: none (can land in parallel with 001–006; do not wait)
- **Category**: tech-debt
- **Planned at**: commit `37ac800`, 2026-08-29

## Why this matters

`services/GitService.js` already exposes `getStagedFiles`, `getDiffForFile`, `getDiffStats`, and `getFileStatuses`. `server.js` still shells porcelain by hand in `/api/health`, `/api/staged-files`, and `/api/export-individual-reviews`. `/api/export-for-ai` is the only route that calls `getStagedFiles`. Deleted-file detection is copy-pasted (`line.startsWith(' D')` vs also `'AD'`). `GitStatusParser` is `require`d in `server.js` and never used (plan 002 will delete that import — this plan must **not** start calling it from `server.js`; keep parsing inside `GitService`). Callers that re-split porcelain will drift the next time Git output changes.

## Current state

- `services/GitService.js` — singleton. Allowlist includes `diff-cached`, `diff-cached-names`, `diff-cached-stat`, `status-porcelain`, `diff-name-status`. Methods:

```67:108:services/GitService.js
  async getStagedFiles() {
    const output = await this.execute('diff-cached-names');
    return output.trim() ? output.trim().split('\n').filter(f => f.length > 0) : [];
  }

  async getDiffForFile(file) {
    return this.execute('diff-cached', ['--', file]);
  }
  // ...
  async getFileStatuses() {
    const output = await this.execute('diff-name-status');
    // splits on tab into statuses[filename] = status
```

- `server.js` health (~284–308) uses `GitService.execute('diff-cached-names')` and `execute('status-porcelain')` then splits lines starting with ` M` or `??`.
- `server.js` staged-files (~340–378) uses `execute('diff-cached-names')`, `execute('diff-cached', ['--name-status'])`, and porcelain for ` D` / `AD`. The `substring(line.startsWith('AD') ? 3 : 3)` ternary is always `3`.
- `server.js` file-diff (~413) uses `GitService.execute('diff-cached', ['--', file])` instead of `getDiffForFile`.
- `server.js` individual export (~668–688) duplicates name-only + ` D` porcelain.
- Plan 002 will remove the unused `GitStatusParser` require from `server.js`. Do not add new uses of `GitStatusParser` in `server.js`. If you need labels, do it inside `GitService`.
- Plan 001 will change validators only. Do not touch `src/utils/gitCommands.js` here (dead copy; deleting it is allowed in this plan if nothing requires it — confirm with `rg`).
- Tests: `test/server.test.js` already hits these HTTP routes against the real workspace git. That is the regression net. Add `test/gitService.test.js` for the new method.
- Conventions: CommonJS class + singleton export. Match existing method style (`async`, `execute` internally). Do not introduce TypeScript.

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Tests | `npm test` | exit 0 |
| Git module tests | `npx jest test/gitService.test.js --verbose` | exit 0 |
| Lint | `npm run lint` | exit 0 (warnings allowed) |
| Prove health uses getStagedFiles | `rg -n "getStagedFiles" server.js` | health and both export routes (not only unified) |
| No porcelain split in health | `rg -n "startsWith\\(' M'\\)" server.js` | no matches |

## Scope

**In scope**:

- `services/GitService.js`
- `server.js` (health, staged-files, file-diff, export-individual-reviews listing only)
- `test/gitService.test.js` (create)
- `src/utils/gitCommands.js` **only if** you delete the file after `rg` shows zero callers (including tests). If any caller exists, leave the file.

**Out of scope**:

- `scripts/export-ai-review.js` (plan 009)
- `src/utils/validation.js` / plan 001
- Injecting `execFile` for tests (nice-to-have; do not do it here — STOP if you think you must)
- `vscode-extension/`
- Changing HTTP JSON keys (`files`, `fileStatuses`, `deletedFiles`, `stagedCount`, …)

## Git workflow

- Branch: stay on the current working branch if dispatched. Otherwise `prax/git-listing-module-3d82`.
- Commit message example: `refactor(git): list staged files through GitService methods`
- Do not push or open a PR unless the operator instructed it.

## Steps

### Step 1: Add `getUnstagedDeletedFiles` on `GitService`

Add a method that:

1. `execute('status-porcelain')`
2. Keeps lines whose first two characters include a working-tree `D` in the same way the staged-files route does today: `line.startsWith(' D') || line.startsWith('AD')`
3. Maps each line with `line.substring(3)` (porcelain is `XY ` + path; keep that 3-char prefix, including the space)
4. Returns an array of strings (possibly empty). On `execute` rejection, **rethrow** from this method. Callers that currently swallow errors should keep their try/catch.

Do not add new allowlist keys unless `status-porcelain` is missing (it is not).

**Verify**: `rg -n "getUnstagedDeletedFiles" services/GitService.js` → method exists.

### Step 2: Characterization tests for the new method and existing helpers

Create `test/gitService.test.js`:

```js
const GitService = require('../services/GitService');

describe('GitService listing', () => {
  test('getStagedFiles returns an array of strings', async () => {
    const files = await GitService.getStagedFiles();
    expect(Array.isArray(files)).toBe(true);
    files.forEach((f) => expect(typeof f).toBe('string'));
  });

  test('getUnstagedDeletedFiles returns an array of strings', async () => {
    const files = await GitService.getUnstagedDeletedFiles();
    expect(Array.isArray(files)).toBe(true);
  });

  test('getFileStatuses returns an object', async () => {
    const statuses = await GitService.getFileStatuses();
    expect(typeof statuses).toBe('object');
    expect(statuses).not.toBeNull();
  });
});
```

This hits the **real** git in the workspace (same as `test/server.test.js`). Do not mock `execFile`.

**Verify**: `npx jest test/gitService.test.js --verbose` → pass **before** changing `server.js` (methods except `getUnstagedDeletedFiles` already exist; the new one must exist from step 1).

### Step 3: Switch `server.js` callers

Replace inline listing as follows. Keep `handleAsyncRoute` and existing HTTP status codes.

1. **`GET /api/health`**: `const stagedFiles = await GitService.getStagedFiles()` for `stagedCount` (`.length`). Keep unstaged count from porcelain **or** add `getUnstagedModifiedCount` if you can do it in ≤15 lines in `GitService`. Prefer a small `getPorcelainLines()` private-to-file helper rather than a fourth copy of `execute('status-porcelain')` in the route. Minimum bar: `stagedCount` comes from `getStagedFiles().length`. If you still parse porcelain in health for unstaged ` M` / `??`, put that parse in `GitService.getUnstagedChangeCount()` rather than the route.

2. **`GET /api/staged-files`**: `files` from `getStagedFiles()`; `fileStatuses` from `getFileStatuses()`; `deletedFiles` from `getUnstagedDeletedFiles()`. Remove `Promise.allSettled` of three raw executes **if** the three methods cover it. If `getFileStatuses` fails, match today’s behavior: empty object, not 500 (use try/catch around that call only).

3. **`GET /api/file-diff`**: `GitService.getDiffForFile(file)` instead of `execute('diff-cached', ['--', file])`.

4. **`POST /api/export-individual-reviews`**: `getStagedFiles()` + `getUnstagedDeletedFiles()` like unified export already uses `getStagedFiles()`.

5. Leave `POST /api/export-for-ai` using `getStagedFiles()` (already). You may switch its porcelain deleted-files block to `getUnstagedDeletedFiles()` so unified and split agree (` D` vs `AD`). **Do** unify: both export routes should use `getUnstagedDeletedFiles()`.

**Verify**: `rg -n "execute\\('diff-cached-names'\\)" server.js` → no matches. `npx jest test/server.test.js --verbose` → pass.

### Step 4: Optional delete of unused `src/utils/gitCommands.js`

Run `rg -n "gitCommands" --glob '!**/node_modules/**' --glob '!.claude/**' --glob '!.agents/**'`. If the only hits are `src/utils/index.js` and the file itself:

- Remove the `executeGitCommand` / `ALLOWED_GIT_COMMANDS` export from `src/utils/index.js` (plan 001 still needs `validateFileRequest` from that index).
- Delete `src/utils/gitCommands.js`.

If `rg` shows any other caller, **leave the file**.

**Verify**: `npm test` → exit 0.

### Step 5: Full suite

**Verify**: `npm test` → exit 0. `npm run lint` → exit 0 (warnings allowed).

## Test plan

- `test/gitService.test.js` as in step 2 (real git, arrays/objects).
- Existing `test/server.test.js` health / staged-files / file-diff / export tests must still pass (same JSON keys).
- Pattern: `test/diffService.test.js` for structure; this file is allowed to be async like server tests.
- Do not assert exact staged file names (the workspace tree changes). Assert types only.

## Done criteria

- [ ] `npm test` exits 0
- [ ] `rg -n "execute\\('diff-cached-names'\\)" server.js` has no matches
- [ ] `rg -n "getDiffForFile" server.js` matches the file-diff route
- [ ] `getUnstagedDeletedFiles` exists and both export routes use it
- [ ] No files outside the in-scope list are modified
- [ ] `plans/README.md` status row for 007 is DONE

## STOP conditions

- `GitService.execute` allowlist no longer includes `status-porcelain` or `diff-cached-names`.
- Switching health to `getStagedFiles` changes `/api/health` JSON keys (do not rename keys).
- You need to change `test/server.test.js` expectations of field names — STOP (you broke the HTTP contract).
- Plan 002 already removed `GitStatusParser` from `server.js`; do not re-add it.
- Injecting `execFile` or rewriting `GitService` into a factory looks required — STOP; this plan only adds methods and switches callers.

## Maintenance notes

- Next git command belongs in `ALLOWED_COMMANDS` + a named method, not a new `execute` from a route.
- `src/utils/gitCommands.js` must not be revived as a second copy.
- Reviewers should confirm export-for-ai and export-individual-reviews now share deleted-file rules.
- CLI script still has its own `execFileSync` until plan 009.
