---
name: web-design-guidelines
description: Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practices".
metadata:
  author: vercel
  version: "1.0.0"
  argument-hint: <file-or-pattern>
---

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Read the **pinned** guidelines at `references/web-interface-guidelines.md` in this skill directory (do not fetch mutable `main`)
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the pinned guidelines
4. Output findings in the terse `file:line` format


## Pinned guidelines (do not fetch mutable main)

This install pins `vercel-labs/web-interface-guidelines` at commit `e3d624baaf29dc1fc645aff3e38f03e564d2d6b1`.
Read `references/web-interface-guidelines.md` in this skill directory. Do not fetch `raw.githubusercontent.com/.../main/command.md` at runtime (supply-chain / drift risk). Re-run `scripts/install-agent-skills.sh` to refresh the pin.

## Guidelines Source

Upstream: https://github.com/vercel-labs/web-interface-guidelines
This skill uses the pinned copy under `references/`. Do not WebFetch mutable `main`.

## Usage

When a user provides a file or pattern argument:
1. Read the pinned guidelines at `references/web-interface-guidelines.md` (do not fetch mutable `main`)
2. Read the specified files
3. Apply all rules from the pinned guidelines
4. Output findings using the format specified in the guidelines

If no files specified, ask the user which files to review.
