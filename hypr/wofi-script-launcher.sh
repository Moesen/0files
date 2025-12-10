#!/bin/bash

SCRIPT_DIR="$HOME/0files/hypr/wofi-scripts/"
SCRIPTS=$(ls "$SCRIPT_DIR"/*.sh 2>/dev/null | xargs -n 1 basename | sed 's/\.sh$//')
SELECTED=$(echo "$SCRIPTS" | wofi --dmenu --prompt "Run Script:" --insensitive)
if [ -n "$SELECTED" ]; then
    bash "$SCRIPT_DIR/$SELECTED.sh"
fi
