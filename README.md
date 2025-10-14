# 🔍 AI Visual Code Review v2.0

A **production-ready**, comprehensive visual code review system with AI integration for any Git repository. Features beautiful GitHub-like interface, line-by-line commenting, structured AI review exports, and enterprise-grade security.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-14%2B-green.svg)](https://nodejs.org/)
[![Git](https://img.shields.io/badge/Git-Required-orange.svg)](https://git-scm.com/)
[![Security](https://img.shields.io/badge/Security-Hardened-red.svg)](https://github.com/PrakharMNNIT/ai-visual-code-review)
[![Tests](https://img.shields.io/badge/Tests-Comprehensive-brightgreen.svg)](https://github.com/PrakharMNNIT/ai-visual-code-review)

## 🚀 **What's New in v2.0**

### 🔒 **Security Hardened**

- **Command Injection Protection** - Secure Git command execution with allowlists
- **Rate Limiting** - DoS protection with configurable limits
- **Input Validation** - Comprehensive sanitization of all user inputs
- **Security Headers** - CSP, XSS protection, and more
- **Path Traversal Prevention** - Multiple layers of file path validation

### ⚡ **Performance Enhanced**

- **Async Operations** - Non-blocking Git operations with timeouts
- **Memory Management** - Automatic cleanup prevents memory leaks
- **Request Caching** - Smart caching for repeated requests
- **Progressive Loading** - Better UX with lazy loading

### 🎨 **UX Improvements**

- **Smart Notifications** - Real-time feedback system
- **Enhanced File Icons** - Better file type recognition
- **Accessibility** - ARIA labels, keyboard navigation
- **Error Recovery** - Graceful handling with retry options
- **Loading States** - Clear progress indicators

## ✨ Core Features

### Visual Review Interface

- **GitHub-like Dark Theme** with professional styling
- **Interactive Diff Viewer** with syntax highlighting and line numbers
- **Line-by-line Commenting** with templates and persistence
- **File Selection** with smart defaults and exclusion options
- **Real-time Git Status** with actionable suggestions
- **Responsive Design** optimized for desktop, tablet, and mobile
- **Keyboard Navigation** full accessibility support

### AI Integration

- **Structured Export** generates comprehensive review documents
- **Multiple Export Formats** (unified or individual file reviews)
- **Enhanced Checklists** covering security, performance, accessibility
- **Framework-aware Analysis** (React, TypeScript, Python, etc.)
- **ChatGPT/Claude Optimized** markdown output with metadata
- **Error Tracking** detailed reporting of processing issues

### Developer Experience

- **Zero Configuration** works with any Git repository out of the box
- **Multiple Access Methods** (CLI, web interface, quick scripts)
- **Flexible File Filtering** advanced include/exclude patterns
- **Intelligent Size Management** automatic handling of large files
- **Cross-platform** support (Windows, macOS, Linux)
- **Development Mode** with hot reloading and debugging

## 🚀 Quick Start

### Option 1: One-line Installation

```bash
# Clone and install
git clone https://github.com/PrakharMNNIT/ai-visual-code-review.git
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
git clone https://github.com/PrakharMNNIT/ai-visual-code-review.git
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

**Recommended: Use CLI command** (cross-platform Node.js)

```bash
# Basic export
ai-review quick

# Exclude specific files
ai-review quick --exclude package-lock.json dist/

# Include only specific files
ai-review quick --include src/main.ts src/components/

# Custom size limits
ai-review quick --max-size 5000
ai-review quick --no-size-limit
```

**Alternative: Direct script** (legacy bash script)

```bash
./scripts/quick-ai-review.sh
```

## 🎯 Advanced Usage

### File Filtering

#### Include/Exclude Patterns

**Enhanced glob pattern support:**

- `**` matches zero or more directories
- `*` matches any characters in filename
- Patterns are matched against full file paths

```bash
# Exclude large config files
ai-review quick --exclude package-lock.json webpack.config.js

# Focus on source code only (** matches nested directories)
ai-review quick --include "src/**/*.ts" "src/**/*.tsx"

# Match files in scripts/ including root level
ai-review quick --include "scripts/**/*.js"

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

## 🛠️ Development & Testing

### Local Development

```bash
# Clone and setup
git clone https://github.com/PrakharMNNIT/ai-visual-code-review.git
cd ai-visual-code-review
npm install

# Development with hot reload
npm run dev

# Run tests
npm test                    # Run all tests
npm run test:watch         # Watch mode
npm run test:coverage      # Coverage report
npm run test:security      # Security audit

# Production server
npm start
```

### Testing Suite

**Comprehensive test coverage includes:**

- ✅ API endpoint testing with security validation
- ✅ Git command injection prevention
- ✅ Rate limiting functionality
- ✅ Input sanitization and validation
- ✅ Error handling and recovery
- ✅ DiffService functionality
- ✅ Security headers verification

```bash
# Run specific test suites
npm test -- --testPathPattern=server.test.js
npm test -- --testPathPattern=diffService.test.js

# Generate coverage report
npm run test:coverage
```

### Project Structure

```
ai-visual-code-review/
├── bin/
│   └── ai-review.js              # CLI entry point
├── public/
│   └── review.html              # Enhanced web interface
├── services/
│   └── diffService.js           # Git diff processing
├── scripts/
│   └── quick-ai-review.sh       # Quick export script
├── test/
│   ├── server.test.js           # API endpoint tests
│   ├── diffService.test.js      # Service tests
│   ├── api-client.py            # Python test client
│   ├── utils.js                 # Test utilities
│   └── sample-component.tsx     # Test data
├── server.js                    # Express server with security
├── package.json                 # Dependencies & scripts
├── install.sh                   # Installation script
└── README.md                    # Documentation
```

### Enhanced API Endpoints

**Core Endpoints:**

- `GET /` - Enhanced web interface with memory management
- `GET /api/health` - Repository status with version info
- `GET /api/summary` - Change statistics with caching
- `GET /api/staged-files` - List staged files with metadata
- `GET /api/file-diff?file=path` - Secure file diff data
- `POST /api/log-comment` - Comment logging with validation
- `POST /api/export-for-ai` - Generate AI review (rate limited)
- `POST /api/export-individual-reviews` - Individual file reviews

**Security Features:**

- 🔒 Rate limiting on all endpoints
- 🛡️ Input sanitization and validation
- 🔐 Command injection prevention
- 📊 Request/response logging
- ⏱️ Configurable timeouts

## 🔒 Security Features

### Multi-Layer Security Protection

**Command Injection Prevention:**

- ✅ Allowlisted Git commands only
- ✅ Argument sanitization with regex filtering
- ✅ Path traversal attack prevention
- ✅ No shell metacharacters allowed

**Input Validation:**

- ✅ File path validation with security patterns
- ✅ Request size limits (10MB default)
- ✅ Comment length restrictions
- ✅ Type checking on all inputs

**Rate Limiting:**

- ✅ 50 requests per 15 minutes (general)
- ✅ 10 exports per 15 minutes (specific)
- ✅ IP-based tracking
- ✅ Configurable limits

**Security Headers:**

- ✅ Content Security Policy (CSP)
- ✅ X-Frame-Options: DENY
- ✅ X-Content-Type-Options: nosniff
- ✅ X-XSS-Protection enabled
- ✅ Referrer Policy configured

**Production Hardening:**

- ✅ Error details hidden in production
- ✅ Sensitive data filtering in logs
- ✅ CORS restrictions
- ✅ Request timeout enforcement

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

For more information, visit: <https://github.com/PrakharMNNIT/ai-visual-code-review>
