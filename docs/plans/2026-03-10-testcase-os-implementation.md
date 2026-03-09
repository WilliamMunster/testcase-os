# testcase-os V1 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the complete testcase-os V1 system — a universal test knowledge base management system based on telos architecture.

**Architecture:** Git-native markdown knowledge base with skill-driven AI agent layer. All test cases stored as YAML-frontmatter markdown cards. Operations triggered via explicit skills (no auto-injection). Shell scripts handle Jira integration and data import.

**Tech Stack:** Shell (bash), Markdown, YAML, Git

---

## Work Distribution

| Agent | Tasks | Rationale |
|-------|-------|-----------|
| **codex** | Task 1 (setup.sh + directory) + Task 2 (shell scripts) + Task 3 (config files) | Code-heavy: shell scripts, sanitize rules, gitignore |
| **gemini** | Task 4 (case-design skill) + Task 5 (case-import skill) + Task 6 (case-execute skill) + Task 7 (daily-track skill) + Task 8 (search skill) + Task 9 (jira-sync skill) | Skill authoring: structured markdown instructions |
| **kimi** | Task 10 (shared.md + identity files) + Task 11 (commons templates) + Task 12 (README trilingual) | Content creation: Chinese/Japanese/English, templates |

---

### Task 1: Project Scaffold — setup.sh + Directory Structure [codex]

**Files:**
- Create: `setup.sh`
- Create: `.gitignore`

**Step 1: Create setup.sh**

```bash
#!/usr/bin/env bash
set -euo pipefail

# testcase-os setup script
# Creates the full directory structure for a new testcase-os instance

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "🔧 Setting up testcase-os at: $PROJECT_ROOT"

# System identity layer
mkdir -p "$PROJECT_ROOT/_system"

# Agent layer
mkdir -p "$PROJECT_ROOT/_agents/instructions"
mkdir -p "$PROJECT_ROOT/_agents/skills"
mkdir -p "$PROJECT_ROOT/_agents/commands"
mkdir -p "$PROJECT_ROOT/_agents/hooks"

# Test cases (with example module)
mkdir -p "$PROJECT_ROOT/cases"

# Commons (public test library)
mkdir -p "$PROJECT_ROOT/commons/checklists"
mkdir -p "$PROJECT_ROOT/commons/patterns"
mkdir -p "$PROJECT_ROOT/commons/methodology"
mkdir -p "$PROJECT_ROOT/commons/templates"

# Knowledge base
mkdir -p "$PROJECT_ROOT/knowledge/domain"
mkdir -p "$PROJECT_ROOT/knowledge/tech"

# Experience library
mkdir -p "$PROJECT_ROOT/experience/incidents"
mkdir -p "$PROJECT_ROOT/experience/missed-bugs"
mkdir -p "$PROJECT_ROOT/experience/techniques"
mkdir -p "$PROJECT_ROOT/experience/anti-patterns"

# Evidence storage
mkdir -p "$PROJECT_ROOT/evidence"

# Shared test data
mkdir -p "$PROJECT_ROOT/data"

# Journal
mkdir -p "$PROJECT_ROOT/journal"

# Scripts
mkdir -p "$PROJECT_ROOT/scripts"

# Docs
mkdir -p "$PROJECT_ROOT/docs/plans"
mkdir -p "$PROJECT_ROOT/docs/reviews"

# Create .gitkeep files for empty directories
for dir in cases evidence data journal; do
  touch "$PROJECT_ROOT/$dir/.gitkeep"
done

# Create index files
for dir in cases commons knowledge experience; do
  if [ ! -f "$PROJECT_ROOT/$dir/_index.md" ]; then
    cat > "$PROJECT_ROOT/$dir/_index.md" << 'INDEXEOF'
# Index

> Auto-generated index. Update with `search` skill.

## Statistics

| Metric | Count |
|--------|-------|
| Total items | 0 |
| Last updated | - |
INDEXEOF
  fi
done

echo "✅ Directory structure created."
echo ""
echo "Next steps:"
echo "  1. Edit _system/identity.md with your team info"
echo "  2. Edit _system/config.yaml with your Jira/project config"
echo "  3. Start using skills: case-design, case-import, search, etc."
```

**Step 2: Create .gitignore**

```
# OS
.DS_Store
Thumbs.db

# IDE
.idea/
.vscode/
*.swp
*.swo
*~

# Evidence artifacts (large binaries — track selectively)
evidence/**/*.png
evidence/**/*.jpg
evidence/**/*.mp4
!evidence/.gitkeep

# Sensitive files
.env
*.key
*.pem
credentials.*

# Temporary
*.tmp
*.bak
```

**Step 3: Run setup.sh and verify**

Run: `cd /Users/ts-haoqi.guo/project/testcase-os && bash setup.sh`
Expected: All directories created, index files in place.

**Step 4: Commit**

```bash
git add setup.sh .gitignore
git commit -m "feat: add setup.sh scaffold and .gitignore"
```

---

