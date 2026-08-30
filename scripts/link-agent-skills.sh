#!/usr/bin/env bash
#
# link-agent-skills.sh
#
# Symlinks the repo-vendored agent skill packs into the user's home skill
# directories so they are active for agents that read ~/.claude/skills
# (Claude Code, Cursor) and ~/.agents/skills (Codex, Prime Agent) globally,
# not just from this repo's working tree.
#
# Cursor slash-command discovery indexes one level of skill directories:
#   .cursor/skills/<skill>/SKILL.md
#   ~/.cursor/skills/<skill>/SKILL.md
#   <plugin>/skills/<skill>/SKILL.md
# Nested packs (`.claude/skills/<pack>/<skill>/SKILL.md`) are invisible to
# that index. This script flattens every vendored SKILL.md into
# `.cursor/skills/<name>/` (project-local relative symlink) and
# `~/.cursor/skills/<name>/` (home) using the SKILL.md `name:` field.
# First pack in PACK_ORDER wins the short slash name; later collisions are
# installed as `<pack>-<name>` and recorded in docs/cursor-skill-collisions.md.
#
# Pack directories stay nested under .claude/skills/<pack> for Claude Code,
# Codex, and runtimes such as gstack-skill-start. Do not always-apply the
# flattened catalog — discovery is not personality.
#
# Idempotent and safe to run repeatedly: it skips gracefully when the repo
# skill directories are not present (e.g. before the skills PR is merged).
# Never deletes a user-owned (non-symlink) Cursor skill directory.
#
# Called from `.cursor/environment.json` install (after `npm ci`).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME:-/home/ubuntu}"
COLLISION_LOG="$REPO_ROOT/docs/cursor-skill-collisions.md"

# First listed pack wins the short slash-command name. awesome-copilot is last
# because it is a large toolbox shelf and collides more often.
PACK_ORDER=(
  gstack
  pstack
  superpowers
  mattpocock
  improve
  cursor-team-kit
  vercel-agent-skills
  addyosmani
  find-skills
  agent-browser
  trailofbits
  compound-engineering
  anthropics
  spec-kit
  microsoft
  aws
  cloudflare
  supabase
  openspec
  last30days
  agent-deep-research
  hallmark
  impeccable
  graphify
  awesome-copilot
)

link_packs() {
  local repo_dir="$1" home_dir="$2"
  [ -d "$repo_dir" ] || { echo "link-agent-skills: $repo_dir not present, skipping"; return 0; }
  mkdir -p "$home_dir"
  local pack name
  for pack in "$repo_dir"/*/; do
    [ -d "$pack" ] || continue
    name="$(basename "$pack")"
    # If a real (non-symlink) directory/file already occupies the target,
    # remove it first so ln does not create a nested link inside it.
    if [ -e "$home_dir/$name" ] && [ ! -L "$home_dir/$name" ]; then
      rm -rf "$home_dir/$name"
    fi
    ln -sfn "${pack%/}" "$home_dir/$name"
    echo "link-agent-skills: linked $home_dir/$name -> ${pack%/}"
  done
}

# YAML frontmatter `name:` (first match). Strips quotes and whitespace.
skill_frontmatter_name() {
  local skill_md="$1"
  local name
  name="$(grep -m1 '^name:' "$skill_md" 2>/dev/null | sed 's/^name:[[:space:]]*//; s/^["'\'']//; s/["'\'']$//' | tr -d '[:space:]')"
  printf '%s' "$name"
}

# Back-compat alias (tests and comments still mention this).
gstack_skill_name() {
  skill_frontmatter_name "$1"
}

valid_skill_slug() {
  case "$1" in
    *[!A-Za-z0-9._-]*|'') return 1 ;;
    *) return 0 ;;
  esac
}

