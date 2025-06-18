#!/bin/bash
THEME=${1:-nord}
CONFIG="$HOME/.config/hypr/themes/$THEME.conf"

if [[ -f "$CONFIG" ]]; then
  cp "$CONFIG" "$HOME/.config/hypr/theme.conf"
  hyprctl reload
  echo "Switched to $THEME theme"
else
  echo "Theme not found: $THEME"
fi
