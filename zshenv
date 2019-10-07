export LESS="-R"
export EDITOR=nvim
export FCEDIT=nvim

export LANG="ja_JP.UTF-8"

export HISTFILE=$HOME/.zhistory
export HISTSIZE=100000
export SAVEHIST=100000

export FZF_DEFAULT_OPTS="--height 40% --ansi --cycle --reverse --select-1 --exit-0 --bind=tab:down --bind=btab:up"

export XDG_CONFIG_HOME=$HOME/.config
export NVM_DIR=$XDG_CONFIG_HOME/nvm

export GOPATH=$HOME/.go
export FZFPATH=$HOME/.fzf
export CARGOPATH=$HOME/.cargo

export PATH=/usr/local/sbin:$GOPATH/bin:$CARGOPATH/bin:$FZFPATH/bin${PATH:+:${PATH}}
