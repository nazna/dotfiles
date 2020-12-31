#!/usr/bin/env sh

set -eu

if [ -e "$HOME/workspace/ghq/github.com/nazna/dotfiles" ]; then
  echo >&2 "[ERROR] Exit bootstrapping because dotfiles already exist."
  exit 1
fi

# fetch dotfiles
mkdir -p $HOME/workspace/ghq/github.com/nazna
git clone https://github.com/nazna/dotfiles.git $HOME/workspace/ghq/github.com/nazna/dotfiles

# install xcode
if [ ! -e "/Library/Developer/CommandLineTools" ]; then
  sudo xcode-select --install
fi

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
export PATH="$HOME/.cargo/bin:$PATH"

# install homebrew formulae
brew bundle --file $HOME/workspace/ghq/github.com/nazna/dotfiles/Brewfile

# install nodejs
volta install node@latest

# configure shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
chsh $USER -s /usr/local/bin/zsh
chmod 755 /usr/local/share/zsh/site-functions
chmod 755 /usr/local/share/zsh

# configure shell font
mkdir -p $HOME/.fonts
curl -L -o $HOME/Cica.zip https://github.com/miiton/Cica/releases/download/v5.0.2/Cica_v5.0.2_with_emoji.zip
unzip -d $HOME/Library/Fonts $HOME/Cica.zip "*.ttf"
rm $HOME/Cica.zip

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

# configure finder
sudo rm -f /Applications/.localized $HOME/Applications/.localized $HOME/Desktop/.localized $HOME/Documents/.localized $HOME/Downloads/.localized $HOME/Library/.localized $HOME/Movies/.localized $HOME/Music/.localized $HOME/Pictures/.localized $HOME/Public/.localized

# configure system preferences on macos
$HOME/workspace/ghq/github.com/nazna/dotfiles/scripts/configure.macos.sh

echo ">>> ========================================"
echo ">>> 1. reboot"
echo ">>> 2. change remote origin to ssh"
echo ">>> 3. confirm vim, vscode, iterm2 and chrome settings"
echo ">>> 4. configure system preferences"
echo ">>> 4. add ssh key for github"
echo ">>> ========================================"
