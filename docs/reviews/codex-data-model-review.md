# testcase-os Design Review: Skill System & Data Model

## Executive Summary

The design is strong as a Git-native authoring model for test knowledge, but it is not yet a complete test management model. It covers case authoring well; it does not yet model execution, planning, coverage, or synchronization rigor well enough for reliable scale. The biggest risk is that lifecycle metadata (`status`, `review`, `version`) is defined, but operational entities from mature systems such as ZenTao (`case`, `step`, `run`, `result`) are still collapsed into one Markdown card.

A practical direction is to keep Markdown cards as the authoring source, while adding a small set of first-class records for execution, suite/plan grouping, and sync state.

## 1. Data Model Rigor

### What is already good

- Naming style is mostly consistent in `snake_case`.
- The schema captures source traceability, review workflow, and automation linkage.
- The card template is readable and Git-friendly.

### Main schema issues

1. **Semantic naming is not fully consistent**
   - `stage` is a list but named singular; `stages` is clearer.
   - `created` / `updated` are dates, while other fields use descriptive suffixes; `created_at` / `updated_at` is more explicit.
   - `review_date` is less consistent than `reviewed_at`; `author` / `reviewer` would align better as `created_by` / `reviewed_by`.
   - `requirement_ref` and `jira_ref` are singular, but both relationships are often many-to-many.

2. **Type safety is under-specified**
   - Enums are listed in prose, but there is no canonical schema file for validation.
   - `date` vs `datetime` is not defined; sync and audit flows usually need timestamps, not just dates.
   - `type`, `stage`, `status`, and `review` should be validated centrally, not only documented.

3. **Conditional requirements are missing**
   - `automation_ref` should be required when `automated = true`.
   - `source_ref` should be required when `source != untracked`.
   - `benchmark_ref` should be required when `benchmark_gaps` is non-empty or `source = benchmark`.
   - Review metadata should follow workflow rules: `reviewed_by` and `reviewed_at` should be required when review is approved or rejected.

4. **Important relationships are missing**
   - No first-class **test suite** or **test plan** grouping.
   - No **execution record** per run.
   - No explicit **defect links** list.
   - No many-to-many **requirement ↔ case** relation.
   - No place for **environment/platform/browser/device** matrix dimensions.

### Comparison to ZenTao structure

Structurally, ZenTao separates at least four concerns:
- `zt_case`: case metadata
- `zt_casestep`: ordered steps
- `zt_testrun`: execution context / run instance
- `zt_testresult`: pass/fail result and evidence

The current design maps well to `zt_case` and partially to `zt_casestep`, but it has no real equivalent for `zt_testrun` or `zt_testresult`. That means the current model can store a good test case, but it cannot cleanly answer operational questions such as:
- What failed in build X?
- How many times did this case fail in regression last month?
- Which step failed under iOS Safari only?

### Recommended model changes

Keep the Markdown case card, but add these first-class entities:
- `suite` or `plan` entity for grouping
- `execution` entity for each run
- `execution_step_result` or step-level result block
- `defect_refs` as a list
- `requirement_refs` as a list
- `external_ids` for imported systems
- `sync_state` for Jira linkage

## 2. Skill Workflow Completeness

The skill list is directionally good, but only `case-design` has a real workflow. Most other skills are names plus one-line intent, which is not enough for reliable automation.

### Cross-cutting gaps

- **Input/output contracts** are mostly unspecified.
- **Error handling** is absent across all skills.
- **Idempotency** is not designed, so re-running a skill may duplicate cards, bugs, or logs.
- **Dependencies** are implicit instead of explicit.

### Skill-by-skill assessment

- `case-design`: Best defined skill. Still needs duplicate detection, deterministic ID allocation, and fallback behavior for ambiguous PRDs.
- `case-import`: Needs explicit mapping contract, duplicate strategy, and partial-import recovery.
- `case-review`: Needs a strict state machine and re-run semantics.
- `bug-file`: Depends on execution records that do not yet exist in the data model.
- `jira-sync`: Needs source-of-truth rules, retry behavior, conflict handling, and offline recovery.
- `knowledge-capture`: Needs a template, indexing strategy, and dedup rules.
- `experience-capture`: Needs trigger conditions, linkage to escaped defects, and severity taxonomy.
- `daily-track`: Needs a clear rule for auto-generated vs human-edited entries.
- `benchmark`: Needs evidence format, source quality rules, and failure behavior when search is unavailable.
- `search`: Needs query grammar, ranking rules, and output schema.

