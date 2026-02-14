#!/bin/bash
set -e

# Resolve SDK dependencies via SPM (replaces pod install)
echo "Resolving SPM dependencies..."
swift package resolve

PLUGINS=("ads" "meta" "vungle")

dest_folder="./bin/release"

# Clear release folder
rm -rf "$dest_folder"

# Create folders
mkdir -p "$dest_folder"
mkdir -p "./bin/static_libraries"
mkdir -p "./bin/xcframeworks"

for PLUGIN in "${PLUGINS[@]}"
do
    # Compile Plugin (produces xcframeworks)
    ./scripts/generate_static_library.sh $PLUGIN release
    ./scripts/generate_static_library.sh $PLUGIN release_debug

    # Rename release_debug → debug for Godot convention
    mv "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.release_debug.xcframework" \
       "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.debug.xcframework"

    # Set destination path based on PLUGIN value
    DEST_PATH="$dest_folder/${PLUGIN}/poing-godot-admob/"
    
    # Move Plugin xcframeworks
    mkdir -p "$DEST_PATH/bin/"
    cp -R "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.release.xcframework" "$DEST_PATH/bin/"
    cp -R "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.debug.xcframework" "$DEST_PATH/bin/"

    # Copy third-party SDK xcframeworks
    ./scripts/copy_sdk_frameworks.sh "$PLUGIN" "$DEST_PATH"

    CONFIG_DIR="./PoingGodotAdMob/src/mediation/${PLUGIN}/config"
    if [ "$PLUGIN" = "ads" ]; then
        CONFIG_DIR="./PoingGodotAdMob/src/${PLUGIN}/config"
    fi

    cp "$CONFIG_DIR"/*.gdip "$dest_folder/${PLUGIN}"
done