---
name: obsidian-sync
description: Sync test cases and knowledge between testcase-os and Obsidian vault. Use this skill when the user wants to push test cases to Obsidian, search the Obsidian vault for related knowledge, append test results to daily notes, check backlinks between cases and knowledge, or bridge the gap between testcase-os markdown files and Obsidian's knowledge graph. Triggers on "sync to Obsidian", "push to vault", "search Obsidian", "link in Obsidian", "daily note", or any request involving Obsidian integration.
---

# Obsidian Sync

Bridge testcase-os with Obsidian for enhanced knowledge management and cross-referencing.

## Configuration

* Detect Obsidian CLI availability: check if `/Applications/Obsidian.app/Contents/MacOS/Obsidian` exists.
* Read vault path from `_system/config.yaml` under `obsidian.vault_path`.
* Fallback to direct file operations if Obsidian CLI is unavailable.

## Workflow

1. **Push Cases to Vault**:
   * Command: Copy selected test case cards from `cases/` to the configured Obsidian vault path.
   * Action: Maintain YAML frontmatter compatibility. Add Obsidian-specific `[[wikilinks]]` for cross-referencing.

2. **Search Vault Knowledge**:
   * Command: `$OBS search query="{keyword}"`.
   * Action: Search Obsidian vault for domain knowledge relevant to test design. Feed results into `case-design` skill.

3. **Daily Note Integration**:
   * Command: `$OBS daily:append content="{summary}"`.
   * Action: After test execution (`case-execute`), append execution summary to today's Obsidian daily note.

4. **Backlink Analysis**:
   * Command: `$OBS backlinks file="{case_id}"`.
   * Action: Find all notes in the vault that reference a specific test case, building a traceability map.

5. **Tag Sync**:
   * Command: `$OBS tags all counts`.
   * Action: Compare tags in testcase-os cases with Obsidian vault tags. Report mismatches.

## Mapping

| Input Intent | Action |
|---|---|
| "Push cases to Obsidian" | Copy cases/ to vault with wikilinks |
| "Search vault for {keyword}" | `$OBS search query="{keyword}"` |
| "Add to daily note" | `$OBS daily:append content="{summary}"` |
| "Show backlinks for {case}" | `$OBS backlinks file="{case}"` |
| "Sync tags" | Compare tags between testcase-os and vault |

## Error Handling

* If Obsidian CLI is not found, fall back to direct file operations on the vault directory.
* If vault path is not configured, prompt the user to add `obsidian.vault_path` to `_system/config.yaml`.
