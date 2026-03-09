# testcase-os 设计文档

> 基于 telos 架构的通用测试知识库管理系统

## 1. 定位

- **通用模板**：任何测试团队 clone 后改配置即可使用（类似 telos-template）
- **Git 原生**：版本管理、协作、审计全部基于 Git
- **Markdown 优先**：所有用例、知识、经验以 md 卡片存储
- **Skill 驱动**：不自动注入上下文，所有操作通过 skill 显式触发
- **先个人后扩展**：第一版聚焦 QA Lead + QA Engineer，预留 Developer/PM 角色和 telos-team 升级路径

## 2. 核心设计原则

| # | 原则 | 说明 |
|---|------|------|
| 1 | Skill 驱动，不自动注入 | 不像 telos 的 session hook 自动加载上下文，所有操作通过 skill 显式触发 |
| 2 | 场景化 Skill | 用例导入、PRD→用例设计、提 Bug、执行跟踪等都是独立 skill |
| 3 | 任务跟踪 | 使用 testcase-os 做设计/执行/验证时，自动或手动记录当日任务日志 |
| 4 | 有据可依 | 每条用例必须标注来源（PRD / 公共库），无据可依的标识为 `source: untracked` |
| 5 | 业界对标 | 生成用例时对比业界成熟产品测试场景，补充遗漏，倒逼 PRD 完善 |
| 6 | 分级审核 | P0/P1 强制 `review: pending`；P2/P3 可通过配置免审；prompt 中明确免审则 `review: approved` |
| 7 | 风险驱动 | 每条用例标注风险等级（high/medium/low），支持基于风险的测试优先级排序 |

## 3. 目录结构

```
testcase-os/
├── _system/                    # 系统身份层
│   ├── identity.md             # 知识库身份：团队、项目、技术栈
│   ├── goals.md                # 质量目标 / 测试 OKR
│   ├── active-context.md       # 当前测试焦点、Sprint 状态
│   └── config.yaml             # 全局配置（Jira URL、项目 key 等）
│
├── _agents/                    # AI agent 层
│   ├── instructions/
│   │   └── shared.md           # AI agent 共享指令
│   ├── skills/                 # 场景化 skill（见 Section 5）
│   ├── commands/               # slash commands
│   └── hooks/                  # 可选 hooks（非自动注入）
│
├── cases/                      # 测试用例库（按模块组织）
│   ├── _index.md               # 用例库索引 + 统计
│   └── {module}/               # 按功能模块分目录
│       ├── _module.md          # 模块概述
│       └── TC-{MOD}-{NNN}.md   # 用例卡片
│
├── commons/                    # 公共测试用例库
│   ├── _index.md               # 公共库索引
│   ├── checklists/             # 通用 checklist 模板
│   ├── patterns/               # 常见测试模式（登录流程、支付流程等）
│   ├── methodology/            # 测试方法论
│   └── templates/              # 用例模板
│
├── knowledge/                  # 业务知识库
│   ├── _index.md
│   ├── domain/                 # 业务领域知识
│   └── tech/                   # 技术知识
│
├── experience/                 # 经验库
│   ├── _index.md
│   ├── incidents/              # 线上事故复盘（漏出 Bug 分析）
│   ├── missed-bugs/            # 测试遗漏分析
│   ├── techniques/             # 测试技巧和窍门
│   └── anti-patterns/          # 常见测试陷阱
│
├── evidence/                   # 执行证据（截图、日志、trace）
│   └── YYYY-MM-DD/             # 按日期组织
│
├── data/                       # 共享测试数据
│   └── {module}/               # 按模块组织（JSON/CSV/SQL）
│
├── journal/                    # 任务日志
│   └── YYYY-MM-DD.md           # 每日测试任务记录
│
├── scripts/                    # 工具脚本
│   ├── jira-cli.sh             # Jira CLI 对接
│   ├── import-gherkin.sh       # Gherkin → md 转化
│   ├── import-excel.sh         # Excel → md 转化
│   ├── sanitize.sh             # 脱敏工具
│   └── sanitize-rules.yaml     # 脱敏规则配置
│
├── team.yaml                   # 角色权限配置（预留）
├── setup.sh                    # 初始化脚本
├── .gitignore
└── README.md
```

## 4. 用例卡片格式

> 字段设计参照 Jira Xray、禅道、ONES 三大成熟平台，结合 testcase-os 特色（来源追溯、业界对标、审核机制）。

### 4.1 frontmatter 字段定义

