#!/bin/bash
# release_static_library.sh
set -e

# Resolve SDK dependencies via SPM
echo "Resolving SPM dependencies..."
swift package resolve

GODOT_VERSION="$1"
PLUGINS=("ads" "meta" "vungle")

dest_folder="./bin/release"

# Clear release folder
rm -rf "$dest_folder"
mkdir -p "$dest_folder"
mkdir -p "./bin/static_libraries"
mkdir -p "./bin/xcframeworks"

for PLUGIN in "${PLUGINS[@]}"
do
    echo "----------------------------------------"
    echo "Processing plugin: $PLUGIN"
    echo "----------------------------------------"
    
    # 1. Compile Plugin (produces xcframeworks in bin/xcframeworks/)
    ./scripts/generate_static_library.sh $PLUGIN release
    ./scripts/generate_static_library.sh $PLUGIN release_debug

    # 2. Setup folder structure
    DEBUG_XCF="./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.debug.xcframework"
    rm -rf "$DEBUG_XCF"
    mv "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.release_debug.xcframework" "$DEBUG_XCF"

    PLUGIN_ROOT="$dest_folder/${PLUGIN}/poing-godot-admob/"
    mkdir -p "$PLUGIN_ROOT/bin/"
    
    # 3. Copy plugin-specific xcframeworks (The tiny binaries)
    cp -R "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.release.xcframework" "$PLUGIN_ROOT/bin/"
    cp -R "./bin/xcframeworks/${PLUGIN}/poing-godot-admob-${PLUGIN}.debug.xcframework" "$PLUGIN_ROOT/bin/"

    # 4. Copy shared SDK xcframeworks (The large binaries)
    ./scripts/copy_sdk_frameworks.sh "$PLUGIN" "$dest_folder/${PLUGIN}/poing-godot-admob"

    # 5. Copy Godot config
    CONFIG_DIR="./PoingGodotAdMob/src/mediation/${PLUGIN}/config"
    if [ "$PLUGIN" = "ads" ]; then
        CONFIG_DIR="./PoingGodotAdMob/src/${PLUGIN}/config"
    fi
    cp "$CONFIG_DIR"/*.gdip "$dest_folder/${PLUGIN}"

    # 6. Create DECOUPLED ZIPs
    # A. Tiny Plugin ZIP (< 1MB)
    ./scripts/create_zip.sh plugin "$PLUGIN" "$GODOT_VERSION"
    
    # B. Large SDK ZIP (Only if needed - usually done once per SDK release)
    ./scripts/create_zip.sh sdk "$PLUGIN"
done

# Optional: Create a "Full Bundle" ZIP for users who want everything in one go (Legacy support)
if [ -n "$GODOT_VERSION" ]; then
    GODOT_STR="-v$GODOT_VERSION"
else
    GODOT_STR=""
fi

FULL_ZIP_NAME="poing-godot-admob-ios-full-bundle$GODOT_STR.zip"
echo "Creating legacy full bundle ZIP: $FULL_ZIP_NAME"
cd "$dest_folder"
# We need to be careful zip doesn't include the .zips we just created
echo "ads/ meta/ vungle/" | xargs zip -r "$FULL_ZIP_NAME"
cd ../..

echo "Build and packaging complete."
echo "Artifacts are in ./bin/release/"