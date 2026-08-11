#!/bin/bash
set -uo pipefail

BASE_DIR="/Users/tatevik.khachatryan/AI Product Managmeent/Trends Report Agent"
CLAUDE_BIN="/Users/tatevik.khachatryan/.local/bin/claude"
PROMPT_FILE="$BASE_DIR/trend-agent-prompt.txt"
RUN_LOG="$BASE_DIR/cron-run.log"

cd "$BASE_DIR" || exit 1

TOKEN_FILE="$HOME/.trend-agent-token"
if [ -f "$TOKEN_FILE" ]; then
  # shellcheck disable=SC1090
  source "$TOKEN_FILE"
fi

WEBHOOK_FILE="$BASE_DIR/.slack-webhook"
if [ -f "$WEBHOOK_FILE" ]; then
  export SLACK_WEBHOOK_URL="$(cat "$WEBHOOK_FILE")"
fi

{
  echo "=== Run started: $(date) ==="
  "$CLAUDE_BIN" -p "$(cat "$PROMPT_FILE")" \
    --model claude-sonnet-5 \
    --tools "WebSearch,Bash,Read,Write" \
    --allowedTools "WebSearch Bash Read Write" \
    --output-format text
  echo "=== Run finished: $(date) (exit code $?) ==="
} >> "$RUN_LOG" 2>&1
