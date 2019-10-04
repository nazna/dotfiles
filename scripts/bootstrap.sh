#!/usr/bin/env bash

set -eu

DOTPATH=$HOME/.dotfiles

echo "Bootstrapping..."

if [ ! -d "$DOTPATH" ]; then
  git clone https://github.com/naoya3e/dotfiles
else
  echo "$DOTPATH already exist. Updateing..."
  cd "$DOTPATH"
  git stash --include-untracked
  git checkout master
  git pull --rebase --prune origin master
fi

cd "$DOTPATH"

scripts/configure.sh
echo

if ! command -v brew >/dev/null 2>&1; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo
fi

brew bundle
echo

scripts/deploy.sh
echo

echo "All green, Done :)"

