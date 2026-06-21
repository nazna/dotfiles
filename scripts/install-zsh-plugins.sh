set -euo pipefail

if [[ ! -d "${HOME}/.config/zsh/plugins" ]]; then
  mkdir -p "${HOME}/.config/zsh/plugins"

  git clone https://github.com/zsh-users/zsh-completions "${HOME}/.config/zsh/plugins/zsh-completions"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.config/zsh/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "${HOME}/.config/zsh/plugins/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-history-substring-search "${HOME}/.config/zsh/plugins/zsh-history-substring-search"
fi
