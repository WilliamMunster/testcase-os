---
name: case-review
description: Review test cases with multi-dimension analysis. Use this skill when the user wants to review test cases, validate case quality, check completeness or correctness, or audit cases before execution. Triggers on phrases like "review test cases", "check case quality", "audit cases", "validate test cases", or any request to evaluate existing test case quality.
---

# Case Review

Review test cases with multi-dimension analysis: completeness, correctness, traceability, knowledge consistency, risk assessment, and compliance.

## Workflow

Follow these 6 steps precisely:

### 0. 加载上下文 / Load Context
*   读取 `_system/context-map.yaml` 的预算和映射规则。
*   根据目标用例的 module/domain tag 匹配相关内容路径。
*   加载目标 case 文件及其关联的 knowledge/ 和 experience/ 内容。
*   Read `_system/context-map.yaml` for budget and mapping rules.
*   Match content paths based on the target case's module/domain tags.
*   Load the target case file and its associated knowledge/ and experience/ content.

### 1. 解析用例文件 / Parse Case File
*   读取 `cases/{module}/{file}.md`，提取 frontmatter 和用例表格。
*   验证 frontmatter 字段完整性（对照 `commons/templates/test-case-card.md`）。
*   解析用例表格中的每一行，提取用例名称、步骤、预期结果等。
*   Read `cases/{module}/{file}.md`, extract frontmatter and case table.
*   Validate frontmatter field completeness (against `commons/templates/test-case-card.md`).
*   Parse each row in the case table: name, steps, expected results, etc.

### 2. 多维度评审 / Multi-Dimension Review

按优先级依次检查以下维度：
Check the following dimensions in priority order:

#### 完整性 / Completeness (Critical)
- 每条用例的步骤是否完整、可执行
- 预期结果是否明确、可验证
- 边界条件是否覆盖（空值、极值、异常输入）
- 前置条件是否充分
- Are steps complete and executable for each case?
- Are expected results clear and verifiable?
- Are boundary conditions covered (null, extreme, abnormal input)?
- Are preconditions sufficient?

#### 正确性 / Correctness (Critical)
- 步骤逻辑是否合理、顺序是否正确
- 预期结果是否与需求一致
- 测试数据是否合理
- Are step logic and sequence correct?
- Do expected results match requirements?
- Is test data reasonable?

#### 来源追溯 / Traceability (High)
- 每条用例的 source 字段是否有据可依
- 与 PRD / Jira ticket 的对应关系是否清晰
- requirement_ref 是否填写
- Does each case have a valid source?
- Is the mapping to PRD / Jira ticket clear?
- Is requirement_ref populated?

#### 知识一致性 / Knowledge Consistency (High)
- 与 knowledge/ 中的已有知识是否一致
- 与 experience/ 中的历史教训是否矛盾
- 是否遗漏已知问题或常见缺陷模式
- Is the case consistent with existing knowledge/?
- Does it contradict lessons in experience/?
- Are known issues or common defect patterns missed?

#### 风险评估 / Risk Assessment (Medium)
- risk 等级是否与优先级匹配（P0→high, P1→high/medium, P2→medium, P3→low）
- 高风险场景是否有足够的用例覆盖
- risk_reason 是否填写
- Does risk level match priority (P0→high, P1→high/medium, P2→medium, P3→low)?
- Do high-risk scenarios have sufficient case coverage?
- Is risk_reason populated?

#### 规范性 / Compliance (Low)
- 格式是否符合 `commons/templates/test-case-card.md` 模板
- tags 是否符合 `_system/tag-taxonomy.yaml` 的 category/value 格式
- ID 格式是否符合 `_system/config.yaml` 的 id_format
- Does format comply with `commons/templates/test-case-card.md`?
- Do tags follow `_system/tag-taxonomy.yaml` category/value format?
- Does ID format match `_system/config.yaml` id_format?

### 3. 生成 Review Report / Generate Review Report
*   基于 `commons/templates/review-report.md` 模板生成报告。
*   写入 `reviews/{module}/{case-file}-review.md`。
*   如果 `reviews/{module}/` 目录不存在，先创建。
*   Generate report based on `commons/templates/review-report.md`.
*   Write to `reviews/{module}/{case-file}-review.md`.
*   Create `reviews/{module}/` directory if it doesn't exist.

### 4. 更新原始 case 的 frontmatter / Update Original Case Frontmatter
*   将 `review: pending` 更新为 `review: reviewed`（agent 评审完成，待人工确认）。
*   添加 `review_note: "见 [[{review-report-name}]]"`。
*   Update `review: pending` to `review: reviewed` (agent review done, pending human confirm).
*   Add `review_note: "见 [[{review-report-name}]]"`.

### 5. 输出摘要 / Output Summary
*   显示评审结论（pass / needs-revision / reject）。
*   列出关键发现和建议修改项。
*   Display verdict (pass / needs-revision / reject).
*   List key findings and suggested changes.

## 评审结论判定 / Verdict Criteria

| 结论 / Verdict | 条件 / Condition |
|---|---|
| **pass** | 无 Critical 问题，High 问题 ≤ 2 且均为建议性 |
| **needs-revision** | 有 Critical 问题，或 High 问题 > 2 |
| **reject** | Critical 问题 ≥ 3，或用例整体不可用 |

## Review Report 模板引用 / Report Template Reference

```yaml
template: "commons/templates/review-report.md"
```
