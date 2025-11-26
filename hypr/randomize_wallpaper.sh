#!/usr/bin/bash

WALLPAPER_DIR="$HOME/0files/wallpapers/Personal/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded) || "none"

FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
WALLPAPER=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)


hyprctl hyprpaper reload "$FOCUSED_MONITOR","$WALLPAPER"
