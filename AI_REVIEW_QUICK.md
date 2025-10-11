# 🔍 Code Review - Sat Oct 11 06:07:33 IST 2025

**Project:** AI Visual Code Review

## 📊 Change Summary

```
 .gitignore                         |    2 +-
 package.json                       |   11 +-
 public/index.html                  | 1608 ++++++++++++++++++
 vscode-extension/package-lock.json | 3245 ++++++++++++++++++++++++++++++++++++
 vscode-extension/package.json      |  178 ++
 vscode-extension/src/extension.ts  |  302 ++++
 vscode-extension/tsconfig.json     |   17 +
 7 files changed, 5361 insertions(+), 2 deletions(-)
```

## 📝 Files Changed


### 📄 `.gitignore`

**Type:** Source File

```diff
diff --git c/.gitignore i/.gitignore
index ae4b881..ba61eae 100644
--- c/.gitignore
+++ i/.gitignore
@@ -74,7 +74,7 @@ dist
 
 # Gatsby files
 .cache/
-public
+# public - Removed: needed for web interface
 
 # Vuepress build output
 .vuepress/dist
```


### 📄 `package.json`

**Type:** Configuration/Data

```diff
diff --git c/package.json i/package.json
index 7d03487..36de7ea 100644
--- c/package.json
+++ i/package.json
@@ -1,6 +1,6 @@
 {
   "name": "ai-visual-code-review",
-  "version": "1.0.2",
+  "version": "1.0.3",
   "description": "A comprehensive visual code review system with AI integration for any Git repository",
   "main": "server.js",
   "bin": {
@@ -58,6 +58,15 @@
       "**/test/**/*.test.js"
     ]
   },
+  "files": [
+    "bin/**",
+    "scripts/**",
+    "services/**",
+    "public/**",
+    "server.js",
+    "README.md",
+    "LICENSE"
+  ],
   "engines": {
     "node": ">=14.0.0"
   },
```


### 📄 `public/index.html`

**Type:** HTML Template

