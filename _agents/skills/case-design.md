---
name: case-design
description: Design high-quality test cases from PRD analysis. Use this skill when the user wants to create test cases based on a PRD, generate test cases for a feature or module, query Confluence for related knowledge, or extract test points from requirements. Triggers on phrases like "design test cases", "generate cases from PRD", "create test cases", "extract test points", or any request to turn requirements into structured test cases.
---

# Case Design

Design high-quality test cases by analyzing PRDs, matching existing common patterns, and querying Confluence for related knowledge.

## Workflow

Follow these 6 steps precisely:

### 0. 加载上下文 / Load Context
*   读取 `_system/context-map.yaml` 的预算和映射规则。
*   根据目标模块的 domain/module tag 匹配相关内容路径。
*   按预算限制加载参考文件（优先读取 frontmatter + 要点，前 50 行）。

### 1. 提取测试点 / Extract Test Points
*   读取提供的 PRD（Jira ticket、文档或文本）。
*   进行功能分解，识别核心功能、边界条件和约束。
*   输出测试点列表，带 ID（如 TP-01, TP-02）。

### 2. 匹配公共库 / Match Commons Library
*   搜索 `commons/` 中相关的 checklist、methodology 和 templates。
*   将通用模式（如登录、搜索、支付流程）应用到提取的测试点。

### 3. 查询 Confluence 知识 / Query Confluence Knowledge
*   读取 `_system/config.yaml` 中的 `confluence` 配置。
*   使用 Confluence REST API 搜索与当前 PRD 相关的知识页面：

```bash
curl -s -H "Authorization: Bearer $CONFLUENCE_API_TOKEN" \
  "{confluence.base_url}/rest/api/content/search?cql=space={confluence.space_key}+AND+text~'{关键词}'&limit=5&expand=body.view"
```

*   从返回结果中提取相关测试经验、已知问题、历史 bug 等信息。
*   如果 Confluence 不可用或未配置，跳过此步骤，仅依赖本地 `knowledge/` 和 `experience/`。

### 4. 生成用例文件 / Generate Test Case File
*   为每个 PRD 生成**单个** Markdown 文件：`cases/{module}/{JIRA-ID}-test-cases.md`
*   如果没有 Jira ID，使用 `cases/{module}/{feature-name}-test-cases.md`
*   文件包含 PRD 级别的 frontmatter 和用例表格（见下方模板）。
*   **Risk Assignment**:
    *   P0 → `risk: high`
    *   P1 → `risk: high` or `risk: medium`
    *   P2 → `risk: medium`
    *   P3 → `risk: low`

### 5. 输出 PRD 差距报告 / Output PRD Gap Report
*   汇总从 Confluence 知识和公共库匹配中发现的 PRD 遗漏点。
*   在文件末尾的「PRD 差距」章节中列出，供 BA/PM 确认。

## 输出文件模板 / Output Template

```markdown
---
prd_ref: "{jira_id or feature_name}"
module: "{module}"
title: "{feature_name} 测试用例"
priority: "{P0|P1|P2|P3}"
risk: "{high|medium|low}"
status: draft
source: prd
requirement_ref: "{requirement_id}"
confluence_refs:
  - "{confluence_page_title_1}"
  - "{confluence_page_title_2}"
jira_ref: "{jira_id}"
tags: []  # Use category/value format per _system/tag-taxonomy.yaml
author: "{agent_name}"
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# {Feature Name} 测试用例

## 背景
PRD 概要、功能意图、测试范围说明。

## 前置条件
- 环境、账号、数据等前提条件

## 测试用例

| # | 用例名称 | 优先级 | 前置条件 | 测试步骤 | 输入数据 | 预期结果 | 来源 | 备注 |
|---|---------|--------|---------|---------|---------|---------|------|------|
| 1 | {name} | P0 | {precondition} | {steps} | {data} | {expected} | prd | - |
| 2 | {name} | P1 | {precondition} | {steps} | {data} | {expected} | commons | - |

## Confluence 参考
从 Confluence 查询到的相关知识摘要（如无则标注"未查询到相关内容"）。

## PRD 差距
- **差距 1**: {description}
- **差距 2**: {description}

## 相关
- PRD: [[{jira_id}]]
- 知识: [[{knowledge_card}]]
- 经验: [[{experience_card}]]
```

## 用例表格字段说明

| 字段 | 说明 |
|------|------|
| # | 序号 |
| 用例名称 | 简洁描述测试场景 |
| 优先级 | P0/P1/P2/P3 |
| 前置条件 | 该条用例特有的前置条件 |
| 测试步骤 | 操作步骤描述 |
| 输入数据 | 测试数据 |
| 预期结果 | 期望的系统行为 |
| 来源 | prd / commons / confluence / experience |
| 备注 | 边界条件、风险点等补充 |
```
