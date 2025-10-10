# Security Policy

## 🔒 Security Features

AI Visual Code Review v2.0 implements comprehensive security measures to protect against common web application vulnerabilities.

## 🛡️ Security Measures Implemented

### Command Injection Prevention
- **Allowlisted Commands**: Only predefined Git commands are permitted
- **Argument Sanitization**: All arguments filtered through regex patterns
- **Path Validation**: Multiple layers of file path security checks
- **Shell Metacharacter Blocking**: Prevention of `; | & $ ` ` ( ) { } [ ] \` injection

### Input Validation & Sanitization
- **File Path Security**: Blocks directory traversal (`../`, absolute paths)
- **Request Size Limits**: 10MB default limit to prevent DoS
- **Comment Length Restrictions**: 10,000 character limit per comment
- **Type Validation**: Strict type checking on all inputs
- **Sensitive Pattern Detection**: Blocks access to `.env`, `.git/`, `.ssh/` files

### Rate Limiting
- **General Endpoints**: 50 requests per 15 minutes per IP
- **Export Endpoints**: 10 requests per 15 minutes per IP (more restrictive)
- **Automatic Cleanup**: Old rate limit entries are automatically cleaned
- **Configurable Limits**: Easy to adjust via configuration

### Security Headers
```http
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'
```

### Production Hardening
- **Error Details**: Internal errors hidden in production mode
- **CORS Restrictions**: Disabled in production by default
- **Request Timeouts**: 30-second timeout on all requests
- **Logging Sanitization**: Sensitive data filtered from logs

## 🚨 Reporting Security Vulnerabilities

If you discover a security vulnerability, please report it by:

1. **DO NOT** create a public GitHub issue
2. Email security issues to: security@ai-code-review.com
3. Include detailed steps to reproduce the vulnerability
4. Provide your contact information for follow-up

### What to Include in Your Report
- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Suggested fix (if you have one)

## 🔍 Security Testing

### Automated Testing
```bash
# Run security audit
npm run test:security

# Run all tests including security validation
npm test

# Coverage report (includes security test coverage)
npm run test:coverage
```

### Manual Security Testing
The test suite includes comprehensive security validation:
- ✅ Command injection prevention tests
- ✅ Path traversal attack prevention
- ✅ XSS attack prevention
- ✅ Rate limiting functionality
- ✅ Input sanitization validation
- ✅ Security header verification

## ⚙️ Security Configuration

### Environment Variables
```bash
# Production security settings
NODE_ENV=production          # Enables production security mode
PORT=3002                   # Server port
MAX_REQUEST_SIZE=10mb       # Request size limit
GIT_TIMEOUT=15000          # Git operation timeout (ms)

# Rate limiting configuration
RATE_LIMIT_WINDOW=900000   # 15 minutes in milliseconds
RATE_LIMIT_MAX=50          # Max requests per window
RATE_LIMIT_EXPORT_MAX=10   # Max export requests per window
```

### Secure Deployment Checklist
- [ ] Set `NODE_ENV=production`
- [ ] Configure reverse proxy (nginx/Apache)
- [ ] Enable HTTPS with valid certificates
- [ ] Set up firewall rules (only allow necessary ports)
- [ ] Regular security updates (`npm audit fix`)
- [ ] Monitor logs for suspicious activity
- [ ] Backup and recovery procedures
- [ ] Access logging and monitoring

## 🔄 Security Updates

### Update Process
1. Monitor for security advisories
2. Run `npm audit` regularly
3. Apply security patches promptly
4. Test in staging environment
5. Deploy to production with rollback plan

### Supported Versions
| Version | Supported          |
| ------- | ------------------ |
| 2.0.x   | ✅ Fully supported |
| 1.x.x   | ❌ No longer supported |

## 📋 Security Checklist for Developers

### Before Deployment
- [ ] Run security audit: `npm run test:security`
- [ ] Verify all tests pass: `npm test`
- [ ] Check for hardcoded secrets
- [ ] Validate input sanitization
- [ ] Test rate limiting functionality
- [ ] Verify error handling doesn't expose internals
- [ ] Confirm security headers are set
- [ ] Test with malicious inputs

### Code Review Security Focus
- Validate all user inputs
- Check for command injection opportunities
- Verify file path handling
- Ensure proper error handling
- Check for information disclosure
- Validate rate limiting implementation

## 🛠️ Security Tools Integration

### Recommended Tools
- **Static Analysis**: ESLint with security plugins
- **Dependency Scanning**: npm audit, Snyk
- **Container Scanning**: If using Docker
- **Runtime Protection**: Consider WAF deployment

### CI/CD Security Integration
```yaml
# Example GitHub Actions security check
- name: Security Audit
  run: npm audit --audit-level high
  
- name: Run Security Tests
  run: npm run test:security
```

## 📚 Security Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [Express.js Security Best Practices](https://expressjs.com/en/advanced/best-practice-security.html)
- [npm Security Advisories](https://www.npmjs.com/advisories)

---

**Last Updated**: October 2024  
**Security Contact**: security@ai-code-review.com
