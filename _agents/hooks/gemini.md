# Gemini CLI Hook for testcase-os

## Session Start
- Load: `_agents/instructions/shared.md` — inject as system instruction on session start
- Read: `_system/active-context.md` — current sprint focus, blockers, next steps
- Config: `_system/config.yaml` — project configuration

## Skills Location
`_agents/skills/` — trigger by user request; load skill file content when invoked

## CLI-Specific Notes
- Gemini uses `@` syntax to reference files (e.g., `@_system/active-context.md`)
- System instructions are set via `GEMINI.md` or `--system-instruction` flag
- Gemini CLI supports `.gemini/` directory for project-level config
- Use `@` to pull in context files mid-conversation

## Integration
1. Create `.gemini/GEMINI.md` or `GEMINI.md` at project root referencing shared instructions
2. On session start, load shared instructions:
   ```
   @_agents/instructions/shared.md
   ```
3. For skills, reference the skill file when needed:
   ```
   @_agents/skills/case-design.md
   ```
4. Gemini config can also be set in `.gemini/settings.json`