# Replace only managed symlinks that already point at this repo's vendored
# packs. Never delete a user-owned Cursor skill directory, and never delete
# OpenSpec/Graphify-generated real files.
prune_managed_cursor_links() {
  local dir="$1"
  [ -d "$dir" ] || return 0
  local entry target
  for entry in "$dir"/*; do
    [ -e "$entry" ] || [ -L "$entry" ] || continue
    [ -L "$entry" ] || continue
    target="$(readlink "$entry")"
    case "$target" in
      *skills/gstack/*|*skills/gstack|*claude/skills/*|*agents/skills/*)
        rm -f "$entry"
        ;;
    esac
  done
}

# Back-compat name used by older comments / tests.
prune_gstack_cursor_links() {
  prune_managed_cursor_links "$1"
}

link_abs_or_skip() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "link-agent-skills: left in place (not a symlink): $dest"
    return 1
  fi
  ln -sfn "$src" "$dest"
  return 0
}

list_packs_in_order() {
  local packs_dir="$1"
  local p
  declare -A seen=()
  for p in "${PACK_ORDER[@]}"; do
    if [ -d "$packs_dir/$p" ]; then
      printf '%s\n' "$p"
      seen["$p"]=1
    fi
  done
  for p in "$packs_dir"/*/; do
    [ -d "$p" ] || continue
    p="$(basename "$p")"
    [ -n "${seen[$p]:-}" ] && continue
    printf '%s\n' "$p"
  done
}

relpath_from_cursor_skills() {
  local skill_dir="$1"
  python3 - "$REPO_ROOT/.cursor/skills" "$skill_dir" <<'PY'
import os, sys
print(os.path.relpath(sys.argv[2], sys.argv[1]))
PY
}

# Flatten every vendored <pack>/<...>/SKILL.md into Cursor's one-level roots.
# link_gstack_cursor_skills is the historical name; it now flattens all packs.
link_gstack_cursor_skills() {
  link_cursor_skills
}

link_cursor_skills() {
  local packs_dir="$REPO_ROOT/.claude/skills"
  local project_dest="$REPO_ROOT/.cursor/skills"
  local home_dest="$HOME_DIR/.cursor/skills"
  local pack skill_md skill_dir dest_name prefixed rel linked skipped
  local -a collisions=()

  [ -d "$packs_dir" ] || { echo "link-agent-skills: no $packs_dir, skipping Cursor flatten"; return 0; }

  mkdir -p "$project_dest" "$home_dest"
  prune_managed_cursor_links "$project_dest"
  prune_managed_cursor_links "$home_dest"

  declare -A claimed=()
  linked=0
  skipped=0

  while IFS= read -r pack; do
    [ -n "$pack" ] || continue
    while IFS= read -r -d '' skill_md; do
      skill_dir="$(dirname "$skill_md")"
      dest_name="$(skill_frontmatter_name "$skill_md")"
      [ -n "$dest_name" ] || dest_name="$(basename "$skill_dir")"
      valid_skill_slug "$dest_name" || { skipped=$((skipped + 1)); continue; }

      if [ -n "${claimed[$dest_name]:-}" ]; then
        prefixed="${pack}-${dest_name}"
        collisions+=("$dest_name	${claimed[$dest_name]}	$prefixed	$pack	$skill_dir")
        dest_name="$prefixed"
        if ! valid_skill_slug "$dest_name"; then
          skipped=$((skipped + 1))
          continue
        fi
        if [ -n "${claimed[$dest_name]:-}" ]; then
          dest_name="${pack}-$(basename "$skill_dir")"
          valid_skill_slug "$dest_name" || { skipped=$((skipped + 1)); continue; }
          if [ -n "${claimed[$dest_name]:-}" ]; then
            dest_name="${dest_name}-alt"
          fi
        fi
      fi

      rel="$(relpath_from_cursor_skills "$skill_dir")"
      if ! link_abs_or_skip "$rel" "$project_dest/$dest_name"; then
        skipped=$((skipped + 1))
        link_abs_or_skip "${skill_dir}" "$home_dest/$dest_name" || true
        claimed["$dest_name"]="$pack"
        continue
      fi
      link_abs_or_skip "${skill_dir}" "$home_dest/$dest_name" || true
      claimed["$dest_name"]="$pack"
      echo "link-agent-skills: cursor skill $dest_name -> $skill_dir"
      linked=$((linked + 1))
    done < <(find "$packs_dir/$pack" -name SKILL.md \
      -type f \
      -not -path '*/.git/*' \
      -not -path '*/node_modules/*' \
      -not -path '*/test/*' \
      -not -path '*/tests/*' \
      -not -path '*/fixtures/*' \
      -not -path '*/references/*' \
      -not -path '*/reference/*' \
      -not -path '*/scripts/*' \
      -not -path '*/vendor/*' \
      -print0)
  done < <(list_packs_in_order "$packs_dir")

  write_collision_log "${collisions[@]+"${collisions[@]}"}"

  echo "link-agent-skills: flattened $linked skills into $project_dest and $home_dest (skipped $skipped)"
}

