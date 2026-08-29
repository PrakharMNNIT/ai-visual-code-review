#!/usr/bin/env bash
#
# install-agent-skills.sh
#
# Re-installs / refreshes the vendored agent skill packs into both
# .claude/skills/ (Claude Code, Cursor) and .agents/skills/ (Codex, Prime Agent).
#
# Slimmed install: SKILL.md, Markdown references, LICENSE/NOTICE files, and each
# skill's scripts/ and references/ directories. Upstream tests, binaries, zips,
# and plugin machinery stay out. Each pack keeps its upstream LICENSE when one
# exists.
#
# PACKS fields: name|github_repo|subdir|license_rel|allowlist|ref
#   allowlist: empty = every SKILL.md under subdir; otherwise comma-separated
#   skill directory basenames (the folder that contains SKILL.md).
#   ref: empty = default branch; otherwise a git tag or branch (depth-1 clone).
#
# spec-kit has no SKILL.md tree. The installer converts templates/commands/*.md
# into Agent Skills (constitution/specify/plan/tasks/implement plus the rest of
# the command set). Do not run `specify init` in this Express app.
#
# Usage:
#   ./scripts/install-agent-skills.sh            # refresh all packs
#
# Requires: git, coreutils, python3 (spec-kit conversion). Network: github.com.
set -euo pipefail

export GIT_TERMINAL_PROMPT=0

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Documented Microsoft subset. Upstream warns that loading all ~175 skills
# causes context rot. Prefer general engineering / Node / git / docs / review.
# Skip Azure SDK language dumps, Foundry, Kusto, M365, DebugView, podcast.
MICROSOFT_SKILLS="cloud-solution-architect,continual-learning,copilot-sdk,frontend-design-review,github-issue-creator,mcp-builder,microsoft-docs,skill-creator,wiki-agents-md,wiki-architect,wiki-changelog,wiki-llms-txt,wiki-onboarding,wiki-page-writer,wiki-qa,wiki-researcher"

# Spec Kit command templates converted to skills. Pin clone to this tag.
SPECKIT_TAG="v1.0.1"
SPECKIT_COMMANDS=(
  constitution specify plan tasks implement
  clarify analyze checklist converge taskstoissues
)

# pack_name|github_repo|subdir_to_scan_for_SKILL.md|license_path|optional_allowlist|optional_ref
PACKS=(
  "superpowers|obra/superpowers|skills|LICENSE||"
  "mattpocock|mattpocock/skills|skills|LICENSE||"
  "gstack|garrytan/gstack|.|LICENSE||"
  "pstack|cursor/plugins|pstack/skills|pstack/LICENSE||"
  "improve|shadcn/improve|skills|LICENSE.md||"
  "cursor-team-kit|cursor/plugins|cursor-team-kit/skills|cursor-team-kit/LICENSE||"
  "vercel-agent-skills|vercel-labs/agent-skills|skills|||"
  "addyosmani|addyosmani/agent-skills|skills|LICENSE||"
  "find-skills|vercel-labs/skills|skills|LICENSE|find-skills|"
  "agent-browser|vercel-labs/agent-browser|skills|LICENSE|agent-browser|"
  "trailofbits|trailofbits/skills|plugins|LICENSE||"
  "compound-engineering|EveryInc/compound-engineering-plugin|skills|LICENSE||"
  "anthropics|anthropics/skills|skills||frontend-design,webapp-testing,mcp-builder,skill-creator,claude-api|"
  "awesome-copilot|github/awesome-copilot|skills|LICENSE||"
  "spec-kit|github/spec-kit|templates/commands|LICENSE||${SPECKIT_TAG}"
  "microsoft|microsoft/skills|.github|LICENSE|${MICROSOFT_SKILLS}|"
  "aws|aws/agent-toolkit-for-aws|skills|LICENSE||"
  "cloudflare|cloudflare/skills|skills|LICENSE||"
  "supabase|supabase/agent-skills|skills|LICENSE||"
)

