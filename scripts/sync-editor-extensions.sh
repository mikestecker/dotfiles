#!/usr/bin/env bash
# Install vscode/extensions.txt into Cursor and VS Code.
# Uncommented ids go to both editors. Commented ids under the
# "Cursor only" and "VS Code only" headings go to that editor.

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIST="$ROOT/vscode/extensions.txt"

if [[ ! -f "$LIST" ]]; then
  echo "Missing $LIST"
  exit 1
fi

section="shared"
shared=()
cursor_only=()
code_only=()

while IFS= read -r line || [[ -n "$line" ]]; do
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"
  [[ -z "$line" ]] && continue

  if [[ "$line" == "# Cursor only"* ]]; then
    section="cursor"
    continue
  fi
  if [[ "$line" == "# VS Code only"* ]]; then
    section="code"
    continue
  fi

  if [[ "$line" == \#* ]]; then
    id="${line#\#}"
    id="${id#"${id%%[![:space:]]*}"}"
    if [[ "$id" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
      case "$section" in
        cursor) cursor_only+=("$id") ;;
        code) code_only+=("$id") ;;
      esac
    fi
    continue
  fi

  if [[ "$line" =~ ^[A-Za-z0-9][A-Za-z0-9._-]*$ ]]; then
    shared+=("$line")
  fi
done < "$LIST"

failed=()

install_ext() {
  local bin="$1"
  local id="$2"
  if ! command -v "$bin" >/dev/null 2>&1; then
    echo "skip $bin $id (command not found)"
    failed+=("$bin: $id (command not found)")
    return
  fi
  if ! "$bin" --install-extension "$id" >/dev/null; then
    echo "failed $bin --install-extension $id"
    failed+=("$bin: $id")
  fi
}

for id in "${shared[@]}"; do
  install_ext cursor "$id"
  install_ext code "$id"
done

for id in "${cursor_only[@]}"; do
  install_ext cursor "$id"
done

for id in "${code_only[@]}"; do
  install_ext code "$id"
done

if ((${#failed[@]})); then
  echo "Extensions that failed:"
  printf '  %s\n' "${failed[@]}"
fi
