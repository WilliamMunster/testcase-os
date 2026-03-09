# Skill: Search

Find test cases and business knowledge by filtering metadata and searching content.

- **Trigger Phrases**: "Search test cases", "Find P0 cases in module {module}", "Search for 'payment' related cases", "Show pending cases"

## Workflow

1.  **Parse Query Parameters**:
    *   **Module**: Filter by directory name in `cases/`.
    *   **Frontmatter Metadata**: Filter by `priority`, `risk`, `source`, `status`, `review`.
    *   **Tags**: Match specific tags.
    *   **Content**: Perform full-text search on case title and body.

2.  **Execute Search**:
    *   Use `grep_search` and `glob` to scan files in `cases/` and `knowledge/`.
    *   Handle multi-criteria queries (e.g., `priority: P0 AND status: active`).

3.  **Format Results**:
    *   Present a table of findings with `ID | Title | Module | Priority | Risk | Status`.
    *   If many results are found, limit output and offer to refine the search.

4.  **Index Maintenance**:
    *   Optionally update `cases/_index.md` with new counts if inconsistencies are found during search.

## Result Format

| ID | Title | Module | Priority | Risk | Status |
|---|---|---|---|---|---|
| TC-RPP-001 | RPP Impression 日志验证 | RPP | P0 | high | active |
| TC-RPP-002 | RPP Click Tracking | RPP | P1 | high | active |

## Error Handling

*   If no results match, suggest widening the search or checking spelling.
*   If the directory `cases/` is empty, report this to the user.
