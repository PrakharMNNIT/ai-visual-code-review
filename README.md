# 🔍 AI Visual Code Review

A comprehensive visual code review system with AI integration for any Git repository. Features beautiful GitHub-like interface, line-by-line commenting, and structured AI review exports.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-14%2B-green.svg)](https://nodejs.org/)
[![Git](https://img.shields.io/badge/Git-Required-orange.svg)](https://git-scm.com/)

## ✨ Features

### Visual Review Interface
- **GitHub-like Dark Theme** with professional styling
- **Interactive Diff Viewer** with syntax highlighting
- **Line-by-line Commenting** with templates and persistence  
- **File Selection** for targeted reviews
- **Real-time Git Status** monitoring
- **Responsive Design** works on desktop and mobile

### AI Integration
- **Structured Export** generates comprehensive review documents
- **Multiple Export Formats** (unified or individual file reviews)
- **Comprehensive Checklists** covering code quality, security, performance
- **Framework-aware Analysis** (React, TypeScript, Python, etc.)
- **ChatGPT/Claude Ready** optimized markdown output

### Developer Experience
- **Zero Configuration** works with any Git repository
- **Multiple Access Methods** (CLI, web interface, quick scripts)
- **Flexible File Filtering** include/exclude patterns
- **Size Management** automatic handling of large files
- **Cross-platform** support (Windows, macOS, Linux)

## 🚀 Quick Start

### Option 1: One-line Installation

```bash
# Clone and install
git clone https://github.com/ai-tools/ai-visual-code-review.git
cd ai-visual-code-review
chmod +x install.sh
./install.sh --global
```

### Option 2: NPM Installation (when published)

```bash
npm install -g ai-visual-code-review
```

### Option 3: Manual Setup

```bash
# Clone repository
git clone https://github.com/ai-tools/ai-visual-code-review.git
cd ai-visual-code-review

# Install dependencies
npm install

# Make scripts executable
chmod +x bin/ai-review.js
chmod +x scripts/quick-ai-review.sh
```

## 📋 Usage

### Basic Workflow

1. **Navigate to your project**
   ```bash
   cd your-project
   git add .  # Stage changes
   ```

2. **Start visual review**
   ```bash
   ai-review  # Opens http://localhost:3002
   ```

3. **Review changes**
   - Expand files to see diffs
   - Add comments and notes
   - Select files for export

4. **Export for AI**
   - Click "Export for AI Review"
   - Gets `AI_REVIEW.md` with structured format

5. **Get AI feedback**
   ```
   Ask ChatGPT/Claude: "Please review the AI_REVIEW.md file and provide detailed feedback on code quality, potential issues, and improvements."
   ```

### CLI Commands

```bash
# Start visual review server
ai-review
ai-review start
ai-review start --port 3003 --open

# Quick markdown generation
ai-review quick
ai-review quick --exclude dist/ node_modules/
ai-review quick --include src/ --no-size-limit

# Help and information
ai-review --help
```

### Quick Script Usage

```bash
# Basic export
./scripts/quick-ai-review.sh

# Exclude specific files
./scripts/quick-ai-review.sh --exclude package-lock.json dist/

# Include only specific files
./scripts/quick-ai-review.sh --include src/main.ts src/components/

# Custom size limits
./scripts/quick-ai-review.sh --max-size 5000
./scripts/quick-ai-review.sh --no-size-limit
```

## 🎯 Advanced Usage

### File Filtering

#### Include/Exclude Patterns
```bash
# Exclude large config files
ai-review quick --exclude package-lock.json webpack.config.js

# Focus on source code only
ai-review quick --include "src/**/*.ts" "src/**/*.tsx"

# Exclude entire directories
ai-review quick --exclude "dist/*" "node_modules/*" "*.log"
```

#### Size Management
```bash
# Skip files over 1000 lines
ai-review quick --max-size 1000

# Include all files regardless of size
ai-review quick --no-size-limit
```

### Custom Port and Options

```bash
# Use different port
ai-review start --port 8080

# Auto-open browser
ai-review start --open

# Environment configuration
PORT=3003 ai-review start
```

### Integration with Editors

#### VS Code Tasks
Add to `.vscode/tasks.json`:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "🔍 Visual Code Review",
      "type": "shell",
      "command": "ai-review",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "new"
      },
      "problemMatcher": []
    }
  ]
}
```

#### Git Hooks
Pre-commit hook example:
```bash
#!/bin/bash
# .git/hooks/pre-commit
if ! git diff --cached --quiet; then
    echo "🔍 Generating code review..."
    ai-review quick
    echo "📋 Review AI_REVIEW.md before committing"
fi
```

## 🔧 Configuration

### Environment Variables

```bash
# Server configuration
export PORT=3002                    # Server port
export NODE_ENV=development         # Environment mode

# Git configuration  
export GIT_DIFF_CONTEXT=3          # Diff context lines
export GIT_DIFF_ALGORITHM=patience  # Diff algorithm
```

### Project Configuration

Create `.ai-review.json` in your project root:
```json
{
  "excludePatterns": [
    "*.log",
    "node_modules/*",
    "dist/*",
    ".env*"
  ],
  "maxFileSize": 10000,
  "defaultPort": 3002,
  "autoOpen": false,
  "exportTemplate": "standard"
}
```

## 📊 Export Formats

### Unified Review (`AI_REVIEW.md`)
```markdown
# 🔍 Code Review - [timestamp]

