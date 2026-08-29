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
# Nesting 50+ gstack skills under .claude/skills/gstack/<skill>/ hides them
# from that index (they look like one opaque pack, or nothing). This script
# also flattens each gstack skill into .cursor/skills/<name> (project-local,
# relative symlink) and ~/.cursor/skills/<name> (home, official gstack Cursor
# path) using the SKILL.md `name:` field so /plan-ceo-review matches the
# GitHub tree. The pack itself stays at .claude/skills/gstack for Claude
# Code, Codex, and the gstack-skill-start preamble.
#
# Idempotent and safe to run repeatedly: it skips gracefully when the repo
# skill directories are not present (e.g. before the skills PR is merged).
#
# Called from `.cursor/environment.json` install (after `npm ci`).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOME_DIR="${HOME:-/home/ubuntu}"

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

gstack_skill_name() {
  local skill_md="$1"
  local name
  name="$(grep -m1 '^name:' "$skill_md" 2>/dev/null | sed 's/^name:[[:space:]]*//' | tr -d '[:space:]')"
  printf '%s' "$name"
}

# Replace only symlinks that already point at the vendored gstack pack.
# Never delete a user-owned Cursor skill directory.
prune_gstack_cursor_links() {
  local dir="$1"
  [ -d "$dir" ] || return 0
  local entry target
  for entry in "$dir"/*; do
    [ -e "$entry" ] || [ -L "$entry" ] || continue
    [ -L "$entry" ] || continue
    target="$(readlink "$entry")"
    case "$target" in
      *skills/gstack/*|*skills/gstack)
        rm -f "$entry"
        ;;
    esac
  done
}

link_abs_or_skip() {
  local src="$1" dest="$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "link-agent-skills: left in place (not a symlink): $dest"
    return 0
  fi
  ln -sfn "$src" "$dest"
}

# Flatten gstack/<skill> into Cursor's one-level skill roots.
link_gstack_cursor_skills() {
  local pack="$REPO_ROOT/.claude/skills/gstack"
  local project_dest="$REPO_ROOT/.cursor/skills"
  local home_dest="$HOME_DIR/.cursor/skills"
  local skill_dir dest_name rel linked

  [ -d "$pack" ] || { echo "link-agent-skills: no $pack, skipping Cursor flatten"; return 0; }

  mkdir -p "$project_dest" "$home_dest"
  prune_gstack_cursor_links "$project_dest"
  prune_gstack_cursor_links "$home_dest"

  linked=0
  for skill_dir in "$pack"/*/; do
    [ -d "$skill_dir" ] || continue
    [ -f "$skill_dir/SKILL.md" ] || continue
    dest_name="$(gstack_skill_name "$skill_dir/SKILL.md")"
    [ -n "$dest_name" ] || dest_name="$(basename "$skill_dir")"
    case "$dest_name" in
      *[!A-Za-z0-9._-]*|'') continue ;;
    esac
    rel="../../.claude/skills/gstack/$(basename "$skill_dir")"
    link_abs_or_skip "$rel" "$project_dest/$dest_name"
    link_abs_or_skip "${skill_dir%/}" "$home_dest/$dest_name"
    echo "link-agent-skills: cursor skill $dest_name -> ${skill_dir%/}"
    linked=$((linked + 1))
  done
  echo "link-agent-skills: flattened $linked gstack skills into $project_dest and $home_dest"
}

# pstack reads ~/.cursor/rules/pstack-models.mdc. Cloud Agent homes are
# ephemeral, so copy the repo-pinned map on every environment boot.
install_pstack_models() {
  local src="$REPO_ROOT/.cursor/rules/pstack-models.mdc"
  local dest_dir="$HOME_DIR/.cursor/rules"
  if [ ! -f "$src" ]; then
    echo "link-agent-skills: no $src, skipping pstack models"
    return 0
  fi
  mkdir -p "$dest_dir"
  cp "$src" "$dest_dir/pstack-models.mdc"
  echo "link-agent-skills: installed $dest_dir/pstack-models.mdc"
}

link_packs "$REPO_ROOT/.claude/skills"  "$HOME_DIR/.claude/skills"
link_packs "$REPO_ROOT/.agents/skills" "$HOME_DIR/.agents/skills"
link_gstack_cursor_skills
install_pstack_models

echo "link-agent-skills: done"
