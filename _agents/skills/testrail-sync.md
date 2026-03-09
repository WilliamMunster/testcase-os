---
name: testrail-sync
description: Sync test cases and results between testcase-os and TestRail via TRCLI. Use this skill when the user wants to export cases to TestRail, import results from TestRail, sync test run status, upload automation results, or bridge testcase-os with TestRail for teams using both systems. Triggers on "sync TestRail", "export to TestRail", "import from TestRail", "upload results", "TRCLI", or any request involving TestRail integration.
---

# TestRail Sync

Synchronize test cases and execution results between testcase-os and TestRail using TRCLI.

## Configuration

* Read TestRail instance URL and credentials from `_system/config.yaml` under `testrail`.
* Verify `trcli` is installed: `pip install trcli`.

## Workflow

1. **Export Cases to TestRail**:
   * Action: Convert testcase-os Markdown cards to TestRail-compatible format.
   * Map frontmatter fields: `priority` → TestRail priority, `type` → TestRail type.
   * Command: `trcli -y -h {url} -u {user} -p {password} --project {project} parse_junit --file results.xml`

2. **Import Cases from TestRail**:
   * Action: Use TestRail API to fetch test cases and convert to testcase-os Markdown cards.
   * Preserve TestRail case IDs in `testrail_ref` frontmatter field.

3. **Upload Results**:
   * Command: `trcli -y -h {url} --project {project} parse_junit --title "Run {date}" --file {junit_xml}`
   * Action: Upload JUnit XML results from automation runs to TestRail test runs.

4. **Status Sync**:
   * Action: Fetch test run results from TestRail and update local journal entries.

## Mapping

| Input Intent | Action |
|---|---|
| "Export cases to TestRail" | Convert MD → TestRail format, upload via API |
| "Import from TestRail" | Fetch cases via API → generate MD cards |
| "Upload test results" | `trcli parse_junit --file {xml}` |
| "Sync run status" | Fetch TestRail run → update journal |

## Error Handling

* If `trcli` is not installed, provide installation instructions.
* If credentials are missing from `config.yaml`, prompt user to configure `testrail` section.
* Validate TestRail project exists before operations.
