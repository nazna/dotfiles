#!/usr/bin/env bash

set -eu

if [ -e "$HOME/dotfiles-master" ] || [ -e "$HOME/workspace/ghq/github.com/naoya3e/dotfiles" ]; then
  echo >&2 "Quit because dotfiles already exist."
  exit 1
fi

echo "Bootstrapping..."

curl -L https://github.com/naoya3e/dotfiles/archive/master.zip -o dotfiles.zip
unzip dotfiles.zip
rm dotfiles.zip
cd dotfiles-master

if ! command -v brew >/dev/null 2>&1; then
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

echo "==============================================="
echo
echo "All automatic configuration was done :)"
echo
echo "Remove this directory for bootstraping. Real dotfiles are deployed."
echo "Run the following command `rm -rf $HOME/dotfiles-master && rm $HOME/.bash_history`"
echo
echo "Please setup the rest of the System Preferences while checking Dropbox Paper."
echo "Next, setup Launcher, Finder, f.lux, Amphetamine and VSCode."
echo
echo "==============================================="
