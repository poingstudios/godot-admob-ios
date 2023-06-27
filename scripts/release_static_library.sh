#!/bin/bash

PLUGIN="ads"

# Compile Plugin
./scripts/generate_static_library.sh $PLUGIN release
./scripts/generate_static_library.sh $PLUGIN release_debug
mv ./bin/${PLUGIN}.release_debug.a ./bin/${PLUGIN}.debug.a

# Move to release folder
rm -rf ./bin/release
mkdir ./bin/release
rm -rf ./bin/release/${PLUGIN}/admob/bin
mkdir -p ./bin/release/${PLUGIN}/admob/bin

# Move Plugin
mv ./bin/${PLUGIN}.{release,debug}.a ./bin/release/${PLUGIN}/admob/bin
cp ./PoingGodotAdMob/src/${PLUGIN}/config/poing-godot-admob-${PLUGIN}.gdip ./bin/release/${PLUGIN}