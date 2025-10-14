# Comprehensive Test Scenarios - Pre-Deployment

**Status:** 🔄 IN PROGRESS
**Objective:** Rigorous testing before npm deployment to prevent cascading effects

## Test Categories

### A. CLI Argument Testing

### B. Pattern Matching Edge Cases

### C. File Type Handling

### D. Error Scenarios

### E. Integration Testing

### F. Performance Testing

### G. Cross-Platform Compatibility

---

## A. CLI Argument Testing

### A1. Basic Commands

- [ ] `./bin/ai-review.js quick`
- [ ] `./bin/ai-review.js quick --help`
- [ ] `./bin/ai-review.js quick -h`
- [ ] `./bin/ai-review.js web` (start server)
- [ ] `./bin/ai-review.js --version`
- [ ] `./bin/ai-review.js --help`

### A2. Include Patterns

- [ ] `./bin/ai-review.js quick --include "*.js"`
- [ ] `./bin/ai-review.js quick --include "scripts/**/*.js"`
- [ ] `./bin/ai-review.js quick --include "src/**/*.ts"`
- [ ] `./bin/ai-review.js quick --include "**/*.md"`
- [ ] `./bin/ai-review.js quick --include "bin/*.js"`
- [ ] `./bin/ai-review.js quick --include "scripts/*.js" "bin/*.js"` (multiple patterns)

### A3. Exclude Patterns

- [ ] `./bin/ai-review.js quick --exclude "*.md"`
- [ ] `./bin/ai-review.js quick --exclude "node_modules/*"`
- [ ] `./bin/ai-review.js quick --exclude "*.log" "*.json"`
- [ ] `./bin/ai-review.js quick --exclude "test/**"`

### A4. Size Limits

- [ ] `./bin/ai-review.js quick --max-size 100`
- [ ] `./bin/ai-review.js quick --max-size 5000`
- [ ] `./bin/ai-review.js quick --no-size-limit`

### A5. Combined Arguments

- [ ] `./bin/ai-review.js quick --include "*.js" --exclude "test/*"`
- [ ] `./bin/ai-review.js quick --include "scripts/**/*.js" --max-size 1000`
- [ ] `./bin/ai-review.js quick --exclude "*.md" --no-size-limit`

---

## B. Pattern Matching Edge Cases

### B1. Glob Patterns

