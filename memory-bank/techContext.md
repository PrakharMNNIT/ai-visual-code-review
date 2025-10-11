# AI Visual Code Review - Technical Context

## 🛠️ **Technology Stack**

### **Runtime Environment**

- **Node.js 14+** - LTS runtime with ES6+ support
- **NPM Package Manager** - Dependency management and publishing
- **Cross-Platform Support** - Windows, macOS, Linux compatibility

### **Backend Technologies**

- **Express.js 4.18+** - Fast, unopinionated web framework
- **CORS 2.8+** - Cross-Origin Resource Sharing middleware
- **Native Node.js Modules** - child_process, fs, path for core functionality

### **Frontend Technologies**

- **Vanilla JavaScript** - No framework dependencies, maximum performance
- **Modern ES6+** - async/await, Map/Set, destructuring, modules
- **CSS3** - Flexbox, CSS Grid, custom properties, animations
- **HTML5** - Semantic markup, accessibility features

### **Development Tools**

- **Jest 29.7+** - JavaScript testing framework
- **SuperTest 6.3+** - HTTP assertion library for API testing
- **Nodemon 3.0+** - Development server with hot reload
- **ESLint 8.50+** - Code linting and style enforcement

### **VSCode Extension Stack**

- **TypeScript 5.0+** - Type-safe extension development
- **VSCode Extension API** - Native editor integration
- **Node.js Child Process** - Git command execution

## 📋 **Package.json Analysis**

### **Production Dependencies**

```json
{
  "express": "^4.18.2",  // Web server framework
  "cors": "^2.8.5"       // CORS middleware
}
```

**Rationale**: Minimal dependencies reduce attack surface and improve reliability.

### **Development Dependencies**

```json
{
  "jest": "^29.7.0",        // Testing framework
  "supertest": "^6.3.3",   // API testing
  "nodemon": "^3.0.1",     // Development server
  "eslint": "^8.50.0"      // Code quality
}
```

### **Scripts Configuration**

```json
{
  "start": "node server.js",           // Production start
  "review": "node server.js",          // Alias for convenience
  "quick": "./scripts/quick-ai-review.sh",  // Quick export
  "test": "jest",                      // Run tests
  "test:coverage": "jest --coverage",  // Coverage reports
  "test:security": "npm audit --audit-level high"  // Security audit
}
```

## 🏗️ **Architecture Decisions**

### **Monolithic vs Microservices**

**Decision**: Monolithic architecture
**Rationale**:

- Single deployment unit simplifies installation
- Lower complexity for code review tool
- Better performance for local development

### **Security-First Design**

**Decision**: Multiple security layers built-in
**Components**:

- Input validation at every entry point
- Command injection prevention with allowlists
- Rate limiting on all public endpoints
- Security headers on all responses

### **No Build Step Frontend**

**Decision**: Vanilla JavaScript without compilation
**Rationale**:

- Faster development cycle
- No build tool dependencies
- Easier debugging and maintenance
- Smaller package size

## 🔒 **Security Technology Choices**

### **Git Command Execution**

```javascript
// Allowlisted commands only
const ALLOWED_GIT_COMMANDS = {
  'diff-cached': ['git', 'diff', '--cached'],
  'diff-cached-names': ['git', 'diff', '--cached', '--name-only'],
  'diff-cached-stat': ['git', 'diff', '--cached', '--stat'],
  'status-porcelain': ['git', 'status', '--porcelain']
};
```

**Security Features**:

- No arbitrary command execution
- Argument sanitization with regex
- Timeout enforcement (15 seconds)
- Buffer limits (10MB)

### **Rate Limiting Implementation**

```javascript
const rateLimitStore = new Map();
const createRateLimit = (maxRequests, windowMs) => {
  // IP-based tracking
  // Configurable limits
  // Development bypass
};
```

**Configuration**:

- General API: 50 requests/15 minutes
- Export endpoints: 10 requests/15 minutes
- Localhost bypass during development

### **Input Validation Strategy**

```javascript
function validateFileRequest(file) {
  // Type checking
  // Security pattern matching
  // Path traversal prevention
  // Length limits
}
```

## 📊 **Performance Considerations**

### **Memory Management**

