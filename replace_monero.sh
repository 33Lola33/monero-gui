#!/bin/bash

# Script to replace Monero with MyNewCoin in the Monero GUI codebase

# Change to the directory where your monero-gui is located
cd ~/monero-gui || exit

# List of directories where Monero-specific code resides
MONERO_DIRS=(
    "monero/src/wallet/api"
    "monero/src/wallet"
    "src/libwalletqt"
    "src"
)

# Function to replace text in files
replace_text() {
    local dir="$1"
    find "$dir" -type f \( -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \) -exec \
        sed -i 's/Monero/MyNewCoin/g' {} +
}

# Loop through each directory and replace text
for dir in "${MONERO_DIRS[@]}"; do
    echo "Processing directory: $dir"
    replace_text "$dir"
done

echo "Text replacement completed. Please review changes manually and test the build."
