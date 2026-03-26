# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Alfred Asks Claude is a macOS Alfred Workflow that uses the Anthropic API (Claude Opus) to translate, summarize, and explain selected text via hotkeys. All scripts are written in zsh. The project is Japanese-language oriented (prompts, error messages, and README are in Japanese).

## Architecture

- **`lib/api.zsh`** — Shared API layer. Retrieves the Anthropic API key from macOS Keychain (`security` command), constructs the JSON payload with `jq`, and calls the Anthropic Messages API via `curl`. All three feature scripts source this file.
- **`scripts/`** — One script per feature (`translate.zsh`, `summarize.zsh`, `ask.zsh`). Each defines a system prompt and calls `call_api` from `lib/api.zsh`. Scripts accept input as `$1` or via stdin.
- **`workflow/info.plist`** — Alfred workflow definition. Wires hotkeys → run-script nodes → clipboard + Large Type output. Bundle ID: `com.jniimi.ask-alfred`.
- **`install.sh`** — Builds the `.alfredworkflow` zip from `workflow/`, `scripts/`, and `lib/`, then opens it to import into Alfred.

## Build & Install

```bash
zsh install.sh
```

This creates `build/` with the `.alfredworkflow` file and opens it in Alfred. No other build tooling exists; there are no tests, linters, or CI.

## Key Dependencies

- `jq` (required at runtime for JSON construction/parsing)
- macOS `security` CLI (Keychain access for API key)
- `curl` (Anthropic API calls)
- API model is set in `lib/api.zsh` (`API_MODEL` variable)

## Adding a New Feature Script

1. Create `scripts/<name>.zsh` following the pattern in existing scripts: source `lib/api.zsh`, define `SYSTEM_PROMPT`, write a `main()` that reads input and calls `call_api`.
2. Add corresponding hotkey and run-script nodes in `workflow/info.plist`, wiring them to the shared `copy-result` and `largetype-result` output nodes.
3. Run `zsh install.sh` to rebuild and reimport the workflow.
