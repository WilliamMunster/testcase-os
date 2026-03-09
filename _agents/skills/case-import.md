---
name: case-import
description: Import test cases from external formats (Gherkin .feature files, Excel, CSV) into testcase-os Markdown cards. Use this skill when the user wants to import, convert, or migrate test cases from other tools or file formats into the knowledge base. Triggers on "import cases", "convert feature file", "import from Excel/CSV", "migrate test cases", or any request involving external test case ingestion.
---

# Case Import

Import test cases from external formats (Gherkin, Excel) into standard testcase-os Markdown format.

## Workflow

0.  **加载上下文 / Load Context**:
    *   读取 `_system/context-map.yaml` 的预算和映射规则。
    *   读取 `_system/tag-taxonomy.yaml` 获取可用的标签分类。
    *   导入时为每个用例分配结构化 tags（从 taxonomy 中选取合适的 `category/value`）。
    *   Read `_system/context-map.yaml` for budget and mapping rules. Read `_system/tag-taxonomy.yaml` for available tag categories. Assign structured tags to each imported case (select appropriate `category/value` from taxonomy).

1.  **Select Import Strategy**:
    *   **Gherkin (.feature)**: Trigger `scripts/import-gherkin.sh` to parse feature files into MD cards.
    *   **Excel/CSV**: Trigger `scripts/import-excel.sh` (planned V2 placeholder). Use manual mapping if needed.

2.  **Sanitization**:
    *   Always run `scripts/sanitize.sh` on the source file before conversion to ensure no PII or sensitive internal data is imported.

3.  **Module Assignment**:
    *   Detect module from the filename or prompt the user: "Which module should these cases be assigned to?"
    *   Target path: `cases/{module}/`.

4.  **Duplicate Detection**:
    *   Check for existing case IDs or titles in the target module's directory.
    *   If duplicates exist, ask the user whether to skip, overwrite, or create a new version.

5.  **Post-Import Summary**:
    *   Summarize the import result.
    *   Include: Total cases imported, target module, and review status (default to `pending`).

## Metadata Injection

*   Set `source: untracked` (must be manually updated by user).
*   Set `review: pending`.
*   Assign new IDs if the source doesn't have compatible ones.
*   Assign structured tags from `_system/tag-taxonomy.yaml`:
    *   `domain/{value}` — infer from source filename or prompt user.
    *   `module/{value}` — match target module directory.
    *   `stage/regression` — default stage unless specified.
    *   `technique/{value}` — infer from test content (api, ui, etc.).

## Example Output

### Import Summary
```markdown
## Import Summary
- **Source**: `orders_v1.feature`
- **Module**: `OrderManagement`
- **Cases Imported**: 12
- **Status**: All marked as `pending` review.
- **Paths**: `cases/OrderManagement/TC-ORD-001.md` ...
```
