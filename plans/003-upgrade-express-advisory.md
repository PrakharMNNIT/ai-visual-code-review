# Plan 003: Upgrade Express to the patched 4.x for the path-to-regexp advisory

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report. When done, update the status row for this plan in `plans/README.md`.
>
> **Drift check (run first)**: `git diff --stat 068fec2..HEAD -- package.json package-lock.json`
> On a mismatch, STOP.

## Status

- **Priority**: P1
- **Effort**: S
- **Risk**: MED
- **Depends on**: none
- **Category**: security
- **Planned at**: commit `068fec2`, 2026-08-29

## Why this matters

`npm audit --omit=dev` at this commit reports 2 high issues on the production tree, including `path-to-regexp` ReDoS via multiple route parameters, reached through `express@4.18.2`. This app's HTTP surface is the product. Staying on an unpatched Express 4.18 line is a known, reachable advisory, not a theoretical scanner hit.

## Current state

- `package.json` `"dependencies": { "cors": "^2.8.5", "express": "^4.18.2" }`.
- Lockfile is `package-lock.json`. CI uses `npm ci`. Do not introduce pnpm in this plan.
- Routes in `server.js` are static paths (`/api/health`, `/api/file-diff`, …). Still upgrade. Do not add new parameterized routes in this plan.
- Tests: `test/server.test.js` hits those routes with supertest.

At plan time, `npm audit --omit=dev` printed severity high for `express` (via body-parser, path-to-regexp, qs) and high for `path-to-regexp`.

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Audit | `npm audit --omit=dev` | 0 high and 0 critical after the upgrade (moderate/low may remain) |
| Tests | `npm test` | exit 0 |
| Lint | `npm run lint` | exit 0 |

## Scope

**In scope**:

- `package.json`
- `package-lock.json`

**Out of scope**:

- Express 5
- `cors` upgrades unless the Express upgrade pulls them
- `pnpm-lock.yaml` (plan 004)
- Route shape changes

## Git workflow

- Commit message example: `fix(deps): upgrade express for path-to-regexp advisory`
- Do not push unless asked.

## Steps

### Step 1: Upgrade Express on the 4.x line

Run `npm install express@4 --save`. Do not jump to Express 5. If npm resolves a 4.x version that still reports the same high `path-to-regexp` issue, STOP and report the resolved version and `npm audit --omit=dev` output instead of forcing Express 5.

**Verify**: `node -e "console.log(require('express/package.json').version)"` → a 4.x version greater than 4.18.2.

### Step 2: Re-audit and test

**Verify**: `npm audit --omit=dev` → 0 high, 0 critical. `npm test` → exit 0.

If audit still shows the same high advisory on `path-to-regexp` after the latest 4.x, STOP. Do not silence it with `npm audit --force` or an override without reporting.

## Test plan

- Existing `test/server.test.js` routes (`/api/health`, staged files, export) must pass. That is the regression net for Express.
- No new tests unless the upgrade changes error JSON shape. If it does, STOP and report the diff.

## Done criteria

- [ ] `express` in `package.json` is a 4.x version newer than 4.18.2
- [ ] `npm audit --omit=dev` has 0 high and 0 critical
- [ ] `npm test` exits 0
- [ ] `plans/README.md` row 003 is DONE

## STOP conditions

- Latest Express 4.x still carries the high advisory.
- The upgrade requires Express 5 API changes (`req.param`, routing).
- Tests fail on response status or body shape.

## Maintenance notes

- Re-run `npm audit --omit=dev` when adding routes with many parameters. That is the advisory's shape.
- Reviewers should read `package-lock.json` only enough to confirm `express` and `path-to-regexp` moved, not a surprise major bump.
