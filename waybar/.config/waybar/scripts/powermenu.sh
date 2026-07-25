#!/bin/bash
#
# Waybar power menu — rendered with wofi using its own themed config/stylesheet
# (~/.config/wofi/power.conf + power.css), so it stays in the Kazuha Dusk look
# without inheriting the drun launcher's search-box proportions.
# Triggered by the custom/power module.
#
# power.conf sets allow_markup=true so each glyph can carry its Waybar accent
# colour. wofi echoes the chosen line back verbatim, markup and all, so the
# label is stripped of tags before the action lookup.

set -euo pipefail

# bare label  ->  action
declare -A actions=(
    ["Lock"]="hyprlock"
    ["Logout"]="hyprctl dispatch exit"
    ["Reboot"]="systemctl reboot"
    ["Shutdown"]="systemctl poweroff"
)

# Preserve a stable order (associative arrays are unordered).
options="<span color='#d6b8c8'>󰌾</span>  Lock
<span color='#e0b088'>󰍃</span>  Logout
<span color='#8fa5c4'>󰜉</span>  Reboot
<span color='#e08a94'>󰐥</span>  Shutdown"

choice=$(printf '%s\n' "$options" | wofi --dmenu \
    --conf "${XDG_CONFIG_HOME:-$HOME/.config}/wofi/power.conf" \
    --style "${XDG_CONFIG_HOME:-$HOME/.config}/wofi/power.css")

[ -z "${choice:-}" ] && exit 0

# Reduce the echoed line to its bare label: drop pango tags, the glyph, and
# surrounding whitespace. Keeps working whether or not wofi strips markup.
label=$(printf '%s' "$choice" | sed -e 's/<[^>]*>//g' -e 's/[^[:alnum:]]//g')

cmd="${actions[$label]:-}"
[ -n "$cmd" ] && exec $cmd
