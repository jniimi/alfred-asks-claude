#!/bin/zsh
# 質問: 選択テキストの内容を解説

SCRIPT_DIR="${0:A:h}"
source "${SCRIPT_DIR}/../lib/api.zsh"

SYSTEM_PROMPT="あなたは優秀な解説者です。
ユーザーから与えられた内容について、日本語で解説してください。
回答は5行以内に収めてください。箇条書きや表は使わず、平文で端的にまとめてください。"

main() {
  local input="$1"
  if [[ -z "$input" ]]; then
    input=$(cat)
  fi
  if [[ -z "$input" ]]; then
    echo "ERROR: 入力テキストがありません" >&2
    return 1
  fi

  local prompt="以下の内容について簡単に解説して:
${input}"

  call_api "$SYSTEM_PROMPT" "$prompt"
}

main "$@"
