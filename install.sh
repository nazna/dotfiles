#!/usr/bin/env bash

set -euo pipefail

is_wsl() {
  if [[ -d /run/WSL ]]; then
    return 1
  else
    return 0
  fi
}

DOTFILES="${HOME}/work/github.com/nazna/dotfiles"
XDG_CONFIG_HOME="${HOME}/.config"

# setup directories
mkdir -p "${HOME}/work"
mkdir -p "${HOME}/sandbox"

# fetch dotfiles
git clone https://github.com/nazna/dotfiles "${DOTFILES}"
cd "${DOTFILES}" && git remote set-url origin git@github.com:nazna/dotfiles.git && cd -

# install system packages
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential language-pack-ja
sudo apt install -y bubblewrap curl ffmpeg imagemagick nkf sqlite3 unzip vim wget zip zsh

# install mise
curl https://mise.run | sh
eval "$(${HOME}/.local/bin/mise activate bash)"
mise trust "${DOTFILES}/mise/config.toml"
mise install --yes

# link dotfiles
ln -nfs "${DOTFILES}/misc/editorconfig" "${HOME}/.editorconfig"
ln -nfs "${DOTFILES}/nodejs/npmrc" "${HOME}/.npmrc"

mkdir -p "${XDG_CONFIG_HOME}/git"
ln -nfs "${DOTFILES}/git/config" "${XDG_CONFIG_HOME}/git/config"
ln -nfs "${DOTFILES}/git/ignore" "${XDG_CONFIG_HOME}/git/ignore"
ln -nfs "${DOTFILES}/git/attributes" "${XDG_CONFIG_HOME}/git/attributes"

mkdir -p "${XDG_CONFIG_HOME}/vim"
ln -nfs "${DOTFILES}/vim/vimrc" "${XDG_CONFIG_HOME}/vim/vimrc"

mkdir -p "${XDG_CONFIG_HOME}/zsh"
ln -nfs "${DOTFILES}/zsh/zshrc" "${HOME}/.zshrc"
ln -nfs "${DOTFILES}/zsh/alias.zsh" "${XDG_CONFIG_HOME}/zsh/alias.zsh"
ln -nfs "${DOTFILES}/zsh/function.zsh" "${XDG_CONFIG_HOME}/zsh/function.zsh"
ln -nfs "${DOTFILES}/starship/starship.toml" "${XDG_CONFIG_HOME}/starship.toml"

mkdir -p "${XDG_CONFIG_HOME}/mise"
ln -nfs "${DOTFILES}/mise/config.toml" "${XDG_CONFIG_HOME}/mise/config.toml"

mkdir -p "${HOME}/.pi/agent"
ln -nfs "${DOTFILES}/pi/settings.json" "${HOME}/.pi/agent/settings.json"

if is_wsl; then
  ln -nfs "${DOTFILES}/misc/wsl.conf" /etc/wsl.conf
fi

# fetch zsh plugins
git clone --depth=1 https://github.com/zsh-users/zsh-completions "${XDG_CONFIG_HOME}/zsh/completions"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${XDG_CONFIG_HOME}/zsh/autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "${XDG_CONFIG_HOME}/zsh/syntax-highlighting"

# change login shell
which zsh | sudo tee -a /etc/shells
sudo chsh "${USER}" -s "$(which zsh)"
