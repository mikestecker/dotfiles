#!/usr/bin/env bash
set -e

if command -v mise >/dev/null 2>&1; then
  echo "Installing Node.js and pnpm with mise..."
  mise use --global node@lts pnpm@latest
  echo "✅ Node.js LTS and pnpm latest installed globally"
  mise install node@latest
  echo "✅ Node.js latest version also installed"
  mise use --global node@lts pnpm@latest
  echo "✅ Global versions set: node@lts, pnpm@latest"
else
  echo "⚠️  Mise not available, skipping tool installation"
fi
