---
name: case-design
description: Design high-quality test cases from PRD analysis. Use this skill when the user wants to create test cases based on a PRD, generate test case cards for a feature or module, benchmark against industry standards, or extract test points from requirements. Triggers on phrases like "design test cases", "generate cases from PRD", "create test case cards", "extract test points", or any request to turn requirements into structured test cases.
---

# Case Design

Design high-quality test cases by analyzing PRDs, matching existing common patterns, and benchmarking against industry standards.

## Workflow

Follow these 5 steps precisely:

1.  **Extract Test Points**:
    *   Read the provided PRD (Jira ticket, document, or text).
    *   Perform functional decomposition.
    *   Identify all core features, edge cases, and constraints.
    *   Output a list of test points with IDs (e.g., TP-01, TP-02).

2.  **Match Commons Library**:
    *   Search `commons/` for relevant checklists, methodology, and templates.
    *   Apply common patterns (e.g., login, search, payment flows) to the extracted test points.

3.  **Industry Benchmark**:
    *   Use WebSearch to find industry-standard testing practices for the feature (e.g., "Google Ads impression tracking best practices").
    *   Compare the PRD against these standards.
    *   Identify "Gaps" (missing requirements or edge cases in the PRD).

4.  **Generate Case Cards**:
    *   For each test point, create a Markdown card in `cases/{module}/TC-{MOD}-{NNN}.md`.
    *   **ID Allocation**: Scan `cases/{module}/` for the highest existing `NNN` and increment.
    *   **Metadata**: Include all frontmatter fields defined in the Architecture Design.
    *   **Risk Assignment**:
        *   P0 -> `risk: high`
        *   P1 -> `risk: high` or `risk: medium`
        *   P2 -> `risk: medium`
        *   P3 -> `risk: low`
    *   **Review Status**:
        *   P0/P1 -> `review: pending`
        *   P2/P3 -> `review: approved` if `auto_approve_p2_p3` is true in `config.yaml`, otherwise `review: pending`.
    *   **Source Tracking**: Mark `source` as `prd`, `commons`, or `benchmark`.

5.  **Output PRD Gap Report**:
    *   At the end of the session, summarize all `benchmark_gaps` into a consolidated report for the BA/PM.

## Frontmatter Template

```yaml
---
id: TC-{MOD}-{NNN}
title: {title}
module: {module}
priority: {P0|P1|P2|P3}
risk: {high|medium|low}
type: functional
stage: [smoke, regression]
status: draft
version: 1
automated: false
automation_ref: ""
precondition: "{precondition}"
requirement_ref: "{requirement_id}"
source: {prd|commons|benchmark|untracked}
source_ref: "{ref_id}"
benchmark_ref: "{benchmark_source}"
benchmark_gaps:
  - "{gap_1}"
review: pending
reviewer: ""
review_date: ""
review_note: ""
jira_ref: ""
tags: []
author: {agent_name}
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

## Example Output

### Case Card (TC-RPP-001.md)
```markdown
# RPP Impression 日志验证
... (steps and benchmark gaps)
```

### PRD Gap Report
```markdown
## PRD Gap Report for [Feature Name]
- **Gap 1**: PRD lacks definition of viewability threshold.
- **Gap 2**: Frequency capping logic is not specified for first-page ads.
```
