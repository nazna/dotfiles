#!/usr/bin/env bash

set -eu

mkdir $HOME/.fonts
mkdir -p $HOME/.cache/dein
mkdir -p $HOME/.config/nvm
mkdir -p $HOME/.config/nvim

rm $HOME/Applications/.localized $HOME/Desktop/.localized $HOME/Documents/.localized $HOME/Downloads/.localized $HOME/Library/.localized $HOME/Movies/.localized $HOME/Music/.localized $HOME/Pictures/.localized $HOME/Public/.localized

rm /Applications/.localized

curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.cache/dein
rm ./installer.sh

sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s /usr/local/bin/zsh

echo
echo "Exec 'code' once, then check VSCode security status on Preferences > Security and Privacy > General"
read -p "Are you ready? (Hit enter key)"
code --install-extension Shan.code-settings-sync

NVM_DIR=$HOME/.config/nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
nvm install node
npm install -g commitizen cz-conventional-changelog neovim prettier npm-check-updates

ssh-keygen -t ed25519
cat $HOME/.ssh/id_ed25519.pub | pbcopy

echo
echo "Copied your generated SSH key to clipboard."
echo "Google Chrome is opening..."
echo "Register the key on GitHub :)"
echo
open -a "Google Chrome" https://github.com/settings/keys
read -p "Are you ready? (Hit enter key)"

cp ./gitconfig $HOME/.gitconfig
ghq get git@github.com:naoya3e/dotfiles.git
rm $HOME/.gitconfig
