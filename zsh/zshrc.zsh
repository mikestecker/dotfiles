#!/usr/bin/env zsh
# Optimized .zshrc for faster startup

# Enable Powerlevel10k instant prompt (keep this at the very top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Essential exports (needed early)
export DOTFILES="$HOME/.dotfiles"
export GPG_TTY=$TTY

# Load performance optimizations early
source "$DOTFILES/zsh/performance.zsh"

# Essential environment variables
export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"
export EDITOR="/Applications/Cursor.app/Contents/MacOS/Cursor -nw"
export LANG=en_US.UTF-8
export DEFAULT_USER="$USER"

# Build optimized PATH once, then activate mise so shims stay in front.
build_optimized_path
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Git signing and GitLab/GitHub use the 1Password SSH agent when it is enabled.
op_ssh_agent="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
if [[ -S "$op_ssh_agent" ]]; then
  export SSH_AUTH_SOCK="$op_ssh_agent"
fi
unset op_ssh_agent

# ZSH options (lightweight)
setopt AUTO_CD EXTENDED_HISTORY CORRECT NO_CASE_GLOB NUMERIC_GLOB_SORT
setopt APPEND_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS HIST_VERIFY INC_APPEND_HISTORY SHARE_HISTORY
setopt PUSHD_IGNORE_DUPS

# History stays in this file on this machine. Do not sync it between laptops.
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
export HISTCONTROL=erasedups
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Timing for long running processes
REPORTTIME=2
TIMEFMT="%U user %S system %P cpu %*Es total"

# ZGen setup with custom compdump location
export ZGEN_CUSTOM_COMPDUMP="~/.zcompdump-$(whoami).zwc"
source ~/.zgenom/zgenom.zsh

# Plugin loading (only if not already saved)
if ! zgenom saved; then
    echo "Regenerating zgenom init.sh..."

    # Core framework
    zgenom ohmyzsh

    # Essential plugins (lightweight first)
    zgenom ohmyzsh plugins/git
    zgenom load romkatv/powerlevel10k powerlevel10k

    zgenom load zsh-users/zsh-autosuggestions
    zgenom load zsh-users/zsh-history-substring-search
    zgenom load zsh-users/zsh-completions src

    # Secondary plugins
    zgenom ohmyzsh plugins/sudo
    zgenom load jocelynmallon/zshmarks
    zgenom load djui/alias-tips
    zgenom load ntnyq/omz-plugin-pnpm

    # Custom plugins
    zgenom load "$DOTFILES/zsh/globalias.plugin.zsh"

    # Syntax highlighting must be the last plugin.
    zgenom load zsh-users/zsh-syntax-highlighting

    # Generate init script
    zgenom save
fi

# Docker and kubectl plugins load on first use.
_load_omz_plugin() {
  local plugin="$1"
  shift
  local cmd
  for cmd in "$@"; do
    unfunction "$cmd" 2>/dev/null
  done
  source "$ZSH/plugins/${plugin}/${plugin}.plugin.zsh"
}

docker() {
  _load_omz_plugin docker docker
  _load_omz_plugin docker-compose docker-compose
  docker "$@"
}

docker-compose() {
  _load_omz_plugin docker docker
  _load_omz_plugin docker-compose docker-compose
  docker-compose "$@"
}

kubectl() {
  _load_omz_plugin kubectl kubectl
  kubectl "$@"
}

# Key bindings for history search (after plugins load)
if [[ -n "${ZSH_VERSION-}" ]]; then
    zmodload zsh/terminfo
    [[ -n "${terminfo[kcuu1]-}" ]] && bindkey "$terminfo[kcuu1]" history-substring-search-up
    [[ -n "${terminfo[kcud1]-}" ]] && bindkey "$terminfo[kcud1]" history-substring-search-down
    bindkey "^k" history-substring-search-up
    bindkey "^j" history-substring-search-down
fi

# Load theme configuration
source "$DOTFILES/zsh/p10k.zsh"

# FZF configuration (lightweight)
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi
export FZF_DEFAULT_OPTS='--reverse --bind ctrl-l:cancel --height=90% --pointer=▶'
export FZF_TMUX_HEIGHT=80%

# Plugin configurations
export ZSH_PLUGINS_ALIAS_TIPS_REVEAL_TEXT="❯ "
export ITERM2_SHOULD_DECORATE_PROMPT=0

# Puppeteer config (only if puppeteer is used)
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
if command -v chromium >/dev/null 2>&1; then
    export PUPPETEER_EXECUTABLE_PATH=$(command -v chromium)
fi

# Initialize direnv if installed (environment management)
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi

# Initialize zoxide if installed (better cd)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Man page colors
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Lazy load aliases and functions using a more efficient method
lazy_load_dotfiles() {
    # Load aliases
    for f in "$DOTFILES"/aliases/*.aliases.*sh; do
        [[ -r "$f" ]] && source "$f"
    done

    # Load functions
    for f in "$DOTFILES"/functions/*; do
        [[ -r "$f" ]] && source "$f"
    done

    # Load custom theme
    [[ -r "$DOTFILES/zsh/fzf-theme-monokai-mikes-mod.sh" ]] && source "$DOTFILES/zsh/fzf-theme-monokai-mikes-mod.sh"

    # Load FZF if available
    [[ -r ~/.fzf.zsh ]] && source ~/.fzf.zsh
}

# Completion settings (defer these)
lazy_load_completions() {
    if [[ -n "${ZSH_VERSION-}" ]]; then
        zstyle ":completion:*:*:skim:*" file-patterns "*.pdf *(-/)"

        # Create zcompclean function
        zcompclean() {
            rm -rf "${XDG_CONFIG_HOME:-$HOME/.cache}/zsh/.zcompdump"*
            autoload -U compinit && compinit
        }
    fi

    # Bun completions
    [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
}

# Load user customizations
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -r ~/.secrets ]] && source ~/.secrets

# Aliases and functions are available at the first prompt.
lazy_load_dotfiles

# Load iTerm2 integration only if we're in iTerm2.
if [[ "$TERM_PROGRAM" == "iTerm.app" ]] && [[ -f "$DOTFILES/iterm2/iterm2_shell_integration.zsh" ]]; then
  source "$DOTFILES/iterm2/iterm2_shell_integration.zsh"
fi

# Completions can load after the prompt.
{
  lazy_load_completions
  if [[ -f "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
    source "$HOMEBREW_PREFIX/share/zsh/site-functions"
  fi
} &!
