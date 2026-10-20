# Sourced by Husky before each Git hook.
# GitHub Desktop and other GUI git clients do not load ~/.zshrc, so mise
# activation never runs there. These shims are symlinks to the mise binary,
# so node, npm, and npx resolve without Homebrew on PATH.
if [ -d "$HOME/.local/share/mise/shims" ]; then
  case ":$PATH:" in
    *":$HOME/.local/share/mise/shims:"*) ;;
    *) PATH="$HOME/.local/share/mise/shims:$PATH" ;;
  esac
  export PATH
fi
