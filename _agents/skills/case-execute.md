---
name: case-execute
description: Guide step-by-step test case execution, capture evidence (screenshots, logs), and update daily journal. Use this skill when the user wants to execute test cases, run a test suite, perform smoke/regression testing, record pass/fail results, or capture test evidence. Triggers on "execute test case", "run tests", "start execution", "smoke test", "regression test", or any request to walk through test steps and record results.
---

# Case Execution

Guide step-by-step test execution, capture evidence, and update journal logs.

## Workflow

1.  **Read Case Metadata**:
    *   Load the MD card from `cases/{module}/TC-{MOD}-{NNN}.md`.
    *   Verify the `status` is `active` and `review` is `approved`.

2.  **Interactive Step-by-Step Guidance**:
    *   Present one test step at a time.
    *   Prompt the user/executor for each step's status: `pass`, `fail`, `blocked`, or `skipped`.
    *   Capture evidence for critical steps or failures.

3.  **Evidence Capture**:
    *   Store screenshots, logs, or traces in `evidence/YYYY-MM-DD/TC-{ID}/`.
    *   Reference these paths in the final execution report.

4.  **Update Journal**:
    *   Update the entry for today's date in `journal/YYYY-MM-DD.md`.
    *   Record the execution results (passed/failed cases).

5.  **Failure Handling**:
    *   If a step fails, offer to trigger the `bug-file` workflow to generate a Markdown Bug report and sync to Jira.

6.  **Summary at End**:
    *   Output a summary of the execution session.
    *   Include: Total cases/steps, counts for each status.

## Example Output

### Execution Summary
```markdown
## Execution Summary: [Sprint-12 Smoke Tests]
- **TC-RPP-001**: Passed
- **TC-RPP-002**: Failed at step 4 (Log not found)
  - **Evidence**: `evidence/2026-03-10/TC-RPP-002/error.log`
  - **Bug Filed**: BUG-2026-003
```
