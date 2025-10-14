# 📋 NPM Scripts Analysis & Fixes for ai-visual-code-review

## 🔍 Issue Identified

**Main Problem:** The `bin/ai-review.js` CLI does NOT pass additional arguments to the bash script when running `quick` command.

### Current Implementation (BROKEN)

```javascript
// In bin/ai-review.js - line ~96
function quickReview() {
  console.log('📝 Generating quick AI review...');

  if (!checkGitRepo()) {
    process.exit(1);
  }

  const scriptPath = path.join(__dirname, '..', 'scripts', 'quick-ai-review.sh');

  try {
    execSync(`chmod +x "${scriptPath}"`, { stdio: 'ignore' });
    execSync(`"${scriptPath}"`, { stdio: 'inherit', cwd: process.cwd() });
    // ❌ NO ARGUMENTS PASSED TO BASH SCRIPT!
  } catch (error) {
    console.error('❌ Quick review generation failed');
    console.error(error.message);
    process.exit(1);
  }
}
```

## ✅ Commands Status

### Working Commands ✅

```json
{
  "review": "npx ai-review start",                    // ✅ Works
  "review:quick": "npx ai-review quick",              // ✅ Works (but no args)
  "review:visual": "npx ai-review start --open"       // ✅ Works
}
```

### Broken Commands ❌ (Arguments Not Passed)

```json
{
  "review:core": "npx ai-review quick --include 'packages/core/src/**/*.ts'",
  "review:cli": "npx ai-review quick --include 'packages/cli/src/**/*.ts'",
  "review:docs": "npx ai-review quick --include 'docs/**/*.md'",
  "review:config": "npx ai-review quick --include '*.json' '*.yaml' '*.yml' '*.toml'",
  "review:tests": "npx ai-review quick --include 'packages/*/tests/**/*.ts' 'tests/**/*.ts'"
}
```

### Unknown Scripts ⚠️ (Need Custom Implementation)

```json
{
  "review:backup": "./tools/scripts/ai-review.sh",
  "review:backup-quick": "./tools/scripts/ai-review.sh --exclude ...",
  "review:web": "node tools/web-review/server.js"
}
```

---

## 🔧 Solutions

### Solution 1: Use Direct Bash Script (RECOMMENDED)

Since the CLI doesn't pass arguments, call the bash script directly:

```json
{
  "scripts": {
    "review": "npx ai-review start",
    "review:quick": "npx ai-review quick",
    "review:visual": "npx ai-review start --open",

    "review:core": "node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/core/src/**/*.ts'",
    "review:cli": "node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/cli/src/**/*.ts'",
    "review:docs": "node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'docs/**/*.md'",
    "review:config": "node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include '*.json' '*.yaml' '*.yml' '*.toml'",
    "review:tests": "node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/*/tests/**/*.ts' 'tests/**/*.ts'",

    "review:exclude": "node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --exclude 'node_modules/*' '*.log' '.DS_Store' 'dist/*' 'coverage/*'"
  }
}
```

### Solution 2: Use npx to Run Bash Script

```json
{
  "scripts": {
    "review:core": "npx --yes -p ai-visual-code-review bash node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/core/src/**/*.ts'",
    "review:cli": "npx --yes -p ai-visual-code-review bash node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/cli/src/**/*.ts'"
  }
}
```

### Solution 3: Create Local Wrapper Scripts (CLEANEST)

Create a `scripts/` folder in your project:

**scripts/review-core.sh**

```bash
#!/bin/bash
./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/core/src/**/*.ts'
```

**scripts/review-cli.sh**

```bash
#!/bin/bash
./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/cli/src/**/*.ts'
```

Then in package.json:

```json
{
  "scripts": {
    "review:core": "./scripts/review-core.sh",
    "review:cli": "./scripts/review-cli.sh"
  }
}
```

---

## 🐛 Diff Formatting Issue

The "diff formatted AI_REVIEW.md" issue you're seeing is likely because the bash script generates proper markdown, but it might appear "raw" in some viewers. The script generates:

