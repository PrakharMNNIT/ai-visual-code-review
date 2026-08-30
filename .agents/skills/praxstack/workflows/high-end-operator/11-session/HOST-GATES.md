# Host session gates

These are Claude Code (or host) built-ins. Do not reimplement them as project skills.

```text
Use the host commands. Do not write a substitute prompt pack.

- Large change, design first: /plan
- Window is full, need a summary: /context
- Window is full, need to shrink: /compact
- Review the current diff: /code-review (alias /review on some hosts)
- Security of this branch vs origin default (injection, auth, data exposure): /security-review

If this host has no such command, say so and stop. Do not invent /security-review behavior from memory.
```