- [ ] `scripts/**/*.js` - Should match scripts/export-ai-review.js
- [ ] `scripts/*.js` - Should match scripts/export-ai-review.js
- [ ] `**/test/*.js` - Should match any test/*.js in subdirectories
- [ ] `src/**/*.ts` - Should match all TypeScript files in src/
- [ ] `**/*.json` - Should match all JSON files recursively
- [ ] `*.md` - Should match all markdown files in root
- [ ] `bin/**` - Should match everything in bin/

### B2. Extension Patterns

- [ ] `*.js` - All JavaScript files
- [ ] `*.ts` - All TypeScript files
- [ ] `*.json` - All JSON files
- [ ] `*.md` - All markdown files
- [ ] `*.css` - All CSS files
- [ ] `*.html` - All HTML files

### B3. Directory Patterns

- [ ] `scripts/` - All files in scripts directory
- [ ] `bin/*` - All files in bin directory
- [ ] `test/*` - All files in test directory
- [ ] `node_modules/` - Should be excluded by default

### B4. Complex Patterns

- [ ] Mix of wildcards and exact paths
- [ ] Patterns with dots in directory names
- [ ] Patterns with special characters
- [ ] Case sensitivity checks

---

## C. File Type Handling

### C1. JavaScript Files

- [ ] .js files display correct icon (🟨)
- [ ] Syntax highlighting in diff
- [ ] Line numbers match correctly

### C2. TypeScript Files

- [ ] .ts files display correct icon (📘)
- [ ] .tsx files display React icon (⚛️)
- [ ] Type annotations preserved

### C3. JSON Files

- [ ] .json files display correct icon (📋)
- [ ] Formatting preserved
- [ ] Nested objects handled

### C4. Markdown Files

- [ ] .md files display correct icon (📖)
- [ ] Markdown syntax preserved
- [ ] Code blocks within markdown

### C5. Other File Types

- [ ] .css files
- [ ] .html files
- [ ] .sh files
- [ ] .yaml/.yml files
- [ ] Binary files (should handle gracefully)

---

## D. Error Scenarios

### D1. Git Repository Errors

- [ ] Running outside git repository
- [ ] No staged changes
- [ ] Corrupted git repository

### D2. File Access Errors

- [ ] File deleted during processing
- [ ] File permissions denied
- [ ] File too large (with size limit)
- [ ] Binary file handling

### D3. Invalid Arguments

- [ ] Invalid pattern syntax
- [ ] Non-existent file patterns
- [ ] Conflicting arguments
- [ ] Invalid size limit values

### D4. Process Errors

- [ ] Interrupted execution (Ctrl+C)
- [ ] Out of memory (very large files)
- [ ] Disk space issues
- [ ] Network issues (if applicable)

---

## E. Integration Testing

### E1. CLI to Script Flow

- [ ] bin/ai-review.js calls export-ai-review.js correctly
- [ ] Arguments passed correctly
- [ ] Exit codes propagate properly
- [ ] Error messages display correctly

### E2. DiffService Integration

- [ ] Line numbers generated correctly
- [ ] +/- signs appear in output
- [ ] Hunks separated properly
- [ ] Empty lines handled

### E3. File System Integration

- [ ] AI_REVIEW.md created successfully
- [ ] File permissions correct
- [ ] Overwriting existing AI_REVIEW.md
- [ ] Special characters in filenames

---

## F. Performance Testing

### F1. Small Projects

- [ ] 1-5 files: < 2 seconds
- [ ] Processing speed
- [ ] Memory usage

### F2. Medium Projects

- [ ] 10-50 files: < 10 seconds
- [ ] Pattern matching speed
- [ ] File reading efficiency

### F3. Large Projects

- [ ] 100+ files with filters: < 30 seconds
- [ ] Memory not exceeding limits
- [ ] No performance degradation

### F4. Large Files

- [ ] Files with 1000+ lines
- [ ] Files with 5000+ lines
- [ ] Files with 10000+ lines (with --no-size-limit)

---

## G. Cross-Platform Compatibility

### G1. macOS (Current Platform)

- [ ] All basic commands work
- [ ] File paths handled correctly
- [ ] Shell integration works

### G2. Linux (Test if possible)

- [ ] Shebang line works (#!/usr/bin/env node)
- [ ] File permissions
- [ ] Path separators

### G3. Windows (Test if possible)

- [ ] Command execution
- [ ] Path separators (\ vs /)
- [ ] Line endings (CRLF vs LF)

---

## H. Output Validation

### H1. AI_REVIEW.md Content

- [ ] Header includes timestamp
- [ ] Project name correct
- [ ] Change summary present
- [ ] Files count correct
- [ ] Excluded files listed
- [ ] Large files listed
- [ ] Diff blocks formatted correctly
- [ ] Line numbers present
- [ ] +/- signs present
- [ ] Review checklist present
- [ ] Footer with metadata

### H2. Console Output

- [ ] Status messages clear
- [ ] Progress indicators work
- [ ] Error messages helpful
- [ ] Success confirmation
- [ ] File counts accurate
- [ ] Next steps displayed

### H3. Exit Codes

- [ ] Success: exit code 0
- [ ] Error: exit code 1
- [ ] Help: exit code 0
- [ ] Interrupted: appropriate code

---

## I. Security Testing

### I1. Command Injection

- [ ] File patterns with shell metacharacters
- [ ] Filenames with special characters
- [ ] Arguments with injection attempts

### I2. Path Traversal

- [ ] Patterns with ../
- [ ] Absolute paths
- [ ] Symlink handling

### I3. Input Validation

- [ ] Large pattern strings
- [ ] Unicode characters
- [ ] Empty arguments
- [ ] Null bytes

---

## J. Regression Testing

### J1. Old Functionality Still Works

- [ ] Basic quick review
- [ ] Web interface (user will test)
- [ ] VSCode extension (user will test)
- [ ] Direct script call

### J2. Backward Compatibility

- [ ] Old command formats still work
- [ ] Default behavior unchanged
- [ ] Output format consistent

---

## Test Execution Plan

### Phase 1: Critical Tests (Automated)

Run automated tests for:

- A1-A5 (CLI arguments)
- B1-B2 (Basic pattern matching)
- C1-C5 (File type handling)
- H1-H2 (Output validation)

### Phase 2: Edge Cases (Automated)

Run automated tests for:

- B3-B4 (Complex patterns)
- D1-D4 (Error scenarios)
- E1-E3 (Integration)

### Phase 3: Manual Testing (User)

User tests:

- Web interface functionality
- VSCode extension
- Cross-platform if possible

### Phase 4: Performance & Security (Automated)

Run automated tests for:

- F1-F4 (Performance)
- I1-I3 (Security)

---

## Test Results Summary

**Total Test Scenarios:** ~100+
**Automated Tests:** ~80
**Manual Tests:** ~20
**Status:** 🔄 Starting automated testing...

### Results

- ✅ Passed: 0
- ❌ Failed: 0
- ⏭️ Skipped: 0
- 🔄 Running: 0

---

## Test Data Setup

Before running tests, we need:

1. Staged files in git
2. Various file types
3. Different directory structures
4. Edge case files

## Automated Test Execution

I'll run a subset of critical tests automatically. The full test suite will be documented with results.