```markdown
### 📄 `filename.ts`

**Type:** TypeScript/React Component

\`\`\`diff
diff --git a/file.ts b/file.ts
index abc123..def456 100644
--- a/file.ts
+++ b/file.ts
@@ -10,7 +10,7 @@ function example() {
-  old line
+  new line
\`\`\`
```

This is **CORRECT** formatting. The issue might be:

1. **GitHub rendering**: GitHub will syntax highlight this properly ✅
2. **VS Code preview**: VS Code markdown preview shows this correctly ✅
3. **Plain text view**: If you're viewing the raw file, it will look like "diff format" ✅

**This is the intended behavior!** AI models (ChatGPT, Claude) understand this format perfectly.

---

## 🚀 Recommended Package.json Configuration

```json
{
  "name": "your-project",
  "version": "1.0.0",
  "scripts": {
    "review": "npx ai-review start",
    "review:quick": "npx ai-review quick",
    "review:visual": "npx ai-review start --open",

    "review:core": "./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/core/src/**/*.ts'",
    "review:cli": "./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/cli/src/**/*.ts'",
    "review:docs": "./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'docs/**/*.md'",
    "review:config": "./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include '*.json' '*.yaml' '*.yml' '*.toml'",
    "review:tests": "./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --include 'packages/*/tests/**/*.ts' 'tests/**/*.ts'",

    "review:exclude-common": "./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --exclude 'node_modules/*' '*.log' '.DS_Store' 'dist/*' 'coverage/*'",
    "review:no-limit": "./node_modules/ai-visual-code-review/scripts/quick-ai-review.sh --no-size-limit"
  },
  "devDependencies": {
    "@biomejs/biome": "^1.9.4",
    "@changesets/cli": "^2.29.7",
    "@types/node": "^22.8.7",
    "ai-visual-code-review": "1.0.4",
    "rimraf": "^6.0.1",
    "turbo": "^2.5.8",
    "typescript": "^5.6.3"
  }
}
```

---

## 🎯 Usage Examples

```bash
# Standard visual review
npm run review

# Quick markdown generation (all files)
npm run review:quick

# Review only core package
npm run review:core

# Review only CLI package
npm run review:cli

# Review only documentation
npm run review:docs

# Review only config files
npm run review:config

# Review only tests
npm run review:tests

# Review with exclusions
npm run review:exclude-common

# Review with no size limit
npm run review:no-limit
```

---

## 📝 File to Fix in ai-visual-code-review Package

The package maintainer should update `bin/ai-review.js` to pass arguments:

```javascript
function quickReview() {
  console.log('📝 Generating quick AI review...');

  if (!checkGitRepo()) {
    process.exit(1);
  }

  const scriptPath = path.join(__dirname, '..', 'scripts', 'quick-ai-review.sh');

  // Get all arguments after 'quick' command
  const quickArgs = process.argv.slice(3).join(' ');

  try {
    execSync(`chmod +x "${scriptPath}"`, { stdio: 'ignore' });
    execSync(`"${scriptPath}" ${quickArgs}`, { stdio: 'inherit', cwd: process.cwd() });
  } catch (error) {
    console.error('❌ Quick review generation failed');
    console.error(error.message);
    process.exit(1);
  }
}
```

---

## 🔍 Verifying Commands Work

Test each command:

```bash
# Ensure you have staged changes
git add .

# Test basic quick review
npm run review:quick

# Check if AI_REVIEW.md is generated
ls -la AI_REVIEW.md

# Test with includes (using direct bash script)
npm run review:core

# Verify only core files are in AI_REVIEW.md
cat AI_REVIEW.md | grep "packages/core"
```

---

## ✅ Conclusion

1. **Commands 1-3** ✅ Work perfectly
2. **Commands 4-8** ❌ Don't work with `npx ai-review quick` (use direct bash script path instead)
3. **Commands 9-11** ⚠️ Require custom scripts in your project
4. **Diff formatting** ✅ Is correct! The markdown diff format is intentional and works with AI models

Use the recommended configuration above for the best experience!
