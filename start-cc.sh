#!/bin/zsh

# Load environment variables from .env.cc
SCRIPT_DIR="${0:A:h}"
ENV_FILE="${SCRIPT_DIR}/.env.cc"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: .env.cc not found at $ENV_FILE"
    exit 1
fi

# Read and export each KEY=VALUE line
while IFS= read -r line || [[ -n "$line" ]]; do
    # Skip empty lines and comments
    [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
    # Export the variable
    export "$line"
done < "$ENV_FILE"

# Execute claude with skip permissions flag
exec claude --dangerously-skip-permissions "$@"
