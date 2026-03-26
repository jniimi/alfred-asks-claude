#!/bin/zsh
# 翻訳: 日本語→英語 / 英語→日本語 を自動判定

SCRIPT_DIR="${0:A:h}"
source "${SCRIPT_DIR}/../lib/api.zsh"

SYSTEM_PROMPT="あなたは優秀な翻訳者です。
入力テキストが日本語であれば英語に、英語であれば日本語に翻訳してください。
翻訳結果のみを出力し、説明や補足は一切付けないでください。"

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
