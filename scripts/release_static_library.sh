#!/bin/bash

PLUGINS=("ads" "adcolony" "meta" "vungle")

# Clear release folder
rm -rf ./bin/release

for PLUGIN in "${PLUGINS[@]}"
do
    # Compile Plugin
    ./scripts/generate_static_library.sh $PLUGIN release
    ./scripts/generate_static_library.sh $PLUGIN release_debug
    mv ./bin/poing-godot-admob-${PLUGIN}.release_debug.a ./bin/poing-godot-admob-${PLUGIN}.debug.a

    # Move Plugin
    mkdir -p ./bin/release/poing-godot-admob/bin
    mv ./bin/poing-godot-admob-${PLUGIN}.{release,debug}.a ./bin/release/poing-godot-admob/bin

    CONFIG_DIR="./PoingGodotAdMob/src/mediation/${PLUGIN}/config"
    if [ "$PLUGIN" = "ads" ]; then
        mkdir -p ./bin/release/poing-godot-admob/scripts
        CONFIG_DIR="./PoingGodotAdMob/src/${PLUGIN}/config"
    fi
    
    cp -r "$CONFIG_DIR"/* ./bin/release/poing-godot-admob/
done
