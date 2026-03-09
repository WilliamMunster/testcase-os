# AI Agent Shared Instructions / AI 代理共享指令

> 本文档定义 testcase-os 的 AI agent 核心行为准则  
> This document defines the core behavior guidelines for testcase-os AI agents

---

## 身份定义 / Identity

testcase-os 是基于 telos 架构的通用测试知识库管理系统：
> testcase-os is a universal test knowledge base management system based on telos architecture:

- **Git 原生 / Git-Native**: 版本管理、协作、审计全部基于 Git  
  Version control, collaboration, and audit are all Git-based
  
- **Markdown 优先 / Markdown-First**: 所有用例、知识、经验以 Markdown 卡片存储  
  All test cases, knowledge, and experiences are stored as Markdown cards
  
- **Skill 驱动 / Skill-Driven**: 不自动注入上下文，所有操作通过 skill 显式触发  
  No automatic context injection; all operations are triggered explicitly via skills

---

## 可用 Skill 列表 / Available Skills

| Skill | 触发场景 / Trigger | 说明 / Description |
|-------|-------------------|-------------------|
| **case-design** | "根据 PRD 设计测试用例" / "Design test cases from PRD" | 读 PRD → 匹配公共库 → 业界对标 → 生成卡片  <br>Read PRD → Match commons → Benchmark → Generate card |
| **case-import** | "导入 Gherkin/Excel 用例" / "Import Gherkin/Excel cases" | Gherkin/Excel → md 卡片  <br>Convert Gherkin/Excel to md cards |
| **case-execute** | "执行测试用例" / "Execute test cases" | 逐步引导 → 记录证据 → 更新日志  <br>Step-by-step guidance → Record evidence → Update journal |
| **daily-track** | "记录今日测试" / "Log today's testing" | 创建/更新 journal/YYYY-MM-DD.md  <br>Create/Update journal/YYYY-MM-DD.md |
| **search** | "搜索用例" / "Search test cases" | 按模块/标签/优先级/风险搜索  <br>Search by module/tag/priority/risk |
| **jira-sync** | "同步 Jira" / "Sync with Jira" | 拉 PRD、提 Bug、同步状态  <br>Pull PRD, file bugs, sync status |

---

## 卡片格式规范 / Card Format Specification

### 模板引用 / Template Reference

所有用例卡片必须基于：
> All test case cards must be based on:

```yaml
# 引用模板 / Reference template
template: "commons/templates/test-case-card.md"
```

### Frontmatter 字段 / Frontmatter Fields

```yaml
---
# 基础字段 / Basic Fields
id: TC-{MODULE}-{NNN}           # 唯一标识 / Unique identifier
title: "用例标题"                # 用例标题 / Case title
module: "模块名"                 # 所属模块 / Module name
priority: P0|P1|P2|P3           # 优先级 / Priority
type: functional|performance|security|compatibility|usability  # 类型 / Type
stage: [smoke, regression, acceptance]  # 适用阶段 / Applicable stages
status: draft|active|deprecated # 状态 / Status

# 来源追溯 / Source Tracing
source: prd|commons|benchmark|untracked  # 来源 / Source
source_ref: ""                  # 来源引用 / Source reference
requirement_ref: ""             # 需求关联 / Requirement reference

# 业界对标 / Benchmark
benchmark_ref: ""               # 对标来源 / Benchmark source
benchmark_gaps: []              # PRD 缺失点 / PRD gaps identified

# 审核 / Review
review: pending|approved|rejected  # 审核状态 / Review status
reviewer: ""                    # 审核人 / Reviewer
review_date: ""                 # 审核日期 / Review date
review_note: ""                 # 审核批注 / Review note

# 风险 / Risk
risk: high|medium|low           # 风险等级 / Risk level
risk_reason: ""                 # 风险原因 / Risk reason

# 元数据 / Metadata
author: ""                      # 创建人 / Author
created: YYYY-MM-DD             # 创建日期 / Creation date
updated: YYYY-MM-DD             # 更新日期 / Last updated
tags: []                        # 标签 / Tags
---
```

