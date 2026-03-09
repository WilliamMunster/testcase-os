#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="$PROJECT_ROOT/_system/config.yaml"
API_VERSION="3"

usage() {
  cat <<'USAGE'
Usage:
  jira-cli.sh <command> [arguments]

Commands:
  pull-prd <ticket>              Fetch issue summary and description as Markdown
  create-bug <markdown-file>     Create a Jira bug from a local Markdown file
  sync-status <ticket>           Fetch and print the current issue status
  link-case <ticket> <case-id>   Create a remote link from Jira to a test case
  --help                         Show this help message

Environment:
  JIRA_TOKEN                     Required Jira API token
  JIRA_USER                      Optional username/email for basic auth
  CASE_LINK_BASE_URL             Optional base URL for link-case; defaults to a placeholder URL

Examples:
  jira-cli.sh pull-prd PROJ-123
  jira-cli.sh create-bug bugs/BUG-001.md
  jira-cli.sh sync-status PROJ-123
  CASE_LINK_BASE_URL=https://kb.example.com/cases jira-cli.sh link-case PROJ-123 TC-AUTH-001
USAGE
}

command_help() {
  local command_name="$1"
  case "$command_name" in
    pull-prd)
      cat <<'USAGE'
Usage: jira-cli.sh pull-prd <ticket>
Fetch the Jira issue summary and description, then print them as Markdown.
USAGE
      ;;
    create-bug)
      cat <<'USAGE'
Usage: jira-cli.sh create-bug <markdown-file>
Create a Jira bug issue using the file title as summary and the full file as description.
USAGE
      ;;
    sync-status)
      cat <<'USAGE'
Usage: jira-cli.sh sync-status <ticket>
Fetch the Jira issue status and print a compact sync summary.
USAGE
      ;;
    link-case)
      cat <<'USAGE'
Usage: jira-cli.sh link-case <ticket> <case-id>
Create a Jira remote link to a testcase-os case. Set CASE_LINK_BASE_URL to a stable case URL prefix.
USAGE
      ;;
    *)
      usage
      ;;
  esac
}

fail() {
  echo "Error: $*" >&2
  exit 1
}

require_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "Required file not found: $path"
}

require_env() {
  local var_name="$1"
  [[ -n "${!var_name:-}" ]] || fail "Environment variable $var_name is required"
}

yaml_get() {
  local section="$1"
  local key="$2"
  awk -v section="$section" -v key="$key" '
    $0 ~ "^" section ":" {in_section=1; next}
    in_section && $0 ~ /^[A-Za-z0-9_-]+:/ {in_section=0}
    in_section {
      pattern = "^[[:space:]]+" key ":[[:space:]]*"
      if ($0 ~ pattern) {
        value = $0
        sub(pattern, "", value)
        gsub(/^"|"$/, "", value)
        gsub(/^'"'"'|'"'"'$/, "", value)
        print value
        exit
      }
    }
  ' "$CONFIG_FILE"
}

jira_base_url() {
  local value
  value="$(yaml_get jira base_url)"
  [[ -n "$value" ]] || fail "jira.base_url is missing from $CONFIG_FILE"
  printf '%s' "$value"
}

jira_project_key() {
  local value
  value="$(yaml_get jira project_key)"
  [[ -n "$value" ]] || fail "jira.project_key is missing from $CONFIG_FILE"
  printf '%s' "$value"
}

jira_request() {
  local method="$1"
  local endpoint="$2"
  local data="${3:-}"
  local base_url
  base_url="$(jira_base_url)"
  require_env JIRA_TOKEN

  local -a auth_args
  if [[ -n "${JIRA_USER:-}" ]]; then
    auth_args=(-u "$JIRA_USER:$JIRA_TOKEN")
  else
    auth_args=(-H "Authorization: Bearer $JIRA_TOKEN")
  fi

  local -a curl_args=(
    -sS
    -X "$method"
    "${auth_args[@]}"
    -H "Accept: application/json"
    -H "Content-Type: application/json"
    "${base_url}/rest/api/${API_VERSION}/${endpoint}"
  )

  if [[ -n "$data" ]]; then
    curl_args+=(--data "$data")
  fi

  curl "${curl_args[@]}"
}

