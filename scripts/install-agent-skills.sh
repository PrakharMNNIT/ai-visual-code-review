#!/usr/bin/env bash
#
# install-agent-skills.sh
#
# Re-installs / refreshes the vendored agent skill packs into both
# .claude/skills/ (Claude Code, Cursor) and .agents/skills/ (Codex, Prime Agent).
#
# Slimmed install: SKILL.md, Markdown references, and each skill's scripts/
# directory. Upstream tests, binaries, zips, and plugin machinery stay out.
# Each pack keeps its upstream LICENSE when one exists.
#
# Usage:
#   ./scripts/install-agent-skills.sh            # refresh all packs
#
# Requires: git, coreutils. Network access to github.com.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# pack_name|github_repo|subdir_to_scan_for_SKILL.md|license_path_relative_to_clone
PACKS=(
  "superpowers|obra/superpowers|skills|LICENSE"
  "mattpocock|mattpocock/skills|skills|LICENSE"
  "gstack|garrytan/gstack|.|LICENSE"
  "pstack|cursor/plugins|pstack/skills|pstack/LICENSE"
  "improve|shadcn/improve|skills|LICENSE.md"
  "cursor-team-kit|cursor/plugins|cursor-team-kit/skills|cursor-team-kit/LICENSE"
  "vercel-agent-skills|vercel-labs/agent-skills|skills|"
  "addyosmani|addyosmani/agent-skills|skills|LICENSE"
)

clone_repo() {
  local repo="$1"
  local src="$TMP/$(echo "$repo" | tr '/' '_')"
  if [ -d "$src/.git" ]; then
    echo ">> reusing clone $repo" >&2
    printf '%s' "$src"
    return 0
  fi
  echo ">> cloning $repo" >&2
  git clone --depth 1 "https://github.com/$repo.git" "$src" >/dev/null 2>&1
  printf '%s' "$src"
}

copy_skill_files() {
  local dir="$1" target="$2"
  mkdir -p "$target"
  (cd "$dir" && find . -type f \
    -not -path '*/.git/*' \
    -not -name '*.zip' \
    \( -name '*.md' -o -path './scripts/*' -o -path './references/*' \) \
    | while read -r f; do
        mkdir -p "$target/$(dirname "$f")"
        cp "$f" "$target/$f"
      done)
}

extract_pack() {
  local pack="$1" repo="$2" subdir="$3" license_rel="${4:-}"
  local src scanroot
  src="$(clone_repo "$repo")"
  scanroot="$src/$subdir"
  scanroot="${scanroot%/.}"
  scanroot="${scanroot%/}"

  for base in "$REPO_ROOT/.claude/skills" "$REPO_ROOT/.agents/skills"; do
    local dest="$base/$pack"
    rm -rf "$dest"
    mkdir -p "$dest"
    find "$scanroot" -name SKILL.md \
      -not -path '*/.git/*' -not -path '*/test/*' \
      -not -path '*/tests/*' -not -path '*/fixtures/*' | while read -r skill; do
      local dir b target
      dir="$(dirname "$skill")"
      if [ "$dir" = "$scanroot" ]; then
        mkdir -p "$dest/_router"
        cp "$skill" "$dest/_router/SKILL.md"
        continue
      fi
      b="$(basename "$dir")"
      target="$dest/$b"
      [ -e "$target" ] && target="$dest/${b}-alt"
      copy_skill_files "$dir" "$target"
    done

    if [ -n "$license_rel" ] && [ -f "$src/$license_rel" ]; then
      cp "$src/$license_rel" "$dest/$(basename "$license_rel")"
    else
      cp "$src/LICENSE" "$dest/LICENSE" 2>/dev/null || true
      cp "$src/LICENSE.md" "$dest/LICENSE.md" 2>/dev/null || true
    fi

    if [ "$pack" = "vercel-agent-skills" ]; then
      cat > "$dest/NOTICE.md" <<'EOF'
Upstream README at https://github.com/vercel-labs/agent-skills states this collection is MIT licensed. The clone does not ship a LICENSE file.
EOF
    fi

    if [ "$pack" = "addyosmani" ] && [ -d "$src/references" ]; then
      mkdir -p "$dest/references"
      find "$src/references" -type f -name '*.md' | while read -r f; do
        cp "$f" "$dest/references/$(basename "$f")"
      done
    fi

    echo "   $pack -> $base/$pack ($(find "$dest" -name SKILL.md | wc -l | tr -d ' ') skills)"
  done
}

for entry in "${PACKS[@]}"; do
  IFS='|' read -r pack repo subdir license_rel <<< "$entry"
  extract_pack "$pack" "$repo" "$subdir" "$license_rel"
done

echo "Done. Regenerate the index with: node scripts/gen-skills-index.js"
