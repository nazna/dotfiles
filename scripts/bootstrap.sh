#!/usr/bin/env bash

set -eu

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

echo "All automatic configuration was done :)"
echo
echo "Remove this directory for bootstraping. True dotfiles are deployed."
echo "Run the following command `cd $HOME && rm -rf dotfiles-master`"
echo
echo "Please setup the rest of the System Preferences while checking Dropbox Paper."
echo "Next, setup Launcher, Finder, f.lux, Amphetamine and VSCode."
