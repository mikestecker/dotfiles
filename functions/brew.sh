# Loaded by zsh/zshrc.zsh. Oh My Zsh's brew plugin also names this `bup`,
# and that alias only runs `brew upgrade`.
unalias bup 2>/dev/null

bup() {
  brew update && brew upgrade && brew cleanup
}
