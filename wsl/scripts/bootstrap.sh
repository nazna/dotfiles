#!/usr/bin/env sh

set -eu

if [ -e "$HOME/workspace/ghq/github.com/nazna/dotfiles" ]; then
  echo >&2 "Quit bootstrap because dotfiles already exist."
  exit 1
fi

echo ">>> Instal apt packages"
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential

echo ">>> Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo ">>> Activate linuxbrew for temporarily"
PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

echo ">>> Fetch dotfiles"
mkdir -p $HOME/workspace/ghq/github.com/nazna
git clone https://github.com/nazna/dotfiles.git $HOME/workspace/ghq/github.com/nazna/dotfiles

echo ">>> Install Homebrew Formulae"
brew bundle --file $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/Brewfile

echo ">>> Link dotfiles"
mkdir -p $HOME/.config
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/editorconfig $HOME/.editorconfig
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/gitconfig $HOME/.gitconfig
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/globalgitignore $HOME/.globalgitignore
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/npmrc $HOME/.npmrc
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/starship.toml $HOME/.config/starship.toml
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/vimrc $HOME/.vimrc
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/zshenv $HOME/.zshenv
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/zshrc $HOME/.zshrc

echo ">>> Install Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo ">>> Install Volta"
curl https://get.volta.sh | bash -s -- --skip-setup
PATH=$HOME/.volta/in:$PATH

echo ">>> Install Node.js"
volta install node@latest

echo ">>> Configure iTerm2"
sudo echo $(which zsh) >> /etc/shells
chsh -s $(which zsh)

echo ">>> Configure Vim"
mkdir -p $HOME/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.cache/dein
rm ./installer.sh

echo ">>> ==================================================="
echo ">>>  Done!"
echo ">>>  Next, setup System Preferences,"
echo ">>>    Vim, Google Chrome, VSCode and SSH."
echo ">>>  Please reboot this to meet awesome computer :)"
echo ">>> ==================================================="