write_collision_log() {
  mkdir -p "$(dirname "$COLLISION_LOG")"
  {
    echo "# Cursor skill name collisions"
    echo
    echo "Generated by \`scripts/link-agent-skills.sh\`. Cursor indexes one-level"
    echo "directories under \`.cursor/skills/<name>/SKILL.md\`. When two packs"
    echo "share a \`name:\` field, the **first pack in flatten order** keeps the"
    echo "short slash command and the later pack is installed as"
    echo "\`<pack>-<name>\`."
    echo
    echo "Flatten order is listed in \`PACK_ORDER\` inside the linker (gstack"
    echo "first, awesome-copilot last). Re-run the linker after adding a pack."
    echo
    if [ "$#" -eq 0 ]; then
      echo "No collisions on this run."
      echo
      return 0
    fi
    echo "| Short name | Winner pack | Prefixed install | Loser pack | Loser path |"
    echo "| --- | --- | --- | --- | --- |"
    local row short winner prefixed loser path
    for row in "$@"; do
      IFS='	' read -r short winner prefixed loser path <<< "$row"
      path="${path#"$REPO_ROOT"/}"
      echo "| \`$short\` | \`$winner\` | \`$prefixed\` | \`$loser\` | \`$path\` |"
    done
    echo
  } > "$COLLISION_LOG"
  echo "link-agent-skills: wrote $COLLISION_LOG ($# collisions)"
}

# pstack reads ~/.cursor/rules/pstack-models.mdc. Cloud Agent homes are
# ephemeral, so copy the repo-pinned map (and other always-apply rules) on
# every environment boot.
install_cursor_rules() {
  local src_dir="$REPO_ROOT/.cursor/rules"
  local dest_dir="$HOME_DIR/.cursor/rules"
  if [ ! -d "$src_dir" ]; then
    echo "link-agent-skills: no $src_dir, skipping Cursor rules"
    return 0
  fi
  mkdir -p "$dest_dir"
  local f
  for f in "$src_dir"/*.mdc; do
    [ -f "$f" ] || continue
    cp "$f" "$dest_dir/$(basename "$f")"
    echo "link-agent-skills: installed $dest_dir/$(basename "$f")"
  done
}

install_pstack_models() {
  install_cursor_rules
}

# Project MCP (Serena + Context7 only). Copy to the home Cursor config when
# the destination is missing so Cloud Agent boots pick it up. Never overwrite
# a user-owned ~/.cursor/mcp.json.
install_cursor_mcp() {
  local src="$REPO_ROOT/.cursor/mcp.json"
  local dest="$HOME_DIR/.cursor/mcp.json"
  if [ ! -f "$src" ]; then
    echo "link-agent-skills: no $src, skipping MCP copy"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ]; then
    echo "link-agent-skills: left in place (existing MCP config): $dest"
    return 0
  fi
  cp "$src" "$dest"
  echo "link-agent-skills: installed $dest"
}

link_packs "$REPO_ROOT/.claude/skills"  "$HOME_DIR/.claude/skills"
link_packs "$REPO_ROOT/.agents/skills" "$HOME_DIR/.agents/skills"
link_gstack_cursor_skills
install_pstack_models
if [ -f "$REPO_ROOT/scripts/link-praxstack-skills.sh" ]; then
  bash "$REPO_ROOT/scripts/link-praxstack-skills.sh"
fi
install_cursor_mcp

echo "link-agent-skills: done"