```diff
diff --git c/public/index.html i/public/index.html
new file mode 100644
index 0000000..3bd82fc
--- /dev/null
+++ i/public/index.html
@@ -0,0 +1,1608 @@
+<!DOCTYPE html>
+<html lang="en">
+<head>
+    <meta charset="UTF-8">
+    <meta name="viewport" content="width=device-width, initial-scale=1.0">
+    <title>🔍 Visual Code Review - SDE2 PrepOps</title>
+    <style>
+        * {
+            margin: 0;
+            padding: 0;
+            box-sizing: border-box;
+        }
+
+        body {
+            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', sans-serif;
+            background: #0d1117;
+            color: #c9d1d9;
+            line-height: 1.5;
+        }
+
+        .header {
+            background: #161b22;
+            padding: 20px;
+            border-bottom: 1px solid #30363d;
+            position: sticky;
+            top: 0;
+            z-index: 100;
+        }
+
+        .header-content {
+            max-width: 1200px;
+            margin: 0 auto;
+            display: flex;
+            justify-content: space-between;
+            align-items: center;
+        }
+
+        .logo {
+            display: flex;
+            align-items: center;
+            gap: 12px;
+        }
+
+        .logo h1 {
+            font-size: 24px;
+            font-weight: 700;
+            color: #f0f6fc;
+        }
+
+        .container {
+            max-width: 1200px;
+            margin: 0 auto;
+            padding: 20px;
+        }
+
+        .status-bar {
+            background: #0d1117;
+            border: 1px solid #30363d;
+            border-radius: 8px;
+            padding: 16px;
+            margin-bottom: 20px;
+            display: flex;
+            justify-content: space-between;
+            align-items: center;
+        }
+
+        .stats {
+            background: #0d1117;
+            padding: 16px;
+            border: 1px solid #30363d;
+            border-radius: 8px;
+            margin-bottom: 20px;
+        }
+
+        .stats h3 {
+            color: #f0f6fc;
+            margin-bottom: 12px;
+            font-size: 18px;
+        }
+
+        .stats pre {
+            background: #161b22;
+            padding: 12px;
+            border-radius: 6px;
+            overflow-x: auto;
+            font-size: 13px;
+            color: #7d8590;
+        }
+
+        .file-list {
+            display: flex;
+            flex-direction: column;
+            gap: 12px;
+            margin: 20px 0;
+        }
+
+        .file-item {
+            background: #161b22;
+            border: 1px solid #30363d;
+            border-radius: 8px;
+            overflow: hidden;
+            transition: all 0.2s ease;
+            position: relative;
+        }
+
+        .file-item:hover {
+            border-color: #58a6ff;
+            box-shadow: 0 0 0 2px rgba(88, 166, 255, 0.1);
+        }
+
+        .file-header {
+            padding: 16px;
+            font-weight: 600;
+            color: #f0f6fc;
+            display: flex;
+            justify-content: space-between;
+            align-items: center;
+            cursor: pointer;
+            user-select: none;
+        }
+
+        .file-header:hover {
+            background: #21262d;
+        }
+
+        .file-path {
+            display: flex;
+            align-items: center;
+            gap: 8px;
+            font-family: 'SF Mono', 'Monaco', 'Consolas', monospace;
+        }
+
+        .file-diff {
+            display: none;
+            background: #0d1117;
+            border-top: 1px solid #30363d;
+            max-height: 600px;
+            overflow-y: auto;
+        }
+
+        .file-diff.active {
+            display: block;
+            animation: slideDown 0.2s ease-out;
+        }
+
+        @keyframes slideDown {
+            from { opacity: 0; transform: translateY(-10px); }
+            to { opacity: 1; transform: translateY(0); }
+        }
+
+        .diff-line {
+            font-family: 'SF Mono', 'Monaco', 'Consolas', monospace;
+            font-size: 13px;
+            padding: 2px 16px;
+            border-left: 4px solid transparent;
+            white-space: pre;
+            overflow-x: auto;
+        }
+
+        .diff-added {
+            background: rgba(46, 160, 67, 0.15);
+            border-left-color: #2ea043;
+            color: #aff5b4;
+        }
+
+        .diff-removed {
+            background: rgba(248, 81, 73, 0.15);
+            border-left-color: #f85149;
+            color: #ffdcd7;
+        }
+
+        .diff-context {
+            color: #8b949e;
+            background: rgba(255, 255, 255, 0.02);
+        }
+
+        .diff-header {
+            background: #161b22;
+            color: #7d8590;
+            padding: 8px 16px;
+            font-weight: 600;
+            border-bottom: 1px solid #30363d;
+        }
+
+        .export-btn {
+            background: linear-gradient(135deg, #2ea043, #238636);
+            color: white;
+            border: none;
+            padding: 12px 20px;
+            border-radius: 8px;
+            cursor: pointer;
+            font-weight: 600;
+            font-size: 14px;
+            transition: all 0.2s ease;
+            display: flex;
+            align-items: center;
+            gap: 8px;
+        }
+
+        .export-btn:hover {
+            background: linear-gradient(135deg, #238636, #2ea043);
+            transform: translateY(-1px);
+            box-shadow: 0 4px 12px rgba(46, 160, 67, 0.3);
+        }
+
+        .export-btn:active {
+            transform: translateY(0);
+        }
+
+        .badge {
+            background: #1f6feb;
+            color: white;
+            padding: 4px 12px;
+            border-radius: 16px;
+            font-size: 12px;
+            font-weight: 600;
+            display: inline-flex;
+            align-items: center;
+            gap: 4px;
+        }
+
+        .badge.modified {
+            background: #ff8c00;
+        }
+
+        .badge.added {
+            background: #2ea043;
+        }
+
+        .badge.deleted {
+            background: #f85149;
+        }
+
+        .empty-state {
+            text-align: center;
+            padding: 60px 20px;
+            color: #7d8590;
+        }
+
+        .empty-state .icon {
+            font-size: 64px;
+            margin-bottom: 16px;
+        }
+
+        .empty-state h3 {
+            color: #f0f6fc;
+            font-size: 20px;
+            margin-bottom: 8px;
+        }
+
+        .loading {
+            display: flex;
+            align-items: center;
+            justify-content: center;
+            padding: 40px;
+            gap: 12px;
+        }
+
+        .spinner {
+            width: 20px;
+            height: 20px;
+            border: 2px solid #30363d;
+            border-top: 2px solid #58a6ff;
+            border-radius: 50%;
+            animation: spin 1s linear infinite;
+        }
+
+        @keyframes spin {
+            0% { transform: rotate(0deg); }
+            100% { transform: rotate(360deg); }
+        }
+
+        .success-message {
+            background: rgba(46, 160, 67, 0.15);
+            border: 1px solid #2ea043;
+            border-radius: 8px;
+            padding: 16px;
+            margin: 20px 0;
+            color: #aff5b4;
+        }
+
+        .error-message {
+            background: rgba(248, 81, 73, 0.15);
+            border: 1px solid #f85149;
+            border-radius: 8px;
+            padding: 16px;
+            margin: 20px 0;
+            color: #ffdcd7;
+        }
+
+        .file-stats {
+            font-size: 12px;
+            color: #7d8590;
+            display: flex;
+            gap: 16px;
+        }
+
+        .expand-icon {
+            transition: transform 0.2s ease;
+        }
+
+        .expand-icon.rotated {
+            transform: rotate(90deg);
+        }
+
+        .comment-btn {
+            background: #21262d;
+            border: 1px solid #30363d;
+            border-radius: 6px;
+            padding: 6px 8px;
+            cursor: pointer;
+            transition: all 0.2s ease;
+            color: #7d8590;
+            font-size: 14px;
+        }
+
+        .comment-btn:hover {
+            background: #30363d;
+            border-color: #58a6ff;
+            color: #58a6ff;
+        }
+
+        .comment-btn.has-comment {
+            background: #1f6feb;
+            color: white;
+            border-color: #1f6feb;
+        }
+
+        /* Modal Styles */
+        .modal-overlay {
+            position: fixed;
+            top: 0;
+            left: 0;
+            right: 0;
+            bottom: 0;
+            background: rgba(0, 0, 0, 0.8);
+            display: none;
+            align-items: center;
+            justify-content: center;
+            z-index: 1000;
+        }
+
+        .modal-overlay.active {
+            display: flex;
+            animation: fadeIn 0.2s ease-out;
+        }
+
+        @keyframes fadeIn {
+            from { opacity: 0; }
+            to { opacity: 1; }
+        }
+
+        .modal {
+            background: #161b22;
+            border: 1px solid #30363d;
+            border-radius: 12px;
+            padding: 24px;
+            max-width: 600px;
+            width: 90%;
+            max-height: 80vh;
+            overflow-y: auto;
+            animation: slideUp 0.3s ease-out;
+        }
+
+        @keyframes slideUp {
+            from { opacity: 0; transform: translateY(20px); }
+            to { opacity: 1; transform: translateY(0); }
+        }
+
+        .modal h3 {
+            color: #f0f6fc;
+            font-size: 18px;
+            margin-bottom: 16px;
+            display: flex;
+            align-items: center;
+            gap: 8px;
+        }
+
+        .comment-textarea {
+            width: 100%;
+            background: #0d1117;
+            border: 1px solid #30363d;
+            border-radius: 8px;
+            padding: 12px;
+            color: #c9d1d9;
+            font-family: 'SF Mono', 'Monaco', 'Consolas', monospace;
+            font-size: 13px;
+            line-height: 1.5;
+            resize: vertical;
+            min-height: 120px;
+        }
+
+        .comment-textarea:focus {
+            outline: none;
+            border-color: #58a6ff;
+            box-shadow: 0 0 0 2px rgba(88, 166, 255, 0.1);
+        }
+
+        .comment-templates {
+            margin-bottom: 16px;
+        }
+
+        .comment-templates h4 {
+            color: #7d8590;
+            font-size: 14px;
+            margin-bottom: 8px;
+        }
+
+        .template-buttons {
+            display: flex;
+            flex-wrap: wrap;
+            gap: 8px;
+        }
+
+        .template-btn {
+            background: #21262d;
+            border: 1px solid #30363d;
+            border-radius: 6px;
+            padding: 4px 8px;
+            cursor: pointer;
+            font-size: 12px;
+            color: #7d8590;
+            transition: all 0.2s ease;
+        }
+
+        .template-btn:hover {
+            background: #30363d;
+            color: #58a6ff;
+        }
+
+        .modal-actions {
+            display: flex;
+            justify-content: flex-end;
+            gap: 12px;
+            margin-top: 20px;
+        }
+
+        .modal-btn {
+            padding: 8px 16px;
+            border-radius: 6px;
+            cursor: pointer;
+            font-weight: 600;
+            font-size: 14px;
+            transition: all 0.2s ease;
+            border: none;
+        }
+
+        .modal-btn.primary {
+            background: #238636;
+            color: white;
+        }
+
+        .modal-btn.primary:hover {
+            background: #2ea043;
+        }
+
+        .modal-btn.secondary {
+            background: #30363d;
+            color: #7d8590;
+        }
+
+        .modal-btn.secondary:hover {
+            background: #21262d;
+            color: #c9d1d9;
+        }
+
+        .comment-display {
+            background: rgba(88, 166, 255, 0.1);
+            border: 1px solid #58a6ff;
+            border-radius: 6px;
+            padding: 8px 12px;
+            margin-top: 8px;
+            font-size: 12px;
+            color: #c9d1d9;
+            white-space: pre-wrap;
+        }
+
+        /* GitHub-style line-by-line diff */
+        .diff-line-container {
+            display: flex;
+            align-items: stretch;
+            border-bottom: 1px solid #21262d;
+            position: relative;
+        }
+
+        .diff-line-container:hover {
+            background: rgba(255, 255, 255, 0.03);
+        }
+
+        .diff-line-container:hover .add-comment-btn {
+            opacity: 1;
+        }
+
+        .line-numbers {
+            display: flex;
+            align-items: center;
+            background: #161b22;
+            padding: 4px 8px;
+            border-right: 1px solid #30363d;
+            min-width: 120px;
+            position: relative;
+        }
+
+        .old-line-num, .new-line-num {
+            font-family: 'SF Mono', 'Monaco', 'Consolas', monospace;
+            font-size: 12px;
+            color: #656d76;
+            width: 35px;
+            text-align: right;
+            user-select: none;
+        }
+
+        .add-comment-btn {
+            background: transparent;
+            border: none;
+            color: #656d76;
+            cursor: pointer;
+            opacity: 0;
+            transition: all 0.2s ease;
+            padding: 2px;
+            margin-left: 4px;
+            font-size: 12px;
+        }
+
+        .add-comment-btn:hover {
+            color: #58a6ff;
+            background: rgba(88, 166, 255, 0.1);
+            border-radius: 3px;
+        }
+
+        .line-content {
+            flex: 1;
+            padding: 4px 8px;
+            font-family: 'SF Mono', 'Monaco', 'Consolas', monospace;
+            font-size: 12px;
+            overflow-x: auto;
+        }
+
+        .line-content code {
+            background: none;
+            color: inherit;
+            padding: 0;
+            white-space: pre;
+        }
+
+        .diff-line-container.diff-added {
+            background: rgba(46, 160, 67, 0.15);
+        }
+
+        .diff-line-container.diff-removed {
+            background: rgba(248, 81, 73, 0.15);
+        }
+
+        .diff-line-container.diff-context {
+            background: transparent;
+        }
+
+        .diff-line-container.diff-added .line-numbers {
+            background: rgba(46, 160, 67, 0.2);
+            border-left: 3px solid #2ea043;
+        }
+
+        .diff-line-container.diff-removed .line-numbers {
+            background: rgba(248, 81, 73, 0.2);
+            border-left: 3px solid #f85149;
+        }
+
+        .line-comment {
+            background: #fff8c5;
+            border: 1px solid #d1cc5d;
+            border-radius: 6px;
+            padding: 8px 12px;
+            margin: 4px 8px 8px 128px;
+            color: #1f2328;
+            font-size: 12px;
+            position: relative;
+        }
+
+        .line-comment::before {
+            content: '';
+            position: absolute;
+            top: -8px;
+            left: 16px;
+            width: 0;
+            height: 0;
+            border-left: 8px solid transparent;
+            border-right: 8px solid transparent;
+            border-bottom: 8px solid #d1cc5d;
+        }
+
+        .line-comment.line-comment-visible {
+            display: block;
+            animation: slideInComment 0.3s ease-out;
+        }
+
+        @keyframes slideInComment {
+            from { opacity: 0; transform: translateY(-10px); }
+            to { opacity: 1; transform: translateY(0); }
+        }
+
+        .has-line-comment {
+            background: rgba(255, 212, 59, 0.1) !important;
+            border-left: 3px solid #ffd43b !important;
+        }
+    </style>
+</head>
+<body>
+    <div class="header">
+        <div class="header-content">
+            <div class="logo">
+                <span style="font-size: 28px;">🔍</span>
+                <h1>Visual Code Review</h1>
+                <span style="color: #7d8590; font-size: 14px;">SDE2 PrepOps</span>
+            </div>
+            <div style="display: flex; gap: 12px;">
+                <button class="export-btn" onclick="exportForAI()" id="exportBtn">
+                    <span>📤</span>
+                    Export for AI Review
+                </button>
+                <button class="export-btn" style="background: linear-gradient(135deg, #1f6feb, #58a6ff);" onclick="exportIndividualReviews()" id="exportIndividualBtn">
+                    <span>📁</span>
+                    Export Individual Files
+                </button>
+            </div>
+        </div>
+    </div>
+
+    <div class="container">
+        <div class="status-bar">
+            <div>
+                <strong style="color: #f0f6fc;">Repository Status</strong>
+                <span id="statusText" style="color: #7d8590; margin-left: 12px;">Checking...</span>
+            </div>
+            <div style="font-size: 12px; color: #7d8590;" id="timestamp">
+                Loading...
+            </div>
+        </div>
+
+        <div class="stats" id="stats">
+            <div class="loading">
+                <div class="spinner"></div>
+                <span>Loading change summary...</span>
+            </div>
+        </div>
+
+        <div class="file-list" id="fileList">
+            <div class="loading">
+                <div class="spinner"></div>
+                <span>Loading staged files...</span>
+            </div>
+        </div>
+    </div>
+
+    <!-- Comment Modal -->
+    <div class="modal-overlay" id="commentModal" onclick="closeCommentModal(event)">
+        <div class="modal" onclick="event.stopPropagation()">
+            <h3>
+                <span>💭</span>
+                Add Comment
+                <span id="modalFileName" style="color: #7d8590; font-size: 14px; font-weight: normal;"></span>
+            </h3>
+
+            <div class="comment-templates">
+                <h4>💡 Quick Templates:</h4>
+                <div class="template-buttons">
+                    <button class="template-btn" onclick="insertTemplate('🐛 Bug: ')">🐛 Bug</button>
+                    <button class="template-btn" onclick="insertTemplate('⚠️ Warning: ')">⚠️ Warning</button>
+                    <button class="template-btn" onclick="insertTemplate('💡 Suggestion: ')">💡 Suggestion</button>
+                    <button class="template-btn" onclick="insertTemplate('❓ Question: ')">❓ Question</button>
+                    <button class="template-btn" onclick="insertTemplate('🔍 Review: ')">🔍 Review</button>
+                    <button class="template-btn" onclick="insertTemplate('✅ Approve: ')">✅ Approve</button>
+                    <button class="template-btn" onclick="insertTemplate('🚀 Performance: ')">🚀 Performance</button>
+                    <button class="template-btn" onclick="insertTemplate('🔒 Security: ')">🔒 Security</button>
+                </div>
+            </div>
+
+            <textarea
+                id="commentTextarea"
+                class="comment-textarea"
+                placeholder="Add your review comments, questions, or suggestions for this file..."
+            ></textarea>
+
+            <div class="modal-actions">
+                <button class="modal-btn secondary" onclick="closeCommentModal()">Cancel</button>
+                <button class="modal-btn primary" onclick="saveComment()">💾 Save Comment</button>
+            </div>
+        </div>
+    </div>
+
+    <script>
+        // Global state variables (missing declarations causing export button issues)
+        let allDiffs = {};
+        let allParsedDiffs = {};
+        let fileComments = {};
+        let lineComments = {};
+        let selectedFiles = new Set();
+        let currentCommentFile = '';
+        let currentCommentFileId = '';
+        let currentLineId = '';
+        let currentLineNumber = 0;
+
+        // Enhanced memory management
+        class MemoryManager {
+            constructor() {
+                this.maxCacheSize = 50;
+                this.cleanupInterval = 300000; // 5 minutes
+                this.startCleanupTimer();
+            }
+
+            startCleanupTimer() {
+                setInterval(() => {
+                    this.cleanup();
+                }, this.cleanupInterval);
+            }
+
+            cleanup() {
+                console.log('🧹 Running memory cleanup...');
+
+                // Clean diff cache if too large
+                if (Object.keys(allDiffs).length > this.maxCacheSize) {
+                    const keys = Object.keys(allDiffs);
+                    const keysToRemove = keys.slice(0, keys.length - this.maxCacheSize);
+                    keysToRemove.forEach(key => {
+                        delete allDiffs[key];
+                        delete allParsedDiffs[key];
+                    });
+                    console.log(`🗑️ Cleaned ${keysToRemove.length} cached diffs`);
+                }
+
+                // Clean up DOM nodes that might be detached
+                this.cleanupDetachedNodes();
+            }
+
+            cleanupDetachedNodes() {
+                // Remove any orphaned event listeners or references
+                const commentDivs = document.querySelectorAll('.line-comment');
+                commentDivs.forEach(div => {
+                    if (!div.parentNode) {
+                        // This is an orphaned node, clean it up
+                        div.remove();
+                    }
+                });
+            }
+        }
+
+        // Enhanced state management with memory limits
+        const state = {
+            allDiffs: new Map(),
+            allParsedDiffs: new Map(),
+            fileComments: new Map(),
+            lineComments: new Map(),
+            selectedFiles: new Set(),
+            currentCommentFile: '',
+            currentCommentFileId: '',
+            currentLineId: '',
+            currentLineNumber: 0,
+            loadingStates: new Map(),
+
+            // Memory management methods
+            addDiff(file, diff, parsedDiff) {
+                this.allDiffs.set(file, diff);
+                this.allParsedDiffs.set(file, parsedDiff);
+
+                // Limit cache size
+                if (this.allDiffs.size > 50) {
+                    const firstKey = this.allDiffs.keys().next().value;
+                    this.allDiffs.delete(firstKey);
+                    this.allParsedDiffs.delete(firstKey);
+                }
+            },
+
+            clear() {
+                this.allDiffs.clear();
+                this.allParsedDiffs.clear();
+                this.loadingStates.clear();
+            }
+        };
+
+        // Initialize memory manager
+        const memoryManager = new MemoryManager();
+
+        // Enhanced loading states
+        const LoadingStates = {
+            show(element, message = 'Loading...') {
+                if (!element) return;
+                element.innerHTML = `
+                    <div class="loading">
+                        <div class="spinner"></div>
+                        <span>${message}</span>
+                    </div>
+                `;
+            },
+
+            hide(element) {
+                if (!element) return;
+                const loading = element.querySelector('.loading');
+                if (loading) loading.remove();
+            },
+
+            error(element, message) {
+                if (!element) return;
+                element.innerHTML = `
+                    <div class="error-message">
+                        <span>❌</span>
+                        <span>${message}</span>
+                        <button onclick="location.reload()" style="margin-left: 10px; padding: 4px 8px; background: #f85149; color: white; border: none; border-radius: 4px; cursor: pointer;">
+                            🔄 Retry
+                        </button>
+                    </div>
+                `;
+            }
+        };
+
+        // Enhanced notification system
+        const NotificationSystem = {
+            show(message, type = 'info', duration = 5000) {
+                const notification = document.createElement('div');
+                notification.className = `notification notification-${type}`;
+                notification.style.cssText = `
+                    position: fixed;
+                    top: 20px;
+                    right: 20px;
+                    padding: 12px 16px;
+                    border-radius: 8px;
+                    color: white;
+                    font-weight: 500;
+                    z-index: 10000;
+                    max-width: 400px;
+                    box-shadow: 0 4px 12px rgba(0,0,0,0.3);
+                    animation: slideIn 0.3s ease-out;
+                    cursor: pointer;
+                `;
+
+                const colors = {
+                    info: '#1f6feb',
+                    success: '#2ea043',
+                    warning: '#fb8500',
+                    error: '#f85149'
+                };
+
+                notification.style.backgroundColor = colors[type] || colors.info;
+                notification.innerHTML = `
+                    <div style="display: flex; align-items: center; gap: 8px;">
+                        <span>${this.getIcon(type)}</span>
+                        <span>${message}</span>
+                        <button onclick="this.parentElement.parentElement.remove()" style="background: none; border: none; color: white; cursor: pointer; font-size: 16px; margin-left: auto;">×</button>
+                    </div>
+                `;
+
+                document.body.appendChild(notification);
+
+                if (duration > 0) {
+                    setTimeout(() => {
+                        if (notification.parentNode) {
+                            notification.remove();
+                        }
+                    }, duration);
+                }
+
+                notification.onclick = () => notification.remove();
+            },
+
+            getIcon(type) {
+                const icons = {
+                    info: 'ℹ️',
+                    success: '✅',
+                    warning: '⚠️',
+                    error: '❌'
+                };
+                return icons[type] || icons.info;
+            }
+        };
+
+        // Add CSS for notifications
+        const notificationStyles = document.createElement('style');
+        notificationStyles.textContent = `
+            @keyframes slideIn {
+                from { transform: translateX(100%); opacity: 0; }
+                to { transform: translateX(0); opacity: 1; }
+            }
+
+            .notification {
+                animation: slideIn 0.3s ease-out;
+            }
+
+            .notification:hover {
+                transform: scale(1.02);
+                transition: transform 0.2s ease;
+            }
+        `;
+        document.head.appendChild(notificationStyles);
+
+        // Enhanced initialization with error handling
+        async function init() {
+            try {
+                NotificationSystem.show('🔍 Initializing AI Visual Code Review...', 'info', 3000);
+
+                await Promise.all([
+                    loadHealthCheck().catch(err => console.warn('Health check failed:', err)),
+                    loadSummary().catch(err => console.warn('Summary load failed:', err)),
+                    loadFiles().catch(err => console.warn('Files load failed:', err))
+                ]);
+
+                NotificationSystem.show('✅ Ready for code review!', 'success', 3000);
+            } catch (error) {
+                console.error('Initialization failed:', error);
+                NotificationSystem.show('❌ Failed to initialize. Please refresh the page.', 'error', 0);
+            }
+        }
+
+        // Comment functionality
+        function showCommentModal(file, fileId) {
+            currentCommentFile = file;
+            currentCommentFileId = fileId;
+
+            const modal = document.getElementById('commentModal');
+            const fileNameSpan = document.getElementById('modalFileName');
+            const textarea = document.getElementById('commentTextarea');
+
+            fileNameSpan.textContent = `for ${file}`;
+            textarea.value = fileComments[file] || '';
+            textarea.focus();
+
+            modal.classList.add('active');
+        }
+
+        function closeCommentModal(event) {
+            if (event && event.target !== event.currentTarget) return;
+            document.getElementById('commentModal').classList.remove('active');
+        }
+
+        function insertTemplate(template) {
+            const textarea = document.getElementById('commentTextarea');
+            const currentText = textarea.value;
+            const cursorPos = textarea.selectionStart;
+
+            const newText = currentText.slice(0, cursorPos) + template + currentText.slice(cursorPos);
+            textarea.value = newText;
+            textarea.focus();
+            textarea.setSelectionRange(cursorPos + template.length, cursorPos + template.length);
+        }
+
+        function saveComment() {
+            const textarea = document.getElementById('commentTextarea');
+            const comment = textarea.value.trim();
+
+            if (comment) {
+                fileComments[currentCommentFile] = comment;
+
+                // Update comment button to show it has a comment
+                const commentBtn = document.querySelector(`[onclick*="'${currentCommentFile}'"]`);
+                if (commentBtn) {
+                    commentBtn.classList.add('has-comment');
+                    const indicator = document.getElementById(`comment-indicator-${currentCommentFileId}`);
+                    if (indicator) {
+                        indicator.style.display = 'inline';
+                    }
+                }
+
+                // Add comment display to the file
+                showCommentInFile(currentCommentFile, currentCommentFileId, comment);
+            } else {
+                // Remove comment if empty
+                delete fileComments[currentCommentFile];
+                const commentBtn = document.querySelector(`[onclick*="'${currentCommentFile}'"]`);
+                if (commentBtn) {
+                    commentBtn.classList.remove('has-comment');
+                    const indicator = document.getElementById(`comment-indicator-${currentCommentFileId}`);
+                    if (indicator) {
+                        indicator.style.display = 'none';
+                    }
+                }
+                removeCommentFromFile(currentCommentFileId);
+            }
+
+            closeCommentModal();
+        }
+
+        function showCommentInFile(file, fileId, comment) {
+            // Remove existing comment display
+            removeCommentFromFile(fileId);
+
+            // Add comment display after file header
+            const fileItem = document.getElementById(`diff-${fileId}`).parentElement;
+            const commentDiv = document.createElement('div');
+            commentDiv.id = `comment-display-${fileId}`;
+            commentDiv.className = 'comment-display';
+            commentDiv.innerHTML = `<strong>💭 Your Comment:</strong><br>${escapeHtml(comment)}`;
+
+            const fileHeader = fileItem.querySelector('.file-header');
+            fileHeader.parentNode.insertBefore(commentDiv, fileHeader.nextSibling);
+        }
+
+        function removeCommentFromFile(fileId) {
+            const existingComment = document.getElementById(`comment-display-${fileId}`);
+            if (existingComment) {
+                existingComment.remove();
+            }
+        }
+
+        // Enhanced health check with error recovery
+        async function loadHealthCheck() {
+            const statusText = document.getElementById('statusText');
+            const timestamp = document.getElementById('timestamp');
+
+            try {
+                const response = await fetch('/api/health');
+                if (!response.ok) {
+                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
+                }
+
+                const data = await response.json();
+
+                // Enhanced status messages with actionable advice
+                if (data.totalChanges === 0) {
+                    statusText.innerHTML = '📝 No changes detected - make some changes to get started';
+                    statusText.style.color = '#7d8590';
+                } else if (data.stagedCount > 0 && data.unstagedCount > 0) {
+                    statusText.innerHTML = `✅ ${data.stagedCount} staged + ${data.unstagedCount} unstaged changes ready`;
+                    statusText.style.color = '#58a6ff';
+                } else if (data.stagedCount > 0) {
+                    statusText.innerHTML = `✅ ${data.stagedCount} staged changes ready for review`;
+                    statusText.style.color = '#aff5b4';
+                } else if (data.unstagedCount > 0) {
+                    statusText.innerHTML = `⚠️ ${data.unstagedCount} unstaged changes - run "git add ." to stage them`;
+                    statusText.style.color = '#ffd43b';
+                } else {
+                    statusText.innerHTML = '📝 Repository is clean';
+                    statusText.style.color = '#7d8590';
+                }
+
+                timestamp.textContent = `Last updated: ${new Date(data.timestamp).toLocaleTimeString()} | Version: ${data.version || '1.0.0'}`;
+            } catch (error) {
+                console.error('Health check failed:', error);
+                statusText.innerHTML = '❌ Status check failed - <button onclick="loadHealthCheck()" style="background: none; border: none; color: #58a6ff; cursor: pointer; text-decoration: underline;">Retry</button>';
+                statusText.style.color = '#f85149';
+                timestamp.textContent = 'Connection error';
+
+                NotificationSystem.show('Health check failed. Please check if the server is running.', 'error', 8000);
+            }
+        }
+
+        // Enhanced summary loading with better error handling
+        async function loadSummary() {
+            const statsElement = document.getElementById('stats');
+
+            try {
+                LoadingStates.show(statsElement, 'Loading change summary...');
+
+                const response = await fetch('/api/summary');
+                if (!response.ok) {
+                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
+                }
+
+                const data = await response.json();
+
+                if (data.stats && data.stats.trim()) {
+                    statsElement.innerHTML = `
+                        <h3>📊 Change Summary <span style="font-size: 12px; color: #7d8590; font-weight: normal;">(Generated: ${data.generated ? new Date(data.generated).toLocaleTimeString() : 'now'})</span></h3>
+                        <pre>${data.stats}</pre>
+                    `;
+                } else {
+                    statsElement.innerHTML = `
+                        <div class="empty-state">
+                            <div class="icon">📄</div>
+                            <h3>No Changes</h3>
+                            <p>Stage some changes with <code>git add .</code> to see statistics</p>
+                            <button onclick="loadSummary()" style="margin-top: 12px; padding: 8px 16px; background: #238636; color: white; border: none; border-radius: 6px; cursor: pointer;">🔄 Refresh</button>
+                        </div>
+                    `;
+                }
+            } catch (error) {
+                console.error('Summary load failed:', error);
+                LoadingStates.error(statsElement, `Failed to load summary: ${error.message}`);
+            }
+        }
+
+        // Enhanced file loading with progressive loading and better UX
+        async function loadFiles() {
+            const container = document.getElementById('fileList');
+
+            try {
+                LoadingStates.show(container, 'Loading staged files...');
+
+                const response = await fetch('/api/staged-files');
+                if (!response.ok) {
+                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
+                }
+
+                const data = await response.json();
+
+                if (!data.files || data.files.length === 0) {
+                    container.innerHTML = `
+                        <div class="empty-state">
+                            <div class="icon">📁</div>
+                            <h3>No Staged Changes</h3>
+                            <p>Stage your changes with <code>git add .</code> to start reviewing</p>
+                            <p style="margin-top: 12px; font-size: 14px;">
+                                Or run <code>git add [specific-files]</code> to stage individual files
+                            </p>
+                            <div style="margin-top: 16px;">
+                                <button onclick="location.reload()" style="padding: 8px 16px; background: #238636; color: white; border: none; border-radius: 6px; cursor: pointer; margin-right: 8px;">🔄 Refresh</button>
+                                <button onclick="window.open('https://git-scm.com/docs/git-add', '_blank')" style="padding: 8px 16px; background: #1f6feb; color: white; border: none; border-radius: 6px; cursor: pointer;">📚 Learn Git Add</button>
+                            </div>
+                        </div>
+                    `;
+                    return;
+                }
+
+                container.innerHTML = '';
+
+                // Enhanced file processing with better icons and metadata
+                data.files.forEach((file, index) => {
+                    const fileId = file.replace(/[^a-zA-Z0-9]/g, '_');
+                    const fileExt = file.substring(file.lastIndexOf('.')).toLowerCase();
+                    const fileName = file.substring(file.lastIndexOf('/') + 1);
+                    const filePath = file.substring(0, file.lastIndexOf('/')) || '.';
+
+                    let badgeClass = 'modified';
+                    let badgeText = 'Modified';
+                    let fileIcon = '📄';
+                    let fileTypeDesc = 'File';
+
+                    // Enhanced file type detection
+                    const fileTypeMap = {
+                        '.tsx': { icon: '⚛️', desc: 'TypeScript React' },
+                        '.ts': { icon: '📘', desc: 'TypeScript' },
+                        '.js': { icon: '🟨', desc: 'JavaScript' },
+                        '.jsx': { icon: '⚛️', desc: 'React Component' },
+                        '.json': { icon: '📋', desc: 'JSON Config' },
+                        '.md': { icon: '📖', desc: 'Markdown' },
+                        '.css': { icon: '🎨', desc: 'Stylesheet' },
+                        '.scss': { icon: '🎨', desc: 'Sass' },
+                        '.html': { icon: '🌐', desc: 'HTML' },
+                        '.py': { icon: '🐍', desc: 'Python' },
+                        '.sh': { icon: '💻', desc: 'Shell Script' },
+                        '.yml': { icon: '⚙️', desc: 'YAML Config' },
+                        '.yaml': { icon: '⚙️', desc: 'YAML Config' }
+                    };
+
+                    if (fileTypeMap[fileExt]) {
+                        fileIcon = fileTypeMap[fileExt].icon;
+                        fileTypeDesc = fileTypeMap[fileExt].desc;
+                    }
+
+                    // Add file to selected set by default
+                    state.selectedFiles.add(file);
+
+                    const fileDiv = document.createElement('div');
+                    fileDiv.className = 'file-item';
+                    fileDiv.innerHTML = `
+                        <div class="file-header" onclick="toggleFile('${file}', '${fileId}')">
+                            <div class="file-path">
+                                <span class="expand-icon" id="icon-${fileId}">▶️</span>
+                                <span>${fileIcon}</span>
+                                <span>${file}</span>
+                            </div>
+                            <div style="display: flex; align-items: center; gap: 12px;">
+                                <label style="display: flex; align-items: center; gap: 6px; cursor: pointer;" onclick="event.stopPropagation();">
+                                    <input
+                                        type="checkbox"
+                                        id="select-${fileId}"
+                                        data-filename="${file}"
+                                        checked
+                                        onchange="toggleFileSelection('${file}', '${fileId}')"
+                                        title="Include in AI review export"
+                                        style="accent-color: #2ea043;"
+                                    >
+                                    <span style="font-size: 12px; color: #7d8590;">Include</span>
+                                </label>
+                                <button
+                                    class="comment-btn"
+                                    onclick="event.stopPropagation(); showCommentModal('${file}', '${fileId}')"
+                                    title="Add comment for this file"
+                                >
+                                    <span id="comment-indicator-${fileId}" style="display: none;">💬</span>
+                                    💭
+                                </button>
+                                <div class="file-stats" id="stats-${fileId}">
+                                    <span>Click to load diff</span>
+                                </div>
+                                <span class="badge ${badgeClass}">${badgeText}</span>
+                            </div>
+                        </div>
+                        <div class="file-diff" id="diff-${fileId}">
+                            <div style="padding: 20px; text-align: center; color: #7d8590;">
+                                <div class="spinner" style="margin: 0 auto 12px;"></div>
+                                Loading diff for ${fileName}...
+                            </div>
+                        </div>
+                    `;
+                    container.appendChild(fileDiv);
+                });
+            } catch (error) {
+                document.getElementById('fileList').innerHTML = `
+                    <div class="error-message">
+                        Error loading files: ${error.message}
+                    </div>
+                `;
+            }
+        }
+
+        async function toggleFile(file, fileId) {
+            const diffDiv = document.getElementById(`diff-${fileId}`);
+            const icon = document.getElementById(`icon-${fileId}`);
+
+            if (diffDiv.classList.contains('active')) {
+                diffDiv.classList.remove('active');
+                icon.classList.remove('rotated');
+                return;
+            }
+
+            // Close all other diffs
+            document.querySelectorAll('.file-diff').forEach(d => d.classList.remove('active'));
+            document.querySelectorAll('.expand-icon').forEach(i => i.classList.remove('rotated'));
+
+            icon.classList.add('rotated');
+
+            if (!allDiffs[file]) {
+                try {
+                    const response = await fetch(`/api/file-diff?file=${encodeURIComponent(file)}`);
+                    const data = await response.json();
+                    allDiffs[file] = data.diff;
+                    allParsedDiffs[file] = data.parsedDiff;
+                    renderDiff(diffDiv, data.diff, file, data.parsedDiff);
+                    updateFileStats(fileId, data.diff);
+                } catch (error) {
+                    diffDiv.innerHTML = `<div class="error-message">Error loading diff: ${error.message}</div>`;
+                }
+            } else {
+                renderDiff(diffDiv, allDiffs[file], file, allParsedDiffs[file]);
+            }
+
+            diffDiv.classList.add('active');
+        }
+
+        // Line commenting functions
+        function addLineComment(lineId, filename, lineNumber) {
+            currentLineId = lineId;
+            currentCommentFile = filename;
+            currentLineNumber = lineNumber;
+
+            const modal = document.getElementById('commentModal');
+            const fileNameSpan = document.getElementById('modalFileName');
+            const textarea = document.getElementById('commentTextarea');
+
+            fileNameSpan.textContent = `for ${filename} - Line ${lineNumber}`;
+            textarea.value = lineComments[lineId] || '';
+            textarea.placeholder = `Add comment for line ${lineNumber}...`;
+            textarea.focus();
+
+            modal.classList.add('active');
+        }
+
+        function saveComment() {
+            const textarea = document.getElementById('commentTextarea');
+            const comment = textarea.value.trim();
+
+            if (currentLineId) {
+                // Line-specific comment
+                if (comment) {
+                    lineComments[currentLineId] = comment;
+                    console.log(`💬 Line comment added: ${currentCommentFile} Line ${currentLineNumber}: "${comment.substring(0, 50)}${comment.length > 50 ? '...' : ''}"`);
+
+                    // Send to server for logging
+                    fetch('/api/log-comment', {
+                        method: 'POST',
+                        headers: { 'Content-Type': 'application/json' },
+                        body: JSON.stringify({
+                            type: 'line_comment',
+                            file: currentCommentFile,
+                            lineNumber: currentLineNumber,
+                            comment: comment
+                        })
+                    });
+
+                    showLineComment(currentLineId, comment);
+                } else {
+                    delete lineComments[currentLineId];
+                    console.log(`❌ Line comment removed: ${currentCommentFile} Line ${currentLineNumber}`);
+                    hideLineComment(currentLineId);
+                }
+                currentLineId = '';
+            } else {
+                // File-level comment (existing functionality)
+                if (comment) {
+                    fileComments[currentCommentFile] = comment;
+                    console.log(`💬 File comment added: ${currentCommentFile}: "${comment.substring(0, 50)}${comment.length > 50 ? '...' : ''}"`);
+
+                    const commentBtn = document.querySelector(`[onclick*="'${currentCommentFile}'"]`);
+                    if (commentBtn) {
+                        commentBtn.classList.add('has-comment');
+                        const indicator = document.getElementById(`comment-indicator-${currentCommentFileId}`);
+                        if (indicator) indicator.style.display = 'inline';
+                    }
+                    showCommentInFile(currentCommentFile, currentCommentFileId, comment);
+                } else {
+                    delete fileComments[currentCommentFile];
+                    console.log(`❌ File comment removed: ${currentCommentFile}`);
+                    const commentBtn = document.querySelector(`[onclick*="'${currentCommentFile}'"]`);
+                    if (commentBtn) {
+                        commentBtn.classList.remove('has-comment');
+                        const indicator = document.getElementById(`comment-indicator-${currentCommentFileId}`);
+                        if (indicator) indicator.style.display = 'none';
+                    }
+                    removeCommentFromFile(currentCommentFileId);
+                }
+            }
+
+            closeCommentModal();
+        }
+
+        function showLineComment(lineId, comment) {
+            const commentDiv = document.getElementById(`comment-${lineId}`);
+            const lineContainer = document.querySelector(`[data-line-id="${lineId}"]`);
+
+            if (commentDiv && lineContainer) {
+                const actualLineNum = lineContainer.getAttribute('data-new-line') || lineContainer.getAttribute('data-old-line');
+                commentDiv.innerHTML = `💭 <strong>Line ${actualLineNum}:</strong> ${escapeHtml(comment)}`;
+                commentDiv.classList.add('line-comment-visible');
+                commentDiv.style.display = 'block';
+                lineContainer.classList.add('has-line-comment');
+
+                console.log(`✅ Line comment displayed: Line ${actualLineNum} in ${currentCommentFile}`);
+            }
+        }
+
+        function hideLineComment(lineId) {
+            const commentDiv = document.getElementById(`comment-${lineId}`);
+            const lineContainer = document.querySelector(`[data-line-id="${lineId}"]`);
+
+            if (commentDiv) commentDiv.style.display = 'none';
+            if (lineContainer) lineContainer.classList.remove('has-line-comment');
+        }
+
+        function renderDiff(container, diff, filename, parsedDiff) {
+            if (!diff.trim() || !parsedDiff?.chunks?.length) {
+                container.innerHTML = `
+                    <div style="padding: 20px; text-align: center; color: #7d8590;">
+                        <span style="font-size: 32px;">📄</span>
+                        <p>No changes detected in ${filename}</p>
+                    </div>
+                `;
+                return;
+            }
+
+            let html = '';
+
+            parsedDiff.chunks.forEach((chunk, chunkIndex) => {
+                // Render chunk header
+                html += `<div class="diff-header">${escapeHtml(chunk.header)}</div>`;
+
+                chunk.lines.forEach((line, lineIndex) => {
+                    const lineId = `${filename.replace(/[^a-zA-Z0-9]/g, '_')}_${chunkIndex}_${lineIndex}`;
+                    const oldNum = line.oldLineNum;
+                    const newNum = line.newLineNum;
+
+                    let className = 'diff-context';
+                    if (line.type === 'added') {
+                        className = 'diff-added';
+                    } else if (line.type === 'removed') {
+                        className = 'diff-removed';
+                    }
+
+                    html += `
+                        <div class="diff-line-container ${className}" data-line-id="${lineId}" data-file="${filename}" data-old-line="${oldNum}" data-new-line="${newNum}">
+                            <div class="line-numbers">
+                                <span class="old-line-num">${oldNum || ''}</span>
+                                <span class="new-line-num">${newNum || ''}</span>
+                                <button class="add-comment-btn" onclick="addLineComment('${lineId}', '${filename}', ${oldNum || newNum})" title="Add comment to this line">💬</button>
+                            </div>
+                            <div class="line-content">
+                                <code>${escapeHtml(line.content)}</code>
+                            </div>
+                            <div class="line-comment" id="comment-${lineId}" style="display: none;"></div>
+                        </div>
+                    `;
+                });
+            });
+
+            container.innerHTML = html;
+        }
+
+        function updateFileStats(fileId, diff) {
+            const lines = diff.split('\n');
+            const added = lines.filter(line => line.startsWith('+') && !line.startsWith('+++')).length;
+            const removed = lines.filter(line => line.startsWith('-') && !line.startsWith('---')).length;
+
+            const statsElement = document.getElementById(`stats-${fileId}`);
+            statsElement.innerHTML = `
+                <span style="color: #aff5b4;">+${added}</span>
+                <span style="color: #ffdcd7;">-${removed}</span>
+            `;
+        }
+
+        // Toggle file selection for export
+        function toggleFileSelection(file, fileId) {
+            const checkbox = document.getElementById(`select-${fileId}`);
+            const fileItem = checkbox.closest('.file-item');
+
+            if (checkbox.checked) {
+                selectedFiles.add(file);
+                fileItem.style.opacity = '1';
+                console.log(`✅ File included in export: ${file}`);
+            } else {
+                selectedFiles.delete(file);
+                fileItem.style.opacity = '0.6';
+                console.log(`⏭️  File excluded from export: ${file}`);
+            }
+
+            updateExportButtonText();
+        }
+
+        // Update export button text with selection count
+        function updateExportButtonText() {
+            const btn = document.getElementById('exportBtn');
+            const total = document.querySelectorAll('input[type="checkbox"][id^="select-"]').length;
+            const selected = selectedFiles.size;
+
+            if (selected === total) {
+                btn.innerHTML = '<span>📤</span> Export for AI Review';
+            } else {
+                btn.innerHTML = `<span>📤</span> Export ${selected}/${total} Files for AI Review`;
+            }
+        }
+
+        async function exportForAI() {
+            const btn = document.getElementById('exportBtn');
+            const originalText = btn.innerHTML;
+
+            // Get excluded files - simplified approach using data attributes
+            const allCheckboxes = Array.from(document.querySelectorAll('input[type="checkbox"][id^="select-"]'));
+            const allFiles = allCheckboxes.map(cb => cb.getAttribute('data-filename')).filter(f => f);
+            const excludedFiles = allFiles.filter(file => !selectedFiles.has(file));
+
+            console.log(`📋 Export Summary:`);
+            console.log(`   Selected files: ${selectedFiles.size}`);
+            console.log(`   Excluded files: ${excludedFiles.length}`);
+
+            if (excludedFiles.length > 0) {
+                console.log(`⏭️  Files excluded from AI review:`, excludedFiles);
+            }
+
+            btn.innerHTML = '<div class="spinner" style="width: 16px; height: 16px;"></div> Generating...';
+            btn.disabled = true;
+
+            try {
+                // Send comments and exclusions with export request
+                const response = await fetch('/api/export-for-ai', {
+                    method: 'POST',
+                    headers: {
+                        'Content-Type': 'application/json'
+                    },
+                    body: JSON.stringify({
+                        comments: fileComments,
+                        lineComments: lineComments,
+                        excludedFiles: excludedFiles
+                    })
+                });
+                const data = await response.json();
+
+                if (data.success) {
+                    btn.innerHTML = '✅ Generated AI_REVIEW.md';
+
+                    // Show success message
+                    const container = document.querySelector('.container');
+                    const successDiv = document.createElement('div');
+                    successDiv.className = 'success-message';
+                    successDiv.innerHTML = `
+                        <strong>✅ AI Review Generated!</strong><br>
+                        📄 Created: ${data.file}<br>
+                        📊 Files processed: ${data.filesProcessed} (${excludedFiles.length} excluded)<br>
+                        💬 Comments included: ${Object.keys(fileComments).length}<br>
+                        🔍 Line comments: ${Object.keys(lineComments).length}<br>
+                        💡 Next: Ask Cline or ChatGPT to review the generated file
+                    `;
+                    container.insertBefore(successDiv, container.firstChild);
+
+                    // Remove success message after 5 seconds
+                    setTimeout(() => {
+                        successDiv.remove();
+                        btn.innerHTML = originalText;
+                        btn.disabled = false;
+                    }, 5000);
+                } else {
+                    throw new Error(data.error || 'Export failed');
+                }
+            } catch (error) {
+                btn.innerHTML = '❌ Export Failed';
+
+                const container = document.querySelector('.container');
+                const errorDiv = document.createElement('div');
+                errorDiv.className = 'error-message';
+                errorDiv.innerHTML = `<strong>❌ Export Failed:</strong> ${error.message}`;
+                container.insertBefore(errorDiv, container.firstChild);
+
+                setTimeout(() => {
+                    errorDiv.remove();
+                    btn.innerHTML = originalText;
+                    btn.disabled = false;
+                }, 5000);
+            }
+        }
+
+        async function exportIndividualReviews() {
+            const btn = document.getElementById('exportIndividualBtn');
+            const originalText = btn.innerHTML;
+
+            // Get excluded files - same logic as exportForAI
+            const allCheckboxes = Array.from(document.querySelectorAll('input[type="checkbox"][id^="select-"]'));
+            const allFiles = allCheckboxes.map(cb => cb.getAttribute('data-filename')).filter(f => f);
+            const excludedFiles = allFiles.filter(file => !selectedFiles.has(file));
+
+            console.log(`📁 Individual Export Summary:`);
+            console.log(`   Selected files: ${selectedFiles.size}`);
+            console.log(`   Excluded files: ${excludedFiles.length}`);
+
+            if (excludedFiles.length > 0) {
+                console.log(`⏭️  Files excluded from individual review:`, excludedFiles);
+            }
+
+            btn.innerHTML = '<div class="spinner" style="width: 16px; height: 16px;"></div> Creating...';
+            btn.disabled = true;
+
+            try {
+                // Send comments and exclusions with export request
+                const response = await fetch('/api/export-individual-reviews', {
+                    method: 'POST',
+                    headers: {
+                        'Content-Type': 'application/json'
+                    },
+                    body: JSON.stringify({
+                        comments: fileComments,
+                        lineComments: lineComments,
+                        excludedFiles: excludedFiles
+                    })
+                });
+                const data = await response.json();
+
+                if (data.success) {
+                    btn.innerHTML = '✅ Created Review Directory';
+
+                    // Show success message
+                    const container = document.querySelector('.container');
+                    const successDiv = document.createElement('div');
+                    successDiv.className = 'success-message';
+                    successDiv.innerHTML = `
+                        <strong>✅ Individual Review Files Created!</strong><br>
+                        📁 Directory: ${data.directory}<br>
+                        📄 Files created: ${data.filesCreated} review files<br>
+                        📊 Total changes: ${data.totalFiles} files (${data.excludedCount} excluded)<br>
+                        💬 Comments included: ${data.commentsIncluded || 0}<br>
+                        💡 Next: Open the directory to review files individually
+                    `;
+                    container.insertBefore(successDiv, container.firstChild);
+
+                    // Remove success message after 5 seconds
+                    setTimeout(() => {
+                        successDiv.remove();
+                        btn.innerHTML = originalText;
+                        btn.disabled = false;
+                    }, 5000);
+                } else {
+                    throw new Error(data.error || 'Export failed');
+                }
+            } catch (error) {
+                btn.innerHTML = '❌ Export Failed';
+
+                const container = document.querySelector('.container');
+                const errorDiv = document.createElement('div');
+                errorDiv.className = 'error-message';
+                errorDiv.innerHTML = `<strong>❌ Individual Export Failed:</strong> ${error.message}`;
+                container.insertBefore(errorDiv, container.firstChild);
+
+                setTimeout(() => {
+                    errorDiv.remove();
+                    btn.innerHTML = originalText;
+                    btn.disabled = false;
+                }, 5000);
+            }
+        }
+
+        function escapeHtml(text) {
+            const div = document.createElement('div');
+            div.textContent = text;
+            return div.innerHTML;
+        }
+
+        // Keyboard shortcuts
+        document.addEventListener('keydown', (e) => {
+            if (e.key === 'Escape' && document.getElementById('commentModal').classList.contains('active')) {
+                closeCommentModal();
+            }
+            if (e.ctrlKey && e.key === 'Enter' && document.getElementById('commentModal').classList.contains('active')) {
+                saveComment();
+            }
+        });
+
+        // Auto-refresh every 30 seconds
+        setInterval(async () => {
+            await loadHealthCheck();
+        }, 30000);
+
+        // Initialize when page loads
+        init();
+    </script>
+</body>
+</html>
```


