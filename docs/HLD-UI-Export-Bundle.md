# High-Level Design (HLD)

## Standalone HTML Bundle Export for Human Code Review

**Document Version:** 1.0
**Date:** October 14, 2025
**Project:** AI Visual Code Review - UI Export Bundle Feature
**Status:** Design Phase

---

## 1. System Overview

### 1.1 Purpose

This document describes the high-level architecture for implementing a standalone HTML bundle export feature that enables offline, shareable code reviews with full interactivity and commenting capabilities.

### 1.2 Design Goals

- **Self-Contained**: Single HTML file with all dependencies embedded
- **Zero Server Dependency**: Works without any backend infrastructure
- **Full Feature Parity**: Matches web interface capabilities
- **Cross-Browser Compatible**: Works on all modern browsers
- **Offline First**: All functionality available without internet

### 1.3 Design Principles

- **Progressive Enhancement**: Core functionality works without JavaScript
- **Security First**: No external resource loading, XSS protection
- **Performance Optimized**: Lazy loading, virtual scrolling for large diffs
- **Maintainability**: Modular code structure, clear separation of concerns

---

## 2. System Architecture

### 2.1 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     CLI/Web Interface                        │
│  (User initiates bundle generation)                          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Bundle Generator Service                         │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  1. Data Collection Module                          │   │
│  │     - Git diff fetching                             │   │
│  │     - File metadata extraction                      │   │
│  │     - Syntax highlighting preparation               │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  2. Template Engine                                 │   │
│  │     - HTML template processing                      │   │
│  │     - CSS inlining                                  │   │
│  │     - JavaScript bundling                           │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  3. Data Embedding Module                           │   │
│  │     - JSON serialization                            │   │
│  │     - Base64 encoding (if needed)                   │   │
│  │     - Data injection into HTML                      │   │
│  └─────────────────────────────────────────────────────┘   │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  4. Minification & Optimization                     │   │
│  │     - CSS minification                              │   │
│  │     - JavaScript minification                       │   │
│  │     - HTML compression                              │   │
│  └─────────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   Generated Bundle.html                      │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  HTML Structure                                       │  │
│  │  - Document metadata                                  │  │
│  │  - Inline CSS (minified)                             │  │
│  │  - Inline JavaScript (minified)                      │  │
│  │  - Embedded review data (JSON)                       │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    Browser Runtime                           │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Frontend Application (Vanilla JS)                    │  │
│  │  ├─ Review Panel Component                           │  │
│  │  ├─ Diff Viewer Component                            │  │
│  │  ├─ Comment Manager Component                        │  │
│  │  ├─ Export Controller                                │  │
│  │  └─ Local Storage Manager                            │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 Component Interaction Flow

```
User Opens Bundle
    ↓
Browser Loads HTML
    ↓
Parse Embedded JSON Data
    ↓
Initialize Application State
    ↓
Render File Tree → Display Diffs → Enable Comments
    ↓
User Interactions (Add/Edit Comments)
    ↓
Save to LocalStorage
    ↓
Export Comments (JSON/Markdown)
```

---

## 3. Component Design

### 3.1 Bundle Generator Service

**Responsibility**: Generate self-contained HTML bundle from staged changes

**Sub-Components:**

#### 3.1.1 Data Collection Module

```javascript
// Pseudo-code
class DataCollector {
  async collectReviewData() {
    return {
      metadata: this.getRepoMetadata(),
      files: await this.getStagedFiles(),
      diffs: await this.generateDiffs(),
      stats: this.calculateStats()
    };
  }

  getRepoMetadata() {
    // Repository name, branch, commit hash, timestamp
  }

  async getStagedFiles() {
    // Use existing diffService.js
  }

  async generateDiffs() {
    // Generate unified diffs with line numbers
  }

  calculateStats() {
    // File count, additions, deletions
  }
}
```

#### 3.1.2 Template Engine

```javascript
class TemplateEngine {
  constructor() {
    this.htmlTemplate = this.loadTemplate('bundle-template.html');
    this.cssTemplate = this.loadTemplate('bundle-styles.css');
    this.jsTemplate = this.loadTemplate('bundle-app.js');
  }

  generateBundle(reviewData) {
    const html = this.injectData(this.htmlTemplate, reviewData);
    const css = this.minifyCSS(this.cssTemplate);
    const js = this.minifyJS(this.jsTemplate);

    return this.combineAssets(html, css, js);
  }

  injectData(template, data) {
    // Replace placeholders with actual data
  }

  combineAssets(html, css, js) {
    // Inline CSS and JS into HTML
  }
}
```

