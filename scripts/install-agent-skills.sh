#!/usr/bin/env bash
#
# install-agent-skills.sh
#
# Re-installs / refreshes the vendored agent skill packs into both
# .claude/skills/ (Claude Code, Cursor) and .agents/skills/ (Codex, Prime Agent).
#
# This performs a *slimmed* install: only SKILL.md files and their Markdown
# reference files are copied. Repo machinery (build scripts, browser extensions,
# tests, binaries) is intentionally excluded to keep the repository lean.
# Each pack keeps its upstream LICENSE for attribution (all MIT).
#
# Usage:
#   ./scripts/install-agent-skills.sh            # refresh all packs
#
# Requires: git, coreutils. Network access to github.com.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# pack_name|github_repo|subdir_to_scan_for_SKILL.md
PACKS=(
  "superpowers|obra/superpowers|skills"
  "mattpocock|mattpocock/skills|skills"
  "gstack|garrytan/gstack|."
  "pstack|michael-denyer/pstack-claude|plugins/pstack/skills"
)

extract_pack() {
  local pack="$1" repo="$2" subdir="$3"
  local src="$TMP/$(echo "$repo" | tr '/' '_')"
  echo ">> cloning $repo"
  git clone --depth 1 "https://github.com/$repo.git" "$src" >/dev/null 2>&1
  local scanroot="$src/$subdir"; scanroot="${scanroot%/.}"; scanroot="${scanroot%/}"

  for base in "$REPO_ROOT/.claude/skills" "$REPO_ROOT/.agents/skills"; do
    local dest="$base/$pack"
    rm -rf "$dest"; mkdir -p "$dest"
    find "$scanroot" -name SKILL.md \
      -not -path '*/.git/*' -not -path '*/test/*' \
      -not -path '*/tests/*' -not -path '*/fixtures/*' | while read -r skill; do
      local dir; dir=$(dirname "$skill")
      if [ "$dir" = "$scanroot" ]; then
        mkdir -p "$dest/_router"; cp "$skill" "$dest/_router/SKILL.md"; continue
      fi
      local b; b=$(basename "$dir"); local target="$dest/$b"
      [ -e "$target" ] && target="$dest/${b}-alt"
      mkdir -p "$target"
      (cd "$dir" && find . -name '*.md' -not -path '*/.git/*' | while read -r f; do
          mkdir -p "$target/$(dirname "$f")"; cp "$f" "$target/$f"; done)
    done
    # attribution
    cp "$src/LICENSE" "$dest/LICENSE" 2>/dev/null || true
    if [ "$pack" = "pstack" ]; then
      cp "$src/NOTICE.md" "$dest/NOTICE.md" 2>/dev/null || true
      cp "$src"/LICENSE-* "$dest/" 2>/dev/null || true
    fi
    echo "   $pack -> $base/$pack ($(find "$dest" -name SKILL.md | wc -l | tr -d ' ') skills)"
  done
}

for entry in "${PACKS[@]}"; do
  IFS='|' read -r pack repo subdir <<< "$entry"
  extract_pack "$pack" "$repo" "$subdir"
done

echo "Done. Regenerate the index with: node scripts/gen-skills-index.js"
