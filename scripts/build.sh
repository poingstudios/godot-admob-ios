#!/bin/bash
# scripts/build.sh

# Source common library
if [ -f "scripts/lib/common.sh" ]; then
    source scripts/lib/common.sh
else
    echo "Error: Cannot find scripts/lib/common.sh"
    exit 1
fi

# Default values
CLEAN_BUILD=false
TARGET="all"
GODOT_VERSION=""

# Help function
show_help() {
    echo "Usage: ./scripts/build.sh [options] [godot_version] [target]"
    echo ""
    echo "Options:"
    echo "  --clean       Perform a clean build (removes all artifacts first)"
    echo "  --help        Show this help message"
    echo ""
    echo "Arguments:"
    echo "  [godot_version]  Optional. The Godot version (e.g., 4.3.0). Auto-detected if omitted."
    echo "  [target]         Optional. What to build: 'internal', 'external', or 'all' (default: all)"
    echo ""
    echo "Examples:"
    echo "  ./scripts/build.sh                   # Incremental build using detected version"
    echo "  ./scripts/build.sh 4.3.0             # Incremental build for specific version"
    echo "  ./scripts/build.sh --clean           # Clean build using detected version"
    echo "  ./scripts/build.sh 4.3.0 internal    # Build only internal plugin logic"
    echo "  ./scripts/build.sh external          # Build only external SDK dependencies"
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --clean) CLEAN_BUILD=true ;;
        --help) show_help; exit 0 ;;
        *) 
            if [ -z "$GODOT_VERSION" ]; then
                # Check if it looks like a version number
                if [[ "$1" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
                    GODOT_VERSION="$1"
                elif [[ "$1" =~ ^(internal|external|all)$ ]]; then
                    TARGET="$1"
                else
                    log_error "Unknown argument: $1"
                    show_help; exit 1
                fi
            elif [[ "$1" =~ ^(internal|external|all)$ ]]; then
                TARGET="$1"
            else
                log_error "Unknown argument: $1"
                show_help; exit 1
            fi
            ;;
    esac
    shift
done

# If version is not provided, try to detect it
if [ -z "$GODOT_VERSION" ]; then
    if [ -f "godot/.version" ]; then
        GODOT_VERSION=$(cat godot/.version)
        log_info "Detected Godot $GODOT_VERSION from 'godot/.version'."
    elif [ -f "godot/version.py" ]; then
        MAJOR=$(grep "major =" godot/version.py | cut -d "=" -f 2 | tr -d " ")
        MINOR=$(grep "minor =" godot/version.py | cut -d "=" -f 2 | tr -d " ")
        PATCH=$(grep "patch =" godot/version.py | cut -d "=" -f 2 | tr -d " ")
        GODOT_VERSION="$MAJOR.$MINOR.$PATCH"
        log_info "Detected Godot $GODOT_VERSION from 'godot/version.py'."
        echo "$GODOT_VERSION" > godot/.version
    else
        log_error "Godot version is required (no existing installation found)."
        show_help; exit 1
    fi
fi

log_info "Starting Build Process (Version: $GODOT_VERSION, Target: $TARGET, Clean: $CLEAN_BUILD)"

if [ "$CLEAN_BUILD" = true ]; then
    log_info "Cleaning project..."
    rm -rf "$RELEASE_DIR"
    rm -rf "$SPM_BUILD_DIR"
    rm -f Package.resolved
    find . -name ".sconsign.dblite" -delete
    find . -name "*.os" -delete
    find . -name "*.o" -delete
    rm -rf godot-*
    log_success "Clean complete."
fi

ensure_dir "$RELEASE_DIR"
ensure_dir "./bin/static_libraries"
ensure_dir "./bin/xcframeworks"

if [ ! -d "$SPM_BUILD_DIR" ]; then
    ./scripts/lib/resolve_spm_deps.sh || exit 1
fi

# --- INTERNAL BUILD ---
if [ "$TARGET" == "all" ] || [ "$TARGET" == "internal" ]; then
    log_info "--- Building Internal Plugin ---"
    ./scripts/lib/download_godot.sh "$GODOT_VERSION" || exit 1
    ./scripts/lib/generate_headers.sh || exit 1

    STAGING_INTERNAL="./bin/release/internal"
    rm -rf "$STAGING_INTERNAL"
    mkdir -p "$STAGING_INTERNAL/poing-godot-admob/bin"

    for PLUGIN in "${ALL_PLUGINS[@]}"; do
        log_info "Processing $PLUGIN..."
        ./scripts/lib/generate_static_library.sh "$PLUGIN" release || exit 1
        ./scripts/lib/generate_static_library.sh "$PLUGIN" release_debug || exit 1

        XCF_DIR="./bin/xcframeworks/${PLUGIN}"
        DEBUG_XCF="$XCF_DIR/poing-godot-admob-${PLUGIN}.debug.xcframework"
        rm -rf "$DEBUG_XCF"
        mv "$XCF_DIR/poing-godot-admob-${PLUGIN}.release_debug.xcframework" "$DEBUG_XCF"

        cp -R "$XCF_DIR/poing-godot-admob-${PLUGIN}.release.xcframework" "$STAGING_INTERNAL/poing-godot-admob/bin/"
        cp -R "$XCF_DIR/poing-godot-admob-${PLUGIN}.debug.xcframework" "$STAGING_INTERNAL/poing-godot-admob/bin/"

        CONFIG_DIR=$(get_plugin_config_dir "$PLUGIN")
        cp "$CONFIG_DIR"/*.gdip "$STAGING_INTERNAL/"
    done

    ./scripts/lib/create_zip.sh "plugin" "internal" "$GODOT_VERSION" || exit 1
    rm -rf "$STAGING_INTERNAL"
fi

# --- EXTERNAL BUILD ---
if [ "$TARGET" == "all" ] || [ "$TARGET" == "external" ]; then
    log_info "--- Building External Dependencies ---"
    STAGING_EXTERNAL="./bin/release/external-dependencies"
    rm -rf "$STAGING_EXTERNAL"
    mkdir -p "$STAGING_EXTERNAL/poing-godot-admob/frameworks"

    for PLUGIN in "${ALL_PLUGINS[@]}"; do
        TEMP_DIR="./bin/temp_sdk_$PLUGIN"
        rm -rf "$TEMP_DIR"
        mkdir -p "$TEMP_DIR"
        ./scripts/lib/copy_sdk_frameworks.sh "$PLUGIN" "$TEMP_DIR/poing-godot-admob" || exit 1
        if [ -d "$TEMP_DIR/poing-godot-admob/frameworks" ]; then
            cp -R "$TEMP_DIR/poing-godot-admob/frameworks/"* "$STAGING_EXTERNAL/poing-godot-admob/frameworks/"
        fi
        rm -rf "$TEMP_DIR"
    done

    ./scripts/lib/create_zip.sh "sdk" "external-dependencies" || exit 1
    rm -rf "$STAGING_EXTERNAL"
fi

log_success "Build process completed successfully."
ls -lh "$RELEASE_DIR"
