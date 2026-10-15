.PHONY: install link vscode-install vscode-save brew brew-optional brew-restore brew-restore-fresh macos dev-setup migrate

# Run dotbot install script (includes Xcode Command Line Tools check)
install:
	./install

link:
	./install --only link

# Install shared extensions into Cursor and VS Code
vscode-install:
	./scripts/sync-editor-extensions.sh

# vscode/extensions.txt is the union of both editors, with editor-specific ids commented at the bottom.
vscode-save:
	@echo "Refresh vscode/extensions.txt from: cursor --list-extensions and code --list-extensions"
	@echo "Keep the Cursor only and VS Code only sections commented at the bottom."

# Save snapshot of Homebrew packages. Skips editor extensions (those live in vscode/extensions.txt).
# Optional packages stay in macos/Brewfile.optional and are not uninstalled by cleanup.
brew:
	HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1 brew bundle dump -f --file=macos/Brewfile
	./macos/install-optional-brews.sh --after-dump

# Ask before installing each personal package in macos/Brewfile.optional
brew-optional:
	./macos/install-optional-brews.sh

# Restore Homebrew packages
brew-restore:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew upgrade
	brew install mas
	brew bundle install --file=macos/Brewfile
	./macos/install-optional-brews.sh
	brew cleanup

# Restore Homebrew packages without cache (for fresh installs/testing)
brew-restore-fresh:
	@echo "Clearing brew cache..."
	@rm -f ~/.cache/dotfiles/brew_prefix 2>/dev/null || true
	@$(MAKE) brew-restore

# Set MacOS defaults
macos:
	./macos/set-defaults.sh

# Quick development environment setup
dev-setup:
	brew bundle install --file=macos/Brewfile
	./macos/install-optional-brews.sh
	./macos/set-defaults.sh

# Migrate existing installation from asdf to mise
migrate:
	./scripts/migrate-to-mise.sh
