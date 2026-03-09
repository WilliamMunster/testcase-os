# 项目身份 / Project Identity

> 定义团队和项目的基本信息  
> Define basic team and project information

---

## 团队 / Team

| 字段 / Field | 值 / Value | 说明 / Description |
|-------------|-----------|-------------------|
| 团队名称 / Team Name | `[填写 / Fill in]` | QA 团队名称 / QA team name |
| 项目名称 / Project Name | `[填写 / Fill in]` | 被测产品名称 / Product under test |
| 技术栈 / Tech Stack | `[填写 / Fill in]` | 主要技术栈 / Primary technology stack |

---

## 测试范围 / Testing Scope

### 核心模块 / Core Modules

```yaml
modules:
  - name: "[模块名 / Module name]"
    code: "[缩写 / Abbreviation, e.g., USER]"
    description: "[功能描述 / Function description]"
    
  - name: "[模块名 / Module name]"
    code: "[缩写 / Abbreviation]"
    description: "[功能描述 / Function description]"
```

### 测试类型 / Test Types

| 类型 / Type | 是否覆盖 / Covered | 说明 / Notes |
|------------|-------------------|-------------|
| functional / 功能测试 | [ ] Yes [ ] No | 核心业务功能 / Core business functions |
| performance / 性能测试 | [ ] Yes [ ] No | 负载、压力、稳定性 / Load, stress, stability |
| security / 安全测试 | [ ] Yes [ ] No | 认证、授权、注入 / Auth, authorization, injection |
| compatibility / 兼容性测试 | [ ] Yes [ ] No | 浏览器、设备、OS / Browser, device, OS |
| usability / 易用性测试 | [ ] Yes [ ] No | 用户体验 / User experience |

---

## 联系方式 / Contact

| 角色 / Role | 姓名 / Name | 联系方式 / Contact |
|------------|------------|-------------------|
| QA Lead / QA 负责人 | `[填写 / Fill in]` | `[邮箱 / Email]` |
| QA Engineer / 测试工程师 | `[填写 / Fill in]` | `[邮箱 / Email]` |
| 邮件列表 / Mailing List | `[填写 / Fill in]` | `[邮箱 / Email]` |
| Slack/Teams 频道 | `[填写 / Fill in]` | `[链接 / Link]` |

---

## 环境信息 / Environment

| 环境 / Environment | URL / 地址 | 用途 / Purpose |
|-------------------|-----------|---------------|
| 开发 / Dev | `[填写 / Fill in]` | 日常开发测试 / Daily dev testing |
| 测试 / QA | `[填写 / Fill in]` | 集成测试 / Integration testing |
| 预发布 / Staging | `[填写 / Fill in]` | 回归测试 / Regression testing |
| 生产 / Production | `[填写 / Fill in]` | 仅只读验证 / Read-only verification |

---

## 集成系统 / Integrated Systems

| 系统 / System | 用途 / Purpose | 配置位置 / Config Location |
|--------------|---------------|--------------------------|
| Jira | 需求管理 / Requirements | `_system/config.yaml` |
| GitHub/GitLab | 代码仓库 / Code repository | `_system/config.yaml` |
| CI/CD | 自动化构建 / Automation | `_system/config.yaml` |
| 监控 / Monitoring | 告警、日志 / Alerts, logs | `[填写 / Fill in]` |

---

*模板版本 / Template Version: v1.0*  
*创建日期 / Created: 2026-03-09*
