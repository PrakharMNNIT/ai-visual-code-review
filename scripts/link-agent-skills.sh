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

# Cursor Cloud Task slugs live in the repo sheet. Copy them to the path
# pstack skills read (~/.claude/pstack-models.md) and append the CLAUDE.md
# include. Skip when CURSOR_AGENT is unset so a local Claude Code home
# keeps its own override.
install_pstack_models() {
  local src="$REPO_ROOT/.cursor/pstack-models.md"
  local dest="$HOME_DIR/.claude/pstack-models.md"
  local claude_md="$HOME_DIR/.claude/CLAUDE.md"
  local include_line="@~/.claude/pstack-models.md"

  [ -f "$src" ] || { echo "link-agent-skills: $src not present, skipping pstack models"; return 0; }

  if [ "${CURSOR_AGENT:-}" != "1" ]; then
    echo "link-agent-skills: CURSOR_AGENT unset, leaving home pstack-models unchanged"
    return 0
  fi

  mkdir -p "$HOME_DIR/.claude"
  cp "$src" "$dest"
  echo "link-agent-skills: installed $dest"

  if [ -f "$claude_md" ] && grep -Fqx "$include_line" "$claude_md"; then
    echo "link-agent-skills: $claude_md already includes $include_line"
    return 0
  fi
  if [ -f "$claude_md" ] && [ -s "$claude_md" ]; then
    printf '\n%s\n' "$include_line" >> "$claude_md"
  else
    printf '%s\n' "$include_line" > "$claude_md"
  fi
  echo "link-agent-skills: wired $include_line into $claude_md"
}

link_packs "$REPO_ROOT/.claude/skills"  "$HOME_DIR/.claude/skills"
link_packs "$REPO_ROOT/.agents/skills" "$HOME_DIR/.agents/skills"
install_pstack_models

echo "link-agent-skills: done"
