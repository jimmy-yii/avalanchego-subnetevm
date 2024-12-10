#!/bin/bash

set -euo pipefail

AVALANCHEGO_DATA_DIR=${AVALANCHEGO_DATA_DIR:-$HOME/.avalanchego}

# Set default plugin dir if not set
if [ -z "${AVALANCHEGO_PLUGIN_DIR:-}" ]; then
    export AVALANCHEGO_PLUGIN_DIR="/plugins/"
fi

# Create data directory if it doesn't exist
mkdir -p $AVALANCHEGO_DATA_DIR/db/


# This speeds up the node startup time
if [ -z "$(ls -A $AVALANCHEGO_DATA_DIR/db/)" ]; then
    echo "Downloading latest testnet P-Chain data..."
    wget -q -O $AVALANCHEGO_DATA_DIR/fuji-latest.tar https://avalanchego-public-database.avax-test.network/p-chain/avalanchego/data-tar/latest.tar
    echo "Extracting latest testnet P-Chain data..."
    tar -xf "$AVALANCHEGO_DATA_DIR/fuji-latest.tar" -C $AVALANCHEGO_DATA_DIR/db/
fi

# Write BLS key if provided
if [ -n "${BLS_KEY_BASE64:-}" ]; then
    mkdir -p "$AVALANCHEGO_DATA_DIR/staking"
    echo "$BLS_KEY_BASE64" | base64 -d > "$AVALANCHEGO_DATA_DIR/staking/signer.key"
fi


# Function to convert ENV vars to flags
get_avalanchego_flags() {
    local flags=""
    # Loop through all environment variables
    while IFS='=' read -r name value; do
        # Check if variable starts with AVALANCHEGO_
        if [[ $name == AVALANCHEGO_* ]]; then
            # Convert AVALANCHEGO_DATA_DIR to --data-dir
            flag_name=$(echo "${name#AVALANCHEGO_}" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
            flags+="--$flag_name=$value "
        fi
    done < <(env)
    echo "$flags"
}

EXTRA_FLAGS=$(get_avalanchego_flags)
echo "Extra flags: $EXTRA_FLAGS"

# Launch avalanchego with dynamic flags
/usr/local/bin/avalanchego $EXTRA_FLAGS
