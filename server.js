#!/usr/bin/env node

const express = require('express');
const { execSync } = require('child_process');
const { writeFileSync, readFileSync, existsSync } = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3002;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Helper functions
function executeGitCommand(command) {
  try {
    return execSync(command, {
      encoding: 'utf-8',
      cwd: process.cwd(),
      stdio: ['pipe', 'pipe', 'ignore']
    });
  } catch (error) {
    throw new Error(`Git command failed: ${command}`);
  }
}

function parseDiff(diff) {
  const lines = diff.split('\n');
  const chunks = [];
  let currentChunk = null;
  let oldLineNum = 0;
  let newLineNum = 0;

  for (const line of lines) {
    if (line.startsWith('@@')) {
      // Parse chunk header: @@ -oldStart,oldCount +newStart,newCount @@
      const match = line.match(/@@ -(\d+)(?:,\d+)? \+(\d+)(?:,\d+)? @@/);
      if (match) {
        oldLineNum = parseInt(match[1]);
        newLineNum = parseInt(match[2]);
        currentChunk = {
          header: line,
          lines: []
        };
        chunks.push(currentChunk);
      }
    } else if (currentChunk && !line.startsWith('---') && !line.startsWith('+++')) {
      let type = 'context';
      let oldNum = null;
      let newNum = null;

      if (line.startsWith('+')) {
        type = 'added';
        newNum = newLineNum++;
      } else if (line.startsWith('-')) {
        type = 'removed';
        oldNum = oldLineNum++;
      } else {
        type = 'context';
        oldNum = oldLineNum++;
        newNum = newLineNum++;
      }

      currentChunk.lines.push({
        type,
        content: line,
        oldLineNum: oldNum,
        newLineNum: newNum
      });
    }
  }

  return { chunks };
}

