if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

export EDITOR=nvim
export FCEDIT=nvim
export GOPATH=$HOME/.go
export PATH=$PATH:$GOPATH/bin
export XDG_CONFIG_HOME=$HOME/.config

export GEOMETRY_COLOR_PACKAGER_VERSION="green"
export GEOMETRY_PROMPT_PLUGINS=(exec_time git node virtualenv)
export GEOMETRY_SYMBOL_GIT_DIRTY=${GEOMETRY_SYMBOL_GIT_DIRTY:-"⬡ "}
export GEOMETRY_SYMBOL_GIT_CLEAN=${GEOMETRY_SYMBOL_GIT_CLEAN:-"⬢ "}
export GEOMETRY_SYMBOL_GIT_BARE=${GEOMETRY_SYMBOL_GIT_BARE:-"⬢ "}
export GEOMETRY_SYMBOL_NODE_NPM_VERSION="⬡ "
export GEOMETRY_SYMBOL_PROMPT="▲ "

eval "$(nodenv init -)"
