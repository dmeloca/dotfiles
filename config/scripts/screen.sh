#!/usr/bin/env bash

# Tokyo Night-ish palette
NB="#000000"   # background normal
NF="#c0caf5"   # text normal
SB="#7aa2f7"   # selected background
SF="#000000"   # selected text
FN="JetBrainsMono Nerd Font Mono"

# Displays
INTERNAL="eDP-1"
EXTERNAL=$(xrandr | grep " connected" | grep -v "$INTERNAL" | cut -d' ' -f1)

[ -z "$EXTERNAL" ] && notify-send "Display" "No external monitor detected" && exit 0

OPTIONS="Laptop only
External only
Mirror
Extend right
Extend left"

CHOICE=$(echo -e "$OPTIONS" | dmenu \
    -i \
    -p "Display mode:" \
    -nb "$NB" \
    -nf "$NF" \
    -sb "$SB" \
    -sf "$SF" \
    -fn "$FN")

case "$CHOICE" in
    "Laptop only")
        xrandr --output "$EXTERNAL" --off \
               --output "$INTERNAL" --auto
        ;;
    "External only")
        xrandr --output "$INTERNAL" --off \
               --output "$EXTERNAL" --auto
        ;;
    "Mirror")
        xrandr --output "$EXTERNAL" --auto \
               --output "$INTERNAL" --auto --same-as "$EXTERNAL"
        ;;
    "Extend right")
        xrandr --output "$INTERNAL" --auto \
               --output "$EXTERNAL" --auto --right-of "$INTERNAL"
        ;;
    "Extend left")
        xrandr --output "$INTERNAL" --auto \
               --output "$EXTERNAL" --auto --left-of "$INTERNAL"
        ;;
esac

