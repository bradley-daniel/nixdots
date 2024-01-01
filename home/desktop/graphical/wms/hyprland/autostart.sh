#!/usr/bin/env bash

# pkill waybar
swww kill
swww init

swww img ~/Wallpapers/nix.png &

dunst &

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
