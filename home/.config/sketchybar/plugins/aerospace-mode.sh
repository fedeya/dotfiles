#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh


if [ -z $MODE ]; then
    MODE="M"
else
    MODE=$MODE
fi

sketchybar --set $NAME label=$MODE
