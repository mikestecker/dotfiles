#!/usr/bin/env bash
set -e

echo "🔄 =============================================="
echo "🚀 Migrating dotfiles from asdf to mise..."
echo "🔄 =============================================="
echo ""

# Check what tool managers are present
HAS_ASDF=false
HAS_NVM=false

if command -v asdf >/dev/null 2>&1; then
  HAS_ASDF=true
fi

if command -v nvm >/dev/null 2>&1 || [[ -s "$HOME/.nvm/nvm.sh" ]] || [[ -f "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
  HAS_NVM=true
fi

if [[ "$HAS_ASDF" == false && "$HAS_NVM" == false ]]; then
  echo "✅ No asdf or nvm found - migration not needed"
  echo "💡 Run 'make install' to set up mise"
  exit 0
fi

echo "🔍 Detected tool managers:"
if [[ "$HAS_ASDF" == true ]]; then
  echo "  • asdf found"
fi
if [[ "$HAS_NVM" == true ]]; then
  echo "  • nvm found"
fi
echo ""

# Show current tools
if [[ "$HAS_ASDF" == true ]]; then
  echo "📋 Current asdf tools:"
  asdf list || echo "No asdf tools installed"
  echo ""
fi

if [[ "$HAS_NVM" == true ]]; then
  echo "📋 Current nvm Node.js versions:"
  if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    source "$HOME/.nvm/nvm.sh"
    nvm list || echo "No nvm versions installed"
  elif [[ -f "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
    nvm list || echo "No nvm versions installed"
  else
    echo "nvm detected but not properly sourced"
  fi
  echo ""
fi

# Install mise if not present
if ! command -v mise >/dev/null 2>&1; then
  echo "📦 Installing mise..."
  if command -v brew >/dev/null 2>&1; then
    brew install mise
  else
    echo "❌ Homebrew not found. Please install Homebrew first."
    exit 1
  fi
fi

# Migrate Node.js versions
echo "🔄 Migrating Node.js versions..."

# Check current versions from both tools
CURRENT_NODE=""
FOUND_VERSIONS=false

if [[ "$HAS_ASDF" == true ]] && asdf list nodejs 2>/dev/null | grep -q '.*'; then
  echo "📋 Found asdf Node.js versions:"
  asdf list nodejs
  CURRENT_NODE=$(asdf current nodejs 2>/dev/null | awk '{print $2}' || echo "")
  FOUND_VERSIONS=true
fi

if [[ "$HAS_NVM" == true ]]; then
  echo "📋 Found nvm Node.js versions:"
  if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    source "$HOME/.nvm/nvm.sh"
    nvm list 2>/dev/null || echo "No nvm versions found"
    CURRENT_NVM=$(nvm current 2>/dev/null || echo "")
    if [[ "$CURRENT_NVM" != "none" && "$CURRENT_NVM" != "" ]]; then
      CURRENT_NODE="$CURRENT_NVM"
      FOUND_VERSIONS=true
    fi
  elif [[ -f "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
    nvm list 2>/dev/null || echo "No nvm versions found"
    CURRENT_NVM=$(nvm current 2>/dev/null || echo "")
    if [[ "$CURRENT_NVM" != "none" && "$CURRENT_NVM" != "" ]]; then
      CURRENT_NODE="$CURRENT_NVM"
      FOUND_VERSIONS=true
    fi
  fi
fi

if [[ "$FOUND_VERSIONS" == true ]]; then
  echo "Current Node.js: ${CURRENT_NODE:-"none detected"}"
  echo "📦 Installing Node.js LTS and latest with mise..."
  mise install node@lts
  mise install node@latest
  mise use --global node@lts
else
  echo "📦 No Node.js versions found, installing fresh..."
  mise install node@lts
  mise install node@latest
  mise use --global node@lts
fi

# Migrate pnpm
echo "🔄 Migrating pnpm..."
if asdf list pnpm 2>/dev/null | grep -q '.*'; then
  echo "📋 Found asdf pnpm versions:"
  asdf list pnpm
fi

echo "📦 Installing pnpm latest with mise..."
mise install pnpm@latest
mise use --global pnpm@latest

echo ""
echo "🧹 Cleanup recommendations..."

# Backup shell configuration
ZSHRC="$HOME/.zshrc"
NEEDS_BACKUP=false

if [[ -f "$ZSHRC" ]]; then
  if [[ "$HAS_ASDF" == true ]] && grep -q "asdf" "$ZSHRC"; then
    NEEDS_BACKUP=true
  fi
  if [[ "$HAS_NVM" == true ]] && (grep -q "nvm" "$ZSHRC" || grep -q "NVM_DIR" "$ZSHRC"); then
    NEEDS_BACKUP=true
  fi
fi

if [[ "$NEEDS_BACKUP" == true ]]; then
  echo "🔧 Backing up .zshrc..."
  cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d)"
  echo "✅ Backup created at $ZSHRC.backup.$(date +%Y%m%d)"
fi

# Cleanup recommendations
echo ""
echo "🗑️  Manual cleanup recommendations (after verifying mise works):"

if [[ "$HAS_ASDF" == true && -d "$HOME/.asdf" ]]; then
  echo "   • Remove asdf directory: rm -rf ~/.asdf"
  echo "   • Uninstall asdf from Homebrew: brew uninstall asdf"
  echo "   • Remove asdf references from $ZSHRC"
fi

if [[ "$HAS_NVM" == true ]]; then
  if [[ -d "$HOME/.nvm" ]]; then
    echo "   • Remove nvm directory: rm -rf ~/.nvm"
  fi
  if brew list nvm &>/dev/null; then
    echo "   • Uninstall nvm from Homebrew: brew uninstall nvm"
  fi
  echo "   • Remove nvm references from $ZSHRC (NVM_DIR, nvm.sh sourcing)"
fi

echo ""
echo "✅ =============================================="
echo "🎉 Migration to mise completed!"
echo "✅ =============================================="
echo ""
echo "📋 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. Verify tools work: node --version && pnpm --version"
echo "   3. Check tool status: mise ls"
echo "   4. Follow cleanup recommendations above (optional)"
echo ""
echo "💡 Your Node.js and pnpm are now managed by mise!"
echo "   • Use 'mise ls' to see installed tools"
echo "   • Use 'mise use node@20' for project-specific versions"
echo "   • Much faster than both asdf and nvm! 🚀"
echo ""
