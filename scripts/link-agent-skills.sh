#!/usr/bin/env bash
#
# link-agent-skills.sh
#
# Symlinks the repo-vendored agent skill packs into the user's home skill
# directories so they are active for agents that read ~/.claude/skills
# (Claude Code, Cursor) and ~/.agents/skills (Codex, Prime Agent) globally,
# not just from this repo's working tree.
#
# Idempotent and safe to run on every boot: it skips gracefully when the
# repo skill directories are not present (e.g. before the skills PR is merged).
#
# Called from `.cursor/environment.json` install after `npm ci`.
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
    ln -sfn "${pack%/}" "$home_dir/$name"
    echo "link-agent-skills: linked $home_dir/$name -> ${pack%/}"
  done
}

link_packs "$REPO_ROOT/.claude/skills"  "$HOME_DIR/.claude/skills"
link_packs "$REPO_ROOT/.agents/skills" "$HOME_DIR/.agents/skills"

echo "link-agent-skills: done"
