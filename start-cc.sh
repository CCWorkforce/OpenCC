#!/bin/zsh

# Load environment variables from .env.cc
SCRIPT_DIR="${0:A:h}"
ENV_FILE="${SCRIPT_DIR}/.env.cc"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: .env.cc not found at $ENV_FILE"
    exit 1
fi

is_secret() {
    local key_lower="${1:l}"
    if [[ $key_lower == *api* || $key_lower == *key* || $key_lower == *secret* || $key_lower == *token* || $key_lower == *pass* || $key_lower == *pwd* ]]; then
        return 0
    fi
    return 1
}

mask_value() {
    local val="$1"
    local len="${#val}"
    if [[ $len -le 8 ]]; then
        echo "***"
    else
        echo "${val:0:4}***${val:(-4)}"
    fi
}

# Read and export each KEY=VALUE line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    key="${line%%=*}"
    value="${line#*=}"
    # Strip outer quotes if present
    if [[ "$value" == \"*\" ]]; then
        value="${value#\"}"
        value="${value%\"}"
    elif [[ "$value" == \'*\' ]]; then
        value="${value#\'}"
        value="${value%\'}"
    fi
    if is_secret "$key"; then
        masked_value=$(mask_value "$value")
        echo "$key=$masked_value"
    else
        echo "$key=$value"
    fi
    export "$key=$value"
done < "$ENV_FILE"

# OpenRouter/Z.ai app attribution headers (if configured)
if [[ "$ANTHROPIC_BASE_URL" == *://*.openrouter.ai/* ]] || [[ "$ANTHROPIC_BASE_URL" == *://*.openrouter.ai ]] || [[ "$ANTHROPIC_BASE_URL" == *://*.z.ai/* ]]; then
    if [[ -n "$OPENROUTER_APP_URL" ]] && [[ -n "$OPENROUTER_APP_NAME" ]]; then
        ANTHROPIC_CUSTOM_HEADERS="HTTP-Referer:${OPENROUTER_APP_URL},X-Title:${OPENROUTER_APP_NAME}"
        masked_url="${OPENROUTER_APP_URL:0:20}..."
        masked_name="${OPENROUTER_APP_NAME:0:20}..."
        echo "ANTHROPIC_CUSTOM_HEADERS=HTTP-Referer:[$masked_url],X-Title:[$masked_name]"
        export ANTHROPIC_CUSTOM_HEADERS
    fi
fi

# Check if claude command exists
if ! command -v claude &>/dev/null; then
    echo "Error: 'claude' command not found."
    echo "Install from https://claude.ai/code"
    exit 1
fi

# Validate required environment variable
if [[ -z "$ANTHROPIC_AUTH_TOKEN" ]]; then
    echo "Error: ANTHROPIC_AUTH_TOKEN not set in $ENV_FILE"
    exit 1
fi

# Execute claude with any passed arguments
exec claude "$@"
