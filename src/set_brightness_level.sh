#!/bin/bash

## source <(curl -s https://raw.githubusercontent.com/chilcano/how-tos/main/src/set_brightness_level.sh) --screen=DP-1 --level=0.90
## Ref: https://forum.manjaro.org/t/screen-brightness-resets-to-full-after-every-reboot/19893

## Screens available:
# eDP-1 (Asus / Laptop)
# HDMI-2 (Johnwill / 3-PDA 24")
# DP-1 (Blitzwolf / 2-RTK 27")

unset _SCREEN _LEVEL

while [ $# -gt 0 ]; do
  case "$1" in
    --screen*|-s*)
      if [[ "$1" != *=* ]]; then shift; fi
      _SCREEN="${1#*=}"
      ;;
    --level*|-l*)
      if [[ "$1" != *=* ]]; then shift; fi
      _LEVEL="${1#*=}"
      ;;
    --help|-h)
      printf "Set brightness level to desired screen. \n"
      exit 0
      ;;
    *)
      >&2 printf "Error: Invalid argument: '$1' \n"
      exit 1
      ;;
  esac
  shift
done

_SCR="${_SCREEN:-DP-1}"
_LEV="${_LEVEL:-0.85}"

xrandr --output ${_SCR} --brightness ${_LEV}
