#!/usr/bin/env bash
#
# install-agent-skills.sh
#
# Re-installs / refreshes the vendored agent skill packs into both
# .claude/skills/ (Claude Code, Cursor) and .agents/skills/ (Codex, Prime Agent).
#
# Slimmed install: SKILL.md, Markdown references, LICENSE files, and each
# skill's scripts/ directory. Upstream tests, binaries, zips, and plugin
# machinery stay out. Each pack keeps its upstream LICENSE when one exists.
#
# PACKS fields: name|github_repo|subdir|license_rel|allowlist
#   allowlist: empty = every SKILL.md under subdir; otherwise comma-separated
#   skill directory basenames (the folder that contains SKILL.md).
#
# github/spec-kit is not in PACKS: it has no useful Agent Skill tree for this
# app. See docs/agent-skill-packs.md for `specify init --here --integration cursor-agent`.
#
# Usage:
#   ./scripts/install-agent-skills.sh            # refresh all packs
#
# Requires: git, coreutils. Network access to github.com.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Documented GitHub issue/PR/Actions/gh subset of github/awesome-copilot.
# The upstream tree is 400+ skills; do not vendor it whole.
AWESOME_GH_SKILLS="github-issues,create-github-issue-feature-from-specification,create-github-issues-feature-from-implementation-plan,create-github-issues-for-unmet-specification-requirements,gen-specs-as-issues,issue-fields-migration,copilot-pr-autopilot,pr-dashboard,pr-screenshots,gh-attach,create-github-action-workflow-specification,github-actions-efficiency,github-actions-hardening,github-actions-runtime-upgrade-conventions,github-release"

# pack_name|github_repo|subdir_to_scan_for_SKILL.md|license_path|optional_allowlist
PACKS=(
  "superpowers|obra/superpowers|skills|LICENSE|"
  "mattpocock|mattpocock/skills|skills|LICENSE|"
  "gstack|garrytan/gstack|.|LICENSE|"
  "pstack|cursor/plugins|pstack/skills|pstack/LICENSE|"
  "improve|shadcn/improve|skills|LICENSE.md|"
  "cursor-team-kit|cursor/plugins|cursor-team-kit/skills|cursor-team-kit/LICENSE|"
  "vercel-agent-skills|vercel-labs/agent-skills|skills||"
  "addyosmani|addyosmani/agent-skills|skills|LICENSE|"
  "find-skills|vercel-labs/skills|skills|LICENSE|find-skills"
  "agent-browser|vercel-labs/agent-browser|skills|LICENSE|agent-browser"
  "trailofbits|trailofbits/skills|plugins|LICENSE|"
  "compound-engineering|EveryInc/compound-engineering-plugin|skills|LICENSE|"
  "anthropics|anthropics/skills|skills||frontend-design,webapp-testing,mcp-builder,skill-creator,claude-api"
  "awesome-copilot|github/awesome-copilot|skills|LICENSE|${AWESOME_GH_SKILLS}"
)

skill_allowed() {
  local name="$1" allow="${2:-}"
  [ -z "$allow" ] && return 0
  case ",${allow}," in
    *",${name},"*) return 0 ;;
    *) return 1 ;;
  esac
}

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
    \( -name '*.md' -o -name 'LICENSE*' -o -name 'NOTICE*' \
       -o -path './scripts/*' -o -path './references/*' \) \
    | while read -r f; do
        mkdir -p "$target/$(dirname "$f")"
        cp "$f" "$target/$f"
      done)
}

write_pack_notice() {
  local pack="$1" dest="$2"
  case "$pack" in
    vercel-agent-skills)
      cat > "$dest/NOTICE.md" <<'EOF'
Upstream README at https://github.com/vercel-labs/agent-skills states this collection is MIT licensed. The clone does not ship a LICENSE file.
EOF
      ;;
    find-skills)
      cat > "$dest/NOTICE.md" <<'EOF'
Skill #0 / discovery only. This pack is find-skills, not the whole vercel-labs/skills CLI tree.
EOF
      ;;
    agent-browser)
      cat > "$dest/NOTICE.md" <<'EOF'
Vendored Agent Skill for the agent-browser CLI. Chromium install is optional; see scripts/install-agent-browser.sh and docs/agent-skill-packs.md.
EOF
      ;;
    trailofbits)
      cat > "$dest/NOTICE.md" <<'EOF'
Trail of Bits skills are CC-BY-SA-4.0. Discover a skill when the task needs it. Do not always-apply every security skill in this tree.
EOF
      ;;
    compound-engineering)
      cat > "$dest/NOTICE.md" <<'EOF'
Compound Engineering is the learn/compound layer. Do not run CE together with gstack, Superpowers, and pstack on the same task. Pick one spec/implement methodology per run.
EOF
      ;;
    anthropics)
      cat > "$dest/NOTICE.md" <<'EOF'
Subset of https://github.com/anthropics/skills: frontend-design, webapp-testing, mcp-builder, skill-creator, claude-api (Apache-2.0). pptx/xlsx/docx, art, branding, and gif skills are not vendored.
EOF
      ;;
    awesome-copilot)
      cat > "$dest/NOTICE.md" <<'EOF'
Subset only: GitHub issue, PR, Actions, and gh workflow skills. Upstream is 400+ skills; the rest stay on GitHub.
EOF
      ;;
  esac
}

copy_pack_license() {
  local src="$1" dest="$2" license_rel="${3:-}"
  if [ -n "$license_rel" ] && [ -f "$src/$license_rel" ]; then
    cp "$src/$license_rel" "$dest/$(basename "$license_rel")"
    return 0
  fi
  cp "$src/LICENSE" "$dest/LICENSE" 2>/dev/null || true
  cp "$src/LICENSE.md" "$dest/LICENSE.md" 2>/dev/null || true
}

extract_pack() {
  local pack="$1" repo="$2" subdir="$3" license_rel="${4:-}" allow="${5:-}"
  local src scanroot
  src="$(clone_repo "$repo")"
  scanroot="$src/$subdir"
  scanroot="${scanroot%/.}"
  scanroot="${scanroot%/}"

  for base in "$REPO_ROOT/.claude/skills" "$REPO_ROOT/.agents/skills"; do
    local dest="$base/$pack"
    rm -rf "$dest"
    mkdir -p "$dest"

    while read -r skill; do
      local dir b target
      dir="$(dirname "$skill")"
      if [ "$dir" = "$scanroot" ]; then
        if skill_allowed "_router" "$allow"; then
          mkdir -p "$dest/_router"
          cp "$skill" "$dest/_router/SKILL.md"
        fi
        continue
      fi
      b="$(basename "$dir")"
      skill_allowed "$b" "$allow" || continue
      target="$dest/$b"
      [ -e "$target" ] && target="$dest/${b}-alt"
      copy_skill_files "$dir" "$target"
    done < <(find "$scanroot" -name SKILL.md \
      -not -path '*/.git/*' -not -path '*/test/*' \
      -not -path '*/tests/*' -not -path '*/fixtures/*')

    copy_pack_license "$src" "$dest" "$license_rel"
    write_pack_notice "$pack" "$dest"

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
  IFS='|' read -r pack repo subdir license_rel allow <<< "$entry"
  extract_pack "$pack" "$repo" "$subdir" "$license_rel" "$allow"
done

echo "Done. Regenerate the index with: node scripts/gen-skills-index.js"
