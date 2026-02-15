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
done

# ---------------------------------------------------------
# Final Packaging: Create the two main distribution ZIPs
# ---------------------------------------------------------
if [ -n "$GODOT_VERSION" ]; then
    GODOT_STR="-v$GODOT_VERSION"
else
    GODOT_STR=""
fi

INTERNAL_ZIP="poing-godot-admob-ios-internal$GODOT_STR.zip"
SDK_ZIP="poing-godot-admob-ios-external-dependencies.zip"

echo "Creating distribution ZIPs..."

# 1. Create Internal ZIP (binaries + .gdip)
STAGING_INTERNAL="./bin/staging_internal"
rm -rf "$STAGING_INTERNAL"
mkdir -p "$STAGING_INTERNAL/poing-godot-admob/bin"

for PLUGIN in "${PLUGINS[@]}"; do
    cp "$dest_folder/$PLUGIN"/*.gdip "$STAGING_INTERNAL/"
    cp -R "$dest_folder/$PLUGIN/poing-godot-admob/bin/"* "$STAGING_INTERNAL/poing-godot-admob/bin/"
done

cd "$STAGING_INTERNAL"
zip -qr "../../bin/release/$INTERNAL_ZIP" .
cd ../..

# 2. Create SDK ZIP (frameworks)
STAGING_SDK="./bin/staging_sdk"
rm -rf "$STAGING_SDK"
mkdir -p "$STAGING_SDK/poing-godot-admob/frameworks"

for PLUGIN in "${PLUGINS[@]}"; do
    if [ -d "$dest_folder/$PLUGIN/poing-godot-admob/frameworks" ]; then
        cp -R "$dest_folder/$PLUGIN/poing-godot-admob/frameworks/"* "$STAGING_SDK/poing-godot-admob/frameworks/"
    fi
done

cd "$STAGING_SDK"
zip -qr "../../bin/release/$SDK_ZIP" .
cd ../..

# Cleanup
rm -rf "$STAGING_INTERNAL" "$STAGING_SDK"
for PLUGIN in "${PLUGINS[@]}"; do
    rm -rf "$dest_folder/$PLUGIN"
done

echo "Build and packaging complete."
echo "Final artifacts in ./bin/release/:"
echo "  1. $INTERNAL_ZIP (Internal libs + .gdips)"
echo "  2. $SDK_ZIP (External dependency frameworks)"