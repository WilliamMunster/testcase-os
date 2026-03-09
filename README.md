# testcase-os

> A universal test knowledge base management system based on the telos architecture. Git-native, Markdown-first, Skill-driven.

## Overview

testcase-os helps QA teams manage test cases, knowledge, and experiences using Git and Markdown. No proprietary databases, no vendor lock-in—just plain text files that work with your existing developer tools.

### Key Features

- **Git-Native**: Version control, collaboration, and audit trail built-in
- **Markdown-First**: All test cases stored as human-readable Markdown cards
- **Skill-Driven**: No automatic context injection—explicit skill triggers only
- **Knowledge Reuse**: Commons library with checklists, patterns, and methodologies
- **Experience Loop**: Track incidents and missed bugs to improve continuously
- **Industry Benchmark**: Built-in support for competitive analysis

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/testcase-os.git
cd testcase-os
```

### 2. Run Setup

```bash
bash setup.sh
```

This creates the basic directory structure and initializes configuration files.

### 3. Configure Your Project

Edit `_system/config.yaml`:

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

### 4. Set Your Identity

Edit `_system/identity.md` with your team and project information.

### 5. Start Using Skills

```bash
# Design test cases from PRD
kimi-cli skill case-design --prd PRD-2026-001.md

# Log today's testing
kimi-cli skill daily-track

# Search test cases
kimi-cli skill search --module user --priority P0
```

## Directory Structure

```
testcase-os/
├── _agents/
│   └── instructions/
│       └── shared.md          # AI agent instructions
├── _system/
│   ├── identity.md            # Team/project identity
│   ├── goals.md               # Quality goals & OKR
│   ├── active-context.md      # Current sprint focus
│   └── config.yaml            # Project configuration
├── cases/                     # Test case library
│   ├── _index.md
│   └── {module}/
│       ├── _module.md
│       └── TC-{MOD}-{NNN}.md  # Test case cards
├── commons/                   # Reusable testing assets
│   ├── checklists/            # Testing checklists
│   ├── patterns/              # Test patterns
│   ├── methodology/           # Testing methodologies
│   └── _index.md
├── knowledge/                 # Business & technical knowledge
│   ├── domain/                # Business domain knowledge
│   └── tech/                  # Technical knowledge
├── experience/                # Lessons learned
│   ├── incidents/             # Production incidents
│   ├── missed-bugs/           # Testing misses
│   ├── techniques/            # Testing techniques
│   └── anti-patterns/         # Common pitfalls
├── journal/                   # Daily testing logs
│   └── YYYY-MM-DD.md
└── scripts/                   # Utility scripts
    ├── jira-cli.sh
    ├── import-excel.sh
    └── sanitize.sh
```

## Available Skills

### case-design
Design test cases from PRD documents with industry benchmarking.

```bash
kimi-cli skill case-design --prd PRD-2026-001.md --module user
```

### case-import
Import test cases from Gherkin or Excel files.

```bash
kimi-cli skill case-import --file features/login.feature --format gherkin
kimi-cli skill case-import --file tests.xlsx --format excel
```

### case-execute
Execute test cases with step-by-step guidance.

```bash
kimi-cli skill case-execute --id TC-USER-001
```

### daily-track
Record daily testing activities and statistics.

```bash
kimi-cli skill daily-track --today
```

### search
Search test cases by various criteria.

```bash
kimi-cli skill search --module user --priority P0
kimi-cli skill search --tag regression --status active
```

### jira-sync
Synchronize with Jira for PRD pulling and bug filing.

```bash
kimi-cli skill jira-sync --pull-prd PROJ-1234
kimi-cli skill jira-sync --create-bug bugs/BUG-001.md
```

## Test Case Card Format

Test cases are stored as Markdown files with YAML frontmatter:

```yaml
---
id: TC-USER-001
title: User Registration with Valid Data
module: user
priority: P0
type: functional
stage: [smoke, regression]
status: active
source: prd
source_ref: "PRD-2026-001 Section 3.2"
review: pending
risk: high
risk_reason: "Core user journey"
author: qa-engineer
created: 2026-03-09
updated: 2026-03-09
tags: [registration, smoke, positive]
---

# User Registration with Valid Data

## Background
New users must be able to register with email and password.

## Preconditions
- User is on registration page
- Email is not already registered

## Test Steps

| # | Step | Input Data | Expected Result |
|---|------|------------|-----------------|
| 1 | Enter email | user@test.com | Email accepted |
| 2 | Enter password | SecurePass123 | Password masked, strength shown |
| 3 | Click Register | - | Account created, confirmation email sent |

## Industry Benchmark
> **Reference**: Competitor X requires email verification within 24 hours
> **Gap**: Our PRD doesn't specify email verification timing
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `id` | Yes | Unique identifier (TC-{MODULE}-{NNN}) |
| `title` | Yes | Test case title |
| `module` | Yes | Module name |
| `priority` | Yes | P0/P1/P2/P3 |
| `type` | Yes | functional/performance/security/compatibility/usability |
| `source` | Yes | prd/commons/benchmark/untracked |
| `review` | Yes | pending/approved/rejected |
| `risk` | Recommended | high/medium/low |
| `tags` | No | List of tags |

## Upgrade Path

### Personal / Small Team (Current)
- Single repository
- Direct file editing
- Skill-based interaction

### Team Scale (V2)
- `team.yaml` for role-based permissions
- Git hooks for audit logging
- MCP server integration

### Enterprise (telos-team Integration)
- Centralized user management
- Advanced analytics
- Multi-project support

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Adding Commons

1. Create file in appropriate `commons/` subdirectory
2. Use English filename (kebab-case)
3. Follow existing format
4. Update `commons/_index.md`

### Reporting Issues

Use the [issue tracker](https://github.com/your-org/testcase-os/issues) to report bugs or request features.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Other Languages

- [日本語 (Japanese)](README.ja.md)
- [简体中文 (Chinese)](README.zh-CN.md)

---

*Built with the telos architecture principles.*