### 📄 `vscode-extension/package-lock.json`

**Type:** Configuration/Data

```diff
diff --git c/vscode-extension/package-lock.json i/vscode-extension/package-lock.json
new file mode 100644
index 0000000..75ca162
--- /dev/null
+++ i/vscode-extension/package-lock.json
@@ -0,0 +1,3245 @@
+{
+  "name": "ai-visual-code-review",
+  "version": "1.0.0",
+  "lockfileVersion": 3,
+  "requires": true,
+  "packages": {
+    "": {
+      "name": "ai-visual-code-review",
+      "version": "1.0.0",
+      "license": "MIT",
+      "dependencies": {
+        "simple-git": "^3.19.1"
+      },
+      "devDependencies": {
+        "@types/node": "16.x",
+        "@types/vscode": "^1.74.0",
+        "@typescript-eslint/eslint-plugin": "^5.45.0",
+        "@typescript-eslint/parser": "^5.45.0",
+        "eslint": "^8.28.0",
+        "typescript": "^4.9.4",
+        "vsce": "^2.15.0"
+      },
+      "engines": {
+        "vscode": "^1.74.0"
+      }
+    },
+    "node_modules/@eslint-community/eslint-utils": {
+      "version": "4.9.0",
+      "resolved": "https://registry.npmjs.org/@eslint-community/eslint-utils/-/eslint-utils-4.9.0.tgz",
+      "integrity": "sha512-ayVFHdtZ+hsq1t2Dy24wCmGXGe4q9Gu3smhLYALJrr473ZH27MsnSL+LKUlimp4BWJqMDMLmPpx/Q9R3OAlL4g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "eslint-visitor-keys": "^3.4.3"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "url": "https://opencollective.com/eslint"
+      },
+      "peerDependencies": {
+        "eslint": "^6.0.0 || ^7.0.0 || >=8.0.0"
+      }
+    },
+    "node_modules/@eslint-community/regexpp": {
+      "version": "4.12.1",
+      "resolved": "https://registry.npmjs.org/@eslint-community/regexpp/-/regexpp-4.12.1.tgz",
+      "integrity": "sha512-CCZCDJuduB9OUkFkY2IgppNZMi2lBQgD2qzwXkEia16cge2pijY/aXi96CJMquDMn3nJdlPV1A5KrJEXwfLNzQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": "^12.0.0 || ^14.0.0 || >=16.0.0"
+      }
+    },
+    "node_modules/@eslint/eslintrc": {
+      "version": "2.1.4",
+      "resolved": "https://registry.npmjs.org/@eslint/eslintrc/-/eslintrc-2.1.4.tgz",
+      "integrity": "sha512-269Z39MS6wVJtsoUl10L60WdkhJVdPG24Q4eZTH3nnF6lpvSShEK3wQjDX9JRWAUPvPh7COouPpU9IrqaZFvtQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "ajv": "^6.12.4",
+        "debug": "^4.3.2",
+        "espree": "^9.6.0",
+        "globals": "^13.19.0",
+        "ignore": "^5.2.0",
+        "import-fresh": "^3.2.1",
+        "js-yaml": "^4.1.0",
+        "minimatch": "^3.1.2",
+        "strip-json-comments": "^3.1.1"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "url": "https://opencollective.com/eslint"
+      }
+    },
+    "node_modules/@eslint/js": {
+      "version": "8.57.1",
+      "resolved": "https://registry.npmjs.org/@eslint/js/-/js-8.57.1.tgz",
+      "integrity": "sha512-d9zaMRSTIKDLhctzH12MtXvJKSSUhaHcjV+2Z+GK+EEY7XKpP5yR4x+N3TAcHTcu963nIr+TMcCb4DBCYX1z6Q==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      }
+    },
+    "node_modules/@humanwhocodes/config-array": {
+      "version": "0.13.0",
+      "resolved": "https://registry.npmjs.org/@humanwhocodes/config-array/-/config-array-0.13.0.tgz",
+      "integrity": "sha512-DZLEEqFWQFiyK6h5YIeynKx7JlvCYWL0cImfSRXZ9l4Sg2efkFGTuFf6vzXjK1cq6IYkU+Eg/JizXw+TD2vRNw==",
+      "deprecated": "Use @eslint/config-array instead",
+      "dev": true,
+      "license": "Apache-2.0",
+      "dependencies": {
+        "@humanwhocodes/object-schema": "^2.0.3",
+        "debug": "^4.3.1",
+        "minimatch": "^3.0.5"
+      },
+      "engines": {
+        "node": ">=10.10.0"
+      }
+    },
+    "node_modules/@humanwhocodes/module-importer": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/@humanwhocodes/module-importer/-/module-importer-1.0.1.tgz",
+      "integrity": "sha512-bxveV4V8v5Yb4ncFTT3rPSgZBOpCkjfK0y4oVVVJwIuDVBRMDXrPyXRL988i5ap9m9bnyEEjWfm5WkBmtffLfA==",
+      "dev": true,
+      "license": "Apache-2.0",
+      "engines": {
+        "node": ">=12.22"
+      },
+      "funding": {
+        "type": "github",
+        "url": "https://github.com/sponsors/nzakas"
+      }
+    },
+    "node_modules/@humanwhocodes/object-schema": {
+      "version": "2.0.3",
+      "resolved": "https://registry.npmjs.org/@humanwhocodes/object-schema/-/object-schema-2.0.3.tgz",
+      "integrity": "sha512-93zYdMES/c1D69yZiKDBj0V24vqNzB/koF26KPaagAfd3P/4gUlh3Dys5ogAK+Exi9QyzlD8x/08Zt7wIKcDcA==",
+      "deprecated": "Use @eslint/object-schema instead",
+      "dev": true,
+      "license": "BSD-3-Clause"
+    },
+    "node_modules/@kwsites/file-exists": {
+      "version": "1.1.1",
+      "resolved": "https://registry.npmjs.org/@kwsites/file-exists/-/file-exists-1.1.1.tgz",
+      "integrity": "sha512-m9/5YGR18lIwxSFDwfE3oA7bWuq9kdau6ugN4H2rJeyhFQZcG9AgSHkQtSD15a8WvTgfz9aikZMrKPHvbpqFiw==",
+      "license": "MIT",
+      "dependencies": {
+        "debug": "^4.1.1"
+      }
+    },
+    "node_modules/@kwsites/promise-deferred": {
+      "version": "1.1.1",
+      "resolved": "https://registry.npmjs.org/@kwsites/promise-deferred/-/promise-deferred-1.1.1.tgz",
+      "integrity": "sha512-GaHYm+c0O9MjZRu0ongGBRbinu8gVAMd2UZjji6jVmqKtZluZnptXGWhz1E8j8D2HJ3f/yMxKAUC0b+57wncIw==",
+      "license": "MIT"
+    },
+    "node_modules/@nodelib/fs.scandir": {
+      "version": "2.1.5",
+      "resolved": "https://registry.npmjs.org/@nodelib/fs.scandir/-/fs.scandir-2.1.5.tgz",
+      "integrity": "sha512-vq24Bq3ym5HEQm2NKCr3yXDwjc7vTsEThRDnkp2DK9p1uqLR+DHurm/NOTo0KG7HYHU7eppKZj3MyqYuMBf62g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@nodelib/fs.stat": "2.0.5",
+        "run-parallel": "^1.1.9"
+      },
+      "engines": {
+        "node": ">= 8"
+      }
+    },
+    "node_modules/@nodelib/fs.stat": {
+      "version": "2.0.5",
+      "resolved": "https://registry.npmjs.org/@nodelib/fs.stat/-/fs.stat-2.0.5.tgz",
+      "integrity": "sha512-RkhPPp2zrqDAQA/2jNhnztcPAlv64XdhIp7a7454A5ovI7Bukxgt7MX7udwAu3zg1DcpPU0rz3VV1SeaqvY4+A==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 8"
+      }
+    },
+    "node_modules/@nodelib/fs.walk": {
+      "version": "1.2.8",
+      "resolved": "https://registry.npmjs.org/@nodelib/fs.walk/-/fs.walk-1.2.8.tgz",
+      "integrity": "sha512-oGB+UxlgWcgQkgwo8GcEGwemoTFt3FIO9ababBmaGwXIoBKZ+GTy0pP185beGg7Llih/NSHSV2XAs1lnznocSg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@nodelib/fs.scandir": "2.1.5",
+        "fastq": "^1.6.0"
+      },
+      "engines": {
+        "node": ">= 8"
+      }
+    },
+    "node_modules/@types/json-schema": {
+      "version": "7.0.15",
+      "resolved": "https://registry.npmjs.org/@types/json-schema/-/json-schema-7.0.15.tgz",
+      "integrity": "sha512-5+fP8P8MFNC+AyZCDxrB2pkZFPGzqQWUzpSeuuVLvm8VMcorNYavBqoFcxK8bQz4Qsbn4oUEEem4wDLfcysGHA==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/@types/node": {
+      "version": "16.18.126",
+      "resolved": "https://registry.npmjs.org/@types/node/-/node-16.18.126.tgz",
+      "integrity": "sha512-OTcgaiwfGFBKacvfwuHzzn1KLxH/er8mluiy8/uM3sGXHaRe73RrSIj01jow9t4kJEW633Ov+cOexXeiApTyAw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/@types/semver": {
+      "version": "7.7.1",
+      "resolved": "https://registry.npmjs.org/@types/semver/-/semver-7.7.1.tgz",
+      "integrity": "sha512-FmgJfu+MOcQ370SD0ev7EI8TlCAfKYU+B4m5T3yXc1CiRN94g/SZPtsCkk506aUDtlMnFZvasDwHHUcZUEaYuA==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/@types/vscode": {
+      "version": "1.105.0",
+      "resolved": "https://registry.npmjs.org/@types/vscode/-/vscode-1.105.0.tgz",
+      "integrity": "sha512-Lotk3CTFlGZN8ray4VxJE7axIyLZZETQJVWi/lYoUVQuqfRxlQhVOfoejsD2V3dVXPSbS15ov5ZyowMAzgUqcw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/@typescript-eslint/eslint-plugin": {
+      "version": "5.62.0",
+      "resolved": "https://registry.npmjs.org/@typescript-eslint/eslint-plugin/-/eslint-plugin-5.62.0.tgz",
+      "integrity": "sha512-TiZzBSJja/LbhNPvk6yc0JrX9XqhQ0hdh6M2svYfsHGejaKFIAGd9MQ+ERIMzLGlN/kZoYIgdxFV0PuljTKXag==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@eslint-community/regexpp": "^4.4.0",
+        "@typescript-eslint/scope-manager": "5.62.0",
+        "@typescript-eslint/type-utils": "5.62.0",
+        "@typescript-eslint/utils": "5.62.0",
+        "debug": "^4.3.4",
+        "graphemer": "^1.4.0",
+        "ignore": "^5.2.0",
+        "natural-compare-lite": "^1.4.0",
+        "semver": "^7.3.7",
+        "tsutils": "^3.21.0"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "type": "opencollective",
+        "url": "https://opencollective.com/typescript-eslint"
+      },
+      "peerDependencies": {
+        "@typescript-eslint/parser": "^5.0.0",
+        "eslint": "^6.0.0 || ^7.0.0 || ^8.0.0"
+      },
+      "peerDependenciesMeta": {
+        "typescript": {
+          "optional": true
+        }
+      }
+    },
+    "node_modules/@typescript-eslint/parser": {
+      "version": "5.62.0",
+      "resolved": "https://registry.npmjs.org/@typescript-eslint/parser/-/parser-5.62.0.tgz",
+      "integrity": "sha512-VlJEV0fOQ7BExOsHYAGrgbEiZoi8D+Bl2+f6V2RrXerRSylnp+ZBHmPvaIa8cz0Ajx7WO7Z5RqfgYg7ED1nRhA==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "@typescript-eslint/scope-manager": "5.62.0",
+        "@typescript-eslint/types": "5.62.0",
+        "@typescript-eslint/typescript-estree": "5.62.0",
+        "debug": "^4.3.4"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "type": "opencollective",
+        "url": "https://opencollective.com/typescript-eslint"
+      },
+      "peerDependencies": {
+        "eslint": "^6.0.0 || ^7.0.0 || ^8.0.0"
+      },
+      "peerDependenciesMeta": {
+        "typescript": {
+          "optional": true
+        }
+      }
+    },
+    "node_modules/@typescript-eslint/scope-manager": {
+      "version": "5.62.0",
+      "resolved": "https://registry.npmjs.org/@typescript-eslint/scope-manager/-/scope-manager-5.62.0.tgz",
+      "integrity": "sha512-VXuvVvZeQCQb5Zgf4HAxc04q5j+WrNAtNh9OwCsCgpKqESMTu3tF/jhZ3xG6T4NZwWl65Bg8KuS2uEvhSfLl0w==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@typescript-eslint/types": "5.62.0",
+        "@typescript-eslint/visitor-keys": "5.62.0"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "type": "opencollective",
+        "url": "https://opencollective.com/typescript-eslint"
+      }
+    },
+    "node_modules/@typescript-eslint/type-utils": {
+      "version": "5.62.0",
+      "resolved": "https://registry.npmjs.org/@typescript-eslint/type-utils/-/type-utils-5.62.0.tgz",
+      "integrity": "sha512-xsSQreu+VnfbqQpW5vnCJdq1Z3Q0U31qiWmRhr98ONQmcp/yhiPJFPq8MXiJVLiksmOKSjIldZzkebzHuCGzew==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@typescript-eslint/typescript-estree": "5.62.0",
+        "@typescript-eslint/utils": "5.62.0",
+        "debug": "^4.3.4",
+        "tsutils": "^3.21.0"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "type": "opencollective",
+        "url": "https://opencollective.com/typescript-eslint"
+      },
+      "peerDependencies": {
+        "eslint": "*"
+      },
+      "peerDependenciesMeta": {
+        "typescript": {
+          "optional": true
+        }
+      }
+    },
+    "node_modules/@typescript-eslint/types": {
+      "version": "5.62.0",
+      "resolved": "https://registry.npmjs.org/@typescript-eslint/types/-/types-5.62.0.tgz",
+      "integrity": "sha512-87NVngcbVXUahrRTqIK27gD2t5Cu1yuCXxbLcFtCzZGlfyVWWh8mLHkoxzjsB6DDNnvdL+fW8MiwPEJyGJQDgQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "type": "opencollective",
+        "url": "https://opencollective.com/typescript-eslint"
+      }
+    },
+    "node_modules/@typescript-eslint/typescript-estree": {
+      "version": "5.62.0",
+      "resolved": "https://registry.npmjs.org/@typescript-eslint/typescript-estree/-/typescript-estree-5.62.0.tgz",
+      "integrity": "sha512-CmcQ6uY7b9y694lKdRB8FEel7JbU/40iSAPomu++SjLMntB+2Leay2LO6i8VnJk58MtE9/nQSFIH6jpyRWyYzA==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "@typescript-eslint/types": "5.62.0",
+        "@typescript-eslint/visitor-keys": "5.62.0",
+        "debug": "^4.3.4",
+        "globby": "^11.1.0",
+        "is-glob": "^4.0.3",
+        "semver": "^7.3.7",
+        "tsutils": "^3.21.0"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "type": "opencollective",
+        "url": "https://opencollective.com/typescript-eslint"
+      },
+      "peerDependenciesMeta": {
+        "typescript": {
+          "optional": true
+        }
+      }
+    },
+    "node_modules/@typescript-eslint/utils": {
+      "version": "5.62.0",
+      "resolved": "https://registry.npmjs.org/@typescript-eslint/utils/-/utils-5.62.0.tgz",
+      "integrity": "sha512-n8oxjeb5aIbPFEtmQxQYOLI0i9n5ySBEY/ZEHHZqKQSFnxio1rv6dthascc9dLuwrL0RC5mPCxB7vnAVGAYWAQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@eslint-community/eslint-utils": "^4.2.0",
+        "@types/json-schema": "^7.0.9",
+        "@types/semver": "^7.3.12",
+        "@typescript-eslint/scope-manager": "5.62.0",
+        "@typescript-eslint/types": "5.62.0",
+        "@typescript-eslint/typescript-estree": "5.62.0",
+        "eslint-scope": "^5.1.1",
+        "semver": "^7.3.7"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "type": "opencollective",
+        "url": "https://opencollective.com/typescript-eslint"
+      },
+      "peerDependencies": {
+        "eslint": "^6.0.0 || ^7.0.0 || ^8.0.0"
+      }
+    },
+    "node_modules/@typescript-eslint/visitor-keys": {
+      "version": "5.62.0",
+      "resolved": "https://registry.npmjs.org/@typescript-eslint/visitor-keys/-/visitor-keys-5.62.0.tgz",
+      "integrity": "sha512-07ny+LHRzQXepkGg6w0mFY41fVUNBrL2Roj/++7V1txKugfjm/Ci/qSND03r2RhlJhJYMcTn9AhhSSqQp0Ysyw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@typescript-eslint/types": "5.62.0",
+        "eslint-visitor-keys": "^3.3.0"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "type": "opencollective",
+        "url": "https://opencollective.com/typescript-eslint"
+      }
+    },
+    "node_modules/@ungap/structured-clone": {
+      "version": "1.3.0",
+      "resolved": "https://registry.npmjs.org/@ungap/structured-clone/-/structured-clone-1.3.0.tgz",
+      "integrity": "sha512-WmoN8qaIAo7WTYWbAZuG8PYEhn5fkz7dZrqTBZ7dtt//lL2Gwms1IcnQ5yHqjDfX8Ft5j4YzDM23f87zBfDe9g==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/acorn": {
+      "version": "8.15.0",
+      "resolved": "https://registry.npmjs.org/acorn/-/acorn-8.15.0.tgz",
+      "integrity": "sha512-NZyJarBfL7nWwIq+FDL6Zp/yHEhePMNnnJ0y3qfieCrmNvYct8uvtiV41UvlSe6apAfk0fY1FbWx+NwfmpvtTg==",
+      "dev": true,
+      "license": "MIT",
+      "bin": {
+        "acorn": "bin/acorn"
+      },
+      "engines": {
+        "node": ">=0.4.0"
+      }
+    },
+    "node_modules/acorn-jsx": {
+      "version": "5.3.2",
+      "resolved": "https://registry.npmjs.org/acorn-jsx/-/acorn-jsx-5.3.2.tgz",
+      "integrity": "sha512-rq9s+JNhf0IChjtDXxllJ7g41oZk5SlXtp0LHwyA5cejwn7vKmKp4pPri6YEePv2PU65sAsegbXtIinmDFDXgQ==",
+      "dev": true,
+      "license": "MIT",
+      "peerDependencies": {
+        "acorn": "^6.0.0 || ^7.0.0 || ^8.0.0"
+      }
+    },
+    "node_modules/ajv": {
+      "version": "6.12.6",
+      "resolved": "https://registry.npmjs.org/ajv/-/ajv-6.12.6.tgz",
+      "integrity": "sha512-j3fVLgvTo527anyYyJOGTYJbG+vnnQYvE0m5mmkc1TK+nxAppkCLMIL0aZ4dblVCNoGShhm+kzE4ZUykBoMg4g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "fast-deep-equal": "^3.1.1",
+        "fast-json-stable-stringify": "^2.0.0",
+        "json-schema-traverse": "^0.4.1",
+        "uri-js": "^4.2.2"
+      },
+      "funding": {
+        "type": "github",
+        "url": "https://github.com/sponsors/epoberezkin"
+      }
+    },
+    "node_modules/ansi-regex": {
+      "version": "5.0.1",
+      "resolved": "https://registry.npmjs.org/ansi-regex/-/ansi-regex-5.0.1.tgz",
+      "integrity": "sha512-quJQXlTSUGL2LH9SUXo8VwsY4soanhgo6LNSm84E1LBcE8s3O0wpdiRzyR9z/ZZJMlMWv37qOOb9pdJlMUEKFQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/ansi-styles": {
+      "version": "4.3.0",
+      "resolved": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-4.3.0.tgz",
+      "integrity": "sha512-zbB9rCJAT1rbjiVDb2hqKFHNYLxgtk8NURxZ3IZwD3F6NtxbXZQCnnSi1Lkx+IDohdPlFp222wVALIheZJQSEg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "color-convert": "^2.0.1"
+      },
+      "engines": {
+        "node": ">=8"
+      },
+      "funding": {
+        "url": "https://github.com/chalk/ansi-styles?sponsor=1"
+      }
+    },
+    "node_modules/argparse": {
+      "version": "2.0.1",
+      "resolved": "https://registry.npmjs.org/argparse/-/argparse-2.0.1.tgz",
+      "integrity": "sha512-8+9WqebbFzpX9OR+Wa6O29asIogeRMzcGtAINdpMHHyAg10f05aSFVBbcEqGf/PXw1EjAZ+q2/bEBg3DvurK3Q==",
+      "dev": true,
+      "license": "Python-2.0"
+    },
+    "node_modules/array-union": {
+      "version": "2.1.0",
+      "resolved": "https://registry.npmjs.org/array-union/-/array-union-2.1.0.tgz",
+      "integrity": "sha512-HGyxoOTYUyCM6stUe6EJgnd4EoewAI7zMdfqO+kGjnlZmBDz/cR5pf8r/cR4Wq60sL/p0IkcjUEEPwS3GFrIyw==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/azure-devops-node-api": {
+      "version": "11.2.0",
+      "resolved": "https://registry.npmjs.org/azure-devops-node-api/-/azure-devops-node-api-11.2.0.tgz",
+      "integrity": "sha512-XdiGPhrpaT5J8wdERRKs5g8E0Zy1pvOYTli7z9E8nmOn3YGp4FhtjhrOyFmX/8veWCwdI69mCHKJw6l+4J/bHA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "tunnel": "0.0.6",
+        "typed-rest-client": "^1.8.4"
+      }
+    },
+    "node_modules/balanced-match": {
+      "version": "1.0.2",
+      "resolved": "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz",
+      "integrity": "sha512-3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/base64-js": {
+      "version": "1.5.1",
+      "resolved": "https://registry.npmjs.org/base64-js/-/base64-js-1.5.1.tgz",
+      "integrity": "sha512-AKpaYlHn8t4SVbOHCy+b5+KKgvR4vrsD8vbvrbiQJps7fKDTkjkDry6ji0rUJjC0kzbNePLwzxq8iypo41qeWA==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/feross"
+        },
+        {
+          "type": "patreon",
+          "url": "https://www.patreon.com/feross"
+        },
+        {
+          "type": "consulting",
+          "url": "https://feross.org/support"
+        }
+      ],
+      "license": "MIT"
+    },
+    "node_modules/bl": {
+      "version": "4.1.0",
+      "resolved": "https://registry.npmjs.org/bl/-/bl-4.1.0.tgz",
+      "integrity": "sha512-1W07cM9gS6DcLperZfFSj+bWLtaPGSOHWhPiGzXmvVJbRLdG82sH/Kn8EtW1VqWVA54AKf2h5k5BbnIbwF3h6w==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "buffer": "^5.5.0",
+        "inherits": "^2.0.4",
+        "readable-stream": "^3.4.0"
+      }
+    },
+    "node_modules/boolbase": {
+      "version": "1.0.0",
+      "resolved": "https://registry.npmjs.org/boolbase/-/boolbase-1.0.0.tgz",
+      "integrity": "sha512-JZOSA7Mo9sNGB8+UjSgzdLtokWAky1zbztM3WRLCbZ70/3cTANmQmOdR7y2g+J0e2WXywy1yS468tY+IruqEww==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/brace-expansion": {
+      "version": "1.1.12",
+      "resolved": "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.12.tgz",
+      "integrity": "sha512-9T9UjW3r0UW5c1Q7GTwllptXwhvYmEzFhzMfZ9H7FQWt+uZePjZPjBP/W1ZEyZ1twGWom5/56TF4lPcqjnDHcg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "balanced-match": "^1.0.0",
+        "concat-map": "0.0.1"
+      }
+    },
+    "node_modules/braces": {
+      "version": "3.0.3",
+      "resolved": "https://registry.npmjs.org/braces/-/braces-3.0.3.tgz",
+      "integrity": "sha512-yQbXgO/OSZVD2IsiLlro+7Hf6Q18EJrKSEsdoMzKePKXct3gvD8oLcOQdIzGupr5Fj+EDe8gO/lxc1BzfMpxvA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "fill-range": "^7.1.1"
+      },
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/buffer": {
+      "version": "5.7.1",
+      "resolved": "https://registry.npmjs.org/buffer/-/buffer-5.7.1.tgz",
+      "integrity": "sha512-EHcyIPBQ4BSGlvjB16k5KgAJ27CIsHY/2JBmCRReo48y9rQ3MaUzWX3KVlBa4U7MyX02HdVj0K7C3WaB3ju7FQ==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/feross"
+        },
+        {
+          "type": "patreon",
+          "url": "https://www.patreon.com/feross"
+        },
+        {
+          "type": "consulting",
+          "url": "https://feross.org/support"
+        }
+      ],
+      "license": "MIT",
+      "dependencies": {
+        "base64-js": "^1.3.1",
+        "ieee754": "^1.1.13"
+      }
+    },
+    "node_modules/buffer-crc32": {
+      "version": "0.2.13",
+      "resolved": "https://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.13.tgz",
+      "integrity": "sha512-VO9Ht/+p3SN7SKWqcrgEzjGbRSJYTx+Q1pTQC0wrWqHx0vpJraQ6GtHx8tvcg1rlK1byhU5gccxgOgj7B0TDkQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": "*"
+      }
+    },
+    "node_modules/call-bind-apply-helpers": {
+      "version": "1.0.2",
+      "resolved": "https://registry.npmjs.org/call-bind-apply-helpers/-/call-bind-apply-helpers-1.0.2.tgz",
+      "integrity": "sha512-Sp1ablJ0ivDkSzjcaJdxEunN5/XvksFJ2sMBFfq6x0ryhQV/2b/KwFe21cMpmHtPOSij8K99/wSfoEuTObmuMQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "es-errors": "^1.3.0",
+        "function-bind": "^1.1.2"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      }
+    },
+    "node_modules/call-bound": {
+      "version": "1.0.4",
+      "resolved": "https://registry.npmjs.org/call-bound/-/call-bound-1.0.4.tgz",
+      "integrity": "sha512-+ys997U96po4Kx/ABpBCqhA9EuxJaQWDQg7295H4hBphv3IZg0boBKuwYpt4YXp6MZ5AmZQnU/tyMTlRpaSejg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "call-bind-apply-helpers": "^1.0.2",
+        "get-intrinsic": "^1.3.0"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/callsites": {
+      "version": "3.1.0",
+      "resolved": "https://registry.npmjs.org/callsites/-/callsites-3.1.0.tgz",
+      "integrity": "sha512-P8BjAsXvZS+VIDUI11hHCQEv74YT67YUi5JJFNWIqL235sBmjX4+qx9Muvls5ivyNENctx46xQLQ3aTuE7ssaQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=6"
+      }
+    },
+    "node_modules/chalk": {
+      "version": "4.1.2",
+      "resolved": "https://registry.npmjs.org/chalk/-/chalk-4.1.2.tgz",
+      "integrity": "sha512-oKnbhFyRIXpUuez8iBMmyEa4nbj4IOQyuhc/wy9kY7/WVPcwIO9VA668Pu8RkO7+0G76SLROeyw9CpQ061i4mA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "ansi-styles": "^4.1.0",
+        "supports-color": "^7.1.0"
+      },
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/chalk/chalk?sponsor=1"
+      }
+    },
+    "node_modules/cheerio": {
+      "version": "1.1.2",
+      "resolved": "https://registry.npmjs.org/cheerio/-/cheerio-1.1.2.tgz",
+      "integrity": "sha512-IkxPpb5rS/d1IiLbHMgfPuS0FgiWTtFIm/Nj+2woXDLTZ7fOT2eqzgYbdMlLweqlHbsZjxEChoVK+7iph7jyQg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "cheerio-select": "^2.1.0",
+        "dom-serializer": "^2.0.0",
+        "domhandler": "^5.0.3",
+        "domutils": "^3.2.2",
+        "encoding-sniffer": "^0.2.1",
+        "htmlparser2": "^10.0.0",
+        "parse5": "^7.3.0",
+        "parse5-htmlparser2-tree-adapter": "^7.1.0",
+        "parse5-parser-stream": "^7.1.2",
+        "undici": "^7.12.0",
+        "whatwg-mimetype": "^4.0.0"
+      },
+      "engines": {
+        "node": ">=20.18.1"
+      },
+      "funding": {
+        "url": "https://github.com/cheeriojs/cheerio?sponsor=1"
+      }
+    },
+    "node_modules/cheerio-select": {
+      "version": "2.1.0",
+      "resolved": "https://registry.npmjs.org/cheerio-select/-/cheerio-select-2.1.0.tgz",
+      "integrity": "sha512-9v9kG0LvzrlcungtnJtpGNxY+fzECQKhK4EGJX2vByejiMX84MFNQw4UxPJl3bFbTMw+Dfs37XaIkCwTZfLh4g==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "boolbase": "^1.0.0",
+        "css-select": "^5.1.0",
+        "css-what": "^6.1.0",
+        "domelementtype": "^2.3.0",
+        "domhandler": "^5.0.3",
+        "domutils": "^3.0.1"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/fb55"
+      }
+    },
+    "node_modules/chownr": {
+      "version": "1.1.4",
+      "resolved": "https://registry.npmjs.org/chownr/-/chownr-1.1.4.tgz",
+      "integrity": "sha512-jJ0bqzaylmJtVnNgzTeSOs8DPavpbYgEr/b0YL8/2GO3xJEhInFmhKMUnEJQjZumK7KXGFhUy89PrsJWlakBVg==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/color-convert": {
+      "version": "2.0.1",
+      "resolved": "https://registry.npmjs.org/color-convert/-/color-convert-2.0.1.tgz",
+      "integrity": "sha512-RRECPsj7iu/xb5oKYcsFHSppFNnsj/52OVTRKb4zP5onXwVF3zVmmToNcOfGC+CRDpfK/U584fMg38ZHCaElKQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "color-name": "~1.1.4"
+      },
+      "engines": {
+        "node": ">=7.0.0"
+      }
+    },
+    "node_modules/color-name": {
+      "version": "1.1.4",
+      "resolved": "https://registry.npmjs.org/color-name/-/color-name-1.1.4.tgz",
+      "integrity": "sha512-dOy+3AuW3a2wNbZHIuMZpTcgjGuLU/uBL/ubcZF9OXbDo8ff4O8yVp5Bf0efS8uEoYo5q4Fx7dY9OgQGXgAsQA==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/commander": {
+      "version": "6.2.1",
+      "resolved": "https://registry.npmjs.org/commander/-/commander-6.2.1.tgz",
+      "integrity": "sha512-U7VdrJFnJgo4xjrHpTzu0yrHPGImdsmD95ZlgYSEajAn2JKzDhDTPG9kBTefmObL2w/ngeZnilk+OV9CG3d7UA==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 6"
+      }
+    },
+    "node_modules/concat-map": {
+      "version": "0.0.1",
+      "resolved": "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz",
+      "integrity": "sha512-/Srv4dswyQNBfohGpz9o6Yb3Gz3SrUDqBH5rTuhGR7ahtlbYKnVxw2bCFMRljaA7EXHaXZ8wsHdodFvbkhKmqg==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/cross-spawn": {
+      "version": "7.0.6",
+      "resolved": "https://registry.npmjs.org/cross-spawn/-/cross-spawn-7.0.6.tgz",
+      "integrity": "sha512-uV2QOWP2nWzsy2aMp8aRibhi9dlzF5Hgh5SHaB9OiTGEyDTiJJyx0uy51QXdyWbtAHNua4XJzUKca3OzKUd3vA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "path-key": "^3.1.0",
+        "shebang-command": "^2.0.0",
+        "which": "^2.0.1"
+      },
+      "engines": {
+        "node": ">= 8"
+      }
+    },
+    "node_modules/css-select": {
+      "version": "5.2.2",
+      "resolved": "https://registry.npmjs.org/css-select/-/css-select-5.2.2.tgz",
+      "integrity": "sha512-TizTzUddG/xYLA3NXodFM0fSbNizXjOKhqiQQwvhlspadZokn1KDy0NZFS0wuEubIYAV5/c1/lAr0TaaFXEXzw==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "boolbase": "^1.0.0",
+        "css-what": "^6.1.0",
+        "domhandler": "^5.0.2",
+        "domutils": "^3.0.1",
+        "nth-check": "^2.0.1"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/fb55"
+      }
+    },
+    "node_modules/css-what": {
+      "version": "6.2.2",
+      "resolved": "https://registry.npmjs.org/css-what/-/css-what-6.2.2.tgz",
+      "integrity": "sha512-u/O3vwbptzhMs3L1fQE82ZSLHQQfto5gyZzwteVIEyeaY5Fc7R4dapF/BvRoSYFeqfBk4m0V1Vafq5Pjv25wvA==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">= 6"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/fb55"
+      }
+    },
+    "node_modules/debug": {
+      "version": "4.4.3",
+      "resolved": "https://registry.npmjs.org/debug/-/debug-4.4.3.tgz",
+      "integrity": "sha512-RGwwWnwQvkVfavKVt22FGLw+xYSdzARwm0ru6DhTVA3umU5hZc28V3kO4stgYryrTlLpuvgI9GiijltAjNbcqA==",
+      "license": "MIT",
+      "dependencies": {
+        "ms": "^2.1.3"
+      },
+      "engines": {
+        "node": ">=6.0"
+      },
+      "peerDependenciesMeta": {
+        "supports-color": {
+          "optional": true
+        }
+      }
+    },
+    "node_modules/decompress-response": {
+      "version": "6.0.0",
+      "resolved": "https://registry.npmjs.org/decompress-response/-/decompress-response-6.0.0.tgz",
+      "integrity": "sha512-aW35yZM6Bb/4oJlZncMH2LCoZtJXTRxES17vE3hoRiowU2kWHaJKFkSBDnDR+cm9J+9QhXmREyIfv0pji9ejCQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "mimic-response": "^3.1.0"
+      },
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/deep-extend": {
+      "version": "0.6.0",
+      "resolved": "https://registry.npmjs.org/deep-extend/-/deep-extend-0.6.0.tgz",
+      "integrity": "sha512-LOHxIOaPYdHlJRtCQfDIVZtfw/ufM8+rVj649RIHzcm/vGwQRXFt6OPqIFWsm2XEMrNIEtWR64sY1LEKD2vAOA==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=4.0.0"
+      }
+    },
+    "node_modules/deep-is": {
+      "version": "0.1.4",
+      "resolved": "https://registry.npmjs.org/deep-is/-/deep-is-0.1.4.tgz",
+      "integrity": "sha512-oIPzksmTg4/MriiaYGO+okXDT7ztn/w3Eptv/+gSIdMdKsJo0u4CfYNFJPy+4SKMuCqGw2wxnA+URMg3t8a/bQ==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/detect-libc": {
+      "version": "2.1.2",
+      "resolved": "https://registry.npmjs.org/detect-libc/-/detect-libc-2.1.2.tgz",
+      "integrity": "sha512-Btj2BOOO83o3WyH59e8MgXsxEQVcarkUOpEYrubB0urwnN10yQ364rsiByU11nZlqWYZm05i/of7io4mzihBtQ==",
+      "dev": true,
+      "license": "Apache-2.0",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/dir-glob": {
+      "version": "3.0.1",
+      "resolved": "https://registry.npmjs.org/dir-glob/-/dir-glob-3.0.1.tgz",
+      "integrity": "sha512-WkrWp9GR4KXfKGYzOLmTuGVi1UWFfws377n9cc55/tb6DuqyF6pcQ5AbiHEshaDpY9v6oaSr2XCDidGmMwdzIA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "path-type": "^4.0.0"
+      },
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/doctrine": {
+      "version": "3.0.0",
+      "resolved": "https://registry.npmjs.org/doctrine/-/doctrine-3.0.0.tgz",
+      "integrity": "sha512-yS+Q5i3hBf7GBkd4KG8a7eBNNWNGLTaEwwYWUijIYM7zrlYDM0BFXHjjPWlWZ1Rg7UaddZeIDmi9jF3HmqiQ2w==",
+      "dev": true,
+      "license": "Apache-2.0",
+      "dependencies": {
+        "esutils": "^2.0.2"
+      },
+      "engines": {
+        "node": ">=6.0.0"
+      }
+    },
+    "node_modules/dom-serializer": {
+      "version": "2.0.0",
+      "resolved": "https://registry.npmjs.org/dom-serializer/-/dom-serializer-2.0.0.tgz",
+      "integrity": "sha512-wIkAryiqt/nV5EQKqQpo3SToSOV9J0DnbJqwK7Wv/Trc92zIAYZ4FlMu+JPFW1DfGFt81ZTCGgDEabffXeLyJg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "domelementtype": "^2.3.0",
+        "domhandler": "^5.0.2",
+        "entities": "^4.2.0"
+      },
+      "funding": {
+        "url": "https://github.com/cheeriojs/dom-serializer?sponsor=1"
+      }
+    },
+    "node_modules/domelementtype": {
+      "version": "2.3.0",
+      "resolved": "https://registry.npmjs.org/domelementtype/-/domelementtype-2.3.0.tgz",
+      "integrity": "sha512-OLETBj6w0OsagBwdXnPdN0cnMfF9opN69co+7ZrbfPGrdpPVNBUj02spi6B1N7wChLQiPn4CSH/zJvXw56gmHw==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/fb55"
+        }
+      ],
+      "license": "BSD-2-Clause"
+    },
+    "node_modules/domhandler": {
+      "version": "5.0.3",
+      "resolved": "https://registry.npmjs.org/domhandler/-/domhandler-5.0.3.tgz",
+      "integrity": "sha512-cgwlv/1iFQiFnU96XXgROh8xTeetsnJiDsTc7TYCLFd9+/WNkIqPTxiM/8pSd8VIrhXGTf1Ny1q1hquVqDJB5w==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "domelementtype": "^2.3.0"
+      },
+      "engines": {
+        "node": ">= 4"
+      },
+      "funding": {
+        "url": "https://github.com/fb55/domhandler?sponsor=1"
+      }
+    },
+    "node_modules/domutils": {
+      "version": "3.2.2",
+      "resolved": "https://registry.npmjs.org/domutils/-/domutils-3.2.2.tgz",
+      "integrity": "sha512-6kZKyUajlDuqlHKVX1w7gyslj9MPIXzIFiz/rGu35uC1wMi+kMhQwGhl4lt9unC9Vb9INnY9Z3/ZA3+FhASLaw==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "dom-serializer": "^2.0.0",
+        "domelementtype": "^2.3.0",
+        "domhandler": "^5.0.3"
+      },
+      "funding": {
+        "url": "https://github.com/fb55/domutils?sponsor=1"
+      }
+    },
+    "node_modules/dunder-proto": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/dunder-proto/-/dunder-proto-1.0.1.tgz",
+      "integrity": "sha512-KIN/nDJBQRcXw0MLVhZE9iQHmG68qAVIBg9CqmUYjmQIhgij9U5MFvrqkUL5FbtyyzZuOeOt0zdeRe4UY7ct+A==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "call-bind-apply-helpers": "^1.0.1",
+        "es-errors": "^1.3.0",
+        "gopd": "^1.2.0"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      }
+    },
+    "node_modules/encoding-sniffer": {
+      "version": "0.2.1",
+      "resolved": "https://registry.npmjs.org/encoding-sniffer/-/encoding-sniffer-0.2.1.tgz",
+      "integrity": "sha512-5gvq20T6vfpekVtqrYQsSCFZ1wEg5+wW0/QaZMWkFr6BqD3NfKs0rLCx4rrVlSWJeZb5NBJgVLswK/w2MWU+Gw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "iconv-lite": "^0.6.3",
+        "whatwg-encoding": "^3.1.1"
+      },
+      "funding": {
+        "url": "https://github.com/fb55/encoding-sniffer?sponsor=1"
+      }
+    },
+    "node_modules/end-of-stream": {
+      "version": "1.4.5",
+      "resolved": "https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.5.tgz",
+      "integrity": "sha512-ooEGc6HP26xXq/N+GCGOT0JKCLDGrq2bQUZrQ7gyrJiZANJ/8YDTxTpQBXGMn+WbIQXNVpyWymm7KYVICQnyOg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "once": "^1.4.0"
+      }
+    },
+    "node_modules/entities": {
+      "version": "4.5.0",
+      "resolved": "https://registry.npmjs.org/entities/-/entities-4.5.0.tgz",
+      "integrity": "sha512-V0hjH4dGPh9Ao5p0MoRY6BVqtwCjhz6vI5LT8AJ55H+4g9/4vbHx1I54fS0XuclLhDHArPQCiMjDxjaL8fPxhw==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">=0.12"
+      },
+      "funding": {
+        "url": "https://github.com/fb55/entities?sponsor=1"
+      }
+    },
+    "node_modules/es-define-property": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/es-define-property/-/es-define-property-1.0.1.tgz",
+      "integrity": "sha512-e3nRfgfUZ4rNGL232gUgX06QNyyez04KdjFrF+LTRoOXmrOgFKDg4BCdsjW8EnT69eqdYGmRpJwiPVYNrCaW3g==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 0.4"
+      }
+    },
+    "node_modules/es-errors": {
+      "version": "1.3.0",
+      "resolved": "https://registry.npmjs.org/es-errors/-/es-errors-1.3.0.tgz",
+      "integrity": "sha512-Zf5H2Kxt2xjTvbJvP2ZWLEICxA6j+hAmMzIlypy4xcBg1vKVnx89Wy0GbS+kf5cwCVFFzdCFh2XSCFNULS6csw==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 0.4"
+      }
+    },
+    "node_modules/es-object-atoms": {
+      "version": "1.1.1",
+      "resolved": "https://registry.npmjs.org/es-object-atoms/-/es-object-atoms-1.1.1.tgz",
+      "integrity": "sha512-FGgH2h8zKNim9ljj7dankFPcICIK9Cp5bm+c2gQSYePhpaG5+esrLODihIorn+Pe6FGJzWhXQotPv73jTaldXA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "es-errors": "^1.3.0"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      }
+    },
+    "node_modules/escape-string-regexp": {
+      "version": "4.0.0",
+      "resolved": "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-4.0.0.tgz",
+      "integrity": "sha512-TtpcNJ3XAzx3Gq8sWRzJaVajRs0uVxA2YAkdb1jm2YkPz4G6egUFAyA3n5vtEIZefPk5Wa4UXbKuS5fKkJWdgA==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/eslint": {
+      "version": "8.57.1",
+      "resolved": "https://registry.npmjs.org/eslint/-/eslint-8.57.1.tgz",
+      "integrity": "sha512-ypowyDxpVSYpkXr9WPv2PAZCtNip1Mv5KTW0SCurXv/9iOpcrH9PaqUElksqEB6pChqHGDRCFTyrZlGhnLNGiA==",
+      "deprecated": "This version is no longer supported. Please see https://eslint.org/version-support for other options.",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@eslint-community/eslint-utils": "^4.2.0",
+        "@eslint-community/regexpp": "^4.6.1",
+        "@eslint/eslintrc": "^2.1.4",
+        "@eslint/js": "8.57.1",
+        "@humanwhocodes/config-array": "^0.13.0",
+        "@humanwhocodes/module-importer": "^1.0.1",
+        "@nodelib/fs.walk": "^1.2.8",
+        "@ungap/structured-clone": "^1.2.0",
+        "ajv": "^6.12.4",
+        "chalk": "^4.0.0",
+        "cross-spawn": "^7.0.2",
+        "debug": "^4.3.2",
+        "doctrine": "^3.0.0",
+        "escape-string-regexp": "^4.0.0",
+        "eslint-scope": "^7.2.2",
+        "eslint-visitor-keys": "^3.4.3",
+        "espree": "^9.6.1",
+        "esquery": "^1.4.2",
+        "esutils": "^2.0.2",
+        "fast-deep-equal": "^3.1.3",
+        "file-entry-cache": "^6.0.1",
+        "find-up": "^5.0.0",
+        "glob-parent": "^6.0.2",
+        "globals": "^13.19.0",
+        "graphemer": "^1.4.0",
+        "ignore": "^5.2.0",
+        "imurmurhash": "^0.1.4",
+        "is-glob": "^4.0.0",
+        "is-path-inside": "^3.0.3",
+        "js-yaml": "^4.1.0",
+        "json-stable-stringify-without-jsonify": "^1.0.1",
+        "levn": "^0.4.1",
+        "lodash.merge": "^4.6.2",
+        "minimatch": "^3.1.2",
+        "natural-compare": "^1.4.0",
+        "optionator": "^0.9.3",
+        "strip-ansi": "^6.0.1",
+        "text-table": "^0.2.0"
+      },
+      "bin": {
+        "eslint": "bin/eslint.js"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "url": "https://opencollective.com/eslint"
+      }
+    },
+    "node_modules/eslint-scope": {
+      "version": "5.1.1",
+      "resolved": "https://registry.npmjs.org/eslint-scope/-/eslint-scope-5.1.1.tgz",
+      "integrity": "sha512-2NxwbF/hZ0KpepYN0cNbo+FN6XoK7GaHlQhgx/hIZl6Va0bF45RQOOwhLIy8lQDbuCiadSLCBnH2CFYquit5bw==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "esrecurse": "^4.3.0",
+        "estraverse": "^4.1.1"
+      },
+      "engines": {
+        "node": ">=8.0.0"
+      }
+    },
+    "node_modules/eslint-visitor-keys": {
+      "version": "3.4.3",
+      "resolved": "https://registry.npmjs.org/eslint-visitor-keys/-/eslint-visitor-keys-3.4.3.tgz",
+      "integrity": "sha512-wpc+LXeiyiisxPlEkUzU6svyS1frIO3Mgxj1fdy7Pm8Ygzguax2N3Fa/D/ag1WqbOprdI+uY6wMUl8/a2G+iag==",
+      "dev": true,
+      "license": "Apache-2.0",
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "url": "https://opencollective.com/eslint"
+      }
+    },
+    "node_modules/eslint/node_modules/eslint-scope": {
+      "version": "7.2.2",
+      "resolved": "https://registry.npmjs.org/eslint-scope/-/eslint-scope-7.2.2.tgz",
+      "integrity": "sha512-dOt21O7lTMhDM+X9mB4GX+DZrZtCUJPL/wlcTqxyrx5IvO0IYtILdtrQGQp+8n5S0gwSVmOf9NQrjMOgfQZlIg==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "esrecurse": "^4.3.0",
+        "estraverse": "^5.2.0"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "url": "https://opencollective.com/eslint"
+      }
+    },
+    "node_modules/eslint/node_modules/estraverse": {
+      "version": "5.3.0",
+      "resolved": "https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz",
+      "integrity": "sha512-MMdARuVEQziNTeJD8DgMqmhwR11BRQ/cBP+pLtYdSTnf3MIO8fFeiINEbX36ZdNlfU/7A9f3gUw49B3oQsvwBA==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">=4.0"
+      }
+    },
+    "node_modules/espree": {
+      "version": "9.6.1",
+      "resolved": "https://registry.npmjs.org/espree/-/espree-9.6.1.tgz",
+      "integrity": "sha512-oruZaFkjorTpF32kDSI5/75ViwGeZginGGy2NoOSg3Q9bnwlnmDm4HLnkl0RE3n+njDXR037aY1+x58Z/zFdwQ==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "acorn": "^8.9.0",
+        "acorn-jsx": "^5.3.2",
+        "eslint-visitor-keys": "^3.4.1"
+      },
+      "engines": {
+        "node": "^12.22.0 || ^14.17.0 || >=16.0.0"
+      },
+      "funding": {
+        "url": "https://opencollective.com/eslint"
+      }
+    },
+    "node_modules/esquery": {
+      "version": "1.6.0",
+      "resolved": "https://registry.npmjs.org/esquery/-/esquery-1.6.0.tgz",
+      "integrity": "sha512-ca9pw9fomFcKPvFLXhBKUK90ZvGibiGOvRJNbjljY7s7uq/5YO4BOzcYtJqExdx99rF6aAcnRxHmcUHcz6sQsg==",
+      "dev": true,
+      "license": "BSD-3-Clause",
+      "dependencies": {
+        "estraverse": "^5.1.0"
+      },
+      "engines": {
+        "node": ">=0.10"
+      }
+    },
+    "node_modules/esquery/node_modules/estraverse": {
+      "version": "5.3.0",
+      "resolved": "https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz",
+      "integrity": "sha512-MMdARuVEQziNTeJD8DgMqmhwR11BRQ/cBP+pLtYdSTnf3MIO8fFeiINEbX36ZdNlfU/7A9f3gUw49B3oQsvwBA==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">=4.0"
+      }
+    },
+    "node_modules/esrecurse": {
+      "version": "4.3.0",
+      "resolved": "https://registry.npmjs.org/esrecurse/-/esrecurse-4.3.0.tgz",
+      "integrity": "sha512-KmfKL3b6G+RXvP8N1vr3Tq1kL/oCFgn2NYXEtqP8/L3pKapUA4G8cFVaoF3SU323CD4XypR/ffioHmkti6/Tag==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "estraverse": "^5.2.0"
+      },
+      "engines": {
+        "node": ">=4.0"
+      }
+    },
+    "node_modules/esrecurse/node_modules/estraverse": {
+      "version": "5.3.0",
+      "resolved": "https://registry.npmjs.org/estraverse/-/estraverse-5.3.0.tgz",
+      "integrity": "sha512-MMdARuVEQziNTeJD8DgMqmhwR11BRQ/cBP+pLtYdSTnf3MIO8fFeiINEbX36ZdNlfU/7A9f3gUw49B3oQsvwBA==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">=4.0"
+      }
+    },
+    "node_modules/estraverse": {
+      "version": "4.3.0",
+      "resolved": "https://registry.npmjs.org/estraverse/-/estraverse-4.3.0.tgz",
+      "integrity": "sha512-39nnKffWz8xN1BU/2c79n9nB9HDzo0niYUqx6xyqUnyoAnQyyWpOTdZEeiCch8BBu515t4wp9ZmgVfVhn9EBpw==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">=4.0"
+      }
+    },
+    "node_modules/esutils": {
+      "version": "2.0.3",
+      "resolved": "https://registry.npmjs.org/esutils/-/esutils-2.0.3.tgz",
+      "integrity": "sha512-kVscqXk4OCp68SZ0dkgEKVi6/8ij300KBWTJq32P/dYeWTSwK41WyTxalN1eRmA5Z9UU/LX9D7FWSmV9SAYx6g==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">=0.10.0"
+      }
+    },
+    "node_modules/expand-template": {
+      "version": "2.0.3",
+      "resolved": "https://registry.npmjs.org/expand-template/-/expand-template-2.0.3.tgz",
+      "integrity": "sha512-XYfuKMvj4O35f/pOXLObndIRvyQ+/+6AhODh+OKWj9S9498pHHn/IMszH+gt0fBCRWMNfk1ZSp5x3AifmnI2vg==",
+      "dev": true,
+      "license": "(MIT OR WTFPL)",
+      "engines": {
+        "node": ">=6"
+      }
+    },
+    "node_modules/fast-deep-equal": {
+      "version": "3.1.3",
+      "resolved": "https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz",
+      "integrity": "sha512-f3qQ9oQy9j2AhBe/H9VC91wLmKBCCU/gDOnKNAYG5hswO7BLKj09Hc5HYNz9cGI++xlpDCIgDaitVs03ATR84Q==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/fast-glob": {
+      "version": "3.3.3",
+      "resolved": "https://registry.npmjs.org/fast-glob/-/fast-glob-3.3.3.tgz",
+      "integrity": "sha512-7MptL8U0cqcFdzIzwOTHoilX9x5BrNqye7Z/LuC7kCMRio1EMSyqRK3BEAUD7sXRq4iT4AzTVuZdhgQ2TCvYLg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "@nodelib/fs.stat": "^2.0.2",
+        "@nodelib/fs.walk": "^1.2.3",
+        "glob-parent": "^5.1.2",
+        "merge2": "^1.3.0",
+        "micromatch": "^4.0.8"
+      },
+      "engines": {
+        "node": ">=8.6.0"
+      }
+    },
+    "node_modules/fast-glob/node_modules/glob-parent": {
+      "version": "5.1.2",
+      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-5.1.2.tgz",
+      "integrity": "sha512-AOIgSQCepiJYwP3ARnGx+5VnTu2HBYdzbGP45eLw1vr3zB3vZLeyed1sC9hnbcOc9/SrMyM5RPQrkGz4aS9Zow==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "is-glob": "^4.0.1"
+      },
+      "engines": {
+        "node": ">= 6"
+      }
+    },
+    "node_modules/fast-json-stable-stringify": {
+      "version": "2.1.0",
+      "resolved": "https://registry.npmjs.org/fast-json-stable-stringify/-/fast-json-stable-stringify-2.1.0.tgz",
+      "integrity": "sha512-lhd/wF+Lk98HZoTCtlVraHtfh5XYijIjalXck7saUtuanSDyLMxnHhSXEDJqHxD7msR8D0uCmqlkwjCV8xvwHw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/fast-levenshtein": {
+      "version": "2.0.6",
+      "resolved": "https://registry.npmjs.org/fast-levenshtein/-/fast-levenshtein-2.0.6.tgz",
+      "integrity": "sha512-DCXu6Ifhqcks7TZKY3Hxp3y6qphY5SJZmrWMDrKcERSOXWQdMhU9Ig/PYrzyw/ul9jOIyh0N4M0tbC5hodg8dw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/fastq": {
+      "version": "1.19.1",
+      "resolved": "https://registry.npmjs.org/fastq/-/fastq-1.19.1.tgz",
+      "integrity": "sha512-GwLTyxkCXjXbxqIhTsMI2Nui8huMPtnxg7krajPJAjnEG/iiOS7i+zCtWGZR9G0NBKbXKh6X9m9UIsYX/N6vvQ==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "reusify": "^1.0.4"
+      }
+    },
+    "node_modules/fd-slicer": {
+      "version": "1.1.0",
+      "resolved": "https://registry.npmjs.org/fd-slicer/-/fd-slicer-1.1.0.tgz",
+      "integrity": "sha512-cE1qsB/VwyQozZ+q1dGxR8LBYNZeofhEdUNGSMbQD3Gw2lAzX9Zb3uIU6Ebc/Fmyjo9AWWfnn0AUCHqtevs/8g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "pend": "~1.2.0"
+      }
+    },
+    "node_modules/file-entry-cache": {
+      "version": "6.0.1",
+      "resolved": "https://registry.npmjs.org/file-entry-cache/-/file-entry-cache-6.0.1.tgz",
+      "integrity": "sha512-7Gps/XWymbLk2QLYK4NzpMOrYjMhdIxXuIvy2QBsLE6ljuodKvdkWs/cpyJJ3CVIVpH0Oi1Hvg1ovbMzLdFBBg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "flat-cache": "^3.0.4"
+      },
+      "engines": {
+        "node": "^10.12.0 || >=12.0.0"
+      }
+    },
+    "node_modules/fill-range": {
+      "version": "7.1.1",
+      "resolved": "https://registry.npmjs.org/fill-range/-/fill-range-7.1.1.tgz",
+      "integrity": "sha512-YsGpe3WHLK8ZYi4tWDg2Jy3ebRz2rXowDxnld4bkQB00cc/1Zw9AWnC0i9ztDJitivtQvaI9KaLyKrc+hBW0yg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "to-regex-range": "^5.0.1"
+      },
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/find-up": {
+      "version": "5.0.0",
+      "resolved": "https://registry.npmjs.org/find-up/-/find-up-5.0.0.tgz",
+      "integrity": "sha512-78/PXT1wlLLDgTzDs7sjq9hzz0vXD+zn+7wypEe4fXQxCmdmqfGsEPQxmiCSQI3ajFV91bVSsvNtrJRiW6nGng==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "locate-path": "^6.0.0",
+        "path-exists": "^4.0.0"
+      },
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/flat-cache": {
+      "version": "3.2.0",
+      "resolved": "https://registry.npmjs.org/flat-cache/-/flat-cache-3.2.0.tgz",
+      "integrity": "sha512-CYcENa+FtcUKLmhhqyctpclsq7QF38pKjZHsGNiSQF5r4FtoKDWabFDl3hzaEQMvT1LHEysw5twgLvpYYb4vbw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "flatted": "^3.2.9",
+        "keyv": "^4.5.3",
+        "rimraf": "^3.0.2"
+      },
+      "engines": {
+        "node": "^10.12.0 || >=12.0.0"
+      }
+    },
+    "node_modules/flatted": {
+      "version": "3.3.3",
+      "resolved": "https://registry.npmjs.org/flatted/-/flatted-3.3.3.tgz",
+      "integrity": "sha512-GX+ysw4PBCz0PzosHDepZGANEuFCMLrnRTiEy9McGjmkCQYwRq4A/X786G/fjM/+OjsWSU1ZrY5qyARZmO/uwg==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/fs-constants": {
+      "version": "1.0.0",
+      "resolved": "https://registry.npmjs.org/fs-constants/-/fs-constants-1.0.0.tgz",
+      "integrity": "sha512-y6OAwoSIf7FyjMIv94u+b5rdheZEjzR63GTyZJm5qh4Bi+2YgwLCcI/fPFZkL5PSixOt6ZNKm+w+Hfp/Bciwow==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/fs.realpath": {
+      "version": "1.0.0",
+      "resolved": "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz",
+      "integrity": "sha512-OO0pH2lK6a0hZnAdau5ItzHPI6pUlvI7jMVnxUQRtw4owF2wk8lOSabtGDCTP4Ggrg2MbGnWO9X8K1t4+fGMDw==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/function-bind": {
+      "version": "1.1.2",
+      "resolved": "https://registry.npmjs.org/function-bind/-/function-bind-1.1.2.tgz",
+      "integrity": "sha512-7XHNxH7qX9xG5mIwxkhumTox/MIRNcOgDrxWsMt2pAr23WHp6MrRlN7FBSFpCpr+oVO0F744iUgR82nJMfG2SA==",
+      "dev": true,
+      "license": "MIT",
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/get-intrinsic": {
+      "version": "1.3.0",
+      "resolved": "https://registry.npmjs.org/get-intrinsic/-/get-intrinsic-1.3.0.tgz",
+      "integrity": "sha512-9fSjSaos/fRIVIp+xSJlE6lfwhES7LNtKaCBIamHsjr2na1BiABJPo0mOjjz8GJDURarmCPGqaiVg5mfjb98CQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "call-bind-apply-helpers": "^1.0.2",
+        "es-define-property": "^1.0.1",
+        "es-errors": "^1.3.0",
+        "es-object-atoms": "^1.1.1",
+        "function-bind": "^1.1.2",
+        "get-proto": "^1.0.1",
+        "gopd": "^1.2.0",
+        "has-symbols": "^1.1.0",
+        "hasown": "^2.0.2",
+        "math-intrinsics": "^1.1.0"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/get-proto": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/get-proto/-/get-proto-1.0.1.tgz",
+      "integrity": "sha512-sTSfBjoXBp89JvIKIefqw7U2CCebsc74kiY6awiGogKtoSGbgjYE/G/+l9sF3MWFPNc9IcoOC4ODfKHfxFmp0g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "dunder-proto": "^1.0.1",
+        "es-object-atoms": "^1.0.0"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      }
+    },
+    "node_modules/github-from-package": {
+      "version": "0.0.0",
+      "resolved": "https://registry.npmjs.org/github-from-package/-/github-from-package-0.0.0.tgz",
+      "integrity": "sha512-SyHy3T1v2NUXn29OsWdxmK6RwHD+vkj3v8en8AOBZ1wBQ/hCAQ5bAQTD02kW4W9tUp/3Qh6J8r9EvntiyCmOOw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/glob": {
+      "version": "7.2.3",
+      "resolved": "https://registry.npmjs.org/glob/-/glob-7.2.3.tgz",
+      "integrity": "sha512-nFR0zLpU2YCaRxwoCJvL6UvCH2JFyFVIvwTLsIf21AuHlMskA1hhTdk+LlYJtOlYt9v6dvszD2BGRqBL+iQK9Q==",
+      "deprecated": "Glob versions prior to v9 are no longer supported",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "fs.realpath": "^1.0.0",
+        "inflight": "^1.0.4",
+        "inherits": "2",
+        "minimatch": "^3.1.1",
+        "once": "^1.3.0",
+        "path-is-absolute": "^1.0.0"
+      },
+      "engines": {
+        "node": "*"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/isaacs"
+      }
+    },
+    "node_modules/glob-parent": {
+      "version": "6.0.2",
+      "resolved": "https://registry.npmjs.org/glob-parent/-/glob-parent-6.0.2.tgz",
+      "integrity": "sha512-XxwI8EOhVQgWp6iDL+3b0r86f4d6AX6zSU55HfB4ydCEuXLXc5FcYeOu+nnGftS4TEju/11rt4KJPTMgbfmv4A==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "is-glob": "^4.0.3"
+      },
+      "engines": {
+        "node": ">=10.13.0"
+      }
+    },
+    "node_modules/globals": {
+      "version": "13.24.0",
+      "resolved": "https://registry.npmjs.org/globals/-/globals-13.24.0.tgz",
+      "integrity": "sha512-AhO5QUcj8llrbG09iWhPU2B204J1xnPeL8kQmVorSsy+Sjj1sk8gIyh6cUocGmH4L0UuhAJy+hJMRA4mgA4mFQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "type-fest": "^0.20.2"
+      },
+      "engines": {
+        "node": ">=8"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/globby": {
+      "version": "11.1.0",
+      "resolved": "https://registry.npmjs.org/globby/-/globby-11.1.0.tgz",
+      "integrity": "sha512-jhIXaOzy1sb8IyocaruWSn1TjmnBVs8Ayhcy83rmxNJ8q2uWKCAj3CnJY+KpGSXCueAPc0i05kVvVKtP1t9S3g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "array-union": "^2.1.0",
+        "dir-glob": "^3.0.1",
+        "fast-glob": "^3.2.9",
+        "ignore": "^5.2.0",
+        "merge2": "^1.4.1",
+        "slash": "^3.0.0"
+      },
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/gopd": {
+      "version": "1.2.0",
+      "resolved": "https://registry.npmjs.org/gopd/-/gopd-1.2.0.tgz",
+      "integrity": "sha512-ZUKRh6/kUFoAiTAtTYPZJ3hw9wNxx+BIBOijnlG9PnrJsCcSjs1wyyD6vJpaYtgnzDrKYRSqf3OO6Rfa93xsRg==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/graphemer": {
+      "version": "1.4.0",
+      "resolved": "https://registry.npmjs.org/graphemer/-/graphemer-1.4.0.tgz",
+      "integrity": "sha512-EtKwoO6kxCL9WO5xipiHTZlSzBm7WLT627TqC/uVRd0HKmq8NXyebnNYxDoBi7wt8eTWrUrKXCOVaFq9x1kgag==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/has-flag": {
+      "version": "4.0.0",
+      "resolved": "https://registry.npmjs.org/has-flag/-/has-flag-4.0.0.tgz",
+      "integrity": "sha512-EykJT/Q1KjTWctppgIAgfSO0tKVuZUjhgMr17kqTumMl6Afv3EISleU7qZUzoXDFTAHTDC4NOoG/ZxU3EvlMPQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/has-symbols": {
+      "version": "1.1.0",
+      "resolved": "https://registry.npmjs.org/has-symbols/-/has-symbols-1.1.0.tgz",
+      "integrity": "sha512-1cDNdwJ2Jaohmb3sg4OmKaMBwuC48sYni5HUw2DvsC8LjGTLK9h+eb1X6RyuOHe4hT0ULCW68iomhjUoKUqlPQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/hasown": {
+      "version": "2.0.2",
+      "resolved": "https://registry.npmjs.org/hasown/-/hasown-2.0.2.tgz",
+      "integrity": "sha512-0hJU9SCPvmMzIBdZFqNPXWa6dqh7WdH0cII9y+CyS8rG3nL48Bclra9HmKhVVUHyPWNH5Y7xDwAB7bfgSjkUMQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "function-bind": "^1.1.2"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      }
+    },
+    "node_modules/hosted-git-info": {
+      "version": "4.1.0",
+      "resolved": "https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-4.1.0.tgz",
+      "integrity": "sha512-kyCuEOWjJqZuDbRHzL8V93NzQhwIB71oFWSyzVo+KPZI+pnQPPxucdkrOZvkLRnrf5URsQM+IJ09Dw29cRALIA==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "lru-cache": "^6.0.0"
+      },
+      "engines": {
+        "node": ">=10"
+      }
+    },
+    "node_modules/htmlparser2": {
+      "version": "10.0.0",
+      "resolved": "https://registry.npmjs.org/htmlparser2/-/htmlparser2-10.0.0.tgz",
+      "integrity": "sha512-TwAZM+zE5Tq3lrEHvOlvwgj1XLWQCtaaibSN11Q+gGBAS7Y1uZSWwXXRe4iF6OXnaq1riyQAPFOBtYc77Mxq0g==",
+      "dev": true,
+      "funding": [
+        "https://github.com/fb55/htmlparser2?sponsor=1",
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/fb55"
+        }
+      ],
+      "license": "MIT",
+      "dependencies": {
+        "domelementtype": "^2.3.0",
+        "domhandler": "^5.0.3",
+        "domutils": "^3.2.1",
+        "entities": "^6.0.0"
+      }
+    },
+    "node_modules/htmlparser2/node_modules/entities": {
+      "version": "6.0.1",
+      "resolved": "https://registry.npmjs.org/entities/-/entities-6.0.1.tgz",
+      "integrity": "sha512-aN97NXWF6AWBTahfVOIrB/NShkzi5H7F9r1s9mD3cDj4Ko5f2qhhVoYMibXF7GlLveb/D2ioWay8lxI97Ven3g==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">=0.12"
+      },
+      "funding": {
+        "url": "https://github.com/fb55/entities?sponsor=1"
+      }
+    },
+    "node_modules/iconv-lite": {
+      "version": "0.6.3",
+      "resolved": "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.6.3.tgz",
+      "integrity": "sha512-4fCk79wshMdzMp2rH06qWrJE4iolqLhCUH+OiuIgU++RB0+94NlDL81atO7GX55uUKueo0txHNtvEyI6D7WdMw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "safer-buffer": ">= 2.1.2 < 3.0.0"
+      },
+      "engines": {
+        "node": ">=0.10.0"
+      }
+    },
+    "node_modules/ieee754": {
+      "version": "1.2.1",
+      "resolved": "https://registry.npmjs.org/ieee754/-/ieee754-1.2.1.tgz",
+      "integrity": "sha512-dcyqhDvX1C46lXZcVqCpK+FtMRQVdIMN6/Df5js2zouUsqG7I6sFxitIC+7KYK29KdXOLHdu9zL4sFnoVQnqaA==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/feross"
+        },
+        {
+          "type": "patreon",
+          "url": "https://www.patreon.com/feross"
+        },
+        {
+          "type": "consulting",
+          "url": "https://feross.org/support"
+        }
+      ],
+      "license": "BSD-3-Clause"
+    },
+    "node_modules/ignore": {
+      "version": "5.3.2",
+      "resolved": "https://registry.npmjs.org/ignore/-/ignore-5.3.2.tgz",
+      "integrity": "sha512-hsBTNUqQTDwkWtcdYI2i06Y/nUBEsNEDJKjWdigLvegy8kDuJAS8uRlpkkcQpyEXL0Z/pjDy5HBmMjRCJ2gq+g==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 4"
+      }
+    },
+    "node_modules/import-fresh": {
+      "version": "3.3.1",
+      "resolved": "https://registry.npmjs.org/import-fresh/-/import-fresh-3.3.1.tgz",
+      "integrity": "sha512-TR3KfrTZTYLPB6jUjfx6MF9WcWrHL9su5TObK4ZkYgBdWKPOFoSoQIdEuTuR82pmtxH2spWG9h6etwfr1pLBqQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "parent-module": "^1.0.0",
+        "resolve-from": "^4.0.0"
+      },
+      "engines": {
+        "node": ">=6"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/imurmurhash": {
+      "version": "0.1.4",
+      "resolved": "https://registry.npmjs.org/imurmurhash/-/imurmurhash-0.1.4.tgz",
+      "integrity": "sha512-JmXMZ6wuvDmLiHEml9ykzqO6lwFbof0GG4IkcGaENdCRDDmMVnny7s5HsIgHCbaq0w2MyPhDqkhTUgS2LU2PHA==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=0.8.19"
+      }
+    },
+    "node_modules/inflight": {
+      "version": "1.0.6",
+      "resolved": "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz",
+      "integrity": "sha512-k92I/b08q4wvFscXCLvqfsHCrjrF7yiXsQuIVvVE7N82W3+aqpzuUdBbfhWcy/FZR3/4IgflMgKLOsvPDrGCJA==",
+      "deprecated": "This module is not supported, and leaks memory. Do not use it. Check out lru-cache if you want a good and tested way to coalesce async requests by a key value, which is much more comprehensive and powerful.",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "once": "^1.3.0",
+        "wrappy": "1"
+      }
+    },
+    "node_modules/inherits": {
+      "version": "2.0.4",
+      "resolved": "https://registry.npmjs.org/inherits/-/inherits-2.0.4.tgz",
+      "integrity": "sha512-k/vGaX4/Yla3WzyMCvTQOXYeIHvqOKtnqBduzTHpzpQZzAskKMhZ2K+EnBiSM9zGSoIFeMpXKxa4dYeZIQqewQ==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/ini": {
+      "version": "1.3.8",
+      "resolved": "https://registry.npmjs.org/ini/-/ini-1.3.8.tgz",
+      "integrity": "sha512-JV/yugV2uzW5iMRSiZAyDtQd+nxtUnjeLt0acNdw98kKLrvuRVyB80tsREOE7yvGVgalhZ6RNXCmEHkUKBKxew==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/is-extglob": {
+      "version": "2.1.1",
+      "resolved": "https://registry.npmjs.org/is-extglob/-/is-extglob-2.1.1.tgz",
+      "integrity": "sha512-SbKbANkN603Vi4jEZv49LeVJMn4yGwsbzZworEoyEiutsN3nJYdbO36zfhGJ6QEDpOZIFkDtnq5JRxmvl3jsoQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=0.10.0"
+      }
+    },
+    "node_modules/is-glob": {
+      "version": "4.0.3",
+      "resolved": "https://registry.npmjs.org/is-glob/-/is-glob-4.0.3.tgz",
+      "integrity": "sha512-xelSayHH36ZgE7ZWhli7pW34hNbNl8Ojv5KVmkJD4hBdD3th8Tfk9vYasLM+mXWOZhFkgZfxhLSnrwRr4elSSg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "is-extglob": "^2.1.1"
+      },
+      "engines": {
+        "node": ">=0.10.0"
+      }
+    },
+    "node_modules/is-number": {
+      "version": "7.0.0",
+      "resolved": "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz",
+      "integrity": "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=0.12.0"
+      }
+    },
+    "node_modules/is-path-inside": {
+      "version": "3.0.3",
+      "resolved": "https://registry.npmjs.org/is-path-inside/-/is-path-inside-3.0.3.tgz",
+      "integrity": "sha512-Fd4gABb+ycGAmKou8eMftCupSir5lRxqf4aD/vd0cD2qc4HL07OjCeuHMr8Ro4CoMaeCKDB0/ECBOVWjTwUvPQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/isexe": {
+      "version": "2.0.0",
+      "resolved": "https://registry.npmjs.org/isexe/-/isexe-2.0.0.tgz",
+      "integrity": "sha512-RHxMLp9lnKHGHRng9QFhRCMbYAcVpn69smSGcq3f36xjgVVWThj4qqLbTLlq7Ssj8B+fIQ1EuCEGI2lKsyQeIw==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/js-yaml": {
+      "version": "4.1.0",
+      "resolved": "https://registry.npmjs.org/js-yaml/-/js-yaml-4.1.0.tgz",
+      "integrity": "sha512-wpxZs9NoxZaJESJGIZTyDEaYpl0FKSA+FB9aJiyemKhMwkxQg63h4T1KJgUGHpTqPDNRcmmYLugrRjJlBtWvRA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "argparse": "^2.0.1"
+      },
+      "bin": {
+        "js-yaml": "bin/js-yaml.js"
+      }
+    },
+    "node_modules/json-buffer": {
+      "version": "3.0.1",
+      "resolved": "https://registry.npmjs.org/json-buffer/-/json-buffer-3.0.1.tgz",
+      "integrity": "sha512-4bV5BfR2mqfQTJm+V5tPPdf+ZpuhiIvTuAB5g8kcrXOZpTT/QwwVRWBywX1ozr6lEuPdbHxwaJlm9G6mI2sfSQ==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/json-schema-traverse": {
+      "version": "0.4.1",
+      "resolved": "https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-0.4.1.tgz",
+      "integrity": "sha512-xbbCH5dCYU5T8LcEhhuh7HJ88HXuW3qsI3Y0zOZFKfZEHcpWiHU/Jxzk629Brsab/mMiHQti9wMP+845RPe3Vg==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/json-stable-stringify-without-jsonify": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/json-stable-stringify-without-jsonify/-/json-stable-stringify-without-jsonify-1.0.1.tgz",
+      "integrity": "sha512-Bdboy+l7tA3OGW6FjyFHWkP5LuByj1Tk33Ljyq0axyzdk9//JSi2u3fP1QSmd1KNwq6VOKYGlAu87CisVir6Pw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/keytar": {
+      "version": "7.9.0",
+      "resolved": "https://registry.npmjs.org/keytar/-/keytar-7.9.0.tgz",
+      "integrity": "sha512-VPD8mtVtm5JNtA2AErl6Chp06JBfy7diFQ7TQQhdpWOl6MrCRB+eRbvAZUsbGQS9kiMq0coJsy0W0vHpDCkWsQ==",
+      "dev": true,
+      "hasInstallScript": true,
+      "license": "MIT",
+      "dependencies": {
+        "node-addon-api": "^4.3.0",
+        "prebuild-install": "^7.0.1"
+      }
+    },
+    "node_modules/keyv": {
+      "version": "4.5.4",
+      "resolved": "https://registry.npmjs.org/keyv/-/keyv-4.5.4.tgz",
+      "integrity": "sha512-oxVHkHR/EJf2CNXnWxRLW6mg7JyCCUcG0DtEGmL2ctUo1PNTin1PUil+r/+4r5MpVgC/fn1kjsx7mjSujKqIpw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "json-buffer": "3.0.1"
+      }
+    },
+    "node_modules/leven": {
+      "version": "3.1.0",
+      "resolved": "https://registry.npmjs.org/leven/-/leven-3.1.0.tgz",
+      "integrity": "sha512-qsda+H8jTaUaN/x5vzW2rzc+8Rw4TAQ/4KjB46IwK5VH+IlVeeeje/EoZRpiXvIqjFgK84QffqPztGI3VBLG1A==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=6"
+      }
+    },
+    "node_modules/levn": {
+      "version": "0.4.1",
+      "resolved": "https://registry.npmjs.org/levn/-/levn-0.4.1.tgz",
+      "integrity": "sha512-+bT2uH4E5LGE7h/n3evcS/sQlJXCpIp6ym8OWJ5eV6+67Dsql/LaaT7qJBAt2rzfoa/5QBGBhxDix1dMt2kQKQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "prelude-ls": "^1.2.1",
+        "type-check": "~0.4.0"
+      },
+      "engines": {
+        "node": ">= 0.8.0"
+      }
+    },
+    "node_modules/linkify-it": {
+      "version": "3.0.3",
+      "resolved": "https://registry.npmjs.org/linkify-it/-/linkify-it-3.0.3.tgz",
+      "integrity": "sha512-ynTsyrFSdE5oZ/O9GEf00kPngmOfVwazR5GKDq6EYfhlpFug3J2zybX56a2PRRpc9P+FuSoGNAwjlbDs9jJBPQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "uc.micro": "^1.0.1"
+      }
+    },
+    "node_modules/locate-path": {
+      "version": "6.0.0",
+      "resolved": "https://registry.npmjs.org/locate-path/-/locate-path-6.0.0.tgz",
+      "integrity": "sha512-iPZK6eYjbxRu3uB4/WZ3EsEIMJFMqAoopl3R+zuq0UjcAm/MO6KCweDgPfP3elTztoKP3KtnVHxTn2NHBSDVUw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "p-locate": "^5.0.0"
+      },
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/lodash.merge": {
+      "version": "4.6.2",
+      "resolved": "https://registry.npmjs.org/lodash.merge/-/lodash.merge-4.6.2.tgz",
+      "integrity": "sha512-0KpjqXRVvrYyCsX1swR/XTK0va6VQkQM6MNo7PqW77ByjAhoARA8EfrP1N4+KlKj8YS0ZUCtRT/YUuhyYDujIQ==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/lru-cache": {
+      "version": "6.0.0",
+      "resolved": "https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz",
+      "integrity": "sha512-Jo6dJ04CmSjuznwJSS3pUeWmd/H0ffTlkXXgwZi+eq1UCmqQwCh+eLsYOYCwY991i2Fah4h1BEMCx4qThGbsiA==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "yallist": "^4.0.0"
+      },
+      "engines": {
+        "node": ">=10"
+      }
+    },
+    "node_modules/markdown-it": {
+      "version": "12.3.2",
+      "resolved": "https://registry.npmjs.org/markdown-it/-/markdown-it-12.3.2.tgz",
+      "integrity": "sha512-TchMembfxfNVpHkbtriWltGWc+m3xszaRD0CZup7GFFhzIgQqxIfn3eGj1yZpfuflzPvfkt611B2Q/Bsk1YnGg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "argparse": "^2.0.1",
+        "entities": "~2.1.0",
+        "linkify-it": "^3.0.1",
+        "mdurl": "^1.0.1",
+        "uc.micro": "^1.0.5"
+      },
+      "bin": {
+        "markdown-it": "bin/markdown-it.js"
+      }
+    },
+    "node_modules/markdown-it/node_modules/entities": {
+      "version": "2.1.0",
+      "resolved": "https://registry.npmjs.org/entities/-/entities-2.1.0.tgz",
+      "integrity": "sha512-hCx1oky9PFrJ611mf0ifBLBRW8lUUVRlFolb5gWRfIELabBlbp9xZvrqZLZAs+NxFnbfQoeGd8wDkygjg7U85w==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "funding": {
+        "url": "https://github.com/fb55/entities?sponsor=1"
+      }
+    },
+    "node_modules/math-intrinsics": {
+      "version": "1.1.0",
+      "resolved": "https://registry.npmjs.org/math-intrinsics/-/math-intrinsics-1.1.0.tgz",
+      "integrity": "sha512-/IXtbwEk5HTPyEwyKX6hGkYXxM9nbj64B+ilVJnC/R6B0pH5G4V3b0pVbL7DBj4tkhBAppbQUlf6F6Xl9LHu1g==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 0.4"
+      }
+    },
+    "node_modules/mdurl": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/mdurl/-/mdurl-1.0.1.tgz",
+      "integrity": "sha512-/sKlQJCBYVY9Ers9hqzKou4H6V5UWc/M59TH2dvkt+84itfnq7uFOMLpOiOS4ujvHP4etln18fmIxA5R5fll0g==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/merge2": {
+      "version": "1.4.1",
+      "resolved": "https://registry.npmjs.org/merge2/-/merge2-1.4.1.tgz",
+      "integrity": "sha512-8q7VEgMJW4J8tcfVPy8g09NcQwZdbwFEqhe/WZkoIzjn/3TGDwtOCYtXGxA3O8tPzpczCCDgv+P2P5y00ZJOOg==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 8"
+      }
+    },
+    "node_modules/micromatch": {
+      "version": "4.0.8",
+      "resolved": "https://registry.npmjs.org/micromatch/-/micromatch-4.0.8.tgz",
+      "integrity": "sha512-PXwfBhYu0hBCPw8Dn0E+WDYb7af3dSLVWKi3HGv84IdF4TyFoC0ysxFd0Goxw7nSv4T/PzEJQxsYsEiFCKo2BA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "braces": "^3.0.3",
+        "picomatch": "^2.3.1"
+      },
+      "engines": {
+        "node": ">=8.6"
+      }
+    },
+    "node_modules/mime": {
+      "version": "1.6.0",
+      "resolved": "https://registry.npmjs.org/mime/-/mime-1.6.0.tgz",
+      "integrity": "sha512-x0Vn8spI+wuJ1O6S7gnbaQg8Pxh4NNHb7KSINmEWKiPE4RKOplvijn+NkmYmmRgP68mc70j2EbeTFRsrswaQeg==",
+      "dev": true,
+      "license": "MIT",
+      "bin": {
+        "mime": "cli.js"
+      },
+      "engines": {
+        "node": ">=4"
+      }
+    },
+    "node_modules/mimic-response": {
+      "version": "3.1.0",
+      "resolved": "https://registry.npmjs.org/mimic-response/-/mimic-response-3.1.0.tgz",
+      "integrity": "sha512-z0yWI+4FDrrweS8Zmt4Ej5HdJmky15+L2e6Wgn3+iK5fWzb6T3fhNFq2+MeTRb064c6Wr4N/wv0DzQTjNzHNGQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/minimatch": {
+      "version": "3.1.2",
+      "resolved": "https://registry.npmjs.org/minimatch/-/minimatch-3.1.2.tgz",
+      "integrity": "sha512-J7p63hRiAjw1NDEww1W7i37+ByIrOWO5XQQAzZ3VOcL0PNybwpfmV/N05zFAzwQ9USyEcX6t3UO+K5aqBQOIHw==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "brace-expansion": "^1.1.7"
+      },
+      "engines": {
+        "node": "*"
+      }
+    },
+    "node_modules/minimist": {
+      "version": "1.2.8",
+      "resolved": "https://registry.npmjs.org/minimist/-/minimist-1.2.8.tgz",
+      "integrity": "sha512-2yyAR8qBkN3YuheJanUpWC5U3bb5osDywNB8RzDVlDwDHbocAJveqqj1u8+SVD7jkWT4yvsHCpWqqWqAxb0zCA==",
+      "dev": true,
+      "license": "MIT",
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/mkdirp-classic": {
+      "version": "0.5.3",
+      "resolved": "https://registry.npmjs.org/mkdirp-classic/-/mkdirp-classic-0.5.3.tgz",
+      "integrity": "sha512-gKLcREMhtuZRwRAfqP3RFW+TK4JqApVBtOIftVgjuABpAtpxhPGaDcfvbhNvD0B8iD1oUr/txX35NjcaY6Ns/A==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/ms": {
+      "version": "2.1.3",
+      "resolved": "https://registry.npmjs.org/ms/-/ms-2.1.3.tgz",
+      "integrity": "sha512-6FlzubTLZG3J2a/NVCAleEhjzq5oxgHyaCU9yYXvcLsvoVaHJq/s5xXI6/XXP6tz7R9xAOtHnSO/tXtF3WRTlA==",
+      "license": "MIT"
+    },
+    "node_modules/mute-stream": {
+      "version": "0.0.8",
+      "resolved": "https://registry.npmjs.org/mute-stream/-/mute-stream-0.0.8.tgz",
+      "integrity": "sha512-nnbWWOkoWyUsTjKrhgD0dcz22mdkSnpYqbEjIm2nhwhuxlSkpywJmBo8h0ZqJdkp73mb90SssHkN4rsRaBAfAA==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/napi-build-utils": {
+      "version": "2.0.0",
+      "resolved": "https://registry.npmjs.org/napi-build-utils/-/napi-build-utils-2.0.0.tgz",
+      "integrity": "sha512-GEbrYkbfF7MoNaoh2iGG84Mnf/WZfB0GdGEsM8wz7Expx/LlWf5U8t9nvJKXSp3qr5IsEbK04cBGhol/KwOsWA==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/natural-compare": {
+      "version": "1.4.0",
+      "resolved": "https://registry.npmjs.org/natural-compare/-/natural-compare-1.4.0.tgz",
+      "integrity": "sha512-OWND8ei3VtNC9h7V60qff3SVobHr996CTwgxubgyQYEpg290h9J0buyECNNJexkFm5sOajh5G116RYA1c8ZMSw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/natural-compare-lite": {
+      "version": "1.4.0",
+      "resolved": "https://registry.npmjs.org/natural-compare-lite/-/natural-compare-lite-1.4.0.tgz",
+      "integrity": "sha512-Tj+HTDSJJKaZnfiuw+iaF9skdPpTo2GtEly5JHnWV/hfv2Qj/9RKsGISQtLh2ox3l5EAGw487hnBee0sIJ6v2g==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/node-abi": {
+      "version": "3.78.0",
+      "resolved": "https://registry.npmjs.org/node-abi/-/node-abi-3.78.0.tgz",
+      "integrity": "sha512-E2wEyrgX/CqvicaQYU3Ze1PFGjc4QYPGsjUrlYkqAE0WjHEZwgOsGMPMzkMse4LjJbDmaEuDX3CM036j5K2DSQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "semver": "^7.3.5"
+      },
+      "engines": {
+        "node": ">=10"
+      }
+    },
+    "node_modules/node-addon-api": {
+      "version": "4.3.0",
+      "resolved": "https://registry.npmjs.org/node-addon-api/-/node-addon-api-4.3.0.tgz",
+      "integrity": "sha512-73sE9+3UaLYYFmDsFZnqCInzPyh3MqIwZO9cw58yIqAZhONrrabrYyYe3TuIqtIiOuTXVhsGau8hcrhhwSsDIQ==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/nth-check": {
+      "version": "2.1.1",
+      "resolved": "https://registry.npmjs.org/nth-check/-/nth-check-2.1.1.tgz",
+      "integrity": "sha512-lqjrjmaOoAnWfMmBPL+XNnynZh2+swxiX3WUE0s4yEHI6m+AwrK2UZOimIRl3X/4QctVqS8AiZjFqyOGrMXb/w==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "boolbase": "^1.0.0"
+      },
+      "funding": {
+        "url": "https://github.com/fb55/nth-check?sponsor=1"
+      }
+    },
+    "node_modules/object-inspect": {
+      "version": "1.13.4",
+      "resolved": "https://registry.npmjs.org/object-inspect/-/object-inspect-1.13.4.tgz",
+      "integrity": "sha512-W67iLl4J2EXEGTbfeHCffrjDfitvLANg0UlX3wFUUSTx92KXRFegMHUVgSqE+wvhAbi4WqjGg9czysTV2Epbew==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/once": {
+      "version": "1.4.0",
+      "resolved": "https://registry.npmjs.org/once/-/once-1.4.0.tgz",
+      "integrity": "sha512-lNaJgI+2Q5URQBkccEKHTQOPaXdUxnZZElQTZY0MFUAuaEqe1E+Nyvgdz/aIyNi6Z9MzO5dv1H8n58/GELp3+w==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "wrappy": "1"
+      }
+    },
+    "node_modules/optionator": {
+      "version": "0.9.4",
+      "resolved": "https://registry.npmjs.org/optionator/-/optionator-0.9.4.tgz",
+      "integrity": "sha512-6IpQ7mKUxRcZNLIObR0hz7lxsapSSIYNZJwXPGeF0mTVqGKFIXj1DQcMoT22S3ROcLyY/rz0PWaWZ9ayWmad9g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "deep-is": "^0.1.3",
+        "fast-levenshtein": "^2.0.6",
+        "levn": "^0.4.1",
+        "prelude-ls": "^1.2.1",
+        "type-check": "^0.4.0",
+        "word-wrap": "^1.2.5"
+      },
+      "engines": {
+        "node": ">= 0.8.0"
+      }
+    },
+    "node_modules/p-limit": {
+      "version": "3.1.0",
+      "resolved": "https://registry.npmjs.org/p-limit/-/p-limit-3.1.0.tgz",
+      "integrity": "sha512-TYOanM3wGwNGsZN2cVTYPArw454xnXj5qmWF1bEoAc4+cU/ol7GVh7odevjp1FNHduHc3KZMcFduxU5Xc6uJRQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "yocto-queue": "^0.1.0"
+      },
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/p-locate": {
+      "version": "5.0.0",
+      "resolved": "https://registry.npmjs.org/p-locate/-/p-locate-5.0.0.tgz",
+      "integrity": "sha512-LaNjtRWUBY++zB5nE/NwcaoMylSPk+S+ZHNB1TzdbMJMny6dynpAGt7X/tl/QYq3TIeE6nxHppbo2LGymrG5Pw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "p-limit": "^3.0.2"
+      },
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/parent-module": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/parent-module/-/parent-module-1.0.1.tgz",
+      "integrity": "sha512-GQ2EWRpQV8/o+Aw8YqtfZZPfNRWZYkbidE9k5rpl/hC3vtHHBfGm2Ifi6qWV+coDGkrUKZAxE3Lot5kcsRlh+g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "callsites": "^3.0.0"
+      },
+      "engines": {
+        "node": ">=6"
+      }
+    },
+    "node_modules/parse-semver": {
+      "version": "1.1.1",
+      "resolved": "https://registry.npmjs.org/parse-semver/-/parse-semver-1.1.1.tgz",
+      "integrity": "sha512-Eg1OuNntBMH0ojvEKSrvDSnwLmvVuUOSdylH/pSCPNMIspLlweJyIWXCE+k/5hm3cj/EBUYwmWkjhBALNP4LXQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "semver": "^5.1.0"
+      }
+    },
+    "node_modules/parse-semver/node_modules/semver": {
+      "version": "5.7.2",
+      "resolved": "https://registry.npmjs.org/semver/-/semver-5.7.2.tgz",
+      "integrity": "sha512-cBznnQ9KjJqU67B52RMC65CMarK2600WFnbkcaiwWq3xy/5haFJlshgnpjovMVJ+Hff49d8GEn0b87C5pDQ10g==",
+      "dev": true,
+      "license": "ISC",
+      "bin": {
+        "semver": "bin/semver"
+      }
+    },
+    "node_modules/parse5": {
+      "version": "7.3.0",
+      "resolved": "https://registry.npmjs.org/parse5/-/parse5-7.3.0.tgz",
+      "integrity": "sha512-IInvU7fabl34qmi9gY8XOVxhYyMyuH2xUNpb2q8/Y+7552KlejkRvqvD19nMoUW/uQGGbqNpA6Tufu5FL5BZgw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "entities": "^6.0.0"
+      },
+      "funding": {
+        "url": "https://github.com/inikulin/parse5?sponsor=1"
+      }
+    },
+    "node_modules/parse5-htmlparser2-tree-adapter": {
+      "version": "7.1.0",
+      "resolved": "https://registry.npmjs.org/parse5-htmlparser2-tree-adapter/-/parse5-htmlparser2-tree-adapter-7.1.0.tgz",
+      "integrity": "sha512-ruw5xyKs6lrpo9x9rCZqZZnIUntICjQAd0Wsmp396Ul9lN/h+ifgVV1x1gZHi8euej6wTfpqX8j+BFQxF0NS/g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "domhandler": "^5.0.3",
+        "parse5": "^7.0.0"
+      },
+      "funding": {
+        "url": "https://github.com/inikulin/parse5?sponsor=1"
+      }
+    },
+    "node_modules/parse5-parser-stream": {
+      "version": "7.1.2",
+      "resolved": "https://registry.npmjs.org/parse5-parser-stream/-/parse5-parser-stream-7.1.2.tgz",
+      "integrity": "sha512-JyeQc9iwFLn5TbvvqACIF/VXG6abODeB3Fwmv/TGdLk2LfbWkaySGY72at4+Ty7EkPZj854u4CrICqNk2qIbow==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "parse5": "^7.0.0"
+      },
+      "funding": {
+        "url": "https://github.com/inikulin/parse5?sponsor=1"
+      }
+    },
+    "node_modules/parse5/node_modules/entities": {
+      "version": "6.0.1",
+      "resolved": "https://registry.npmjs.org/entities/-/entities-6.0.1.tgz",
+      "integrity": "sha512-aN97NXWF6AWBTahfVOIrB/NShkzi5H7F9r1s9mD3cDj4Ko5f2qhhVoYMibXF7GlLveb/D2ioWay8lxI97Ven3g==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "engines": {
+        "node": ">=0.12"
+      },
+      "funding": {
+        "url": "https://github.com/fb55/entities?sponsor=1"
+      }
+    },
+    "node_modules/path-exists": {
+      "version": "4.0.0",
+      "resolved": "https://registry.npmjs.org/path-exists/-/path-exists-4.0.0.tgz",
+      "integrity": "sha512-ak9Qy5Q7jYb2Wwcey5Fpvg2KoAc/ZIhLSLOSBmRmygPsGwkVVt0fZa0qrtMz+m6tJTAHfZQ8FnmB4MG4LWy7/w==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/path-is-absolute": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz",
+      "integrity": "sha512-AVbw3UJ2e9bq64vSaS9Am0fje1Pa8pbGqTTsmXfaIiMpnr5DlDhfJOuLj9Sf95ZPVDAUerDfEk88MPmPe7UCQg==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=0.10.0"
+      }
+    },
+    "node_modules/path-key": {
+      "version": "3.1.1",
+      "resolved": "https://registry.npmjs.org/path-key/-/path-key-3.1.1.tgz",
+      "integrity": "sha512-ojmeN0qd+y0jszEtoY48r0Peq5dwMEkIlCOu6Q5f41lfkswXuKtYrhgoTpLnyIcHm24Uhqx+5Tqm2InSwLhE6Q==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/path-type": {
+      "version": "4.0.0",
+      "resolved": "https://registry.npmjs.org/path-type/-/path-type-4.0.0.tgz",
+      "integrity": "sha512-gDKb8aZMDeD/tZWs9P6+q0J9Mwkdl6xMV8TjnGP3qJVJ06bdMgkbBlLU8IdfOsIsFz2BW1rNVT3XuNEl8zPAvw==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/pend": {
+      "version": "1.2.0",
+      "resolved": "https://registry.npmjs.org/pend/-/pend-1.2.0.tgz",
+      "integrity": "sha512-F3asv42UuXchdzt+xXqfW1OGlVBe+mxa2mqI0pg5yAHZPvFmY3Y6drSf/GQ1A86WgWEN9Kzh/WrgKa6iGcHXLg==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/picomatch": {
+      "version": "2.3.1",
+      "resolved": "https://registry.npmjs.org/picomatch/-/picomatch-2.3.1.tgz",
+      "integrity": "sha512-JU3teHTNjmE2VCGFzuY8EXzCDVwEqB2a8fsIvwaStHhAWJEeVd1o1QD80CU6+ZdEXXSLbSsuLwJjkCBWqRQUVA==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8.6"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/jonschlinkert"
+      }
+    },
+    "node_modules/prebuild-install": {
+      "version": "7.1.3",
+      "resolved": "https://registry.npmjs.org/prebuild-install/-/prebuild-install-7.1.3.tgz",
+      "integrity": "sha512-8Mf2cbV7x1cXPUILADGI3wuhfqWvtiLA1iclTDbFRZkgRQS0NqsPZphna9V+HyTEadheuPmjaJMsbzKQFOzLug==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "detect-libc": "^2.0.0",
+        "expand-template": "^2.0.3",
+        "github-from-package": "0.0.0",
+        "minimist": "^1.2.3",
+        "mkdirp-classic": "^0.5.3",
+        "napi-build-utils": "^2.0.0",
+        "node-abi": "^3.3.0",
+        "pump": "^3.0.0",
+        "rc": "^1.2.7",
+        "simple-get": "^4.0.0",
+        "tar-fs": "^2.0.0",
+        "tunnel-agent": "^0.6.0"
+      },
+      "bin": {
+        "prebuild-install": "bin.js"
+      },
+      "engines": {
+        "node": ">=10"
+      }
+    },
+    "node_modules/prelude-ls": {
+      "version": "1.2.1",
+      "resolved": "https://registry.npmjs.org/prelude-ls/-/prelude-ls-1.2.1.tgz",
+      "integrity": "sha512-vkcDPrRZo1QZLbn5RLGPpg/WmIQ65qoWWhcGKf/b5eplkkarX0m9z8ppCat4mlOqUsWpyNuYgO3VRyrYHSzX5g==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">= 0.8.0"
+      }
+    },
+    "node_modules/pump": {
+      "version": "3.0.3",
+      "resolved": "https://registry.npmjs.org/pump/-/pump-3.0.3.tgz",
+      "integrity": "sha512-todwxLMY7/heScKmntwQG8CXVkWUOdYxIvY2s0VWAAMh/nd8SoYiRaKjlr7+iCs984f2P8zvrfWcDDYVb73NfA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "end-of-stream": "^1.1.0",
+        "once": "^1.3.1"
+      }
+    },
+    "node_modules/punycode": {
+      "version": "2.3.1",
+      "resolved": "https://registry.npmjs.org/punycode/-/punycode-2.3.1.tgz",
+      "integrity": "sha512-vYt7UD1U9Wg6138shLtLOvdAu+8DsC/ilFtEVHcH+wydcSpNE20AfSOduf6MkRFahL5FY7X1oU7nKVZFtfq8Fg==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=6"
+      }
+    },
+    "node_modules/qs": {
+      "version": "6.14.0",
+      "resolved": "https://registry.npmjs.org/qs/-/qs-6.14.0.tgz",
+      "integrity": "sha512-YWWTjgABSKcvs/nWBi9PycY/JiPJqOD4JA6o9Sej2AtvSGarXxKC3OQSk4pAarbdQlKAh5D4FCQkJNkW+GAn3w==",
+      "dev": true,
+      "license": "BSD-3-Clause",
+      "dependencies": {
+        "side-channel": "^1.1.0"
+      },
+      "engines": {
+        "node": ">=0.6"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/queue-microtask": {
+      "version": "1.2.3",
+      "resolved": "https://registry.npmjs.org/queue-microtask/-/queue-microtask-1.2.3.tgz",
+      "integrity": "sha512-NuaNSa6flKT5JaSYQzJok04JzTL1CA6aGhv5rfLW3PgqA+M2ChpZQnAC8h8i4ZFkBS8X5RqkDBHA7r4hej3K9A==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/feross"
+        },
+        {
+          "type": "patreon",
+          "url": "https://www.patreon.com/feross"
+        },
+        {
+          "type": "consulting",
+          "url": "https://feross.org/support"
+        }
+      ],
+      "license": "MIT"
+    },
+    "node_modules/rc": {
+      "version": "1.2.8",
+      "resolved": "https://registry.npmjs.org/rc/-/rc-1.2.8.tgz",
+      "integrity": "sha512-y3bGgqKj3QBdxLbLkomlohkvsA8gdAiUQlSBJnBhfn+BPxg4bc62d8TcBW15wavDfgexCgccckhcZvywyQYPOw==",
+      "dev": true,
+      "license": "(BSD-2-Clause OR MIT OR Apache-2.0)",
+      "dependencies": {
+        "deep-extend": "^0.6.0",
+        "ini": "~1.3.0",
+        "minimist": "^1.2.0",
+        "strip-json-comments": "~2.0.1"
+      },
+      "bin": {
+        "rc": "cli.js"
+      }
+    },
+    "node_modules/rc/node_modules/strip-json-comments": {
+      "version": "2.0.1",
+      "resolved": "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz",
+      "integrity": "sha512-4gB8na07fecVVkOI6Rs4e7T6NOTki5EmL7TUduTs6bu3EdnSycntVJ4re8kgZA+wx9IueI2Y11bfbgwtzuE0KQ==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=0.10.0"
+      }
+    },
+    "node_modules/read": {
+      "version": "1.0.7",
+      "resolved": "https://registry.npmjs.org/read/-/read-1.0.7.tgz",
+      "integrity": "sha512-rSOKNYUmaxy0om1BNjMN4ezNT6VKK+2xF4GBhc81mkH7L60i6dp8qPYrkndNLT3QPphoII3maL9PVC9XmhHwVQ==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "mute-stream": "~0.0.4"
+      },
+      "engines": {
+        "node": ">=0.8"
+      }
+    },
+    "node_modules/readable-stream": {
+      "version": "3.6.2",
+      "resolved": "https://registry.npmjs.org/readable-stream/-/readable-stream-3.6.2.tgz",
+      "integrity": "sha512-9u/sniCrY3D5WdsERHzHE4G2YCXqoG5FTHUiCC4SIbr6XcLZBY05ya9EKjYek9O5xOAwjGq+1JdGBAS7Q9ScoA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "inherits": "^2.0.3",
+        "string_decoder": "^1.1.1",
+        "util-deprecate": "^1.0.1"
+      },
+      "engines": {
+        "node": ">= 6"
+      }
+    },
+    "node_modules/resolve-from": {
+      "version": "4.0.0",
+      "resolved": "https://registry.npmjs.org/resolve-from/-/resolve-from-4.0.0.tgz",
+      "integrity": "sha512-pb/MYmXstAkysRFx8piNI1tGFNQIFA3vkE3Gq4EuA1dF6gHp/+vgZqsCGJapvy8N3Q+4o7FwvquPJcnZ7RYy4g==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=4"
+      }
+    },
+    "node_modules/reusify": {
+      "version": "1.1.0",
+      "resolved": "https://registry.npmjs.org/reusify/-/reusify-1.1.0.tgz",
+      "integrity": "sha512-g6QUff04oZpHs0eG5p83rFLhHeV00ug/Yf9nZM6fLeUrPguBTkTQOdpAWWspMh55TZfVQDPaN3NQJfbVRAxdIw==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "iojs": ">=1.0.0",
+        "node": ">=0.10.0"
+      }
+    },
+    "node_modules/rimraf": {
+      "version": "3.0.2",
+      "resolved": "https://registry.npmjs.org/rimraf/-/rimraf-3.0.2.tgz",
+      "integrity": "sha512-JZkJMZkAGFFPP2YqXZXPbMlMBgsxzE8ILs4lMIX/2o0L9UBw9O/Y3o6wFw/i9YLapcUJWwqbi3kdxIPdC62TIA==",
+      "deprecated": "Rimraf versions prior to v4 are no longer supported",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "glob": "^7.1.3"
+      },
+      "bin": {
+        "rimraf": "bin.js"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/isaacs"
+      }
+    },
+    "node_modules/run-parallel": {
+      "version": "1.2.0",
+      "resolved": "https://registry.npmjs.org/run-parallel/-/run-parallel-1.2.0.tgz",
+      "integrity": "sha512-5l4VyZR86LZ/lDxZTR6jqL8AFE2S0IFLMP26AbjsLVADxHdhB/c0GUsH+y39UfCi3dzz8OlQuPmnaJOMoDHQBA==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/feross"
+        },
+        {
+          "type": "patreon",
+          "url": "https://www.patreon.com/feross"
+        },
+        {
+          "type": "consulting",
+          "url": "https://feross.org/support"
+        }
+      ],
+      "license": "MIT",
+      "dependencies": {
+        "queue-microtask": "^1.2.2"
+      }
+    },
+    "node_modules/safe-buffer": {
+      "version": "5.2.1",
+      "resolved": "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.2.1.tgz",
+      "integrity": "sha512-rp3So07KcdmmKbGvgaNxQSJr7bGVSVk5S9Eq1F+ppbRo70+YeaDxkw5Dd8NPN+GD6bjnYm2VuPuCXmpuYvmCXQ==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/feross"
+        },
+        {
+          "type": "patreon",
+          "url": "https://www.patreon.com/feross"
+        },
+        {
+          "type": "consulting",
+          "url": "https://feross.org/support"
+        }
+      ],
+      "license": "MIT"
+    },
+    "node_modules/safer-buffer": {
+      "version": "2.1.2",
+      "resolved": "https://registry.npmjs.org/safer-buffer/-/safer-buffer-2.1.2.tgz",
+      "integrity": "sha512-YZo3K82SD7Riyi0E1EQPojLz7kpepnSQI9IyPbHHg1XXXevb5dJI7tpyN2ADxGcQbHG7vcyRHk0cbwqcQriUtg==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/sax": {
+      "version": "1.4.1",
+      "resolved": "https://registry.npmjs.org/sax/-/sax-1.4.1.tgz",
+      "integrity": "sha512-+aWOz7yVScEGoKNd4PA10LZ8sk0A/z5+nXQG5giUO5rprX9jgYsTdov9qCchZiPIZezbZH+jRut8nPodFAX4Jg==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/semver": {
+      "version": "7.7.3",
+      "resolved": "https://registry.npmjs.org/semver/-/semver-7.7.3.tgz",
+      "integrity": "sha512-SdsKMrI9TdgjdweUSR9MweHA4EJ8YxHn8DFaDisvhVlUOe4BF1tLD7GAj0lIqWVl+dPb/rExr0Btby5loQm20Q==",
+      "dev": true,
+      "license": "ISC",
+      "bin": {
+        "semver": "bin/semver.js"
+      },
+      "engines": {
+        "node": ">=10"
+      }
+    },
+    "node_modules/shebang-command": {
+      "version": "2.0.0",
+      "resolved": "https://registry.npmjs.org/shebang-command/-/shebang-command-2.0.0.tgz",
+      "integrity": "sha512-kHxr2zZpYtdmrN1qDjrrX/Z1rR1kG8Dx+gkpK1G4eXmvXswmcE1hTWBWYUzlraYw1/yZp6YuDY77YtvbN0dmDA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "shebang-regex": "^3.0.0"
+      },
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/shebang-regex": {
+      "version": "3.0.0",
+      "resolved": "https://registry.npmjs.org/shebang-regex/-/shebang-regex-3.0.0.tgz",
+      "integrity": "sha512-7++dFhtcx3353uBaq8DDR4NuxBetBzC7ZQOhmTQInHEd6bSrXdiEyzCvG07Z44UYdLShWUyXt5M/yhz8ekcb1A==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/side-channel": {
+      "version": "1.1.0",
+      "resolved": "https://registry.npmjs.org/side-channel/-/side-channel-1.1.0.tgz",
+      "integrity": "sha512-ZX99e6tRweoUXqR+VBrslhda51Nh5MTQwou5tnUDgbtyM0dBgmhEDtWGP/xbKn6hqfPRHujUNwz5fy/wbbhnpw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "es-errors": "^1.3.0",
+        "object-inspect": "^1.13.3",
+        "side-channel-list": "^1.0.0",
+        "side-channel-map": "^1.0.1",
+        "side-channel-weakmap": "^1.0.2"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/side-channel-list": {
+      "version": "1.0.0",
+      "resolved": "https://registry.npmjs.org/side-channel-list/-/side-channel-list-1.0.0.tgz",
+      "integrity": "sha512-FCLHtRD/gnpCiCHEiJLOwdmFP+wzCmDEkc9y7NsYxeF4u7Btsn1ZuwgwJGxImImHicJArLP4R0yX4c2KCrMrTA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "es-errors": "^1.3.0",
+        "object-inspect": "^1.13.3"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/side-channel-map": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/side-channel-map/-/side-channel-map-1.0.1.tgz",
+      "integrity": "sha512-VCjCNfgMsby3tTdo02nbjtM/ewra6jPHmpThenkTYh8pG9ucZ/1P8So4u4FGBek/BjpOVsDCMoLA/iuBKIFXRA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "call-bound": "^1.0.2",
+        "es-errors": "^1.3.0",
+        "get-intrinsic": "^1.2.5",
+        "object-inspect": "^1.13.3"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/side-channel-weakmap": {
+      "version": "1.0.2",
+      "resolved": "https://registry.npmjs.org/side-channel-weakmap/-/side-channel-weakmap-1.0.2.tgz",
+      "integrity": "sha512-WPS/HvHQTYnHisLo9McqBHOJk2FkHO/tlpvldyrnem4aeQp4hai3gythswg6p01oSoTl58rcpiFAjF2br2Ak2A==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "call-bound": "^1.0.2",
+        "es-errors": "^1.3.0",
+        "get-intrinsic": "^1.2.5",
+        "object-inspect": "^1.13.3",
+        "side-channel-map": "^1.0.1"
+      },
+      "engines": {
+        "node": ">= 0.4"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/ljharb"
+      }
+    },
+    "node_modules/simple-concat": {
+      "version": "1.0.1",
+      "resolved": "https://registry.npmjs.org/simple-concat/-/simple-concat-1.0.1.tgz",
+      "integrity": "sha512-cSFtAPtRhljv69IK0hTVZQ+OfE9nePi/rtJmw5UjHeVyVroEqJXP1sFztKUy1qU+xvz3u/sfYJLa947b7nAN2Q==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/feross"
+        },
+        {
+          "type": "patreon",
+          "url": "https://www.patreon.com/feross"
+        },
+        {
+          "type": "consulting",
+          "url": "https://feross.org/support"
+        }
+      ],
+      "license": "MIT"
+    },
+    "node_modules/simple-get": {
+      "version": "4.0.1",
+      "resolved": "https://registry.npmjs.org/simple-get/-/simple-get-4.0.1.tgz",
+      "integrity": "sha512-brv7p5WgH0jmQJr1ZDDfKDOSeWWg+OVypG99A/5vYGPqJ6pxiaHLy8nxtFjBA7oMa01ebA9gfh1uMCFqOuXxvA==",
+      "dev": true,
+      "funding": [
+        {
+          "type": "github",
+          "url": "https://github.com/sponsors/feross"
+        },
+        {
+          "type": "patreon",
+          "url": "https://www.patreon.com/feross"
+        },
+        {
+          "type": "consulting",
+          "url": "https://feross.org/support"
+        }
+      ],
+      "license": "MIT",
+      "dependencies": {
+        "decompress-response": "^6.0.0",
+        "once": "^1.3.1",
+        "simple-concat": "^1.0.0"
+      }
+    },
+    "node_modules/simple-git": {
+      "version": "3.28.0",
+      "resolved": "https://registry.npmjs.org/simple-git/-/simple-git-3.28.0.tgz",
+      "integrity": "sha512-Rs/vQRwsn1ILH1oBUy8NucJlXmnnLeLCfcvbSehkPzbv3wwoFWIdtfd6Ndo6ZPhlPsCZ60CPI4rxurnwAa+a2w==",
+      "license": "MIT",
+      "dependencies": {
+        "@kwsites/file-exists": "^1.1.1",
+        "@kwsites/promise-deferred": "^1.1.1",
+        "debug": "^4.4.0"
+      },
+      "funding": {
+        "type": "github",
+        "url": "https://github.com/steveukx/git-js?sponsor=1"
+      }
+    },
+    "node_modules/slash": {
+      "version": "3.0.0",
+      "resolved": "https://registry.npmjs.org/slash/-/slash-3.0.0.tgz",
+      "integrity": "sha512-g9Q1haeby36OSStwb4ntCGGGaKsaVSjQ68fBxoQcutl5fS1vuY18H3wSt3jFyFtrkx+Kz0V1G85A4MyAdDMi2Q==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/string_decoder": {
+      "version": "1.3.0",
+      "resolved": "https://registry.npmjs.org/string_decoder/-/string_decoder-1.3.0.tgz",
+      "integrity": "sha512-hkRX8U1WjJFd8LsDJ2yQ/wWWxaopEsABU1XfkM8A+j0+85JAGppt16cr1Whg6KIbb4okU6Mql6BOj+uup/wKeA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "safe-buffer": "~5.2.0"
+      }
+    },
+    "node_modules/strip-ansi": {
+      "version": "6.0.1",
+      "resolved": "https://registry.npmjs.org/strip-ansi/-/strip-ansi-6.0.1.tgz",
+      "integrity": "sha512-Y38VPSHcqkFrCpFnQ9vuSXmquuv5oXOKpGeT6aGrr3o3Gc9AlVa6JBfUSOCnbxGGZF+/0ooI7KrPuUSztUdU5A==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "ansi-regex": "^5.0.1"
+      },
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/strip-json-comments": {
+      "version": "3.1.1",
+      "resolved": "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-3.1.1.tgz",
+      "integrity": "sha512-6fPc+R4ihwqP6N/aIv2f1gMH8lOVtWQHoqC4yK6oSDVVocumAsfCqjkXnqiYMhmMwS/mEHLp7Vehlt3ql6lEig==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=8"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/supports-color": {
+      "version": "7.2.0",
+      "resolved": "https://registry.npmjs.org/supports-color/-/supports-color-7.2.0.tgz",
+      "integrity": "sha512-qpCAvRl9stuOHveKsn7HncJRvv501qIacKzQlO/+Lwxc9+0q2wLyv4Dfvt80/DPn2pqOBsJdDiogXGR9+OvwRw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "has-flag": "^4.0.0"
+      },
+      "engines": {
+        "node": ">=8"
+      }
+    },
+    "node_modules/tar-fs": {
+      "version": "2.1.4",
+      "resolved": "https://registry.npmjs.org/tar-fs/-/tar-fs-2.1.4.tgz",
+      "integrity": "sha512-mDAjwmZdh7LTT6pNleZ05Yt65HC3E+NiQzl672vQG38jIrehtJk/J3mNwIg+vShQPcLF/LV7CMnDW6vjj6sfYQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "chownr": "^1.1.1",
+        "mkdirp-classic": "^0.5.2",
+        "pump": "^3.0.0",
+        "tar-stream": "^2.1.4"
+      }
+    },
+    "node_modules/tar-stream": {
+      "version": "2.2.0",
+      "resolved": "https://registry.npmjs.org/tar-stream/-/tar-stream-2.2.0.tgz",
+      "integrity": "sha512-ujeqbceABgwMZxEJnk2HDY2DlnUZ+9oEcb1KzTVfYHio0UE6dG71n60d8D2I4qNvleWrrXpmjpt7vZeF1LnMZQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "bl": "^4.0.3",
+        "end-of-stream": "^1.4.1",
+        "fs-constants": "^1.0.0",
+        "inherits": "^2.0.3",
+        "readable-stream": "^3.1.1"
+      },
+      "engines": {
+        "node": ">=6"
+      }
+    },
+    "node_modules/text-table": {
+      "version": "0.2.0",
+      "resolved": "https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz",
+      "integrity": "sha512-N+8UisAXDGk8PFXP4HAzVR9nbfmVJ3zYLAWiTIoqC5v5isinhr+r5uaO8+7r3BMfuNIufIsA7RdpVgacC2cSpw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/tmp": {
+      "version": "0.2.5",
+      "resolved": "https://registry.npmjs.org/tmp/-/tmp-0.2.5.tgz",
+      "integrity": "sha512-voyz6MApa1rQGUxT3E+BK7/ROe8itEx7vD8/HEvt4xwXucvQ5G5oeEiHkmHZJuBO21RpOf+YYm9MOivj709jow==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=14.14"
+      }
+    },
+    "node_modules/to-regex-range": {
+      "version": "5.0.1",
+      "resolved": "https://registry.npmjs.org/to-regex-range/-/to-regex-range-5.0.1.tgz",
+      "integrity": "sha512-65P7iz6X5yEr1cwcgvQxbbIw7Uk3gOy5dIdtZ4rDveLqhrdJP+Li/Hx6tyK0NEb+2GCyneCMJiGqrADCSNk8sQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "is-number": "^7.0.0"
+      },
+      "engines": {
+        "node": ">=8.0"
+      }
+    },
+    "node_modules/tslib": {
+      "version": "1.14.1",
+      "resolved": "https://registry.npmjs.org/tslib/-/tslib-1.14.1.tgz",
+      "integrity": "sha512-Xni35NKzjgMrwevysHTCArtLDpPvye8zV/0E4EyYn43P7/7qvQwPh9BGkHewbMulVntbigmcT7rdX3BNo9wRJg==",
+      "dev": true,
+      "license": "0BSD"
+    },
+    "node_modules/tsutils": {
+      "version": "3.21.0",
+      "resolved": "https://registry.npmjs.org/tsutils/-/tsutils-3.21.0.tgz",
+      "integrity": "sha512-mHKK3iUXL+3UF6xL5k0PEhKRUBKPBCv/+RkEOpjRWxxx27KKRBmmA60A9pgOUvMi8GKhRMPEmjBRPzs2W7O1OA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "tslib": "^1.8.1"
+      },
+      "engines": {
+        "node": ">= 6"
+      },
+      "peerDependencies": {
+        "typescript": ">=2.8.0 || >= 3.2.0-dev || >= 3.3.0-dev || >= 3.4.0-dev || >= 3.5.0-dev || >= 3.6.0-dev || >= 3.6.0-beta || >= 3.7.0-dev || >= 3.7.0-beta"
+      }
+    },
+    "node_modules/tunnel": {
+      "version": "0.0.6",
+      "resolved": "https://registry.npmjs.org/tunnel/-/tunnel-0.0.6.tgz",
+      "integrity": "sha512-1h/Lnq9yajKY2PEbBadPXj3VxsDDu844OnaAo52UVmIzIvwwtBPIuNvkjuzBlTWpfJyUbG3ez0KSBibQkj4ojg==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=0.6.11 <=0.7.0 || >=0.7.3"
+      }
+    },
+    "node_modules/tunnel-agent": {
+      "version": "0.6.0",
+      "resolved": "https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz",
+      "integrity": "sha512-McnNiV1l8RYeY8tBgEpuodCC1mLUdbSN+CYBL7kJsJNInOP8UjDDEwdk6Mw60vdLLrr5NHKZhMAOSrR2NZuQ+w==",
+      "dev": true,
+      "license": "Apache-2.0",
+      "dependencies": {
+        "safe-buffer": "^5.0.1"
+      },
+      "engines": {
+        "node": "*"
+      }
+    },
+    "node_modules/type-check": {
+      "version": "0.4.0",
+      "resolved": "https://registry.npmjs.org/type-check/-/type-check-0.4.0.tgz",
+      "integrity": "sha512-XleUoc9uwGXqjWwXaUTZAmzMcFZ5858QA2vvx1Ur5xIcixXIP+8LnFDgRplU30us6teqdlskFfu+ae4K79Ooew==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "prelude-ls": "^1.2.1"
+      },
+      "engines": {
+        "node": ">= 0.8.0"
+      }
+    },
+    "node_modules/type-fest": {
+      "version": "0.20.2",
+      "resolved": "https://registry.npmjs.org/type-fest/-/type-fest-0.20.2.tgz",
+      "integrity": "sha512-Ne+eE4r0/iWnpAxD852z3A+N0Bt5RN//NjJwRd2VFHEmrywxf5vsZlh4R6lixl6B+wz/8d+maTSAkN1FIkI3LQ==",
+      "dev": true,
+      "license": "(MIT OR CC0-1.0)",
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    },
+    "node_modules/typed-rest-client": {
+      "version": "1.8.11",
+      "resolved": "https://registry.npmjs.org/typed-rest-client/-/typed-rest-client-1.8.11.tgz",
+      "integrity": "sha512-5UvfMpd1oelmUPRbbaVnq+rHP7ng2cE4qoQkQeAqxRL6PklkxsM0g32/HL0yfvruK6ojQ5x8EE+HF4YV6DtuCA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "qs": "^6.9.1",
+        "tunnel": "0.0.6",
+        "underscore": "^1.12.1"
+      }
+    },
+    "node_modules/typescript": {
+      "version": "4.9.5",
+      "resolved": "https://registry.npmjs.org/typescript/-/typescript-4.9.5.tgz",
+      "integrity": "sha512-1FXk9E2Hm+QzZQ7z+McJiHL4NW1F2EzMu9Nq9i3zAaGqibafqYwCVU6WyWAuyQRRzOlxou8xZSyXLEN8oKj24g==",
+      "dev": true,
+      "license": "Apache-2.0",
+      "bin": {
+        "tsc": "bin/tsc",
+        "tsserver": "bin/tsserver"
+      },
+      "engines": {
+        "node": ">=4.2.0"
+      }
+    },
+    "node_modules/uc.micro": {
+      "version": "1.0.6",
+      "resolved": "https://registry.npmjs.org/uc.micro/-/uc.micro-1.0.6.tgz",
+      "integrity": "sha512-8Y75pvTYkLJW2hWQHXxoqRgV7qb9B+9vFEtidML+7koHUFapnVJAZ6cKs+Qjz5Aw3aZWHMC6u0wJE3At+nSGwA==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/underscore": {
+      "version": "1.13.7",
+      "resolved": "https://registry.npmjs.org/underscore/-/underscore-1.13.7.tgz",
+      "integrity": "sha512-GMXzWtsc57XAtguZgaQViUOzs0KTkk8ojr3/xAxXLITqf/3EMwxC0inyETfDFjH/Krbhuep0HNbbjI9i/q3F3g==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/undici": {
+      "version": "7.16.0",
+      "resolved": "https://registry.npmjs.org/undici/-/undici-7.16.0.tgz",
+      "integrity": "sha512-QEg3HPMll0o3t2ourKwOeUAZ159Kn9mx5pnzHRQO8+Wixmh88YdZRiIwat0iNzNNXn0yoEtXJqFpyW7eM8BV7g==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=20.18.1"
+      }
+    },
+    "node_modules/uri-js": {
+      "version": "4.4.1",
+      "resolved": "https://registry.npmjs.org/uri-js/-/uri-js-4.4.1.tgz",
+      "integrity": "sha512-7rKUyy33Q1yc98pQ1DAmLtwX109F7TIfWlW1Ydo8Wl1ii1SeHieeh0HHfPeL2fMXK6z0s8ecKs9frCuLJvndBg==",
+      "dev": true,
+      "license": "BSD-2-Clause",
+      "dependencies": {
+        "punycode": "^2.1.0"
+      }
+    },
+    "node_modules/url-join": {
+      "version": "4.0.1",
+      "resolved": "https://registry.npmjs.org/url-join/-/url-join-4.0.1.tgz",
+      "integrity": "sha512-jk1+QP6ZJqyOiuEI9AEWQfju/nB2Pw466kbA0LEZljHwKeMgd9WrAEgEGxjPDD2+TNbbb37rTyhEfrCXfuKXnA==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/util-deprecate": {
+      "version": "1.0.2",
+      "resolved": "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz",
+      "integrity": "sha512-EPD5q1uXyFxJpCrLnCc1nHnq3gOa6DZBocAIiI2TaSCA7VCJ1UJDMagCzIkXNsUYfD1daK//LTEQ8xiIbrHtcw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/vsce": {
+      "version": "2.15.0",
+      "resolved": "https://registry.npmjs.org/vsce/-/vsce-2.15.0.tgz",
+      "integrity": "sha512-P8E9LAZvBCQnoGoizw65JfGvyMqNGlHdlUXD1VAuxtvYAaHBKLBdKPnpy60XKVDAkQCfmMu53g+gq9FM+ydepw==",
+      "deprecated": "vsce has been renamed to @vscode/vsce. Install using @vscode/vsce instead.",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "azure-devops-node-api": "^11.0.1",
+        "chalk": "^2.4.2",
+        "cheerio": "^1.0.0-rc.9",
+        "commander": "^6.1.0",
+        "glob": "^7.0.6",
+        "hosted-git-info": "^4.0.2",
+        "keytar": "^7.7.0",
+        "leven": "^3.1.0",
+        "markdown-it": "^12.3.2",
+        "mime": "^1.3.4",
+        "minimatch": "^3.0.3",
+        "parse-semver": "^1.1.1",
+        "read": "^1.0.7",
+        "semver": "^5.1.0",
+        "tmp": "^0.2.1",
+        "typed-rest-client": "^1.8.4",
+        "url-join": "^4.0.1",
+        "xml2js": "^0.4.23",
+        "yauzl": "^2.3.1",
+        "yazl": "^2.2.2"
+      },
+      "bin": {
+        "vsce": "vsce"
+      },
+      "engines": {
+        "node": ">= 14"
+      }
+    },
+    "node_modules/vsce/node_modules/ansi-styles": {
+      "version": "3.2.1",
+      "resolved": "https://registry.npmjs.org/ansi-styles/-/ansi-styles-3.2.1.tgz",
+      "integrity": "sha512-VT0ZI6kZRdTh8YyJw3SMbYm/u+NqfsAxEpWO0Pf9sq8/e94WxxOpPKx9FR1FlyCtOVDNOQ+8ntlqFxiRc+r5qA==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "color-convert": "^1.9.0"
+      },
+      "engines": {
+        "node": ">=4"
+      }
+    },
+    "node_modules/vsce/node_modules/chalk": {
+      "version": "2.4.2",
+      "resolved": "https://registry.npmjs.org/chalk/-/chalk-2.4.2.tgz",
+      "integrity": "sha512-Mti+f9lpJNcwF4tWV8/OrTTtF1gZi+f8FqlyAdouralcFWFQWF2+NgCHShjkCb+IFBLq9buZwE1xckQU4peSuQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "ansi-styles": "^3.2.1",
+        "escape-string-regexp": "^1.0.5",
+        "supports-color": "^5.3.0"
+      },
+      "engines": {
+        "node": ">=4"
+      }
+    },
+    "node_modules/vsce/node_modules/color-convert": {
+      "version": "1.9.3",
+      "resolved": "https://registry.npmjs.org/color-convert/-/color-convert-1.9.3.tgz",
+      "integrity": "sha512-QfAUtd+vFdAtFQcC8CCyYt1fYWxSqAiK2cSD6zDB8N3cpsEBAvRxp9zOGg6G/SHHJYAT88/az/IuDGALsNVbGg==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "color-name": "1.1.3"
+      }
+    },
+    "node_modules/vsce/node_modules/color-name": {
+      "version": "1.1.3",
+      "resolved": "https://registry.npmjs.org/color-name/-/color-name-1.1.3.tgz",
+      "integrity": "sha512-72fSenhMw2HZMTVHeCA9KCmpEIbzWiQsjN+BHcBbS9vr1mtt+vJjPdksIBNUmKAW8TFUDPJK5SUU3QhE9NEXDw==",
+      "dev": true,
+      "license": "MIT"
+    },
+    "node_modules/vsce/node_modules/escape-string-regexp": {
+      "version": "1.0.5",
+      "resolved": "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz",
+      "integrity": "sha512-vbRorB5FUQWvla16U8R/qgaFIya2qGzwDrNmCZuYKrbdSUMG6I1ZCGQRefkRVhuOkIGVne7BQ35DSfo1qvJqFg==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=0.8.0"
+      }
+    },
+    "node_modules/vsce/node_modules/has-flag": {
+      "version": "3.0.0",
+      "resolved": "https://registry.npmjs.org/has-flag/-/has-flag-3.0.0.tgz",
+      "integrity": "sha512-sKJf1+ceQBr4SMkvQnBDNDtf4TXpVhVGateu0t918bl30FnbE2m4vNLX+VWe/dpjlb+HugGYzW7uQXH98HPEYw==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=4"
+      }
+    },
+    "node_modules/vsce/node_modules/semver": {
+      "version": "5.7.2",
+      "resolved": "https://registry.npmjs.org/semver/-/semver-5.7.2.tgz",
+      "integrity": "sha512-cBznnQ9KjJqU67B52RMC65CMarK2600WFnbkcaiwWq3xy/5haFJlshgnpjovMVJ+Hff49d8GEn0b87C5pDQ10g==",
+      "dev": true,
+      "license": "ISC",
+      "bin": {
+        "semver": "bin/semver"
+      }
+    },
+    "node_modules/vsce/node_modules/supports-color": {
+      "version": "5.5.0",
+      "resolved": "https://registry.npmjs.org/supports-color/-/supports-color-5.5.0.tgz",
+      "integrity": "sha512-QjVjwdXIt408MIiAqCX4oUKsgU2EqAGzs2Ppkm4aQYbjm+ZEWEcW4SfFNTr4uMNZma0ey4f5lgLrkB0aX0QMow==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "has-flag": "^3.0.0"
+      },
+      "engines": {
+        "node": ">=4"
+      }
+    },
+    "node_modules/whatwg-encoding": {
+      "version": "3.1.1",
+      "resolved": "https://registry.npmjs.org/whatwg-encoding/-/whatwg-encoding-3.1.1.tgz",
+      "integrity": "sha512-6qN4hJdMwfYBtE3YBTTHhoeuUrDBPZmbQaxWAqSALV/MeEnR5z1xd8UKud2RAkFoPkmB+hli1TZSnyi84xz1vQ==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "iconv-lite": "0.6.3"
+      },
+      "engines": {
+        "node": ">=18"
+      }
+    },
+    "node_modules/whatwg-mimetype": {
+      "version": "4.0.0",
+      "resolved": "https://registry.npmjs.org/whatwg-mimetype/-/whatwg-mimetype-4.0.0.tgz",
+      "integrity": "sha512-QaKxh0eNIi2mE9p2vEdzfagOKHCcj1pJ56EEHGQOVxp8r9/iszLUUV7v89x9O1p/T+NlTM5W7jW6+cz4Fq1YVg==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=18"
+      }
+    },
+    "node_modules/which": {
+      "version": "2.0.2",
+      "resolved": "https://registry.npmjs.org/which/-/which-2.0.2.tgz",
+      "integrity": "sha512-BLI3Tl1TW3Pvl70l3yq3Y64i+awpwXqsGBYWkkqMtnbXgrMD+yj7rhW0kuEDxzJaYXGjEW5ogapKNMEKNMjibA==",
+      "dev": true,
+      "license": "ISC",
+      "dependencies": {
+        "isexe": "^2.0.0"
+      },
+      "bin": {
+        "node-which": "bin/node-which"
+      },
+      "engines": {
+        "node": ">= 8"
+      }
+    },
+    "node_modules/word-wrap": {
+      "version": "1.2.5",
+      "resolved": "https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.5.tgz",
+      "integrity": "sha512-BN22B5eaMMI9UMtjrGd5g5eCYPpCPDUy0FJXbYsaT5zYxjFOckS53SQDE3pWkVoWpHXVb3BrYcEN4Twa55B5cA==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=0.10.0"
+      }
+    },
+    "node_modules/wrappy": {
+      "version": "1.0.2",
+      "resolved": "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz",
+      "integrity": "sha512-l4Sp/DRseor9wL6EvV2+TuQn63dMkPjZ/sp9XkghTEbV9KlPS1xUsZ3u7/IQO4wxtcFB4bgpQPRcR3QCvezPcQ==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/xml2js": {
+      "version": "0.4.23",
+      "resolved": "https://registry.npmjs.org/xml2js/-/xml2js-0.4.23.tgz",
+      "integrity": "sha512-ySPiMjM0+pLDftHgXY4By0uswI3SPKLDw/i3UXbnO8M/p28zqexCUoPmQFrYD+/1BzhGJSs2i1ERWKJAtiLrug==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "sax": ">=0.6.0",
+        "xmlbuilder": "~11.0.0"
+      },
+      "engines": {
+        "node": ">=4.0.0"
+      }
+    },
+    "node_modules/xmlbuilder": {
+      "version": "11.0.1",
+      "resolved": "https://registry.npmjs.org/xmlbuilder/-/xmlbuilder-11.0.1.tgz",
+      "integrity": "sha512-fDlsI/kFEx7gLvbecc0/ohLG50fugQp8ryHzMTuW9vSa1GJ0XYWKnhsUx7oie3G98+r56aTQIUB4kht42R3JvA==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=4.0"
+      }
+    },
+    "node_modules/yallist": {
+      "version": "4.0.0",
+      "resolved": "https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz",
+      "integrity": "sha512-3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==",
+      "dev": true,
+      "license": "ISC"
+    },
+    "node_modules/yauzl": {
+      "version": "2.10.0",
+      "resolved": "https://registry.npmjs.org/yauzl/-/yauzl-2.10.0.tgz",
+      "integrity": "sha512-p4a9I6X6nu6IhoGmBqAcbJy1mlC4j27vEPZX9F4L4/vZT3Lyq1VkFHw/V/PUcB9Buo+DG3iHkT0x3Qya58zc3g==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "buffer-crc32": "~0.2.3",
+        "fd-slicer": "~1.1.0"
+      }
+    },
+    "node_modules/yazl": {
+      "version": "2.5.1",
+      "resolved": "https://registry.npmjs.org/yazl/-/yazl-2.5.1.tgz",
+      "integrity": "sha512-phENi2PLiHnHb6QBVot+dJnaAZ0xosj7p3fWl+znIjBDlnMI2PsZCJZ306BPTFOaHf5qdDEI8x5qFrSOBN5vrw==",
+      "dev": true,
+      "license": "MIT",
+      "dependencies": {
+        "buffer-crc32": "~0.2.3"
+      }
+    },
+    "node_modules/yocto-queue": {
+      "version": "0.1.0",
+      "resolved": "https://registry.npmjs.org/yocto-queue/-/yocto-queue-0.1.0.tgz",
+      "integrity": "sha512-rVksvsnNCdJ/ohGc6xgPwyN8eheCxsiLM8mxuE/t/mOVqJewPuO1miLpTHQiRgTKCLexL4MeAFVagts7HmNZ2Q==",
+      "dev": true,
+      "license": "MIT",
+      "engines": {
+        "node": ">=10"
+      },
+      "funding": {
+        "url": "https://github.com/sponsors/sindresorhus"
+      }
+    }
+  }
+}
```


