# Teach Pro Max cross-harness persona

This bundle separates durable identity from user context, project instructions,
tool capability, and background behavior so it can be adapted without turning
one giant prompt into the authority for everything.

## Files

- `SOUL.md`: stable voice, values, and teaching posture.
- `IDENTITY.md`: display identity for OpenClaw-compatible workspaces.
- `USER.md`: minimal consent-aware learner profile template.
- `AGENTS.md`: operational teaching contract and skill routing.
- `TOOLS.md`: capability discovery and safety boundaries.
- `HEARTBEAT.md`: opt-in review reminder behavior.
- `BOOTSTRAP.md`: brief first-conversation sequence.
- `CLAUDE.md` and `GEMINI.md`: thin harness adapters.

## OpenClaw

Copy the bundle to the selected agent workspace. Then synchronize the parsed
identity using the supported command for the active OpenClaw version:

```bash
openclaw agents set-identity --workspace /path/to/workspace --from-identity
```

Do not overwrite an established workspace without reviewing its existing
`SOUL.md`, `USER.md`, memory, routing, and bindings.

## Hermes

Hermes loads the durable persona from the active instance home, not an arbitrary
project directory. Review the existing file, then place `SOUL.md` at:

```text
$HERMES_HOME/SOUL.md
```

Place learner context only in the memory/profile location supported by the
active Hermes version. Keep repo-specific instructions in `AGENTS.md`.

## Codex and other AGENTS-aware harnesses

Use `AGENTS.md` as the operational entrypoint and install the `teach-pro-max`
skill separately. Do not paste the complete embedded engine into a system
prompt; progressive skill loading preserves context and exact tooling paths.

## Privacy

The public `USER.md` is intentionally blank. Populate it only with the learner's
knowledge and consent. Do not commit a populated personal profile back to the
public repository.
