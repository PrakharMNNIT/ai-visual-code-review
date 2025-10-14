#!/usr/bin/env node

/**
 * Unified AI Review Export Script
 * Generates AI_REVIEW.md with consistent formatting for CLI and Web interface
 * Supports include/exclude file patterns
 */

const { execSync } = require('child_process');
const { writeFileSync } = require('fs');
const path = require('path');

// Import DiffService for consistent formatting
const DiffService = require('../services/diffService');

// Parse command line arguments
const args = process.argv.slice(2);
const config = {
  includeFiles: [],
  excludeFiles: [],
  maxFileSize: 10000,
  skipLargeFiles: true,
  includeOnlyMode: false
};

// Parse arguments
for (let i = 0; i < args.length; i++) {
  const arg = args[i];

  switch (arg) {
    case '--include':
      config.includeOnlyMode = true;
      i++;
      while (i < args.length && !args[i].startsWith('--')) {
        config.includeFiles.push(args[i]);
        i++;
      }
      i--;
      break;

    case '--exclude':
      i++;
      while (i < args.length && !args[i].startsWith('--')) {
        config.excludeFiles.push(args[i]);
        i++;
      }
      i--;
      break;

    case '--max-size':
      config.maxFileSize = parseInt(args[i + 1]);
      i++;
      break;

    case '--no-size-limit':
      config.skipLargeFiles = false;
      break;

    case '-h':
    case '--help':
      console.log(`
🔍 AI Review Export Script

Usage: node export-ai-review.js [options]

Options:
  --include FILES...  ONLY include specific files (space-separated)
  --exclude FILES...  Exclude specific files (space-separated)
  --max-size LINES    Skip files larger than LINES (default: 10000)
  --no-size-limit     Include all files regardless of size
  -h, --help          Show this help

Examples:
  node export-ai-review.js
  node export-ai-review.js --include "src/**/*.ts"
  node export-ai-review.js --exclude "*.log" "dist/*"
  node export-ai-review.js --no-size-limit
      `);
      process.exit(0);
  }
}

// Default excludes (minimal - user has full control)
const DEFAULT_EXCLUDES = [
  '.env',
  '.env.local',
  '.env.production',
  'node_modules/',
  '*.log',
  '.git/',
  'dist/',
  'build/'
];

console.log('🔍 AI Review Export');
console.log('===================');

// Check if we're in a git repository
try {
  execSync('git rev-parse --git-dir', { stdio: 'ignore' });
} catch (error) {
  console.error('❌ Error: Not a git repository');
  console.error('💡 Please run this command inside a git repository');
  process.exit(1);
}

// Check if there are staged changes
let stagedFiles = [];
try {
  const output = execSync('git diff --cached --name-only', { encoding: 'utf-8' });
  stagedFiles = output.trim() ? output.trim().split('\n').filter(f => f.length > 0) : [];
} catch (error) {
  console.error('❌ Error getting staged files:', error.message);
  process.exit(1);
}

if (stagedFiles.length === 0) {
  console.error('⚠️  No staged changes found');
  console.error('💡 Run \'git add .\' to stage changes, then try again');
  process.exit(1);
}

console.log(`✅ Found ${stagedFiles.length} staged files`);

// Function to check if file should be processed
function shouldProcessFile(file) {
  // Include-only mode: only process files in includeFiles
  if (config.includeOnlyMode) {
    for (const pattern of config.includeFiles) {
      if (matchPattern(file, pattern)) {
        return true;
      }
    }
    return false;
  }

  // Exclude mode: process all files except excluded ones
  const allExcludes = [...DEFAULT_EXCLUDES, ...config.excludeFiles];

  for (const pattern of allExcludes) {
    if (matchPattern(file, pattern)) {
      return false;
    }
  }

  return true;
}

