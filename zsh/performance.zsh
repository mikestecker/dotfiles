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

# Lazy loading functions for expensive operations
lazy_load_nvm() {
  if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    source "$HOME/.nvm/nvm.sh"
    source "$HOME/.nvm/bash_completion" 2>/dev/null
  fi
}

lazy_load_rbenv() {
  if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
  fi
}

# Create function wrappers that load on first use
if [[ -s "$HOME/.nvm/nvm.sh" ]] && ! command -v nvm >/dev/null 2>&1; then
  nvm() {
    unfunction nvm
    lazy_load_nvm
    nvm "$@"
  }
fi

if command -v rbenv >/dev/null 2>&1 && [[ -z "$RBENV_SHELL" ]]; then
  rbenv() {
    unfunction rbenv
    lazy_load_rbenv
    rbenv "$@"
  }

  ruby() {
    unfunction ruby rbenv
    lazy_load_rbenv
    ruby "$@"
  }

  gem() {
    unfunction gem rbenv
    lazy_load_rbenv
    gem "$@"
  }
fi

# Optimize PATH building - avoid duplicates and minimize PATH manipulations
build_optimized_path() {
  local new_path=""
  local paths=(
    "$HOME/bin"
    "$HOMEBREW_PREFIX/bin"
    "$HOMEBREW_COREUTILS"
    "$HOMEBREW_PREFIX/opt/python@3.12/libexec/bin"
    "$ASDF_DATA_DIR/shims"
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

# Skip expensive operations in non-interactive shells
if [[ ! -o interactive ]]; then
  return
fi

# Defer heavy operations until after prompt is ready
defer_heavy_operations() {
  # Load iTerm2 integration only if we're in iTerm2
  if [[ "$TERM_PROGRAM" == "iTerm.app" ]] && [[ -f "$DOTFILES/iterm2/iterm2_shell_integration.zsh" ]]; then
    source "$DOTFILES/iterm2/iterm2_shell_integration.zsh"
  fi

  # Load completion enhancements
  if [[ -f "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh/site-functions"
  fi
}

# Schedule deferred operations
if command -v zsh-defer >/dev/null 2>&1; then
  zsh-defer defer_heavy_operations
else
  # Fallback: use background job
  defer_heavy_operations &!
fi
