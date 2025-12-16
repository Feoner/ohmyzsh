
# ------------------------------------------------------------
# Portable Oh My Zsh template
# Works on macOS and Linux (RHEL, Debian/Ubuntu, etc.)
# Configure variables in the section below; defaults are sensible.
# ------------------------------------------------------------

### ---------------------------------
### User-configurable variables
### ---------------------------------
# Oh My Zsh installation directory
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"

# Theme (set to "random" to pick from ZSH_THEME_RANDOM_CANDIDATES)
export ZSH_THEME="${ZSH_THEME:-jonathan}"
# Uncomment and edit to control random theme candidates
# ZSH_THEME_RANDOM_CANDIDATES=("robbyrussell" "agnoster" "jonathan")

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

# Python user bin (macOS vs Linux)
# macOS typical user site-packages
export PY_USER_BIN_MAC="${PY_USER_BIN_MAC:-$HOME/Library/Python/3.9/bin}"
# Linux typical user local bin
export PY_USER_BIN_LINUX="${PY_USER_BIN_LINUX:-$HOME/.local/bin}"
# Optional Python framework bin on macOS
export PY_FRAMEWORK_BIN_MAC="${PY_FRAMEWORK_BIN_MAC:-/Library/Frameworks/Python.framework/Versions/3.13/bin}"

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
path_append() {
  [ -d "$1" ] || return 0
  case ":$PATH:" in
    *:"$1":*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}

# Homebrew prefix (macOS)
if [ "$OS" = "Darwin" ]; then
  BREW_PREFIX="$(/usr/bin/env brew --prefix 2>/dev/null || echo '/opt/homebrew')"
fi

### ---------------------------------
### Base PATH setup (portable)
### ---------------------------------
# Respect existing PATH first
# Add language/tool paths if present

# Go toolchains
path_add "$GOROOT/bin"
path_add "$GOBIN"

# Python user bin (per OS)
if [ "$OS" = "Darwin" ]; then
  path_add "$PY_USER_BIN_MAC"
  path_add "$PY_FRAMEWORK_BIN_MAC"
  # Homebrew bins
  path_add "${BREW_PREFIX}/bin"
  path_add "${BREW_PREFIX}/sbin"
else
  path_add "$PY_USER_BIN_LINUX"
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

# (Oh My Zsh's completion system will run compinit)
# Ensure highlighting is sourced LAST if installed via package manager
if [ "$OS" = "Darwin" ] && [ -f "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "${BREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ "$OS" = "Darwin" ] && [ -f "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "${BREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Linux fallback for distro packages (if installed)
if [ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
if [ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Final guard: if packages/plugins were cloned into $ZSH_CUSTOM, Oh My Zsh will source them via `plugins=(...)`.

### ---------------------------------
### Optional preferences
### ---------------------------------
# export LANG="en_US.UTF-8"
# export EDITOR="nvim"
# CASE_SENSITIVE="true"        # uncomment for case-sensitive completion
# HYPHEN_INSENSITIVE="true"     # hyphen-insensitive completion
# zstyle ':omz:update' mode auto # auto-update Oh My Zsh
# zstyle ':omz:update' frequency 13

# Example alias file (create if you want)
# [ -f "$ZSH/custom/aliases.zsh" ] && source "$ZSH/custom/aliases.zsh"
``
