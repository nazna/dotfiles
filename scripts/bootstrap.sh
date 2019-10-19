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

xcode-select --install

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
echo "Automatic configuration was all done :)"
echo
echo "Next, setup System Preferences, Finder, Launchpad, Amphetamine, Google Chrome and VSCode."
echo "For VSCode, download settings from my gist by Setting-Sync."
echo "Press cmd+shift+p and type 'download setting'."
echo
echo "==============================================="
