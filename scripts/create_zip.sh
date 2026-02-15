#!/bin/bash
# create_zip.sh
set -e

TYPE="$1" # "plugin" or "sdk"
NAME="$2" # ads, meta, vungle, etc.
VERSION="$3" # Godot version (optional for SDK)

if [ "$TYPE" != "plugin" ] && [ "$TYPE" != "sdk" ]; then
    echo "Usage: $0 <plugin|sdk> <name> [version]"
    exit 1
fi

cd ./bin/release

if [ "$TYPE" == "plugin" ]; then
    # Plugin ZIP: Contains .gdip and poing-godot-admob/bin/
    # Godot version is relevant here
    if [ -n "$VERSION" ]; then
        VER_STR="-v$VERSION"
    else
        VER_STR=""
    fi
    FILE_NAME="poing-godot-admob-ios-$NAME$VER_STR.zip"
    
    echo "Creating Plugin ZIP: $FILE_NAME"
    cd "$NAME"
    # Zip only gdip and the bin folder (exclude frameworks)
    zip -r "../$FILE_NAME" ./*.gdip poing-godot-admob/bin/
    cd ..
else
    # SDK ZIP: Contains poing-godot-admob/frameworks/
    # Godot version is NOT relevant for shared SDKs
    FILE_NAME="poing-godot-admob-ios-sdk-$NAME.zip"
    
    echo "Creating SDK ZIP: $FILE_NAME"
    cd "$NAME"
    # Zip only the frameworks folder
    zip -r "../$FILE_NAME" poing-godot-admob/frameworks/
    cd ..
fi

echo "Created artifact: ./bin/release/$FILE_NAME"