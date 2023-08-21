#!/bin/bash
if [ $# -eq 0 ]; then
    godot_version=""
else
    godot_version="-v$1"
fi


cd "./bin/release" && zip -r "poing-admob-ios$godot_version.zip" "./"