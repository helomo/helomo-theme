#!/bin/bash
#
# Lock wrapper — the single entry point for locking (SUPER+L, hypridle, the
# Waybar power menu).
#
# hyprlock holds the session-lock keyboard grab, so Hyprland's SUPER+SPACE
# layout bind cannot fire while it is up, and kb_options carries no grp: toggle
# on purpose (see hyprland.conf input{} — a grp: toggle is per-device and
# desyncs Waybar). If the screen locked while the xkb group was `ara`, the
# password would be untypeable with no way out. Pin group 0 (us) first so the
# lock screen is always English; hyprlock.conf renders the active layout under
# the input field to confirm it.

set -euo pipefail

# Don't stack instances — all three entry points land here.
# `if` rather than `pidof … && exit 0`: under set -e a failing AND-list aborts
# the script, which would skip the lock entirely.
if pidof hyprlock >/dev/null 2>&1; then
    exit 0
fi

hyprctl switchxkblayout all 0 >/dev/null 2>&1 || true

exec hyprlock
