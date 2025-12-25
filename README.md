# OpenCC Usage Guide

## 1. Set Up Environment Configuration

1. Copy the example file to create your config:\

   ```bash
   cp .env.cc.example .env.cc
   ```

2. Edit `.env.cc` (using your preferred editor, e.g., `nano .env.cc` or VS Code):
   - Set `ANTHROPIC_AUTH_TOKEN=your_openrouter_token_here` (get a free token from [OpenRouter](https://openrouter.ai)).
   - Leave `ANTHROPIC_API_KEY=""` **exactly as-is** (must be empty for OpenRouter).
   - `ANTHROPIC_BASE_URL=https://openrouter.ai/api` is pre-configured.
   - Optionally customize model defaults and token limits (e.g., `ANTHROPIC_DEFAULT_OPUS_MODEL`, `CLAUDE_CODE_MAX_OUTPUT_TOKENS=65536`, `MAX_MCP_OUTPUT_TOKENS=65536`, `MAX_THINKING_TOKENS=32768`).

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

2. Run the script (optionally with args):

   ```bash
   ./start-cc.sh                    # Basic start (no args)

   ./start-cc.sh --dangerously-skip-permissions  # With custom args (e.g., --dangerously-skip-permissions)
   ```

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

- **Error: .env.cc not found**: Ensure Step 1 completed.
- **Auth errors**: Verify your OpenRouter token has credits.
- **Model issues**: Check OpenRouter dashboard for model availability.
