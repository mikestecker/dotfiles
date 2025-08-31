#!/usr/bin/env bash
#
# Modern CLI tool aliases and shortcuts

# bat (better cat with syntax highlighting)
if type bat > /dev/null 2>&1; then
  alias cat='bat'
  alias ccat='bat --color=always'          # Force colored output
  alias bcat='bat --style=plain'           # Plain output (no line numbers/git)
  alias batl='bat --list-languages'        # List supported languages
  alias batp='bat --style=plain --paging=never' # Plain, no paging
fi

# lazygit (TUI for git)
if type lazygit > /dev/null 2>&1; then
  alias lg='lazygit'
  alias lgs='lazygit status'
fi

# tldr (simplified man pages)
if type tldr > /dev/null 2>&1; then
  alias tl='tldr'
  alias tldr-update='tldr --update'
  # Function for quick tldr with fallback to man
  mans() {
    if [[ -n "$1" ]]; then
      tldr "$1" 2>/dev/null || man "$1"
    else
      echo "Usage: mans <command>"
    fi
  }
fi

# httpie (better curl)
if type http > /dev/null 2>&1; then
  alias hget='http GET'
  alias hpost='http POST'
  alias hput='http PUT'
  alias hdelete='http DELETE'
  alias hpatch='http PATCH'
  alias hjson='http --json'
  alias hform='http --form'
  alias hdownload='http --download'

  # Quick localhost shortcuts
  alias h3000='http localhost:3000'
  alias h8000='http localhost:8000'
  alias h8080='http localhost:8080'
fi

# delta is already configured in git config, but add some shortcuts
if type delta > /dev/null 2>&1; then
  alias delta-side='delta --side-by-side'
  alias delta-line='delta --line-numbers'
fi

# Enhanced file operations with the new tools
if type bat > /dev/null 2>&1 && type fzf > /dev/null 2>&1; then
  # Preview files with bat in fzf
  alias fzfp='fzf --preview="bat --color=always --style=numbers --line-range=:500 {}"'

  # Edit files with fzf + bat preview
  cep() {
    local file
    file=$(fzf --preview="bat --color=always --style=numbers --line-range=:500 {}") && code "$file"
  }
fi

# Git + lazygit shortcuts
if type lazygit > /dev/null 2>&1; then
  # Open lazygit in current repo or specific directory
  lgg() {
    if [[ -n "$1" ]]; then
      cd "$1" && lazygit
    else
      lazygit
    fi
  }
fi

# HTTP testing shortcuts for common dev ports
if type http > /dev/null 2>&1; then
  # Next.js default
  alias hnext='http localhost:3000'
  # React dev server
  alias hreact='http localhost:3000'
  # Vue dev server
  alias hvue='http localhost:8080'
  # Express default
  alias hexpress='http localhost:3000'
  # Django default
  alias hdjango='http localhost:8000'
  # Flask default
  alias hflask='http localhost:5000'
fi

# fx (interactive JSON viewer)
if type fx > /dev/null 2>&1; then
  alias json='fx'
  alias jless='fx'
fi

# zoxide (better cd)
if type zoxide > /dev/null 2>&1; then
  alias cd='z'
  alias cdi='zi'  # interactive cd
fi

# gping (graphical ping)
if type gping > /dev/null 2>&1; then
  alias ping='gping'
fi

# wrk (HTTP benchmarking)
if type wrk > /dev/null 2>&1; then
  alias loadtest='wrk -t12 -c400 -d30s'
  alias quicktest='wrk -t4 -c100 -d10s'
fi

# commitizen (better commits)
if type cz > /dev/null 2>&1; then
  alias commit='cz commit'
  alias ccommit='cz commit'
fi
