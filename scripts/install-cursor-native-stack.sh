#!/usr/bin/env bash
#
# install-cursor-native-stack.sh
#
# Fail-soft Cursor Cloud VM extras: bun (gstack setup), uv (Graphify / Serena),
# OpenSpec CLI, Graphify Cursor rule, then the durable skill flatten and
# agent-browser CLI. Never fails environment boot. Does not run Graphify
# indexing (optional, can be slow) or Serena project index.
#
# Called from `.cursor/environment.json` after `npm ci`.
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="${HOME:-/home/ubuntu}/.bun/bin:${HOME:-/home/ubuntu}/.local/bin:${PATH}"
mkdir -p "${HOME:-/home/ubuntu}/.local/bin"

try() {
  local label="$1"
  shift
  echo "native-stack: $label"
  if "$@"; then
    echo "native-stack: $label ok"
    return 0
  fi
  echo "native-stack: $label failed (continuing)" >&2
  return 0
}

if ! command -v bun >/dev/null 2>&1; then
  try "install bun" bash -lc 'curl -fsSL https://bun.sh/install | bash'
fi

if ! command -v uv >/dev/null 2>&1; then
  try "install uv" bash -lc 'curl -fsSL https://astral.sh/uv/install.sh | sh'
fi

if ! command -v openspec >/dev/null 2>&1; then
  try "install openspec" npm install -g --prefix "${HOME:-/home/ubuntu}/.local" @fission-ai/openspec@latest
fi

if ! command -v graphify >/dev/null 2>&1; then
  try "install graphifyy" uv tool install graphifyy
fi

if [ ! -f "$REPO_ROOT/.cursor/rules/graphify.mdc" ] && command -v graphify >/dev/null 2>&1; then
  try "graphify cursor install" graphify cursor install
fi

try "link-agent-skills" bash "$REPO_ROOT/scripts/link-agent-skills.sh"
try "install-agent-browser" bash "$REPO_ROOT/scripts/install-agent-browser.sh"

echo "native-stack: done"
