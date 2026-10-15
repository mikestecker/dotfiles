#!/usr/bin/env bash
# Create or show the SSH public key stored in 1Password.
# The private key is never written to disk or to this repo.
set -euo pipefail

TITLE="${SSH_KEY_TITLE:-BBW GitLab}"
PUB="${SSH_PUB_FILE:-$HOME/.ssh/id_bbw.pub}"
AGENT_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

usage() {
  cat <<EOF
Usage: ./scripts/ssh-key.sh [show|create]

  show    Print the public key from the "$TITLE" 1Password item and
          write it to $PUB. Copies it to the clipboard on macOS.
  create  Create an Ed25519 key in 1Password when that item does not exist,
          then show the public key.

Paste the public key into GitLab and GitHub. The key item syncs with your
1Password account. These Developer settings are per Mac and stay out of git:

  On:  Use the SSH agent
  On:  Integrate with 1Password CLI
  Off: Generate SSH config file with bookmarked hosts

Leave that last one off. This repo already owns ~/.ssh/config.
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

show_key() {
  need_op
  if ! item_exists; then
    echo "No 1Password item named \"$TITLE\"." >&2
    if [[ -f "$HOME/.ssh/id_bbw" ]]; then
      echo "Import the existing key once: 1Password > New Item > SSH Key > Import ~/.ssh/id_bbw, and name it \"$TITLE\"." >&2
      echo "Then run this script again. The key already on GitLab keeps working." >&2
    else
      echo "Create one with: ./scripts/ssh-key.sh create" >&2
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
    echo "Copied to the clipboard. Paste it into GitLab and GitHub."
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
  op item create --category ssh --title "$TITLE" --ssh-generate-key ed25519 >/dev/null
  echo "Created \"$TITLE\" in 1Password."
  show_key
}

case "${1:-show}" in
  show) show_key ;;
  create) create_key ;;
  -h|--help|help) usage ;;
  *)
    usage >&2
    exit 1
    ;;
esac
