#!/usr/bin/env bash
#
# Optimized Node.js path configuration
# Uses mise for fast, modern tool management

# PNPM home (for completions and global installs)
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Mise manages Node.js, pnpm, and other tools
# No lazy loading needed - mise is fast and handles PATH automatically
# Tools are available immediately via mise shims in ~/.local/share/mise/shims
