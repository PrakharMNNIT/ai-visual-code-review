# Changelog

All notable changes to AI Visual Code Review will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2025-10-14

### 🎯 Cross-Platform Export System

This release introduces a unified Node.js-based export system, replacing the bash script for true cross-platform compatibility, along with critical bug fixes and enhanced pattern matching.

### ✨ Features

#### Unified Export System

- **ADDED** `scripts/export-ai-review.js` - Cross-platform Node.js export script (386 lines)
- **CHANGED** CLI to use Node.js script instead of bash for `ai-review quick` command
- **ADDED** Enhanced glob pattern support with zero-directory matching (`**` matches 0+ directories)
- **ADDED** Direct integration with `services/diffService.js` for consistent formatting
- **IMPROVED** Line number formatting to match web interface (`line# +/- content`)

#### Enhanced Pattern Matching

- **ADDED** Placeholder-based regex replacement to prevent pattern corruption
- **FIXED** `scripts/**/*.js` now correctly includes files instead of excluding all files
- **FIXED** Zero-directory glob matching: `scripts/**/*.js` now matches `scripts/file.js`
- **IMPROVED** Glob pattern algorithm with proper order of operations
- **ADDED** Full path pattern matching with support for nested directories

### 🐛 Bug Fixes

#### Critical Fixes

- **FIXED** Syntax errors in template literals (excessive backslash escaping `\\\\\\\\n`)
- **FIXED** Pattern matching corruption due to regex replacement order
- **FIXED** Zero-directory glob pattern not matching root-level files
- **FIXED** Fatal error when processing deleted files with graceful handling
- **FIXED** CLI argument forwarding to export script

#### Technical Improvements

- **IMPROVED** Error handling with try-catch for git operations
- **ADDED** Git status check for deleted files before processing
- **IMPROVED** Cross-platform file path handling
- **ENHANCED** Export script to handle edge cases gracefully

### 📚 Documentation

- **UPDATED** README.md with unified export system documentation
- **ADDED** Enhanced glob pattern usage guide and examples
- **ADDED** `UNIFIED_EXPORT_GUIDE.md` - Comprehensive usage guide
- **ADDED** `COMPREHENSIVE_TEST_SCENARIOS.md` - 100+ documented test scenarios
- **ADDED** `FINAL_TEST_RESULTS.md` - Complete validation results
- **ADDED** `TEST_RESULTS.md` - Bug fix documentation
- **ADDED** `TWITTER_LAUNCH_THREADS.md` - Launch content for social media
- **ADDED** `NPM_SCRIPTS_ANALYSIS.md` - Technical analysis documentation
- **IMPROVED** Pattern matching examples with detailed explanations

### 🧪 Testing & Validation

- **ADDED** `run-tests.js` - Comprehensive automated test suite (16 tests)
- **ACHIEVED** 100% test pass rate across all test scenarios
- **VALIDATED** Cross-platform compatibility (Windows, macOS, Linux)
- **VERIFIED** Pattern matching with various glob patterns
- **CONFIRMED** Line number formatting consistency
- **APPROVED** Senior SDE production code review

### 🔧 Technical Details

#### Pattern Matching Algorithm

```javascript
// Placeholder approach prevents corruption
pattern.replace(/\*\*\//g, '__DOUBLESTARSLASH__')
  .replace(/\./g, '\\.')
  .replace(/\//g, '\/')
  .replace(/\*/g, '[^/]*')
  .replace(/__DOUBLESTARSLASH__/g, '(.*\\/)?');
```

#### Deleted File Handling

- Git status check before processing
- Graceful skip for deleted files
- No fatal errors on missing files

### 🚀 Migration Notes

#### From v2.0.0 to v2.1.0

- **No Breaking Changes** - Fully backward compatible
- **Recommended**: Use `ai-review quick` CLI command instead of direct bash script
- **Benefit**: Automatic cross-platform compatibility
- **Pattern Matching**: Enhanced glob patterns now work correctly

#### For Windows Users

- No longer need bash emulation (Git Bash, WSL)
- Native Node.js execution
- Full feature parity with Unix-like systems

#### CLI Usage Changes (Optional)

```bash
# Old (still works, but legacy)
./scripts/quick-ai-review.sh --include "src/**/*.ts"

# New (recommended)
ai-review quick --include "src/**/*.ts"
```

### 📊 Testing Results

- **Total Tests**: 16 automated tests
- **Pass Rate**: 100%
- **Coverage**: Core functionality, pattern matching, error handling
- **Validation**: Web interface confirmed working perfectly
- **Review**: Approved by Senior SDE for production

### Known Issues

None. All critical bugs identified during rigorous testing have been resolved.

---

## [2.0.0] - 2024-10-10

