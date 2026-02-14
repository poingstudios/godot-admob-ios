#!/bin/bash
set -euo pipefail

# Plugin argument is optional, mainly for logging or specific logic if needed in future
PLUGIN="${1:-all}"

echo "Resolving SPM dependencies..."
swift package resolve

# Export SPM build directory (absolute path)
# We assume .build is in the project root
SPM_BUILD_DIR="$(pwd)/.build"
export SPM_BUILD_DIR

echo "SPM directories resolved to: $SPM_BUILD_DIR"
