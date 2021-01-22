#!/bin/bash
set -euo pipefail

## only works with xfce4-screenshooter

TARGET=~/Screenshots
mkdir -p $TARGET
FILENAME=$(date +%Y%m%d_%H%M%S).png
DESTINATION=$TARGET/$FILENAME

# w: active windows
# o: launch external app
xfce4-screenshooter -w -o cat > $DESTINATION  
