---
type: case-review
target: "[[{case-file-name}]]"
module: "{module}"
reviewer: "ai-agent"
review_date: YYYY-MM-DD
status: pending-human-confirm
verdict: pass|needs-revision|reject
issues_count: 0
critical_count: 0
tags:
  - domain/{value}
  - stage/review
---

# Review: {case-file-name}

## 评审摘要

- 目标文件：[[{case-file-name}]]
- 评审结论：{pass|needs-revision|reject}
- 问题数：{n}（严重 {n} / 建议 {n}）

## 检查结果

### 完整性 / Completeness

| # | 用例 | 问题 | 严重度 | 建议 |
|---|------|------|--------|------|
| 1 | {case-name} | {issue} | Critical/Suggestion | {recommendation} |

### 正确性 / Correctness

| # | 用例 | 问题 | 严重度 | 建议 |
|---|------|------|--------|------|
| 1 | {case-name} | {issue} | Critical/Suggestion | {recommendation} |

### 来源追溯 / Traceability

| # | 用例 | 问题 | 严重度 | 建议 |
|---|------|------|--------|------|
| 1 | {case-name} | {issue} | High/Suggestion | {recommendation} |

### 知识一致性 / Knowledge Consistency

- 参考知识：[[{knowledge-card}]]
- 参考经验：[[{experience-card}]]
- 发现的不一致：{description or "无"}

### 风险评估 / Risk Assessment

| # | 用例 | 问题 | 严重度 | 建议 |
|---|------|------|--------|------|
| 1 | {case-name} | {issue} | Medium/Suggestion | {recommendation} |

### 规范性 / Compliance

| # | 问题 | 严重度 | 建议 |
|---|------|--------|------|
| 1 | {issue} | Low/Suggestion | {recommendation} |

## 修改建议

1. [Critical] {description}
2. [Suggestion] {description}

## 相关

- 原始用例：[[{case-file-name}]]
- 参考知识：[[{knowledge-cards}]]
- 参考经验：[[{experience-cards}]]
