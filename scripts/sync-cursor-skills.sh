#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_SRC="$PROJECT_ROOT/_agents/skills"
CURSOR_PROJECT="$PROJECT_ROOT/.cursor/skills"
CURSOR_GLOBAL="$HOME/.cursor/skills"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "No skills found at $SKILLS_SRC"
  exit 1
fi

count=0
for skill_file in "$SKILLS_SRC"/*.md; do
  [[ -f "$skill_file" ]] || continue
  name="$(basename "$skill_file" .md)"

  # Project-level: symlink
  mkdir -p "$CURSOR_PROJECT/$name"
  ln -sf "../../../_agents/skills/${name}.md" "$CURSOR_PROJECT/$name/SKILL.md"

  # Global-level: copy
  mkdir -p "$CURSOR_GLOBAL/$name"
  cp "$skill_file" "$CURSOR_GLOBAL/$name/SKILL.md"

  count=$((count + 1))
done

echo "Synced $count skills to:"
echo "  Project: $CURSOR_PROJECT"
echo "  Global:  $CURSOR_GLOBAL"
