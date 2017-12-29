# install Homebrew
/usr/bin/ruby -e "$(curl -fsSL )"

# install homebrew packages
brew update
brew install python3 nodenv youtube-dl neovim
brew cask install iina

# install ethereum
brew tap ethereum/ethereum
brew install ethereum

# install rust language
curl https://sh.rustup.rs -sSf | sh

# install cargo packages
cargo install --no-default-features exa

# setup neovim
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh $HOME/.vim/bundles
