if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

export EDITOR=nvim
export FCEDIT=nvim
export PAGER=less
export SHELL=zsh
export XDG_CONFIG_HOME=$HOME/.config
export PATH="/Users/naoya/anaconda/bin:$PATH"
