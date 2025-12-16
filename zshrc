
# ------------------------------------------------------------
# Portable Oh My Zsh template with Powerlevel10k
# Works on macOS and Linux (RHEL, Debian/Ubuntu, etc.)
# Configure variables in the section below; defaults are sensible.
# ------------------------------------------------------------

### ---------------------------------
### User-configurable variables
### ---------------------------------
# Oh My Zsh installation directory
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"

# Theme: default to powerlevel10k; override by exporting ZSH_THEME before sourcing
export ZSH_THEME="${ZSH_THEME:-powerlevel10k/powerlevel10k}"
# Uncomment and edit to control random theme candidates (only used if ZSH_THEME=random)
# ZSH_THEME_RANDOM_CANDIDATES=("robbyrussell" "agnoster" "jonathan" "powerlevel10k/powerlevel10k")

# Plugins to load (Oh My Zsh will source these automatically if present)
plugins=(
  git
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Autosuggestions style
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:-fg=23}"

# Go configuration (auto-detected if `go` is on PATH)
export GOPATH="${GOPATH:-$HOME/go}"
export GOROOT="${GOROOT:-/usr/local/go}"
# GOBIN defaults to $GOPATH/bin
export GOBIN="${GOBIN:-$GOPATH/bin}"

### ---------------------------------
### Powerlevel10k Instant Prompt (recommended)
### ---------------------------------
# Should stay close to the top of ~/.zshrc. Any init code that may require
# console input (password prompts, [y/n] confirmations, etc.) must go ABOVE this block.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### ---------------------------------
### OS detection and PATH helpers
### ---------------------------------
OS="$(uname -s)"

# Helper: add to PATH if the directory exists and is not already present
path_add() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *:"$1":*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

# Homebrew prefix (macOS)
if [ "$OS" = "Darwin" ]; then
  BREW_PREFIX="$(/usr/bin/env brew --prefix 2>/dev/null || echo '/opt/homebrew')"
fi

### ---------------------------------
### Flexible PATH setup (portable)
### ---------------------------------
# Respect existing PATH first. Add language/tool paths if present.

# Go toolchains
path_add "$GOROOT/bin"
path_add "$GOBIN"

# Python: flexible detection
if [ "$OS" = "Darwin" ]; then
  # macOS: pick up all user site-packages bins under ~/Library/Python/*/bin
  for pybin in "$HOME"/Library/Python/*/bin; do
    [ -d "$pybin" ] && path_add "$pybin"
  done
  # macOS: optional Python framework bins under /Library/Frameworks/Python.framework/Versions/*/bin
  for fwbin in /Library/Frameworks/Python.framework/Versions/*/bin; do
    [ -d "$fwbin" ] && path_add "$fwbin"
  done
  # Homebrew bins
  path_add "${BREW_PREFIX}/bin"
  path_add "${BREW_PREFIX}/sbin"
else
  # Linux: pip --user installs to ~/.local/bin
  path_add "$HOME/.local/bin"
fi

# Common local and system locations (only if they exist)
for p in \
  "/usr/local/bin" \
  "/usr/local/sbin" \
  "$HOME/bin" \
  "$HOME/.local/bin" \
  "/usr/bin" \
  "/bin" \
  "/usr/sbin" \
  "/sbin"; do
  path_add "$p"
done

### ---------------------------------
### Oh My Zsh boot
### ---------------------------------
export ZSH
source "$ZSH/oh-my-zsh.sh"

# Ensure highlighting is sourced LAST if installed via package manager
if [ "$OS" = "Darwin" ] && [ -f "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ "$OS" = "Darwin" ] && [ -f "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Linux fallbacks for distro packages (if installed)
if [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Load Powerlevel10k user config if present (created by `p10k configure`)
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

### ---------------------------------
### Optional preferences
### ---------------------------------
# export LANG="en_US.UTF-8"
# CASE_SENSITIVE="true"        # uncomment for case-sensitive completion
# HYPHEN_INSENSITIVE="true"     # hyphen-insensitive completion
# zstyle ':omz:update' mode auto # auto-update Oh My Zsh
# zstyle ':omz:update' frequency 13

# Example alias file (create if you want)
# [ -f "$ZSH/custom/aliases.zsh" ] && source "$ZSH/custom/aliases.zsh"

