#!/bin/bash
# scripts/lib/generate_static_library.sh

if [ -f "scripts/lib/common.sh" ]; then
    source scripts/lib/common.sh
elif [ -f "lib/common.sh" ]; then
    source lib/common.sh
else
    echo "Error: Cannot find common.sh"
    exit 1
fi

PLUGIN="$1"
TARGET="$2"

log_info "Compiling $PLUGIN ($TARGET)..."

# Using timeout script to prevent hanging if configured
TIMEOUT_CMD=""
if [ -f "scripts/lib/timeout" ]; then
    TIMEOUT_CMD="scripts/lib/timeout"
fi

# Compile static libraries
# ARM64 Device
$TIMEOUT_CMD scons target=$TARGET arch=arm64 plugin=$PLUGIN || { log_error "Failed to build arm64 device"; exit 1; }

# ARM64 Simulator (Apple Silicon Macs)
$TIMEOUT_CMD scons target=$TARGET arch=arm64 simulator=yes plugin=$PLUGIN || { log_error "Failed to build arm64 simulator"; exit 1; }

# x86_64 Simulator (Intel Macs / Rosetta)
$TIMEOUT_CMD scons target=$TARGET arch=x86_64 simulator=yes plugin=$PLUGIN || { log_error "Failed to build x86_64 simulator"; exit 1; }

# Strip local symbols to reduce size
log_info "Stripping symbols..."
strip -S "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-ios.$TARGET.a"
strip -S "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-simulator.$TARGET.a"
strip -S "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.x86_64-simulator.$TARGET.a"

# Create fat simulator library (arm64-sim + x86_64-sim)
log_info "Creating Fat Simulator Library..."
lipo -create \
    "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-simulator.$TARGET.a" \
    "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.x86_64-simulator.$TARGET.a" \
    -output "./bin/static_libraries/$PLUGIN/poing-godot-admob-$PLUGIN.simulator.$TARGET.a" || { log_error "Failed to create fat lib"; exit 1; }

# Create xcframework (device + simulator)
XCF_OUT="./bin/xcframeworks/$PLUGIN/poing-godot-admob-$PLUGIN.$TARGET.xcframework"
mkdir -p "./bin/xcframeworks/$PLUGIN"
rm -rf "$XCF_OUT"

log_info "Creating XCFramework..."
xcodebuild -create-xcframework \
    -library "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-ios.$TARGET.a" \
    -library "./bin/static_libraries/$PLUGIN/poing-godot-admob-$PLUGIN.simulator.$TARGET.a" \
    -output "$XCF_OUT" || { log_error "Failed to create xcframework"; exit 1; }

log_success "Created xcframework: $XCF_OUT"