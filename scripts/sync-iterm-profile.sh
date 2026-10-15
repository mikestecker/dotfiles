#!/usr/bin/env bash
# Point iTerm2 at the dynamic profile in this repo.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
guid="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["Profiles"][0]["Guid"])' "$root/iterm2/profile.json")"

if [[ "$(uname)" != Darwin ]]; then
  exit 0
fi

defaults write com.googlecode.iterm2 "Default Bookmark Guid" -string "$guid"
echo "iTerm default profile set to $guid"
echo "Quit and reopen iTerm. Allow the Python API if it asks, so this profile stays selected."
