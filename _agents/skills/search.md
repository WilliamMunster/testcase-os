---
name: search
description: Search test cases and knowledge base by metadata filters (module, priority, risk, status, tags) and full-text content. Use this skill when the user wants to find test cases, filter by priority or risk level, search for specific keywords across the knowledge base, list pending reviews, or query cases by any combination of metadata fields. Triggers on "search cases", "find test cases", "show P0 cases", "list pending", "filter by module", or any test case lookup request.
---

# Search

Find test cases and business knowledge by filtering metadata and searching content.

## Workflow

0.  **加载上下文 / Load Context**:
    *   读取 `_system/context-map.yaml` 的预算和映射规则。
    *   读取 `_system/tag-taxonomy.yaml` 获取可用的标签分类。
    *   支持按 `category/value` 格式搜索 tags（如 `domain/ad-rpp`、`stage/smoke`、`technique/api`）。
    *   Read `_system/context-map.yaml` for budget and mapping rules. Read `_system/tag-taxonomy.yaml` for available tag categories. Support searching tags in `category/value` format.

1.  **Parse Query Parameters**:
    *   **Module**: Filter by directory name in `cases/`.
    *   **Frontmatter Metadata**: Filter by `priority`, `risk`, `source`, `status`, `review`.
    *   **Tags**: Match specific tags in `category/value` format (e.g., `domain/ad-rpp`, `stage/smoke`). Supports partial match on category prefix.
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
