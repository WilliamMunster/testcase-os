#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NON_INTERACTIVE=false

readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_RESET='\033[0m'
readonly TODAY="$(date +%F)"
readonly SUPPORTED_CLIS=(claude gemini codex kimi cursor)

declare -a DIRECTORIES=(
  "_system"
  "_agents/instructions"
  "_agents/skills"
  "_agents/commands"
  "_agents/hooks"
  "cases"
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

PROJECT_NAME="${PROJECT_NAME:-}"
PROJECT_KEY="${PROJECT_KEY:-}"
JIRA_URL="${JIRA_URL:-}"
JIRA_PROJECT_KEY="${JIRA_PROJECT_KEY:-}"
TEAM_NAME="${TEAM_NAME:-}"
QA_LEAD_NAME="${QA_LEAD_NAME:-}"
QA_LEAD_EMAIL="${QA_LEAD_EMAIL:-}"
AUTO_APPROVE_P2_P3="${AUTO_APPROVE_P2_P3:-}"
ENABLED_CLIS="${ENABLED_CLIS:-}"

echo_banner() {
  printf '%b\n' "${COLOR_BLUE}"
  cat <<'BANNER'
========================================
      testcase-os initializer
========================================
BANNER
  printf '%b' "${COLOR_RESET}"
}

log_info() {
  printf '%b\n' "${COLOR_BLUE}$*${COLOR_RESET}"
}

log_success() {
  printf '%b\n' "${COLOR_GREEN}$*${COLOR_RESET}"
}

log_warn() {
  printf '%b\n' "${COLOR_YELLOW}$*${COLOR_RESET}"
}

log_error() {
  printf '%b\n' "${COLOR_RED}$*${COLOR_RESET}" >&2
}

usage() {
  cat <<'USAGE'
Usage:
  ./setup.sh [--non-interactive] [--help]

Modes:
  Default           Prompt for project settings interactively
  --non-interactive Read all values from environment variables

Required environment variables for --non-interactive:
  PROJECT_NAME
  PROJECT_KEY
  TEAM_NAME
  QA_LEAD_NAME
  QA_LEAD_EMAIL
  AUTO_APPROVE_P2_P3   true|false|y|n
  ENABLED_CLIS         space-separated list: claude gemini codex kimi cursor

Optional environment variables:
  JIRA_URL
  JIRA_PROJECT_KEY
USAGE
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

validate_project_key() {
  local key="$1"
  [[ "$key" =~ ^[A-Z]{2,6}$ ]]
}

normalize_bool() {
  local value
  value="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  case "$value" in
    y|yes|true|1)
      printf 'true'
      ;;
    n|no|false|0)
      printf 'false'
      ;;
    *)
      return 1
      ;;
  esac
}

validate_clis() {
  local cli
  local item
  local valid

  for item in $1; do
    valid=false
    for cli in "${SUPPORTED_CLIS[@]}"; do
      if [[ "$item" == "$cli" ]]; then
        valid=true
        break
      fi
    done
    if [[ "$valid" == false ]]; then
      return 1
    fi
  done

  return 0
}

require_non_empty() {
  local value="$1"
  local label="$2"
  if [[ -z "$value" ]]; then
    log_error "$label is required."
    exit 1
  fi
}

prompt_required() {
  local prompt_label="$1"
  local result=""
  while [[ -z "$result" ]]; do
    read -r -p "$prompt_label: " result
    result="$(trim "$result")"
    if [[ -z "$result" ]]; then
      log_warn "This field is required."
    fi
  done
  printf '%s' "$result"
}

prompt_optional() {
  local prompt_label="$1"
  local result=""
  read -r -p "$prompt_label: " result
  printf '%s' "$(trim "$result")"
}

prompt_project_key() {
  local result=""
  while true; do
    read -r -p "Project key (2-6 uppercase letters, used in TC-PROJ-001): " result
    result="$(trim "$result")"
    if validate_project_key "$result"; then
      printf '%s' "$result"
      return
    fi
    log_error "Project key must be 2-6 uppercase letters."
  done
}