### 🚀 Major Release - Production Ready

This is a major security and performance update that makes AI Visual Code Review production-ready with comprehensive security hardening.

### 🔒 Security

- **ADDED** Command injection prevention with allowlisted Git commands
- **ADDED** Comprehensive input validation and sanitization
- **ADDED** Rate limiting middleware (50 req/15min general, 10 req/15min exports)
- **ADDED** Security headers (CSP, XSS Protection, Frame Options)
- **ADDED** Path traversal attack prevention
- **ADDED** Request size limits and timeout enforcement
- **FIXED** All command injection vulnerabilities
- **IMPROVED** Error handling to not expose internal details in production

### ⚡ Performance

- **CHANGED** All Git operations to async (non-blocking)
- **ADDED** Request caching with TTL for GET endpoints
- **ADDED** Memory management and cleanup systems
- **ADDED** Progressive loading for better UX
- **IMPROVED** File processing with parallel operations
- **FIXED** Memory leaks in frontend diff caching

### 🎨 User Experience

- **ADDED** Smart notification system with real-time feedback
- **ADDED** Enhanced file type detection with better icons
- **ADDED** Accessibility improvements (ARIA labels, keyboard navigation)
- **ADDED** Loading states and progress indicators
- **ADDED** Error recovery with retry options
- **IMPROVED** File listing with metadata and descriptions
- **IMPROVED** Responsive design for mobile devices

### 🧪 Testing & Quality

- **ADDED** Comprehensive test suite with Jest and Supertest
- **ADDED** Security vulnerability testing
- **ADDED** API endpoint testing with malicious input validation
- **ADDED** Rate limiting functionality tests
- **ADDED** Coverage reporting and CI/CD integration
- **ADDED** ESLint configuration for code quality

### 📚 Documentation

- **ADDED** Comprehensive SECURITY.md with vulnerability reporting
- **UPDATED** README.md with v2.0 features and security info
- **ADDED** Developer setup and testing instructions
- **ADDED** Security hardening checklist
- **IMPROVED** API documentation with security considerations

### 🛠️ Developer Experience

- **ADDED** Development mode with hot reloading (`npm run dev`)
- **ADDED** Test scripts with watch mode and coverage
- **ADDED** Security audit script (`npm run test:security`)
- **IMPROVED** Error messages and debugging information
- **ADDED** Configuration management system

### API Changes

- **ENHANCED** `/api/health` - Added version info and better status reporting
- **ENHANCED** `/api/summary` - Added generation timestamps and caching
- **ENHANCED** `/api/staged-files` - Added file count and metadata
- **ENHANCED** `/api/file-diff` - Added file size and timestamp info
- **ENHANCED** `/api/export-for-ai` - Added error tracking and enhanced checklists
- **ENHANCED** `/api/export-individual-reviews` - Added line comments and comprehensive templates
- **ADDED** `/api/log-comment` - Enhanced with input validation and sanitization

### Breaking Changes

- Minimum Node.js version increased to 14+
- Some API responses now include additional metadata fields
- Rate limiting may affect high-frequency API usage
- CORS is disabled by default in production mode

## [1.0.0] - 2024-09-15

### Initial Release

- Basic visual code review interface
- Git diff viewing and commenting
- AI review export functionality
- CLI interface with basic commands
- GitHub-like dark theme
- File selection and exclusion
- Basic error handling

### Features

- Interactive diff viewer
- Line-by-line commenting
- AI-optimized markdown export
- Cross-platform CLI tool
- Quick review scripts
- Basic file filtering

---

## Migration Guide v1.x → v2.0

### For Developers

1. **Update Dependencies**: Run `npm install` to get new dev dependencies
2. **Run Tests**: New test suite requires `npm test` to pass
3. **Check Security**: Run `npm run test:security` for security audit
4. **Update Scripts**: New npm scripts available for development

### For Deployment

1. **Security Review**: Review new security features in SECURITY.md
2. **Environment Variables**: New configuration options available
3. **Rate Limiting**: Consider if default limits work for your use case
4. **HTTPS Required**: Strongly recommended for production deployments

### API Compatibility

- All existing endpoints maintain backward compatibility
- New fields added to responses (non-breaking)
- Rate limiting may affect high-frequency usage
- Error responses now include timestamps (non-breaking)

---

## Upcoming Features (Roadmap)

### v2.1.0 (Planned)

- WebSocket support for real-time updates
- Plugin system for custom review rules
- Integration with popular code analysis tools
- Batch export functionality

### v2.2.0 (Planned)

- User authentication and multi-user support
- Review history and version tracking
- Advanced diff algorithms
- Custom review templates

---

**For technical support or security issues, please refer to SECURITY.md**
