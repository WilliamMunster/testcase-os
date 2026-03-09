#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  cat <<'USAGE'
Usage:
  import-gherkin.sh --module <name> --author <name> [--output-dir <path>] <feature-file>

Description:
  Convert a Gherkin .feature file into testcase-os Markdown cards.

Options:
  --module <name>        Target module code used in case IDs and frontmatter
  --author <name>        Author name written to generated cards
  --output-dir <path>    Output directory for generated cards (default: cases/<module>)
  --help                 Show this help message
USAGE
}

MODULE=""
AUTHOR=""
OUTPUT_DIR=""
FEATURE_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --module)
      MODULE="${2:-}"
      shift 2
      ;;
    --author)
      AUTHOR="${2:-}"
      shift 2
      ;;
    --output-dir)
      OUTPUT_DIR="${2:-}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --*)
      echo "Error: unknown option $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -n "$FEATURE_FILE" ]]; then
        echo "Error: only one feature file is supported per run" >&2
        exit 1
      fi
      FEATURE_FILE="$1"
      shift
      ;;
  esac
done

[[ -n "$MODULE" ]] || { echo "Error: --module is required" >&2; exit 1; }
[[ -n "$AUTHOR" ]] || { echo "Error: --author is required" >&2; exit 1; }
[[ -n "$FEATURE_FILE" ]] || { echo "Error: feature file is required" >&2; exit 1; }
[[ -f "$FEATURE_FILE" ]] || { echo "Error: feature file not found: $FEATURE_FILE" >&2; exit 1; }

if [[ -z "$OUTPUT_DIR" ]]; then
  OUTPUT_DIR="$PROJECT_ROOT/cases/$MODULE"
fi
mkdir -p "$OUTPUT_DIR"

python3 - <<'PY' "$FEATURE_FILE" "$MODULE" "$AUTHOR" "$OUTPUT_DIR"
import datetime as dt
import pathlib
import re
import sys

feature_path = pathlib.Path(sys.argv[1])
module = sys.argv[2]
author = sys.argv[3]
output_dir = pathlib.Path(sys.argv[4])
output_dir.mkdir(parents=True, exist_ok=True)

today = dt.date.today().isoformat()
feature_name = ""
background_steps = []
scenarios = []
current = None
current_mode = None
example_headers = []
example_rows = []

step_prefixes = ("Given ", "When ", "Then ", "And ", "But ", "* ")

for raw_line in feature_path.read_text(encoding="utf-8").splitlines():
    line = raw_line.rstrip()
    stripped = line.strip()
    if not stripped or stripped.startswith("#"):
        continue
    if stripped.startswith("Feature:"):
        feature_name = stripped.split(":", 1)[1].strip()
        current = None
        current_mode = None
        continue
    if stripped.startswith("Background:"):
        current = None
        current_mode = "background"
        continue
    if stripped.startswith("Scenario Outline:") or stripped.startswith("Scenario:"):
        scenario_title = stripped.split(":", 1)[1].strip()
        current = {
            "title": scenario_title,
            "steps": [],
            "examples": [],
        }
        scenarios.append(current)
        current_mode = "scenario"
        example_headers = []
        example_rows = []
        continue
    if stripped.startswith("Examples:"):
        current_mode = "examples"
        example_headers = []
        example_rows = []
        continue

    if stripped.startswith(step_prefixes):
        normalized = re.sub(r"^(Given|When|Then|And|But|\*)\s+", "", stripped)
        if current_mode == "background":
            background_steps.append(normalized)
        elif current is not None:
            current["steps"].append(normalized)
        continue

    if current_mode == "examples" and stripped.startswith("|") and stripped.endswith("|"):
        columns = [part.strip() for part in stripped.strip("|").split("|")]
        if not example_headers:
            example_headers = columns
        else:
            example_rows.append(columns)
            current["examples"] = [example_headers] + example_rows
        continue

existing_numbers = []
pattern = re.compile(rf"^TC-{re.escape(module)}-(\d{{3}})\.md$")
for item in output_dir.iterdir():
    match = pattern.match(item.name)
    if match:
        existing_numbers.append(int(match.group(1)))
next_number = max(existing_numbers, default=0) + 1


def slugify(text: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9]+", "-", text).strip("-")
    return cleaned.lower() or "scenario"


def build_examples_block(example_table):
    if not example_table:
        return ""
    headers = example_table[0]
    rows = example_table[1:]
    if not rows:
        return ""
    lines = ["\n## Examples\n", "| " + " | ".join(headers) + " |", "|" + "|".join(["---"] * len(headers)) + "|"]
    for row in rows:
        padded = row + [""] * max(0, len(headers) - len(row))
        lines.append("| " + " | ".join(padded[: len(headers)]) + " |")
    return "\n".join(lines) + "\n"


def summary_precondition(background):
    if not background:
        return ""
    return "; ".join(background[:2])[:200]


for scenario in scenarios:
    case_id = f"TC-{module}-{next_number:03d}"
    file_name = output_dir / f"{case_id}.md"
    title = scenario["title"] or feature_name or case_id
    lines = [
        "---",
        f"id: {case_id}",
        f"title: \"{title.replace(chr(34), chr(39))}\"",
        f"module: {module}",
        "priority: P2",
        "risk: medium",
        "type: functional",
        "stage: []",
        "status: draft",
        "version: 1",
        "automated: false",
        'automation_ref: ""',
        f"precondition: \"{summary_precondition(background_steps).replace(chr(34), chr(39))}\"",
        'requirement_ref: ""',
        'design_ref: ""',
        "source: untracked",
        f"source_ref: \"{feature_path.name}\"",
        'benchmark_ref: ""',
        "benchmark_gaps: []",
        "review: pending",
        'reviewer: ""',
        'review_date: ""',
        'review_note: ""',
        'jira_ref: ""',
        "tags:",
        "  - gherkin-import",
        f"  - {slugify(module)}",
        f"author: {author}",
        f"created: {today}",
        f"updated: {today}",
        "---",
        "",
        f"# {title}",
        "",
        "## Background",
        "",
        f"Imported from feature: `{feature_path.name}`.",
        "",
        "## Preconditions",
        "",
    ]

    if background_steps:
        lines.extend([f"- {step}" for step in background_steps])
    else:
        lines.append("- None specified.")

    lines.extend([
        "",
        "## Test Steps",
        "",
        "| # | Step | Input Data | Expected Result |",
        "|---|------|------------|-----------------|",
    ])

    for index, step in enumerate(scenario["steps"], start=1):
        safe_step = step.replace("|", "\\|")
        lines.append(f"| {index} | {safe_step} | - | Verify expected behavior |")

    if not scenario["steps"]:
        lines.append("| 1 | Review imported scenario manually | - | Replace with expected result |")

    lines.extend([
        "",
        "## Industry Benchmark",
        "",
        "- Not captured during Gherkin import.",
        "",
        "## Notes",
        "",
        "- Review imported steps and expected results before execution.",
    ])

    examples_block = build_examples_block(scenario["examples"])
    if examples_block:
        lines.append(examples_block.rstrip("\n"))

    file_name.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(str(file_name))
    next_number += 1
PY
