#!/bin/bash
set -e

# Resolve SDK dependencies via SPM (replaces pod install)
echo "Resolving SPM dependencies..."
swift package resolve

GODOT_VERSION="$1"
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
    echo "Building plugin: $PLUGIN"
    # Compile Plugin (produces xcframeworks)
    ./scripts/generate_static_library.sh $PLUGIN release
    ./scripts/generate_static_library.sh $PLUGIN release_debug

    # Rename release_debug → debug for Godot convention
    DEBUG_XCF="./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.debug.xcframework"
    rm -rf "$DEBUG_XCF"
    mv "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.release_debug.xcframework" "$DEBUG_XCF"

    # Set destination path based on PLUGIN value
    PLUGIN_DEST="$dest_folder/${PLUGIN}/poing-godot-admob/"
    
    # Move Plugin xcframeworks
    mkdir -p "$PLUGIN_DEST/bin/"
    cp -R "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.release.xcframework" "$PLUGIN_DEST/bin/"
    cp -R "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.debug.xcframework" "$PLUGIN_DEST/bin/"

    # Copy third-party SDK xcframeworks (with thinning/stripping)
    ./scripts/copy_sdk_frameworks.sh "$PLUGIN" "$dest_folder/${PLUGIN}/poing-godot-admob"

    CONFIG_DIR="./PoingGodotAdMob/src/mediation/${PLUGIN}/config"
    if [ "$PLUGIN" = "ads" ]; then
        CONFIG_DIR="./PoingGodotAdMob/src/${PLUGIN}/config"
    fi

    cp "$CONFIG_DIR"/*.gdip "$dest_folder/${PLUGIN}"

    # Create individual ZIP for this plugin
    ./scripts/create_zip.sh "$PLUGIN" "$GODOT_VERSION"
done

# Create a final "full" ZIP containing all plugins
if [ -n "$GODOT_VERSION" ]; then
    GODOT_STR="-v$GODOT_VERSION"
else
    GODOT_STR=""
fi

FULL_ZIP_NAME="poing-godot-admob-ios$GODOT_STR.zip"
echo "Creating full bundle ZIP: $FULL_ZIP_NAME"
cd "$dest_folder"
# Zip only the directories (ads, meta, vungle), excluding existing .zip files
zip -r "$FULL_ZIP_NAME" ads/ meta/ vungle/
cd ../..

echo "Build and packaging complete."