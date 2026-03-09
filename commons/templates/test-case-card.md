---
# Unique test case identifier following the configured case code format.
id: TC-MOD-001
# Human-readable title for the test case.
title: Replace with test case title
# Functional module or feature area; typically matches the cases/{module}/ directory.
module: MOD
# Business priority: P0 / P1 / P2 / P3.
priority: P1
# Risk level used for risk-based execution ordering: high / medium / low.
risk: medium
# Test type: functional / performance / security / compatibility / usability.
type: functional
# Applicable stages such as smoke / regression / acceptance / exploratory.
stage:
  - regression
# Lifecycle status: draft / active / deprecated.
status: draft
# Case revision number; increment when test steps change materially.
version: 1
# Whether the case is covered by automation.
automated: false
# Path, suite name, or job reference for the automated implementation.
automation_ref: ""
# Short summary of prerequisites; put detailed items in the body section as well.
precondition: ""
# Linked requirement reference such as a PRD section or Jira ticket.
requirement_ref: ""
# Linked design artifact such as Figma / Sketch / Zeplin.
design_ref: ""
# Source classification: prd / commons / benchmark / untracked.
source: prd
# Concrete source citation such as PRD section, imported file, or commons ID.
source_ref: ""
# External benchmark source used to strengthen the case.
benchmark_ref: ""
# Missing requirement details discovered during benchmark comparison.
benchmark_gaps:
  - ""
# Review state: pending / approved / rejected.
review: pending
# Reviewer name or identifier once reviewed.
reviewer: ""
# Review date in YYYY-MM-DD format.
review_date: ""
# Reviewer comments or change requests.
review_note: ""
# Linked Jira issue, test ticket, or execution reference.
jira_ref: ""
# Search and grouping tags.
tags:
  - sample-tag
# Author or creator of the case.
author: your-name
# Creation date in YYYY-MM-DD format.
created: YYYY-MM-DD
# Last updated date in YYYY-MM-DD format.
updated: YYYY-MM-DD
---

# Replace with test case title

## Background

Describe the business context, feature intent, and why this test matters.

## Preconditions

- List environment, account, data, or configuration prerequisites.

## Test Steps

| # | Step | Input Data | Expected Result |
|---|------|------------|-----------------|
| 1 | Replace with the first action | Replace with data | Replace with expected result |
| 2 | Replace with the second action | - | Replace with expected result |

## Industry Benchmark

- Document relevant industry references, comparison notes, and PRD gaps.

## Notes

- Add implementation notes, follow-up questions, or execution caveats.