### Dependency observations

The design should explicitly define a dependency graph:
- `case-design` depends on `search`, optional `benchmark`, and optional `jira-sync` for PRD retrieval.
- `bug-file` depends on execution data and usually `jira-sync`.
- `daily-track` depends on outputs from `case-design`, execution records, and bug creation.
- `experience-capture` should consume bug and escape signals, not rely on manual memory alone.

## 3. ID Generation Strategy

`TC-{MOD}-{NNN}` is good as a **human-facing display code**, but weak as the only identifier.

### Risks

- **Module rename** breaks semantic stability.
- **Cross-module import** can create duplicate numeric ranges.
- **Deduplication** is hard when the same case moves between modules.
- **Imported cases** may already have stable external identifiers.

### Recommendation

Use two identifiers:
- Immutable primary key: `case_uid` (ULID/UUID)
- Human display code: `case_code = TC-{MOD}-{NNN}`

Also add:
- `aliases` or `historical_codes` for renamed modules
- `external_ids` for imported systems
- Central sequence registry or index file for `case_code` allocation

This preserves human readability without making module names part of the permanent primary key.

## 4. Jira Integration Design

## Key concern

The repository currently contains only the design document; `scripts/jira-cli.sh` is not present. So the Jira integration is still conceptual, not reviewable as an implementation.

### CLI vs REST API

For V1, a CLI wrapper is acceptable for manual workflows and quick bootstrap. For long-term bi-directional sync, REST API integration is the stronger design because it gives:
- structured responses
- better pagination and retry control
- explicit rate-limit handling
- finer field-level conflict resolution
- easier automation in CI/services

Also, the document calls `jira-cli` an “Atlassian official CLI”. That assumption should be verified before committing the design around it.

### Missing sync design elements

- No field ownership model: which side owns status, title, links, or comments?
- No conflict policy: last-write-wins is dangerous for test assets.
- No sync metadata: `last_synced_at`, `remote_updated_at`, `local_revision`, `sync_status`, `sync_error`.
- No retry or dead-letter strategy.
- No idempotency key for create-bug flows.

### Recommended sync policy

- Jira owns Jira issue workflow fields.
- Local repo owns case authoring structure and review metadata.
- Shared fields use revision checks and raise explicit conflicts instead of silent overwrite.
- Persist sync journal entries for audit and replay.

## 5. Missing Concepts from Test Management Theory

The current design is strongest on authoring knowledge, but it is missing several basic test-management concepts:

1. **Test Suites / Test Plans**
   - Needed to group cases for smoke, regression, release, or sprint execution.

2. **Test Execution Records**
   - Case status is not enough. You need pass/fail/blocked/skipped per run, with executor, build, environment, and timestamps.

3. **Coverage Matrix**
   - Requirement coverage should be a first-class relation, not a single string ref.

4. **Regression Suite Management**
   - Regression is currently just a `stage` label; it should also exist as an executable maintained suite.

5. **Environment and configuration matrix**
   - Many failures are environment-specific; the model should capture this structurally.

## Priority Recommendations

### P0
- Introduce immutable `case_uid` plus human-readable `case_code`.
- Add execution records and suite/plan entities.
- Convert singular refs to lists where relationships are many-to-many.
- Define a canonical schema file with validation rules and conditional requirements.

### P1
- Define skill contracts: input, output, errors, idempotency, dependencies.
- Add Jira sync metadata and explicit conflict policy.
- Separate authoring lifecycle from execution outcome.

### P2
- Add coverage views, regression suite governance, and environment matrix support.
- Formalize import/export identity mapping for external systems.

## Bottom Line

The design is promising for **Git-native test case authoring**, but it is not yet a complete **test management system data model**. The most important design change is to separate:
- case definition,
- case grouping,
- case execution,
- defect linkage,
- and sync state.

Without that separation, the system will work for writing cases but will struggle with execution analytics, Jira sync, and long-term maintainability.
