# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

OpenCC is a shell script wrapper for the `claude` CLI tool. It loads environment configuration from `.env.cc` to enable Claude Code usage with alternative API providers (OpenRouter, Z.ai).

Key files:
- `start-cc.sh`: Core script that sources `.env.cc`, masks secrets in output, and executes `claude "$@"`.
- `.env.cc.example`: OpenRouter configuration template.
- `.env.cc.zai.example`: Z.ai configuration template.
- `README.md`: Setup, usage, and deployment instructions.
- `CLAUDE.md`: This file - internal guidance for Claude Code.

## Common Commands

### Initial Setup
```bash
chmod +x start-cc.sh
cp .env.cc.example .env.cc  # or .env.cc.zai.example for Z.ai
# Edit CLAUDE_CODE_OAUTH_TOKEN with your API key
echo ".env.cc" >> .gitignore
```

### Execution
```bash
./start-cc.sh                       # Launch Claude Code
./start-cc.sh --dangerously-skip-permissions  # With arguments
./start-cc.sh --help                # Show usage
./start-cc.sh --debug               # Enable zsh tracing
```

### Verification
No build system, linter, or tests. Verify changes by running the script directly.

## Architecture

Single-script design (`start-cc.sh`):

1. **Environment file check**: Verifies `.env.cc` exists in script directory.
2. **Flag processing**: Handles `--help` and `--debug` flags before loading config.
3. **Config parsing**: Reads each line, validates variable names (alphanumeric/underscore only), strips quotes.
4. **Secret masking**: `is_secret()` identifies sensitive variables by name patterns (api, key, secret, token, pass, pwd). `mask_value()` displays first/last 4 chars for values >= 8 chars.
5. **Export**: Exports all valid variables to environment.
6. **App attribution**: For OpenRouter/Z.ai, sets `ANTHROPIC_CUSTOM_HEADERS` if `OPENROUTER_APP_URL` and `OPENROUTER_APP_NAME` are configured.
7. **Validation**: Ensures `CLAUDE_CODE_OAUTH_TOKEN` is defined and non-empty; checks `claude` command exists.
8. **Execution**: Uses `exec claude "$@"` for seamless delegation.

Purpose: Deploy to any repo root for local Claude Code setup with alternative APIs (zero dependencies).

## Configuration Variables

### Required

- `CLAUDE_CODE_OAUTH_TOKEN`: API provider authentication token.
- `ANTHROPIC_BASE_URL`: API endpoint (e.g., `https://openrouter.ai/api` or `https://api.z.ai/api/anthropic`).

### Model Selection (Optional)
- `ANTHROPIC_DEFAULT_OPUS_MODEL`: Model for Opus-tier tasks.
- `ANTHROPIC_DEFAULT_SONNET_MODEL`: Model for Sonnet-tier tasks.
- `ANTHROPIC_DEFAULT_HAIKU_MODEL`: Model for Haiku-tier tasks.

### Token Limits (Optional)
- `CLAUDE_CODE_MAX_OUTPUT_TOKENS`: Max output tokens (default: 65536).
- `MAX_MCP_OUTPUT_TOKENS`: Max MCP tool tokens (default: 65536).
- `MAX_THINKING_TOKENS`: Max thinking tokens (default: 32768).

### Provider-Specific (Optional)
- `API_TIMEOUT_MS`: Request timeout for Z.ai (default: 3000000ms).
- `OPENROUTER_APP_URL`: App URL for OpenRouter/Z.ai leaderboards.
- `OPENROUTER_APP_NAME`: App name for OpenRouter/Z.ai leaderboards.

## Secret Masking

Variables matching these patterns are masked in output: `*api*`, `*key*`, `*secret*`, `*token*`, `*pass*`, `*pwd*`.

Explicit exclusions: `API_TIMEOUT_MS`, `CLAUDE_CODE_MAX_OUTPUT_TOKENS`, `MAX_MCP_OUTPUT_TOKENS`, `MAX_THINKING_TOKENS`.

Masked format: `prefix***suffix` (first/last 4 characters visible; values < 8 chars show `***`).