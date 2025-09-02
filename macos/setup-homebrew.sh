#!/usr/bin/env bash
set -e  # Exit on error
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
  # Temporarily disable exit on error for Homebrew installation
  set +e
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  homebrew_exit_code=$?
  set -e

  # Add Homebrew to PATH for current session
  echo "Setting up Homebrew PATH..."
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # Check if brew is now available
  if ! type brew > /dev/null 2>&1; then
    echo "❌ Homebrew installation may have failed. Continuing with manual setup..."
    echo "📝 If brew commands fail, please install Homebrew manually:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    echo "   Then restart the installation with: make install"
    # Don't exit here, let the process continue to see what else works
  else
    echo "✅ Homebrew installed successfully"
  fi
fi

# Ensure brew is in PATH
if ! type brew > /dev/null 2>&1; then
  echo "Setting up Homebrew PATH..."
  if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_UPGRADE=1

PACKAGES=(
  "mise"
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

if type brew > /dev/null 2>&1; then
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
else
  echo "⚠️  Homebrew not available, skipping package installation"
  echo "📝 Please install Homebrew manually and re-run: make install"
fi
