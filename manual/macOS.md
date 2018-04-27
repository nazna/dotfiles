# install Homebrew
/usr/bin/ruby -e "$(curl -fsSL )"

# download Google Chrome
open https://www.google.co.jp/chrome/browser/desktop/index.html

# install homebrew packages
brew update
brew install python2 python3 youtube-dl
brew cask install iina

# install rust language
curl https://sh.rustup.rs -sSf | sh

# install cargo packages
cargo install --no-default-features exa

# setup neovim
pip2 install --upgrade pip
pip3 install --upgrade pip
pip2 install --upgrade neovim
pip3 install --upgrade neovim flake8
mkdir -p $HOME/.vim/bundles
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.vim/bundles

# download iTerm2
open https://www.iterm2.com/downloads.html

# create directories
mkdir -p $HOME/.fonts $HOME/.icons $HOME/.config/nvim

# install fonts
curl -L https://github.com/miiton/Cica/releases/download/v2.1.0/Cica_v2.1.0.zip -o $HOME/Cica.zip
unzip Cica.zip -d $HOME/.fonts/Cica
rm $HOME/Cica.zip

# generate ssh key
ssh-keygen -t ed25519
cat $HOME/.ssh/id_ed25519.pub | pbcopy

# setup zsh configure
git clone git@github.com:naoya3e/.dotfiles.git && cd .dotfiles
sh ./install.sh

# setup latex packages
brew install ghostscript
brew cask install basictex
pip install pygments
sudo tlmgr install collection-langjapanese latexmk here multirow collection-fontsrecommended graphicx

# install node packages
npm install -g doctoc
