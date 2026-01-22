#!/usr/bin/env bash

# Tokyo Night-ish palette
NB="#000000"   # background normal
NF="#c0caf5"   # texto normal
SB="#7aa2f7"   # background seleccionado
SF="#000000"   # texto seleccionado
FN="JetBrainsMono Nerd Font Mono"

OPTIONS="Lock
Shutdown
Reboot
Suspend
Logout"

CHOICE=$(echo -e "$OPTIONS" | dmenu -i \
    -fn "$FN" \
    -p "Power Menu:" \
    -nb "$NB" \
    -nf "$NF" \
    -sb "$SB" \
    -sf "$SF"
)

case "$CHOICE" in
    Lock)
        slock
        ;;
    Shutdown)
        systemctl poweroff
        ;;
    Reboot)
        systemctl reboot
        ;;
    Suspend)
        systemctl suspend
        ;;
    Logout)
        pkill x
        ;;
    *)
        exit 0
        ;;
esac

