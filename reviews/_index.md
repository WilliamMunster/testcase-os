# Reviews

> AI agent 评审报告存储目录。按模块组织，与 `cases/` 目录结构对应。
> AI agent review reports. Organized by module, mirroring the `cases/` directory structure.

## 结构 / Structure

```
reviews/
  {module}/
    {case-file}-review.md    # 对应 cases/{module}/{case-file}.md 的评审报告
```

## 状态流转 / Status Flow

| 状态 / Status | 说明 / Description |
|---|---|
| `pending-human-confirm` | AI 评审完成，等待人工确认 |
| `confirmed` | 人工已确认评审结果 |
| `resolved` | 所有问题已修复 |

## 关联 / Related

- 用例目录：`cases/`
- 评审模板：`commons/templates/review-report.md`
- 评审 skill：`_agents/skills/case-review.md`