### ID 格式 / ID Format

- **格式 / Format**: `TC-{MODULE}-{NNN}`
  - `TC`: Test Case 前缀 / Test Case prefix
  - `{MODULE}`: 模块缩写 / Module abbreviation (2-4 大写字母 / uppercase letters)
  - `{NNN}`: 3 位数字序号 / 3-digit sequential number

- **示例 / Examples**: 
  - `TC-RPP-001` (RPP 模块 / RPP module)
  - `TC-USER-042` (用户模块 / User module)

---

## 设计原则 / Design Principles

### 1. Skill 驱动，不自动注入 / Skill-Driven, No Auto-Injection

- 不像 telos 自动加载 session hook，所有操作必须显式触发  
  Unlike telos auto-loading session hooks, all operations must be explicitly triggered
- AI agent 不会主动修改文件，除非用户明确要求使用 skill  
  AI agent will not proactively modify files unless user explicitly requests using a skill

### 2. 有据可依 / Evidence-Based

- 每条用例必须标注来源（`source` 字段必填）
  Every case must have a source annotated (`source` field is required)
- 无据可依的标识为 `source: untracked`，并需说明原因  
  Untracked cases marked as `source: untracked` with justification

### 3. 业界对标 / Industry Benchmark

- 生成用例时主动搜索同类产品测试场景  
  Actively search for similar product test scenarios when generating cases
- 标注 `benchmark_ref` 和 `benchmark_gaps`，倒逼 PRD 完善  
  Annotate `benchmark_ref` and `benchmark_gaps` to drive PRD improvements

### 4. 分级审核 / Tiered Review

| 优先级 / Priority | 审核要求 / Review Requirement |
|------------------|------------------------------|
| P0 / P1 | 强制 `review: pending`，必须人工审核  <br>Mandatory `review: pending`, requires human review |
| P2 / P3 | 可配置免审，由 `config.yaml` 控制  <br>Can be configured for auto-approval via `config.yaml` |

### 5. 风险驱动 / Risk-Driven

- 每个用例必须评估 `risk` 等级（high/medium/low）
  Every case must have a `risk` level assessed (high/medium/low)
- `risk_reason` 说明高风险用例的测试重点  
  `risk_reason` explains the testing focus for high-risk cases

---

## 配置引用 / Configuration References

### 项目配置 / Project Config

```yaml
# _system/config.yaml
jira:
  url: "https://jira.company.com"
  project_key: "PROJ"
  
review_policy:
  p0_requires_review: true
  p1_requires_review: true
  p2_requires_review: false
  p3_requires_review: false
```

### 团队配置 / Team Config

```yaml
# team.yaml
roles:
  qa_lead:
    can_approve: [P0, P1, P2, P3]
  qa_engineer:
    can_approve: [P2, P3]
    can_create: [P0, P1, P2, P3]
```

---

## 执行指南 / Execution Guidelines

### 创建用例时 / When Creating Cases

1. 检查 `_system/active-context.md` 了解当前 Sprint 状态  
   Check `_system/active-context.md` for current sprint status
2. 匹配 `commons/` 中的相关 checklist 和方法论  
   Match relevant checklists and methodologies in `commons/`
3. 执行业界对标搜索  
   Perform industry benchmark search
4. 生成卡片并设置 `review: pending`（如需审核）
   Generate card and set `review: pending` (if review required)
5. 更新 `journal/YYYY-MM-DD.md` 记录设计活动  
   Update `journal/YYYY-MM-DD.md` to log design activity

### 执行用例时 / When Executing Cases

1. 读取用例卡片，按步骤引导执行  
   Read case card and guide execution step-by-step
2. 记录执行证据（截图、日志、录屏路径）
   Record execution evidence (screenshots, logs, recording paths)
3. 标记每一步的 pass/fail 状态  
   Mark pass/fail status for each step
4. 如有失败，协助生成 Bug 报告  
   Assist in generating bug report if failures occur
5. 更新 journal 执行统计  
   Update journal execution statistics

---

*最后更新 / Last Updated: 2026-03-09*
