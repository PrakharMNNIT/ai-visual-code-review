# Plan 006: Repair duplicated file-header markup in the review page

> **Executor instructions**: Follow this plan step by step. Run every
> verification command and confirm the expected result before moving to the
> next step. If anything in the "STOP conditions" section occurs, stop and
> report — do not improvise. When done, update the status row for this plan
> in `plans/README.md` — unless a reviewer dispatched you and told you they
> maintain the index.
>
> **Drift check (run first)**: `git diff --stat 37ac800..HEAD -- public/index.html test/public-file-header.test.js`
> If any in-scope file changed since this plan was written, compare the
> "Current state" excerpts against the live code before proceeding; on a
> mismatch, treat it as a STOP condition.

## Status

- **Priority**: P1
- **Effort**: S
- **Risk**: MED
- **Depends on**: none
- **Category**: bug
- **Planned at**: commit `37ac800`, 2026-08-29

## Why this matters

`public/index.html` is the highest-churn file in `git log`. `loadFiles()` builds each row with **four** stacked `file-header` nodes (leftover from merged accordion/a11y PRs). Duplicate `id`s on the include checkbox, mixed `onclick="toggleFile('${file}', ...)"` (string-built) and `data-file` handlers, and unclosed `file-path` tags mean `toggleFile`’s `diffDiv.previousElementSibling` is not a reliable header. Keyboard a11y and include-checkboxes do not have a single path. This is a product bug in the default UI, not a style nit.

## Current state

- `public/index.html` — single-page review UI. ESLint ignores this file (`.eslintrc.js` `ignorePatterns` includes `public/index.html`), so markup bugs will not show up in `npm run lint`.
- Inside `async function loadFiles()`, after `const fileDiv = document.createElement('div');`, `fileDiv.innerHTML` starts approximately at line 1200. The template currently opens **four** `class="file-header"` divs before one `file-diff`. Excerpt of the start of that blob:

```1199:1220:public/index.html
                    const fileDiv = document.createElement('div');
                    fileDiv.className = 'file-item';
                    fileDiv.innerHTML = `
                        <div class="file-header"
                             role="button"
                             tabindex="0"
                             aria-expanded="false"
                             aria-controls="diff-${fileId}"
                             onclick="toggleFile('${file}', '${fileId}')"
                             onkeydown="if(event.key === 'Enter' || event.key === ' ') { event.preventDefault(); toggleFile('${file}', '${fileId}'); }">
                        <div class="file-header" data-file="${escapeHtml(file)}" onclick="toggleFile(this.getAttribute('data-file'), '${fileId}')">
                            <div class="file-path">
                                <span class="expand-icon" id="icon-${fileId}">▶️</span>
                                <span>${escapeHtml(fileIcon)}</span>
                                <span>${safeFile}</span>
                        <div class="file-header"
                             onclick="toggleFile('${file}', '${fileId}')"
```

- The **last** header in that blob is the intended one: `data-file`, `data-file-id`, `escapeHtml` on visible text, checkbox `onchange` via `getAttribute`. Keep that contract. Drop the first three headers and the duplicate `id="select-..."` / duplicate `onclick` attributes.
- `handleFileHeaderKeydown(event, file, fileId)` exists ~line 1285. Wire `onkeydown` to it via data attributes, not a second inline copy of the key logic.
- `safeFile` / `escapeHtml(file)` already exist just above the template. Visible text must keep using those. Do **not** put raw `file` inside `onclick="..."` strings.
- Jest does not execute this HTML. This plan adds a **string characterization test** so the four-header regression cannot return unnoticed.

## Commands you will need

| Purpose | Command | Expected on success |
|---------|---------|---------------------|
| Tests | `npm test` | exit 0 |
| New test | `npx jest test/public-file-header.test.js --verbose` | exit 0 |
| Lint | `npm run lint` | exit 0 (warnings allowed; this file is ignored) |
| Count headers in loadFiles | `node -e "const fs=require('fs'); const h=fs.readFileSync('public/index.html','utf8'); const s=h.split('async function loadFiles')[1].split('function handleFileHeaderKeydown')[0]; console.log((s.match(/class=\\\"file-header\\\"/g)||[]).length);"` | `1` after the fix |

## Scope

**In scope**:

- `public/index.html` (only the `fileDiv.innerHTML` template inside `loadFiles`, plus `onkeydown` wiring if you must change the header that remains)
- `test/public-file-header.test.js` (create)

**Out of scope**:

- `parseGitStatus` / `getStatusLabel` duplication vs `services/gitStatusParser.js` (architecture follow-up, not this bug)
- `server.js`
- CSS beyond what the single header already uses
- Moving the page off inline scripts / CSP nonce (requires HTML templating)

## Git workflow

- Branch: stay on the current working branch if dispatched. Otherwise `prax/fix-file-header-markup-3d82`.
- Commit message example: `fix(web): collapse duplicate file-header markup`
- Do not push or open a PR unless the operator instructed it.

## Steps

### Step 1: Characterization test that fails on four headers

Create `test/public-file-header.test.js`:

```js
const fs = require('fs');
const path = require('path');

