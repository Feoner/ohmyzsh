
#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_FILE="zshrc.template"
TARGET_ZSHRC="$HOME/.zshrc"
ZSH_DIR="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
THEMES_DIR="$ZSH_CUSTOM/themes"

# Colors
Y="\033[33m"; G="\033[32m"; R="\033[31m"; B="\033[34m"; X="\033[0m"

usage() {
  cat <<EOF
${B}Portable Zsh setup${X}
Usage: $0 [--force] [--no-install]
  --force       Overwrite existing ~/.zshrc
  --no-install  Do not install Oh My Zsh or plugins; only place template
EOF
}

FORCE=0
NOINSTALL=0
while [ "${1:-}" != "" ]; do
  case "$1" in
    --force) FORCE=1 ;;
    --no-install) NOINSTALL=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo -e "${R}Unknown option: $1${X}"; usage; exit 1 ;;
  esac
  shift || true
done

OS="$(uname -s)"

# Install Oh My Zsh if missing
install_omz() {
  if [ -d "$ZSH_DIR" ]; then
    echo -e "${G}Oh My Zsh already present at $ZSH_DIR${X}"
    return
  fi
  echo -e "${Y}Installing Oh My Zsh...${X}"
  if command -v curl >/dev/null 2>&1; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
  elif command -v wget >/dev/null 2>&1; then
    sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
  else
    echo -e "${R}Neither curl nor wget found. Install one and re-run.${X}"; exit 1
  fi
}

# Clone plugin if missing
ensure_plugin() {
  local name="$1" url="$2"
  mkdir -p "$PLUGINS_DIR"
  if [ -d "$PLUGINS_DIR/$name" ]; then
    echo -e "${G}Plugin '$name' already present${X}"
  else
    echo -e "${Y}Installing plugin '$name'...${X}"
    git clone --depth=1 "$url" "$PLUGINS_DIR/$name"
  fi
}

# Clone theme if missing
ensure_theme() {
  local name="$1" url="$2"
  mkdir -p "$THEMES_DIR"
  if [ -d "$THEMES_DIR/$name" ]; then
    echo -e "${G}Theme '$name' already present${X}"
  else
    echo -e "${Y}Installing theme '$name'...${X}"
    git clone --depth=1 "$url" "$THEMES_DIR/$name"
  fi
}

# Install plugins and Powerlevel10k theme
install_components() {
  ensure_plugin zsh-autosuggestions https://github.com/zsh-users/zsh-autosuggestions
  ensure_plugin zsh-syntax-highlighting https://github.com/zsh-users/zsh-syntax-highlighting
  ensure_plugin zsh-completions https://github.com/zsh-users/zsh-completions
  ensure_theme powerlevel10k https://github.com/romkatv/powerlevel10k.git
}

# Place template
place_template() {
  if [ -f "$TARGET_ZSHRC" ] && [ "$FORCE" -ne 1 ]; then
    cp "$TARGET_ZSHRC" "$TARGET_ZSHRC.bak.$(date +%Y%m%d%H%M%S)"
    echo -e "${Y}Backed up existing ~/.zshrc. Use --force to overwrite without backup.${X}"
  fi
  cp "$TEMPLATE_FILE" "$TARGET_ZSHRC"
  echo -e "${G}Wrote template to $TARGET_ZSHRC${X}"
}

# Main
if [ "$NOINSTALL" -ne 1 ]; then
  install_omz
  install_components
else
  echo -e "${Y}Skipping Oh My Zsh & plugin/theme installation (--no-install).${X}"
fi
place_template

# Inform user to reload
cat <<EOM
${B}Next steps:${X}
  1) Make zsh your default shell if not already:
     chsh -s "$(command -v zsh)"
  2) Start a new shell or run: ${G}source ~/.zshrc${X}
  3) Run the Powerlevel10k wizard: ${G}p10k configure${X} (creates ~/.p10k.zsh)
  4) Verify plugins with the provided script: ${G}./verify_zsh_plugins.sh${X}
EOM
``