### 📄 `vscode-extension/package.json`

**Type:** Configuration/Data

```diff
diff --git c/vscode-extension/package.json i/vscode-extension/package.json
new file mode 100644
index 0000000..5e42a37
--- /dev/null
+++ i/vscode-extension/package.json
@@ -0,0 +1,178 @@
+{
+  "name": "ai-visual-code-review",
+  "displayName": "AI Visual Code Review",
+  "description": "Comprehensive visual code review system with AI integration for Git repositories",
+  "version": "1.0.0",
+  "publisher": "ai-code-review",
+  "engines": {
+    "vscode": "^1.74.0"
+  },
+  "categories": [
+    "Other",
+    "SCM Providers"
+  ],
+  "keywords": [
+    "code-review",
+    "git",
+    "ai",
+    "visual",
+    "diff",
+    "github",
+    "development",
+    "quality"
+  ],
+  "activationEvents": [
+    "onCommand:aiCodeReview.openReview",
+    "onCommand:aiCodeReview.exportForAI",
+    "onCommand:aiCodeReview.quickReview"
+  ],
+  "main": "./out/extension.js",
+  "contributes": {
+    "commands": [
+      {
+        "command": "aiCodeReview.openReview",
+        "title": "Open AI Code Review",
+        "category": "AI Code Review",
+        "icon": "$(search-view-icon)"
+      },
+      {
+        "command": "aiCodeReview.exportForAI",
+        "title": "Export for AI Review",
+        "category": "AI Code Review",
+        "icon": "$(export)"
+      },
+      {
+        "command": "aiCodeReview.quickReview",
+        "title": "Quick AI Review",
+        "category": "AI Code Review",
+        "icon": "$(zap)"
+      },
+      {
+        "command": "aiCodeReview.refreshFiles",
+        "title": "Refresh Staged Files",
+        "category": "AI Code Review",
+        "icon": "$(refresh)"
+      }
+    ],
+    "menus": {
+      "commandPalette": [
+        {
+          "command": "aiCodeReview.openReview",
+          "when": "gitOpenRepositoryCount != 0"
+        },
+        {
+          "command": "aiCodeReview.exportForAI",
+          "when": "gitOpenRepositoryCount != 0"
+        },
+        {
+          "command": "aiCodeReview.quickReview",
+          "when": "gitOpenRepositoryCount != 0"
+        }
+      ],
+      "scm/title": [
+        {
+          "command": "aiCodeReview.openReview",
+          "group": "navigation",
+          "when": "scmProvider == git"
+        },
+        {
+          "command": "aiCodeReview.exportForAI",
+          "group": "1_modification",
+          "when": "scmProvider == git"
+        }
+      ],
+      "view/title": [
+        {
+          "command": "aiCodeReview.refreshFiles",
+          "when": "view == aiCodeReviewView",
+          "group": "navigation"
+        }
+      ]
+    },
+    "views": {
+      "scm": [
+        {
+          "id": "aiCodeReviewView",
+          "name": "AI Code Review",
+          "when": "gitOpenRepositoryCount != 0"
+        }
+      ]
+    },
+    "viewsContainers": {
+      "activitybar": [
+        {
+          "id": "aiCodeReview",
+          "title": "AI Code Review",
+          "icon": "$(search-view-icon)"
+        }
+      ]
+    },
+    "configuration": {
+      "title": "AI Code Review",
+      "properties": {
+        "aiCodeReview.autoRefresh": {
+          "type": "boolean",
+          "default": true,
+          "description": "Automatically refresh staged files when git status changes"
+        },
+        "aiCodeReview.showLineNumbers": {
+          "type": "boolean",
+          "default": true,
+          "description": "Show line numbers in diff view"
+        },
+        "aiCodeReview.maxFileSize": {
+          "type": "number",
+          "default": 10000,
+          "description": "Maximum file size to process (in KB)"
+        },
+        "aiCodeReview.excludePatterns": {
+          "type": "array",
+          "default": [
+            "node_modules/**",
+            "dist/**",
+            "build/**",
+            "*.log",
+            "package-lock.json"
+          ],
+          "description": "File patterns to exclude from review"
+        }
+      }
+    }
+  },
+  "scripts": {
+    "vscode:prepublish": "npm run compile",
+    "compile": "tsc -p ./",
+    "watch": "tsc -watch -p ./",
+    "pretest": "npm run compile && npm run lint",
+    "lint": "eslint src --ext ts",
+    "test": "node ./out/test/runTest.js",
+    "package": "vsce package",
+    "publish": "vsce publish"
+  },
+  "devDependencies": {
+    "@types/vscode": "^1.74.0",
+    "@types/node": "16.x",
+    "@typescript-eslint/eslint-plugin": "^5.45.0",
+    "@typescript-eslint/parser": "^5.45.0",
+    "eslint": "^8.28.0",
+    "typescript": "^4.9.4",
+    "vsce": "^2.15.0"
+  },
+  "dependencies": {
+    "simple-git": "^3.19.1"
+  },
+  "repository": {
+    "type": "git",
+    "url": "https://github.com/PrakharMNNIT/ai-visual-code-review.git"
+  },
+  "bugs": {
+    "url": "https://github.com/PrakharMNNIT/ai-visual-code-review/issues"
+  },
+  "homepage": "https://github.com/PrakharMNNIT/ai-visual-code-review#readme",
+  "license": "MIT",
+  "icon": "resources/icon.png",
+  "galleryBanner": {
+    "color": "#1e1e1e",
+    "theme": "dark"
+  }
+}
```


