#!/bin/bash
if [ $# -eq 0 ]; then
    godot_version=""
else
    godot_version="-v$1"
fi

cd ./bin/release

file_name="poing-godot-admob-ios$godot_version.zip"

rm $file_name || true
zip -r $file_name ./