#### 3.1.3 Data Embedding Module

```javascript
class DataEmbedder {
  embedData(html, reviewData) {
    const serialized = JSON.stringify(reviewData);
    const encoded = this.compressIfNeeded(serialized);

    return html.replace(
      '<!-- DATA_PLACEHOLDER -->',
      `<script type="application/json" id="review-data">${encoded}</script>`
    );
  }

  compressIfNeeded(data) {
    // Optional: Use compression for large datasets
    if (data.length > 1000000) {
      return this.compress(data);
    }
    return data;
  }
}
```

#### 3.1.4 Optimization Module

```javascript
class BundleOptimizer {
  optimize(bundle) {
    return {
      html: this.minifyHTML(bundle.html),
      size: this.calculateSize(bundle),
      warnings: this.checkSize(bundle)
    };
  }

  minifyHTML(html) {
    // Remove unnecessary whitespace, comments
  }

  checkSize(bundle) {
    // Warn if bundle > 5MB
  }
}
```

### 3.2 Frontend Application (Embedded in Bundle)

**Responsibility**: Provide interactive review interface in browser

**Architecture Pattern**: Component-Based (Vanilla JavaScript)

#### 3.2.1 Application Bootstrap

```javascript
// bundle-app.js structure
class ReviewApp {
  constructor() {
    this.state = new AppState();
    this.storage = new LocalStorageManager();
    this.components = this.initializeComponents();
  }

  async init() {
    // Load embedded data
    this.reviewData = this.loadReviewData();

    // Restore comments from localStorage
    this.comments = this.storage.loadComments();

    // Initialize UI
    this.render();

    // Attach event listeners
    this.attachEventHandlers();
  }

  loadReviewData() {
    const dataElement = document.getElementById('review-data');
    return JSON.parse(dataElement.textContent);
  }
}
```

#### 3.2.2 State Management

```javascript
class AppState {
  constructor() {
    this.state = {
      selectedFile: null,
      expandedFiles: new Set(),
      comments: new Map(),
      filters: {
        search: '',
        showCommentedOnly: false
      }
    };
    this.listeners = new Set();
  }

  setState(updates) {
    Object.assign(this.state, updates);
    this.notifyListeners();
  }

  subscribe(listener) {
    this.listeners.add(listener);
  }

  notifyListeners() {
    this.listeners.forEach(fn => fn(this.state));
  }
}
```

#### 3.2.3 UI Components

**File Tree Component:**

```javascript
class FileTreeComponent {
  constructor(container, state) {
    this.container = container;
    this.state = state;
  }

  render(files) {
    const tree = this.buildTree(files);
    this.container.innerHTML = this.generateHTML(tree);
    this.attachHandlers();
  }

  buildTree(files) {
    // Group files by directory
  }

  generateHTML(tree) {
    // Create nested file tree HTML
  }
}
```

**Diff Viewer Component:**

```javascript
class DiffViewerComponent {
  constructor(container, state) {
    this.container = container;
    this.state = state;
    this.virtualScroll = new VirtualScrollManager();
  }

  render(file) {
    const diff = this.parseDiff(file.diff);
    const html = this.generateDiffHTML(diff);
    this.container.innerHTML = html;
    this.applySyntaxHighlighting(file.language);
  }

  parseDiff(diffText) {
    // Parse unified diff format
  }

  generateDiffHTML(diff) {
    // Create side-by-side or inline diff view
  }

  applySyntaxHighlighting(language) {
    // Apply syntax highlighting (lightweight library or custom)
  }
}
```

**Comment Manager Component:**

```javascript
class CommentManagerComponent {
  constructor(storage) {
    this.storage = storage;
    this.comments = new Map();
  }

  addComment(fileId, lineNumber, commentData) {
    const key = `${fileId}:${lineNumber}`;
    const comment = {
      id: this.generateId(),
      author: commentData.author || 'Anonymous',
      text: commentData.text,
      timestamp: new Date().toISOString(),
      line: lineNumber,
      file: fileId
    };

    this.comments.set(key, comment);
    this.storage.saveComments(this.comments);
    this.renderComment(comment);
  }

  editComment(commentId, newText) {
    // Update existing comment
  }

  deleteComment(commentId) {
    // Remove comment
  }

  renderComment(comment) {
    // Display comment inline
  }
}
```

