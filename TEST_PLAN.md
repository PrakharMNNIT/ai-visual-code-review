# 🧪 Unified Export System - Test Plan

## 📋 Pre-Deployment Testing Checklist

Before publishing to npm, verify all functionality works correctly.

---

## 🔍 Test Environment Setup

```bash
# 1. Ensure you're in the project directory
cd /path/to/ai-visual-code-review

# 2. Make scripts executable
chmod +x scripts/export-ai-review.js
chmod +x bin/ai-review.js

# 3. Stage some test files
git add scripts/export-ai-review.js bin/ai-review.js UNIFIED_EXPORT_GUIDE.md
```

---

## ✅ Test Suite

### Test 1: Direct Script Call (Basic)

```bash
# Test basic functionality
node scripts/export-ai-review.js

# Expected Output:
# ✅ Found X staged files
# ✅ Processing: filename1
# ✅ Processing: filename2
# ✅ Generated: AI_REVIEW.md

# Verify:
cat AI_REVIEW.md | head -50
```

**Success Criteria:**

- ✅ Script runs without errors
- ✅ AI_REVIEW.md is created
- ✅ File contains diff with line numbers
- ✅ Format shows: `10  11  + added line`

---

### Test 2: CLI Quick Command

```bash
# Test CLI integration
./bin/ai-review.js quick

# Expected Output:
# 📝 Generating quick AI review...
# 🔍 Running: node "...path.../scripts/export-ai-review.js"
# ✅ Generated: AI_REVIEW.md

# Verify:
cat AI_REVIEW.md | grep -A 5 "```diff"
```

**Success Criteria:**

- ✅ CLI command works
- ✅ Calls unified script
- ✅ Same output format as Test 1

---

### Test 3: Include Pattern

```bash
# Test --include argument
./bin/ai-review.js quick --include "scripts/**/*.js"

# Expected Output:
# 📋 INCLUDE-ONLY MODE
# ✅ Files to include: scripts/export-ai-review.js

# Verify:
grep "scripts/export-ai-review.js" AI_REVIEW.md
```

**Success Criteria:**

- ✅ Only includes specified files
- ✅ Other files are excluded
- ✅ Summary shows correct count

---

### Test 4: Exclude Pattern

```bash
# Test --exclude argument
./bin/ai-review.js quick --exclude "*.md"

# Expected Output:
# ⏭️  Skipping: UNIFIED_EXPORT_GUIDE.md (excluded)
# ⏭️  Skipping: NPM_SCRIPTS_ANALYSIS.md (excluded)

# Verify:
grep -c "\.md" AI_REVIEW.md || echo "No .md files (correct)"
```

**Success Criteria:**

- ✅ Excludes specified patterns
- ✅ Shows excluded files in summary
- ✅ AI_REVIEW.md doesn't contain excluded files

---

### Test 5: Multiple Arguments

```bash
# Test multiple include patterns
./bin/ai-review.js quick --include "scripts/*.js" "bin/*.js"

# Expected Output:
# ✅ Found X staged files
# ✅ Processing: scripts/export-ai-review.js
# ✅ Processing: bin/ai-review.js

# Verify:
grep -c "📄" AI_REVIEW.md
```

**Success Criteria:**

- ✅ Handles multiple patterns
- ✅ Includes all matching files
- ✅ Correct file count

---

### Test 6: Help Command

```bash
# Test help output
./bin/ai-review.js quick --help

# Expected Output:
# 🔍 AI Review Export Script
# Usage: node export-ai-review.js [options]
# Options:
#   --include FILES...
#   --exclude FILES...
```

**Success Criteria:**

- ✅ Shows help text
- ✅ Lists all options
- ✅ Shows examples

---

### Test 7: Line Numbers Verification

```bash
# Generate review
./bin/ai-review.js quick

# Check for proper line number format
grep -A 10 "```diff" AI_REVIEW.md | head -20

