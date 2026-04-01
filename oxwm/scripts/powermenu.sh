#!/usr/bin/env bash

set -euo pipefail

ROFI_CMD="rofi -dmenu -i -p Power"

OPTIONS="Lock
Suspend
Logout
Reboot
Power Off"

CHOSEN="$(printf '%s\n' "$OPTIONS" | eval "$ROFI_CMD")"

case "${CHOSEN:-}" in
    "Lock")
	i3lock \
	    --inside-color=1a1b26cc \
	    --ring-color=7aa2f7 \
	    --line-color=00000000 \
	    --keyhl-color=bb9af7 \
	    --bshl-color=f7768e \
	    --separator-color=00000000 \
	    --clock \
	    --time-color=c0caf5 \
	    --date-color=9aa5ce \
	    --blur 5 \
	    & systemctl suspend
	;;
    "Suspend")
        systemctl suspend
        ;;
    "Logout")
        if [ -n "${DESKTOP_SESSION:-}" ]; then
            case "$DESKTOP_SESSION" in
                i3)
                    i3-msg exit
                    ;;
                bspwm)
                    bspc quit
                    ;;
                xfce|xfce4)
                    xfce4-session-logout --logout
                    ;;
                *)
                    loginctl terminate-session "$XDG_SESSION_ID"
                    ;;
            esac
        else
            loginctl terminate-session "$XDG_SESSION_ID"
        fi
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Power Off")
        systemctl poweroff
        ;;
    *)
        exit 0
        ;;
esac
