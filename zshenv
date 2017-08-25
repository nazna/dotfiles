if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

export EDITOR=nvim
export FCEDIT=nvim
export GOPATH=$HOME/.go
export XDG_CONFIG_HOME=$HOME/.config

export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"
