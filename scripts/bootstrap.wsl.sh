#!/usr/bin/env sh

set -eu

if [ -e "$HOME/workspace/ghq/github.com/nazna/dotfiles" ]; then
  echo >&2 "[ERROR] Exit bootstrapping because dotfiles already exist."
  exit 1
fi

# pre-setup
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y patch build-essential zsh locales-all

# fetch dotfiles
mkdir -p $HOME/workspace/ghq/github.com/nazna
git clone https://github.com/nazna/dotfiles.git $HOME/workspace/ghq/github.com/nazna/dotfiles

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH="$HOME/.cargo/bin:$PATH"

# install nodejs (volta on homebrew is broken)
curl https://get.volta.sh | bash -s -- --skip-setup
export PATH="$HOME/.volta/bin:$PATH"
volta install node@latest

# install homebrew formulae
brew bundle --file $HOME/workspace/ghq/github.com/nazna/dotfiles/Brewfile.wsl

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

# configure shell
echo $(which zsh) | sudo tee -a /etc/shells
chsh $USER -s $(which zsh)

# configure vim
mkdir -p $HOME/.cache/dein
pip3 install pynvim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > $HOME/installer.sh
sh $HOME/installer.sh $HOME/.cache/dein
rm $HOME/installer.sh

echo ">>> ========================================"
echo ">>> 1. reboot"
echo ">>> 2. change remote origin to ssh"
echo ">>> 3. confirm vim, vscode and chrome settings"
echo ">>> 4. configure system preferences"
echo ">>> 4. add ssh key for github"
echo ">>> ========================================"
