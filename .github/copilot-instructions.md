# Copilot instructions

Shared runbook: [AGENTS.md](../AGENTS.md). These constraints also apply in Copilot chat, review, and cloud agents.

- This repo is symlinked into the home directory by Dotbot. A one-file check uses `./install --only link`. Run `./install` only when asked to reinstall the machine.
- Never commit private SSH keys, 1Password data, shell history, tokens, or `macos/Brewfile.dump`.
- One SSH key for GitHub and GitLab: 1Password item `Git`, public file `~/.ssh/id_git.pub`, refreshed with `make ssh-key`. Do not generate another key.
- Global git email is `mike@stecker.me` and personal commits stay unsigned. `mistecker@bbw.com` and SSH signing apply only under `~/Development/Current/`.
- mise owns Node, pnpm, and Python. `zsh/zshrc.zsh` is the only shell rc. Edit `macos/Brewfile` by hand.
- Leave submodule checkouts (`dotbot/`, `zsh/oh-my-zsh/`, `zsh/zgenom/`) unchanged unless the task is to update the gitlink.
- Commit only when asked. Change only the files the task requires.
- One-time agent-tooling setup for other repos: use [docs/AGENT_PLUGINS.md](../docs/AGENT_PLUGINS.md), then copy self-contained notes into that project (never link back to these personal dotfiles). This repo is not a storefront — do not enable Datadog here.

Workflows, each with a review before any change:

- Scratch install: `git clone --recursive https://github.com/mikestecker/dotfiles.git ~/.dotfiles`. List the install steps, including optional Homebrew y/N prompts, and run `./install` only after acceptance. Then `make ssh-key`. If the `Git` item is missing from `op`, sign in and retry. Do not run `make ssh-key-create`.
- Pull: show `git status -sb`, `git log HEAD..origin/main`, and `git diff HEAD...origin/main`. Stop when the tree is dirty or `main` has diverged. After acceptance, `git pull --ff-only origin main`, `git submodule update --init --recursive`, then `./install --only link`. A full `./install` is only for Brewfile, mise, extension, font, or install-step changes, and it prompts for optional packages.
- Push: show `git status` and `git diff`, exclude secrets, commit only after acceptance, and wait again before `git push`. Never force-push `main`.
- `make macos` is not part of install. Decline optional Homebrew prompts on a work Mac unless asked.
