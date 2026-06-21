#!/bin/bash

set -euo pipefail

DOTFILES="${HOME}/ghq/github.com/nazna/dotfiles"

is_wsl() {
  if [[ -d /run/WSL ]]; then
    return 1
  else
    return 0
  fi
}

# Fetch dotfiles
if [[ ! -d "${DOTFILES}" ]]; then
  git clone https://github.com/nazna/dotfiles "${DOTFILES}"
fi

# Install system packages
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential language-pack-ja

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

source ./scripts/link-dotfiles.sh
source ./scripts/install-zsh-plugins.sh

# Install Antigravity
curl -fsSL https://antigravity.google/cli/install.sh | bash

# Change login shell
if type zsh > /dev/null 2>&1; then
  which zsh | sudo tee -a /etc/shells
  sudo chsh "${USER}" -s "$(which zsh)"
fi