function loadFilesSlice() {
  const html = fs.readFileSync(path.join(__dirname, '..', 'public', 'index.html'), 'utf8');
  const after = html.split('async function loadFiles')[1];
  if (!after) throw new Error('loadFiles not found');
  const slice = after.split('function handleFileHeaderKeydown')[0];
  return slice;
}

describe('file list header markup', () => {
  test('loadFiles template contains exactly one file-header class', () => {
    const slice = loadFilesSlice();
    const headers = slice.match(/class="file-header"/g) || [];
    expect(headers).toHaveLength(1);
  });

  test('loadFiles template does not interpolate raw file into toggleFile onclick', () => {
    const slice = loadFilesSlice();
    expect(slice).not.toMatch(/onclick="toggleFile\('\$\{file\}'/);
  });
});
```

**Verify**: `npx jest test/public-file-header.test.js --verbose` → first test **fails** (`Expected length: 1`, received 4). If it already passes, STOP (markup already fixed).

### Step 2: Replace the innerHTML blob with one header

Replace the entire `fileDiv.innerHTML = \` ... \`;` assignment in `loadFiles` with **one** `file-item` body:

- Outer: existing `fileDiv.className = 'file-item'` (keep).
- One `div.file-header` with:
  - `role="button"` `tabindex="0"`
  - `aria-expanded="false"` `aria-controls="diff-${escapeHtml(fileId)}"`
  - `data-file="${escapeHtml(file)}"` `data-file-id="${escapeHtml(fileId)}"`
  - `onclick="toggleFile(this.getAttribute('data-file'), this.getAttribute('data-file-id'))"`
  - `onkeydown="handleFileHeaderKeydown(event, this.getAttribute('data-file'), this.getAttribute('data-file-id'))"`
- One `div.file-path` containing expand icon `id="icon-${escapeHtml(fileId)}"`, icon text, `escapeHtml(file)`.
- One include checkbox: **one** `id="select-${escapeHtml(fileId)}"`, `data-filename`, `data-file-id`, `onchange` via `getAttribute` only, `onclick="event.stopPropagation();"` on the label.
- One comment button: `data-file` / `data-file-id`, `showCommentModal` via `getAttribute`, `aria-label="Add comment for ${escapeHtml(file)}"`.
- `div.file-stats` `id="stats-${escapeHtml(fileId)}"`.
- Badge: `class="badge ${escapeHtml(badgeClass)}"` and `escapeHtml(badgeText)`.
- Sibling `div.file-diff` `id="diff-${escapeHtml(fileId)}"` with the existing loading copy that uses `safeFileName`.

Keep `fragment.appendChild(fileDiv)` and the rest of `loadFiles` (fetch, empty state, `selectedFiles.add(file)`) unchanged.

**Verify**: the node one-liner in the commands table prints `1`. `npx jest test/public-file-header.test.js --verbose` → both tests pass.

### Step 3: Full suite

**Verify**: `npm test` → exit 0.

## Test plan

- `test/public-file-header.test.js` as above (count + no raw `toggleFile('${file}'`).
- Pattern: `test/agent-skill-packs.test.js` (reads files from disk with `fs`; no browser).
- No Playwright/browser in this plan. If you cannot confirm accordion behavior, say so in the PR body; the string tests still lock the regression.

## Done criteria

- [ ] `npm test` exits 0
- [ ] `npx jest test/public-file-header.test.js` exits 0
- [ ] loadFiles slice has exactly one `class="file-header"`
- [ ] `rg -n "onclick=\"toggleFile\\('\\$\\{file\\}'" public/index.html` returns no matches
- [ ] No files outside the in-scope list are modified
- [ ] `plans/README.md` status row for 006 is DONE

## STOP conditions

- `async function loadFiles` or `function handleFileHeaderKeydown` cannot be found (file restructured).
- Step 1 already passes (do not restyle the page).
- A step's verification fails twice after a reasonable fix attempt.
- You think you must extract a JS bundle or Tailwind build (`build:css` is a placeholder — do not invent a bundler here).
- Checkbox include/export behavior seems to require changing `toggleFileSelection` or `exportForAI` — STOP and report; those functions are out of scope unless a missing `id` would break them. Match existing `id="select-${fileId}"` (with escapeHtml).

## Maintenance notes

- Future a11y edits must edit the **single** header. Merging a second copy of the header is the bug this test exists to catch.
- `toggleFile` still uses `diffDiv.previousElementSibling` as the header. After this plan that sibling must be the one `file-header`. Do not wrap the header in an extra div without updating `toggleFile`.
- Status-parse duplication in the same file is deferred (architecture candidate, not this plan).
