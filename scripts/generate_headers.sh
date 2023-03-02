#!/bin/bash
if [[ "$1" == "3.x" ]];
then
    cd ./godot && \
        ./../scripts/timeout scons platform=iphone target=template_release
else
    cd ./godot && \
        ./../scripts/timeout scons platform=ios target=template_release  
fi