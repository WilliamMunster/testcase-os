#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up testcase-os at: $PROJECT_ROOT"

declare -a DIRECTORIES=(
  "_system"
  "_agents/instructions"
  "_agents/skills"
  "_agents/commands"
  "_agents/hooks"
  "cases"
  "commons/checklist"
  "commons/checklists"
  "commons/patterns"
  "commons/methodology"
  "commons/templates"
  "knowledge/domain"
  "knowledge/tech"
  "experience/escapes"
  "experience/lessons"
  "experience/best-practices"
  "experience/incidents"
  "experience/missed-bugs"
  "experience/techniques"
  "experience/anti-patterns"
  "evidence"
  "data"
  "journal"
  "scripts"
  "docs/plans"
  "docs/reviews"
)

create_index_if_missing() {
  local target_dir="$1"
  local label="$2"
  local index_file="$PROJECT_ROOT/$target_dir/_index.md"

  if [[ -f "$index_file" ]]; then
    return
  fi

  cat > "$index_file" <<EOF
# ${label} Index

> Auto-generated scaffold index. Update with project content.

## Statistics

| Metric | Count |
|--------|-------|
| Total items | 0 |
| Last updated | - |
EOF
}

for relative_dir in "${DIRECTORIES[@]}"; do
  mkdir -p "$PROJECT_ROOT/$relative_dir"
done

create_index_if_missing "cases" "Cases"
create_index_if_missing "commons" "Commons"
create_index_if_missing "knowledge" "Knowledge"
create_index_if_missing "experience" "Experience"

# Keep empty scaffold directories in Git without overwriting real content.
while IFS= read -r empty_dir; do
  touch "$empty_dir/.gitkeep"
done < <(find "$PROJECT_ROOT" \
  -path "$PROJECT_ROOT/.git" -prune -o \
  -type d -empty -print)

echo "Directory structure created."