**Export Controller:**

```javascript
class ExportController {
  exportToJSON(comments, metadata) {
    const exportData = {
      version: '1.0',
      generated: new Date().toISOString(),
      repository: metadata.repo,
      commit: metadata.commit,
      comments: Array.from(comments.values())
    };

    this.downloadFile(
      'review-comments.json',
      JSON.stringify(exportData, null, 2),
      'application/json'
    );
  }

  exportToMarkdown(comments, metadata) {
    const markdown = this.generateMarkdown(comments, metadata);
    this.downloadFile(
      'review-comments.md',
      markdown,
      'text/markdown'
    );
  }

  downloadFile(filename, content, mimeType) {
    const blob = new Blob([content], { type: mimeType });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.click();
    URL.revokeObjectURL(url);
  }
}
```

#### 3.2.4 Local Storage Manager

```javascript
class LocalStorageManager {
  constructor() {
    this.storageKey = 'ai-review-comments';
    this.metadataKey = 'ai-review-metadata';
  }

  saveComments(comments) {
    const data = {
      comments: Array.from(comments.entries()),
      lastModified: new Date().toISOString()
    };
    localStorage.setItem(this.storageKey, JSON.stringify(data));
  }

  loadComments() {
    const data = localStorage.getItem(this.storageKey);
    if (!data) return new Map();

    const parsed = JSON.parse(data);
    return new Map(parsed.comments);
  }

  clearComments() {
    localStorage.removeItem(this.storageKey);
  }

  exportStorage() {
    // Export all localStorage data for backup
  }
}
```

---

## 4. Data Model

### 4.1 Embedded Review Data Structure

```javascript
{
  "version": "1.0",
  "metadata": {
    "repository": "ai-visual-code-review",
    "branch": "main",
    "commit": "abc123...",
    "author": "developer@example.com",
    "generated": "2025-10-14T10:00:00Z",
    "title": "Feature: Add authentication",
    "description": "Implementing OAuth2 authentication"
  },
  "stats": {
    "filesChanged": 15,
    "additions": 342,
    "deletions": 87,
    "totalLines": 4521
  },
  "files": [
    {
      "id": "src_auth_oauth.js",
      "path": "src/auth/oauth.js",
      "status": "modified",
      "language": "javascript",
      "type": "application/javascript",
      "lines": {
        "added": 45,
        "deleted": 12,
        "total": 156
      },
      "diff": {
        "format": "unified",
        "hunks": [
          {
            "oldStart": 23,
            "oldLines": 10,
            "newStart": 23,
            "newLines": 15,
            "lines": [
              {
                "type": "context",
                "oldNumber": 23,
                "newNumber": 23,
                "content": "function authenticate(user) {"
              },
              {
                "type": "addition",
                "oldNumber": null,
                "newNumber": 24,
                "content": "  if (!user.email) throw new Error('Email required');"
              },
              // ... more lines
            ]
          }
        ]
      }
    }
  ]
}
```

### 4.2 Comment Data Structure

```javascript
{
  "version": "1.0",
  "reviewId": "abc123...",  // Links to review metadata
  "comments": [
    {
      "id": "comment-uuid-1",
      "fileId": "src_auth_oauth.js",
      "filePath": "src/auth/oauth.js",
      "lineNumber": 24,
      "lineType": "addition",  // addition, deletion, context
      "author": {
        "name": "John Doe",
        "email": "john@example.com"
      },
      "timestamp": "2025-10-14T11:30:00Z",
      "content": "Consider adding email validation before throwing error",
      "type": "suggestion",  // suggestion, question, issue, praise
      "status": "open",  // open, resolved, acknowledged
      "thread": [  // For replies (future enhancement)
        {
          "id": "reply-uuid-1",
          "author": {...},
          "timestamp": "...",
          "content": "Good point, will add validation"
        }
      ]
    }
  ]
}
```

---

## 5. Technology Stack

