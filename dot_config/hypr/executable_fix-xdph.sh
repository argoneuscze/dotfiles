#!/usr/bin/env bash

sleep 4
killall -e xdg-desktop-portal-hyprland
killall xdg-desktop-portal
/usr/libexec/xdg-desktop-portal-hyprland &
sleep 4
/usr/libexec/xdg-desktop-portal &

