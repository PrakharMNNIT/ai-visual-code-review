#!/bin/bash

# 📤 Quick AI Review Export Script - Portable Version
# Generates AI_REVIEW.md from staged changes with file exclusion options

set -e

echo "🔍 Quick AI Review Export"
echo "========================="

# Default exclusions (minimal - user has full control)
DEFAULT_EXCLUDES=(
    ".env*"
    "node_modules/*"
    "*.log"
    ".git/*"
    "dist/*"
    "build/*"
)

# Parse command line arguments
EXCLUDE_FILES=()
INCLUDE_FILES=()
SKIP_LARGE_FILES=true
MAX_FILE_SIZE=10000  # lines
INCLUDE_ONLY_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --exclude)
            # Collect all files until next flag or end
            shift
            while [[ $# -gt 0 && "$1" != --* ]]; do
                EXCLUDE_FILES+=("$1")
                shift
            done
            ;;
        --include)
            # Only include specified files (ignores defaults)
            INCLUDE_ONLY_MODE=true
            shift
            while [[ $# -gt 0 && "$1" != --* ]]; do
                INCLUDE_FILES+=("$1")
                shift
            done
            ;;
        --max-size)
            MAX_FILE_SIZE="$2"
            shift 2
            ;;
        --no-size-limit)
            SKIP_LARGE_FILES=false
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --exclude FILES...  Exclude specific files (space-separated)"
            echo "  --include FILES...  ONLY include specific files (ignores all others)"
            echo "  --max-size LINES    Skip files larger than LINES (default: 10000)"
            echo "  --no-size-limit     Include all files regardless of size"
            echo "  -h, --help          Show this help"
            echo ""
            echo "Examples:"
            echo "  $0  # Standard export (all files)"
            echo "  $0 --exclude package-lock.json dist/bundle.js"
            echo "  $0 --include src/main.ts src/components/Header.tsx"
            echo "  $0 --include 'src/**/*.ts' --no-size-limit"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not a git repository"
    echo "💡 Please run this command inside a git repository"
    echo "   Initialize with: git init"
    exit 1
fi

# Setup exclusion logic
if [ "$INCLUDE_ONLY_MODE" = true ]; then
    ALL_EXCLUDES=()  # Don't use default excludes in include-only mode
    echo "📋 INCLUDE-ONLY MODE: Will only process specified files"
    echo "✅ Files to include: ${INCLUDE_FILES[*]}"
else
    ALL_EXCLUDES=("${DEFAULT_EXCLUDES[@]}" "${EXCLUDE_FILES[@]}")
    if [ ${#EXCLUDE_FILES[@]} -gt 0 ]; then
        echo "📋 Excluding files: ${EXCLUDE_FILES[*]}"
    fi
    echo "🛡️  Always excluded: ${DEFAULT_EXCLUDES[*]}"
fi

echo "📏 Max file size: $MAX_FILE_SIZE lines"

# Check if there are staged changes or unstaged deletions
STAGED_CHANGES=$(git diff --cached --name-only | wc -l)
DELETED_FILES=$(git ls-files --deleted | wc -l)

if [ "$STAGED_CHANGES" -eq 0 ] && [ "$DELETED_FILES" -eq 0 ]; then
    echo "⚠️  No staged changes found"
    echo "💡 Run 'git add .' to stage changes, then try again"
    exit 1
elif [ "$STAGED_CHANGES" -eq 0 ] && [ "$DELETED_FILES" -gt 0 ]; then
    echo "⚠️  Found $DELETED_FILES deleted file(s) but they are not staged"
    echo "💡 To include deleted files in review:"
    echo "   • Stage all changes: git add -A"
    echo "   • Or stage specific deleted files: git rm <filename>"
    echo "   • Then try again"
    exit 1
else
    echo "✅ Found staged changes"
    if [ "$DELETED_FILES" -gt 0 ]; then
        echo "ℹ️  Note: $DELETED_FILES unstaged deleted file(s) will not be included"
    fi
fi

echo "📊 Generating review file..."

# Generate AI review file
cat > AI_REVIEW.md << EOF
# 🔍 Code Review - $(date)

**Project:** AI Visual Code Review

## 📊 Change Summary

\`\`\`
$(git diff --cached --stat)
\`\`\`

## 📝 Files Changed

EOF

# Function to check if file should be processed
should_process_file() {
    local file="$1"

    # Include-only mode: only process files in INCLUDE_FILES
    if [ "$INCLUDE_ONLY_MODE" = true ]; then
        for include_file in "${INCLUDE_FILES[@]}"; do
            if [[ "$file" == "$include_file" ]]; then
                return 0  # Should process
            fi
        done
        return 1  # Should not process (not in include list)
    fi

    # Exclude mode: process all files except excluded ones
    for exclude_item in "${ALL_EXCLUDES[@]}"; do
        if [[ -n "$exclude_item" ]]; then
            # Exact file match
            if [[ "$file" == "$exclude_item" ]]; then
                return 1  # Should exclude
            fi

            # Directory exclusion: "node_modules/" excludes all files in node_modules/
            if [[ "$exclude_item" == *"/" ]]; then
                local dir_name="${exclude_item%/}"
                if [[ "$file" =~ ^"$dir_name"/ ]]; then
                    return 1  # Should exclude
                fi
            fi

            # Directory with wildcard: "node_modules/*" excludes all files in node_modules/
            if [[ "$exclude_item" == *"/*" ]]; then
                local dir_name="${exclude_item%/*}"
                if [[ "$file" =~ ^"$dir_name"/ ]]; then
                    return 1  # Should exclude
                fi
            fi

            # File extension pattern: "*.log"
            if [[ "$exclude_item" == *"*"* ]]; then
                if [[ "$file" == $exclude_item ]]; then
                    return 1  # Should exclude
                fi
            fi
        fi
    done
    return 0  # Should process
}

# Function to check file size
is_too_large() {
    local file="$1"
    if [ ! -f "$file" ]; then
        return 1  # File doesn't exist, not too large
    fi
    local line_count=$(wc -l < "$file" 2>/dev/null || echo "0")
    [ "$line_count" -gt "$MAX_FILE_SIZE" ]
}

# Process each staged file with exclusions
PROCESSED_COUNT=0
EXCLUDED_COUNT=0
LARGE_FILE_COUNT=0

# Store file list in array to avoid subshell issues
IFS=$'\n' read -d '' -r -a STAGED_FILES < <(git diff --cached --name-only && printf '\0')

for file in "${STAGED_FILES[@]}"; do
    if [ -n "$file" ]; then
        # Check if file should be processed
        if ! should_process_file "$file"; then
            if [ "$INCLUDE_ONLY_MODE" = true ]; then
                echo "⏭️  Skipping: $file (not in include list)"
            else
                echo "⏭️  Skipping: $file (excluded)"
            fi
            EXCLUDED_COUNT=$((EXCLUDED_COUNT + 1))
            continue
        fi

        # Check file size
        if [ "$SKIP_LARGE_FILES" = true ] && is_too_large "$file"; then
            line_count=$(wc -l < "$file" 2>/dev/null || echo "0")
            echo "⏭️  Skipping: $file (too large: $line_count lines)"
            echo "" >> AI_REVIEW.md
            echo "### 📄 \`$file\` ⚠️ SKIPPED" >> AI_REVIEW.md
            echo "" >> AI_REVIEW.md
            echo "**Type:** Large File (${line_count} lines)" >> AI_REVIEW.md
            echo "**Reason:** File too large for review (use \`--max-size ${line_count}\` to include)" >> AI_REVIEW.md
            echo "" >> AI_REVIEW.md
            LARGE_FILE_COUNT=$((LARGE_FILE_COUNT + 1))
            continue
        fi

        echo "✅ Processing: $file"
        echo "" >> AI_REVIEW.md
        echo "### 📄 \`$file\`" >> AI_REVIEW.md
        echo "" >> AI_REVIEW.md

        # Check if file is deleted
        if ! git diff --cached --name-status | grep -q "^D.*$file$"; then
            # File exists or is modified/added - add file type context
            case "$file" in
                *.tsx|*.ts)
                    echo "**Type:** TypeScript/React Component" >> AI_REVIEW.md
                    ;;
                *.js|*.jsx)
                    echo "**Type:** JavaScript" >> AI_REVIEW.md
                    ;;
                *.json)
                    echo "**Type:** Configuration/Data" >> AI_REVIEW.md
                    ;;
                *.md)
                    echo "**Type:** Documentation" >> AI_REVIEW.md
                    ;;
                *.css|*.scss|*.less)
                    echo "**Type:** Stylesheet" >> AI_REVIEW.md
                    ;;
                *.html|*.htm)
                    echo "**Type:** HTML Template" >> AI_REVIEW.md
                    ;;
                *.py)
                    echo "**Type:** Python Script" >> AI_REVIEW.md
                    ;;
                *.sh)
                    echo "**Type:** Shell Script" >> AI_REVIEW.md
                    ;;
                *)
                    echo "**Type:** Source File" >> AI_REVIEW.md
                    ;;
            esac
        else
            # File is deleted
            echo "**Type:** DELETED FILE" >> AI_REVIEW.md
            echo "**Status:** This file has been completely removed" >> AI_REVIEW.md
        fi

        echo "" >> AI_REVIEW.md
        echo "\`\`\`diff" >> AI_REVIEW.md

        # Check the file status to handle different scenarios
        file_status=$(git diff --cached --name-status | grep "^[A-Z].*$file$" | cut -c1)

        if [ "$file_status" = "D" ]; then
            # File is properly deleted and staged - show the deletion diff
            git diff --cached "$file" 2>/dev/null || echo "# File deleted but unable to show diff"
        elif [ "$file_status" = "A" ] && [ ! -f "$file" ]; then
            # File was staged as new but then deleted from working directory
            # Show what would be deleted (the staged content as deleted lines)
            echo "--- a/$file"
            echo "+++ /dev/null"
            echo "@@ -1,$(git show ":$file" 2>/dev/null | wc -l) +0,0 @@"
            git show ":$file" 2>/dev/null | sed 's/^/-/' || echo "# Unable to show deleted content"
        else
            # Normal case - show the regular diff
            git diff --cached "$file" 2>/dev/null || echo "# Unable to show diff for $file"
        fi

        echo "\`\`\`" >> AI_REVIEW.md
        echo "" >> AI_REVIEW.md

        PROCESSED_COUNT=$((PROCESSED_COUNT + 1))
    fi
done

echo ""
echo "📊 Export Summary:"
echo "   Processed: $PROCESSED_COUNT files"
echo "   Excluded: $EXCLUDED_COUNT files"
echo "   Too large: $LARGE_FILE_COUNT files"

# Add review checklist
cat >> AI_REVIEW.md << 'EOF'

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
EOF

echo "✅ Generated: AI_REVIEW.md"
echo "📊 Total staged files: $(git diff --cached --name-only | wc -l)"
echo "📄 AI_REVIEW.md size: $(wc -l < AI_REVIEW.md) lines"

# Try to open in preferred editor
if command -v code &> /dev/null; then
    code AI_REVIEW.md
    echo "📝 Opened AI_REVIEW.md in VS Code"
elif command -v subl &> /dev/null; then
    subl AI_REVIEW.md
    echo "📝 Opened AI_REVIEW.md in Sublime Text"
elif command -v atom &> /dev/null; then
    atom AI_REVIEW.md
    echo "📝 Opened AI_REVIEW.md in Atom"
else
    echo "💡 Editor not found. Please open AI_REVIEW.md manually"
fi

echo ""
echo "🎯 Next steps:"
echo "1. Review AI_REVIEW.md"
echo "2. Ask ChatGPT/Claude: 'Please review AI_REVIEW.md'"
echo "3. Make any suggested changes"
echo "4. Commit: git commit -m 'Your message'"
echo ""
