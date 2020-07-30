#!/usr/bin/env sh

set -eu

if [ -e "$HOME/workspace/ghq/github.com/nazna/dotfiles" ]; then
  echo >&2 "Quit bootstrap because dotfiles already exist."
  exit 1
fi

if ! builtin command -v xcode-select --print-path > /dev/null; then
  echo ">>> Install Xcode components"
  xcode-select --install
fi

if ! builtin command -v brew > /dev/null; then
  echo ">>> Install Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo ">>> Fetch dotfiles"
mkdir -p $HOME/workspace/ghq/github.com/nazna
git clone https://github.com/nazna/dotfiles.git $HOME/workspace/ghq/github.com/nazna/dotfiles

echo ">>> Install Homebrew Formulae"
brew bundle --file $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/Brewfile

echo ">>> Install Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo ">>> Install Node.js"
volta install node@latest

echo ">>> Link dotfiles"
mkdir -p $HOME/.config
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/editorconfig $HOME/.editorconfig
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/gitconfig $HOME/.gitconfig
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/globalgitignore $HOME/.globalgitignore
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/npmrc $HOME/.npmrc
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/starship.toml $HOME/.config/starship.toml
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/vimrc $HOME/.vimrc
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/zshenv $HOME/.zshenv
ln -nfs $HOME/workspace/ghq/github.com/nazna/dotfiles/macos/zshrc $HOME/.zshrc

echo ">>> Configure iTerm2"
mkdir -p $HOME/.fonts
curl -L -o Cica.zip https://github.com/miiton/Cica/releases/download/v5.0.1/Cica_v5.0.1_with_emoji.zip
unzip -d $HOME/Library/Fonts ./Cica.zip "*.ttf"
rm ./Cica.zip

sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
chsh -s /usr/local/bin/zsh

chmod 755 /usr/local/share/zsh/site-functions
chmod 755 /usr/local/share/zsh

echo ">>> Configure Vim"
mkdir -p $HOME/.cache/dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.cache/dein
rm ./installer.sh

echo ">>> Configure VSCode"
code --install-extension Shan.code-settings-sync

echo ">>> Configure macOS system settings"
sudo rm -f /Applications/.localized $HOME/Applications/.localized $HOME/Desktop/.localized $HOME/Documents/.localized $HOME/Downloads/.localized $HOME/Library/.localized $HOME/Movies/.localized $HOME/Music/.localized $HOME/Pictures/.localized $HOME/Public/.localized
$HOME/workspace/ghq/github.com/nazna/dotfiles/macos/scripts/configure.sh

echo ">>> ==================================================="
echo ">>>  Done!"
echo ">>>  Next, setup System Preferences, Finder, Launchpad,"
echo ">>>    Vim, Google Chrome, VSCode and SSH."
echo ">>>  Please reboot this to meet awesome computer :)"
echo ">>> ==================================================="
