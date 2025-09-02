# mikestecker's dotfiles

[![Actions Status](https://github.com/mikestecker/dotfiles/workflows/Dotfiles%20Install/badge.svg)](https://github.com/mikestecker/dotfiles/actions)
[![Powered by dotbot][dbshield]][dblink]

[dblink]: https://github.com/anishathalye/dotbot
[dbshield]: https://img.shields.io/badge/powered%20by-dotbot-blue?style=flat

> Personal dotfiles configuration

![Image](preview.png)

| Component                     | Tool                                                      | Config                                   |
| ----------------------------- | --------------------------------------------------------- | ---------------------------------------- |
| Installation                  | [Dotbot](https://github.com/anishathalye/dotbot)          | [install.conf.yaml](./install.conf.yaml) |
| Theme                         | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | [p10k.zsh](./zsh/p10k.zsh)               |
| .zshrc                        | [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)    | [.zshrc](./zsh/zshrc.zsh)                |
| Development Tools             | [mise](https://github.com/jdx/mise)                       | Global: `mise use --global node@lts pnpm@latest` |
| Modern CLI Tools              | [bat](https://github.com/sharkdp/bat), [lazygit](https://github.com/jesseduffield/lazygit), [httpie](https://httpie.io/) | [aliases/](./aliases/)                   |
| Font                          | Operator Mono Nerd Font                                   | [fonts/](./fonts/)                      |

## [Makefile](./Makefile)

- Install with dotbot
- Homebrew save/restore
- VS Code extension save/restore
- Frontend development environment setup
- macOS defaults optimization

## Development Tools Management

### mise - Modern Tool Version Manager

[mise](https://github.com/jdx/mise) replaces asdf/nvm with a faster, more modern approach:

```bash
# Install and use Node.js versions
mise use node@lts          # Use Node.js LTS in current project
mise use --global node@lts # Set Node.js LTS globally
mise install node@20       # Install specific version

# Install multiple tools
mise use --global node@lts pnpm@latest

# Project-specific versions (creates .mise.toml)
mise use node@20 pnpm@9
```

**Benefits over asdf:**

- ⚡ **Faster** - Rust-based, no shell overhead
- 🎯 **No shims** - Direct paths to binaries
- 🔧 **Built-in tasks** - Replace some Makefile functionality
- 📦 **Better Node.js** - First-class pnpm integration

## Modern CLI Tools & Aliases

Enhanced command-line experience with modern alternatives to traditional tools:

### Core Tools

- **[bat](https://github.com/sharkdp/bat)** - Better `cat` with syntax highlighting (`cat` → `bat`)
- **[lazygit](https://github.com/jesseduffield/lazygit)** - Terminal UI for git (`lg`)
- **[httpie](https://httpie.io/)** - Better HTTP client (`hget`, `hpost`, etc.)
- **[tldr](https://tldr.sh/)** - Simplified man pages (`tl`, `mans`)
- **[delta](https://github.com/dandavison/delta)** - Better git diff (configured in git)
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter cd command (`z`)
- **[fx](https://github.com/antonmedv/fx)** - Interactive JSON viewer (`json`)
- **[Rectangle](https://rectangleapp.com/)** - Window management for development

### Key Aliases

```bash
# File operations
cat file.js        # Uses bat with syntax highlighting
fzfp               # fzf with bat preview

# Git workflow  
lg                 # Open lazygit TUI
lgg ~/project      # Open lazygit in specific directory

# HTTP testing
hget api.github.com/users/mikestecker
hnext              # Quick test localhost:3000
hreact             # Quick test localhost:3000

# Documentation
tl git             # Quick tldr for git
mans docker        # Try tldr first, fallback to man

# Development utilities
z ~/projects       # Smart cd with zoxide
json data.json     # Interactive JSON viewer
loadtest http://localhost:3000  # HTTP load testing
```

*See [aliases/modern-cli.aliases.sh](./aliases/modern-cli.aliases.sh) for complete list*

## Performance Optimizations

**High-performance shell configuration** with lazy loading and caching (default):

- **75%+ faster startup** (0.24s vs 0.97s)
- **Cached expensive operations** (brew prefix, path resolution)
- **Lazy loading** for NVM, rbenv, and heavy plugins
- **Background loading** of non-essential components

```bash
# Benchmark your shell performance
./scripts/benchmark-zsh

# Revert to original configuration if needed
cp zsh/zshrc-original.zsh zsh/zshrc.zsh
```

*See [docs/PERFORMANCE.md](./docs/PERFORMANCE.md) for detailed information*

## Frontend Development Features

**Optimized for React/Frontend development workflows:**

- **Environment Management**: [direnv](https://direnv.net/) for automatic .env loading
- **Window Management**: [Rectangle](https://rectangleapp.com/) for development layouts
- **JSON Processing**: Interactive JSON viewer with fx
- **HTTP Testing**: Load testing with wrk and API testing with httpie
- **Git Workflow**: Frontend-specific aliases and conventional commits
- **macOS Optimization**: Developer-focused system defaults

```bash
# Frontend development shortcuts
make dev-setup     # Install tools + set macOS defaults
make macos         # Apply macOS defaults only

# Project environment (with direnv)
cd my-react-app    # Automatically loads .env and project settings
z my-proj          # Smart cd with zoxide (remembers frecency)

# Window management (Rectangle)
⌃⌥←               # Snap window to left half (browser)
⌃⌥→               # Snap window to right half (editor)
```

*See [docs/RECTANGLE_SETUP.md](./docs/RECTANGLE_SETUP.md) for window management guide*

## Usage

*Prerequisites: macOS (fresh installation supported)*

### Installation

#### Fresh macOS Setup

```sh
# 1. Install Xcode Command Line Tools first (required for git)
xcode-select --install

# 2. Clone the repository after installation completes
git clone https://github.com/mikestecker/dotfiles.git .dotfiles --recursive
cd .dotfiles

# 3. Install everything
make install

# Or for frontend-focused setup
make dev-setup
```

#### Existing Development Machine

```sh
# Clone and install (Xcode CLI Tools check included)
git clone https://github.com/mikestecker/dotfiles.git .dotfiles --recursive
cd .dotfiles
make install
```

**Note**: On fresh macOS installations, you must install Xcode Command Line Tools manually first to get `git`. The dotfiles installation will handle everything else automatically.

**Post-Installation**: Set your git email with `git config --global user.email 'your-email@example.com'` before making commits.

**If Homebrew Installation Fails**: Run `make brew-restore-fresh` manually after setting up Homebrew, then retry `make install`.

### Other Tasks

*[See Makefile](./Makefile)*

### System Preferences

- Appearance
  - Dark Mode
- Show Scroll Bars -> "Always"
  - Ugly, but better for web development
- Dock
  - Remove most applications from Dock
  - Automatic Hide
  - Smaller Dock
  - "Show recent applications in Dock" -> off
  - "Show indicators for open applications" -> on
  - Battery -> "Show Percentage"
- Display
  - Nightshift
- Security
  - Touch ID
- Notifications
  - Off, except for Calendar
- Siri
  - Disabled
- Trackpad
  - Tap to Click
  - Point & Click -> Look up & data detectors off
  - More Gestures -> Notification Centre off
- Keyboard
  - Text
    - disable "Capitalize word automatically"
    - disable "Add full stop with double-space"
    - disable "Use smart quotes and dashes"
    - use " for double quotes
    - use ' for single quotes
- Mission Control
  - Hot Corners: disable all
- Finder
  - General
    - New Finder windows show: [Downloads]
    - Show these items on the desktop: disable all
  - Sidebar
    - activate all Favorites
    - move Library to Favorites
  - Show only:
    - Desktop
    - Downloads
    - Documents
    - [User]
    - Library
- Advanced
  - Show all Filename Extensions
  - Remove Items from Bin after 30 Days
  - View -> Show Preview (e.g. image files)
- Sharing
  - "Change computer name"
  - Also terminal:
    - `sudo scutil --set ComputerName "newname"`
    - `sudo scutil --set LocalHostName "newname"`
    - `sudo scutil --set HostName "newname"`
  - "Make sure all file sharing is disabled"
- Security and Privacy
  - Turn on FileVault
  - Add Browser to "Screen Recording"
- Storage
  - Remove Garage Band & Sound Library
  - Remove iMovie
- Trackpad
  - Speed: Max
- Accessibility
  - Scroll Speed: Max
