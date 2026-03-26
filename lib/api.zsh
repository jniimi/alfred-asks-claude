#!/bin/zsh
# Anthropic API 共通処理

API_MODEL="claude-opus-4-6"
API_URL="https://api.anthropic.com/v1/messages"

get_api_key() {
  local key
  key=$(security find-generic-password -s "anthropic-api-key" -a "claude" -w 2>/dev/null)
  if [[ -z "$key" ]]; then
    echo "ERROR: APIキーがKeychainに見つかりません" >&2
    return 1
  fi
  echo "$key"
}

call_api() {
  local system_prompt="$1"
  local user_message="$2"
  local api_key

  api_key=$(get_api_key) || return 1

  local payload
  payload=$(jq -n \
    --arg model "$API_MODEL" \
    --arg system "$system_prompt" \
    --arg message "$user_message" \
    '{
      model: $model,
      max_tokens: 4096,
      system: $system,
      messages: [{ role: "user", content: $message }]
    }')

  local tmpfile
  tmpfile=$(mktemp)
  trap "rm -f '$tmpfile'" EXIT

  local http_code
  http_code=$(curl -s -o "$tmpfile" -w "%{http_code}" "$API_URL" \
    -H "Content-Type: application/json" \
    -H "x-api-key: $api_key" \
    -H "anthropic-version: 2023-06-01" \
    -d "$payload")

  if [[ "$http_code" -ne 200 ]]; then
    local error_msg
    error_msg=$(jq -r '.error.message // "不明なエラー"' "$tmpfile" 2>/dev/null)
    echo "ERROR: API呼び出し失敗 (HTTP $http_code): $error_msg" >&2
    return 1
  fi

  jq -r '.content[0].text' "$tmpfile"
}