## 📊 Change Summary
[git diff stats]

## 📝 Files Changed
### 📄 `src/component.tsx`
**Type:** TypeScript/React Component
```diff
[unified diff for all changes]
```

## 🤖 Review Checklist
- [ ] Code Quality
- [ ] Security & Data  
- [ ] Performance
- [ ] Accessibility
```

### Individual File Reviews
Creates `code-reviews-[timestamp]/` directory with separate markdown file for each changed file.

## 🤖 AI Integration Guide

### Optimal Prompts

**For ChatGPT/Claude:**
```
Please review the AI_REVIEW.md file and provide detailed feedback on:

1. Code Quality & Best Practices
2. Potential Bugs & Edge Cases  
3. Security Vulnerabilities
4. Performance Optimizations
5. Accessibility Improvements
6. Testing Recommendations

Focus on actionable suggestions with examples.
```

**For Code-specific Analysis:**
```
Analyze this [TypeScript/Python/etc] code for:
- Type safety issues
- Framework-specific anti-patterns  
- Memory leaks or performance issues
- Missing error handling
- Opportunities for refactoring
```

### Supported Frameworks

The system provides specialized analysis for:
- **React/TypeScript** - Hook patterns, component structure, type safety
- **Node.js** - Async/await patterns, error handling, security
- **Python** - Type hints, PEP compliance, performance
- **Vue.js** - Composition API, reactivity patterns
- **General** - Git best practices, documentation, testing

## 🛠️ Development

### Local Development

```bash
# Clone and setup
git clone https://github.com/ai-tools/ai-visual-code-review.git
cd ai-visual-code-review
npm install

# Start development server
npm start
# or
node server.js

# Run with auto-reload
npm install -g nodemon
nodemon server.js
```

### Project Structure

```
ai-visual-code-review/
├── bin/
│   └── ai-review.js         # CLI entry point
├── public/
│   └── index.html          # Web interface
├── scripts/
│   └── quick-ai-review.sh  # Quick export script
├── server.js               # Express server
├── package.json           # Dependencies
├── install.sh            # Installation script
└── README.md            # Documentation
```

### API Endpoints

- `GET /` - Web interface
- `GET /api/health` - Repository status
- `GET /api/summary` - Change statistics  
- `GET /api/staged-files` - List staged files
- `GET /api/file-diff?file=path` - File diff data
- `POST /api/export-for-ai` - Generate AI review
- `POST /api/export-individual-reviews` - Individual file reviews

## 🔒 Security Considerations

- **Production Safety**: Export functionality disabled in production
- **Local Only**: Server binds to localhost by default
- **No Remote Access**: Git operations limited to local repository
- **Input Sanitization**: All file paths validated
- **Process Isolation**: Git commands run with limited permissions

## 🐛 Troubleshooting

### Common Issues

**"No staged changes found"**
```bash
git add .
git status  # Verify files are staged
```

**"Port 3002 already in use"**
```bash
# Kill existing process
lsof -ti:3002 | xargs kill
# Or use different port
ai-review start --port 3003
```

**"Git command failed"**
```bash
# Check Git installation
git --version
# Verify you're in a Git repository
git status
```

**"Module not found: express"**
```bash
npm install
# Or global installation
npm install -g ai-visual-code-review
```

### Performance Issues

**Large repositories:**
- Use file filtering: `--exclude` or `--include`
- Set size limits: `--max-size 5000`
- Focus on specific directories

**Slow diff generation:**
- Stage fewer files at once
- Use `git add [specific-files]` instead of `git add .`
- Configure Git diff algorithm: `git config diff.algorithm patience`

## 📈 Examples

### React/TypeScript Project
```bash
# Focus on source code, exclude generated files
ai-review quick --include "src/**/*.ts" "src/**/*.tsx" --exclude "dist/*" "*.d.ts"
```

### Node.js API Project
```bash
# Include API routes and exclude logs
ai-review quick --include "routes/**" "middleware/**" "models/**" --exclude "*.log" "node_modules/*"
```

### Python Project
```bash
# Include Python files, exclude virtual environment
ai-review quick --include "*.py" --exclude "venv/*" "__pycache__/*" "*.pyc"
```

### Full-stack Project
```bash
# Separate frontend and backend reviews
ai-review quick --include "frontend/**" > frontend_review.md
ai-review quick --include "backend/**" > backend_review.md
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests.

### Development Setup
1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Make changes and test thoroughly
4. Submit pull request with clear description

### Reporting Issues
- Use GitHub Issues with detailed reproduction steps
- Include system information (OS, Node.js version, Git version)
- Provide sample repository if possible

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by GitHub's code review interface
- Built for AI-assisted development workflows
- Designed for modern development teams

---

**Happy Reviewing!** 🔍✨

For more information, visit: https://github.com/ai-tools/ai-visual-code-review
