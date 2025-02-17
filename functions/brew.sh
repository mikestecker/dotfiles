#!/usr/bin/env bash
#
# Homebrew update, requires: https://github.com/buo/homebrew-cask-upgrade
bup() {
  echo "Updating your [Homebrew] system"
  brew update
  brew upgrade
  brew cu
  brew cleanup
}
