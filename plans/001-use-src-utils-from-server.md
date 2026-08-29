# Plan 001: Route `server.js` validation through `src/utils`

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report. When done, update the status row for this plan in `plans/README.md`.
>
> **Drift check (run first)**: `git diff --stat 068fec2..HEAD -- server.js src/utils/validation.js src/utils/index.js src/utils/gitCommands.js test/server.test.js`
> If any in-scope file changed since this plan was written, compare the
> "Current state" excerpts against the live code before proceeding; on a
> mismatch, treat it as a STOP condition.

## Status

- **Priority**: P1
- **Effort**: M
- **Risk**: MED
- **Depends on**: none
- **Category**: tech-debt
- **Planned at**: commit `068fec2`, 2026-08-29

## Why this matters

`server.js` inlines `validateFileRequest` and `validateExportRequest`. The same functions already live in `src/utils/validation.js`, and nothing in the running app `require`s `src/utils`. The two copies have already drifted: the `src/utils` export-validator rejects extra characters in comment file keys that the `server.js` copy does not. A security fix applied to one copy will not apply to the other. The live process uses the `server.js` copy.

## Current state

- `server.js` owns the Express app and currently defines validators inline (starts at line 159).
- `src/utils/validation.js` is the extracted copy. `src/utils/index.js` re-exports it. A repo-wide search for `require('./src` and `require('../src` returns no matches.
- `services/GitService.js` is what `server.js` uses for git. Leave it. Do not switch the app onto `src/utils/gitCommands.js` in this plan.
- Tests live in `test/server.test.js` and hit HTTP routes with supertest. Model new tests after the existing `POST /api/log-comment should sanitize input` case.

`server.js` still imports modules it does not use. Do not clean those here. Plan 002 does that after this delete.

Excerpt, `server.js` (local validator the process actually runs):

```159:172:server.js
function validateFileRequest(file) {
  if (!file || typeof file !== 'string') {
    return { valid: false, error: 'File parameter is required and must be a string' };
  }
  if (file.length > 500) {
    return { valid: false, error: 'File path too long (max 500 characters)' };
  }
  if (!DiffService.isValidFilePath(file)) {
    return { valid: false, error: 'Invalid file path - potential security risk' };
  }
```

Excerpt, `src/utils/index.js` (dead to the running app):

```6:15:src/utils/index.js
const { validateFileRequest, validateExportRequest, sanitizeForLog } = require('./validation');
const { executeGitCommand, ALLOWED_GIT_COMMANDS } = require('./gitCommands');

module.exports = {
  validateFileRequest,
  validateExportRequest,
  sanitizeForLog,
  executeGitCommand,
  ALLOWED_GIT_COMMANDS
};
```

Conventions: CommonJS `require`, Express handlers in `server.js`, Jest + supertest in `test/server.test.js`. Match that. Do not introduce TypeScript in these files.

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Tests | `npm test` | exit 0 |
| Lint | `npm run lint` | exit 0 (warnings allowed) |
| Prove src/utils is referenced | `rg -n "require\\('./src/utils" server.js` | at least one match |

## Scope

**In scope**:

- `server.js`
- `src/utils/validation.js` (only if a test proves a behavior gap you must close)
- `test/server.test.js` (add cases)

**Out of scope**:

- `src/utils/gitCommands.js` and `services/GitService.js` (duplicate git wrappers; not this plan)
- `public/`
- ESLint rule severity
- Express version (plan 003)

## Git workflow

- Branch: stay on the current working branch if you were dispatched onto one. Otherwise `prax/use-src-utils-3d82`.
- Commit message example: `refactor(server): use src/utils validators`
- Do not push or open a PR unless the operator instructed it.

## Steps

### Step 1: Point `server.js` at `src/utils`

Add near the other requires in `server.js`:

```js
const { validateFileRequest, validateExportRequest } = require('./src/utils');
```

Delete the local `function validateFileRequest` and `function validateExportRequest` bodies (the block that today starts at line 159 and ends at the `return { valid: true }` of `validateExportRequest`, just before the next helper). Keep `DiffService` required. `src/utils/validation.js` already requires it.

**Verify**: `rg -n "^function validate(File|Export)Request" server.js` → no matches.

### Step 2: Add tests for the stricter export-validator behavior

In `test/server.test.js`, add a case that `POST /api/export-for-ai` with a comment key containing `"` or `;` returns 400. That is the extra check in `src/utils/validation.js` (`/[;&|`$(){}[\]<>'"]/` on comment file keys) which the deleted `server.js` copy did not apply the same way.

Also keep an existing happy-path export test passing.

**Verify**: `npx jest test/server.test.js --verbose` → all pass, including the new 400 case.

### Step 3: Full suite

**Verify**: `npm test` → exit 0.

## Test plan

- Happy path: existing export and file-diff tests still pass.
- Regression: comment file key with `;` or `"` is rejected with 400.
- Pattern: `test/server.test.js` supertest `request(app)`.

## Done criteria

- [ ] `npm test` exits 0
- [ ] `rg -n "^function validate(File|Export)Request" server.js` returns no matches
- [ ] `rg -n "require('./src/utils" server.js` matches
- [ ] No files outside the in-scope list are modified
- [ ] `plans/README.md` status row for 001 is DONE

## STOP conditions

- `src/utils/validation.js` is missing `validateFileRequest` or `validateExportRequest`.
- Deleting the local functions leaves a ReferenceError because some other helper in `server.js` expected them as inner closures. Stop and report the remaining call sites.
- A test requires changing `services/GitService.js` to pass.

## Maintenance notes

- New HTTP validators belong in `src/utils/validation.js` only.
- Reviewers should confirm `server.js` no longer defines those two functions.
- Git wrapper duplication is deferred to a later plan on purpose.
