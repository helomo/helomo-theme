#!/bin/bash

# --- Configuration: Icons for better distinction and robustness ---
# These icons prioritize visual clarity and wider rendering success.
# Assuming JetBrainsMono Nerd Font is correctly configured and working.

ICON_MUTED=""  # Using Muted Speaker emoji (U+1F507) - highly distinct and generally well-supported.
# Alternative muted if 🔇 doesn't show: "" (Font Awesome volume-off) or "[M]"

ICON_LOW=""    # Font Awesome: volume-down (U+F027) - should work with Nerd Fonts.
ICON_MEDIUM="" # Font Awesome: volume-up (U+F028) - should work with Nerd Fonts.
ICON_HIGH=""  # Using Speaker with three sound waves emoji (U+1F50A) - distinctly "loud" and widely supported.
# Alternative high if 🔊 doesn't show: "+++ "

# --- Get volume and mute status using amixer (alsamixer backend) ---

VOL_RAW=$(amixer get Master 2>&1)

VOL=$(echo "$VOL_RAW" | sed -n 's/.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)

if echo "$VOL_RAW" | grep -iq '\[off\]'; then
    MUTED_STATUS="true"
else
    MUTED_STATUS="false"
fi

if [ -z "$VOL" ]; then
    VOL=0
fi

# --- Determine the icon based on mute status and volume level ---

if [ "$MUTED_STATUS" = "true" ] || [ "$VOL" -eq 0 ]; then
    ICON="$ICON_MUTED"
    OUTPUT="Muted"
elif [ "$VOL" -lt 10 ]; then
    ICON="$ICON_LOW"
    OUTPUT="$VOL%"
elif [ "$VOL" -le 30 ]; then
    ICON="$ICON_LOW"
    OUTPUT="$VOL%"
elif [ "$VOL" -le 60 ]; then
    ICON="$ICON_MEDIUM"
    OUTPUT="$VOL%"
else # Volume > 60% (e.g., 61% to 100%)
    ICON="$ICON_HIGH "
    OUTPUT="$VOL%"
fi

echo "$ICON $OUTPUT"