### Task 2: Shell Scripts — jira-cli.sh + import-gherkin.sh + sanitize.sh [codex]

**Files:**
- Create: `scripts/jira-cli.sh`
- Create: `scripts/import-gherkin.sh`
- Create: `scripts/sanitize.sh`
- Create: `scripts/sanitize-rules.yaml`

**Step 1: Create scripts/jira-cli.sh**

Wrapper around `jira` CLI (go-jira or atlassian-cli). Four subcommands:
- `pull-prd <ticket>` — fetch Jira issue description as markdown
- `create-bug <md-file>` — create Jira issue from bug markdown file
- `sync-status <ticket>` — sync Jira ticket status to local case
- `link-case <ticket> <case-id>` — add remote link between Jira ticket and test case

Requirements:
- Read Jira base URL and project key from `_system/config.yaml`
- Use `jira` CLI if available, fall back to `curl` + Jira REST API
- Output errors clearly, exit with non-zero on failure
- Include `--help` for each subcommand

**Step 2: Create scripts/import-gherkin.sh**

Parse `.feature` files and generate testcase-os markdown cards:
- Feature name → `title`
- `Background:` block → precondition section
- Each `Scenario:` → one TC card
- `Given/When/Then` steps → step table rows
- `Examples:` → parameterized data table
- Auto-set: `source: untracked`, `review: pending`, `status: draft`
- Auto-assign sequential IDs: `TC-{MODULE}-{NNN}`
- Accept `--module <name>` and `--output-dir <path>` flags

**Step 3: Create scripts/sanitize.sh**

Text sanitization tool driven by `sanitize-rules.yaml`:
- Read rules from YAML config
- Apply regex replacements in order
- Support `--input <file|dir>` and `--output <file|dir>`
- Support `--dry-run` to preview changes
- Log replacements count per rule

**Step 4: Create scripts/sanitize-rules.yaml**

```yaml
# Sanitization rules for testcase-os
# Each rule: pattern (regex) → replacement

rules:
  # PII
  - name: phone_numbers
    pattern: '1[3-9]\d{9}'
    replacement: '[PHONE]'

  - name: email_addresses
    pattern: '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
    replacement: '[EMAIL]'

  - name: ip_addresses
    pattern: '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
    replacement: '[IP_ADDR]'

  # Domain-specific (customize per project)
  - name: company_names
    pattern: ''
    replacement: '[COMPANY]'
    enabled: false

  - name: internal_urls
    pattern: 'https?://[a-z]+\.internal\.[a-z]+\.[a-z]+'
    replacement: '[INTERNAL_URL]'
```

**Step 5: Make scripts executable and commit**

```bash
chmod +x scripts/*.sh
git add scripts/
git commit -m "feat: add jira-cli, import-gherkin, and sanitize scripts"
```

---

### Task 3: Config Files — config.yaml + team.yaml + card template [codex]

**Files:**
- Create: `_system/config.yaml`
- Create: `_system/identity.md`
- Create: `_system/goals.md`
- Create: `_system/active-context.md`
- Create: `team.yaml`
- Create: `commons/templates/test-case-card.md`

**Step 1: Create _system/config.yaml**

```yaml
# testcase-os configuration
# Customize for your team/project

project:
  name: "My Project"
  key: "PROJ"

jira:
  base_url: "https://your-org.atlassian.net"
  project_key: "PROJ"
  # Authentication: set JIRA_TOKEN env var or use ~/.netrc

review:
  # P0/P1: always require review
  # P2/P3: configurable
  auto_approve_p2_p3: false
  trusted_authors: []

id_format:
  prefix: "TC"
  separator: "-"
  # e.g., TC-AUTH-001

import:
  default_source: "untracked"
  default_review: "pending"
  sanitize_on_import: true
```

**Step 2: Create _system/identity.md, goals.md, active-context.md**

Placeholder templates with clear instructions for customization.

**Step 3: Create team.yaml**

```yaml
schema_version: 1

team:
  name: my-qa-team
  description: "QA Team — customize for your project"

members:
  qa-lead:
    role: qa-lead
    email: lead@example.com
  # qa-engineer:
  #   role: qa-engineer
  #   email: eng@example.com

roles:
  qa-lead:
    permissions:
      cases/: { read: true, write: true }
      commons/: { read: true, write: true }
      knowledge/: { read: true, write: true }
      experience/: { read: true, write: true }
      _system/: { read: true, write: true }
  qa-engineer:
    permissions:
      cases/: { read: true, write: true }
      commons/: { read: true, write: false }
      knowledge/: { read: true, write: true }
      experience/: { read: true, write: true }
      _system/: { read: true, write: false }
  developer:
    permissions:
      cases/: { read: true, write: false }
      commons/: { read: true, write: false }
      knowledge/: { read: true, write: false }
      experience/: { read: true, write: true }
      _system/: { read: true, write: false }
  pm:
    permissions:
      cases/: { read: true, write: false }
      commons/: { read: true, write: false }
      knowledge/: { read: true, write: false }
      experience/: { read: true, write: false }
      _system/: { read: true, write: false }
```

