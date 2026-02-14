#!/bin/bash
set -e

PLUGIN="$1"
TARGET="$2"

# Compile static libraries

# ARM64 Device
scons target=$TARGET arch=arm64 plugin=$PLUGIN

# ARM64 Simulator (Apple Silicon Macs)
scons target=$TARGET arch=arm64 simulator=yes plugin=$PLUGIN

# x86_64 Simulator (Intel Macs / Rosetta)
scons target=$TARGET arch=x86_64 simulator=yes plugin=$PLUGIN

# Strip local symbols to reduce size
echo "Stripping symbols from static libraries..."
strip -S "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-ios.$TARGET.a"
strip -S "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-simulator.$TARGET.a"
strip -S "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.x86_64-simulator.$TARGET.a"

# Create fat simulator library (arm64-sim + x86_64-sim)
lipo -create \
    "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-simulator.$TARGET.a" \
    "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.x86_64-simulator.$TARGET.a" \
    -output "./bin/static_libraries/$PLUGIN/poing-godot-admob-$PLUGIN.simulator.$TARGET.a"

# Create xcframework (device + simulator)
XCF_OUT="./bin/xcframeworks/$PLUGIN/poing-godot-admob-$PLUGIN.$TARGET.xcframework"
mkdir -p "./bin/xcframeworks/$PLUGIN"
rm -rf "$XCF_OUT"

xcodebuild -create-xcframework \
    -library "./bin/static_libraries/$PLUGIN/libpoing-godot-admob-$PLUGIN.arm64-ios.$TARGET.a" \
    -library "./bin/static_libraries/$PLUGIN/poing-godot-admob-$PLUGIN.simulator.$TARGET.a" \
    -output "$XCF_OUT"

echo "Created xcframework: ./bin/xcframeworks/$PLUGIN/poing-godot-admob-$PLUGIN.$TARGET.xcframework"