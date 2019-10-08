#!/usr/bin/env bash

set -eu

if [ -e "$HOME/dotfiles-master" ] || [ -e "$HOME/workspace/ghq/github.com/naoya3e/dotfiles" ]; then
  echo >&2 "Quit because dotfiles already exist."
  exit 1
fi

curl -L https://github.com/naoya3e/dotfiles/archive/master.zip -o $HOME/dotfiles.zip
unzip $HOME/dotfiles.zip
rm $HOME/dotfiles.zip
cd $HOME/dotfiles-master

if ! builtin command -v brew > /dev/null 2>&1; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo
fi

brew bundle
echo

scripts/configure.sh
echo

scripts/initialize.sh
echo

scripts/deploy.sh
echo

rm -rf $HOME/dotfiles-master

echo "==============================================="
echo
echo "All automatic configuration was done :)"
echo
echo "Please setup the rest of the System Preferences while checking Dropbox Paper."
echo "Next, configure Launchpad, Finder, Amphetamine and VSCode."
echo
echo "==============================================="
