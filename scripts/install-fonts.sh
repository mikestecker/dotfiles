#!/usr/bin/env bash
set -e

echo "Installing Operator Mono Nerd Font..."
if [[ $(uname) = "Darwin" ]]; then
  FONT_DIR="$HOME/Library/Fonts"
  mkdir -p "$FONT_DIR"
  cp -f fonts/operator-mono-nerd/*.otf "$FONT_DIR/"
  echo "✅ Installed $(ls fonts/operator-mono-nerd/*.otf | wc -l | tr -d ' ') Operator Mono Nerd Font variants"
else
  echo "⚠️  Font installation skipped (not macOS)"
fi