**Step 4: Create commons/templates/test-case-card.md**

The canonical test case card template with all frontmatter fields from the design doc (Section 4.2).

**Step 5: Commit**

```bash
git add _system/ team.yaml commons/templates/
git commit -m "feat: add system config, team.yaml, and card template"
```

---

### Task 4: Skill — case-design [gemini]

**Files:**
- Create: `_agents/skills/case-design.md`

The core skill that reads PRD input → matches commons → benchmarks → generates test case cards.

Must follow the 5-step flow from design doc Section 5.2:
1. Extract test points from PRD
2. Match commons library templates
3. Industry benchmark search (WebSearch)
4. Generate case cards with full frontmatter
5. Output PRD Gap report

Skill must handle:
- ID auto-allocation (scan existing cases/{module}/ for highest NNN, increment)
- source/source_ref/benchmark_ref/benchmark_gaps population
- review: pending by default (or approved if prompt says so)
- risk field assignment based on priority and business impact
- Output files to `cases/{module}/TC-{MOD}-{NNN}.md`

---

### Task 5: Skill — case-import [gemini]

**Files:**
- Create: `_agents/skills/case-import.md`

Skill that orchestrates importing test cases from external formats:
- Gherkin (.feature files) via `scripts/import-gherkin.sh`
- Excel (.xlsx) via `scripts/import-excel.sh` (V2, note as placeholder)
- Text/CSV manual parsing
- Sanitization via `scripts/sanitize.sh`

Must handle:
- Module assignment (ask user or auto-detect)
- Duplicate detection (check existing IDs)
- Batch import with progress reporting
- Post-import summary (count, modules, review status)

---

### Task 6: Skill — case-execute [gemini]

**Files:**
- Create: `_agents/skills/case-execute.md`

Skill that guides step-by-step test execution:
- Read case card, display steps one by one
- Record pass/fail/blocked/skipped per step
- Capture evidence (screenshots, logs) to `evidence/YYYY-MM-DD/`
- Update journal with execution results
- Optionally trigger bug-file skill on failure

---

### Task 7: Skill — daily-track [gemini]

**Files:**
- Create: `_agents/skills/daily-track.md`

Skill that creates/updates daily test journal:
- Create `journal/YYYY-MM-DD.md` if not exists
- Scan recent git commits for case-design/case-execute activity
- Aggregate statistics (cases designed, executed, passed, failed, bugs)
- Support manual entry mode

---

### Task 8: Skill — search [gemini]

**Files:**
- Create: `_agents/skills/search.md`

Skill for searching the knowledge base:
- Search by module, tags, priority, risk, source, status, review status
- Full-text search across case titles and content
- Use Grep/Glob tools for implementation
- Output formatted result table

---

### Task 9: Skill — jira-sync [gemini]

**Files:**
- Create: `_agents/skills/jira-sync.md`

Skill that wraps `scripts/jira-cli.sh` with natural language interface:
- "Pull PRD from PROJ-1234" → pull-prd
- "Create bug for TC-RPP-001 step 3 failure" → create-bug
- "Sync status for PROJ-1234" → sync-status
- Read config from `_system/config.yaml`

---

### Task 10: Agent Instructions + System Identity [kimi]

**Files:**
- Create: `_agents/instructions/shared.md`
- Populate: `_system/identity.md`
- Populate: `_system/goals.md`
- Populate: `_system/active-context.md`

shared.md is the core AI agent instruction file that:
- Defines testcase-os identity and purpose
- Lists available skills with trigger descriptions
- Specifies card format conventions
- References config.yaml for project settings
- Enforces design principles (evidence-based, risk-driven, tiered review)

System files should be clear templates with placeholder values and instructions.

---

### Task 11: Commons Templates + Knowledge/Experience Index [kimi]

**Files:**
- Create: `commons/checklists/ui-testing.md`
- Create: `commons/checklists/crud-testing.md`
- Create: `commons/checklists/api-testing.md`
- Create: `commons/checklists/permission-testing.md`
- Create: `commons/checklists/security-top10.md`
- Create: `commons/patterns/login-flow.md`
- Create: `commons/patterns/payment-flow.md`
- Create: `commons/methodology/risk-based-testing.md`
- Create: `commons/methodology/boundary-value-analysis.md`
- Create: `commons/methodology/equivalence-partitioning.md`
- Create: `knowledge/_index.md`
- Create: `experience/_index.md`

Each checklist/pattern should be a practical, reusable template in English.

---

### Task 12: Trilingual README [kimi]

**Files:**
- Create: `README.md` (English)
- Create: `README.ja.md` (Japanese)
- Create: `README.zh-CN.md` (Chinese)

Each README covers:
- Project overview and positioning
- Quick start (clone → setup.sh → configure)
- Directory structure explanation
- Available skills with usage examples
- Card format overview
- Upgrade path to telos-team
- Contributing guidelines
- License (MIT)
