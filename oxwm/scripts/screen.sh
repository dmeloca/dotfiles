#!/usr/bin/env bash

set -euo pipefail

# ---------- Config ----------
ROFI_CMD="rofi -dmenu -i -p Screen"
# ---------------------------

# Detect connected outputs
mapfile -t CONNECTED_OUTPUTS < <(xrandr --query | awk '/ connected/{print $1}')

if [ "${#CONNECTED_OUTPUTS[@]}" -eq 0 ]; then
    notify-send "Screen" "No output detected"
    exit 1
fi

# Try to detect internal display
INTERNAL=""
for out in "${CONNECTED_OUTPUTS[@]}"; do
    case "$out" in
        eDP*|LVDS*|DSI*)
            INTERNAL="$out"
            break
            ;;
    esac
done

# If no clear internal display found, use the first connected one
if [ -z "$INTERNAL" ]; then
    INTERNAL="${CONNECTED_OUTPUTS[0]}"
fi

# Detect an external display
EXTERNAL=""
for out in "${CONNECTED_OUTPUTS[@]}"; do
    if [ "$out" != "$INTERNAL" ]; then
        EXTERNAL="$out"
        break
    fi
done

# If no external display, only offer internal option
if [ -z "$EXTERNAL" ]; then
    choice=$(printf "Laptop Screen Only" | eval "$ROFI_CMD")
    case "${choice:-}" in
        "Laptop Screen Only")
            xrandr --output "$INTERNAL" --auto
            ;;
        *)
            exit 0
            ;;
    esac
    exit 0
fi

# Menu
choice=$(printf "Mirror\nExtend\nSecond Screen Only\nLaptop Screen Only\n" | eval "$ROFI_CMD")

case "${choice:-}" in
    "Mirror")
        # Use internal resolution as base
        mode=$(xrandr | awk -v out="$INTERNAL" '
            $1 == out {found=1; next}
            found && /^[[:space:]]+[0-9]+x[0-9]+/ {print $1; exit}
        ')
        xrandr \
            --output "$INTERNAL" --auto \
            --output "$EXTERNAL" --auto --same-as "$INTERNAL"
        ;;
    "Extend")
        xrandr \
            --output "$INTERNAL" --auto \
            --output "$EXTERNAL" --auto --right-of "$INTERNAL"
        ;;
    "Second Screen Only")
        xrandr \
            --output "$INTERNAL" --off \
            --output "$EXTERNAL" --auto
        ;;
    "Laptop Screen Only")
        xrandr \
            --output "$INTERNAL" --auto \
            --output "$EXTERNAL" --off
        ;;
    *)
        exit 0
        ;;
esac
