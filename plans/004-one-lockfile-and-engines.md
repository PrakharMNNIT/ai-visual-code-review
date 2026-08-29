# Plan 004: Keep one lockfile and align `engines` with CI

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report. When done, update the status row for this plan in `plans/README.md`.
>
> **Drift check (run first)**: `git diff --stat 068fec2..HEAD -- package.json pnpm-lock.yaml .github/workflows/ci.yml`
> On a mismatch, STOP.

## Status

- **Priority**: P2
- **Effort**: S
- **Risk**: LOW
- **Depends on**: none
- **Category**: dx
- **Planned at**: commit `068fec2`, 2026-08-29

## Why this matters

CI and Cloud Agent install use `npm ci`, which reads `package-lock.json`. The repo also has `pnpm-lock.yaml`. Two lockfiles drift. `package.json` `engines.node` is `>=14.0.0` while `.github/workflows/ci.yml` tests 18.x and 20.x only. Contributors on Node 14 get a promised runtime CI never runs. README badges still say Node 14+.

## Current state

- `package.json` `"engines": { "node": ">=14.0.0" }`.
- `.github/workflows/ci.yml` matrix `node-version: [18.x, 20.x]`.
- Both `package-lock.json` and `pnpm-lock.yaml` exist at repo root.
- `.cursor/environment.json` install is `npm ci && bash scripts/link-agent-skills.sh`.
- README badge: `Node.js-14%2B`.

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Tests | `npm test` | exit 0 |
| Prove one lockfile | `test ! -f pnpm-lock.yaml` | exit 0 |

## Scope

**In scope**:

- `package.json` (`engines` only)
- `pnpm-lock.yaml` (delete)
- `README.md` (Node badge and any "Node 14" install claim in the first 80 lines)
- `.gitignore` only if you need to ignore future `pnpm-lock.yaml` (optional, skip unless you already touch it)

**Out of scope**:

- Adding pnpm CI
- Changing the Node matrix to 22.x
- `package-lock.json` contents (plan 003 owns Express)

## Git workflow

- Commit message example: `chore(env): drop pnpm lockfile and require Node 18`
- Do not push unless asked.

## Steps

### Step 1: Set engines to match CI

In `package.json`, set `"node": ">=18.0.0"`.

**Verify**: `node -e "console.log(require('./package.json').engines.node)"` → `>=18.0.0`.

### Step 2: Delete `pnpm-lock.yaml`

`git rm pnpm-lock.yaml`.

**Verify**: `test ! -f pnpm-lock.yaml` → exit 0.

### Step 3: Update the README Node badge

Replace the `Node.js-14%2B` badge with an 18+ badge in the same shield style already used in `README.md`. If the Quick Start text says Node 14, update that sentence only.

**Verify**: `rg -n "14" README.md` → no remaining "Node 14" runtime claims in the badge or Quick Start. Mentions of historical changelog Node 14 are fine if they are clearly historical. If unsure, STOP and list leftover lines.

### Step 4: Tests

**Verify**: `npm test` → exit 0.

## Test plan

- No new tests. This is manifest and docs.

## Done criteria

- [ ] `engines.node` is `>=18.0.0`
- [ ] `pnpm-lock.yaml` is gone
- [ ] README no longer advertises Node 14 as current
- [ ] `npm test` exits 0
- [ ] `plans/README.md` row 004 is DONE

## STOP conditions

- Something in the repo actually requires pnpm (a script or doc that fails without `pnpm-lock.yaml`). Report the path.
- You find Node 14-only syntax that would break after the engines bump. Report it instead of adding polyfills.

## Maintenance notes

- New contributors should run `npm ci`.
- If someone adds pnpm later, they must delete `package-lock.json` and switch CI. Do not restore a second lockfile casually.
