#!/usr/bin/env bash

# Screenshot timelapse - Fun for making timelapse gifs later, run `creep 20` for every 20 seconds
creep() {
  while :; do
    echo "📸" $(date +%H:%M:%S)
    screencapture -x ~/Screenshots/$(date +%s).png
    sleep $1
  done
}