prompt_auto_approve() {
  local answer=""
  while true; do
    read -r -p "Auto-approve P2/P3 test cases? (y/n): " answer
    answer="$(trim "$answer")"
    if AUTO_APPROVE_P2_P3="$(normalize_bool "$answer" 2>/dev/null)"; then
      printf '%s' "$AUTO_APPROVE_P2_P3"
      return
    fi
    log_error "Please answer y or n."
  done
}

prompt_clis() {
  local answer=""
  while true; do
    read -r -p "Enabled AI CLI(s) [claude gemini codex kimi cursor]: " answer
    answer="$(trim "$answer")"
    if [[ -z "$answer" ]]; then
      log_error "Select at least one CLI."
      continue
    fi
    if validate_clis "$answer"; then
      printf '%s' "$answer"
      return
    fi
    log_error "Unsupported CLI found. Use only: claude gemini codex kimi cursor"
  done
}

load_non_interactive_values() {
  PROJECT_NAME="$(trim "${PROJECT_NAME:-}")"
  PROJECT_KEY="$(trim "${PROJECT_KEY:-}")"
  JIRA_URL="$(trim "${JIRA_URL:-}")"
  JIRA_PROJECT_KEY="$(trim "${JIRA_PROJECT_KEY:-}")"
  TEAM_NAME="$(trim "${TEAM_NAME:-}")"
  QA_LEAD_NAME="$(trim "${QA_LEAD_NAME:-}")"
  QA_LEAD_EMAIL="$(trim "${QA_LEAD_EMAIL:-}")"
  ENABLED_CLIS="$(trim "${ENABLED_CLIS:-}")"
  local auto_approve_value="$(trim "${AUTO_APPROVE_P2_P3:-}")"

  require_non_empty "$PROJECT_NAME" "PROJECT_NAME"
  require_non_empty "$PROJECT_KEY" "PROJECT_KEY"
  require_non_empty "$TEAM_NAME" "TEAM_NAME"
  require_non_empty "$QA_LEAD_NAME" "QA_LEAD_NAME"
  require_non_empty "$QA_LEAD_EMAIL" "QA_LEAD_EMAIL"
  require_non_empty "$ENABLED_CLIS" "ENABLED_CLIS"
  require_non_empty "$auto_approve_value" "AUTO_APPROVE_P2_P3"

  if ! validate_project_key "$PROJECT_KEY"; then
    log_error "PROJECT_KEY must be 2-6 uppercase letters."
    exit 1
  fi

  if ! AUTO_APPROVE_P2_P3="$(normalize_bool "$auto_approve_value")"; then
    log_error "AUTO_APPROVE_P2_P3 must be one of: true false y n yes no 1 0"
    exit 1
  fi

  if ! validate_clis "$ENABLED_CLIS"; then
    log_error "ENABLED_CLIS contains unsupported values."
    exit 1
  fi
}

collect_inputs() {
  if [[ "$NON_INTERACTIVE" == true ]]; then
    load_non_interactive_values
    return
  fi

  PROJECT_NAME="$(prompt_required 'Project name')"
  PROJECT_KEY="$(prompt_project_key)"
  JIRA_URL="$(prompt_optional 'Jira URL (optional, press Enter to skip)')"
  JIRA_PROJECT_KEY="$(prompt_optional 'Jira project key (optional)')"
  TEAM_NAME="$(prompt_required 'Team name')"
  QA_LEAD_NAME="$(prompt_required 'QA Lead name')"
  QA_LEAD_EMAIL="$(prompt_required 'QA Lead email')"
  AUTO_APPROVE_P2_P3="$(prompt_auto_approve)"
  ENABLED_CLIS="$(prompt_clis)"
}

create_index_if_missing() {
  local target_dir="$1"
  local label="$2"
  local index_file="$PROJECT_ROOT/$target_dir/_index.md"

  if [[ -f "$index_file" ]]; then
    return
  fi

  cat > "$index_file" <<INDEXEOF
# ${label} Index

> Auto-generated scaffold index. Update with project content.

## Statistics

| Metric | Count |
|--------|-------|
| Total items | 0 |
| Last updated | - |
INDEXEOF
}

