#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_RULES="$SCRIPT_DIR/sanitize-rules.yaml"

usage() {
  cat <<'USAGE'
Usage:
  sanitize.sh --input <file|dir> [--output <file|dir>] [--dry-run] [--rules <yaml-path>]

Description:
  Apply regex-based sanitization rules to a file or directory tree.

Options:
  --input <path>        Input file or directory
  --output <path>       Output file or directory; required unless --dry-run is used
  --rules <yaml-path>   Rules file to use (default: scripts/sanitize-rules.yaml)
  --dry-run             Preview matches without writing files
  --help                Show this help message
USAGE
}

INPUT_PATH=""
OUTPUT_PATH=""
RULES_PATH="$DEFAULT_RULES"
DRY_RUN="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)
      INPUT_PATH="${2:-}"
      shift 2
      ;;
    --output)
      OUTPUT_PATH="${2:-}"
      shift 2
      ;;
    --rules)
      RULES_PATH="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN="true"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown option $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

[[ -n "$INPUT_PATH" ]] || { echo "Error: --input is required" >&2; exit 1; }
[[ -e "$INPUT_PATH" ]] || { echo "Error: input path not found: $INPUT_PATH" >&2; exit 1; }
[[ -f "$RULES_PATH" ]] || { echo "Error: rules file not found: $RULES_PATH" >&2; exit 1; }
if [[ "$DRY_RUN" != "true" && -z "$OUTPUT_PATH" ]]; then
  echo "Error: --output is required unless --dry-run is used" >&2
  exit 1
fi

python3 - <<'PY' "$INPUT_PATH" "$OUTPUT_PATH" "$RULES_PATH" "$DRY_RUN"
import pathlib
import re
import shutil
import sys

input_path = pathlib.Path(sys.argv[1])
output_arg = sys.argv[2]
rules_path = pathlib.Path(sys.argv[3])
dry_run = sys.argv[4].lower() == "true"
output_path = pathlib.Path(output_arg) if output_arg else None


def parse_scalar(value: str):
    value = value.strip()
    if value in {"true", "false"}:
        return value == "true"
    if value == "":
        return ""
    if (value.startswith(""") and value.endswith(""")) or (value.startswith("'") and value.endswith("'")):
        return value[1:-1]
    return value


def parse_rules(path: pathlib.Path):
    rules = []
    current = None
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.rstrip()
        stripped = line.strip()
        if not stripped or stripped.startswith("#") or stripped == "rules:":
            continue
        if stripped.startswith("- "):
            if current:
                rules.append(current)
            current = {"enabled": True}
            remainder = stripped[2:]
            if remainder and ":" in remainder:
                key, value = remainder.split(":", 1)
                current[key.strip()] = parse_scalar(value)
            continue
        if current is None or ":" not in stripped:
            continue
        key, value = stripped.split(":", 1)
        current[key.strip()] = parse_scalar(value)
    if current:
        rules.append(current)
    return [rule for rule in rules if rule.get("enabled", True)]


rules = parse_rules(rules_path)
if not rules:
    raise SystemExit("Error: no enabled rules found")


def collect_files(path: pathlib.Path):
    if path.is_file():
        return [path]
    return sorted(candidate for candidate in path.rglob("*") if candidate.is_file())


def sanitize_text(text: str):
    summary = []
    updated = text
    for rule in rules:
        pattern = rule.get("pattern", "")
        replacement = rule.get("replacement", "")
        if not pattern:
            summary.append((rule.get("name", "unnamed"), 0))
            continue
        compiled = re.compile(pattern)
        updated, count = compiled.subn(replacement, updated)
        summary.append((rule.get("name", "unnamed"), count))
    return updated, summary

files = collect_files(input_path)

if output_path and not dry_run:
    if input_path.is_dir():
        output_path.mkdir(parents=True, exist_ok=True)
    else:
        output_path.parent.mkdir(parents=True, exist_ok=True)

for source_file in files:
    source_text = source_file.read_text(encoding="utf-8")
    sanitized_text, summary = sanitize_text(source_text)
    print(f"FILE: {source_file}")
    for name, count in summary:
        print(f"  - {name}: {count}")

    if dry_run:
        continue

    if input_path.is_dir():
        relative = source_file.relative_to(input_path)
        destination = output_path / relative
        destination.parent.mkdir(parents=True, exist_ok=True)
    else:
        destination = output_path
        destination.parent.mkdir(parents=True, exist_ok=True)

    destination.write_text(sanitized_text, encoding="utf-8")
PY