| 字段 | 类型 | 必填 | 来源参照 | 说明 |
|------|------|------|----------|------|
| `id` | string | Y | 通用 | 唯一标识 TC-{MOD}-{NNN} |
| `title` | string | Y | 通用 | 用例标题 |
| `module` | string | Y | 禅道/ONES | 所属功能模块（对应 cases/{module}/ 目录） |
| `priority` | enum | Y | Jira/禅道 | P0 / P1 / P2 / P3 |
| `risk` | enum | Y | **testcase-os** | 测试风险等级：high / medium / low（用于风险驱动测试排序） |
| `type` | enum | Y | 禅道 | functional / performance / security / compatibility / usability |
| `stage` | list | N | 禅道 | 适用测试阶段：smoke / regression / acceptance / exploratory（可多选） |
| `status` | enum | Y | 通用 | draft / active / deprecated |
| `version` | int | N | 禅道 21.4 | 用例版本号，每次修改步骤时递增 |
| `automated` | bool | N | Xray | 是否已自动化，默认 false |
| `automation_ref` | string | N | Xray | 关联自动化脚本路径 |
| `precondition` | string | N | Xray/禅道 | 前置条件摘要（详细写在正文中） |
| `requirement_ref` | string | N | Xray/ONES | 关联需求（PRD ticket 或文档引用） |
| `design_ref` | string | N | **testcase-os** | 关联 UI/UX 设计稿链接（Figma/Sketch/Zeplin） |
| `source` | enum | Y | **testcase-os** | 用例来源：prd / commons / benchmark / untracked |
| `source_ref` | string | N | **testcase-os** | 来源引用（PRD 编号、公共库 ID 等） |
| `benchmark_ref` | string | N | **testcase-os** | 业界对标来源 |
| `benchmark_gaps` | list | N | **testcase-os** | 对标后发现的 PRD 缺失点 |
| `review` | enum | Y | **testcase-os** | pending / approved / rejected |
| `reviewer` | string | N | | 审核人 |
| `review_date` | date | N | | 审核日期 |
| `review_note` | string | N | | 审核批注 |
| `jira_ref` | string | N | Jira 集成 | 关联 Jira ticket |
| `tags` | list | N | 通用 | 标签 |
| `author` | string | Y | 通用 | 创建人 |
| `created` | date | Y | 通用 | 创建日期 |
| `updated` | date | Y | 通用 | 最后更新日期 |

### 4.2 卡片模板

```yaml
---
id: TC-RPP-001
title: RPP Impression 日志验证
module: RPP
priority: P0
risk: high
type: functional
stage: [regression, acceptance]
status: active
version: 1
automated: false
automation_ref: ""
precondition: "Staging 环境，maxAdsOnFirstPage=6"
requirement_ref: "PRD-2026-003 Section 4.2"

# 来源追溯（有据可依）
source: prd
source_ref: "PRD-2026-003 Section 4.2"
benchmark_ref: "Google Ads impression tracking"
benchmark_gaps:
  - "PRD 未定义 viewability 阈值（业界标准：50% 像素可见 1s+）"

# 审核
review: pending
reviewer: ""
review_date: ""
review_note: ""

# 关联
jira_ref: ""
tags: [impression, log-validation, RPP]
author: william
created: 2026-03-09
updated: 2026-03-09
---

# RPP Impression 日志验证

## 背景
RPP 广告展示后应生成对应的 Impression 日志，用于广告计费和效果追踪。

## 前置条件
- Staging 环境
- maxAdsOnFirstPage=6, maxAdsOnSearchPage_SP=6

## 测试步骤

| # | 步骤 | 输入数据 | 预期结果 |
|---|------|----------|----------|
| 1 | 搜索关键词 | SKU_RPP_みかん_Auto05 | 搜索结果页正常加载 |
| 2 | 启动 RPP Impression 日志尾部 | - | 日志开始记录 |
| 3 | 检查广告显示数量 | - | 至少 1 个广告展示 |
| 4 | 停止日志并导入 | - | 日志文件可正常解析 |
| 5 | 验证日志数量 | 预期 5 条 | 日志数 = 广告展示数 |
| 6 | 验证广告顺序 | - | 展示顺序与日志顺序一致 |

## 业界对标
> **Google Ads**: impression tracking 包括 viewability 检测（50% 像素可见 1s+）
> **Meta Ads**: 支持 impression deduplication 和 frequency capping 日志
>
> **PRD Gap**: 建议补充 viewability 阈值定义和 impression 去重机制

## 备注
```

