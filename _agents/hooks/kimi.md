# Kimi Code Hook for testcase-os

## Session Start
- Load: `_agents/instructions/shared.md` — load as session context on start
- Read: `_system/active-context.md` — current sprint focus, blockers, next steps
- Config: `_system/config.yaml` — project configuration

## Skills Location
`_agents/skills/` — trigger by user request; load skill content into conversation

## CLI-Specific Notes
- Kimi supports Chinese well — bilingual instructions (Chinese + English) work naturally
- Instructions can mix Chinese explanations with English technical terms
- Kimi Code uses `.kimi/` directory for project-level configuration
- Good at understanding context from Chinese requirement documents

## Integration
1. Create `.kimi/config.json` or `KIMI.md` at project root:
   ```json
   {
     "system_prompt_file": "_agents/instructions/shared.md"
   }
   ```
2. On session start, Kimi loads the system prompt automatically
3. For skills, reference the skill file in conversation:
   ```
   Read _agents/skills/case-design.md and follow the instructions
   ```
4. Bilingual tip: shared.md can contain both Chinese and English sections — Kimi handles both fluently
