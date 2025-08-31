#!/usr/bin/env bash
#
# Optimized Node.js path configuration
# Lazy loads NVM to improve shell startup time

# PNPM (lightweight, always load)
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# NVM lazy loading - only load when needed
if [[ -s "$HOME/.nvm/nvm.sh" ]] && [[ ! -v NVM_DIR ]]; then
  export NVM_DIR="$HOME/.nvm"

  # Create lazy loading functions
  _lazy_load_nvm() {
    unset -f nvm node npm npx yarn
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  }

  # Override commands that require NVM
  nvm() { _lazy_load_nvm && nvm "$@"; }
  node() { _lazy_load_nvm && node "$@"; }
  npm() { _lazy_load_nvm && npm "$@"; }
  npx() { _lazy_load_nvm && npx "$@"; }
  yarn() { _lazy_load_nvm && yarn "$@"; }
fi
