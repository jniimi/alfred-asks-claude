#!/bin/zsh
# Ask Alfred - インストールスクリプト
# .alfredworkflow ファイルを生成し、開いてAlfredにインポートする

set -e

SCRIPT_DIR="${0:A:h}"
BUILD_DIR="${SCRIPT_DIR}/build"
WORKFLOW_NAME="Alfred Asks Claude.alfredworkflow"

echo "==> ビルドディレクトリを準備..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/workflow"

echo "==> ファイルをコピー..."
cp "${SCRIPT_DIR}/workflow/info.plist" "$BUILD_DIR/workflow/"
cp -r "${SCRIPT_DIR}/scripts" "$BUILD_DIR/workflow/"
cp -r "${SCRIPT_DIR}/lib" "$BUILD_DIR/workflow/"

echo "==> .alfredworkflow を生成..."
cd "$BUILD_DIR/workflow"
zip -r "${BUILD_DIR}/${WORKFLOW_NAME}" . -x ".*" > /dev/null

echo "==> Alfred にインポート..."
open "${BUILD_DIR}/${WORKFLOW_NAME}"

echo "==> 完了! Alfred でホットキーを設定してください。"
echo "    翻訳: ⌘+C, C (推奨)"
echo "    要約: ⌘+C, S (推奨)"
echo "    質問: ⌘+C, Q (推奨)"
