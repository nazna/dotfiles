#!/usr/bin/env bash

set -eu

ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/editorconfig $HOME/.editorconfig
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/gitconfig $HOME/.gitconfig
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/globalgitignore $HOME/.globalgitignore
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/hyper.js $HOME/.hyper.js
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/latexmkrc $HOME/.latexmkrc
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/npmrc $HOME/.npmrc
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/vimrc $HOME/.config/nvim/init.vim
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/zshenv $HOME/.zshenv
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/zshrc $HOME/.zshrc
ln -nfs $HOME/workspace/ghq/github.com/naoya3e/dotfiles/editorconfig $HOME/.editorconfig

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.cache/dein

sudo echo "/usr/local/bin/zsh" >> /etc/shells
chsh -s /usr/local/bin/zsh