### 5.1 Bundle Generation (Node.js)

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Template Engine | String interpolation | HTML/CSS/JS templating |
| Minification | terser (JS), csso (CSS) | Code optimization |
| Diff Generation | diffService.js (existing) | Git diff processing |
| File I/O | Node.js fs module | Read/write operations |

### 5.2 Frontend (Browser)

| Component | Technology | Purpose |
|-----------|-----------|---------|
| Core Framework | Vanilla JavaScript (ES6+) | No external dependencies |
| Syntax Highlighting | Prism.js (embedded) or custom | Code coloring |
| Markdown Rendering | Simple parser or marked.js | Comment formatting |
| Storage | LocalStorage API | Comment persistence |
| UI Components | Custom web components | Modular architecture |

### 5.3 Performance Optimizations

| Technique | Implementation | Benefit |
|-----------|---------------|---------|
| Virtual Scrolling | Custom implementation | Handle large diffs |
| Lazy Loading | Intersection Observer | Load diffs on demand |
| Code Splitting | Separate modules | Faster initial load |
| Caching | In-memory cache | Reduce recomputation |

---

## 6. Security Architecture

### 6.1 Content Security Policy

```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'none';
  script-src 'self' 'unsafe-inline';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data:;
  font-src 'self' data:;
  connect-src 'none';
">
```

### 6.2 XSS Prevention

**Input Sanitization:**

```javascript
class SecurityManager {
  sanitizeHTML(input) {
    const div = document.createElement('div');
    div.textContent = input;
    return div.innerHTML;
  }

  sanitizeMarkdown(input) {
    // Allow only safe markdown subset
    return input
      .replace(/<script/gi, '&lt;script')
      .replace(/<iframe/gi, '&lt;iframe')
      .replace(/javascript:/gi, '');
  }
}
```

### 6.3 Data Validation

```javascript
class DataValidator {
  validateReviewData(data) {
    if (!data.version) throw new Error('Invalid data: missing version');
    if (!data.metadata) throw new Error('Invalid data: missing metadata');
    if (!Array.isArray(data.files)) throw new Error('Invalid data: files must be array');

    return true;
  }

  validateComment(comment) {
    const schema = {
      fileId: 'string',
      lineNumber: 'number',
      content: 'string',
      author: 'object'
    };

    return this.matchesSchema(comment, schema);
  }
}
```

---

## 7. Performance Considerations

### 7.1 Bundle Size Optimization

**Target Sizes:**

- HTML structure: <50KB
- CSS (minified): <30KB
- JavaScript (minified): <100KB
- Review data: Variable (1-5MB typical)
- Total bundle: <5MB target

**Optimization Strategies:**

1. Minify all code
2. Remove comments and whitespace
3. Use gzip-friendly patterns
4. Compress large diff blocks
5. Lazy-load syntax highlighting

### 7.2 Runtime Performance

**Initial Load:**

- Parse embedded JSON: <500ms
- Render file tree: <300ms
- Display first file: <200ms
- Total time to interactive: <1.5s

**Interaction Performance:**

- Comment addition: <100ms
- File switching: <200ms
- Export generation: <500ms
- Search/filter: <50ms

### 7.3 Memory Management

```javascript
class MemoryManager {
  constructor() {
    this.cache = new Map();
    this.maxCacheSize = 50; // MB
  }

  cacheView(fileId, renderedHTML) {
    if (this.getCurrentCacheSize() > this.maxCacheSize) {
      this.evictOldest();
    }
    this.cache.set(fileId, {
      html: renderedHTML,
      timestamp: Date.now()
    });
  }

  evictOldest() {
    const oldest = Array.from(this.cache.entries())
      .sort((a, b) => a[1].timestamp - b[1].timestamp)[0];
    this.cache.delete(oldest[0]);
  }
}
```

---

## 8. Error Handling

### 8.1 Generation Errors

```javascript
class BundleGeneratorError extends Error {
  constructor(code, message, details) {
    super(message);
    this.code = code;
    this.details = details;
  }
}

// Error codes
const ErrorCodes = {
  GIT_ERROR: 'GIT_001',
  FILE_TOO_LARGE: 'FILE_002',
  TEMPLATE_ERROR: 'TMPL_001',
  MINIFICATION_ERROR: 'MIN_001',
  IO_ERROR: 'IO_001'
};

// Usage
try {
  const bundle = await generator.generate();
} catch (error) {
  if (error.code === ErrorCodes.FILE_TOO_LARGE) {
    console.warn('Some files excluded due to size');
  } else {
    throw error;
  }
}
```

