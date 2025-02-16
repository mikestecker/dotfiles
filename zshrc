# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZSH Config
export ZSH=/Users/mikestecker/.oh-my-zsh # Path to oh-my-zsh installation.
ZSH_THEME="powerlevel10k/powerlevel10k" # https://github.com/romkatv/powerlevel10k
COMPLETION_WAITING_DOTS="true" # Display red dots while waiting for completion

# Setup zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

plugins=(
  alias-finder
  brew
  compleat
  copyfile
  copypath
  dirhistory
  docker
  docker-compose
  # dotenv
  encode64
  extract
  fzf
  git
  git-flow
  github
  gem
  heroku
  history
  jsontools
  kubectl
  lol
  node
  npm
  macos
  rbenv
  ruby
  urltools
  vscode
  web-search
  z
  # zsh-completions # Installed via
)

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/oh-my-zsh.sh

# Basic Settings
alias code="/Applications/Cursor.app/Contents/MacOS/Cursor" # Alias for Cursor, overrides code command
export EDITOR="code -nw"
export LANG=en_US.UTF-8  # Set language
setopt AUTO_CD  # Type directory name to cd into it
setopt EXTENDED_HISTORY  # Add timestamps to history
setopt CORRECT # Command correction
setopt CORRECT_ALL # Argument correction
setopt NO_CASE_GLOB # Case insensitive globbing
setopt NUMERIC_GLOB_SORT # Sort numerically when globbing

export DEFAULT_USER="$USER"

# History Settings
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY  # Share history between sessions
setopt HIST_IGNORE_DUPS  # Don't record duplicated commands
setopt HIST_IGNORE_SPACE # Don't record commands starting with space
setopt HIST_VERIFY # Show command with history expansion before running it
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from history
export HISTCONTROL=erasedups

#-------------------------------------------------------------------------------
# Setup PATH
#-------------------------------------------------------------------------------
export PATH="/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin:$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Initialize rbenv if installed
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

# Puppeteer config
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=$(which chromium)

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------
# Navigation
alias cd..="cd .."
alias ..='cd ..'
alias _='cd -'
alias work="cd ~/Development/Work/"
alias ...='cd ../..'
alias ....='cd ../../..'

# ls aliases with flags
alias ls="ls -lGFh"     # Default: long, colors, file types, human readable
alias l='ls -lFh'       # Size, type, human readable
alias la='ls -lAFh'     # Show hidden files
alias lr='ls -tRFh'     # Sort by date, recursive
alias lt='ls -ltFh'     # Sort by date
alias ll='ls -l'        # Long format
alias lc='colorls -lA --sd' # Colorized ls
alias lsd='ls -ld */'   # List only directories

# Grep with colors
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# System commands
alias du='du -kh'
alias df='df -kTh'
alias h=history
alias hosts="sudo $EDITOR /private/etc/hosts"
alias mkdir='mkdir -p'
alias o='open'
alias of='lsof -nP +c 15 | grep LISTEN'
alias m='make -j8'
alias c='clear'
alias path='echo -e ${PATH//:/\\n}' # Print each PATH entry on a separate line
alias ports='netstat -tulanp' # Show active ports

# Git aliases
alias gum="git pull upstream master"
alias gco="git checkout"
alias gri="git ls-files --ignored --exclude-standard | xargs -0 git rm -r" # Remove files in .gitignore
alias fix="git diff --name-only | uniq | xargs cursor" # Open changed files
# alias 🖕😏🖕="git push --force"
alias "git latest"="git for-each-ref --sort=-committerdate refs/heads/"
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline'
alias gaa='git add .'

# Config files
alias zs="source ~/.zshrc"
alias zshconfig="$EDITOR ~/.zshrc"
alias refresh='source ${ZSH_VERSION:+~/.zshrc}'
alias vimconfig="$EDITOR ~/.vimrc"
alias sshconfig="$EDITOR ~/.ssh/config"

# macOS
alias skim='open -a Skim'
alias add-spacer="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"spacer-tile\";}'; killall Dock"
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete" # Remove .DS_Store files

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
# Homebrew update, requires: https://github.com/buo/homebrew-cask-upgrade
bup() {
  echo "Updating your [Homebrew] system"
  brew update
  brew upgrade
  brew cu
  brew cleanup
}

# File search
search() {
  find . -iname "*$@*" | less
}

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Skim PDF viewer completion
if [[ -n ${ZSH_VERSION-} ]]; then
  zstyle ":completion:*:*:skim:*" file-patterns "*.pdf *(-/)"
  zcompclean() {
    rm -rf ${XDG_CONFIG_HOME}/zsh/.zcompdump*
    autoload -U compinit && compinit
  }
fi

# PDF optimization
optipdf() {
  local pdf=$1
  local res="$(basename $pdf .pdf)-optimized.pdf"
  noglob gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -sOutputFile=$res $pdf
  local opti_size=$(du -k $res | cut -f1)
  local size=$(du -k $pdf | cut -f1)
  if [[ "$opti_size" -lt "$size" ]]; then
    echo " => optimized PDF of smaller size ($opti_size vs. $size) thus overwrite $pdf"
    mv $res $pdf
    git commit -s -m "reduce size of PDF '$pdf'" $pdf
  else
    echo " => already optimized PDF thus discarded"
    rm -f $res
  fi
}
alias reducepdf='optipdf'
alias optipng='optipng -o9 -zm1-9 -strip all'
alias optijpg='jpegoptim'

# Directory tree view
t() {
  tree -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst --filelimit 15 -L ${1:-3} -aC $2
}

# Screenshot timelapse - Fun for making timelapse gifs later, run `creep 20` for every 20 seconds
creep() {
  while :; do
    echo "📸" $(date +%H:%M:%S)
    screencapture -x ~/Screenshots/$(date +%s).png
    sleep $1
  done
}

# Weather forecast
weather() {
  curl wttr.in/$1
}

# IP address info
myip() {
  echo "Public IP: $(curl -s ifconfig.me)"
  echo "Local IP: $(ipconfig getifaddr en0)"
}

#-------------------------------------------------------------------------------
# Node Version Manager
#-------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

#-------------------------------------------------------------------------------
# PNPM
#-------------------------------------------------------------------------------
export PNPM_HOME="/Users/mikestecker/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

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
