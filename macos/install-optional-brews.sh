#!/usr/bin/env bash
# Prompt for each entry in macos/Brewfile.optional.
# With --after-dump, keep those entries out of a freshly dumped Brewfile
# and include them when cleaning up, so personal apps are not uninstalled.

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FILE="$ROOT/macos/Brewfile.optional"
MAIN="$ROOT/macos/Brewfile"

entries() {
  [[ -f "$FILE" ]] || return 0
  local line kind token desc
  while IFS= read -r line || [[ -n "$line" ]]; do
    [[ "$line" =~ ^[[:space:]]*(brew|cask)[[:space:]]+\"([^\"]+)\"[[:space:]]*(#[[:space:]]*(.*))?$ ]] || continue
    kind="${BASH_REMATCH[1]}"
    token="${BASH_REMATCH[2]}"
    desc="${BASH_REMATCH[4]:-}"
    printf '%s\t%s\t%s\n' "$kind" "$token" "$desc"
  done < "$FILE"
}

installed() {
  local kind="$1"
  local token="$2"
  local short="${token##*/}"
  if [[ "$kind" == "cask" ]]; then
    brew list --cask "$short" >/dev/null 2>&1
  else
    brew list --formula "$short" >/dev/null 2>&1
  fi
}

strip_from_dump() {
  [[ -f "$MAIN" && -f "$FILE" ]] || return 0
  local kind token desc short tmp
  tmp="$(mktemp)"
  cp "$MAIN" "$tmp"
  while IFS=$'\t' read -r kind token desc; do
    short="${token##*/}"
    grep -v -E "^(brew|cask) \"(${token}|${short})\"" "$tmp" > "${tmp}.next"
    mv "${tmp}.next" "$tmp"
  done < <(entries)
  mv "$tmp" "$MAIN"
}

cleanup_keep_optional() {
  local combined
  combined="$(mktemp)"
  cat "$MAIN" "$FILE" > "$combined"
  brew bundle --force cleanup --file="$combined"
  rm -f "$combined"
}

if [[ "${1:-}" == "--after-dump" ]]; then
  strip_from_dump
  cleanup_keep_optional
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not available, skipping optional packages."
  exit 0
fi

if [[ ! -t 0 ]]; then
  echo "Skipping optional Homebrew packages (no interactive terminal)."
  echo "Install them later with: make brew-optional"
  exit 0
fi

echo "Optional Homebrew packages. y installs one package; any other answer skips it."
echo

while IFS=$'\t' read -r kind token desc; do
  short="${token##*/}"
  [[ -n "$desc" ]] || desc="no description"
  if installed "$kind" "$token"; then
    printf 'Already installed: %s — %s\n' "$short" "$desc"
    continue
  fi

  printf 'Install %s — %s? [y/N] ' "$short" "$desc"
  read -r answer
  case "$answer" in
    y|Y|yes|YES)
      if [[ "$kind" == "cask" ]]; then
        brew install --cask "$token" || echo "Failed to install $token"
      else
        brew install "$token" || echo "Failed to install $token"
      fi
      ;;
    *)
      echo "Skipped $short"
      ;;
  esac
done < <(entries)
