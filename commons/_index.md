# Commons Index / 公共库索引

> Reusable testing assets for testcase-os / testcase-os 的可复用测试资源

## Directory Structure / 目录结构

```
commons/
├── _index.md              # This file / 本文件
├── checklists/            # Testing checklists / 测试检查清单
├── patterns/              # Test patterns / 测试模式
├── methodology/           # Testing methodologies / 测试方法论
└── templates/             # Document templates / 文档模板
```

---

## Checklists / 检查清单

| File | Description / 描述 | Use Case / 使用场景 |
|------|-------------------|-------------------|
| [ui-testing.md](checklists/ui-testing.md) | UI/UX testing (layout, typography, responsive, a11y) / 界面测试 | Web/mobile interface validation |
| [crud-testing.md](checklists/crud-testing.md) | CRUD operations testing / 增删改查测试 | Data management features |
| [api-testing.md](checklists/api-testing.md) | API testing checklist / API 测试清单 | RESTful/GraphQL endpoints |
| [permission-testing.md](checklists/permission-testing.md) | Access control testing / 权限测试 | RBAC and authorization |
| [security-top10.md](checklists/security-top10.md) | OWASP Top 10 security tests / OWASP 安全测试 | Security assessment |

---

## Patterns / 测试模式

| File | Description / 描述 | Coverage / 覆盖范围 |
|------|-------------------|-------------------|
| [login-flow.md](patterns/login-flow.md) | Authentication test pattern / 登录测试模式 | Normal/abnormal/lockout/MFA/remember me |
| [payment-flow.md](patterns/payment-flow.md) | Payment processing pattern / 支付测试模式 | Order/payment/callback/refund/reconciliation |

---

## Methodology / 方法论

| File | Description / 描述 | Application / 应用 |
|------|-------------------|-------------------|
| [risk-based-testing.md](methodology/risk-based-testing.md) | Risk-driven testing approach / 风险驱动测试 | Prioritization and resource allocation |
| [boundary-value-analysis.md](methodology/boundary-value-analysis.md) | BVA technique / 边界值分析 | Input range testing |
| [equivalence-partitioning.md](methodology/equivalence-partitioning.md) | EP technique / 等价类划分 | Input classification testing |

---

## Templates / 模板

| File | Description / 描述 | Purpose / 用途 |
|------|-------------------|----------------|
| templates/test-case-card.md | Test case template / 用例卡片模板 | Standard test case format |
| templates/bug-report.md | Bug report template / 缺陷报告模板 | Standard bug report format |
| templates/journal-entry.md | Daily journal template / 日志模板 | Daily testing log format |

---

## Usage Guidelines / 使用指南

### Referencing in Test Cases / 在用例中引用

```yaml
---
# In your test case frontmatter / 在用例 frontmatter 中
checklist_ref:
  - "commons/checklists/ui-testing"
pattern_ref:
  - "commons/patterns/login-flow"
methodology_ref:
  - "commons/methodology/boundary-value-analysis"
---
```

### Creating New Commons / 创建新的公共库条目

1. Choose appropriate subdirectory / 选择合适的子目录
2. Use English filename (kebab-case) / 使用英文文件名（短横线连接）
3. Follow existing format / 遵循现有格式
4. Update this index / 更新本索引
5. Set `review: approved` for commons / 公共库设置 `review: approved`

---

## Versioning / 版本管理

- Use Git tags for versioning / 使用 Git 标签管理版本
- Tag format: `commons-v{major}.{minor}.{patch}` / 标签格式
- Example: `commons-v1.2.0`

---

*Last Updated / 最后更新: 2026-03-09*
