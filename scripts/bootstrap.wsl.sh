#!/usr/bin/env bash

set -eu

function pre_setup() {
  sudo apt update -y
  sudo apt upgrade -y
  sudo apt install -y build-essential pkg-config libssl-dev zip unzip
}

function fetch_dotfiles() {
  if [[ ! -e "$HOME/work/ghq/github.com/nazna/dotfiles" ]]; then
    git clone https://github.com/nazna/dotfiles.git "$HOME/work/ghq/github.com/nazna/dotfiles"
  fi
}

function install_rust() {
  # https://www.rust-lang.org/
  if ! type rustup > /dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  fi
}

function install_sdkman() {
  # https://sdkman.io/
  if ! type sdk > /dev/null 2>&1; then
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
  fi
}

function install_nodejs() {
  # https://github.com/Schniz/fnm
  if ! type fnm > /dev/null 2>&1; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  fi
}

function install_homebrew() {
  # https://brew.sh/
  if ! type brew > /dev/null 2>&1; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

function install_homebrew_formulae() {
  if type brew > /dev/null 2>&1; then
    brew install curl exa fzf ghq git jq nkf starship tree vim youtube-dl zsh
  fi
}

function setup_shell() {
  # https://github.com/zdharma/zinit
  if ! type zinit > /dev/null 2>&1; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
    chsh "$USER" -s "$(which zsh)"
  fi
}

function setup_vim() {
  if [[ -e "$HOME/.vim/colors/hybrid_material.vim" ]]; then
    mkdir -p "$HOME/.vim/colors"
    curl -o "$HOME/.vim/colors/hybrid_material.vim" https://raw.githubusercontent.com/kristijanhusak/vim-hybrid-material/master/colors/hybrid_material.vim
    git clone https://github.com/editorconfig/editorconfig-vim.git "$HOME/.vim/pack/plugins/start/editorconfig-vim"
    git clone https://github.com/cohama/lexima.vim.git "$HOME/.vim/pack/plugins/start/lexima"
    git clone https://github.com/itchyny/lightline.vim.git "$HOME/.vim/pack/plugins/start/lightline"
    git clone https://github.com/cocopon/lightline-hybrid.vim.git "$HOME/.vim/pack/plugins/start/lightline-hybrid"
  fi
}

function deploy_dotfiles() {
  mkdir -p "$HOME/.config/git"
  ln -nfs "$HOME/work/ghq/github.com/nazna/dotfiles/editorconfig" "$HOME/.editorconfig"
  ln -nfs "$HOME/work/ghq/github.com/nazna/dotfiles/gitconfig" "$HOME/.gitconfig"
  ln -nfs "$HOME/work/ghq/github.com/nazna/dotfiles/gitignore" "$HOME/.config/git/ignore"
  ln -nfs "$HOME/work/ghq/github.com/nazna/dotfiles/npmrc" "$HOME/.npmrc"
  ln -nfs "$HOME/work/ghq/github.com/nazna/dotfiles/starship.toml" "$HOME/.config/starship.toml"
  ln -nfs "$HOME/work/ghq/github.com/nazna/dotfiles/vimrc" "$HOME/.vimrc"
  ln -nfs "$HOME/work/ghq/github.com/nazna/dotfiles/zshrc" "$HOME/.zshrc"
}

pre_setup
fetch_dotfiles
install_rust
install_sdkman
install_nodejs
install_homebrew
install_homebrew_formulae
setup_shell
setup_vim
deploy_dotfiles

echo ">>> ========================================"
echo ">>> 1. reboot"
echo ">>> 2. ssh-keygen -t ed25519"
echo ">>> 3. cat $HOME/.ssh/id_ed25519.pub | pbcopy && open https://github.com/settings/keys"
echo ">>> 4. git remote set-url origin git@github.com:nazna/dotfiles.git"
echo ">>> 5. sdk install java 16.0.2-zulu"
echo ">>> 6. fnm install 16.10.0"
echo ">>> 9. Configure VSCode"
echo ">>> ========================================"
