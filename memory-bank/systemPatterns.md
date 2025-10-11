# AI Visual Code Review - System Patterns & Architecture

## 🏗️ **Core Architecture Pattern**

### **Layered Security-First Architecture**

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │     CLI     │  │  Web UI     │  │   VSCode    │        │
│  │   (Node.js) │  │ (Vanilla JS)│  │ Extension   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
│
┌─────────────────────────────────────────────────────────────┐
│                   API Gateway Layer                         │
│         Express.js Server with Security Middleware          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │Rate Limiting│  │   Input     │  │   Security  │        │
│  │& Validation │  │ Sanitization│  │   Headers   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
│
┌─────────────────────────────────────────────────────────────┐
│                  Service Layer                               │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │ DiffService │  │ GitService  │  │ ExportService│        │
│  │  (Secure)   │  │(Allowlisted)│  │  (AI-Opt)   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
│
┌─────────────────────────────────────────────────────────────┐
│                   Data Layer                                 │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │    Git      │  │  File System│  │   Memory    │        │
│  │  Commands   │  │   (Secured) │  │   Cache     │        │
│  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────┘
```

## 🔒 **Security Patterns**

### **Defense in Depth Pattern**

```javascript
// 1. Input Validation Layer
const validateInput = (input) => {
  if (!input || typeof input !== 'string') return false;
  if (suspiciousPatterns.some(pattern => pattern.test(input))) return false;
  return DiffService.isValidFilePath(input);
};

// 2. Command Allowlisting Pattern
const ALLOWED_GIT_COMMANDS = {
  'diff-cached': ['git', 'diff', '--cached'],
  'status-porcelain': ['git', 'status', '--porcelain']
};

// 3. Rate Limiting Pattern
const createRateLimit = (maxRequests, windowMs) => {
  return middleware with IP-based tracking;
};

// 4. Security Headers Pattern
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('Content-Security-Policy', "default-src 'self'");
});
```

### **Secure Git Command Execution Pattern**

```javascript
async function executeGitCommand(commandType, args = []) {
  // 1. Validate command type against allowlist
  const baseCommand = ALLOWED_GIT_COMMANDS[commandType];
  if (!baseCommand) reject();

  // 2. Sanitize arguments
  const sanitizedArgs = args.filter(validateArg);

  // 3. Execute with timeout and buffer limits
  exec(command, { timeout: 15000, maxBuffer: 10MB });
}
```

## 📊 **Data Flow Patterns**

### **Request Processing Pipeline**

```
Request → Security Middleware → Validation → Rate Limiting →
Business Logic → Git Commands → Response Generation →
Security Headers → Response
```

### **Git Diff Processing Pattern**

```javascript
// Structured Diff Processing
class DiffService {
  static parseDiff(diff) {
    // Parse chunks with line tracking
    // Handle added/removed/context lines
    // Generate structured output
  }

  static formatEnhancedDiff(parsedDiff) {
    // Format with line numbers
    // Add markdown syntax highlighting
    // Preserve security context
  }
}
```

## 🎨 **UI/UX Patterns**

### **Progressive Enhancement Pattern**

```javascript
// 1. Base Functionality (Server-side rendering)
app.get('/', (req, res) => {
  if (htmlExists) res.sendFile(htmlPath);
  else res.send(fallbackHTML);
});

// 2. Enhanced Functionality (Client-side JavaScript)
// Interactive diff viewer
// Real-time commenting
// Live status updates

