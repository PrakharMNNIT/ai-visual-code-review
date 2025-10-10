#!/bin/bash

# 🚀 GitHub Setup Script for AI Visual Code Review
# This script helps you connect your local repository to GitHub

echo "🚀 AI Visual Code Review - GitHub Setup"
echo "======================================"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check if origin already exists
if git remote get-url origin > /dev/null 2>&1; then
    echo "✅ Remote 'origin' already exists:"
    git remote get-url origin
    echo ""
    read -p "Do you want to update it? (y/N): " update_remote
    if [[ $update_remote =~ ^[Yy]$ ]]; then
        git remote remove origin
    else
        echo "Keeping existing remote. You can push with: git push origin main"
        exit 0
    fi
fi

# Get GitHub username
read -p "Enter your GitHub username: " username

if [ -z "$username" ]; then
    echo "❌ Username cannot be empty"
    exit 1
fi

# Repository name
REPO_NAME="ai-visual-code-review"

echo ""
echo "📋 Setup Summary:"
echo "   GitHub Username: $username"
echo "   Repository: $REPO_NAME"
echo "   URL: https://github.com/$username/$REPO_NAME.git"
echo ""

read -p "Continue with setup? (Y/n): " confirm
if [[ $confirm =~ ^[Nn]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

# Add remote
echo "🔗 Adding GitHub remote..."
git remote add origin "https://github.com/$username/$REPO_NAME.git"

# Set main branch
echo "🌿 Setting main branch..."
git branch -M main

echo ""
echo "✅ Git remote configured successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Go to GitHub.com and create a new repository named '$REPO_NAME'"
echo "2. Set it to Public (recommended for open source)"
echo "3. Don't initialize with README/License (we have them)"
echo "4. After creating, run: git push -u origin main"
echo ""
echo "🌐 Repository will be available at:"
echo "   https://github.com/$username/$REPO_NAME"
echo ""
echo "📦 To publish to NPM later:"
echo "   npm publish (requires NPM account)"
