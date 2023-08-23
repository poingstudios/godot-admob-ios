#!/bin/bash
if [ $# -eq 0 ]; then
    godot_version=""
else
    godot_version="-v$1"
fi

cd ./bin/release

file_name="poing-godot-admob-ios$godot_version.zip"


if [ -e $file_name ]; then
  echo "Deleting existing .zip folder..."
  rm $file_name
fi

zip -r $file_name ./