# kill existing processes (if any)
killall -q dwmblocks
kill $(xprop -name "spt" _NET_WM_PID | cut -d "=" -f 2)

dwmblocks &
feh --bg-scale ~/.local/share/dwm/wallpaper.jpg &
urxvt -e spt &
