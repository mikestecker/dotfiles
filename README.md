# mikestecker's dotfiles

[![Actions Status](https://github.com/mikestecker/dotfiles/workflows/Dotfiles%20Install/badge.svg)](https://github.com/mikestecker/dotfiles/actions)
[![Powered by dotbot][dbshield]][dblink]

[dblink]: https://github.com/anishathalye/dotbot
[dbshield]: https://img.shields.io/badge/powered%20by-dotbot-blue?style=flat

| Component                     | Tool                                                      | Config                                   |
| ----------------------------- | --------------------------------------------------------- | ---------------------------------------- |
| Installation                  | [Dotbot](https://github.com/anishathalye/dotbot)          | [install.conf.yaml](./install.conf.yaml) |
| Theme                         | [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | [p10k.zsh](./zsh/p10k.zsh)               |
| .zshrc                        | [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)    | [.zshrc](./zsh/zshrc.zsh)                |

## [Makefile](./Makefile)

- Install with dotbot
- Homebrew save/restore
- VS Code extension save/restore

## Usage

*Prerequisites: python, git, zsh*

### Installation

```sh
git clone git@github.com:mikestecker/dotfiles.git .dotfiles --recursive
cd .dotfiles
make install
```

### Other Tasks

*[See Makefile](./Makefile)*
