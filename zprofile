emulate sh
source ~/.profile
emulate zsh

eval $(/opt/homebrew/bin/brew shellenv)
FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
