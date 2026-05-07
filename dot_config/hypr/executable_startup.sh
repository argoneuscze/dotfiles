#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# fix portals
"$SCRIPT_DIR/fix-xdph.sh" &

# shell
qs -c noctalia-shell &
sleep 3 # delay so tray works as expected

# apps
hyprctl dispatch exec "[workspace 3 silent] ghostty"
hyprctl dispatch workspace 1
brave-browser &
Discord &
sleep 7 # Delay because of Discord integration
flatpak run app.ytmdesktop.ytmdesktop &

