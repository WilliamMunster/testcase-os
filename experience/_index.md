# Experience Library Index / 经验库索引

> Lessons learned, incidents, and best practices for testcase-os / testcase-os 的经验教训、事故和最佳实践

## Directory Structure / 目录结构

```
experience/
├── _index.md              # This file / 本文件
├── incidents/             # Production incidents / 线上事故
├── missed-bugs/           # Testing misses / 测试遗漏
├── techniques/            # Testing techniques / 测试技巧
└── anti-patterns/         # Common pitfalls / 常见陷阱
```

---

## Categories / 分类

### Incidents / 线上事故 (incidents/)

**Purpose / 目的**: Document production incidents and their root cause analysis for prevention.

记录线上事故及其根因分析，以防止再次发生。

| Attribute | Description / 描述 |
|-----------|-------------------|
| Severity | P0 (Critical), P1 (High), P2 (Medium), P3 (Low) |
| Impact | Users affected, revenue loss, data impact |
| Root Cause | Technical and process root causes |
| Resolution | How it was fixed |
| Prevention | Measures to prevent recurrence |

**Template / 模板**:
```markdown
# INC-YYYY-NNN: [Incident Title]

## Summary / 摘要
- Date: YYYY-MM-DD
- Severity: P0/P1/P2/P3
- Duration: X hours

## Impact / 影响
- Users affected: X
- Revenue impact: $X
- Data integrity: Yes/No

## Timeline / 时间线
- HH:MM - Issue detected
- HH:MM - Investigation started
- HH:MM - Root cause identified
- HH:MM - Fix deployed

## Root Cause / 根因
Technical and process analysis.

## Resolution / 解决方案
Steps taken to resolve.

## Prevention / 预防措施
- [ ] Action item 1
- [ ] Action item 2

## Related / 相关
- Related cases: TC-XXX-001
- Experience: EXP-XXX-001
```

---

### Missed Bugs / 测试遗漏 (missed-bugs/)

**Purpose / 目的**: Analyze bugs that escaped to production to improve test coverage.

分析漏到生产环境的缺陷，以改进测试覆盖。

| Attribute | Description / 描述 |
|-----------|-------------------|
| Escape Point | Where testing failed / 测试失效点 |
| Root Cause | Why it wasn't caught / 为什么没发现 |
| Category | Type of miss (coverage, environment, data) |

**Template / 模板**:
```markdown
# BUG-YYYY-NNN: [Bug Summary]

## Bug Details / 缺陷详情
- Severity: P0/P1/P2/P3
- Found by: Customer/Monitoring/Support
- Date found: YYYY-MM-DD

## What Was Missed / 遗漏了什么
Description of the bug.

## Why It Was Missed / 为什么遗漏
- Test coverage gap / 测试覆盖缺口
- Environment difference / 环境差异
- Data condition / 数据条件
- Edge case not considered / 未考虑的边界情况

## Lessons Learned / 经验教训
1. Lesson 1
2. Lesson 2

## Action Items / 行动项
- [ ] Add test case TC-XXX
- [ ] Update checklist
- [ ] Share with team
```

---

### Techniques / 测试技巧 (techniques/)

**Purpose / 目的**: Share effective testing techniques and productivity tips.

分享有效的测试技巧和提高效率的方法。

**Template / 模板**:
```markdown
# TEC-NNN: [Technique Name]

## Problem / 问题
What challenge does this solve?

## Solution / 解决方案
Step-by-step technique.

## Example / 示例
Concrete example with code/commands.

## Benefits / 收益
- Benefit 1
- Benefit 2

## When to Use / 适用场景
Context for applying this technique.
```

---

### Anti-Patterns / 常见陷阱 (anti-patterns/)

**Purpose / 目的**: Document common testing mistakes and how to avoid them.

记录常见的测试错误及如何避免。

**Template / 模板**:
```markdown
# AP-NNN: [Anti-Pattern Name]

## The Anti-Pattern / 反模式
Description of what NOT to do.

## Why It's Harmful / 为什么有害
Consequences and risks.

## The Better Way / 更好的方式
Recommended approach.

## Examples / 示例
### Bad / 不好
```
// Bad example
```

### Good / 好
```
// Good example
```

## Detection / 如何发现
How to identify this in code reviews or tests.
```

---

## Usage Guidelines / 使用指南

### For All Team Members / 对于所有团队成员

1. **Read before designing** / 设计前阅读
   - Check `missed-bugs/` for similar features
   - Review `anti-patterns/` for common mistakes

2. **Reference in cases** / 在用例中引用
   ```yaml
   ---
   experience_ref:
     - "experience/missed-bugs/BUG-2026-001"
     - "experience/anti-patterns/AP-001"
   ---
   ```

3. **Contribute learnings** / 贡献经验
   - Document incidents promptly
   - Share useful techniques
   - Update when patterns change

### For Incident Contributors / 对于事故贡献者

1. **Timeliness** / 及时性
   - Document within 48 hours of resolution
   - Include accurate timeline

2. **Blameless** / 无责
   - Focus on system improvements
   - Not individual fault

3. **Actionable** / 可操作
   - Specific prevention items
   - Assigned owners and deadlines

---

## Metrics / 指标

Track experience library health / 跟踪经验库健康状况：

| Metric | Target | Description |
|--------|--------|-------------|
| Incidents documented | 100% | All P0/P1 incidents |
| Missed bugs analyzed | 80%+ | Bugs with root cause analysis |
| Action items closed | 90%+ | Within 30 days |
| Experience references | Growing | In test case frontmatter |

---

## Quick Links / 快速链接

| Category | Count | Last Updated |
|----------|-------|--------------|
| [incidents/](./incidents/) | - | - |
| [missed-bugs/](./missed-bugs/) | - | - |
| [techniques/](./techniques/) | - | - |
| [anti-patterns/](./anti-patterns/) | - | - |

---

*Last Updated / 最后更新: 2026-03-09*
