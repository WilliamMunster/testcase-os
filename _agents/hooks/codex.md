# Codex CLI Hook for testcase-os

## Session Start
- Load: `_agents/instructions/shared.md` — inject as system prompt
- Read: `_system/active-context.md` — current sprint focus, blockers, next steps
- Config: `_system/config.yaml` — project configuration

## Skills Location
`_agents/skills/` — trigger by user request; pass skill file path explicitly

## CLI-Specific Notes
- Codex works best with explicit file paths — always use full relative paths from project root
- System prompt is set via `AGENTS.md` or `codex --system-prompt` flag
- Codex prefers concise, structured instructions
- File references should be explicit (no glob patterns)

## Integration
1. Create `AGENTS.md` at project root with shared instructions content
2. Alternatively, pass system prompt on launch:
   ```bash
   codex --system-prompt "$(cat _agents/instructions/shared.md)"
   ```
3. For skills, explicitly reference the file:
   ```bash
   codex --file _agents/skills/case-design.md "design test cases for login"
   ```
4. Codex reads `AGENTS.md` automatically if present at project root
