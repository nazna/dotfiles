export LESS="-R"
export EDITOR=nvim
export FCEDIT=nvim
export LANG="ja_JP.UTF-8"
export HISTFILE=$HOME/.zhistory
export HISTSIZE=100000
export SAVEHIST=100000
export FZF_DEFAULT_OPTS="--height 40% --ansi --reverse --preview-window down:1"

export BREW_INSTALLED=/usr/local/opt

export XDG_CONFIG_HOME=$HOME/.config
export ZPLUG_HOME=$BREW_INSTALLED/zplug

export GOPATH=$HOME/.go
export FZFPATH=$HOME/.fzf
export NVMPATH=$HOME/.nvm
export CARGOPATH=$HOME/.cargo

export PATH=$GOPATH/bin:$CARGOPATH/bin:$FZFPATH/bin${PATH:+:${PATH}}
