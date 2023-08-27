#!/usr/bin/env bash

# Terminate already running bar instances
#pkill polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config
polybar main -r 2>&1 | tee /tmp/polybar.log & disown

echo "Polybar launched..."
