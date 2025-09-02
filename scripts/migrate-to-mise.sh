#!/usr/bin/env bash
set -e

echo "🔄 =============================================="
echo "🚀 Migrating dotfiles from asdf to mise..."
echo "🔄 =============================================="
echo ""

# Check if this is needed
if ! command -v asdf >/dev/null 2>&1; then
  echo "✅ No asdf found - migration not needed"
  echo "💡 Run 'make install' to set up mise"
  exit 0
fi

echo "📋 Current asdf tools:"
asdf list || echo "No asdf tools installed"
echo ""

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
if asdf list nodejs 2>/dev/null | grep -q '.*'; then
  echo "📋 Found asdf Node.js versions:"
  asdf list nodejs

  # Get current global version
  CURRENT_NODE=$(asdf current nodejs 2>/dev/null | awk '{print $2}' || echo "")
  echo "Current global Node.js: ${CURRENT_NODE:-"none"}"

  # Install LTS and latest with mise
  echo "📦 Installing Node.js LTS and latest with mise..."
  mise install node@lts
  mise install node@latest
  mise use --global node@lts
else
  echo "📦 No asdf Node.js versions found, installing fresh..."
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
echo "🧹 Cleaning up asdf..."

# Remove asdf from shell configuration (if present)
ZSHRC="$HOME/.zshrc"
if [[ -f "$ZSHRC" ]] && grep -q "asdf" "$ZSHRC"; then
  echo "🔧 Backing up .zshrc..."
  cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d)"
  echo "⚠️  Please manually remove asdf references from $ZSHRC"
  echo "   We've created a backup at $ZSHRC.backup.$(date +%Y%m%d)"
fi

# Remove asdf directory (optional - let user decide)
if [[ -d "$HOME/.asdf" ]]; then
  echo ""
  echo "🗑️  asdf directory found at ~/.asdf"
  echo "   You can safely remove it after verifying mise works:"
  echo "   rm -rf ~/.asdf"
fi

echo ""
echo "✅ =============================================="
echo "🎉 Migration to mise completed!"
echo "✅ =============================================="
echo ""
echo "📋 Next steps:"
echo "   1. Restart your terminal or run: source ~/.zshrc"
echo "   2. Verify tools work: node --version && pnpm --version"
echo "   3. Remove ~/.asdf directory if everything works"
echo "   4. Optionally uninstall asdf from Homebrew: brew uninstall asdf"
echo ""
echo "💡 Your Node.js and pnpm are now managed by mise!"
echo "   • Use 'mise ls' to see installed tools"
echo "   • Use 'mise use node@20' for project-specific versions"
echo ""
