#!/usr/bin/env bash

set -euo pipefail

source "${BASH_SOURCE[0]%/*}/zsh/common.zsh"

DOTFILES="${HOME}/work/github.com/nazna/dotfiles"
XDG_CONFIG_HOME="${HOME}/.config"

# setup directories
mkdir -p "${HOME}/work"
mkdir -p "${HOME}/sandbox"

# fetch dotfiles
git clone https://github.com/nazna/dotfiles "${DOTFILES}"
cd "${DOTFILES}" && git remote set-url origin git@github.com:nazna/dotfiles.git && cd -

# install system packages
if is_wsl; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y build-essential language-pack-ja
  sudo apt install -y bubblewrap curl ffmpeg imagemagick nkf sqlite3 unzip vim wget zip zsh
fi

# link dotfiles
mkdir -p "${XDG_CONFIG_HOME}/ghostty"
ln -nfs "${DOTFILES}/ghostty/config" "${XDG_CONFIG_HOME}/ghostty/config"

mkdir -p "${XDG_CONFIG_HOME}/git"
ln -nfs "${DOTFILES}/git/config" "${XDG_CONFIG_HOME}/git/config"
ln -nfs "${DOTFILES}/git/ignore" "${XDG_CONFIG_HOME}/git/ignore"
ln -nfs "${DOTFILES}/git/attributes" "${XDG_CONFIG_HOME}/git/attributes"

if is_hyprland; then
  ln -nfs "${DOTFILES}/hypr/input.lua" "${XDG_CONFIG_HOME}/hypr/input.lua"
fi

ln -nfs "${DOTFILES}/misc/editorconfig" "${HOME}/.editorconfig"

if is_wsl; then
  ln -nfs "${DOTFILES}/misc/wsl.conf" /etc/wsl.conf
fi

mkdir -p "${XDG_CONFIG_HOME}/mise"
ln -nfs "${DOTFILES}/mise/config.toml" "${XDG_CONFIG_HOME}/mise/config.toml"

ln -nfs "${DOTFILES}/nodejs/npmrc" "${HOME}/.npmrc"

if is_omarchy; then
  mkdir -p "${XDG_CONFIG_HOME}/omarchy/plugins/us-japanese.ime"
  ln -nfs "${DOTFILES}/omarchy/shell.json" "${XDG_CONFIG_HOME}/omarchy/shell.json"
  ln -nfs "${DOTFILES}/omarchy/plugins/us-japanese.ime/Ime.qml" "${XDG_CONFIG_HOME}/omarchy/plugins/us-japanese.ime/Ime.qml"
  ln -nfs "${DOTFILES}/omarchy/plugins/us-japanese.ime/manifest.json" "${XDG_CONFIG_HOME}/omarchy/plugins/us-japanese.ime/manifest.json"
fi

mkdir -p "${HOME}/.pi/agent/extensions" "${HOME}/.pi/agent/skills/cdp"
ln -nfs "${DOTFILES}/pi/agent/AGENTS.md" "${HOME}/.pi/agent/AGENTS.md"
ln -nfs "${DOTFILES}/pi/agent/keybindings.json" "${HOME}/.pi/agent/keybindings.json"
ln -nfs "${DOTFILES}/pi/agent/settings.json" "${HOME}/.pi/agent/settings.json"
ln -nfs "${DOTFILES}/pi/agent/extensions/openrouter-server-tools.ts" "${HOME}/.pi/agent/extensions/openrouter-server-tools.ts"
ln -nfs "${DOTFILES}/pi/agent/skills/cdp/SKILL.md" "${HOME}/.pi/agent/skills/cdp/SKILL.md"

ln -nfs "${DOTFILES}/starship/starship.toml" "${XDG_CONFIG_HOME}/starship.toml"

mkdir -p "${XDG_CONFIG_HOME}/vim"
ln -nfs "${DOTFILES}/vim/vimrc" "${XDG_CONFIG_HOME}/vim/vimrc"

# TODO: vscode

mkdir -p "${XDG_CONFIG_HOME}/zed"
ln -nfs "${DOTFILES}/zed/settings.json" "${XDG_CONFIG_HOME}/zed/settings.json"
ln -nfs "${DOTFILES}/zed/keymap.json" "${XDG_CONFIG_HOME}/zed/keymap.json"

mkdir -p "${XDG_CONFIG_HOME}/zsh"
ln -nfs "${DOTFILES}/zsh/zshrc" "${HOME}/.zshrc"
ln -nfs "${DOTFILES}/zsh/common.zsh" "${XDG_CONFIG_HOME}/zsh/common.zsh"
ln -nfs "${DOTFILES}/zsh/alias.zsh" "${XDG_CONFIG_HOME}/zsh/alias.zsh"
ln -nfs "${DOTFILES}/zsh/function.zsh" "${XDG_CONFIG_HOME}/zsh/function.zsh"

# fetch zsh plugins
git clone --depth=1 https://github.com/zsh-users/zsh-completions "${XDG_CONFIG_HOME}/zsh/completions"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${XDG_CONFIG_HOME}/zsh/autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "${XDG_CONFIG_HOME}/zsh/syntax-highlighting"

# install mise
curl https://mise.run | sh
eval "$(${HOME}/.local/bin/mise activate bash)"
mise trust "${DOTFILES}/mise/config.toml"
mise install --yes

# change login shell
which zsh | sudo tee -a /etc/shells
sudo chsh "${USER}" -s "$(which zsh)"