ensure_scaffold() {
  local relative_dir=""
  for relative_dir in "${DIRECTORIES[@]}"; do
    mkdir -p "$PROJECT_ROOT/$relative_dir"
  done

  create_index_if_missing "cases" "Cases"
  create_index_if_missing "commons" "Commons"
  create_index_if_missing "knowledge" "Knowledge"
  create_index_if_missing "experience" "Experience"

  while IFS= read -r empty_dir; do
    touch "$empty_dir/.gitkeep"
  done < <(find "$PROJECT_ROOT" \
    -path "$PROJECT_ROOT/.git" -prune -o \
    -type d -empty -print)
}

write_config_yaml() {
  cat > "$PROJECT_ROOT/_system/config.yaml" <<EOF_CONFIG
# testcase-os configuration
# Generated by setup.sh on ${TODAY}

project:
  name: "${PROJECT_NAME}"
  key: "${PROJECT_KEY}"

jira:
  base_url: "${JIRA_URL}"
  project_key: "${JIRA_PROJECT_KEY}"

review:
  auto_approve_p2_p3: ${AUTO_APPROVE_P2_P3}
  trusted_authors:
    - "${QA_LEAD_EMAIL}"

id_format:
  prefix: "TC-${PROJECT_KEY}"
  separator: "-"

import:
  default_source: "untracked"
  default_review: "pending"
  sanitize_on_import: true
EOF_CONFIG
}

write_identity_md() {
  cat > "$PROJECT_ROOT/_system/identity.md" <<EOF_IDENTITY
# Project Identity

> Generated by setup.sh on ${TODAY}

## Team

| Field | Value | Notes |
|------|-------|-------|
| Team Name | ${TEAM_NAME} | Primary QA team |
| Project Name | ${PROJECT_NAME} | Product under test |
| Project Key | ${PROJECT_KEY} | Case code pattern: TC-${PROJECT_KEY}-001 |
| Jira URL | ${JIRA_URL:-Not configured} | Requirement and issue tracking |
| Jira Project Key | ${JIRA_PROJECT_KEY:-Not configured} | Jira project scope |

## Contacts

| Role | Name | Contact |
|------|------|---------|
| QA Lead | ${QA_LEAD_NAME} | ${QA_LEAD_EMAIL} |

## Enabled AI CLI

$(for cli in $ENABLED_CLIS; do printf -- '- `%s`\n' "$cli"; done)

## Next Customization

- Update _system/goals.md with quality objectives.
- Update _system/active-context.md with the current sprint focus.
- Add module definitions under cases/ before large-scale import.
EOF_IDENTITY
}

write_team_yaml() {
  local team_id
  team_id="$(printf '%s' "$TEAM_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"

  cat > "$PROJECT_ROOT/team.yaml" <<EOF_TEAM
schema_version: 1

team:
  name: "${team_id}"
  description: "Generated team RBAC for ${TEAM_NAME}."

members:
  - id: "qa-lead-1"
    name: "${QA_LEAD_NAME}"
    role: "qa-lead"
    email: "${QA_LEAD_EMAIL}"

roles:
  qa-lead:
    description: "Full ownership of the test knowledge base; PRD remains read-only."
    permissions:
      cases/: { read: true, write: true }
      commons/: { read: true, write: true }
      knowledge/: { read: true, write: true }
      experience/: { read: true, write: true }
      bugs/: { read: true, write: true }
      docs/: { read: true, write: false }
      _system/: { read: true, write: true }
      journal/: { read: true, write: true }

  qa-engineer:
    description: "Can author cases and knowledge, contribute bugs and experience, and read PRD content."
    permissions:
      cases/: { read: true, write: true }
      commons/: { read: true, write: false }
      knowledge/: { read: true, write: true }
      experience/: { read: true, write: true }
      bugs/: { read: true, write: true }
      docs/: { read: true, write: false }
      _system/: { read: true, write: false }
      journal/: { read: true, write: true }

  developer:
    description: "Can review shared artifacts, update bug and experience records, and read PRD content."
    permissions:
      cases/: { read: true, write: false }
      commons/: { read: true, write: false }
      knowledge/: { read: true, write: false }
      experience/: { read: true, write: true }
      bugs/: { read: true, write: true }
      docs/: { read: true, write: false }
      _system/: { read: true, write: false }
      journal/: { read: true, write: false }

  pm:
    description: "Primarily read-only access with PRD stewardship preserved in docs."
    permissions:
      cases/: { read: true, write: false }
      commons/: { read: true, write: false }
      knowledge/: { read: true, write: false }
      experience/: { read: true, write: false }
      bugs/: { read: true, write: false }
      docs/: { read: true, write: true }
      _system/: { read: true, write: false }
      journal/: { read: true, write: false }
EOF_TEAM
}