// API Routes
app.get('/api/health', (req, res) => {
  try {
    let stagedCount = 0;
    let unstagedCount = 0;

    try {
      const stagedFiles = executeGitCommand('git diff --cached --name-only').trim();
      stagedCount = stagedFiles ? stagedFiles.split('\n').filter(f => f.length > 0).length : 0;
    } catch (error) {
      // Ignore error
    }

    try {
      const unstagedFiles = executeGitCommand('git diff --name-only').trim();
      unstagedCount = unstagedFiles ? unstagedFiles.split('\n').filter(f => f.length > 0).length : 0;
    } catch (error) {
      // Ignore error
    }

    const totalChanges = stagedCount + unstagedCount;

    res.json({
      status: 'healthy',
      stagedCount,
      unstagedCount,
      totalChanges,
      timestamp: new Date().toISOString(),
      cwd: process.cwd()
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get('/api/summary', (req, res) => {
  try {
    const stats = executeGitCommand('git diff --cached --stat').trim();
    res.json({ stats });
  } catch (error) {
    res.json({ stats: '' });
  }
});

app.get('/api/staged-files', (req, res) => {
  try {
    const output = executeGitCommand('git diff --cached --name-only').trim();
    const files = output ? output.split('\n').filter(f => f.length > 0) : [];
    res.json({ files });
  } catch (error) {
    res.json({ files: [] });
  }
});

app.get('/api/file-diff', (req, res) => {
  try {
    const { file } = req.query;
    if (!file) {
      return res.status(400).json({ error: 'File parameter required' });
    }

    const diff = executeGitCommand(`git diff --cached "${file}"`);
    const parsedDiff = parseDiff(diff);

    res.json({
      diff,
      parsedDiff,
      file
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/log-comment', (req, res) => {
  try {
    const { type, file, lineNumber, comment } = req.body;
    console.log(`💬 ${type}: ${file}${lineNumber ? ` Line ${lineNumber}` : ''}: "${comment}"`);
    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/api/export-for-ai', (req, res) => {
  try {
    const { comments, lineComments, excludedFiles } = req.body;

    console.log('🚀 Export for AI Review request received');
    console.log('📋 Excluded files:', excludedFiles);
    console.log('💬 File comments:', Object.keys(comments || {}).length);
    console.log('🔍 Line comments:', Object.keys(lineComments || {}).length);

    // Get all staged files
    const stagedFiles = executeGitCommand('git diff --cached --name-only')
      .trim()
      .split('\n')
      .filter(f => f.length > 0);

    console.log('📁 All staged files:', stagedFiles.length);

    // Filter out excluded files
    const includedFiles = stagedFiles.filter(file => {
      const isExcluded = excludedFiles && excludedFiles.includes(file);
      if (isExcluded) {
        console.log(`⏭️  Excluding: ${file}`);
      }
      return !isExcluded;
    });

    console.log('✅ Files to include:', includedFiles.length);
    console.log('📊 Excluded count:', stagedFiles.length - includedFiles.length);

    // Generate AI review content
    const timestamp = new Date().toLocaleString();
    let content = `# 🔍 Code Review - ${timestamp}

**Project:** AI Visual Code Review

## 📊 Change Summary

\`\`\`
${executeGitCommand('git diff --cached --stat')}
\`\`\`

## 📝 Files Changed (${includedFiles.length}/${stagedFiles.length} selected)

`;

    if (excludedFiles && excludedFiles.length > 0) {
      content += `### ⏭️ Excluded Files
The following files were excluded from this review:
${excludedFiles.map(f => `- \`${f}\``).join('\n')}

`;
    }

    let processedCount = 0;

    // Process each included file
    for (const file of includedFiles) {
      try {
        console.log(`✅ Processing: ${file}`);

        content += `\n### 📄 \`${file}\`\n\n`;

        // Add file type context
        const ext = path.extname(file);
        switch (ext) {
          case '.tsx':
          case '.ts':
            content += '**Type:** TypeScript/React Component\n\n';
            break;
          case '.js':
            content += '**Type:** JavaScript\n\n';
            break;
          case '.json':
            content += '**Type:** Configuration/Data\n\n';
            break;
          case '.md':
            content += '**Type:** Documentation\n\n';
            break;
          case '.css':
            content += '**Type:** Stylesheet\n\n';
            break;
          default:
            content += '**Type:** Source File\n\n';
            break;
        }

        // Add file comment if exists
        if (comments && comments[file]) {
          content += `**💭 Review Comment:**\n${comments[file]}\n\n`;
        }

        // Add diff
        const diff = executeGitCommand(`git diff --cached "${file}"`);
        content += `\`\`\`diff\n${diff}\`\`\`\n\n`;

        processedCount++;
      } catch (error) {
        console.error(`Error processing ${file}:`, error);
        content += `**Error:** Could not load diff for ${file}\n\n`;
      }
    }

    // Add line comments section if any exist
    if (lineComments && Object.keys(lineComments).length > 0) {
      content += `## 🔍 Line-by-Line Comments

`;
      Object.entries(lineComments).forEach(([lineId, comment]) => {
        content += `- **${lineId}:** ${comment}\n`;
      });
      content += '\n';
    }

    // Add review checklist
    content += `---

## 🤖 Review Checklist

Please review these changes for:

### 🔍 Code Quality
- [ ] **ESLint Compliance**: No \`any\` types, no unused imports/variables
- [ ] **TypeScript Strict Mode**: Proper typing throughout
- [ ] **React Best Practices**: Hooks order, component structure
- [ ] **Performance**: Efficient rendering, proper memoization

### 🐛 Potential Issues
- [ ] **Runtime Errors**: Type mismatches, null/undefined handling
- [ ] **Logic Bugs**: Incorrect calculations, edge cases
- [ ] **Memory Leaks**: Cleanup in useEffect, event listeners
- [ ] **Accessibility**: ARIA labels, keyboard navigation

### 🔒 Security & Data
- [ ] **Input Sanitization**: XSS prevention, data validation
- [ ] **Privacy**: No sensitive data exposure
- [ ] **Dependencies**: Updated packages, security vulnerabilities

### 📱 UX/UI
- [ ] **Responsive Design**: Mobile/desktop compatibility
- [ ] **Loading States**: Proper feedback during async operations
- [ ] **Error Handling**: User-friendly error messages
- [ ] **Animations**: Smooth, purposeful transitions

### 💡 Suggestions
Please provide specific feedback on:
1. Any potential improvements
2. Missing error handling
3. Performance optimizations
4. Code organization suggestions

---
*Generated by AI Visual Code Review (${processedCount} files processed)*
`;

    // Write to AI_REVIEW.md in current working directory
    const filePath = path.join(process.cwd(), 'AI_REVIEW.md');
    writeFileSync(filePath, content);

    console.log('✅ AI_REVIEW.md generated successfully');
    console.log(`📊 Final stats: ${processedCount} files processed, ${excludedFiles?.length || 0} excluded`);

    res.json({
      success: true,
      file: 'AI_REVIEW.md',
      filesProcessed: processedCount,
      totalFiles: stagedFiles.length,
      excludedCount: excludedFiles?.length || 0,
      excludedFiles: excludedFiles || []
    });

  } catch (error) {
    console.error('❌ Export for AI failed:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Individual file export endpoint
app.post('/api/export-individual-reviews', (req, res) => {
  try {
    const { comments, lineComments, excludedFiles } = req.body;

    console.log('📁 Individual Export request received');

    // Get all staged files
    const stagedFiles = executeGitCommand('git diff --cached --name-only')
      .trim()
      .split('\n')
      .filter(f => f.length > 0);

    // Filter out excluded files
    const includedFiles = stagedFiles.filter(file => {
      return !excludedFiles || !excludedFiles.includes(file);
    });

    const timestamp = new Date().toISOString().slice(0, 19).replace(/[:]/g, '-');
    const reviewDir = `code-reviews-${timestamp}`;

    // Create directory if it doesn't exist
    const { mkdirSync } = require('fs');
    const reviewPath = path.join(process.cwd(), reviewDir);

    try {
      mkdirSync(reviewPath, { recursive: true });
    } catch (error) {
      // Directory might already exist
    }

    let filesCreated = 0;

    // Create individual review file for each included file
    for (const file of includedFiles) {
      try {
        const safeName = file.replace(/[^a-zA-Z0-9.-]/g, '_');
        const reviewFileName = `review-${safeName}.md`;
        const reviewFilePath = path.join(reviewPath, reviewFileName);

        let content = `# 📄 Code Review: \`${file}\`

**Generated:** ${new Date().toLocaleString()}
**Project:** AI Visual Code Review

## 📊 File Information

**Type:** ${path.extname(file) || 'No extension'}
**Path:** \`${file}\`

`;

        // Add file comment if exists
        if (comments && comments[file]) {
          content += `## 💭 Review Comment

${comments[file]}

`;
        }

        // Add diff
        try {
          const diff = executeGitCommand(`git diff --cached "${file}"`);
          content += `## 🔍 Changes

\`\`\`diff
${diff}
\`\`\`

`;
        } catch (error) {
          content += `## ❌ Error

Could not load diff for ${file}: ${error.message}

`;
        }

        // Add review template
        content += `## 🤖 Review Checklist

### ✅ Code Quality
- [ ] Syntax and formatting
- [ ] Variable naming and clarity
- [ ] Function/method structure
- [ ] Documentation and comments

### 🔍 Logic Review
- [ ] Algorithm correctness
- [ ] Edge case handling
- [ ] Error handling
- [ ] Performance considerations

### 🐛 Potential Issues
- [ ] Memory leaks
- [ ] Security vulnerabilities
- [ ] Race conditions
- [ ] Null/undefined handling

### 💡 Suggestions
Add your feedback here:

---
*Individual file review generated by AI Visual Code Review*
`;

        writeFileSync(reviewFilePath, content);
        filesCreated++;
        console.log(`✅ Created: ${reviewFileName}`);

      } catch (error) {
        console.error(`❌ Error creating review for ${file}:`, error);
      }
    }

    res.json({
      success: true,
      directory: reviewDir,
      filesCreated,
      totalFiles: stagedFiles.length,
      excludedCount: excludedFiles?.length || 0,
      commentsIncluded: Object.keys(comments || {}).length
    });

  } catch (error) {
    console.error('❌ Individual export failed:', error);
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Serve the main review interface
app.get('/', (req, res) => {
  const htmlPath = path.join(__dirname, 'public', 'index.html');
  if (existsSync(htmlPath)) {
    res.sendFile(htmlPath);
  } else {
    res.send(`
      <h1>AI Visual Code Review</h1>
      <p>Server is running but interface files are missing.</p>
      <p>Current directory: ${process.cwd()}</p>
      <p>Please ensure the public/index.html file exists.</p>
    `);
  }
});

// Start server
app.listen(PORT, () => {
  console.log('🔍 AI Visual Code Review Server');
  console.log('===============================');
  console.log(`🌐 Server running at: http://localhost:${PORT}`);
  console.log(`📁 Working directory: ${process.cwd()}`);
  console.log(`⏰ Started at: ${new Date().toLocaleString()}`);
  console.log('');
  console.log('📋 Available endpoints:');
  console.log('   GET  /                     - Visual review interface');
  console.log('   GET  /api/health          - Repository status');
  console.log('   GET  /api/summary         - Change statistics');
  console.log('   GET  /api/staged-files    - List of staged files');
  console.log('   POST /api/export-for-ai   - Generate AI review');
  console.log('');
  console.log('💡 Usage:');
  console.log('   1. Stage changes: git add .');
  console.log('   2. Open: http://localhost:3002');
  console.log('   3. Review and export for AI analysis');
  console.log('');
});

module.exports = app;