// 3. Advanced Features (Memory management)
class MemoryManager {
  cleanup() {
    // Clean diff cache
    // Remove detached nodes
    // Manage memory limits
  }
}
```

### **GitHub-Like Interface Pattern**

```css
/* Dark theme with professional styling */
body { background: #0d1117; color: #c9d1d9; }

/* Interactive elements with hover states */
.file-item:hover {
  border-color: #58a6ff;
  box-shadow: 0 0 0 2px rgba(88, 166, 255, 0.1);
}

/* Diff visualization with color coding */
.diff-added { background: rgba(46, 160, 67, 0.15); }
.diff-removed { background: rgba(248, 81, 73, 0.15); }
```

## 🔄 **State Management Patterns**

### **Client-Side State Pattern**

```javascript
const state = {
  allDiffs: new Map(),
  fileComments: new Map(),
  lineComments: new Map(),
  selectedFiles: new Set(),

  // Memory management
  addDiff(file, diff, parsedDiff) {
    this.allDiffs.set(file, diff);
    // Limit cache size to prevent memory issues
    if (this.allDiffs.size > 50) {
      const firstKey = this.allDiffs.keys().next().value;
      this.allDiffs.delete(firstKey);
    }
  }
};
```

### **Server-Side Caching Pattern**

```javascript
const requestCache = new Map();

function cacheMiddleware(ttlSeconds = 30) {
  return (req, res, next) => {
    const key = getCacheKey(req);
    const cached = requestCache.get(key);

    if (cached && !isExpired(cached)) {
      return res.json(cached.data);
    }
    // Cache response with TTL
  };
}
```

## 🧪 **Testing Patterns**

### **Security Testing Pattern**

```javascript
describe('Security Tests', () => {
  test('Should reject malicious file paths', async () => {
    const maliciousFiles = [
      '../../../etc/passwd',
      'file<script>alert(1)</script>',
      'file|rm -rf /'
    ];

    for (const file of maliciousFiles) {
      const response = await request(app)
        .get('/api/file-diff')
        .query({ file })
        .expect(400);
    }
  });
});
```

### **Rate Limiting Test Pattern**

```javascript
test('Should apply rate limits', async () => {
  const promises = Array.from({length: 15}, () =>
    request(app).post('/api/export-for-ai').send({})
  );

  const responses = await Promise.all(promises);
  const rateLimitedCount = responses.filter(r => r.status === 429).length;
  expect(rateLimitedCount).toBeGreaterThan(0);
});
```

## 📱 **Multi-Platform Patterns**

### **CLI Interface Pattern**

```javascript
// Command parsing with validation
function parseArgs() {
  // Parse commands: start, quick, help
  // Validate port numbers
  // Handle options: --port, --open
}

// Process management
function startServer(port, openBrowser) {
  const serverProcess = spawn('node', [serverPath]);
  // Handle graceful shutdown
  // Auto-open browser if requested
}
```

### **VSCode Extension Pattern**

```typescript
export function activate(context: vscode.ExtensionContext) {
  // Register providers
  const stagedFilesProvider = new StagedFilesProvider(gitService);
  const reviewWebviewProvider = new ReviewWebviewProvider();

  // Register commands
  context.subscriptions.push(
    vscode.commands.registerCommand('aiCodeReview.exportForAI', exportCommand)
  );
}
```

## 🔧 **Configuration Patterns**

### **Environment-Based Configuration**

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
  },
  rateLimit: {
    windowMs: 15 * 60 * 1000,
    max: 50,
    exportMax: 10
  }
};
```

### **Development vs Production Pattern**

```javascript
// Security behavior changes based on environment
const isLocalhost = ip === '::1' || ip === '127.0.0.1';
const isDevelopment = process.env.NODE_ENV !== 'production';
const isTesting = process.env.NODE_ENV === 'test';

if (isLocalhost && isDevelopment && !isTesting) {
  // Bypass rate limiting for development
  return next();
}
```

## 💡 **Key Design Principles**

1. **Security First** - Every input validated, every command allowlisted
2. **Progressive Enhancement** - Works without JavaScript, better with it
3. **Memory Management** - Automatic cleanup and size limits
4. **Error Resilience** - Graceful degradation and recovery
5. **Cross-Platform** - Works on Windows, macOS, Linux
6. **AI-Optimized** - Structured output for modern AI assistants

These patterns ensure the codebase remains maintainable, secure, and scalable while providing an excellent user experience across all supported platforms.