write_hook_file() {
  local cli_name="$1"
  local hook_file="$PROJECT_ROOT/_agents/hooks/${cli_name}.hook.sh"

  cat > "$hook_file" <<EOF_HOOK
#!/usr/bin/env bash
set -euo pipefail

# Generated hook scaffold for ${cli_name}.
# Extend this hook to load testcase-os context for ${cli_name} sessions.

echo "[${cli_name}] testcase-os hook placeholder for ${PROJECT_NAME}"
EOF_HOOK

  chmod +x "$hook_file"
}

link_cursor_skills() {
  local skills_src="$PROJECT_ROOT/_agents/skills"
  local cursor_skills="$PROJECT_ROOT/.cursor/skills"
  local global_skills="$HOME/.cursor/skills"
  local skill_file=""
  local skill_name=""

  if [[ ! -d "$skills_src" ]]; then
    return
  fi

  for skill_file in "$skills_src"/*.md; do
    [[ -f "$skill_file" ]] || continue
    skill_name="$(basename "$skill_file" .md)"
    # Project-level: symlink
    mkdir -p "$cursor_skills/$skill_name"
    ln -sf "../../../_agents/skills/${skill_name}.md" "$cursor_skills/$skill_name/SKILL.md"
    # Global-level: copy for cross-project discovery
    mkdir -p "$global_skills/$skill_name"
    cp "$skill_file" "$global_skills/$skill_name/SKILL.md"
  done
  log_success "Cursor skills linked: $cursor_skills"
  log_success "Cursor skills synced to global: $global_skills"
}

write_hooks() {
  local cli_name=""
  mkdir -p "$PROJECT_ROOT/_agents/hooks"
  for cli_name in $ENABLED_CLIS; do
    write_hook_file "$cli_name"
  done

  # Link skills for Cursor discovery
  for cli_name in $ENABLED_CLIS; do
    if [[ "$cli_name" == "cursor" ]]; then
      link_cursor_skills
      break
    fi
  done
}

print_summary() {
  printf '\n'
  log_success 'Initialization complete.'
  printf '%b\n' "${COLOR_GREEN}Project Name:${COLOR_RESET} ${PROJECT_NAME}"
  printf '%b\n' "${COLOR_GREEN}Config Files:${COLOR_RESET}"
  printf '  - %s\n' "$PROJECT_ROOT/_system/config.yaml"
  printf '  - %s\n' "$PROJECT_ROOT/_system/identity.md"
  printf '  - %s\n' "$PROJECT_ROOT/team.yaml"
  printf '%b\n' "${COLOR_GREEN}Enabled CLI:${COLOR_RESET} ${ENABLED_CLIS}"
  printf '%b\n' "${COLOR_GREEN}Next Steps:${COLOR_RESET}"
  printf '  1. Review generated files and adjust project-specific details.\n'
  printf '  2. Update _system/goals.md and _system/active-context.md.\n'
  printf '  3. Start creating modules under cases/ and enable CLI hooks as needed.\n'
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --non-interactive)
        NON_INTERACTIVE=true
        shift
        ;;
      --help|-h)
        usage
        exit 0
        ;;
      *)
        log_error "Unknown argument: $1"
        usage >&2
        exit 1
        ;;
    esac
  done

  echo_banner
  log_info "Initializing testcase-os at: $PROJECT_ROOT"

  collect_inputs
  ensure_scaffold
  write_config_yaml
  write_identity_md
  write_team_yaml
  write_hooks
  print_summary
}

main "$@"