### 8.2 Runtime Errors

```javascript
class ErrorBoundary {
  constructor(app) {
    this.app = app;
    this.setupGlobalHandlers();
  }

  setupGlobalHandlers() {
    window.addEventListener('error', (event) => {
      this.handleError(event.error);
    });

    window.addEventListener('unhandledrejection', (event) => {
      this.handleError(event.reason);
    });
  }

  handleError(error) {
    console.error('Application error:', error);
    this.showUserFriendlyMessage(error);
    this.logErrorForDebugging(error);
  }

  showUserFriendlyMessage(error) {
    const notification = {
      type: 'error',
      message: 'Something went wrong. Your data is safe.',
      action: 'Reload Page'
    };
    this.app.showNotification(notification);
  }
}
```

---

## 9. Integration Points

### 9.1 CLI Integration

```bash
# New command
ai-review bundle [options]

# Options
--output <file>       # Output filename (default: review-bundle-TIMESTAMP.html)
--include <patterns>  # Include specific files
--exclude <patterns>  # Exclude specific files
--title <string>      # Review title
--description <text>  # Review description
```

### 9.2 Web Interface Integration

```javascript
// Add export button to web UI
<button onclick="generateBundle()">
  📦 Generate Bundle
</button>

function generateBundle() {
  fetch('/api/generate-bundle', {
    method: 'POST',
    body: JSON.stringify({
      files: selectedFiles,
      options: exportOptions
    })
  })
  .then(response => response.blob())
  .then(blob => {
    downloadFile('review-bundle.html', blob);
  });
}
```

---

## 10. Deployment & Distribution

### 10.1 File Structure

```
generated-bundle.html  (Single file, 2-5MB typical)
```

### 10.2 Distribution Methods

1. **Email Attachment**: Direct file sharing
2. **Cloud Storage**: Upload to Dropbox, Google Drive
3. **Internal Network**: Company file server
4. **Version Control**: Check into repository (optional)
5. **Messaging**: Slack, Teams file sharing

### 10.3 Usage Instructions

```
1. Open bundle file in any modern browser
2. Review changes, add comments
3. Export comments when done
4. Share exported comments file back
```

---

## 11. Testing Strategy

### 11.1 Bundle Generation Tests

- [ ] Test with various repository sizes
- [ ] Test with different file types
- [ ] Test with large diffs (>1000 lines)
- [ ] Test with binary files (exclusion)
- [ ] Test bundle size limits
- [ ] Test generation performance

### 11.2 Browser Compatibility Tests

- [ ] Chrome 90+ (Windows, macOS, Linux)
- [ ] Firefox 88+ (Windows, macOS, Linux)
- [ ] Safari 14+ (macOS, iOS)
- [ ] Edge 90+ (Windows)
- [ ] Mobile browsers (iOS Safari, Chrome)

### 11.3 Functional Tests

- [ ] File tree navigation
- [ ] Diff viewing (side-by-side, inline)
- [ ] Comment CRUD operations
- [ ] Comment persistence (localStorage)
- [ ] Export functionality (JSON, Markdown)
- [ ] Search and filter
- [ ] Offline functionality

---

## 12. Monitoring & Metrics

### 12.1 Generation Metrics

- Bundle generation time
- Bundle size distribution
- Error rate during generation
- Most common file types
- Average files per bundle

### 12.2 Usage Metrics (Optional, Opt-In)

- Bundle load time
- Time to interactive
- Comment count distribution
- Export frequency
- Browser distribution

---

## 13. Future Enhancements

### 13.1 Phase 2 Features

- Comment threading (replies)
- @mentions in comments
- Comment status workflow (open/resolved)
- Syntax highlighting themes
- Diff algorithm options (myers, patience)

### 13.2 Phase 3 Features

- Multiple bundle merging
- Collaborative editing (conflict resolution)
- Custom review templates
- Integration with CI/CD
- Browser extension for easier opening

---

## Document Control

- **Version**: 1.0
- **Last Updated**: October 14, 2025
- **Next Review**: November 14, 2025
- **Owner**: AI Code Review System Team
- **Approved By**: Technical Lead (Pending)
