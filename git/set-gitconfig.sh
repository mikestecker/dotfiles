#!/usr/bin/env bash
# shellcheck disable=SC2016

# Name
git config --global user.name "Mike Stecker"

# Set git global settings
git config --global core.autocrlf false # Don't convert line endings
git config --global core.whitespace cr-at-eol # Don't allow trailing whitespace
git config --global push.default current # Push to the current branch
git config --global push.autoSetupRemote true # Automatically set the remote
git config --global push.followTags true # Follow tags when pushing
git config --global pull.rebase true # Rebase when pulling
git config --global rebase.autoStash true # Stash when rebasing
git config --global status.short true # Show short status
git config --global status.branch true # Show branch in status
git config --global branch.autoSetupMerge true # Automatically set the merge branch
git config --global init.defaultBranch main # Set the default branch to main

# Set aliases in .gitconfig
git config --global alias.last 'log -1 HEAD' # Show the last commit
git config --global alias.unstage 'reset HEAD --' # Unstage changes
git config --global alias.hist 'log --oneline --graph --decorate --all' # Show the commit history
git config --global alias.stu 'status -uno' # Show the status of the working directory
git config --global alias.st 'status' # Show the status of the repository
git config --global alias.unp 'log origin/master..HEAD' # Show the changes that have been pushed
git config --global alias.subup 'submodule update --remote --merge' # Update the submodules
git config --global alias.aliases "config --get-regexp '^alias\.'" # Show the aliases
git config --global alias.pom 'push origin master' # Push to the master branch
git config --global alias.undolast 'reset HEAD~1' # Reset the last commit
git config --global alias.revertlast 'revert HEAD' # Revert the last commit
git config --global alias.editlast 'commit --amend -m' # Edit the last commit
git config --global alias.pr '!f() { git fetch -fu ${2:-$(git remote |grep ^upstream || echo origin)} refs/pull/$1/head:pr/$1 && git checkout pr/$1; }; f' # Fetch and checkout a pull request
git config --global alias.pr-clean '!git for-each-ref refs/heads/pr/* --format="%(refname)" | while read ref ; do branch=${ref#refs/heads/} ; git branch -D $branch ; done' # Clean up pull requests
git config --global alias.fzau '!git ls-files -m --exclude-standard | fzf -m --print0 --preview-window down,90% --preview "git diff $@ -- {-1} | delta" | xargs -0 -o -t git add -p' # Add files to the staging area
git config --global alias.fza '!git ls-files -m -o --exclude-standard | fzf -m --print0 --preview-window down,90% --preview "git diff $@ -- {-1} | delta" | xargs -0 -o -t git add -p' # Add files to the staging area
git config --global alias.authors 'shortlog -s -n -e --all --no-merges' # Show the authors

## Find most recent common ancestor between HEAD and another branch
git config --global alias.find-base '!f() { git merge-base HEAD $1 | xargs git l3; }; f'

# Frontend development specific aliases
git config --global alias.feature '!f() { git checkout -b feature/$1; }; f' # Create feature branch
git config --global alias.hotfix '!f() { git checkout -b hotfix/$1; }; f' # Create hotfix branch
git config --global alias.cleanup '!f() { git branch --merged | grep -v "\\*\\|main\\|master\\|develop" | xargs -n 1 git branch -d; }; f' # Clean merged branches
git config --global alias.pushf 'push --force-with-lease' # Safer force push
git config --global alias.amend 'commit --amend --no-edit' # Quick amend
git config --global alias.fixup '!f() { git commit --fixup $1; }; f' # Fixup commit
git config --global alias.squash-all '!f() { git reset --soft $(git merge-base HEAD $1) && git commit; }; f' # Squash all commits

# Fancy Logs
git config --global alias.l 'log --oneline --graph --decorate --all' # Show the commit history
git config --global alias.l1 "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(blue)<%an>%Creset%C(yellow)%d%Creset' --all" # Show the commit history
git config --global alias.l2 "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all" # Show the commit history
git config --global alias.l3 "log --abbrev=7 --format='%C(bold cyan)%h%Creset %s %Cgreen(%cr) %C(blue)<%<(8,trunc)%an>%Creset%C(yellow)%d%Creset'" # Show the commit history

# Zsh plugins
git config --global alias.editlast "commit --amend -m" # Make sure to unstage all first!
git config --global alias.sync "!zsh -ic git-sync" # Sync the repository
git config --global alias.add-upstream "!zsh -ic add-upstream" # Add the upstream branch
git config --global alias.trav "!zsh -ic git-trav" # Travel to a branch

# Check for git email configuration
if [[ -z $(git config --global --get user.email) ]]; then
  echo "⚠️  Git email not configured."
  echo "📧 To set your email, run: git config --global user.email 'your-email@example.com'"
  echo "✅ Installation continuing..."
fi

# Delta

git config --global pager.diff delta
git config --global pager.log delta
git config --global pager.reflog delta
git config --global pager.show delta

git config --global delta.plus-style 'syntax #012800'
git config --global delta.plus-emph-style 'syntax #1B421A'
git config --global delta.minus-style 'syntax #340001'
git config --global delta.minus-emph-style 'syntax #4E1A1B'

git config --global delta.file-decoration-style 'blue box'
git config --global delta.hunk-header-style 'omit'

git config --global delta.navigate 'syntax #340001'
git config --global delta.navigate true
git config --global delta.syntax-theme 'Solarized (dark)'
git config --global delta.line-numbers true

git config --global interactive.diffFilter 'delta --color-only'
