#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Error: Please provide the Godot version as an argument."
  exit 1
fi

CURRENT_GODOT_VERSION="$1"

GODOT_FOLDER="godot-${CURRENT_GODOT_VERSION}-stable"
DOWNLOAD_FILE="${GODOT_FOLDER}.tar.xz"

FULL_PATHNAME_DOWNLOAD_GODOT_EXTRACTED_HEADERS="https://github.com/godotengine/godot/releases/download/${CURRENT_GODOT_VERSION}-stable/${DOWNLOAD_FILE}"

curl -LO "$FULL_PATHNAME_DOWNLOAD_GODOT_EXTRACTED_HEADERS"
tar -xf "$DOWNLOAD_FILE"

if [ -d "godot" ]; then
  echo "Deleting existing 'godot' folder..."
  rm -rf "godot"
fi

mv "$GODOT_FOLDER" godot
rm $DOWNLOAD_FILE