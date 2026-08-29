#!/usr/bin/env bash
#
# link-agent-skills.sh
#
# Symlinks the repo-vendored agent skill packs into the user's home skill
# directories so they are active for agents that read ~/.claude/skills
# (Claude Code, Cursor) and ~/.agents/skills (Codex, Prime Agent) globally,
# not just from this repo's working tree.
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
install_pstack_models

echo "link-agent-skills: done"
