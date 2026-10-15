#!/usr/bin/env zsh
#
# Performance optimizations for zsh startup
# Source this file early in .zshrc for faster shell startup

# Cache expensive operations
export DOTFILES_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
mkdir -p "$DOTFILES_CACHE_DIR"

# Cache brew prefix (expensive operation)
if [[ ! -f "$DOTFILES_CACHE_DIR/brew_prefix" ]] || [[ $(find "$DOTFILES_CACHE_DIR/brew_prefix" -mtime +7) ]]; then
  brew --prefix > "$DOTFILES_CACHE_DIR/brew_prefix" 2>/dev/null || echo "/opt/homebrew" > "$DOTFILES_CACHE_DIR/brew_prefix"
fi
export HOMEBREW_PREFIX="$(cat "$DOTFILES_CACHE_DIR/brew_prefix")"

# Pre-calculate common paths
export HOMEBREW_COREUTILS="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"

# Mise shims come before Homebrew so node, pnpm, and python follow mise.
# Optimize PATH building - avoid duplicates and minimize PATH manipulations
build_optimized_path() {
  local new_path=""
  local paths=(
    "$HOME/bin"
    "$HOME/.local/share/mise/shims"
    "$HOME/.console-ninja/.bin"
    "$HOMEBREW_PREFIX/sbin"
    "$HOMEBREW_PREFIX/bin"
    "$HOMEBREW_COREUTILS"
    "$PNPM_HOME"
    "$BUN_INSTALL/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  )

  for p in "${paths[@]}"; do
    if [[ -d "$p" ]] && [[ ":$new_path:" != *":$p:"* ]]; then
      new_path="${new_path:+$new_path:}$p"
    fi
  done

  export PATH="$new_path"
}
