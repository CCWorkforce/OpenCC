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
    if is_secret "$key"; then
        masked_value=$(mask_value "$value")
        echo "$key=$masked_value"
    else
        echo "$key=$value"
    fi
    export "$line"
done < "$ENV_FILE"

# Execute claude with any passed arguments
exec claude "$@"
