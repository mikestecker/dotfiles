.PHONY: install link vscode-install vscode-save brew brew-dump brew-optional brew-restore brew-restore-fresh macos dev-setup migrate ssh-key ssh-key-create

# Run dotbot install script (includes Xcode Command Line Tools check)
install:
	./install

# Show the GitLab public key. Create the GitHub key once with: ./scripts/ssh-key.sh create github
ssh-key:
	./scripts/ssh-key.sh show gitlab

ssh-key-create:
	./scripts/ssh-key.sh create gitlab

link:
	./install --only link

# Install shared extensions into Cursor and VS Code
vscode-install:
	./scripts/sync-editor-extensions.sh

# vscode/extensions.txt is the union of both editors, with editor-specific ids commented at the bottom.
vscode-save:
	@echo "Refresh vscode/extensions.txt from: cursor --list-extensions and code --list-extensions"
	@echo "Keep the Cursor only and VS Code only sections commented at the bottom."

# macos/Brewfile is curated by hand. This does not dump or uninstall packages.
brew:
	@echo "macos/Brewfile is curated. Edit it by hand."
	@echo "Optional packages: make brew-optional"
	@echo "Inspect everything Homebrew has installed: make brew-dump"

# Write an untracked snapshot. It is not the install list.
brew-dump:
	HOMEBREW_BUNDLE_DUMP_NO_VSCODE=1 brew bundle dump -f --file=macos/Brewfile.dump
	@echo "Wrote macos/Brewfile.dump (gitignored)."

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
