# pstack model configuration

Per-role model overrides for pstack skills. Each pstack SKILL.md names its defaults in a Models section; the values here override those defaults. Delete a line to fall back to the skill default. A value of `inherit-parent` or `auto` runs that role on the parent session's model (the `Agent` call omits `model`); an alias entry in a panel list still counts toward that panel's fan-out.

These values are Cursor Task slugs confirmed in this workspace. Claude Code defaults (`claude-opus-4-8`, `claude-opus-5`, `claude-fable-5`, `claude-sonnet-5`, `claude-haiku-4-5`) do not resolve on Cursor Task. Opus 4.8 maps to `claude-opus-5-thinking-high`. Haiku maps to `composer-2.5-fast`. Strongest judgment uses Fable 5 xhigh.

feature, refactoring: claude-opus-5-thinking-high
bug-fix: claude-opus-5-thinking-high
perf-issue: claude-opus-5-thinking-high
hillclimb: claude-opus-5-thinking-high
judgment and prose: claude-opus-5-thinking-high
strongest judgment: claude-fable-5-thinking-xhigh
how explorer: claude-opus-5-thinking-high
how explainer: claude-opus-5-thinking-high
how critics: claude-opus-5-thinking-high, claude-fable-5-thinking-high, claude-sonnet-5-thinking-high, composer-2.5-fast
why investigators: claude-opus-5-thinking-high
why synthesizer: claude-opus-5-thinking-high
reflect tooling: claude-opus-5-thinking-high
reflect judgment, divergent, synthesizer: claude-opus-5-thinking-high
arena runners: claude-opus-5-thinking-high, claude-fable-5-thinking-high, claude-sonnet-5-thinking-high, composer-2.5-fast
arena cross-judge pool: claude-opus-5-thinking-high, claude-fable-5-thinking-high, claude-sonnet-5-thinking-high
swarm workers: claude-opus-5-thinking-high
architect runners: claude-opus-5-thinking-high, claude-fable-5-thinking-high, claude-sonnet-5-thinking-high, composer-2.5-fast
interrogate reviewers: claude-opus-5-thinking-high, claude-fable-5-thinking-high, claude-sonnet-5-thinking-high, composer-2.5-fast