# Expected format:
# @@ -10,7 +10,7 @@ function example() {
#  10  11   const unchanged = 'line';
#  12      - const old = 'removed';
#      13  + const new = 'added';
```

**Success Criteria:**

- ✅ Line numbers present
- ✅ Format: `old  new  content`
- ✅ `-` for deletions, `+` for additions
- ✅ Both numbers on context lines

---

### Test 8: Compare with DiffService Output

```bash
# Test that script uses DiffService correctly
node -e "
const DiffService = require('./services/diffService.js');
const { execSync } = require('child_process');

const diff = execSync('git diff --cached scripts/export-ai-review.js', { encoding: 'utf-8' });
const formatted = DiffService.generateEnhancedDiffMarkdown(diff);

console.log('=== DiffService Output ===');
console.log(formatted);
"

# Compare with AI_REVIEW.md output
# Should be identical format
```

**Success Criteria:**

- ✅ Uses DiffService
- ✅ Same formatting
- ✅ Line numbers match

---

### Test 9: Web Interface Export

```bash
# Start server
./bin/ai-review.js start

# In another terminal or browser:
# 1. Open http://localhost:3002
# 2. Click "Export for AI Review"
# 3. Check AI_REVIEW.md

# Compare outputs:
md5 AI_REVIEW_CLI.md
md5 AI_REVIEW_WEB.md
# Should have same structure (not byte-identical due to timestamps)
```

**Success Criteria:**

- ✅ Web export works
- ✅ Same line number format as CLI
- ✅ Uses DiffService formatting

---

### Test 10: Error Handling

```bash
# Test with no staged files
git reset HEAD .
./bin/ai-review.js quick

# Expected Output:
# ⚠️  No staged changes found
# 💡 Run 'git add .' to stage changes

# Test invalid pattern
./bin/ai-review.js quick --include ""

# Should handle gracefully
```

**Success Criteria:**

- ✅ Shows clear error messages
- ✅ No crashes
- ✅ Helpful suggestions

---

## 📊 Output Verification Checklist

After running tests, verify AI_REVIEW.md contains:

```markdown
- [ ] Header with timestamp
- [ ] Project name
- [ ] Change summary with git stats
- [ ] File count (X/Y selected)
- [ ] Excluded files section (if any)
- [ ] For each file:
  - [ ] File path in backticks
  - [ ] File type emoji and label
  - [ ] Diff block with ```diff
  - [ ] Line numbers in format: old  new  content
  - [ ] + for additions
  - [ ] - for deletions
- [ ] Review checklist at bottom
- [ ] Footer with stats
```

---

## 🎯 Critical Tests

**These MUST pass before npm publish:**

1. ✅ **Unified formatting**: CLI and web produce same format
2. ✅ **Line numbers**: All diffs show old/new line numbers
3. ✅ **Arguments work**: `--include` and `--exclude` are honored
4. ✅ **DiffService used**: Both methods use same formatter
5. ✅ **No errors**: Clean execution in all scenarios

---

## 🔬 Detailed Output Format Test

Create this test file:

```bash
# test-output-format.sh
#!/bin/bash

echo "🧪 Testing Output Format..."

# Generate review
./bin/ai-review.js quick > /dev/null 2>&1

# Check critical format elements
echo "Checking line number format..."
if grep -q "@@ -[0-9]" AI_REVIEW.md; then
    echo "✅ Chunk headers present"
else
    echo "❌ Missing chunk headers"
    exit 1
fi

if grep -q "^[0-9]\{2,3\}  [0-9]\{2,3\}" AI_REVIEW.md; then
    echo "✅ Line numbers present (context lines)"
else
    echo "❌ Missing line numbers on context lines"
    exit 1
fi

if grep -q "^[0-9]\{2,3\}      -" AI_REVIEW.md; then
    echo "✅ Deletion format correct"
else
    echo "❌ Missing deletion format"
    exit 1
fi

if grep -q "^     [0-9]\{2,3\}  +" AI_REVIEW.md; then
    echo "✅ Addition format correct"
else
    echo "❌ Missing addition format"
    exit 1
fi

echo ""
echo "✅ All format checks passed!"
```