### 4.3 步骤格式说明

采用表格式步骤（参照禅道的"步骤-预期"分离模式），每个步骤独立记录输入数据和预期结果，便于：
- 逐步执行时标记 pass/fail
- 精确定位失败步骤
- Bug 报告直接引用步骤编号

## 5. Skill 体系

### 5.1 Skill 清单

| Skill | 触发场景 | 说明 |
|-------|----------|------|
| **case-design** | "根据 PRD 设计测试用例" | 读 PRD → 读公共库/业务知识 → 业界对标 → 生成用例卡片 |
| **case-import** | "导入 Gherkin/Excel 用例" | 解析源文件 → 脱敏 → 转化为 md 卡片 |
| **case-review** | "审核用例" | 列出 pending 用例，辅助审核，更新 review 字段 |
| **case-execute** | "执行测试用例" | 引导逐步执行 → 记录 pass/fail → 生成证据 → 更新 journal |
| **case-report** | "生成测试报告" | 汇总 journal/ + cases/ 数据 → 生成覆盖率/通过率摘要 |
| **bug-file** | "提 Bug" | 从用例执行结果生成 Bug → 同步 Jira |
| **jira-sync** | "拉 PRD / 同步状态" | 双向：拉 PRD 内容、推 Bug、同步用例状态 |
| **knowledge-capture** | "记录业务知识" | 捕获业务规则到 knowledge/ |
| **experience-capture** | "记录经验教训" | 事故复盘、测试遗漏 → experience/ |
| **daily-track** | 自动/手动 | 记录当日测试任务（设计/执行/Bug 统计） |
| **benchmark** | "对标业界" | 搜索业界测试实践，补充用例，标注 PRD gap |
| **search** | "搜索用例" | 按模块/标签/来源/状态/风险搜索 |

### 5.2 case-design 核心流程

```
输入: PRD 文档（Jira ticket / 本地文件 / 粘贴文本）
  │
  ├─ 1. 提取测试点（功能点拆解）
  │
  ├─ 2. 匹配公共库模板
  │     └─ 搜索 commons/ 中相关 checklist 和方法论
  │
  ├─ 3. 业界对标搜索
  │     └─ Web 搜索同类产品测试场景
  │     └─ 标注 benchmark_ref 和 benchmark_gaps
  │
  ├─ 4. 生成用例卡片
  │     ├─ source: prd / commons / benchmark / untracked
  │     ├─ review: pending（默认）或 approved（prompt 明确免审）
  │     └─ 自动分配 ID: TC-{MODULE}-{NNN}
  │
  └─ 5. 输出 PRD Gap 报告
        └─ 汇总 benchmark_gaps，建议 BA 补充的需求点
```

### 5.3 daily-track 机制

```yaml
# journal/2026-03-09.md
---
date: 2026-03-09
sprint: Sprint-12
---

## 今日测试任务

### 用例设计
- [x] TC-RPP-015 ~ TC-RPP-018 (4 条，来自 PRD-2026-005)
- [ ] TC-SE-022 ~ TC-SE-025 (4 条，待审核)

### 用例执行
- TC-RPP-001 ~ TC-RPP-010: 8 passed, 2 failed

### Bug
- BUG-2026-042: RPP impression 日志缺失 (Jira: PROJ-1234)

### 统计
| 指标 | 数量 |
|------|------|
| 新增用例 | 8 |
| 执行用例 | 10 |
| 通过 | 8 |
| 失败 | 2 |
| 新增 Bug | 1 |
```

## 6. 角色权限（预留）

### 第一版：QA Lead + QA Engineer

| 角色 | 用例库 | 公共库 | 业务知识 | Bug | 经验库 | PRD |
|------|--------|--------|----------|-----|--------|-----|
| QA Lead | CRUD | CRUD | CRUD | CRUD | CRUD | R |
| QA Eng | CRUD | R | RW | CRU | CRW | R |

### 预留扩展

| 角色 | 用例库 | 公共库 | 业务知识 | Bug | 经验库 | PRD |
|------|--------|--------|----------|-----|--------|-----|
| Developer | R | R | R | CRU | RW | R |
| PM | R | R | R | R | R | RW |

权限通过 `team.yaml` 配置，参照 telos-team 的 RBAC 模型。

## 7. Jira 集成

### scripts/jira-cli.sh

基于 `jira-cli`（Atlassian 官方 CLI）封装：

