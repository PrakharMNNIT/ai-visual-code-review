# 🚀 Complete Setup Guide

This guide covers all installation and setup scenarios for AI Visual Code Review v2.0.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Installation](#local-installation)
3. [Using in Any Repository](#using-in-any-repository)
4. [NPM Publishing & Distribution](#npm-publishing--distribution)
5. [Remote Repository Usage](#remote-repository-usage)
6. [CI/CD Integration](#cicd-integration)
7. [Docker Deployment](#docker-deployment)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### System Requirements
- **Node.js**: Version 14 or higher
- **npm**: Version 6 or higher
- **Git**: Version 2.0 or higher
- **Operating System**: Windows, macOS, or Linux

### Quick Check
```bash
node --version    # Should show v14.0.0 or higher
npm --version     # Should show 6.0.0 or higher
git --version     # Should show 2.0.0 or higher
```

---

## 🏠 Local Installation

### Option 1: Clone and Install (Recommended for Development)

```bash
# 1. Clone the repository
git clone https://github.com/ai-tools/ai-visual-code-review.git
cd ai-visual-code-review

# 2. Install dependencies
npm install

# 3. Run tests to verify installation
npm test

# 4. Install globally for system-wide access
npm install -g .

# 5. Verify installation
ai-review --help
```

### Option 2: Direct NPM Installation

```bash
# Install globally from npm (when published)
npm install -g ai-visual-code-review

# Verify installation
ai-review --help
```

### Option 3: Local Development Setup

```bash
# 1. Clone for development
git clone https://github.com/ai-tools/ai-visual-code-review.git
cd ai-visual-code-review

# 2. Install dependencies including dev dependencies
npm install

# 3. Start development server with hot reload
npm run dev

# 4. Run in development mode (separate terminal)
cd /path/to/your/project
/path/to/ai-visual-code-review/bin/ai-review.js
```

---

## 📁 Using in Any Repository

### Quick Start (5 minutes)

```bash
# 1. Navigate to your project
cd /path/to/your/project

# 2. Ensure it's a git repository
git init  # if not already initialized

# 3. Make some changes and stage them
git add .

# 4. Start AI Visual Code Review
ai-review

# 5. Open browser at http://localhost:3002
```

### Detailed Workflow

#### Step 1: Project Preparation
```bash
# Navigate to your project
cd ~/my-awesome-project

# Check git status
git status

# Stage changes you want to review
git add src/components/Header.tsx
git add src/utils/helpers.js
# OR stage everything
git add .
```

#### Step 2: Start Review Server
```bash
# Basic usage
ai-review

# Custom port
ai-review --port 3003

# Auto-open browser
ai-review --open

# Help and options
ai-review --help
```

#### Step 3: Review Process
1. **Open Interface**: Navigate to `http://localhost:3002`
2. **Review Files**: Click on files to see diffs
3. **Add Comments**: Use the comment button to add file or line comments
4. **Select Files**: Choose which files to include in AI review
5. **Export**: Click "Export for AI Review" to generate `AI_REVIEW.md`
6. **AI Analysis**: Copy content to ChatGPT/Claude for detailed feedback

#### Step 4: Quick Export (Alternative)
```bash
# Generate AI review without web interface
ai-review quick

# With file exclusions
ai-review quick --exclude package-lock.json dist/

# Include only specific files
ai-review quick --include src/ --no-size-limit
```

---

## 📦 NPM Publishing & Distribution

### Publishing to NPM

#### Step 1: Prepare for Publishing
```bash
# 1. Update version in package.json
npm version patch  # or minor/major

# 2. Ensure all tests pass
npm test
npm run test:security

# 3. Build documentation
npm run build:docs  # if applicable

# 4. Review package contents
npm pack --dry-run
```

#### Step 2: Publish to NPM
```bash
# 1. Login to npm (first time only)
npm login

# 2. Publish package
npm publish

# 3. Verify publication
npm view ai-visual-code-review
```

#### Step 3: Create Distribution Scripts
```bash
# Create release script
cat > scripts/release.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Preparing release..."

# Run tests
npm test
npm run test:security

# Update version
npm version $1

# Publish
npm publish

# Create git tag
git push origin --tags

echo "✅ Release complete!"
EOF

chmod +x scripts/release.sh

# Usage: ./scripts/release.sh patch
```

### Private Registry Publishing

```bash
# Configure private registry
npm config set registry https://your-private-registry.com

# Publish to private registry
npm publish

# Reset to public registry (optional)
npm config set registry https://registry.npmjs.org
```

---

## 🌐 Remote Repository Usage

### Scenario 1: Team Member Installation

```bash
# Team member on any machine
npm install -g ai-visual-code-review

# Use in any project
cd /path/to/team/project
git add .
ai-review
```

### Scenario 2: Project-Specific Installation

```bash
# Add to your project's package.json
npm install --save-dev ai-visual-code-review

# Add to scripts section in package.json
{
  "scripts": {
    "review": "ai-review",
    "review:quick": "ai-review quick"
  }
}

# Team members can now use:
npm run review
npm run review:quick
```

### Scenario 3: Shared Configuration

Create `.ai-review.json` in project root:
```json
{
  "excludePatterns": [
    "*.log",
    "node_modules/*",
    "dist/*",
    ".env*",
    "coverage/*"
  ],
  "maxFileSize": 5000,
  "defaultPort": 3002,
  "autoOpen": false,
  "exportTemplate": "comprehensive"
}
```

### Scenario 4: Git Hooks Integration

```bash
# Install in project
cd your-project
npm install --save-dev ai-visual-code-review

# Create pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
if ! git diff --cached --quiet; then
    echo "🔍 Generating code review..."
    npx ai-review quick --exclude "*.lock" "dist/*"
    echo "📋 Review generated: AI_REVIEW.md"
    echo "💡 Tip: Review AI_REVIEW.md before committing"
fi
EOF

chmod +x .git/hooks/pre-commit
```

---

## ⚙️ CI/CD Integration

### GitHub Actions

Create `.github/workflows/code-review.yml`:
```yaml
name: AI Code Review

on:
  pull_request:
    branches: [ main, develop ]

jobs:
  ai-review:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
      with:
        fetch-depth: 2
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
    
    - name: Install AI Code Review
      run: npm install -g ai-visual-code-review
    
    - name: Stage changes
      run: |
        git diff HEAD~1 --name-only | xargs git add
    
    - name: Generate AI Review
      run: ai-review quick --exclude "*.lock" "dist/*"
    
    - name: Upload Review
      uses: actions/upload-artifact@v3
      with:
        name: ai-review
        path: AI_REVIEW.md
    
    - name: Comment on PR
      uses: actions/github-script@v6
      with:
        script: |
          const fs = require('fs');
          if (fs.existsSync('AI_REVIEW.md')) {
            const review = fs.readFileSync('AI_REVIEW.md', 'utf8');
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '## 🤖 AI Code Review\n\n```markdown\n' + review + '\n```'
            });
          }
```

### GitLab CI

Create `.gitlab-ci.yml`:
```yaml
stages:
  - review

ai_code_review:
  stage: review
  image: node:18
  before_script:
    - npm install -g ai-visual-code-review
  script:
    - git diff HEAD~1 --name-only | xargs git add
    - ai-review quick --exclude "*.lock" "dist/*"
  artifacts:
    paths:
      - AI_REVIEW.md
    expire_in: 1 week
  only:
    - merge_requests
```

### Jenkins Pipeline

```groovy
pipeline {
    agent any
    
    stages {
        stage('AI Code Review') {
            steps {
                sh 'npm install -g ai-visual-code-review'
                sh 'git diff HEAD~1 --name-only | xargs git add'
                sh 'ai-review quick --exclude "*.lock" "dist/*"'
                
                archiveArtifacts artifacts: 'AI_REVIEW.md', fingerprint: true
                
                script {
                    if (fileExists('AI_REVIEW.md')) {
                        def review = readFile('AI_REVIEW.md')
                        pullRequest.comment("## 🤖 AI Code Review\n\n```markdown\n${review}\n```")
                    }
                }
            }
        }
    }
}
```

---

## 🐳 Docker Deployment

### Dockerfile

Create `Dockerfile`:
```dockerfile
FROM node:18-alpine

# Install git (required for git operations)
RUN apk add --no-cache git

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application files
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S ai-review -u 1001

# Change ownership
RUN chown -R ai-review:nodejs /app
USER ai-review

# Expose port
EXPOSE 3002

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3002/api/health || exit 1

# Start application
CMD ["npm", "start"]
```

### Docker Compose

Create `docker-compose.yml`:
```yaml
version: '3.8'

services:
  ai-code-review:
    build: .
    ports:
      - "3002:3002"
    volumes:
      - .:/workspace:ro
    working_dir: /workspace
    environment:
      - NODE_ENV=production
      - PORT=3002
    restart: unless-stopped
    
  # Optional: Nginx reverse proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/ssl/certs:ro
    depends_on:
      - ai-code-review
    restart: unless-stopped
```

### Kubernetes Deployment

Create `k8s-deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ai-code-review
  labels:
    app: ai-code-review
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ai-code-review
  template:
    metadata:
      labels:
        app: ai-code-review
    spec:
      containers:
      - name: ai-code-review
        image: ai-code-review:2.0.0
        ports:
        - containerPort: 3002
        env:
        - name: NODE_ENV
          value: "production"
        - name: PORT
          value: "3002"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /api/health
            port: 3002
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /api/health
            port: 3002
          initialDelaySeconds: 5
          periodSeconds: 5

---
apiVersion: v1
kind: Service
metadata:
  name: ai-code-review-service
spec:
  selector:
    app: ai-code-review
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3002
  type: LoadBalancer
```

---

## 🔧 Troubleshooting

### Common Issues

#### Issue: "Command not found: ai-review"
```bash
# Solutions:
# 1. Install globally
npm install -g ai-visual-code-review

# 2. Use npx for one-time usage
npx ai-visual-code-review

# 3. Check PATH
echo $PATH
npm config get prefix
```

#### Issue: "Not a git repository"
```bash
# Solution: Initialize git
git init
git add .
git commit -m "Initial commit"
```

#### Issue: "No staged changes found"
```bash
# Solution: Stage some changes
git add .
git status  # Verify files are staged
```

#### Issue: "Port 3002 already in use"
```bash
# Solutions:
# 1. Use different port
ai-review --port 3003

# 2. Kill existing process
lsof -ti:3002 | xargs kill

# 3. Find what's using the port
lsof -i:3002
```

#### Issue: "Permission denied"
```bash
# Solutions:
# 1. Fix permissions
chmod +x /path/to/ai-review

# 2. Use sudo for global install (Linux/macOS)
sudo npm install -g ai-visual-code-review

# 3. Configure npm for non-root global installs
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### Performance Issues

#### Large Repositories
```bash
# Use file filtering
ai-review quick --exclude "node_modules/*" "dist/*" "*.log"

# Include only specific directories
ai-review quick --include "src/**" "components/**"

# Set size limits
ai-review quick --max-size 1000
```

#### Memory Issues
```bash
# Monitor memory usage
node --max-old-space-size=4096 /path/to/ai-review

# Use individual file exports for large changesets
ai-review # Use web interface, select fewer files
```

### Network Issues

#### Firewall/Proxy
```bash
# Configure npm for corporate proxy
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy http://proxy.company.com:8080

# Configure git for proxy
git config --global http.proxy http://proxy.company.com:8080
```

### Getting Help

```bash
# Built-in help
ai-review --help
ai-review quick --help

# Check version
ai-review --version

# Debug mode
DEBUG=ai-review:* ai-review

# Verbose logging
NODE_ENV=development ai-review
```

### Reporting Issues

1. **Check existing issues**: [GitHub Issues](https://github.com/ai-tools/ai-visual-code-review/issues)
2. **Provide information**:
   - Operating system and version
   - Node.js and npm versions
   - Git version
   - Command that failed
   - Complete error message
   - Steps to reproduce
3. **Security issues**: Follow [SECURITY.md](SECURITY.md) guidelines

---

## 📞 Support & Community

- **Documentation**: [README.md](README.md)
- **Security**: [SECURITY.md](SECURITY.md)
- **Changes**: [CHANGELOG.md](CHANGELOG.md)
- **Issues**: [GitHub Issues](https://github.com/ai-tools/ai-visual-code-review/issues)
- **Discussions**: [GitHub Discussions](https://github.com/ai-tools/ai-visual-code-review/discussions)

---

**Happy Reviewing!** 🔍✨
