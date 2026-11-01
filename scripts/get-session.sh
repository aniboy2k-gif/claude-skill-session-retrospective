#!/bin/bash
# Get current session JSONL content for retrospective analysis
# Usage: get-session.sh [session-id]
#
# session_id 획득 우선순위:
#   1) CLI 인자 ($1)
#   2) hook stdin JSON의 .session_id (stdin이 tty가 아닌 경우)
#   3) hooks/lib/session-id.sh 폴백 — CLAUDE_CODE_SESSION_ID (구 CLAUDE_SESSION_ID 폴백은 제거됨)
#
# Anthropic 공식 API는 hook stdin JSON의 .session_id 필드이며,
# CLAUDE_SESSION_ID 환경변수는 공식 기능이 아님 (GitHub issues
# #25642 / #13733 / #17188 모두 OPEN feature request).

set -e

# shellcheck source=../../../hooks/lib/session-id.sh
source "$HOME/.claude/hooks/lib/session-id.sh"

SESSION_ID="${1:-}"

if [ -z "$SESSION_ID" ] && [ ! -t 0 ]; then
  HOOK_INPUT=$(cat)
  SESSION_ID=$(extract_session_id "$HOOK_INPUT")
fi

if [ -z "$SESSION_ID" ]; then
  SESSION_ID=$(extract_session_id "")
fi

if [ -z "$SESSION_ID" ]; then
  echo "Error: session_id 획득 실패 (CLI 인자·stdin JSON·CLAUDE_CODE_SESSION_ID 모두 비어있음)" >&2
  exit 1
fi

PROJECTS_DIR="$HOME/.claude/projects"
SESSION_FILE=$(find "$PROJECTS_DIR" -name "${SESSION_ID}.jsonl" -type f 2>/dev/null | head -1)

if [ -z "$SESSION_FILE" ] || [ ! -f "$SESSION_FILE" ]; then
  echo "Error: Session file not found for ID: $SESSION_ID" >&2
  exit 1
fi

cat "$SESSION_FILE"
