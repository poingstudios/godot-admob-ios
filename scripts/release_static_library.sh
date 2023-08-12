#!/bin/bash
function run_pod_install() {
    local directory="./PoingGodotAdMob"
    
    if [ -d "$directory" ]; then
        pushd "$directory" > /dev/null
        pod install --repo-update
        popd > /dev/null
    else
        echo "Directory '$directory' not found."
        exit 1
    fi
}

run_pod_install

PLUGINS=("ads" "adcolony" "meta" "vungle")

# Clear release folder
rm -rf ./bin/release

for PLUGIN in "${PLUGINS[@]}"
do
    # Compile Plugin
    ./scripts/generate_static_library.sh $PLUGIN release
    ./scripts/generate_static_library.sh $PLUGIN release_debug
    mv ./bin/poing-godot-admob-${PLUGIN}.release_debug.a ./bin/poing-godot-admob-${PLUGIN}.debug.a

    # Set destination path based on PLUGIN value
    DEST_PATH="./bin/release/${PLUGIN}/poing-godot-admob/"
    
    # Move Plugin
    mkdir -p "$DEST_PATH/bin/"
    mv ./bin/poing-godot-admob-${PLUGIN}.{release,debug}.a "$DEST_PATH/bin"

    CONFIG_DIR="./PoingGodotAdMob/src/mediation/${PLUGIN}/config"
    if [ "$PLUGIN" = "ads" ]; then
        mkdir -p "$DEST_PATH/scripts"
        CONFIG_DIR="./PoingGodotAdMob/src/${PLUGIN}/config"
    fi

    cp "$CONFIG_DIR"/*.gdip ./bin/release/${PLUGIN}

    for item in "$CONFIG_DIR"/*
    do
        if [ ! -f "$item" ] || [ "${item##*.}" != "gdip" ]; then
            cp -r "$item" "$DEST_PATH/"
        fi
    done
done