| 命令 | 说明 |
|------|------|
| `jira-cli.sh pull-prd <ticket>` | 拉取 Jira ticket 内容作为 PRD 输入 |
| `jira-cli.sh create-bug <md-file>` | 从 Bug md 文件创建 Jira issue |
| `jira-cli.sh sync-status <ticket>` | 同步 Jira ticket 状态到本地用例 |
| `jira-cli.sh link-case <ticket> <case-id>` | 关联 Jira ticket 和测试用例 |

### jira-sync skill

AI agent 通过 skill 调用 jira-cli.sh，支持自然语言操作：
- "拉一下 PROJ-1234 的 PRD" → `jira-cli.sh pull-prd PROJ-1234`
- "把这个 Bug 提到 Jira" → `jira-cli.sh create-bug bugs/BUG-xxx.md`

## 8. 数据转化能力

### 8.1 Gherkin → md

`scripts/import-gherkin.sh` 解析 `.feature` 文件：
- Feature name → title
- Background → 前置条件
- Scenario steps → 测试步骤
- Examples → 参数化数据
- 自动标注 `source: untracked`（需人工补充来源）
- 自动标注 `review: pending`

### 8.2 Excel → md

`scripts/import-excel.sh` 解析 Excel/CSV：
- 列映射配置化（哪列是标题、步骤、期望结果等）
- 支持脱敏规则（`scripts/sanitize.sh`）

### 8.3 脱敏工具

`scripts/sanitize.sh` 支持：
- 正则替换（手机号、邮箱、IP、域名）
- 关键词替换（公司名、产品名映射表）
- 配置文件驱动：`scripts/sanitize-rules.yaml`

## 9. 升级路径

```
testcase-os (个人/小团队)
    │
    ├─ 添加 team.yaml 权限 → 多角色协作
    │
    ├─ 接入 telos-team 的 MCP Server → 标准化 API
    │
    └─ 接入 Git hooks (pre-commit 权限检查) → 审计日志
```

## 10. 第一版交付范围

### 必做（V1）
- [ ] 目录结构搭建 + setup.sh
- [ ] 用例卡片模板 + ID 规范
- [ ] case-design skill（PRD → 用例，含对标 + 审核 + 风险字段）
- [ ] case-import skill（Gherkin → md）
- [ ] case-execute skill（引导执行 + 记录证据）
- [ ] daily-track skill（任务日志）
- [ ] search skill（用例搜索）
- [ ] jira-sync skill + jira-cli.sh
- [ ] sanitize.sh 脱敏工具 + sanitize-rules.yaml
- [ ] team.yaml 预留
- [ ] README.md（EN / JA / ZH 三语）

### 延后（V2）
- [ ] case-review skill（批量审核）
- [ ] case-report skill（覆盖率/通过率报告生成）
- [ ] bug-file skill
- [ ] experience-capture skill
- [ ] benchmark skill（独立）
- [ ] import-excel.sh
- [ ] Developer/PM 角色实现
- [ ] telos-team 升级集成
- [ ] MCP Server 搜索/索引接入
- [ ] 执行记录实体（suite/plan/execution — 完整测试管理扩展）

## 11. 评审改进记录

> 2026-03-09 由 gemini / codex / kimi 三方独立评审后吸收的改进。

| 改进项 | 来源 | 版本 | 说明 |
|--------|------|------|------|
| 增加 `risk` 字段 | gemini | V1 | 支持风险驱动测试（RBT），P0 |
| 分级审核（P0/P1 强制，P2/P3 可免审） | kimi | V1 | 避免审核成为瓶颈 |
| 增加 `case-execute` skill | gemini + codex | V1 | 引导执行 + 证据记录 |
| 增加 `case-report` skill | gemini | V2 | 覆盖率/通过率报告生成 |
| 增加 `evidence/` 目录 | gemini | V1 | 执行证据存储（截图、日志） |
| 增加 `data/` 目录 | gemini | V1 | 共享测试数据 |
| 增加 `design_ref` 字段 | gemini | V1 | UI/UX 设计稿链接 |
| Experience 目录重构 | kimi | V1 | incidents/missed-bugs/techniques/anti-patterns |
| Commons 增加 `patterns/` | kimi | V1 | 常见测试模式库 |
| 执行记录实体（suite/plan/execution） | codex | V2 | 完整测试管理扩展 |
| MCP Server 搜索索引 | gemini | V2 | 大规模用例库性能支撑 |
| Skill 契约定义（输入/输出/错误/幂等） | codex | V2 | 提升 skill 可靠性 |

评审报告详见 `docs/reviews/` 目录。
