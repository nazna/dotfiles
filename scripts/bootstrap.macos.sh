#!/usr/bin/env bash

set -eu

function fetch_dotfiles() {
  if [[ ! -e "$HOME/work/ghq/github.com/nazna/dotfiles" ]]; then
    git clone https://github.com/nazna/dotfiles.git "$HOME/work/ghq/github.com/nazna/dotfiles"
  fi
}

function install_xcode_cli() {
  if [[ ! -e "/Library/Developer/CommandLineTools" ]]; then
    sudo xcode-select --install
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
    curl -fsSL https://fnm.vercel.app/install | bash -- --skip-shell
    fnm completions --shell zsh
  fi
}

function install_homebrew() {
  # https://brew.sh/
  if ! type brew > /dev/null 2>&1; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

function install_homebrew_formulae() {
  if type brew > /dev/null 2>&1; then
    brew bundle --file "$HOME/work/ghq/github.com/nazna/dotfiles/Brewfile"
  fi
}

function setup_fonts() {
  # https://www.jetbrains.com/ja-jp/lp/mono/
  if [[ -e "$HOME/Library/Fonts/JetBrainsMono" ]]; then
    curl -sSOL https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip
    unzip -j JetBrainsMono-2.242.zip -d "$HOME/Library/Fonts" "*.ttf"
    rm -f JetBrainsMono-2.242.zip
  fi
}

function setup_shell() {
  # https://github.com/zdharma/zinit
  if ! type zinit > /dev/null 2>&1; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
    chsh "$USER" -s /usr/local/bin/zsh
    chmod 755 /usr/local/share/zsh
    chmod 755 /usr/local/share/zsh/site-functions
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

function remove_garbages() {
  rm -f "$HOME/Applications/.localized" 
  rm -f "$HOME/Desktop/.localized" 
  rm -f "$HOME/Documents/.localized" 
  rm -f "$HOME/Downloads/.localized" 
  rm -f "$HOME/Library/.localized" 
  rm -f "$HOME/Movies/.localized" 
  rm -f "$HOME/Music/.localized" 
  rm -f "$HOME/Pictures/.localized" 
  rm -f "$HOME/Public/.localized"
}

function configure_system_preferences() {
  if [[ ! -e "$HOME/work/ghq/github.com/nazna/dotfiles" ]]; then
    bash "$HOME/workspace/ghq/github.com/nazna/dotfiles/scripts/configure.macos.sh"
  fi
}

fetch_dotfiles
install_xcode_cli
install_rust
install_sdkman
install_nodejs
install_homebrew
install_homebrew_formulae
setup_fonts
setup_shell
setup_vim
deploy_dotfiles
remove_garbages
configure_system_preferences

echo ">>> =========================================================="
echo ">>> 1. reboot"
echo ">>> 2. ssh-keygen -t ed25519"
echo ">>> 3. cat $HOME/.ssh/id_ed25519.pub | pbcopy && open https://github.com/settings/keys"
echo ">>> 4. git remote set-url origin git@github.com:nazna/dotfiles.git"
echo ">>> 5. sdk install java 16.0.2-zulu"
echo ">>> 6. fnm install 16.10.0"
echo ">>> 7. brew install intellij-idea"
echo ">>> 8. Configure system preferences"
echo ">>> 9. Configure Discord, VSCode, iTerm 2, Google Japanese IME and Google Chrome"
echo ">>> =========================================================="
