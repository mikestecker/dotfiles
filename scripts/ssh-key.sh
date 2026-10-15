#!/usr/bin/env bash
# Show or create the one SSH key used for both GitLab and GitHub.
# The private key is never written by this script and is not stored in git.
set -euo pipefail

TITLE="${SSH_KEY_TITLE:-Git}"
PUB="${SSH_PUB_FILE:-$HOME/.ssh/id_git.pub}"
AGENT_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
ACTION="show"

usage() {
  cat <<EOF
Usage: ./scripts/ssh-key.sh [show|create]

  show    Print the public key from the "$TITLE" 1Password item and
          write it to $PUB. Copies it to the clipboard on macOS.
  create  Create an Ed25519 key in 1Password when that item does not exist.

GitLab and GitHub already trust this one public key. On a new computer,
sign in to 1Password, turn on Settings > Developer > SSH agent, then run
show. Keys in the Private vault are offered by the agent. Do not create
a second key.

Import the current key once, if it is not in 1Password yet:
  1Password > New Item > SSH Key > Import ~/.ssh/id_git
  Name the item "$TITLE".
EOF
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
    | python3 -c 'import json,sys; data=json.load(sys.stdin); print((data[0] if isinstance(data, list) else data)["value"])'
}

write_pub() {
  local key="$1"
  mkdir -p "$(dirname "$PUB")"
  chmod 700 "$(dirname "$PUB")"
  printf '%s\n' "$key" > "$PUB"
  chmod 600 "$PUB"
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
Keys in the Private vault are offered automatically. Confirm with:
  SSH_AUTH_SOCK="$AGENT_SOCK" ssh-add -l
EOF
}

show_key() {
  need_op
  if ! item_exists; then
    echo "No 1Password item named \"$TITLE\"." >&2
    if [[ -f "$HOME/.ssh/id_git" ]]; then
      echo "Import ~/.ssh/id_git once and name the item \"$TITLE\". The Private vault entry in the SSH agent config offers it." >&2
      echo "GitLab and GitHub already have this public key, so a new computer can use the same item." >&2
    else
      echo "Create one with: ./scripts/ssh-key.sh create" >&2
      echo "Then add the public key to both GitLab and GitHub." >&2
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
    echo "Copied to the clipboard. It belongs on both GitLab and GitHub."
  fi
  echo "Public key written to $PUB"
  agent_hint
}

create_key() {
  need_op
  if item_exists; then
    echo "\"$TITLE\" already exists. Showing that public key."
    show_key
    return
  fi
  if [[ -f "$HOME/.ssh/id_git" ]]; then
    echo "A local key already exists at ~/.ssh/id_git." >&2
    echo "Import that key into 1Password as \"$TITLE\" instead of creating a new one." >&2
    echo "A new key would need to be added to GitLab and GitHub again." >&2
    exit 1
  fi
  op item create --category ssh --title "$TITLE" --ssh-generate-key ed25519 >/dev/null
  echo "Created \"$TITLE\" in 1Password. Add this public key to both GitLab and GitHub."
  show_key
}

for arg in "$@"; do
  case "$arg" in
    show|create) ACTION="$arg" ;;
    gitlab|github) ;;
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

case "$ACTION" in
  show) show_key ;;
  create) create_key ;;
esac
