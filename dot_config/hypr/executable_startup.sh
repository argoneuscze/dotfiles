#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# fix portals
"$SCRIPT_DIR/fix-xdph.sh" &

# shell
qs -c noctalia-shell &
sleep 3 # delay so tray works as expected

# apps
hyprctl dispatch exec "[workspace 3 silent] ghostty"
rm -f ~/.config/BraveSoftware/Brave-Browser/Singleton*
brave-browser &
flatpak run com.discordapp.Discord &
sleep 8 # delay due to Discord integration
flatpak run app.ytmdesktop.ytmdesktop &