skill_allowed() {
  local name="$1" allow="${2:-}"
  [ -z "$allow" ] && return 0
  case ",${allow}," in
    *",${name},"*) return 0 ;;
    *) return 1 ;;
  esac
}

assert_github_slug() {
  local repo="$1"
  case "$repo" in
    *[!A-Za-z0-9._/-]*|/*|*/*/*|*//*|*/|*..*)
      echo "install-agent-skills: invalid GitHub repo slug: $repo" >&2
      exit 1
      ;;
  esac
  case "$repo" in
    */*) ;;
    *)
      echo "install-agent-skills: repo must be owner/name: $repo" >&2
      exit 1
      ;;
  esac
}

clone_repo() {
  local repo="$1"
  local ref="${2:-}"
  local key src
  assert_github_slug "$repo"
  key="$(echo "${repo}_${ref}" | tr '/' '_')"
  src="$TMP/$key"
  if [ -d "$src/.git" ]; then
    echo ">> reusing clone $repo ${ref:+@$ref}" >&2
    printf '%s' "$src"
    return 0
  fi
  echo ">> cloning $repo ${ref:+@$ref}" >&2
  if [ -n "$ref" ]; then
    git clone --depth 1 --branch "$ref" "https://github.com/$repo.git" "$src"
  else
    git clone --depth 1 "https://github.com/$repo.git" "$src"
  fi
  printf '%s' "$src"
}

copy_skill_files() {
  local dir="$1" target="$2"
  mkdir -p "$target"
  (cd "$dir" && find . -type f \
    -not -path '*/.git/*' \
    -not -path '*/node_modules/*' \
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
Full github/awesome-copilot skills/ toolbox shelf (ChatGPT portable install is --skill '*'). Slimmed to SKILL.md, Markdown, scripts/, and references/. Discover a skill when the task matches; do not always-apply the whole catalog.
EOF
      ;;
    spec-kit)
      cat > "$dest/NOTICE.md" <<'EOF'
GitHub Spec Kit command templates vendored as Agent Skills (pinned to tag v1.0.1).

Do not run `specify init` in this Express app — that would dump a Spec Kit project into application source.

For a greenfield repo:
  specify init --here --integration cursor-agent

Pin the CLI from the Git tag (not a random PyPI specify-cli):
  uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v1.0.1

Pick Spec Kit XOR gstack XOR Compound Engineering for spec. Never run CE + gstack + Superpowers + pstack on the same task.
EOF
      ;;
    microsoft)
      cat > "$dest/NOTICE.md" <<'EOF'
Selective subset of https://github.com/microsoft/skills (MIT). Microsoft warns that loading the whole set (~175 skills) causes context rot.

Allowlist (see scripts/install-agent-skills.sh MICROSOFT_SKILLS):
cloud-solution-architect, continual-learning, copilot-sdk, frontend-design-review,
github-issue-creator, mcp-builder, microsoft-docs, skill-creator, wiki-agents-md,
wiki-architect, wiki-changelog, wiki-llms-txt, wiki-onboarding, wiki-page-writer,
wiki-qa, wiki-researcher.

Skipped: Azure SDK language dumps, Foundry, Kusto, M365 Agents Toolkit, DebugView, podcast-generation, entra-agent-id.
EOF
      ;;
    aws)
      cat > "$dest/NOTICE.md" <<'EOF'
AWS agent toolkit skills from skills/ (core-skills + specialized-skills). Apache-2.0. Plugin duplicates under plugins/ are not copied. Discover on demand.
EOF
      ;;
    cloudflare)
      cat > "$dest/NOTICE.md" <<'EOF'
Cloudflare agent skills (Workers, Wrangler, Durable Objects, and related). Apache-2.0. Discover on demand.
EOF
      ;;
    supabase)
      cat > "$dest/NOTICE.md" <<'EOF'
Supabase agent skills (backend, Postgres, RLS). MIT. Discover on demand.
EOF
      ;;
  esac
}

copy_pack_license() {
  local src="$1" dest="$2" license_rel="${3:-}"
  if [ -n "$license_rel" ] && [ -f "$src/$license_rel" ]; then
    cp "$src/$license_rel" "$dest/$(basename "$license_rel")"
  else
    cp "$src/LICENSE" "$dest/LICENSE" 2>/dev/null || true
    cp "$src/LICENSE.md" "$dest/LICENSE.md" 2>/dev/null || true
  fi
  cp "$src/NOTICE" "$dest/NOTICE" 2>/dev/null || true
}

write_speckit_skill() {
  local src_md="$1" dest_dir="$2" skill_name="$3"
  mkdir -p "$dest_dir"
  python3 - "$src_md" "$dest_dir/SKILL.md" "$skill_name" <<'PY'
import sys
from pathlib import Path

src, dest, name = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3]
text = src.read_text(encoding="utf-8")
notice = (
    "\n> Vendored GitHub Spec Kit command template (**v1.0.1**). "
    "Do **not** run `specify init` inside this Express app. "
    "Use these skills for constitution / specify / plan / tasks / implement "
    "(and clarify / analyze / checklist / converge / taskstoissues). "
    "Greenfield: `specify init --here --integration cursor-agent`. "
    "CLI pin: `uv tool install specify-cli --from "
    "git+https://github.com/github/spec-kit.git@v1.0.1`. "
    "Helper scripts: this pack's `scripts/` directory. "
    "Document templates: this pack's `references/`.\n\n"
)
if text.startswith("---"):
    end = text.find("\n---", 3)
    if end == -1:
        raise SystemExit(f"unclosed frontmatter in {src}")
    fm = text[3:end]
    body = text[end + 4 :]
    if "\nname:" not in fm and not fm.lstrip().startswith("name:"):
        fm = f"\nname: {name}" + fm
    dest.write_text(f"---{fm}\n---\n{notice}{body}", encoding="utf-8")
else:
    dest.write_text(
        f"---\nname: {name}\ndescription: Spec Kit {name} command.\n---\n{notice}{text}",
        encoding="utf-8",
    )
PY
}

extract_spec_kit() {
  local src dest cmd
  src="$(clone_repo "github/spec-kit" "$SPECKIT_TAG")"
  for base in "$REPO_ROOT/.claude/skills" "$REPO_ROOT/.agents/skills"; do
    dest="$base/spec-kit"
    rm -rf "$dest"
    mkdir -p "$dest/references" "$dest/scripts"
    for cmd in "${SPECKIT_COMMANDS[@]}"; do
      write_speckit_skill "$src/templates/commands/${cmd}.md" "$dest/${cmd}" "speckit-${cmd}"
    done
    find "$src/templates" -maxdepth 1 -type f -name '*.md' -exec cp {} "$dest/references/" \;
    if [ -f "$src/spec-driven.md" ]; then
      cp "$src/spec-driven.md" "$dest/references/spec-driven.md"
    fi
    if [ -d "$src/scripts" ]; then
      cp -a "$src/scripts/." "$dest/scripts/"
    fi
    copy_pack_license "$src" "$dest" "LICENSE"
    write_pack_notice "spec-kit" "$dest"
    echo "   spec-kit -> $base/spec-kit ($(find "$dest" -name SKILL.md | wc -l | tr -d ' ') skills)"
  done
}

extract_pack() {
  local pack="$1" repo="$2" subdir="$3" license_rel="${4:-}" allow="${5:-}" ref="${6:-}"
  local src scanroot

  if [ "$pack" = "spec-kit" ]; then
    extract_spec_kit
    return 0
  fi

  src="$(clone_repo "$repo" "$ref")"
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
      -not -path '*/tests/*' -not -path '*/fixtures/*' \
      -not -path '*/node_modules/*' -not -path '*/.entire/*')

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
  IFS='|' read -r pack repo subdir license_rel allow ref <<< "$entry"
  extract_pack "$pack" "$repo" "$subdir" "$license_rel" "$allow" "$ref"
done

echo "Done. Regenerate the index with: node scripts/gen-skills-index.js"
