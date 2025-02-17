#!/usr/bin/env bash

# https://github.com/ohmyzsh/ohmyzsh/issues/5243#issuecomment-253649851
alias rl='exec zsh'
alias regen='zgenom reset;source ~/.zshrc'

# Main directories
alias .f='cd ~/.dotfiles'
alias .d='cd ~/Development'
alias work="cd ~/Development/Work/"


if type eza > /dev/null 2>&1; then
  alias ll='eza -alF --icons --color=always --group-directories-first'
  alias llt='eza -alF --icons --color=always -s=mod --reverse'
else
  alias ll='ls -la'
  alias llt='ls -lat'
fi

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias ~='cd ~/'

# Prompt if overwriting
alias cp='cp -i'
alias mv='mv -i'

hs(){ history | grep -i "$1" ;}

# Zsh global aliases
alias -g H='| head'
alias -g Hn='| head -n'
alias -g T='| tail'
alias -g Tn='| tail -n'
alias -g L='| less'
alias -g G='| grep'
alias -g Gi='| grep -i'
alias -g NUL='&> /dev/null'
alias -g CD='&& $_'
alias -g F='| fzf'
alias -g R='| rg'
alias -g J='| jq'
alias -g P='$(pbpaste)'

case "$(uname)" in
  'Linux') alias -g C='| xclip -selection c' ;;
  'Darwin') alias -g C='| pbcopy' ;;
  *) ;;
esac

# VS Code
alias code="/Applications/Cursor.app/Contents/MacOS/Cursor"
alias c.='code .'
alias ca='code -a'

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



# tree w/ .gitignore - https://unix.stackexchange.com/a/632196
alias tr1='rg --files | tree --fromfile -L 1 -C'
alias tr2='rg --files | tree --fromfile -L 2 -C'
alias tr3='rg --files | tree --fromfile -L 3 -C'
alias tr4='rg --files | tree --fromfile -L 4 -C'
alias tr5='rg --files | tree --fromfile -L 5 -C'
alias trall='rg --files | tree --fromfile -C'

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
