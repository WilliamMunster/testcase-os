# testcase-os 设计审查与公共测试用例语料库分析报告

> 分析日期: 2026-03-09  
> 分析师: Kimi

---

## 第一部分：设计审查 (Task A)

### 1. 用户体验与工作流评估

#### 1.1 Skill-driven（无自动注入）方法的实用性

**评估**: ⚠️ **需要优化**

| 优点 | 缺点 |
|------|------|
| 上下文可控，避免信息过载 | 增加记忆负担，QA需要记住skill名称 |
| 显式操作，意图清晰 | 新手入门门槛提高 |
| 便于审计追踪 | 日常高频操作可能显得繁琐 |

**建议**:
- 提供 `help` 或 `?` skill 快速列出可用技能
- 高频操作（如 `daily-track`）可考虑提供快捷指令
- 在 AI agent 中内置模糊匹配，如"记录今天的测试"自动映射到 `daily-track`

#### 1.2 Daily-track 机制的现实性

**评估**: ✅ **基本可行，但需简化**

当前设计需要手动维护 Markdown 任务列表，实际工作中 QA 可能更习惯：
- Jira/Xray 等工具的已有看板
- 简单的 checklist 而非结构化日志

**建议**:
- `daily-track` 应支持从 Jira 自动拉取当日任务
- 提供两种模式：自动化（基于 Jira 活动）和 手动（Markdown 编辑）
- 统计部分应自动生成，而非手动填写

#### 1.3 Review Gate（review: pending）对工作流速度的影响

**评估**: ⚠️ **可能成为瓶颈**

设计规定默认 `review: pending`，这意味着：
- 每个用例都需要人工审核才能进入 active 状态
- 快速迭代的敏捷团队可能感到阻塞

**建议**:
- 按优先级差异化处理：P0/P1 强制审核，P2/P3 可免审
- 提供批量审核 skill (`case-review-batch`)
- 允许设置 "可信作者" 名单，其创建的用例自动 approved
- sprint 后期可临时放宽审核要求（通过 config.yaml 开关）

---

### 2. Knowledge Reuse 设计评估 (commons/)

#### 2.1 当前结构是否充分

```
commons/
├── checklist/      # ✅ 清晰
├── methodology/    # ✅ 清晰
└── templates/      # ✅ 清晰
```

**评估**: 基础结构合理，但建议增加：

| 建议新增 | 用途 |
|----------|------|
| `commons/patterns/` | 常见测试模式（如登录流程、支付流程） |
| `commons/regression-suites/` | 回归测试套件模板 |
| `commons/compat-matrix/` | 兼容性测试矩阵模板 |

#### 2.2 commons/ 与 cases/ 的交互设计

**建议采用 "引用 + 继承" 混合模式**:

```yaml
# cases/rpp/TC-RPP-001.md
---
# 引用公共库
template_ref: "commons/templates/web-form-validation"
checklist_ref: 
  - "commons/checklists/security-top10"
  - "commons/checklists/performance-baseline"

# 继承后可本地覆盖
priority: P0  # 覆盖模板默认值
---
```

**链接机制**:
- `source: commons` 时，`source_ref` 指向具体的 commons/ 条目
- 支持 `inherit-from` 字段实现模板继承

#### 2.3 commons/ 版本控制

**建议**:
- 使用 Git tag 标记 commons/ 版本（如 `commons-v1.2.0`）
- 在用例卡片中记录使用的 commons 版本：
  ```yaml
  commons_version: "v1.2.0"
  ```
- 提供 `commons-upgrade` skill 自动检查并提示最佳实践更新

---

### 3. Experience Library 设计评估 (experience/)

#### 3.1 escapes/ vs lessons/ vs best-practices/ 的清晰度

**评估**: ⚠️ **边界模糊，容易混淆**

| 目录 | 定义 | 问题 |
|------|------|------|
| escapes/ | 漏出复盘（线上 Bug）| 与 lessons/ 区别不清 |
| lessons/ | 经验教训 | 定义过于宽泛 |
| best-practices/ | 最佳实践 | 与 methodology/ 重复 |

**建议重新定义**:

```
experience/
├── incidents/          # 线上事故复盘（原 escapes/）
├── missed-bugs/        # 测试遗漏分析
├── techniques/         # 测试技巧/窍门
└── anti-patterns/      # 常见陷阱
```

#### 3.2 反馈闭环设计

**关键问题**: 如何避免 experience/ 成为 "知识的坟墓"

**建议机制**:

1. **强制关联**: 每个 experience 条目必须关联至少一个用例或 PRD
   ```yaml
   # experience/incidents/INC-2026-001.md
   related_cases:
     - "TC-RPP-015"
     - "TC-RPP-018"
   related_prd: "PRD-2026-003"
   ```

2. **定期检查**: `experience-review` skill 每月提示：
   - 哪些 experience 条目尚未关联用例
   - 哪些用例可能需要基于 experience 更新

