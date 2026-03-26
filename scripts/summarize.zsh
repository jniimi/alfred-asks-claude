#!/bin/zsh
# 要約: 選択テキストを日本語で要約

SCRIPT_DIR="${0:A:h}"
source "${SCRIPT_DIR}/../lib/api.zsh"

SYSTEM_PROMPT="あなたは優秀な要約者です。
入力テキストの内容を日本語で簡潔に要約してください。
要約結果のみを出力し、前置きや補足は一切付けないでください。"

main() {
  local input="$1"
  if [[ -z "$input" ]]; then
    input=$(cat)
  fi
  if [[ -z "$input" ]]; then
    echo "ERROR: 入力テキストがありません" >&2
    return 1
  fi

  call_api "$SYSTEM_PROMPT" "$input"
}

main "$@"
