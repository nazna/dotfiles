#!/usr/bin/env bash

set -eu

mkdir $HOME/.fonts
mkdir -p $HOME/.cache/dein
mkdir -p $HOME/.config/nvim

ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/editorconfig $HOME/.editorconfig
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/gitconfig $HOME/.gitconfig
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/globalgitignore $HOME/.globalgitignore
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/hyper.js $HOME/.hyper.js
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/latexmkrc $HOME/.latexmkrc
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/npmrc $HOME/.npmrc
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/nvimrc $HOME/.config/nvim/init.vim
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/zshenv $HOME/.zshenv
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/zshrc $HOME/.zshrc
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/editorconfig $HOME/.editorconfig

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.cache/dein
rm ./installer.sh

sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s /usr/local/bin/zsh

echo "Generating ssh key..."
ssh-keygen -t ed25519
cat $HOME/.ssh/id_ed25519.pub | pbcopy
