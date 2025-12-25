# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Structure

OpenCC is a shell script wrapper for the `claude` CLI tool. It loads environment configuration from `.env.cc` to enable Claude Code usage with OpenRouter (or Z.ai) APIs.

Key files:
- `start-cc.sh`: Core script that sources `.env.cc`, masks secrets in output, and executes `claude "$@"`.
- `.env.cc.example` / `.env.cc.zai.example`: API provider configuration templates.
- `README.md`: Setup, usage, and deployment instructions.

## Common Commands

### Initial Setup
```bash
chmod +x start-cc.sh
cp .env.cc.example .env.cc  # Edit ANTHROPIC_AUTH_TOKEN with your API key
echo ".env.cc" >> .gitignore
```

### Execution
```bash
./start-cc.sh                       # Launch Claude Code
./start-cc.sh --dangerously-skip-permissions  # With arguments
```

No build system, linter, or tests; verify changes by running the script.

## Architecture

Single-script design:
1. Checks for `.env.cc`.
2. Parses lines, exports vars, echoes non-secrets fully and masks secrets (shows first/last 4 chars).
3. Uses `exec claude "$@"` for seamless delegation.

Purpose: Deploy to any repo root for local Claude Code setup with alternative APIs (zero dependencies).