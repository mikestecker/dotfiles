
#-------------------------------------------------------------------------------
# Setup PATH.
#-------------------------------------------------------------------------------

# bin folder for this machine
# export PATH=~/bin:${PATH}
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/mysql/bin:$PATH
export PATH=$PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi


#-------------------------------------------------------------------------------
# Setup the prompt
#-------------------------------------------------------------------------------
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

export HISTCONTROL=erasedups
export HISTSIZE=100000

#-------------------------------------------------------------------------------
# Use colors in the Terminal program.
#-------------------------------------------------------------------------------

# -l for long, -G for colors, -F to decorate file names, -A to show dot files
alias ls="ls -lGFh"
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'

# Another way to do colors in the Terminal program.
# export CLICOLOR=1
# export LSCOLORS=ExFxCxDxBxegedabagacad

#-------------------------------------------------------------------------------
# aliases
#-------------------------------------------------------------------------------
alias cd..="cd .."
alias ..='cd ..'
alias _='cd -'

alias l="ls -al"
alias lp="ls -p"
alias ll='ls -l -h'
alias la='ls -A'
alias du='du -kh'
alias df='df -kTh'
alias h=history
alias work="cd ~/Documents/Projects/"
alias hosts="sudo atom /private/etc/hosts"
alias vhosts="sudo atom /private/etc/apache2/extra/httpd-vhosts.conf"
alias ra="sudo apachectl restart"
alias add-spacer="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"spacer-tile\";}'; killall Dock"

source ~/.profile

# added by Anaconda3 4.4.0 installer
export PATH="/Users/mikestecker/anaconda/bin:$PATH"

# virtualenv
# export WORKON_HOME=~/virtualenvs
# source /usr/local/bin/virtualenvwrapper.sh
