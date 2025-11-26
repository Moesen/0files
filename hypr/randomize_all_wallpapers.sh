#!/usr/bin/bash
WALLPAPER_DIR="$HOME/0files/wallpapers/Personal/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

for monitor in $(hyprctl monitors -j | jq -r '.[] | .name'); do
    WALLPAPER=$(find $WALLPAPER_DIR -type f | shuf -n 1) || "none"
    hyprctl hyprpaper reload "$monitor","$WALLPAPER"
done
