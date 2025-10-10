#!/bin/bash

# 🔍 AI Visual Code Review - Installation Script
# Installs the tool globally or locally for easy use in any Git repository

set -e

INSTALL_DIR="/usr/local/bin"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_INSTALL=false
LOCAL_INSTALL=false

echo "🔍 AI Visual Code Review - Installation"
echo "====================================="

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --global|-g)
            GLOBAL_INSTALL=true
            shift
            ;;
        --local|-l)
            LOCAL_INSTALL=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --global, -g    Install globally (requires sudo)"
            echo "  --local, -l     Install to current directory"
            echo "  --help, -h      Show this help"
            echo ""
            echo "Examples:"
            echo "  $0 --global     # Install globally"
            echo "  $0 --local      # Install to current directory"
            echo "  $0              # Interactive installation"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check Node.js installation
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found"
    echo "💡 Please install Node.js (version 14 or higher) from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node --version | sed 's/v//')
REQUIRED_VERSION="14.0.0"

if ! node -e "
const current = '$NODE_VERSION'.split('.').map(Number);
const required = '$REQUIRED_VERSION'.split('.').map(Number);
const isValid = current[0] > required[0] ||
               (current[0] === required[0] && current[1] > required[1]) ||
               (current[0] === required[0] && current[1] === required[1] && current[2] >= required[2]);
process.exit(isValid ? 0 : 1);
" 2>/dev/null; then
    echo "❌ Node.js version $NODE_VERSION is too old"
    echo "💡 Please upgrade to Node.js 14.0.0 or higher"
    exit 1
fi

echo "✅ Node.js $NODE_VERSION detected"

# Check Git installation
if ! command -v git &> /dev/null; then
    echo "❌ Git not found"
    echo "💡 Please install Git from https://git-scm.com/"
    exit 1
fi

echo "✅ Git $(git --version | cut -d' ' -f3) detected"

# Interactive installation if no options specified
if [ "$GLOBAL_INSTALL" = false ] && [ "$LOCAL_INSTALL" = false ]; then
    echo ""
    echo "Choose installation type:"
    echo "1) Global installation (recommended) - available everywhere"
    echo "2) Local installation - copy to current directory"
    echo "3) NPM installation - install from npm (if published)"
    echo ""
    read -p "Enter your choice (1-3): " choice

    case $choice in
        1)
            GLOBAL_INSTALL=true
            ;;
        2)
            LOCAL_INSTALL=true
            ;;
        3)
            echo "📦 Installing from NPM..."
            npm install -g ai-visual-code-review
            if [ $? -eq 0 ]; then
                echo "✅ Successfully installed ai-visual-code-review globally via NPM"
                echo ""
                echo "🎯 Usage:"
                echo "  ai-review                    # Start visual review server"
                echo "  ai-review quick              # Generate quick AI review"
                echo "  ai-review --help             # Show help"
                exit 0
            else
                echo "❌ NPM installation failed. Falling back to local installation."
                LOCAL_INSTALL=true
            fi
            ;;
        *)
            echo "Invalid choice. Defaulting to local installation."
            LOCAL_INSTALL=true
            ;;
    esac
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
cd "$SCRIPT_DIR"

if [ ! -f "package.json" ]; then
    echo "❌ package.json not found in $SCRIPT_DIR"
    exit 1
fi

npm install --production

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Global installation
if [ "$GLOBAL_INSTALL" = true ]; then
    echo ""
    echo "🌍 Installing globally..."

    # Check if we need sudo
    if [ ! -w "$INSTALL_DIR" ]; then
        echo "🔐 Requesting administrator privileges..."
        SUDO_CMD="sudo"
    else
        SUDO_CMD=""
    fi

    # Create symlink to CLI tool
    $SUDO_CMD ln -sf "$SCRIPT_DIR/bin/ai-review.js" "$INSTALL_DIR/ai-review"

    # Make scripts executable
    chmod +x "$SCRIPT_DIR/bin/ai-review.js"
    chmod +x "$SCRIPT_DIR/scripts/quick-ai-review.sh"

    echo "✅ Installed globally to $INSTALL_DIR/ai-review"
    echo ""
    echo "🎯 Usage (from any directory):"
    echo "  ai-review                    # Start visual review server"
    echo "  ai-review start --port 3003  # Custom port"
    echo "  ai-review quick              # Generate quick AI review"
    echo "  ai-review --help             # Show help"

# Local installation
elif [ "$LOCAL_INSTALL" = true ]; then
    echo ""
    echo "📁 Installing locally..."

    TARGET_DIR="$(pwd)/ai-visual-code-review"

    # Create target directory if it doesn't exist
    if [ ! -d "$TARGET_DIR" ]; then
        mkdir -p "$TARGET_DIR"
    fi

    # Copy files
    cp -r "$SCRIPT_DIR"/* "$TARGET_DIR/"

    # Make scripts executable
    chmod +x "$TARGET_DIR/bin/ai-review.js"
    chmod +x "$TARGET_DIR/scripts/quick-ai-review.sh"

    echo "✅ Installed locally to $TARGET_DIR"
    echo ""
    echo "🎯 Usage (from current directory):"
    echo "  ./ai-visual-code-review/bin/ai-review.js        # Start visual server"
    echo "  ./ai-visual-code-review/scripts/quick-ai-review.sh  # Quick review"
    echo ""
    echo "💡 Add to PATH for easier access:"
    echo "  echo 'export PATH=\"\$PATH:$(pwd)/ai-visual-code-review/bin\"' >> ~/.bashrc"
    echo "  source ~/.bashrc"
fi

echo ""
echo "🎉 Installation completed successfully!"
echo ""
echo "📚 Quick Start:"
echo "1. Navigate to any Git repository"
echo "2. Stage some changes: git add ."
echo "3. Run: ai-review"
echo "4. Open browser at http://localhost:3002"
echo "5. Review and export for AI analysis"
echo ""
echo "📖 For more information, see README.md"
echo "🐛 Report issues: https://github.com/ai-tools/ai-visual-code-review/issues"
