#!/bin/bash

capacity=$(cat /sys/class/power_supply/BAT*/capacity)
status=$(cat /sys/class/power_supply/BAT*/status)

# Nerd Font icons
if [ "$capacity" -ge 95 ]; then
    icon=""
elif [ "$capacity" -ge 70 ]; then
    icon=""
elif [ "$capacity" -ge 45 ]; then
    icon=""
elif [ "$capacity" -ge 20 ]; then
    icon=""
else
    icon=""
fi

if [ "$status" = "Charging" ]; then
    icon=" $icon"  # bolt icon before battery
fi

echo "$icon  $capacity%"
