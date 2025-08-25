#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Error: Please provide the Godot version as an argument."
  exit 1
fi

CURRENT_GODOT_VERSION="$1"

GODOT_FOLDER="godot-${CURRENT_GODOT_VERSION}-stable"
DOWNLOAD_FILE="${GODOT_FOLDER}.tar.xz"
FULL_PATHNAME_DOWNLOAD_GODOT_EXTRACTED_HEADERS="https://github.com/godotengine/godot/releases/download/${CURRENT_GODOT_VERSION}-stable/${DOWNLOAD_FILE}"
echo "Downloading from: $FULL_PATHNAME_DOWNLOAD_GODOT_EXTRACTED_HEADERS"

if ! curl -LO "$FULL_PATHNAME_DOWNLOAD_GODOT_EXTRACTED_HEADERS"; then
  echo "Error: Failed to download $DOWNLOAD_FILE"
  exit 1
fi

if [ ! -f "$DOWNLOAD_FILE" ]; then
  echo "Error: Download file $DOWNLOAD_FILE not found"
  exit 1
fi

if ! tar -xf "$DOWNLOAD_FILE"; then
  echo "Error: Failed to extract $DOWNLOAD_FILE"
  rm -f "$DOWNLOAD_FILE"
  exit 1
fi

rm -f "$DOWNLOAD_FILE"

if [ ! -d "$GODOT_FOLDER" ]; then
  echo "Error: Extracted folder $GODOT_FOLDER not found"
  exit 1
fi

if [ -d "godot" ]; then
  echo "Deleting existing 'godot' folder..."
  rm -rf "godot"
fi

if ! mv "$GODOT_FOLDER" "godot"; then
  echo "Error: Failed to rename $GODOT_FOLDER to godot"
  exit 1
fi

echo "Godot $CURRENT_GODOT_VERSION downloaded successfully in 'godot' folder"