Run with:

```bash
chmod +x test-output-format.sh
./test-output-format.sh
```

---

## 📝 Manual Verification Steps

1. **Visual Inspection**

   ```bash
   # Open AI_REVIEW.md in VS Code
   code AI_REVIEW.md

   # Check:
   # - Line numbers are aligned
   # - +/- signs are present
   # - Context lines have both numbers
   # - Removed lines have only old number
   # - Added lines have only new number
   ```

2. **AI Testing**

   ```bash
   # Copy AI_REVIEW.md content
   # Paste into ChatGPT/Claude
   # Ask: "Can you review this code?"
   #
   # AI should be able to:
   # - Read the diff format
   # - Identify line numbers
   # - Reference specific changes
   ```

3. **Cross-Method Comparison**

   ```bash
   # Generate via CLI
   ./bin/ai-review.js quick
   mv AI_REVIEW.md AI_REVIEW_CLI.md

   # Generate via web (manual)
   ./bin/ai-review.js start
   # Export via web interface
   mv AI_REVIEW.md AI_REVIEW_WEB.md

   # Compare structure
   diff -u <(grep "^[0-9]" AI_REVIEW_CLI.md) <(grep "^[0-9]" AI_REVIEW_WEB.md)
   # Should show similar line number patterns
   ```

---

## 🚀 Pre-Deployment Checklist

Before `npm publish`:

- [ ] All tests pass
- [ ] No error messages
- [ ] Line numbers format correct in all outputs
- [ ] `--include` works correctly
- [ ] `--exclude` works correctly
- [ ] Web interface uses same format
- [ ] Help text is accurate
- [ ] Documentation is complete
- [ ] Examples in docs are tested
- [ ] CHANGELOG updated
- [ ] Version bumped in package.json
- [ ] Git changes committed
- [ ] Git tag created

---

## 📋 Test Results Template

Copy this for your test results:

```
# Test Results - Date: ___________

## Environment
- Node version: ___________
- npm version: ___________
- OS: ___________
- Git version: ___________

## Test Results

| Test | Status | Notes |
|------|--------|-------|
| 1. Direct script call | ⬜ Pass / ❌ Fail | |
| 2. CLI quick command | ⬜ Pass / ❌ Fail | |
| 3. Include pattern | ⬜ Pass / ❌ Fail | |
| 4. Exclude pattern | ⬜ Pass / ❌ Fail | |
| 5. Multiple arguments | ⬜ Pass / ❌ Fail | |
| 6. Help command | ⬜ Pass / ❌ Fail | |
| 7. Line numbers | ⬜ Pass / ❌ Fail | |
| 8. DiffService output | ⬜ Pass / ❌ Fail | |
| 9. Web interface | ⬜ Pass / ❌ Fail | |
| 10. Error handling | ⬜ Pass / ❌ Fail | |

## Sample Output

Paste sample AI_REVIEW.md sections here:

```diff
[paste diff section]
```

## Issues Found

1.
2.
3.

## Ready for Deployment?

⬜ YES - All tests passed
⬜ NO - Issues found (see above)

```

---

## 🎉 Success Criteria Summary

The unified export system is ready for npm publish when:

✅ **Consistency**: CLI and web produce identical formats
✅ **Line Numbers**: All diffs show proper old/new line numbers
✅ **Arguments**: All CLI arguments work as documented
✅ **No Errors**: Clean execution in all test scenarios
✅ **Documentation**: All docs match actual behavior
✅ **AI Compatible**: ChatGPT/Claude can parse the output

If all tests pass, you're ready to:
```bash
npm version patch  # or minor/major
npm publish
git push --tags
