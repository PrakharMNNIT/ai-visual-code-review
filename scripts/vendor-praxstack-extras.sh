#!/usr/bin/env bash
#
# vendor-praxstack-extras.sh
#
# Adds Prax's public skills (slim Teach Pro Max), SAFETY.md, personas,
# operator workflows, and harness agent files on top of the new-skills/
# portfolio already copied into a praxstack pack dest.
#
# Usage:
#   scripts/vendor-praxstack-extras.sh <skills-and-personas-clone> <repo-root> <pack-dest>
#
# Do not copy personas/prax-lannister (personal memory / PII).
# Do not copy skills/ wholesale (legacy dump). Do not copy teach-pro-max
# evidence/, tests/, or zip archives.
set -euo pipefail

SRC="${1:?clone path}"
REPO_ROOT="${2:?repo root}"
DEST="${3:?pack dest}"

copy_skill_files() {
  local dir="$1" target="$2"
  mkdir -p "$target"
  (cd "$dir" && find . -type f \
    -not -path '*/.git/*' \
    -not -path '*/node_modules/*' \
    -not -name '*.zip' \
    \( -name '*.md' -o -name 'LICENSE*' -o -name 'NOTICE*' \
       -o -path './scripts/*' -o -path './references/*' -o -path './reference/*' \) \
    | while read -r f; do
        mkdir -p "$target/$(dirname "$f")"
        cp "$f" "$target/$f"
      done)
}

copy_teach_pro_max_slim() {
  local src="$1" dest="$2"
  local eng out d
  mkdir -p "$dest/references/prax-teach-v2" "$dest/scripts"
  cp "$src/SKILL.md" "$dest/SKILL.md"
  if [ -d "$src/scripts" ]; then
    cp -a "$src/scripts/." "$dest/scripts/" 2>/dev/null || true
  fi
  if [ -f "$src/references/PUBLIC-DISTRIBUTION.md" ]; then
    cp "$src/references/PUBLIC-DISTRIBUTION.md" "$dest/references/"
  fi
  eng="$src/references/prax-teach-v2"
  out="$dest/references/prax-teach-v2"
  [ -d "$eng" ] || return 0
  cp "$eng/SKILL.md" "$out/SKILL.md"
  for f in GLOSSARY-FORMAT.md LEARNING-RECORD-FORMAT.md MISSION-FORMAT.md RESOURCES-FORMAT.md STATUS.md; do
    [ -f "$eng/$f" ] && cp "$eng/$f" "$out/"
  done
  for d in references schemas runtime agents scripts; do
    [ -d "$eng/$d" ] || continue
    mkdir -p "$out/$d"
    (cd "$eng/$d" && find . -type f \
      -not -path '*/.git/*' \
      -not -path '*/node_modules/*' \
      -not -path '*/tests/*' \
      -not -path '*/test/*' \
      -not -path '*/evidence/*' \
      -not -name '*.zip' \
      -not -name 'uv.lock' \
      | while read -r f; do
          mkdir -p "$out/$d/$(dirname "$f")"
          cp "$eng/$d/$f" "$out/$d/$f"
        done)
  done
  cat > "$dest/NOTICE.md" <<'EOF'
Slimmed Teach Pro Max. Wrapper SKILL.md plus the prax-teach-v2 protocol
(SKILL.md, references, schemas, runtime, scripts). Upstream evidence/,
tests/, HTML mirrors, and zip archives are not vendored. Full engine:
https://github.com/praxstack/skills-and-personas/tree/main/skills/teach-pro-max
EOF
}

mkdir -p "$DEST"

# Public portable skills (README install commands).
if [ -d "$SRC/skills/teach-pro-max" ]; then
  copy_teach_pro_max_slim "$SRC/skills/teach-pro-max" "$DEST/teach-pro-max"
fi
for name in superimprove coding-agent-leadership-principles cross-agent-handoff; do
  if [ -d "$SRC/skills/$name" ]; then
    copy_skill_files "$SRC/skills/$name" "$DEST/$name"
  fi
done

[ -f "$SRC/SAFETY.md" ] && cp "$SRC/SAFETY.md" "$DEST/SAFETY.md"
[ -f "$SRC/LICENSE" ] && cp "$SRC/LICENSE" "$DEST/LICENSE"

# Portable markdown personas (on-demand references, not always-on rules).
if [ -d "$SRC/md-personas" ]; then
  mkdir -p "$DEST/personas/md-personas"
  cp -a "$SRC/md-personas/." "$DEST/personas/md-personas/"
fi

# Teach Pro Max cross-harness identity (USER.md is a blank template).
if [ -d "$SRC/personas/teach-pro-max-agent-persona" ]; then
  mkdir -p "$DEST/personas/teach-pro-max-agent-persona"
  (cd "$SRC/personas/teach-pro-max-agent-persona" && find . -type f -name '*.md' \
    | while read -r f; do
        mkdir -p "$DEST/personas/teach-pro-max-agent-persona/$(dirname "$f")"
        cp "$f" "$DEST/personas/teach-pro-max-agent-persona/$f"
      done)
fi

# Operator workflows (paste prompts, not a fifth methodology).
if [ -d "$SRC/prompts/high-end-operator" ]; then
  mkdir -p "$DEST/workflows/high-end-operator"
  (cd "$SRC/prompts/high-end-operator" && find . -type f -name '*.md' \
    | while read -r f; do
        mkdir -p "$DEST/workflows/high-end-operator/$(dirname "$f")"
        cp "$f" "$DEST/workflows/high-end-operator/$f"
      done)
fi
if [ -d "$SRC/prompts/project-alignment" ]; then
  mkdir -p "$DEST/workflows/project-alignment"
  cp -a "$SRC/prompts/project-alignment/." "$DEST/workflows/project-alignment/"
fi

# Constellation Claude Code / Cursor / Codex agents (harness-correct paths).
if [ -d "$SRC/.claude/agents" ]; then
  mkdir -p "$DEST/agents/claude" "$REPO_ROOT/.claude/agents" "$REPO_ROOT/.cursor/agents"
  cp -a "$SRC/.claude/agents/." "$DEST/agents/claude/"
  cp -a "$SRC/.claude/agents/." "$REPO_ROOT/.claude/agents/"
  cp -a "$SRC/.claude/agents/." "$REPO_ROOT/.cursor/agents/"
fi
if [ -d "$SRC/.codex/agents" ]; then
  mkdir -p "$DEST/agents/codex" "$REPO_ROOT/.codex/agents"
  cp -a "$SRC/.codex/agents/." "$DEST/agents/codex/"
  cp -a "$SRC/.codex/agents/." "$REPO_ROOT/.codex/agents/"
fi

echo "vendor-praxstack-extras: $DEST"
