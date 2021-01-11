#!/usr/bin/env sh

set -eu

if [ -e "$HOME/workspace/ghq/github.com/nazna/dotfiles" ]; then
  echo >&2 "[ERROR] Exit bootstrapping because dotfiles already exist."
  exit 1
fi

# pre-setup
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential pkg-config libssl-dev

# fetch dotfiles
mkdir -p $HOME/workspace/ghq/github.com/nazna
git clone https://github.com/nazna/dotfiles.git $HOME/workspace/ghq/github.com/nazna/dotfiles

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH="$HOME/.cargo/bin:$PATH"

# install homebrew formulae
brew install curl
brew install exa
brew install fzf
brew install ghq
brew install git
brew install jq
brew install starship
brew install tree
brew install vim
brew install volta
brew install youtube-dl
brew install zsh

# install nodejs
volta install node@latest
volta setup

# configure shell
echo $(which zsh) | sudo tee -a /etc/shells
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
sudo chsh $USER -s $(which zsh)

# configure vim
mkdir -p $HOME/.vim/colors
curl -o $HOME/hybrid_material.vim https://raw.githubusercontent.com/kristijanhusak/vim-hybrid-material/master/colors/hybrid_material.vim
mv $HOME/hybrid_material.vim $HOME/.vim/colors
git clone https://github.com/editorconfig/editorconfig-vim.git $HOME/.vim/pack/plugins/start/editorconfig-vim
git clone https://github.com/cohama/lexima.vim.git $HOME/.vim/pack/plugins/start/lexima
git clone https://github.com/itchyny/lightline.vim.git $HOME/.vim/pack/plugins/start/lightline
git clone https://github.com/cocopon/lightline-hybrid.vim.git $HOME/.vim/pack/plugins/start/lightline-hybrid

# deploy dotfiles
mkdir -p $HOME/.config
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/editorconfig $HOME/.editorconfig
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/gitconfig $HOME/.gitconfig
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/globalgitignore $HOME/.globalgitignore
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/npmrc $HOME/.npmrc
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/starship.toml $HOME/.config/starship.toml
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/vimrc $HOME/.vimrc
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/zshenv $HOME/.zshenv
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/zshrc $HOME/.zshrc


echo ">>> ========================================"
echo ">>> 1. reboot"
echo ">>> 2. change remote origin to ssh"
echo ">>> 3. confirm vim, vscode and chrome settings"
echo ">>> 4. configure system preferences"
echo ">>> 4. add ssh key for github"
echo ">>> ========================================"
