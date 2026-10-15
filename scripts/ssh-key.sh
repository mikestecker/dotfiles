#!/usr/bin/env bash
# Create or show an SSH public key stored in 1Password.
# The private key is never written to disk or to this repo.
set -euo pipefail

AGENT_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
ACTION="show"
HOST_NAME="gitlab"
TITLE=""
PUB=""
LEGACY=""

usage() {
  cat <<EOF
Usage: ./scripts/ssh-key.sh [show|create] [gitlab|github]

  show    Print the public key and write the .pub file. Copies it to the clipboard.
  create  Create an Ed25519 key in 1Password when that item does not exist.

  gitlab  1Password item "GitLab", writes ~/.ssh/id_gitlab.pub (default)
  github  1Password item "GitHub", writes ~/.ssh/id_github.pub

GitLab and GitHub are personal accounts. A work address is an extra email on
the account, not a separate key. Create the GitHub key once with:

  ./scripts/ssh-key.sh create github

On a new machine, sign in to 1Password and turn on Settings > Developer > SSH agent.
EOF
}

select_host() {
  case "$1" in
    gitlab)
      TITLE="GitLab"
      PUB="$HOME/.ssh/id_gitlab.pub"
      LEGACY="$HOME/.ssh/id_bbw"
      ;;
    github)
      TITLE="GitHub"
      PUB="$HOME/.ssh/id_github.pub"
      LEGACY=""
      ;;
    *)
      echo "Unknown host \"$1\". Use gitlab or github." >&2
      usage >&2
      exit 1
      ;;
  esac
}

need_op() {
  if ! command -v op >/dev/null 2>&1; then
    echo "1Password CLI (op) is not installed. Install it with: brew install --cask 1password-cli" >&2
    exit 1
  fi
}

item_exists() {
  op item get "$TITLE" >/dev/null 2>&1
}

public_key() {
  op item get "$TITLE" --fields 'label=public key' --format json \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)[0]["value"])'
}

write_pub() {
  local key="$1"
  mkdir -p "$(dirname "$PUB")"
  chmod 700 "$(dirname "$PUB")"
  printf '%s\n' "$key" > "$PUB"
  chmod 644 "$PUB"
}

agent_hint() {
  if [[ -S "$AGENT_SOCK" ]]; then
    return
  fi
  cat <<EOF
1Password SSH agent is off. On this Mac, in Settings > Developer:
  • Turn on Use the SSH agent
  • Turn on Integrate with 1Password CLI
  • Leave Generate SSH config file with bookmarked hosts off
Then authorize "$TITLE" for the agent and run this script again.
EOF
}

github_hint() {
  if [[ "$HOST_NAME" == "gitlab" && ! -f "$HOME/.ssh/id_github.pub" ]]; then
    echo "GitHub key not written yet. Create it once with: ./scripts/ssh-key.sh create github"
  fi
}

show_key() {
  need_op
  if ! item_exists; then
    echo "No 1Password item named \"$TITLE\"." >&2
    if [[ -n "$LEGACY" && -f "$LEGACY" ]]; then
      echo "Import the existing key once: 1Password > New Item > SSH Key > Import $LEGACY, and name it \"$TITLE\"." >&2
      echo "Then run this script again. The key already on GitLab keeps working." >&2
    elif [[ "$HOST_NAME" == "github" ]]; then
      echo "Create one with: ./scripts/ssh-key.sh create github" >&2
    else
      echo "Create one with: ./scripts/ssh-key.sh create gitlab" >&2
    fi
    if [[ -f "$PUB" ]]; then
      echo >&2
      echo "Local public key:" >&2
      cat "$PUB"
    fi
    exit 1
  fi

  local key
  key="$(public_key)"
  write_pub "$key"
  printf '%s\n' "$key"
  if command -v pbcopy >/dev/null 2>&1; then
    printf '%s\n' "$key" | pbcopy
    echo "Copied to the clipboard. Paste it into ${HOST_NAME}."
  fi
  echo "Public key written to $PUB"
  agent_hint
  github_hint
}

create_key() {
  need_op
  if item_exists; then
    echo "\"$TITLE\" already exists. Showing that public key."
    show_key
    return
  fi
  op item create --category ssh --title "$TITLE" --ssh-generate-key ed25519 >/dev/null
  echo "Created \"$TITLE\" in 1Password."
  show_key
}

for arg in "$@"; do
  case "$arg" in
    show|create) ACTION="$arg" ;;
    gitlab|github) HOST_NAME="$arg" ;;
    -h|--help|help)
      usage
      exit 0
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
done

select_host "$HOST_NAME"

case "$ACTION" in
  show) show_key ;;
  create) create_key ;;
esac
