#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bars top and bottom
echo "---" | tee -a /tmp/polybar_top.log /tmp/polybar_bottom.log
polybar top >>/tmp/polybar_top.log 2>&1 &
polybar bottom >>/tmp/polybar_bottom.log 2>&1 &

echo "Bars launched..."
