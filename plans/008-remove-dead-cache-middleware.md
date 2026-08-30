# Plan 008: Remove dead GET cache middleware

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report — do not improvise. When done, update the status row for this plan
> in `plans/README.md` — unless a reviewer dispatched you and told you they
> maintain the index.
>
> **Drift check (run first)**: `git diff --stat 37ac800..HEAD -- server.js test/server.test.js`
> If any in-scope file changed since this plan was written, compare the
> "Current state" excerpts against the live code before proceeding; on a
> mismatch, treat it as a STOP condition.

## Status

- **Priority**: P2
- **Effort**: S
- **Risk**: LOW
- **Depends on**: none
- **Category**: perf
- **Planned at**: commit `37ac800`, 2026-08-29

## Why this matters

`server.js` registers `app.get('/api/health'|'/api/summary'|'/api/staged-files', ...)` **first**, then later `app.use('/api/health', cacheMiddleware(10))` (and the other two). In Express 4, those `app.use` hooks never wrap the GET handlers that already finished the request. `requestCache` is dead. Comments claim cache hits (`💨 Cache hit`) that production never logs. Wiring the cache **before** the GET handlers would make `/api/health` lie about staged counts for 10 seconds — worse than deleting it. Delete the dead code. Do not “fix” it by activating stale git status.

## Current state

Route registration order in `server.js`:

- `app.get('/api/health', handleAsyncRoute(...))` ~line 284
- `app.get('/api/summary', ...)` ~324
- `app.get('/api/staged-files', ...)` ~340
- `app.get('/api/file-diff', ...)` ~401

Then **after** those:

```448:504:server.js
const requestCache = new Map();

function getCacheKey(req) {
  return `${req.method}:${req.path}:${JSON.stringify(req.query)}`;
}

function cacheMiddleware(ttlSeconds = 30) {
  return (req, res, next) => {
    if (req.method !== 'GET') return next();
    // ... res.json monkey-patch, size>100 eviction ...
  };
}

// Apply caching to GET routes
app.use('/api/health', cacheMiddleware(10));
app.use('/api/summary', cacheMiddleware(30));
app.use('/api/staged-files', cacheMiddleware(15));
```

`test/server.test.js` does not assert cache headers or `requestCache`. Health tests expect live `stagedCount`. There is no test that would fail if cache started working.

Express convention in this file: middleware that must run for a route is `app.use` **before** `app.get` (cors, json, logger, static, headers, rate limit). This cache block is the exception, and it is unused.

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Tests | `npm test` | exit 0 |
| Lint | `npm run lint` | exit 0 (warnings allowed) |
| Prove cache gone | `rg -n "cacheMiddleware|requestCache|getCacheKey" server.js` | no matches |

## Scope

**In scope**:

- `server.js` (delete `requestCache`, `getCacheKey`, `cacheMiddleware`, and the three `app.use('/api/...', cacheMiddleware...)` lines)

**Out of scope**:

- Adding Redis, ETags, or a working cache
- Caching `/api/file-diff`
- `src/` (unused `src/config` `cache:` block is not wired; do not start using it here)
- Changing rate limiting

## Git workflow

- Branch: stay on the current working branch if dispatched. Otherwise `prax/remove-dead-cache-3d82`.
- Commit message example: `refactor(server): remove unused GET cache middleware`
- Do not push or open a PR unless the operator instructed it.

## Steps

### Step 1: Delete the dead cache block

Delete from `const requestCache = new Map();` through the three `app.use('/api/health'... cacheMiddleware` lines, inclusive. Do not leave a comment that says caching was removed unless you keep it to one line: `// GET responses are not cached; git status must stay live.`

Do **not** move `cacheMiddleware` above the `app.get` handlers.

**Verify**: `rg -n "cacheMiddleware|requestCache|getCacheKey|Cache hit" server.js` → no matches.

### Step 2: Confirm HTTP tests still see live health

**Verify**: `npx jest test/server.test.js --verbose` → health, summary, staged-files still 200 with the same body keys.

### Step 3: Full suite

**Verify**: `npm test` → exit 0.

## Test plan

- No new tests required. Existing `GET /api/health should return server status` is the lock that we did not start serving a cached empty body.
- If you add a test, assert only that two sequential `/api/health` requests both return 200 with `status: 'healthy'` — do not assert counts (git can change).
- Pattern: `test/server.test.js`.

## Done criteria

- [ ] `npm test` exits 0
- [ ] `rg -n "cacheMiddleware|requestCache|getCacheKey" server.js` returns no matches
- [ ] `app.get('/api/health'` still exists
- [ ] No files outside the in-scope list are modified
- [ ] `plans/README.md` status row for 008 is DONE

## STOP conditions

- Someone already moved cache **before** `app.get` (cache is live). STOP and report: deleting it would change behavior; this plan assumed dead code.
- Health tests fail after deletion for reasons unrelated to cache (git/env) — report, do not “fix” git.
- You believe you should implement a correct cache instead — that is a different plan; do not do it here.

## Maintenance notes

- If a future change needs caching, register middleware **before** the GET handler and **exclude** `/api/health` and `/api/staged-files` (live git). `/api/summary` is the only plausible candidate.
- Reviewers should confirm no `res.json` monkey-patch remains.
- `src/config` still has a `cache:` object unused by `server.js`. Do not treat that as a live feature.