```javascript
class MemoryManager {
  constructor() {
    this.maxCacheSize = 50;
    this.cleanupInterval = 300000; // 5 minutes
  }

  cleanup() {
    // Clean diff cache
    // Remove detached DOM nodes
    // Manage Map/Set sizes
  }
}
```

### **Caching Strategy**

- **Client-side**: Map-based diff caching with size limits
- **Server-side**: Request caching with TTL (30 seconds)
- **Automatic cleanup**: Prevents memory leaks

### **Async Operations**

```javascript
// Non-blocking Git operations
async function executeGitCommand(commandType, args) {
  return new Promise((resolve, reject) => {
    exec(command, {
      timeout: CONFIG.git.timeout,
      maxBuffer: 10 * 1024 * 1024
    }, callback);
  });
}
```

## 🧪 **Testing Architecture**

### **Test Categories**

1. **Security Tests** - Command injection, XSS, path traversal
2. **API Tests** - All endpoints with error scenarios
3. **Rate Limiting Tests** - Verify limits enforced
4. **Validation Tests** - Input sanitization effectiveness

### **Test Configuration**

```javascript
"jest": {
  "testEnvironment": "node",
  "collectCoverageFrom": [
    "**/*.js",
    "!node_modules/**",
    "!coverage/**",
    "!test/**"
  ],
  "testMatch": ["**/test/**/*.test.js"]
}
```

### **Security Test Examples**

```javascript
describe('Security Tests', () => {
  test('Should reject malicious file paths', () => {
    const maliciousFiles = [
      '../../../etc/passwd',
      'file<script>alert(1)</script>',
      'file|rm -rf /'
    ];
    // Test each for proper rejection
  });
});
```

## 📱 **Multi-Platform Strategy**

### **CLI Implementation**

- **Shebang**: `#!/usr/bin/env node` for cross-platform execution
- **Process Management**: Graceful shutdown handling
- **Path Resolution**: Cross-platform path handling

### **Web Interface**

- **Responsive Design**: Mobile, tablet, desktop support
- **Cross-Browser**: Modern browser compatibility
- **Progressive Enhancement**: Works without JavaScript

### **VSCode Extension**

- **TypeScript**: Type-safe development
- **Extension API**: Native VS Code integration
- **Command Registration**: Palette integration

## 🔧 **Configuration Management**

### **Environment Variables**

```javascript
const CONFIG = {
  server: {
    port: process.env.PORT || 3002,
    requestTimeout: 30000,
    maxRequestSize: '10mb'
  },
  git: {
    timeout: 15000,
    maxFileSize: 10000
  }
};
```

### **Runtime Detection**

```javascript
// Environment-aware behavior
const isDevelopment = process.env.NODE_ENV !== 'production';
const isTesting = process.env.NODE_ENV === 'test';

// Security adjustments based on environment
if (isLocalhost && isDevelopment && !isTesting) {
  // Development optimizations
}
```

## 📦 **Deployment Strategy**

### **NPM Package Structure**

```json
"files": [
  "bin/**",
  "scripts/**",
  "services/**",
  "public/**",
  "server.js",
  "README.md",
  "LICENSE"
]
```

### **Binary Executables**

```json
"bin": {
  "ai-review": "./bin/ai-review.js",
  "quick-ai-review": "./scripts/quick-ai-review.sh"
}
```

### **Engine Requirements**

```json
"engines": {
  "node": ">=14.0.0"
}
```

## 💡 **Technical Trade-offs**

### **Advantages of Current Stack**

✅ **Minimal Dependencies** - Reduced security vulnerabilities
✅ **Fast Startup** - No compilation or build steps
✅ **Easy Debugging** - Direct source code execution
✅ **Cross-Platform** - Node.js runs everywhere
✅ **Production Ready** - Battle-tested technologies

### **Potential Limitations**

⚠️ **No TypeScript in Main Code** - Runtime type checking only
⚠️ **Vanilla JavaScript Frontend** - More manual DOM manipulation
⚠️ **In-Memory Storage** - No persistent data between sessions

### **Design Justifications**

- **Security over convenience** - Multiple validation layers
- **Reliability over features** - Conservative technology choices
- **Performance over developer experience** - Minimal abstractions
- **Maintainability over complexity** - Clear, readable code patterns

This technology stack provides a robust, secure, and maintainable foundation for the AI Visual Code Review system while keeping dependencies minimal and performance optimal.
