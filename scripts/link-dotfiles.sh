set -euo pipefail

is_wsl() {
  if [[ -d /run/WSL ]]; then
    return 1
  else
    return 0
  fi
}

if [[ ! -d "${DOTFILES}" ]]; then
  mkdir -p "${HOME}/.config/git"
  mkdir -p "${HOME}/.config/zsh"
  mkdir -p "${HOME}/.config/mise"

  ln -nfs "${DOTFILES}/git/config" "${HOME}/.config/git/config"
  ln -nfs "${DOTFILES}/git/ignore" "${HOME}/.config/git/ignore"
  ln -nfs "${DOTFILES}/git/attributes" "${HOME}/.config/git/attributes"
  ln -nfs "${DOTFILES}/misc/editorconfig" "${HOME}/.editorconfig"
  ln -nfs "${DOTFILES}/mise/config.toml" "${HOME}/.config/mise/config.toml"
  ln -nfs "${DOTFILES}/nodejs/npmrc" "${HOME}/.npmrc"
  ln -nfs "${DOTFILES}/pi/settings.json" "${HOME}/.pi/agents/settings.json"
  ln -nfs "${DOTFILES}/starship/starship.toml" "${HOME}/.config/starship.toml"
  ln -nfs "${DOTFILES}/vim/vimrc" "${HOME}/.config/vim/vimrc"
  ln -nfs "${DOTFILES}/zsh/zshenv" "${HOME}/.zshenv"
  ln -nfs "${DOTFILES}/zsh/zshrc" "${HOME}/.zshrc"
  ln -nfs "${DOTFILES}/zsh/alias.zsh" "${HOME}/.config/zsh/alias.zsh"
  ln -nfs "${DOTFILES}/zsh/function.zsh" "${HOME}/.config/zsh/function.zsh"

  if is_wsl; then
    ln -nfs "${DOTFILES}/misc/wsl.conf" "/etc/wsl.conf"
    ln -nfs "${DOTFILES}/vscode/settings.json" "${HOME}/.vscode-server/data/Machine/settings.json"
    ln -nfs "${DOTFILES}/vscode/keybindings.json" "${HOME}/.vscode-server/data/Machine/keybindings.json"
  fi
fi

