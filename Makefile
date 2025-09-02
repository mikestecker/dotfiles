.PHONY: install link vscode-install vscode-save brew brew-restore brew-restore-fresh macos dev-setup migrate

# Run dotbot install script (includes Xcode Command Line Tools check)
install:
	./install

link:
	./install --only link

# Install extensions from vscode/extensions.txt
vscode-install:
	cat ${DOTFILES}/vscode/extensions.txt | xargs -L 1 code --install-extension

# Save all current extensions to vscode/extensions.txt
vscode-save:
	code --list-extensions > ${DOTFILES}/vscode/extensions.txt

# Save snapshot of all Homebrew packages to macos/Brewfile
brew:
	brew bundle dump -f --file=macos/Brewfile
	brew bundle --force cleanup --file=macos/Brewfile

# Restore Homebrew packages
brew-restore:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew upgrade
	brew install mas
	brew bundle install --file=macos/Brewfile
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
	./macos/set-defaults.sh

# Migrate existing installation from asdf to mise
migrate:
	./scripts/migrate-to-mise.sh
