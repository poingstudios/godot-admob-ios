#!/bin/bash
# scripts/lib/common.sh

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper for logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_error() {
    if [ $? -ne 0 ]; then
        log_error "$1"
        exit 1
    fi
}

# Source configuration
source ./scripts/lib/config.sh

# Configuration constants
RELEASE_DIR="./bin/release"
SPM_BUILD_DIR=".build"
SPM_ARTIFACTS="${SPM_BUILD_DIR}/artifacts"

ensure_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

# CPU Cores for parallel build
if [[ "$OSTYPE" == "darwin"* ]]; then
    NUM_CORES=$(sysctl -n hw.ncpu)
else
    NUM_CORES=$(nproc)
fi

# Shared SCons cache arguments
export SCONS_CACHE_ARGS=""
if [ -n "$SCONS_CACHE" ] && [ -d "$SCONS_CACHE" ]; then
    export SCONS_CACHE_ARGS="cache_path=$SCONS_CACHE"
    # Unset the environment variable so Godot's Python script 
    # doesn't see it and print the deprecation warning
    unset SCONS_CACHE
fi
