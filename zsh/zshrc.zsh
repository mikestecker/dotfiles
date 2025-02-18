# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!/usr/bin/env bash
# Get zgen
source ~/.zgenom/zgenom.zsh
export DOTFILES="$HOME/.dotfiles"
export GPG_TTY=$TTY # https://unix.stackexchange.com/a/608921

# Override compdump name: https://github.com/jandamm/zgenom/discussions/121
export ZGEN_CUSTOM_COMPDUMP="~/.zcompdump-$(whoami).zwc"

# Generate zgen init.sh if it doesn't exist
if ! zgenom saved; then
    zgenom ohmyzsh

    # Plugins
    zgenom ohmyzsh plugins/git
    zgenom ohmyzsh plugins/github
    zgenom ohmyzsh plugins/sudo
    zgenom ohmyzsh plugins/command-not-found
    zgenom ohmyzsh plugins/kubectl
    zgenom ohmyzsh plugins/docker
    zgenom ohmyzsh plugins/docker-compose
    zgenom ohmyzsh plugins/z
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load jocelynmallon/zshmarks
    zgenom load denolfe/git-it-on.zsh
    zgenom load caarlos0/zsh-mkc
    zgenom load caarlos0/zsh-git-sync
    zgenom load caarlos0/zsh-add-upstream
    zgenom load denolfe/zsh-prepend

    zgenom load andrewferrier/fzf-z
    zgenom load reegnz/jq-zsh-plugin

    zgenom ohmyzsh plugins/asdf

    zgenom load ntnyq/omz-plugin-pnpm

    # These 2 must be in this order
    zgenom load zsh-users/zsh-syntax-highlighting
    zgenom load zsh-users/zsh-history-substring-search

    # Set keystrokes for substring searching
    zmodload zsh/terminfo
    bindkey "$terminfo[kcuu1]" history-substring-search-up
    bindkey "$terminfo[kcud1]" history-substring-search-down
    bindkey "^k" history-substring-search-up
    bindkey "^j" history-substring-search-down

    # Warn you when you run a command that you've got an alias for
    zgenom load djui/alias-tips

    # Modified globalias plugin
    zgenom load $DOTFILES/zsh/globalias.plugin.zsh

    # Completion-only repos
    zgenom load zsh-users/zsh-completions src

    # Theme
    zgenom load romkatv/powerlevel10k powerlevel10k

    # Generate init.sh
    zgenom save
fi

source $DOTFILES/zsh/p10k.zsh

# History Options
setopt append_history # Append history to the history file (no overwriting)
setopt extended_history # Add timestamps to history
setopt hist_expire_dups_first # Expire duplicates first when trimming history
setopt hist_ignore_all_dups # Ignore all dups in history
setopt hist_ignore_dups # Ignore dups in history
setopt hist_ignore_space # Ignore commands that start with a space
setopt hist_reduce_blanks # Remove superfluous blanks from history
setopt hist_save_no_dups # Don't record duplicated commands
setopt hist_verify # Show command with history expansion before running it
setopt inc_append_history # Append history to the history file (no overwriting)

# Share history across all your terminal windows
setopt share_history # Share history across all your terminal windows
#setopt noclobber

# set some more options
setopt pushd_ignore_dups # Ignore duplicates when using pushd
#setopt pushd_silent

# Basic Settings
export EDITOR="/Applications/Cursor.app/Contents/MacOS/Cursor -nw"
export LANG=en_US.UTF-8  # Set language
setopt AUTO_CD  # Type directory name to cd into it
setopt EXTENDED_HISTORY  # Add timestamps to history
setopt CORRECT # Command correction
setopt CORRECT_ALL # Argument correction
setopt NO_CASE_GLOB # Case insensitive globbing
setopt NUMERIC_GLOB_SORT # Sort numerically when globbing

export DEFAULT_USER="$USER"

# History Settings
HISTSIZE=1000000000000000000
SAVEHIST=1000000000000000000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY  # Share history between sessions
setopt HIST_IGNORE_DUPS  # Don't record duplicated commands
setopt HIST_IGNORE_SPACE # Don't record commands starting with space
setopt HIST_VERIFY # Show command with history expansion before running it
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from history
export HISTCONTROL=erasedups
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"

# Return time on long running processes
REPORTTIME=2
TIMEFMT="%U user %S system %P cpu %*Es total"

# Load aliases
for f in $DOTFILES/aliases/*.aliases.*sh; do source $f; done

# Load functions
for f in $DOTFILES/functions/*; do source $f; done

# Load all path files
export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$(brew --prefix coreutils)/libexec/gnubin:$PATH"
for f in $DOTFILES/path/*.path.sh; do source $f; done

if type fd > /dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f'
fi

# FZF config and theme
export FZF_DEFAULT_OPTS='--reverse --bind 'ctrl-l:cancel' --height=90% --pointer='▶''
source $DOTFILES/zsh/fzf-theme-monokai-mikes-mod.sh
export FZF_TMUX_HEIGHT=80%
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export ZSH_PLUGINS_ALIAS_TIPS_REVEAL_TEXT="❯ "

# Initialize rbenv if installed
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

# Puppeteer config
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=$(which chromium)

if [[ -n ${ZSH_VERSION-} ]]; then
  zstyle ":completion:*:*:skim:*" file-patterns "*.pdf *(-/)"
  zcompclean() {
    rm -rf ${XDG_CONFIG_HOME}/zsh/.zcompdump*
    autoload -U compinit && compinit
  }
fi

export ITERM2_SHOULD_DECORATE_PROMPT=0
source $DOTFILES/iterm2/iterm2_shell_integration.zsh

export ASDF_DOWNLOAD_PATH=bin/install
source /opt/homebrew/opt/asdf/libexec/asdf.sh
source /opt/homebrew/share/zsh/site-functions

# pnpm
export PNPM_HOME="/Users/elliot/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# Console Ninja
PATH=~/.console-ninja/.bin:$PATH

# Add color to man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# To customize prompt, run `p10k configure` or edit ~/.dotfiles/zsh/p10k.zsh.
[[ ! -f ~/.dotfiles/zsh/p10k.zsh ]] || source ~/.dotfiles/zsh/p10k.zsh
