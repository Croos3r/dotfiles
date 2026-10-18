#!/bin/bash

# Prints the play/pause icon for Spotify and updates it on every status change
# (replaces the polybar-msg hooks from the polybar setup).
echo "󰏤"
playerctl --player=spotify --follow status 2>/dev/null | while read -r status; do
    if [ "$status" = "Playing" ]; then
        echo "󰏤"
    else
        echo "󰐊"
    fi
done
