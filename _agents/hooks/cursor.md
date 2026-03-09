# Cursor CLI Hook for testcase-os

## Session Start
- Load: `_agents/instructions/shared.md` — inject via `.cursorrules` or system prompt
- Read: `_system/active-context.md` — current sprint focus, blockers, next steps
- Config: `_system/config.yaml` — project configuration

## Skills Location
`_agents/skills/` — trigger by user request; Cursor can index skill files for context

## CLI-Specific Notes
- Cursor supports Plan / Ask / Agent modes — use Plan mode for multi-step tasks
- `.cursorrules` at project root is auto-loaded as system instructions
- MCP integration available via `mcp.json` in `.cursor/` directory
- Cursor indexes the full project — skills and instructions are searchable
- Supports `@file` and `@folder` references in chat

## Integration
1. Create `.cursorrules` at project root with shared instructions:
   ```bash
   cp _agents/instructions/shared.md .cursorrules
   ```
2. For MCP tools, configure `.cursor/mcp.json`:
   ```json
   {
     "mcpServers": {}
   }
   ```
3. For skills, reference in chat:
   ```
   @_agents/skills/case-design.md
   ```
4. Use Plan mode for complex test case design tasks
5. Cursor auto-indexes `_agents/` — skills appear in context search
