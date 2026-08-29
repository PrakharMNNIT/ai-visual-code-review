#!/usr/bin/env bash
#
# Best-effort install of Vercel agent-browser (CLI + Chromium) so agents can
# drive a real browser for visual QA. Failures must not fail environment boot.
#
# Cloud Agent VMs often cannot write /usr/lib/node_modules. Fall back to a
# user prefix at $HOME/.local.
set -u

PREFIX="${HOME:-/home/ubuntu}/.local"
export PATH="$PREFIX/bin:${PATH:-/usr/bin}"

if ! command -v npm >/dev/null 2>&1; then
  echo "install-agent-browser: npm not found, skipping"
  exit 0
fi

install_cli() {
  if command -v agent-browser >/dev/null 2>&1; then
    echo "install-agent-browser: CLI already on PATH ($(command -v agent-browser))"
    return 0
  fi
  echo "install-agent-browser: npm install -g agent-browser"
  if npm install -g agent-browser; then
    return 0
  fi
  echo "install-agent-browser: global install failed, trying --prefix $PREFIX"
  mkdir -p "$PREFIX"
  npm install -g agent-browser --prefix "$PREFIX"
}

if ! install_cli; then
  echo "install-agent-browser: CLI install failed, skipping"
  exit 0
fi

if command -v agent-browser >/dev/null 2>&1; then
  echo "install-agent-browser: agent-browser install"
  agent-browser install || echo "install-agent-browser: browser runtime install failed"
else
  echo "install-agent-browser: CLI not on PATH after install"
fi