3. **设计时提醒**: `case-design` skill 自动匹配相关 experience

#### 3.3 经验库活跃度指标

在 `_index.md` 中自动统计：
- 未关联的 experience 数量
- 最近 30 天新增的 experience
- 被引用次数最多的 experience TOP5

---

### 4. 国际化 (i18n) 支持评估

#### 4.1 结构层面的 i18n 支持

**评估**: ✅ **结构基本支持，但需明确约定**

当前设计使用英文作为元数据语言（字段名、枚举值），内容是中文。

**建议增强**:

1. **目录级语言标记**:
   ```
   cases/
   ├── zh/           # 中文用例
   ├── en/           # 英文用例
   └── ja/           # 日文用例
   ```

2. **用例卡片增加语言标记**:
   ```yaml
   lang: zh-CN
   # 或
   i18n:
     original: TC-RPP-001
     translations:
       en: TC-RPP-001-en
       ja: TC-RPP-001-ja
   ```

3. **commons/ 的语言策略**:
   - checklist/ 和 methodology/ 按语言分目录
   - 或统一用英文，内容本地化

---

## 第二部分：公共测试用例语料库分析 (Task B)

### 1. 文件概览

| 文件名 | 领域分类 | 用例数 | 格式 |
|--------|----------|--------|------|
| 典型应用、其他.xlsx | 典型应用/其他 | 79 | xlsx |
| 界面、控件.xlsx | UI/UX | 29 | xlsx |
| 安装.xlsx | 安装/部署 | 36 | xlsx |
| 流程.xlsx | 业务流程 | 7 | xlsx |
| 文档.xlsx | 文档测试 | 5 | xlsx |
| 自定义查询.xlsx | 查询功能 | 23 | xlsx |
| 查询.xlsx | 查询功能 | 10 | xlsx |
| 数据移植.xlsx | 数据迁移 | 22 | xlsx |
| 统计.xlsx | 报表统计 | 20 | xlsx |
| 权限.xlsx | 权限控制 | 21 | xlsx |
| 增删改.xlsx | CRUD | 58 | xlsx |
| IO.xlsx | 文件IO | 25 | xlsx |
| 【接口测试】之接口测试公共用例.xls | 接口测试 | ~50* | xls |
| 【涉款公共用例】功能.txt | 支付功能 | ~30* | txt |

**总计: ~415 个测试用例**

*注: xls 和 txt 文件未完整解析，用例数为估算*

### 2. Excel 文件结构分析

#### 2.1 数据结构（转置格式）

每 4 行组成一个测试用例：

| 行偏移 | 字段 | 示例值 |
|--------|------|--------|
| +0 | Headline | "界面测试：总体" |
| +1 | Priority | "1 － 高" / "2 － 中" |
| +2 | 用例类型 | "功能特性" |
| +3 | Description | 包含前置条件/步骤/输入/预期结果 |

#### 2.2 Description 解析格式

Description 使用 `*****` 分隔符：

```
*********承前条件**************
[前置条件内容]

*********执行步骤**************
[步骤内容]

*********输入数据**************
[输入数据]

*********预期结果**************
[预期结果]
```

**注意**: 部分用例使用 `执行步骤&输入数据` 合并格式。

### 3. 按测试领域分类

```
┌─────────────────────────────────────────────────────┐
│                    测试领域分布                      │
├─────────────────┬──────────┬────────────────────────┤
│ 领域            │ 用例数   │ 对应文件               │
├─────────────────┼──────────┼────────────────────────┤
│ CRUD操作        │ 58       │ 增删改.xlsx            │
│ 典型应用/其他   │ 79       │ 典型应用、其他.xlsx    │
│ UI/控件         │ 29       │ 界面、控件.xlsx        │
│ 安装/部署       │ 36       │ 安装.xlsx              │
│ 查询            │ 33       │ 查询.xlsx + 自定义查询 │
│ 接口测试        │ ~50      │ 【接口测试】...xls     │
│ 权限控制        │ 21       │ 权限.xlsx              │
│ 数据移植        │ 22       │ 数据移植.xlsx          │
│ 报表统计        │ 20       │ 统计.xlsx              │
│ 业务流程        │ 7        │ 流程.xlsx              │
│ 文件IO          │ 25       │ IO.xlsx                │
│ 支付/涉款       │ ~30      │ 【涉款公共用例】...txt │
│ 文档测试        │ 5        │ 文档.xlsx              │
└─────────────────┴──────────┴────────────────────────┘
```

### 4. 脱敏需求分析

#### 4.1 识别出的敏感信息

