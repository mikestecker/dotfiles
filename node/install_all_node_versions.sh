#!/usr/bin/env bash
# Install Node.js versions referenced by .nvmrc files under ~/dev.

echo "----- INSTALLING NODEJS VERSIONS -----"
find ~/dev -maxdepth 3 -name .nvmrc -type f -print0 | while IFS= read -r -d '' nvmrc; do
  version="$(sed 's/^v//' "$nvmrc")"
  [[ -n "$version" ]] && mise install "node@${version}"
done
