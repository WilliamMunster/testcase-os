# Skill: Case Import

Import test cases from external formats (Gherkin, Excel) into standard testcase-os Markdown format.

- **Trigger Phrases**: "Import cases from Gherkin", "Convert Excel file to Markdown cases", "Import {file_path} to {module}"

## Workflow

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
