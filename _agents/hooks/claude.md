# Claude Code Hook for testcase-os

## Session Start
- Load: `_agents/instructions/shared.md` — project-wide instructions (auto-loaded via CLAUDE.md)
- Read: `_system/active-context.md` — current sprint focus, blockers, next steps
- Config: `_system/config.yaml` — project configuration

## Skills Location
`_agents/skills/` — Claude Code auto-discovers skill files; trigger by user request or slash command

## CLI-Specific Notes
- Use Read tool before editing any file
- Use Edit tool for modifications, Write tool for new files only
- Use Bash for shell commands, not for file operations
- CLAUDE.md at project root is the primary entry point — it should reference `_agents/instructions/shared.md`
- Skills are registered via `_agents/skills/*.md` and appear as slash commands

## Integration
1. Ensure `CLAUDE.md` exists at project root with:
   ```
   See _agents/instructions/shared.md for project instructions.
   ```
2. Skills in `_agents/skills/` are auto-discovered by Claude Code
3. No additional config needed — Claude Code reads CLAUDE.md on session start
