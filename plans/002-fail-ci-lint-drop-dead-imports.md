# Plan 002: Drop unused `server.js` imports and fail CI lint on error

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report. When done, update the status row for this plan in `plans/README.md`.
>
> **Drift check (run first)**: `git diff --stat 068fec2..HEAD -- server.js .github/workflows/ci.yml .eslintrc.js`
> On a mismatch with the excerpts below, STOP.

## Status

- **Priority**: P1
- **Effort**: S
- **Risk**: LOW
- **Depends on**: plans/001-use-src-utils-from-server.md
- **Category**: dx
- **Planned at**: commit `068fec2`, 2026-08-29

## Why this matters

`npm run lint` reports unused `execFile`, `writeFileSync`, `readFileSync`, `mkdirSync`, and `GitStatusParser` in `server.js`. Those bindings never run. `.github/workflows/ci.yml` sets `continue-on-error: true` on the lint step, so even a future eslint **error** would not fail the job. The repo already claims a security-hardened review tool; CI that cannot fail lint is how dead requires and later real errors both ship.

## Current state

- `server.js` lines 4–9 require `execFile`, four `fs` bindings, and `GitStatusParser`. Live uses: `path.join` / `path.resolve`, `existsSync` for `public/index.html`. `writeFileSync`, `readFileSync`, `mkdirSync`, `execFile`, and `GitStatusParser` have no other hits in `server.js`.
- `.github/workflows/ci.yml` job `test`, step "Run linter": `run: npm run lint` then `continue-on-error: true`.
- `.eslintrc.js` sets `'no-unused-vars': ['warn', ...]`. Do not change rule severity in this plan. Removing unused bindings is enough for those warnings to disappear from `server.js`.
- Lint currently exits 0 with warnings. Removing `continue-on-error` is still required so a later error fails the job.

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Lint | `npm run lint` | exit 0 |
| Tests | `npm test` | exit 0 |
| Confirm CI | `rg -n "continue-on-error" .github/workflows/ci.yml` | no match on the lint step |

## Scope

**In scope**:

- `server.js` (imports only, plus any leftover after plan 001)
- `.github/workflows/ci.yml` (lint step only)

**Out of scope**:

- Promoting `no-unused-vars` from warn to error
- Other lint warnings (`max-depth` in `bin/ai-review.js`, complexity in `validateExportRequest`, unused vars in `scripts/export-ai-review.js`)
- Coverage and codecov `continue-on-error` flags

## Git workflow

- Commit message example: `chore(ci): fail lint on error and drop dead server requires`
- Do not push unless asked.

## Steps

### Step 1: Trim `server.js` requires

Keep:

```js
const { existsSync } = require('fs');
```

Remove `execFile` (`child_process`), `writeFileSync`, `readFileSync`, `mkdirSync`, and `GitStatusParser`. Git execution stays on `GitService`.

**Verify**: `rg -n "execFile|writeFileSync|readFileSync|mkdirSync|GitStatusParser" server.js` → no matches.

### Step 2: Fail the CI lint step

In `.github/workflows/ci.yml`, delete `continue-on-error: true` from the "Run linter" step only. Leave the coverage and codecov `continue-on-error` entries.

**Verify**: `rg -n -A2 "Run linter" .github/workflows/ci.yml` → the step is `run: npm run lint` with no `continue-on-error`.

### Step 3: Recheck

**Verify**: `npm run lint` → exit 0. `npm test` → exit 0.

## Test plan

- No new tests. `test/server.test.js` already boots `server.js`.
- Confirm the process still serves `/` using `existsSync` (covered by existing HTTP tests if present; otherwise `npm test` is the gate).

## Done criteria

- [ ] `rg -n "execFile|GitStatusParser|writeFileSync|readFileSync|mkdirSync" server.js` is empty
- [ ] Lint step in `ci.yml` has no `continue-on-error`
- [ ] `npm test` exits 0
- [ ] `plans/README.md` row 002 is DONE

## STOP conditions

- Plan 001 is not landed and `server.js` still contains the inline validators (imports will look different).
- Removing `GitStatusParser` breaks a route you did not see in the excerpt. Stop and report the call site.
- Making lint fail CI requires changing `.eslintrc.js` because errors already exist. Stop and list them instead of weakening the config.

## Maintenance notes

- Next lint cleanup is `scripts/export-ai-review.js` unused requires, out of scope here.
- Reviewers should read the CI diff as a one-line behavioral change: lint errors fail the job.
