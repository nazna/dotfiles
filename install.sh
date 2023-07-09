#!/usr/bin/env bash

set -eu

# fetch dotfiles
if [[ ! -e "${HOME}/work/ghq/github.com/nazna/dotfiles" ]]; then
  git clone https://github.com/nazna/dotfiles.git "${HOME}/work/ghq/github.com/nazna/dotfiles"
fi

# setup macos
if [[ "${OSTYPE}" == darwin* ]] && [[ ! -e "/Library/Developer/CommandLineTools" ]]; then
  sudo xcode-select --install
fi

# configure macos
if [[ "${OSTYPE}" == darwin* ]]; then
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0
  defaults write com.apple.screencapture location -string "${HOME}/work"
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture disable-shadow -bool true
  defaults write com.apple.screencapture name -string "ss"
  defaults write com.apple.screencapture include-date -bool true
  rm -f "${HOME}/Application/.localized" "${HOME}/Desktop/.localized" "${HOME}/Documents/.localized" "${HOME}/Downloads/.localized"
  rm -f "${HOME}/Library/.localized" "${HOME}/Movies/.localized" "${HOME}/Music/.localized" "${HOME}/Pictures/.localized" "${HOME}/Public/.localized"
fi

# setup linux
if [[ "${OSTYPE}" == linux* ]]; then
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y build-essential language-pack-ja
  sudo cp "${HOME}/work/ghq/github.com/nazna/dotfiles/wsl/wsl.conf" "/etc/wsl.conf"
fi

# deploy dotfiles
if [[ -e "${HOME}/work/ghq/github.com/nazna/dotfiles" ]]; then
  mkdir -p "${HOME}/.config/git"
  mkdir -p "${HOME}/.config/zsh"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/misc/editorconfig" "${HOME}/.editorconfig"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/node/npmrc" "${HOME}/.npmrc"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/vim/vimrc" "${HOME}/.vimrc"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/zsh/zshrc" "${HOME}/.zshrc"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/zsh/alias.zsh" "${HOME}/.config/zsh/alias.zsh"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/zsh/function.zsh" "${HOME}/.config/zsh/function.zsh"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/git/config" "${HOME}/.config/git/config"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/git/ignore" "${HOME}/.config/git/ignore"
  ln -nfs "${HOME}/work/ghq/github.com/nazna/dotfiles/starship/starship.toml" "${HOME}/.config/starship.toml"
fi

# install homebrew
if [[ "${OSTYPE}" == darwin* ]] && ! type brew > /dev/null 2>&1; then
  NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  cat "${HOME}/work/ghq/github.com/nazna/dotfiles/misc/Brewfile.macos" | brew bundle --file=-
elif [[ "${OSTYPE}" == linux* ]] && ! type brew > /dev/null 2>&1; then
  NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  cat "${HOME}/work/ghq/github.com/nazna/dotfiles/misc/Brewfile.wsl" | brew bundle --file=-
fi

# fetch zsh plugins
if [[ ! -e "${HOME}/.config/zsh/plugin" ]]; then
  mkdir -p "${HOME}/.config/zsh/plugin"
  git clone https://github.com/zsh-users/zsh-completions "${HOME}/.config/zsh/plugin/zsh-completions"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.config/zsh/plugin/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "${HOME}/.config/zsh/plugin/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-history-substring-search "${HOME}/.config/zsh/plugin/zsh-history-substring-search"
fi

# fetch fonts
if [[ "${OSTYPE}" == darwin* ]] && [[ ! -e "${HOME}/Library/Fonts/UDEVGothicNF-Regular.ttf" ]]; then
  curl -o udev.zip -sSOL https://github.com/yuru7/udev-gothic/releases/download/v1.3.0/UDEVGothic_v1.3.0.zip
  unzip -j udev.zip -d ./test "UDEVGothic_NF_v1.3.0/UDEVGothicNF-*"
  rm udev.zip
fi

# install rust
if [[ ! -e "${HOME}/.rustup" ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# install node and java
if type rtx > /dev/null 2>&1; then
  rtx install node@latest
  rtx install java@latest
  rtx use -g node@latest
  rtx use -g java@latest
fi

# change default shell
if type zsh > /dev/null 2>&1; then
  which zsh | sudo tee -a /etc/shells
  sudo chsh "${USER}" -s "$(which zsh)"
fi
