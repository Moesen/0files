#!/bin/bash

# Try to find Steam installation
STEAM_ROOT=""
if [[ -d "$HOME/.steam/steam" ]]; then
    STEAM_ROOT="$HOME/.steam/steam"
elif [[ -d "$HOME/.local/share/Steam" ]]; then
    STEAM_ROOT="$HOME/.local/share/Steam"
elif [[ -d "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam" ]]; then
    STEAM_ROOT="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"
fi

if [[ -z "$STEAM_ROOT" ]]; then
    echo "Could not find Steam installation" >&2
    exit 1
fi

STEAM_PATH="$STEAM_ROOT/steamapps"
ICON_CACHE="$STEAM_ROOT/appcache/librarycache"

# Function to find icon for app ID
find_icon() {
    local appid="$1"
    local icon_dir="$ICON_CACHE/$appid"

    if [[ -d "$icon_dir" ]]; then
        # Prefer logo.png, then library_600x900.jpg, then header.jpg
        local icon_files=(
            "$icon_dir/logo.png"
            "$icon_dir/library_600x900.jpg"
            "$icon_dir/header.jpg"
        )

        for icon_file in "${icon_files[@]}"; do
            if [[ -f "$icon_file" ]]; then
                echo "$icon_file"
                return 0
            fi
        done
    fi
    return 1
}

# Function to get game info from appmanifest
get_game_info() {
    local manifest="$1"
    local appid=$(grep -oP '"appid"\s*"\K\d+' "$manifest")
    local name=$(grep -oP '"name"\s*"\K[^"]+' "$manifest")

    # Skip Steam runtime and Proton
    if [[ "$name" == *"Steam Linux Runtime"* ]] || [[ "$name" == *"Proton"* ]]; then
        return
    fi

    local icon=$(find_icon "$appid")
    echo "$appid|$name|$icon"
}

# Create temp files
GAMES_FILE="/tmp/steam_games_list"
WOFI_FILE="/tmp/wofi_games_list"
> "$GAMES_FILE"
> "$WOFI_FILE"

# Parse all appmanifest files
for manifest in "$STEAM_PATH"/appmanifest_*.acf; do
    if [[ -f "$manifest" ]]; then
        get_game_info "$manifest" >> "$GAMES_FILE"
    fi
done

# Create wofi-formatted list with icons
while IFS='|' read -r appid name icon; do
    if [[ -n "$icon" && -f "$icon" ]]; then
        echo "img:$icon:text:$name"
    else
        echo "🎮 $name"
    fi
done < "$GAMES_FILE" > "$WOFI_FILE"

# Show wofi menu
selected=$(wofi --dmenu --prompt "Steam Games" --width 700 --height 500 --allow-images --allow-markup --style ~/.config/wofi/custom/game-launcher/launch-game.css < "$WOFI_FILE")

if [[ -n "$selected" ]]; then
    # Extract game name (remove icon prefix or emoji)
    game_name=$(echo "$selected" | sed 's/^img:[^:]*:text://' | sed 's/^🎮 //')

    # Get the app ID for the selected game
    appid=$(grep "$game_name" "$GAMES_FILE" | cut -d'|' -f1)

    if [[ -n "$appid" ]]; then
        # Launch the game and move to gaming workspace
        hyprctl dispatch workspace 5
        steam "steam://rungameid/$appid"
    fi
fi

# Clean up
rm "$GAMES_FILE" "$WOFI_FILE"
