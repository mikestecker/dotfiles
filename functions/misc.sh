#!/usr/bin/env bash

# Weather forecast
weather() {
  curl wttr.in/$1
}

# IP address info
myip() {
  echo "Public IP: $(curl -s ifconfig.me)"
  echo "Local IP: $(ipconfig getifaddr en0)"
}
