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
   - Optionally customize model defaults (e.g., `ANTHROPIC_DEFAULT_OPUS_MODEL`).

3. **Secure the file**: Add `.env.cc` to `.gitignore` to avoid committing secrets:

   ```bash
   echo ".env.cc" >> .gitignore
   git add .gitignore
   git commit -m "Ignore .env.cc secrets"
   ```

## 2. Start OpenCC

1. Ensure the script is executable:

   ```bash
   chmod +x start-cc.sh
   ```

2. Run the script (optionally with args):

   ```bash
   ./start-cc.sh                    # Basic start (no args)

   ./start-cc.sh develop_a_feature  # With custom args (e.g., develop_a_feature)
   ```

This loads `.env.cc` vars and launches `claude --dangerously-skip-permissions [your-args]` (or just the base command if no args provided).

## Troubleshooting

- **Error: .env.cc not found**: Ensure Step 1 completed.
- **Auth errors**: Verify your OpenRouter token has credits.
- **Model issues**: Check OpenRouter dashboard for model availability.
