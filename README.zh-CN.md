# testcase-os

> 基于 telos 架构的通用测试知识库管理系统。Git 原生、Markdown 优先、Skill 驱动。

## 概述

testcase-os 帮助 QA 团队使用 Git 和 Markdown 管理测试用例、知识和经验。没有专有数据库，没有供应商锁定——只有与现有开发工具配合使用的纯文本文件。

### 核心特性

- **Git 原生**: 内置版本控制、协作和审计追踪
- **Markdown 优先**: 所有测试用例以可读的 Markdown 卡片存储
- **Skill 驱动**: 无自动上下文注入——仅通过显式 Skill 触发
- **知识复用**: 包含检查清单、模式和知识方法的 Commons 库
- **经验闭环**: 追踪事故和遗漏的 Bug 以持续改进
- **业界对标**: 内置竞品分析支持

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/your-org/testcase-os.git
cd testcase-os
```

### 2. 运行设置

```bash
bash setup.sh
```

这将创建基本的目录结构并初始化配置文件。

### 3. 配置项目

编辑 `_system/config.yaml`：

```yaml
project:
  name: "Your Project"
  team: "QA Team"

jira:
  url: "https://jira.company.com"
  project_key: "PROJ"

review_policy:
  p0_requires_review: true
  p1_requires_review: true
  p2_requires_review: false
  p3_requires_review: false
```

### 4. 设置身份

在 `_system/identity.md` 中填写您的团队和项目信息。

### 5. 开始使用 Skill

```bash
# 从 PRD 设计测试用例
kimi-cli skill case-design --prd PRD-2026-001.md

# 记录今天的测试
kimi-cli skill daily-track

# 搜索测试用例
kimi-cli skill search --module user --priority P0
```

## 目录结构

```
testcase-os/
├── _agents/
│   └── instructions/
│       └── shared.md          # AI 代理指令
├── _system/
│   ├── identity.md            # 团队/项目身份
│   ├── goals.md               # 质量目标与 OKR
│   ├── active-context.md      # 当前冲刺焦点
│   └── config.yaml            # 项目配置
├── cases/                     # 测试用例库
│   ├── _index.md
│   └── {module}/
│       ├── _module.md
│       └── TC-{MOD}-{NNN}.md  # 测试用例卡片
├── commons/                   # 可复用测试资产
│   ├── checklists/            # 测试检查清单
│   ├── patterns/              # 测试模式
│   ├── methodology/           # 测试方法论
│   └── _index.md
├── knowledge/                 # 业务与技术知识
│   ├── domain/                # 业务领域知识
│   └── tech/                  # 技术知识
├── experience/                # 经验教训
│   ├── incidents/             # 线上事故
│   ├── missed-bugs/           # 测试遗漏
│   ├── techniques/            # 测试技巧
│   └── anti-patterns/         # 常见陷阱
├── journal/                   # 每日测试日志
│   └── YYYY-MM-DD.md
└── scripts/                   # 实用脚本
    ├── jira-cli.sh
    ├── import-excel.sh
    └── sanitize.sh
```

## 可用 Skill

### case-design
从 PRD 文档设计测试用例，包含业界对标。

```bash
kimi-cli skill case-design --prd PRD-2026-001.md --module user
```

### case-import
从 Gherkin 或 Excel 文件导入测试用例。

```bash
kimi-cli skill case-import --file features/login.feature --format gherkin
kimi-cli skill case-import --file tests.xlsx --format excel
```

### case-execute
通过分步引导执行测试用例。

```bash
kimi-cli skill case-execute --id TC-USER-001
```

### daily-track
记录每日测试活动和统计信息。

```bash
kimi-cli skill daily-track --today
```

### search
按各种条件搜索测试用例。

```bash
kimi-cli skill search --module user --priority P0
kimi-cli skill search --tag regression --status active
```

### jira-sync
与 Jira 同步以拉取 PRD 和提交 Bug。

```bash
kimi-cli skill jira-sync --pull-prd PROJ-1234
kimi-cli skill jira-sync --create-bug bugs/BUG-001.md
```

## 测试用例卡片格式

测试用例以带有 YAML 前置数据的 Markdown 文件存储：

```yaml
---
id: TC-USER-001
title: 使用有效数据注册用户
module: user
priority: P0
type: functional
stage: [smoke, regression]
status: active
source: prd
source_ref: "PRD-2026-001 Section 3.2"
review: pending
risk: high
risk_reason: "核心用户旅程"
author: qa-engineer
created: 2026-03-09
updated: 2026-03-09
tags: [registration, smoke, positive]
---

# 使用有效数据注册用户

## 背景
新用户必须能够使用邮箱和密码注册。

## 前置条件
- 用户在注册页面
- 邮箱尚未注册

## 测试步骤

| # | 步骤 | 输入数据 | 预期结果 |
|---|------|----------|----------|
| 1 | 输入邮箱 | user@test.com | 邮箱被接受 |
| 2 | 输入密码 | SecurePass123 | 密码被掩码，显示强度 |
| 3 | 点击注册 | - | 账户创建，发送确认邮件 |

## 业界对标
> **参考**: 竞品 X 要求 24 小时内完成邮箱验证
> **差距**: 我们的 PRD 未指定邮箱验证时间
```

### 前置数据字段

| 字段 | 必需 | 说明 |
|------|------|------|
| `id` | 是 | 唯一标识符 (TC-{MODULE}-{NNN}) |
| `title` | 是 | 测试用例标题 |
| `module` | 是 | 模块名称 |
| `priority` | 是 | P0/P1/P2/P3 |
| `type` | 是 | functional/performance/security/compatibility/usability |
| `source` | 是 | prd/commons/benchmark/untracked |
| `review` | 是 | pending/approved/rejected |
| `risk` | 推荐 | high/medium/low |
| `tags` | 否 | 标签列表 |

## 升级路径

### 个人/小团队（当前）
- 单一仓库
- 直接文件编辑
- 基于 Skill 的交互

### 团队规模（V2）
- 用于基于角色的权限的 `team.yaml`
- 用于审计日志的 Git 钩子
- MCP 服务器集成

### 企业版（telos-team 集成）
- 集中式用户管理
- 高级分析
- 多项目支持

## 贡献

我们欢迎贡献！详情请参阅 [Contributing Guide](CONTRIBUTING.md)。

### 添加 Commons

1. 在适当的 `commons/` 子目录中创建文件
2. 使用英文文件名（短横线连接）
3. 遵循现有格式
4. 更新 `commons/_index.md`

### 报告问题

使用 [issue tracker](https://github.com/your-org/testcase-os/issues) 报告 Bug 或请求功能。

## 许可证

MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件。

## 其他语言

- [English](README.md)
- [日本語](README.ja.md)

---

*基于 telos 架构原则构建。*
