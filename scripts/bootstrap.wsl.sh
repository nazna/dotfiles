#!/usr/bin/env bash

set -eu

function pre_setup() {
  if [[ ! -e "$HOME/work/ghq/github.com/nazna/dotfiles" ]]; then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y build-essential procps pkg-config libssl-dev zip unzip
  fi
}

function fetch_dotfiles() {
  if [[ ! -e "$HOME/work/ghq/github.com/nazna/dotfiles" ]]; then
    git clone https://github.com/nazna/dotfiles.git "$HOME/work/ghq/github.com/nazna/dotfiles"
  fi
}

function install_rust() {
  # https://www.rust-lang.org/
  if [[ ! -e "$HOME/.rustup" ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
  fi
}

function install_sdkman() {
  # https://sdkman.io/
  if [[ ! -e "$HOME/.sdkman" ]]; then
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
  fi
}

function install_nodejs() {
  # https://github.com/Schniz/fnm
  if [[ ! -e "$HOME/.fnm" ]]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  fi
}

function install_homebrew() {
  # https://brew.sh/
  if [[ ! -e "/home/linuxbrew/.linuxbrew" ]]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

function install_homebrew_formulae() {
  if [[ ! -e "/home/linuxbrew/.linuxbrew/bin/starship" ]]; then
    brew install curl exa fzf ghq git jq nkf starship tree vim youtube-dl zsh
  fi
}

function setup_vim() {
  if [[ ! -e "$HOME/.vim/colors" ]]; then
    mkdir -p "$HOME/.vim/colors"
    curl https://raw.githubusercontent.com/kristijanhusak/vim-hybrid-material/HEAD/colors/hybrid_material.vim > "$HOME/.vim/colors/hybrid_material.vim"
    git clone https://github.com/editorconfig/editorconfig-vim.git "$HOME/.vim/pack/plugins/start/editorconfig-vim"
    git clone https://github.com/cohama/lexima.vim.git "$HOME/.vim/pack/plugins/start/lexima"
    git clone https://github.com/itchyny/lightline.vim.git "$HOME/.vim/pack/plugins/start/lightline"
    git clone https://github.com/cocopon/lightline-hybrid.vim.git "$HOME/.vim/pack/plugins/start/lightline-hybrid"
  fi
}

function setup_zsh() {
  if [[ ! -e "$HOME/.config/zsh" ]]; then
    mkdir -p "$HOME/.config/zsh"
    git clone https://github.com/zsh-users/zsh-completions "$HOME/.config/zsh/zsh-completions"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.config/zsh/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.config/zsh/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-history-substring-search "$HOME/.config/zsh/zsh-history-substring-search"
    which zsh | sudo tee -a /etc/shells
    sudo chsh "$USER" -s "$(which zsh)"
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
setup_vim
setup_zsh
deploy_dotfiles

echo ">>> ========================================"
echo ">>> 1. reboot"
echo ">>> 2. ssh-keygen -t ed25519"
echo ">>> 3. cat $HOME/.ssh/id_ed25519.pub | pbcopy"
echo ">>> 4. git remote set-url origin git@github.com:nazna/dotfiles.git"
echo ">>> 5. sdk install java 17.0.1-zulu"
echo ">>> 6. fnm install --lts"
echo ">>> 9. Configure VSCode"
echo ">>> ========================================"
