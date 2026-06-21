#!/usr/bin/env bash

set -euo pipefail

DOTFILES="${HOME}/ghq/github.com/nazna/dotfiles"

# setup directories
mkdir -p "${HOME}/work"
mkdir -p "${HOME}/sandbox"

# fetch dotfiles
git clone https://github.com/nazna/dotfiles "${DOTFILES}"
cd ${DOTFILES} && git remote set-url origin git@github.com:nazna/dotfiles.git && cd -

# install system packages
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential language-pack-ja bubblewrap

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
cat "${DOTFILES}/misc/Brewfile" | brew bundle --file=-

source ./scripts/link-dotfiles.sh
source ./scripts/install-zsh-plugins.sh

# install Antigravity
curl -fsSL https://antigravity.google/cli/install.sh | bash

# change login shell
which zsh | sudo tee -a /etc/shells
chsh -s "$(which zsh)"
