#!/usr/bin/env sh

set -eu

if [ -e "$HOME/workspace/ghq/github.com/nazna/dotfiles" ]; then
  echo >&2 "Quit bootstrap because dotfiles already exist."
  exit 1
fi

echo ">>> Instal apt packages"
sudo apt update -y
sudo apt install -y build-essential

if ! builtin command -v brew > /dev/null; then
  echo ">>> Install Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo ">>> Activate linuxbrew for temporarily"
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

echo ">>> Install Homebrew Formulae"
brew bundle --file $HOME/workspace/ghq/github.com/nazna/dotfiles/wsl/Brewfile

echo ">>> Fetch dotfiles"
mkdir -p $HOME/workspace/ghq/github.com/nazna
git clone https://github.com/nazna/dotfiles.git $HOME/workspace/ghq/github.com/nazna/dotfiles

echo ">>> Install Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo ">>> Install Node.js"
volta install node@latest

echo ">>> Link dotfiles"
mkdir -p $HOME/.config
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/editorconfig $HOME/.editorconfig
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/gitconfig $HOME/.gitconfig
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/globalgitignore $HOME/.globalgitignore
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/npmrc $HOME/.npmrc
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/starship.toml $HOME/.config/starship.toml
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/vimrc $HOME/.vimrc
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/zshenv $HOME/.zshenv
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/zshrc $HOME/.zshrc

echo ">>> Configure iTerm2"
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
