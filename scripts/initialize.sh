#!/usr/bin/env bash

set -eu

mkdir $HOME/.fonts
mkdir -p $HOME/.cache/dein
mkdir -p $HOME/.config/nvim

rm $HOME/Applications/.localized $HOME/Desktop/.localized $HOME/Documents/.localized $HOME/Downloads/.localized $HOME/Library/.localized $HOME/Movies/.localized $HOME/Music/.localized $HOME/Pictures/.localized $HOME/Public/.localized

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.cache/dein
rm ./installer.sh

sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s /usr/local/bin/zsh

echo "Generating ssh key..."
ssh-keygen -t ed25519
cat $HOME/.ssh/id_ed25519.pub | pbcopy

echo "Configuring node.js environment..."
nvm install node
npm install -g commitizen cz-conventional-changelog
echo '{ "path": "cz-conventional-changelog" }' > ~/.czrc
