#!/bin/bash
# Smart Ghostty launcher - detects monitor and uses appropriate config

# Get cursor position and active monitor
CURSOR_INFO=$(hyprctl cursorpos -j)
CURSOR_X=$(echo "$CURSOR_INFO" | jq -r '.x')

# Get monitor info
MONITORS=$(hyprctl monitors -j)

# Find which monitor the cursor is on
CURRENT_MONITOR=$(echo "$MONITORS" | jq -r --argjson x "$CURSOR_X" '.[] | select(.x <= $x and ($x < (.x + .width))) | .name')

# Launch appropriate config based on monitor
if [ "$CURRENT_MONITOR" = "DP-1" ]; then
    # Small monitor - use large font
    exec ghostty --config="$HOME/.config/ghostty/config-large"
else
    # Large monitor or fallback - use default font
    exec ghostty --config="$HOME/.config/ghostty/config"
fi
