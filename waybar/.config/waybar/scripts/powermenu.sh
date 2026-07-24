#!/bin/bash
#
# Waybar power menu — rendered with wofi so it inherits the themed launcher
# style (~/.config/wofi/style.css). Triggered by the custom/power module.

set -euo pipefail

# label  ->  action
declare -A actions=(
    ["󰌾  Lock"]="hyprlock"
    ["󰍃  Logout"]="hyprctl dispatch exit"
    ["󰜉  Reboot"]="systemctl reboot"
    ["󰐥  Shutdown"]="systemctl poweroff"
)

# Preserve a stable order (associative arrays are unordered).
options="󰌾  Lock
󰍃  Logout
󰜉  Reboot
󰐥  Shutdown"

choice=$(printf '%s\n' "$options" | wofi --dmenu --prompt "Power" --width 260 --height 240 --cache-file /dev/null)

[ -z "${choice:-}" ] && exit 0

cmd="${actions[$choice]:-}"
[ -n "$cmd" ] && exec $cmd
