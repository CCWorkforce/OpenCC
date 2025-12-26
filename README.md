# OpenCC Usage Guide

## 1. Set Up Environment Configuration

1. Copy the example file to create your config:

   ```bash
   cp .env.cc.example .env.cc        # For OpenRouter
   # or
   cp .env.cc.zai.example .env.cc    # For Z.ai
   ```

2. Edit `.env.cc` (using your preferred editor, e.g., `nano .env.cc` or VS Code).

### OpenRouter Configuration

- Set `CLAUDE_CODE_OAUTH_TOKEN=your_openrouter_token_here` (get a free token from [OpenRouter](https://openrouter.ai)).
- `ANTHROPIC_BASE_URL=https://openrouter.ai/api` is pre-configured.

### Z.ai Configuration

- Set `CLAUDE_CODE_OAUTH_TOKEN=your_zai_token_here` (get access from [Z.ai](https://z.ai)).
   - `ANTHROPIC_BASE_URL=https://api.z.ai/api/anthropic` is pre-configured.
   - Optionally set `API_TIMEOUT_MS=3000000` for long-running requests.

### Optional Configuration

| Variable | Purpose | Default |
|----------|---------|---------|
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Model for Opus tier tasks | Provider-dependent |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Model for Sonnet tier tasks | Provider-dependent |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Model for Haiku tier tasks | Provider-dependent |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Max tokens for Claude output | 65536 |
| `MAX_MCP_OUTPUT_TOKENS` | Max tokens for MCP tools | 65536 |
| `MAX_THINKING_TOKENS` | Max tokens for thinking mode | 32768 |
| `OPENROUTER_APP_URL` | App URL for leaderboards | - |
| `OPENROUTER_APP_NAME` | App name for leaderboards | - |

3. **Secure the file**: Add `.env.cc` to `.gitignore` to avoid committing secrets:

   ```bash
   echo ".env.cc" >> .gitignore
   git add .gitignore
   git commit -m "Ignore .env.cc secrets"
   ```

## 2. Start OpenCC (Local Testing)

1. Ensure the script is executable:

   ```bash
   chmod +x start-cc.sh
   ```

2. Run the script:

   ```bash
   ./start-cc.sh                           # Basic start (no args)
   ./start-cc.sh --dangerously-skip-permissions   # With custom args
   ./start-cc.sh --help                    # Show usage information
   ./start-cc.sh --debug                   # Enable debug tracing
   ./start-cc.sh --debug --help            # Debug Claude directly
   ```

### Command-Line Flags

| Flag | Description |
|------|-------------|
| `--help`, `-h` | Show usage information and exit |
| `--debug` | Enable zsh tracing (`set -x`) for debugging |

### Secret Masking

OpenCC automatically masks sensitive values in output. Variables containing `api`, `key`, `secret`, `token`, `pass`, or `pwd` in their name are displayed as `prefix***suffix` (first/last 4 characters visible). Non-sensitive variables are shown fully.

This loads `.env.cc` vars and launches `claude [your-args]` (or just the base command if no args provided).

## 3. Deploy to Project Root (Other Repositories)

To use OpenCC in **any Git repository** (e.g., your other projects):

1. Copy these files to your project's root directory:

   ```bash
   cp start-cc.sh /path/to/your/project/
   cp .env.cc /path/to/your/project/
   ```

2. **Secure `.env.cc`** (add to `.gitignore` if not already):

   ```bash
   cd /path/to/your/project/
   echo \".env.cc\" >> .gitignore
   git add .gitignore
   git commit -m \"Ignore OpenCC .env.cc secrets\"
   ```

3. Make the script executable and run:

   ```bash
   chmod +x start-cc.sh
   ./start-cc.sh                    # Basic start (no args)
   # or
   ./start-cc.sh --dangerously-skip-permissions  # With custom args
   ```

This loads `.env.cc` vars **locally** in your project and launches `claude` with passed args.

## Troubleshooting

| Error | Solution |
|-------|----------|
| `.env.cc not found` | Run `cp .env.cc.example .env.cc` or `cp .env.cc.zai.example .env.cc` |
| `CLAUDE_CODE_OAUTH_TOKEN is not defined` | Add `CLAUDE_CODE_OAUTH_TOKEN=your_token` to `.env.cc` |
| `CLAUDE_CODE_OAUTH_TOKEN is empty` | Ensure the token value is not empty in `.env.cc` |
| `'claude' command not found` | Install Claude Code from https://claude.ai/code |
| Auth errors | Verify your API provider token has credits/usage available |
| Model issues | Check your provider's dashboard for model availability |
| Variable name warnings | Ensure variable names contain only letters, numbers, and underscores |

### Debug Mode

Use `--debug` to enable verbose zsh tracing. This helps diagnose issues with environment variable parsing or script execution:

```bash
./start-cc.sh --debug
```
