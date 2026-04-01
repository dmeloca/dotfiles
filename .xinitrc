!#/bin/sh
setxkbmap -layout "us,latam" -option "grp:alt_shift_toggle"
xset r rate 300 50
xset -b
xwallpaper --zoom ~/.config/walls/wall.jpg
picom --config ~/.config/picom/picom.conf & 
exec oxwm
