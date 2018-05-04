#!/bin/sh

if [ "$(uname)" != 'Darwin' ]; then
  sudo cp $HOME/.dotfiles/themes/hybrid.theme /usr/share/xfce4/terminal/colorschemes/
  sudo cp $HOME/.dotfiles/themes/onedark.theme /usr/share/xfce4/terminal/colorschemes/
fi

ln -nfs $HOME/.ghq/github.com/naoya3e/.dotfiles/gitconfig $HOME/.gitconfig
ln -nfs $HOME/.ghq/github.com/naoya3e/.dotfiles/globalignore $HOME/.globalignore
ln -nfs $HOME/.ghq/github.com/naoya3e/.dotfiles/latexmkrc $HOME/.latexmkrc
ln -nfs $HOME/.ghq/github.com/naoya3e/.dotfiles/nvimrc $HOME/.config/nvim/init.vim
ln -nfs $HOME/.ghq/github.com/naoya3e/.dotfiles/nvimrc $HOME/.nvimrc
ln -nfs $HOME/.ghq/github.com/naoya3e/.dotfiles/zshenv $HOME/.zshenv
ln -nfs $HOME/.ghq/github.com/naoya3e/.dotfiles/zshrc $HOME/.zshrc
