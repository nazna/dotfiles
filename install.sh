#!/bin/sh

sudo cp $HOME/.dotfiles/hybrid.theme /usr/share/xfce4/terminal/colorschemes/

ln -is $HOME/.dotfiles/gitconfig $HOME/.gitconfig
ln -is $HOME/.dotfiles/nvimrc $HOME/.config/nvim/init.vim
ln -is $HOME/.dotfiles/nvimrc $HOME/.nvimrc
ln -is $HOME/.dotfiles/zshenv $HOME/.zshenv
ln -is $HOME/.dotfiles/zshrc $HOME/.zshrc
