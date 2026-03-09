# Skill: Daily Track

Create or update daily test activity logs by scanning recent git commits or accepting manual input.

- **Trigger Phrases**: "Update daily log", "Create journal for today", "Track my test activities", "Daily summary"

## Workflow

1.  **Initialize Journal**:
    *   Create `journal/YYYY-MM-DD.md` if it doesn't exist.
    *   Set the frontmatter with `date` and current `sprint` (from `_system/active-context.md` or `config.yaml`).

2.  **Scan Activities**:
    *   Check for recent git commits in the repository.
    *   Identify `case-design` and `case-execute` activities based on file changes in `cases/` or `journal/`.
    *   Check current branch for uncommitted changes.

3.  **Aggregate Statistics**:
    *   Count new cases designed.
    *   Count cases executed (from execution logs or user input).
    *   Count passed/failed steps/cases.
    *   Count new bugs filed.

4.  **Format Log**:
    *   Populate the `journal/YYYY-MM-DD.md` file using the standard template.
    *   Support manual entry mode if automatic detection is incomplete.

5.  **Summary Verification**:
    *   Display the updated daily statistics to the user.

## Journal Template

```yaml
---
date: YYYY-MM-DD
sprint: Sprint-XX
---

## 今日测试任务

### 用例设计
- [x] TC-XXX-NNN ~ TC-XXX-NNN (N条)

### 用例执行
- TC-XXX-NNN ~ TC-XXX-NNN: X passed, Y failed

### Bug
- BUG-YYYY-NNN: 描述

### 统计
| 指标 | 数量 |
|------|------|
| 新增用例 | N |
| 执行用例 | N |
| 通过 | N |
| 失败 | N |
| 新增 Bug | N |
```

## Error Handling

*   If `journal/` directory is missing, create it.
*   If `active-context.md` is missing, prompt user for the current Sprint name.