### 📄 `vscode-extension/src/extension.ts`

**Type:** TypeScript/React Component

```diff
diff --git c/vscode-extension/src/extension.ts i/vscode-extension/src/extension.ts
new file mode 100644
index 0000000..fb74960
--- /dev/null
+++ i/vscode-extension/src/extension.ts
@@ -0,0 +1,302 @@
+import * as vscode from 'vscode';
+import * as path from 'path';
+import { GitService } from './services/gitService';
+import { DiffService } from './services/diffService';
+import { ReviewWebviewProvider } from './webview/reviewWebviewProvider';
+import { StagedFilesProvider } from './providers/stagedFilesProvider';
+
+export function activate(context: vscode.ExtensionContext) {
+    console.log('AI Visual Code Review extension is now active!');
+
+    // Initialize services
+    const gitService = new GitService();
+    const diffService = new DiffService();
+
+    // Initialize providers
+    const stagedFilesProvider = new StagedFilesProvider(gitService);
+    const reviewWebviewProvider = new ReviewWebviewProvider(context, gitService, diffService);
+
+    // Register tree data provider
+    vscode.window.createTreeView('aiCodeReviewView', {
+        treeDataProvider: stagedFilesProvider,
+        showCollapseAll: true
+    });
+
+    // Register webview provider
+    context.subscriptions.push(
+        vscode.window.registerWebviewViewProvider('aiCodeReviewWebview', reviewWebviewProvider)
+    );
+
+    // Register commands
+    const commands = [
+        vscode.commands.registerCommand('aiCodeReview.openReview', async () => {
+            await openReviewCommand(reviewWebviewProvider);
+        }),
+
+        vscode.commands.registerCommand('aiCodeReview.exportForAI', async () => {
+            await exportForAICommand(gitService, diffService);
+        }),
+
+        vscode.commands.registerCommand('aiCodeReview.quickReview', async () => {
+            await quickReviewCommand(gitService, diffService);
+        }),
+
+        vscode.commands.registerCommand('aiCodeReview.refreshFiles', () => {
+            stagedFilesProvider.refresh();
+        })
+    ];
+
+    context.subscriptions.push(...commands);
+
+    // Auto-refresh on git changes if enabled
+    const config = vscode.workspace.getConfiguration('aiCodeReview');
+    if (config.get('autoRefresh', true)) {
+        setupAutoRefresh(stagedFilesProvider);
+    }
+
+    // Status bar item
+    const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
+    statusBarItem.command = 'aiCodeReview.openReview';
+    statusBarItem.text = '$(search-view-icon) AI Review';
+    statusBarItem.tooltip = 'Open AI Code Review';
+    statusBarItem.show();
+    context.subscriptions.push(statusBarItem);
+
+    // Update status bar based on git status
+    updateStatusBar(statusBarItem, gitService);
+
+    console.log('AI Visual Code Review extension activated successfully!');
+}
+
+async function openReviewCommand(reviewWebviewProvider: ReviewWebviewProvider) {
+    try {
+        // Create or show the webview panel
+        await reviewWebviewProvider.createOrShowPanel();
+        vscode.window.showInformationMessage('AI Code Review panel opened');
+    } catch (error) {
+        vscode.window.showErrorMessage(`Failed to open review: ${error}`);
+    }
+}
+
+async function exportForAICommand(gitService: GitService, diffService: DiffService) {
+    try {
+        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
+        if (!workspaceFolder) {
+            vscode.window.showErrorMessage('No workspace folder found');
+            return;
+        }
+
+        // Show progress
+        await vscode.window.withProgress({
+            location: vscode.ProgressLocation.Notification,
+            title: 'Exporting for AI Review',
+            cancellable: false
+        }, async (progress) => {
+            progress.report({ increment: 10, message: 'Getting staged files...' });
+
+            const stagedFiles = await gitService.getStagedFiles(workspaceFolder.uri.fsPath);
+
+            if (stagedFiles.length === 0) {
+                vscode.window.showWarningMessage('No staged files found. Please stage your changes first.');
+                return;
+            }
+
+            progress.report({ increment: 30, message: `Processing ${stagedFiles.length} files...` });
+
+            // Generate review content
+            const timestamp = new Date().toLocaleString();
+            let content = `# 🔍 Code Review - ${timestamp}
+
+**Project:** ${workspaceFolder.name}
+**Generated by:** AI Visual Code Review Extension v1.0.0
+
+## 📊 Change Summary
+
+\`\`\`
+${await gitService.getDiffStats(workspaceFolder.uri.fsPath)}
+\`\`\`
+
+## 📝 Files Changed (${stagedFiles.length} selected)
+
+`;
+
+            let processedCount = 0;
+            for (const file of stagedFiles) {
+                try {
+                    progress.report({
+                        increment: 50 / stagedFiles.length,
+                        message: `Processing ${file}...`
+                    });
+
+                    content += `\n### 📄 \`${file}\`\n\n`;
+
+                    // Add file type context
+                    const ext = path.extname(file).toLowerCase();
+                    const fileTypeMap: { [key: string]: string } = {
+                        '.tsx': '**Type:** TypeScript React Component ⚛️\n\n',
+                        '.ts': '**Type:** TypeScript Source File 📘\n\n',
+                        '.js': '**Type:** JavaScript Source File 🟨\n\n',
+                        '.jsx': '**Type:** React Component (JavaScript) ⚛️\n\n',
+                        '.json': '**Type:** Configuration/Data File 📋\n\n',
+                        '.md': '**Type:** Documentation 📖\n\n',
+                        '.css': '**Type:** Stylesheet 🎨\n\n',
+                        '.scss': '**Type:** Sass Stylesheet 🎨\n\n',
+                        '.html': '**Type:** HTML Template 🌐\n\n',
+                        '.py': '**Type:** Python Script 🐍\n\n',
+                        '.sh': '**Type:** Shell Script 💻\n\n'
+                    };
+                    content += fileTypeMap[ext] || '**Type:** Source File 📄\n\n';
+
+                    // Add diff
+                    const diff = await gitService.getFileDiff(workspaceFolder.uri.fsPath, file);
+                    content += diffService.generateEnhancedDiffMarkdown(diff);
+
+                    processedCount++;
+                } catch (error) {
+                    console.error(`Error processing ${file}:`, error);
+                    content += `**❌ Error:** Could not load diff for \`${file}\`\n\n`;
+                }
+            }
+
+            // Add review checklist
+            content += `---
+
+## 🤖 AI Review Checklist
+
+Please review these changes for:
+
+### 🔍 Code Quality
+- [ ] **Linting Compliance**: No unused imports/variables, proper formatting
+- [ ] **Type Safety**: Proper typing throughout (TypeScript/JSDoc)
+- [ ] **Best Practices**: Framework-specific conventions and patterns
+- [ ] **Performance**: Efficient algorithms, proper memoization
+- [ ] **Documentation**: Clear comments and function descriptions
+
+### 🐛 Potential Issues
+- [ ] **Runtime Errors**: Type mismatches, null/undefined handling
+- [ ] **Logic Bugs**: Incorrect calculations, edge cases
+- [ ] **Memory Leaks**: Cleanup in lifecycle methods, event listeners
+- [ ] **Error Handling**: Proper try-catch blocks, user feedback
+- [ ] **Accessibility**: ARIA labels, keyboard navigation, screen readers
+
+### 🔒 Security & Data
+- [ ] **Input Validation**: Sanitization, XSS prevention, SQL injection
+- [ ] **Authentication**: Proper access controls and permissions
+- [ ] **Privacy**: No sensitive data exposure in logs/client
+- [ ] **Dependencies**: Updated packages, vulnerability checks
+
+### 📱 UX/UI
+- [ ] **Responsive Design**: Mobile/desktop/tablet compatibility
+- [ ] **Loading States**: Proper feedback during async operations
+- [ ] **Error Messages**: User-friendly error handling and recovery
+- [ ] **Performance**: Fast loading, smooth animations
+
+### 💡 Suggestions & Improvements
+Please provide specific feedback on:
+1. Code organization and structure improvements
+2. Performance optimization opportunities
+3. Security considerations and hardening
+4. Testing coverage and strategies
+5. Documentation and maintainability
+
+---
+*Generated by AI Visual Code Review Extension v1.0.0*
+*Files processed: ${processedCount}/${stagedFiles.length} | Generated: ${new Date().toISOString()}*
+`;
+
+            progress.report({ increment: 10, message: 'Saving review file...' });
+
+            // Write to file
+            const reviewFile = vscode.Uri.file(path.join(workspaceFolder.uri.fsPath, 'AI_REVIEW.md'));
+            await vscode.workspace.fs.writeFile(reviewFile, Buffer.from(content, 'utf8'));
+
+            // Open the file
+            const doc = await vscode.workspace.openTextDocument(reviewFile);
+            await vscode.window.showTextDocument(doc);
+        });
+
+        vscode.window.showInformationMessage('AI review exported successfully!');
+    } catch (error) {
+        vscode.window.showErrorMessage(`Failed to export review: ${error}`);
+    }
+}
+
+async function quickReviewCommand(gitService: GitService, diffService: DiffService) {
+    try {
+        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
+        if (!workspaceFolder) {
+            vscode.window.showErrorMessage('No workspace folder found');
+            return;
+        }
+
+        const stagedFiles = await gitService.getStagedFiles(workspaceFolder.uri.fsPath);
+
+        if (stagedFiles.length === 0) {
+            vscode.window.showWarningMessage('No staged files found. Please stage your changes first.');
+            return;
+        }
+
+        // Show quick summary
+        const stats = await gitService.getDiffStats(workspaceFolder.uri.fsPath);
+        const message = `📊 Quick Review Summary:
+${stagedFiles.length} files staged
+${stats}
+
+Export full review?`;
+
+        const choice = await vscode.window.showInformationMessage(
+            message,
+            { modal: true },
+            'Export Full Review',
+            'Cancel'
+        );
+
+        if (choice === 'Export Full Review') {
+            await exportForAICommand(gitService, diffService);
+        }
+    } catch (error) {
+        vscode.window.showErrorMessage(`Quick review failed: ${error}`);
+    }
+}
+
+function setupAutoRefresh(stagedFilesProvider: StagedFilesProvider) {
+    // Watch for git changes
+    const watcher = vscode.workspace.createFileSystemWatcher('**/.git/index');
+
+    watcher.onDidChange(() => {
+        stagedFilesProvider.refresh();
+    });
+
+    watcher.onDidCreate(() => {
+        stagedFilesProvider.refresh();
+    });
+
+    watcher.onDidDelete(() => {
+        stagedFilesProvider.refresh();
+    });
+}
+
+async function updateStatusBar(statusBarItem: vscode.StatusBarItem, gitService: GitService) {
+    try {
+        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
+        if (!workspaceFolder) {
+            statusBarItem.text = '$(search-view-icon) AI Review';
+            return;
+        }
+
+        const stagedFiles = await gitService.getStagedFiles(workspaceFolder.uri.fsPath);
+        if (stagedFiles.length > 0) {
+            statusBarItem.text = `$(search-view-icon) AI Review (${stagedFiles.length})`;
+            statusBarItem.backgroundColor = new vscode.ThemeColor('statusBarItem.prominentBackground');
+        } else {
+            statusBarItem.text = '$(search-view-icon) AI Review';
+            statusBarItem.backgroundColor = undefined;
+        }
+    } catch (error) {
+        console.error('Failed to update status bar:', error);
+    }
+}
+
+export function deactivate() {
+    console.log('AI Visual Code Review extension deactivated');
+}
```


### 📄 `vscode-extension/tsconfig.json`

**Type:** Configuration/Data

```diff
diff --git c/vscode-extension/tsconfig.json i/vscode-extension/tsconfig.json
new file mode 100644
index 0000000..3d2f8f6
--- /dev/null
+++ i/vscode-extension/tsconfig.json
@@ -0,0 +1,17 @@
+{
+  "compilerOptions": {
+    "module": "commonjs",
+    "target": "ES2020",
+    "outDir": "out",
+    "lib": [
+      "ES2020"
+    ],
+    "sourceMap": true,
+    "rootDir": "src",
+    "strict": true
+  },
+  "exclude": [
+    "node_modules",
+    ".vscode-test"
+  ]
+}
```


---

## 🤖 Review Checklist

Please review these changes for:

### 🔍 Code Quality
- [ ] **Linting Compliance**: No unused imports/variables, proper formatting
- [ ] **Type Safety**: Proper typing throughout (TypeScript/Python type hints)
- [ ] **Best Practices**: Framework-specific conventions and patterns
- [ ] **Performance**: Efficient algorithms, proper memoization

### 🐛 Potential Issues
- [ ] **Runtime Errors**: Type mismatches, null/undefined handling
- [ ] **Logic Bugs**: Incorrect calculations, edge cases
- [ ] **Memory Leaks**: Cleanup in lifecycle methods, event listeners
- [ ] **Error Handling**: Proper try-catch blocks, user feedback

### 🔒 Security & Data
- [ ] **Input Validation**: Sanitization, XSS prevention
- [ ] **Authentication**: Proper access controls
- [ ] **Data Privacy**: No sensitive data exposure
- [ ] **Dependencies**: Updated packages, vulnerability checks

### 📱 UX/UI
- [ ] **Responsive Design**: Mobile/desktop compatibility
- [ ] **Loading States**: Proper feedback during async operations
- [ ] **Accessibility**: ARIA labels, keyboard navigation
- [ ] **User Experience**: Intuitive interactions, clear messaging

### 💡 Suggestions
Please provide specific feedback on:
1. Any potential improvements
2. Missing error handling
3. Performance optimizations
4. Code organization suggestions
5. Documentation needs

---
*Generated by AI Visual Code Review Quick Script*
