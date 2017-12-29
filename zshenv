if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

export EDITOR=nvim
export FCEDIT=nvim
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
export XDG_CONFIG_HOME=$HOME/.config

export GEOMETRY_SYMBOL_PROMPT="▲ "
export GEOMETRY_PROMPT_PLUGINS=(exec_time git node virtualenv)

eval "$(nodenv init -)"
