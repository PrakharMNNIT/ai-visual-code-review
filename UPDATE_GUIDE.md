# 🔄 Upgrading AI Visual Code Review from v1.0.3 to v1.0.4+

## 📋 **Update Methods by Installation Type**

### **Method 1: NPX (Recommended)**

Using npx ensures you always get the latest version without global installation:

```bash
# Always uses latest version - no installation needed
npx ai-visual-code-review@latest start
npx ai-visual-code-review@latest quick
npx ai-visual-code-review@latest --help

# Or use shorter form with latest
npx ai-visual-code-review start
```

### **Method 2: Global NPM Installation**

If you prefer global installation:

```bash
# Check current version
ai-review --version

# Update to latest version
npm update -g ai-visual-code-review

# Or reinstall to ensure latest
npm uninstall -g ai-visual-code-review
npm install -g ai-visual-code-review

# Verify new version
ai-review --version
```

### **Method 3: Local Project Installation**

If you have it as a project dependency:

```bash
# Update in package.json
npm update ai-visual-code-review

# Or specify exact version
npm install ai-visual-code-review@latest

# For specific version
npm install ai-visual-code-review@1.0.4
```

### **Method 3: Git Repository Clone**

If you cloned the repository:

```bash
# Navigate to your cloned directory
cd path/to/ai-visual-code-review

# Pull latest changes
git pull origin main

# Reinstall dependencies if needed
npm install

# Make scripts executable (if needed)
chmod +x bin/ai-review.js
chmod +x scripts/quick-ai-review.sh
```

## 🆕 **What's New in v1.0.4**

### **✨ Major Improvements**

1. **Memory Bank System** - Complete project documentation and context preservation
2. **Fixed CLI Issues** - No more `npx` required, direct `ai-review` commands work
3. **Reduced Logging** - Cleaner console output during development
4. **Enhanced Security** - Comprehensive security guidelines and patterns documented
5. **Developer Guidelines** - `.clinerules` with structured commit workflows

### **🔧 CLI Improvements**

**Before (v1.0.3):**

```bash
# Required npx for some users
npx ai-review start

# Excessive logging output
# Rate limiting messages cluttered output
```

**After (v1.0.4+):**

```bash
# Direct commands work
ai-review start
ai-review quick
ai-review --help

# Clean, minimal logging
# Better user experience
```

### **📚 New Documentation**

Your updated installation now includes:

- `memory-bank/` - Complete project documentation system
- `.clinerules` - Development guidelines and commit workflow
- Enhanced security patterns and architecture documentation

## 🔍 **Verification Steps**

After updating, verify everything works:

```bash
# 1. Check version
ai-review --version

# 2. Test basic functionality
cd your-project
git add some-files
ai-review start

# 3. Test CLI commands
ai-review --help
ai-review quick

# 4. Verify web interface
# Open http://localhost:3002 and check for improvements
```

## 🚨 **Breaking Changes**

**Good News: NO BREAKING CHANGES!**

Version 1.0.4 is fully backward compatible with 1.0.3:

- ✅ All existing commands work the same way
- ✅ All API endpoints remain unchanged
- ✅ Configuration files and usage patterns unchanged
- ✅ Existing workflows continue to work

## 🐛 **Troubleshooting Update Issues**

### **Issue: Command not found after update**

```bash
# Solution 1: Refresh shell
source ~/.bashrc  # or ~/.zshrc

# Solution 2: Check npm global path
npm config get prefix
echo $PATH

# Solution 3: Reinstall globally
npm uninstall -g ai-visual-code-review
npm install -g ai-visual-code-review
```

### **Issue: Old version still showing**

```bash
# Clear npm cache
npm cache clean --force

# Reinstall
npm install -g ai-visual-code-review@latest

# Check which version is being used
which ai-review
ai-review --version
```

### **Issue: Permission errors**

```bash
# Fix permissions (macOS/Linux)
sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

# Or use a version manager like nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

## 📦 **For Team/Organization Updates**

### **Update package.json dependencies:**

```json
{
  "devDependencies": {
    "ai-visual-code-review": "^1.0.4"
  }
}
```

### **CI/CD Pipeline Updates:**

```yaml
# GitHub Actions example
- name: Install AI Code Review
  run: npm install -g ai-visual-code-review@latest

- name: Run Code Review
  run: ai-review quick
```

### **Docker Updates:**

```dockerfile
# Update Dockerfile
RUN npm install -g ai-visual-code-review@latest
```

## 🎯 **Recommended Workflow**

1. **Backup current setup** (if heavily customized)
2. **Update using your installation method** (see above)
3. **Test in a small project first**
4. **Roll out to team/production** once verified
5. **Enjoy improved CLI experience and documentation**

## 📞 **Need Help?**

If you encounter any issues during the update:

- Check the [GitHub Issues](https://github.com/PrakharMNNIT/ai-visual-code-review/issues)
- Review the updated documentation in `memory-bank/`
- Follow the troubleshooting steps above
- The new `.clinerules` file has comprehensive development guidelines

## 🚀 **Next Steps**

After updating:

1. Explore the new `memory-bank/` documentation
2. Try the improved CLI commands (no more npx needed!)
3. Check out the `.clinerules` for development best practices
4. Enjoy the cleaner logging output
5. Share feedback on the improvements!

---

**Happy Coding with AI Visual Code Review v1.0.4+!** 🎉
