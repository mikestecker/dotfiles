#!/usr/bin/env bash
#
# Install homebrew and essential packages

# Install Xcode Command Line Tools (required for development)
echo "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &> /dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Please complete the Xcode Command Line Tools installation in the dialog that appeared."
  echo "Press any key to continue after installation is complete..."
  read -n 1 -s
else
  echo "✓ Xcode Command Line Tools already installed"
fi

if ! type brew > /dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_UPGRADE=1

PACKAGES=(
  "asdf"
  "fzf"
  "git"
  "eza"
  "neovim"
  "tree"
  "fd"
  "jq"
  "ripgrep"
  "zsh"
)

echo "Checking Homebrew packages..."

brew_list=$(brew list --formulae -1)

for PKG in "${PACKAGES[@]}"
do
  if ! echo "$brew_list" | grep -q "$PKG"; then
    echo "Installing $PKG..."
    brew install $PKG
  fi
done

echo "Core packages installed."

echo "Installing brewfile..."

brew bundle --file=macos/Brewfile
