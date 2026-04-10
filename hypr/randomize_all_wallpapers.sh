#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/0files/wallpapers/light"

if ! command -v jq >/dev/null 2>&1; then
    echo "jq is required for randomize_all_wallpapers.sh" >&2
    exit 1
fi

mapfile -t monitors < <(hyprctl monitors -j | jq -r '.[].name')

if [ "${#monitors[@]}" -eq 0 ]; then
    echo "No monitors returned by hyprctl" >&2
    exit 1
fi

for monitor in "${monitors[@]}"; do
    wallpaper=$(find "$WALLPAPER_DIR" -type f | shuf -n 1)
    hyprctl hyprpaper wallpaper "$monitor, $wallpaper, cover"
done