| 敏感类型 | 示例 | 来源文件 |
|----------|------|----------|
| **行业术语** | 法院、中院、高院、司法统计期 | 查询.xlsx, 权限.xlsx |
| **业务实体** | 收案日期、立案日期、审判程序、结案方式 | 查询.xlsx |
| **支付渠道** | 微信、支付宝、银联 | 【涉款公共用例】功能.txt |
| **产品功能** | 电子法院、微法院、诉费一体机 | 【涉款公共用例】功能.txt |
| **地域信息** | 东城区、西城区、朝阳区 | 查询.xlsx |
| **公司名称** | (需进一步识别) | 待分析 |

#### 4.2 脱敏建议

```yaml
# scripts/sanitize-rules.yaml
rules:
  # 行业术语泛化
  - pattern: "法院|中院|高院|最高法院"
    replacement: "[司法机构]"
    
  # 业务实体泛化
  - pattern: "收案日期|立案日期"
    replacement: "[业务日期]"
    
  - pattern: "审判程序|案件来源|结案方式"
    replacement: "[业务类型]"
    
  # 支付渠道保留（通用术语，可保留）
  - pattern: "微信|支付宝|银联"
    replacement: "[支付渠道]"
    
  # 产品功能泛化
  - pattern: "电子法院|微法院|诉费一体机"
    replacement: "[业务系统]"
    
  # 地域泛化
  - pattern: "东城区|西城区|朝阳区|丰台区"
    replacement: "[区域名称]"
```

### 5. xlsx → md card 格式映射

#### 5.1 字段映射表

| xlsx 源字段 | testcase-os 目标字段 | 转换规则 |
|-------------|---------------------|----------|
| Headline | `title` | 直接映射 |
| Priority | `priority` | "1 － 高" → P0, "2 － 中" → P1, "3 － 低" → P2 |
| 用例类型 | `type` | "功能特性" → functional |
| Description | 正文内容 | 解析分隔符，拆分至对应章节 |

#### 5.2 Description 解析映射

| 分隔符区块 | md card 章节 |
|------------|--------------|
| *********承前条件************** | ## 前置条件 |
| *********执行步骤************** | ## 测试步骤 |
| *********输入数据************** | 合并到步骤表格 |
| *********预期结果************** | 步骤表格的"预期结果"列 |

#### 5.3 转换后示例

```yaml
---
id: TC-COMM-001
title: 界面测试：总体
module: commons-ui
priority: P0
type: functional
stage: [regression]
status: active
source: commons
source_ref: "commons/checklists/ui-basics"
review: pending
author: imported
created: 2026-03-09
updated: 2026-03-09
tags: [ui, checklist, commons]
---

# 界面测试：总体

## 前置条件
拿到测试标准：界面原型或对界面信息项的详细描述文档

## 测试步骤

| # | 步骤 | 输入数据 | 预期结果 |
|---|------|----------|----------|
| 1 | 查看界面 | - | 界面大小符合美学观点... |
| 2 | 验证字体 | - | 字体大小与界面协调... |

## 备注
原始来源: 界面、控件.xlsx
```

### 6. commons/ 子类别映射建议

| 源文件 | 建议 commons/ 子目录 |
|--------|---------------------|
| 界面、控件.xlsx | `commons/checklists/ui-testing.md` |
| 增删改.xlsx | `commons/checklists/crud-testing.md` |
| 查询.xlsx + 自定义查询.xlsx | `commons/checklists/query-testing.md` |
| 权限.xlsx | `commons/checklists/permission-testing.md` |
| 安装.xlsx | `commons/checklists/deployment-testing.md` |
| 数据移植.xlsx | `commons/checklists/data-migration-testing.md` |
| 统计.xlsx | `commons/checklists/report-testing.md` |
| IO.xlsx | `commons/checklists/io-testing.md` |
| 流程.xlsx | `commons/templates/business-flow-template.md` |
| 文档.xlsx | `commons/checklists/documentation-testing.md` |
| 【接口测试】之接口测试公共用例.xls | `commons/checklists/api-testing.md` |
| 【涉款公共用例】功能.txt | `commons/checklists/payment-testing.md` |
| 典型应用、其他.xlsx | `commons/methodology/domain-specific/` |

---

## 第三部分：关键建议汇总

### 高优先级建议

1. **Review Gate 优化**: 按优先级差异化审核要求，P2/P3 可免审
2. **Experience 目录重构**: 重新定义 escapes/lessons/best-practices 的边界
3. **Daily-track 简化**: 支持从 Jira 自动拉取任务
4. **Import 工具开发**: 优先开发 `import-excel.sh` 处理现有 335+ 用例

### 中优先级建议

5. **Commons 版本管理**: 引入 Git tag 和 `commons_version` 字段
6. **Skill 别名**: 为高频 skill 提供自然语言别名
7. **I18n 目录结构**: 明确 cases/{lang}/ 的多语言支持方案

### 待进一步分析

8. 【接口测试】之接口测试公共用例.xls 完整解析
9. 涉款用例中的支付行业特殊场景提取

---

*报告完成*