json_escape() {
  python3 -c 'import json, sys; print(json.dumps(sys.stdin.read()))'
}

read_markdown_summary() {
  local file_path="$1"
  awk 'NF {gsub(/^#+[[:space:]]*/, ""); print; exit}' "$file_path"
}

pull_prd() {
  local ticket="$1"
  local response
  response="$(jira_request GET "issue/${ticket}?fields=summary,description")"
  python3 - <<'PY' "$ticket" "$response"
import json
import sys

ticket = sys.argv[1]
payload = json.loads(sys.argv[2])
fields = payload.get("fields", {})
summary = fields.get("summary", "")
description = fields.get("description")

print(f"# {ticket} - {summary}\n")
print("## Description\n")

if isinstance(description, dict):
    blocks = []
    for block in description.get("content", []):
        for item in block.get("content", []):
            if item.get("type") == "text":
                blocks.append(item.get("text", ""))
        if blocks and blocks[-1] != "":
            blocks.append("\n")
    text = "".join(blocks).strip()
    print(text if text else "(No description)")
elif isinstance(description, str):
    print(description if description else "(No description)")
else:
    print("(No description)")
PY
}

create_bug() {
  local markdown_file="$1"
  require_file "$markdown_file"
  local summary
  summary="$(read_markdown_summary "$markdown_file")"
  [[ -n "$summary" ]] || summary="Imported bug from $(basename "$markdown_file")"

  local description_json
  description_json="$(json_escape < "$markdown_file")"
  local project_key
  project_key="$(jira_project_key)"

  local payload
  payload="$(python3 - <<'PY' "$project_key" "$summary" "$description_json"
import json
import sys

project_key = sys.argv[1]
summary = sys.argv[2]
description_text = json.loads(sys.argv[3])

payload = {
    "fields": {
        "project": {"key": project_key},
        "summary": summary,
        "issuetype": {"name": "Bug"},
        "description": description_text,
    }
}
print(json.dumps(payload))
PY
)"

  jira_request POST "issue" "$payload"
}

sync_status() {
  local ticket="$1"
  local response
  response="$(jira_request GET "issue/${ticket}?fields=status")"
  python3 - <<'PY' "$ticket" "$response"
import json
import sys

ticket = sys.argv[1]
payload = json.loads(sys.argv[2])
status = payload.get("fields", {}).get("status", {}).get("name", "UNKNOWN")
print(f"ticket={ticket}")
print(f"status={status}")
PY
}

link_case() {
  local ticket="$1"
  local case_id="$2"
  local base_case_url="${CASE_LINK_BASE_URL:-https://example.invalid/testcase-os/cases}"
  local case_url="${base_case_url%/}/${case_id}.md"
  local payload
  payload="$(python3 - <<'PY' "$case_id" "$case_url"
import json
import sys

case_id = sys.argv[1]
case_url = sys.argv[2]
payload = {
    "object": {
        "url": case_url,
        "title": case_id,
        "summary": f"testcase-os test case {case_id}",
        "icon": {"title": "testcase-os"},
    }
}
print(json.dumps(payload))
PY
)"
  jira_request POST "issue/${ticket}/remotelink" "$payload"
}

main() {
  require_file "$CONFIG_FILE"

  local command="${1:-}"
  case "$command" in
    ""|--help|-h)
      usage
      exit 0
      ;;
    pull-prd|create-bug|sync-status|link-case)
      if [[ "${2:-}" == "--help" || "${2:-}" == "-h" ]]; then
        command_help "$command"
        exit 0
      fi
      ;;
  esac

  case "$command" in
    pull-prd)
      [[ $# -eq 2 ]] || fail "pull-prd requires <ticket>"
      pull_prd "$2"
      ;;
    create-bug)
      [[ $# -eq 2 ]] || fail "create-bug requires <markdown-file>"
      create_bug "$2"
      ;;
    sync-status)
      [[ $# -eq 2 ]] || fail "sync-status requires <ticket>"
      sync_status "$2"
      ;;
    link-case)
      [[ $# -eq 3 ]] || fail "link-case requires <ticket> <case-id>"
      link_case "$2" "$3"
      ;;
    *)
      fail "Unknown command: ${command:-<none>}"
      ;;
  esac
}

main "$@"
