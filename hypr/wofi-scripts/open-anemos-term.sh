#!/bin/bash

# Switch to workspace 4 (automatically focuses the right monitor)
hyprctl dispatch workspace 4
hyprctl dispatch exec alacritty
sleep 0.2

# These commands work relative to the active monitor
hyprctl dispatch togglefloating
hyprctl dispatch resizeactive exact 50% 90%
hyprctl dispatch moveactive exact 10 30