// Simple pattern matching
function matchPattern(file, pattern) {
  // Exact match
  if (file === pattern) return true;

  // Directory exclusion: "node_modules/" or "node_modules/*"
  if (pattern.endsWith('/') || pattern.endsWith('/*')) {
    const dir = pattern.replace(/\/?\\*?$/, '');
    if (file.startsWith(dir + '/')) return true;
  }

  // Extension pattern: "*.log"
  if (pattern.startsWith('*.')) {
    const ext = pattern.substring(1);
    if (file.endsWith(ext)) return true;
  }

  // Glob-like pattern: "src/**/*.ts" or "scripts/**/*.js"
  if (pattern.includes('**')) {
    // Convert glob pattern to regex
    // scripts/**/*.js -> ^scripts\/(.*\/)?[^/]*\.js$
    // ** means "zero or more directories", so **/ becomes (.*\/)?
    let regexPattern = pattern
      .replace(/\*\*\//g, '__DOUBLESTARSLASH__')  // Placeholder for **/
      .replace(/\./g, '\\.')  // Escape dots
      .replace(/\//g, '\\/')  // Escape forward slashes
      .replace(/\*/g, '[^/]*')  // * matches any characters except /
      .replace(/__DOUBLESTARSLASH__/g, '(.*\\/)?');  // **/ means zero or more dirs
    const regex = new RegExp('^' + regexPattern + '$');
    if (regex.test(file)) return true;
  }

  // Simple wildcard: "src/*.ts"
  if (pattern.includes('*')) {
    const regexPattern = pattern
      .replace(/\./g, '\\.')
      .replace(/\//g, '\\/')
      .replace(/\*/g, '[^/]*');
    const regex = new RegExp('^' + regexPattern + '$');
    if (regex.test(file)) return true;
  }

  return false;
}

// Function to check file size
function isTooLarge(file) {
  if (!config.skipLargeFiles) return false;

  try {
    const content = execSync(`git show :${file}`, { encoding: 'utf-8' });
    const lineCount = content.split('\n').length;
    return lineCount > config.maxFileSize;
  } catch (error) {
    return false;
  }
}

// Filter files
const includedFiles = [];
const excludedFiles = [];
const largeFiles = [];

for (const file of stagedFiles) {
  if (!shouldProcessFile(file)) {
    excludedFiles.push(file);
    console.log(`⏭️  Skipping: ${file} (excluded)`);
  } else if (isTooLarge(file)) {
    largeFiles.push(file);
    console.log(`⏭️  Skipping: ${file} (too large)`);
  } else {
    includedFiles.push(file);
  }
}

console.log(`\n📊 Summary:`);
console.log(`   Included: ${includedFiles.length} files`);
console.log(`   Excluded: ${excludedFiles.length} files`);
console.log(`   Too large: ${largeFiles.length} files`);

if (includedFiles.length === 0) {
  console.error('\n❌ No files to process after filtering');
  process.exit(1);
}

// Generate AI review content
console.log('\n📝 Generating AI_REVIEW.md...\n');

const timestamp = new Date().toLocaleString();
let content = `# 🔍 Code Review - ${timestamp}

**Project:** AI Visual Code Review
**Generated by:** AI Visual Code Review v2.0

## 📊 Change Summary

\`\`\`
${execSync('git diff --cached --stat', { encoding: 'utf-8' }).trim()}
\`\`\`

## 📝 Files Changed (${includedFiles.length}/${stagedFiles.length} selected)

`;

if (excludedFiles.length > 0) {
  content += `### ⏭️ Excluded Files\nThe following files were excluded from this review:\n${excludedFiles.map(f => `- \`${f}\``).join('\n')}\n\n`;
}

if (largeFiles.length > 0) {
  content += `### 📦 Large Files Skipped\nThe following files were skipped due to size (use --no-size-limit to include):\n${largeFiles.map(f => `- \`${f}\``).join('\n')}\n\n`;
}

// Process each included file
let processedCount = 0;
const errors = [];

for (const file of includedFiles) {
  try {
    console.log(`✅ Processing: ${file}`);

    content += `\n### 📄 \`${file}\`\n\n`;

    // Add file type context
    const ext = path.extname(file).toLowerCase();
    const fileTypeMap = {
      '.tsx': '**Type:** TypeScript React Component ⚛️\n\n',
      '.ts': '**Type:** TypeScript Source File 📘\n\n',
      '.js': '**Type:** JavaScript Source File 🟨\n\n',
      '.jsx': '**Type:** React Component (JavaScript) ⚛️\n\n',
      '.json': '**Type:** Configuration/Data File 📋\n\n',
      '.md': '**Type:** Documentation 📖\n\n',
      '.css': '**Type:** Stylesheet 🎨\n\n',
      '.scss': '**Type:** Sass Stylesheet 🎨\n\n',
      '.html': '**Type:** HTML Template 🌐\n\n',
      '.py': '**Type:** Python Script 🐍\n\n',
      '.sh': '**Type:** Shell Script 💻\n\n',
      '.vue': '**Type:** Vue Component 💚\n\n',
      '.yaml': '**Type:** YAML Configuration 📋\n\n',
      '.yml': '**Type:** YAML Configuration 📋\n\n',
      '.toml': '**Type:** TOML Configuration 📋\n\n'
    };
    content += fileTypeMap[ext] || '**Type:** Source File 📄\n\n';

    // Get diff - handle both new files and modifications
    let diff;
    try {
      diff = execSync(`git diff --cached -- "${file}"`, { encoding: 'utf-8' });

      // If diff is empty, file might be deleted or renamed
      if (!diff || diff.trim().length === 0) {
        throw new Error('File may be deleted or has no diff');
      }
    } catch (diffError) {
      // Try checking if file is deleted
      try {
        const status = execSync(`git status --short "${file}"`, { encoding: 'utf-8' });
        if (status.trim().startsWith('D')) {
          content += `**Status:** File deleted ❌\n\n`;
          processedCount++;
          continue;
        }
      } catch (statusError) {
        throw diffError;
      }
    }

    // Use DiffService for consistent formatting with line numbers
    content += DiffService.generateEnhancedDiffMarkdown(diff);

    processedCount++;
  } catch (error) {
    console.error(`❌ Error processing ${file}:`, error.message);
    errors.push(file);
    content += `**❌ Error:** Could not load diff for \`${file}\` - ${error.message}\n\n`;
  }
}

// Add review checklist
content += `---

## 🤖 AI Review Checklist

Please review these changes for:

### 🔍 Code Quality
- [ ] **Linting Compliance**: No unused imports/variables, proper formatting
- [ ] **Type Safety**: Proper typing throughout (TypeScript/Python type hints)
- [ ] **Best Practices**: Framework-specific conventions and patterns
- [ ] **Performance**: Efficient algorithms, proper memoization
- [ ] **Documentation**: Clear comments and function descriptions

### 🐛 Potential Issues
- [ ] **Runtime Errors**: Type mismatches, null/undefined handling
- [ ] **Logic Bugs**: Incorrect calculations, edge cases
- [ ] **Memory Leaks**: Cleanup in lifecycle methods, event listeners
- [ ] **Error Handling**: Proper try-catch blocks, user feedback
- [ ] **Accessibility**: ARIA labels, keyboard navigation, screen readers

### 🔒 Security & Data
- [ ] **Input Validation**: Sanitization, XSS prevention, SQL injection
- [ ] **Authentication**: Proper access controls and permissions
- [ ] **Privacy**: No sensitive data exposure in logs/client
- [ ] **Dependencies**: Updated packages, vulnerability checks

### 📱 UX/UI
- [ ] **Responsive Design**: Mobile/desktop/tablet compatibility
- [ ] **Loading States**: Proper feedback during async operations
- [ ] **Error Messages**: User-friendly error handling and recovery
- [ ] **Performance**: Fast loading, smooth animations

### 💡 Suggestions & Improvements
Please provide specific feedback on:
1. Code organization and structure improvements
2. Performance optimization opportunities
3. Security considerations and hardening
4. Testing coverage and strategies
5. Documentation and maintainability

---
*Generated by AI Visual Code Review v2.0 - Unified Export Script*
*Files processed: ${processedCount}/${includedFiles.length} | Errors: ${errors.length} | Generated: ${new Date().toISOString()}*
`;

// Write to file
const filePath = path.join(process.cwd(), 'AI_REVIEW.md');
writeFileSync(filePath, content, 'utf8');

console.log('\n✅ Generated: AI_REVIEW.md');
console.log(`📊 Final stats: ${processedCount} files processed, ${excludedFiles.length} excluded, ${errors.length} errors`);
console.log(`📄 File size: ${content.length} characters\n`);

console.log('🎯 Next steps:');
console.log('1. Review AI_REVIEW.md');
console.log('2. Ask ChatGPT/Claude: "Please review AI_REVIEW.md"');
console.log('3. Make any suggested changes');
console.log('4. Commit: git commit -m "Your message"\n');

process.exit(0);
