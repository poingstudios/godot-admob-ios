#!/bin/bash
set -e

PLUGIN_NAME="$1"
GODOT_VERSION="$2"

if [ -n "$GODOT_VERSION" ]; then
    GODOT_STR="-v$GODOT_VERSION"
else
    GODOT_STR=""
fi

# We are in project root, or we should be.
# release_static_library.sh puts files in ./bin/release/
cd ./bin/release

# The directory structure for the plugin is now in its own folder
# e.g., ./ads/ contains poing-godot-admob/ and poing-godot-admob-ads.gdip

file_name="poing-godot-admob-ios-$PLUGIN_NAME$GODOT_STR.zip"

if [ -e "$file_name" ]; then
  echo "Deleting existing .zip: $file_name"
  rm "$file_name"
fi

echo "Creating ZIP for $PLUGIN_NAME..."
# We want to zip the contents of the plugin directory so that when extracted,
# the user gets the .gdip and the poing-godot-admob/ folder.
cd "$PLUGIN_NAME"
zip -r "../$file_name" ./
cd ..

echo "Created: ./bin/release/$file_name"