#!/usr/bin/env bash

set -eu

# fetch dotfiles
if [[ ! -e "${HOME}/work/ghq/github.com/nazna/dotfiles" ]]; then
  git clone https://github.com/nazna/dotfiles.git "${HOME}/work/ghq/github.com/nazna/dotfiles"
fi

# deploy dotfiles
if [[ -e "${HOME}/work/ghq/github.com/nazna/dotfiles" ]]; then
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/editorconfig" "${HOME}/.editorconfig"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/node/npmrc" "${HOME}/.npmrc"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/vim/vimrc" "${HOME}/.vimrc"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/zsh/zshrc" "${HOME}/.zshrc"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/zsh/alias.zsh" "${HOME}/.config/zsh/alias.zsh"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/zsh/function.zsh" "${HOME}/.config/zsh/function.zsh"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/git/config" "${HOME}/.config/git/config"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/git/ignore" "${HOME}/.config/git/ignore"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/starship/starship.toml" "${HOME}/.config/starship.toml"
fi

# setup macos
if [[ "${OSTYPE}" == darwin* ]] && [[ ! -e "/Library/Developer/CommandLineTools" ]]; then
  sudo xcode-select --install
fi

# configure macos
if [[ "${OSTYPE}" == darwin* ]]; then
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0
  defaults write com.apple.screencapture location -string "${HOME}/Downloads"
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture disable-shadow -bool true
  defaults write com.apple.screencapture name -string "ss"
  defaults write com.apple.screencapture include-date -bool true
  /bin/rm -f "${HOME}/Application/.localized" "${HOME}/Desktop/.localized" "${HOME}/Documents/.localized" "${HOME}/Downloads/.localized"
  /bin/rm -f "${HOME}/Library/.localized" "${HOME}/Movies/.localized" "${HOME}/Music/.localized" "${HOME}/Pictures/.localized" "${HOME}/Public/.localized"
fi

# setup linux
if [[ "${OSTYPE}" == linux* ]]; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y build-essential sqlite3 unzip zip
  sudo cp "${HOME}/work/ghq/github.com/nazna/dotfiles/wsl/wsl.conf" "/etc/wsl.conf"
fi

# install homebrew
if [[ ! -e "/usr/local/bin/brew" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew bundle --file "${HOME}/work/ghq/github/com/nazna/dotfiles/Brewfile"
fi

# fetch zsh plugins
if [[ ! -e "${HOME}/.config/zsh/plugin" ]]; then
  mkdir -p "${HOME}/.config/zsh/plugin"
  git clone https://github.com/zsh-users/zsh-completions "${HOME}/.config/zsh/plugin/zsh-completions"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.config/zsh/plugin/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "${HOME}/.config/zsh/plugin/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-history-substring-search "${HOME}/.config/zsh/plugin/zsh-history-substring-search"
fi

# fetch vim plugins
if [[ ! -e "${HOME}/.vim/colors" ]]; then
  mkdir -p "${HOME}/.vim/colors"
  curl https://raw.githubusercontent.com/kristijanhusak/vim-hybrid-material/HEAD/colors/hybrid_material.vim > "${HOME}/.vim/colors/hybrid_material.vim"
  git clone https://github.com/editorconfig/editorconfig-vim.git "${HOME}/.vim/pack/plugins/start/editorconfig-vim"
  git clone https://github.com/cohama/lexima.vim.git "${HOME}/.vim/pack/plugins/start/lexima"
  git clone https://github.com/itchyny/lightline.vim.git "${HOME}/.vim/pack/plugins/start/lightline"
  git clone https://github.com/cocopon/lightline-hybrid.vim.git "${HOME}/.vim/pack/plugins/start/lightline-hybrid"
  git clone https://github.com/arcticicestudio/nord-vim.git "${HOME}/.vim/pack/plugins/start/nord"
fi

# change default shell
if ! command -v zsh > /dev/null; then
  which zsh | sudo tee -a /etc/shells
  sudo chsh "${USER}" -s "$(which zsh)"
fi

# install node and java
if ! command -v rtx > /dev/null; then
  rtx install node@latest
  rtx install java@laetst
fi

# install rust
if [[ ! -e "${HOME}/.rustup" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
