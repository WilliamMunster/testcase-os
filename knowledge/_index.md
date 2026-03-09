# Knowledge Base Index / 知识库索引

> Domain and technical knowledge repository for testcase-os / testcase-os 的领域和技术知识库

## Directory Structure / 目录结构

```
knowledge/
├── _index.md          # This file / 本文件
├── domain/            # Business domain knowledge / 业务领域知识
│   ├── _index.md
│   └── {domain}/      # Specific domain folders / 具体领域文件夹
└── tech/              # Technical knowledge / 技术知识
    ├── _index.md
    └── {topic}/       # Specific tech topics / 具体技术主题
```

---

## Domain Knowledge / 领域知识

### Purpose / 目的
Store business rules, domain terminology, and business process documentation that testers need to understand to create effective test cases.

存储业务规则、领域术语和业务流程文档，帮助测试人员理解业务以创建有效的测试用例。

### Structure / 结构

```
domain/
├── _index.md                    # Domain overview / 领域概览
├── terminology.md               # Glossary / 术语表
├── business-rules.md            # Business rules / 业务规则
├── user-personas.md             # User personas / 用户画像
└── {feature}/                   # Feature-specific docs / 功能特定文档
    ├── overview.md
    └── workflows.md
```

### Example Content / 示例内容

| Document | Content / 内容 | Purpose / 用途 |
|----------|---------------|----------------|
| `terminology.md` | Domain-specific terms and definitions / 领域特定术语和定义 | Ensure consistent understanding |
| `business-rules.md` | Validation rules, calculations, constraints / 验证规则、计算、约束 | Test case input |
| `user-personas.md` | User types, permissions, typical actions / 用户类型、权限、典型操作 | Scenario-based testing |
| `{feature}/workflows.md` | Step-by-step business processes / 分步业务流程 | End-to-end test design |

---

## Technical Knowledge / 技术知识

### Purpose / 目的
Store technical implementation details, architecture decisions, and integration information relevant to testing.

存储与测试相关的技术实现细节、架构决策和集成信息。

### Structure / 结构

```
tech/
├── _index.md                    # Tech overview / 技术概览
├── architecture.md              # System architecture / 系统架构
├── api-reference.md             # API documentation / API 文档
├── database-schema.md           # Database schema / 数据库结构
├── integration-points.md        # External integrations / 外部集成
└── {component}/                 # Component-specific docs / 组件特定文档
    └── technical-spec.md
```

### Example Content / 示例内容

| Document | Content / 内容 | Purpose / 用途 |
|----------|---------------|----------------|
| `architecture.md` | System components, data flow / 系统组件、数据流 | Integration testing planning |
| `api-reference.md` | Endpoint specs, auth methods / 端点规格、认证方法 | API test design |
| `database-schema.md` | Table structures, relationships / 表结构、关系 | Data validation testing |
| `integration-points.md` | Third-party services, protocols / 第三方服务、协议 | Contract testing |

---

## Usage Guidelines / 使用指南

### For Test Designers / 对于测试设计人员

1. **Start with domain knowledge** / 从领域知识开始
   - Read `domain/_index.md` for overview
   - Check `domain/terminology.md` for unfamiliar terms

2. **Reference during case design** / 用例设计时引用
   ```yaml
   ---
   knowledge_ref:
     - "knowledge/domain/payment/business-rules"
     - "knowledge/tech/api-reference"
   ---
   ```

3. **Update when learning** / 学习时更新
   - Add new business rules discovered during testing
   - Document technical constraints found

### For Knowledge Contributors / 对于知识贡献者

1. **Keep it practical** / 保持实用性
   - Focus on information testers actually need
   - Include concrete examples

2. **Maintain links** / 维护链接
   - Link to related cases
   - Cross-reference domain and tech docs

3. **Version control** / 版本控制
   - Track changes to business rules
   - Document when rules change

---

## Templates / 模板

### Domain Knowledge Entry / 领域知识条目

```markdown
# [Domain Feature] Knowledge / [领域功能] 知识

## Overview / 概览
Brief description of the feature and its business purpose.

## Terminology / 术语
| Term | Definition |
|------|------------|
| | |

## Business Rules / 业务规则
1. Rule 1
2. Rule 2

## Related Cases / 相关用例
- TC-XXX-001
- TC-XXX-002

## Last Updated / 最后更新
YYYY-MM-DD
```

### Technical Knowledge Entry / 技术知识条目

```markdown
# [Component] Technical Spec / [组件] 技术规格

## Overview / 概览
Component purpose and responsibilities.

## Interface / 接口
| Endpoint | Method | Description |
|----------|--------|-------------|
| | | |

## Data Model / 数据模型
```
Table: xxx
- id: PK
- name: string
```

## Testing Considerations / 测试注意事项
- Point 1
- Point 2
```

---

*Last Updated / 最后更新: 2026-03-09*
